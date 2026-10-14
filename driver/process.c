#include "driver.h"

// ──────────────────────────────────────────────
// find PID by name — walks active process list
// no user32 dependency, no snapshots
// ──────────────────────────────────────────────

NTSTATUS find_process_id(const WCHAR* name, ULONG* pid_out) {
    if (!name || !pid_out) return STATUS_INVALID_PARAMETER;

    // SystemProcessInformation = 5
    ULONG buf_size = 0;
    NTSTATUS status = ZwQuerySystemInformation(5, NULL, 0, &buf_size);
    if (buf_size == 0) return STATUS_UNSUCCESSFUL;

    buf_size += 0x1000; // padding for race
    PVOID buffer = ExAllocatePool2(POOL_FLAG_NON_PAGED, buf_size, DRIVER_TAG);
    if (!buffer) return STATUS_INSUFFICIENT_RESOURCES;

    status = ZwQuerySystemInformation(5, buffer, buf_size, &buf_size);
    if (!NT_SUCCESS(status)) {
        ExFreePoolWithTag(buffer, DRIVER_TAG);
        return status;
    }

    typedef struct _SYSTEM_PROCESS_INFORMATION {
        ULONG NextEntryOffset;
        ULONG NumberOfThreads;
        LARGE_INTEGER Reserved[3];
        LARGE_INTEGER CreateTime;
        LARGE_INTEGER UserTime;
        LARGE_INTEGER KernelTime;
        UNICODE_STRING ImageName;
        KPRIORITY BasePriority;
        HANDLE UniqueProcessId;
        // truncated — we only need the above
    } SPI, *PSPI;

    PSPI entry = (PSPI)buffer;
    UNICODE_STRING target;
    RtlInitUnicodeString(&target, name);

    status = STATUS_NOT_FOUND;
    for (;;) {
        if (entry->ImageName.Buffer &&
            RtlCompareUnicodeString(&entry->ImageName, &target, TRUE) == 0) {
            *pid_out = (ULONG)(ULONG_PTR)entry->UniqueProcessId;
            status = STATUS_SUCCESS;
            break;
        }
        if (entry->NextEntryOffset == 0) break;
        entry = (PSPI)((PUCHAR)entry + entry->NextEntryOffset);
    }

    ExFreePoolWithTag(buffer, DRIVER_TAG);
    return status;
}

// ──────────────────────────────────────────────
// get module base from PEB — kernel-side ldr walk
// ──────────────────────────────────────────────

typedef struct _PEB_LDR_DATA_K {
    ULONG Length;
    BOOLEAN Initialized;
    PVOID SsHandle;
    LIST_ENTRY InLoadOrderModuleList;
} PEB_LDR_DATA_K;

typedef struct _LDR_DATA_TABLE_ENTRY_K {
    LIST_ENTRY InLoadOrderLinks;
    LIST_ENTRY InMemoryOrderLinks;
    LIST_ENTRY InInitializationOrderLinks;
    PVOID DllBase;
    PVOID EntryPoint;
    ULONG SizeOfImage;
    UNICODE_STRING FullDllName;
    UNICODE_STRING BaseDllName;
} LDR_DATA_TABLE_ENTRY_K;

NTSTATUS get_process_module(ULONG pid, const WCHAR* module_name,
                            ULONGLONG* base, ULONG* mod_size) {
    if (!module_name || !base || !mod_size)
        return STATUS_INVALID_PARAMETER;

    PEPROCESS process = NULL;
    NTSTATUS status = PsLookupProcessByProcessId((HANDLE)(ULONG_PTR)pid, &process);
    if (!NT_SUCCESS(status)) return status;

    PPEB peb = PsGetProcessPeb(process);
    if (!peb) {
        ObDereferenceObject(process);
        return STATUS_NOT_FOUND;
    }

    // attach to target process to read its PEB
    KAPC_STATE apc;
    KeStackAttachProcess(process, &apc);

    __try {
        PEB_LDR_DATA_K* ldr = NULL;
        SIZE_T bytes = 0;

        // read Ldr pointer from PEB (offset 0x18 on x64)
        PVOID ldr_ptr = *(PVOID*)((PUCHAR)peb + 0x18);
        if (!ldr_ptr) {
            status = STATUS_NOT_FOUND;
            __leave;
        }
        ldr = (PEB_LDR_DATA_K*)ldr_ptr;

        UNICODE_STRING target;
        RtlInitUnicodeString(&target, module_name);

        LIST_ENTRY* head = &ldr->InLoadOrderModuleList;
        LIST_ENTRY* current = head->Flink;

        status = STATUS_NOT_FOUND;
        while (current != head) {
            LDR_DATA_TABLE_ENTRY_K* entry =
                CONTAINING_RECORD(current, LDR_DATA_TABLE_ENTRY_K, InLoadOrderLinks);

            if (entry->BaseDllName.Buffer &&
                RtlCompareUnicodeString(&entry->BaseDllName, &target, TRUE) == 0) {
                *base = (ULONGLONG)entry->DllBase;
                *mod_size = entry->SizeOfImage;
                status = STATUS_SUCCESS;
                break;
            }

            current = current->Flink;
        }
    } __except (EXCEPTION_EXECUTE_HANDLER) {
        status = STATUS_ACCESS_VIOLATION;
    }

    KeUnstackDetachProcess(&apc);
    ObDereferenceObject(process);
    return status;
}
