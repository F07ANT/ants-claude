#pragma once
#include <ntddk.h>
#include <ntifs.h>
#include <windef.h>

#define DRIVER_TAG 'r6xd'

// ntoskrnl imports not in headers
extern "C" {

NTKERNELAPI NTSTATUS MmCopyVirtualMemory(
    PEPROCESS SourceProcess,
    PVOID SourceAddress,
    PEPROCESS TargetProcess,
    PVOID TargetAddress,
    SIZE_T BufferSize,
    KPROCESSOR_MODE PreviousMode,
    PSIZE_T ReturnSize
);

NTKERNELAPI PVOID PsGetProcessSectionBaseAddress(PEPROCESS Process);

NTKERNELAPI PPEB PsGetProcessPeb(PEPROCESS Process);

NTKERNELAPI NTSTATUS ZwQuerySystemInformation(
    ULONG SystemInformationClass,
    PVOID SystemInformation,
    ULONG SystemInformationLength,
    PULONG ReturnLength
);

}

// forward decls
NTSTATUS read_kernel_memory(ULONG pid, ULONGLONG address, PVOID buffer, ULONG size);
NTSTATUS get_process_module(ULONG pid, const WCHAR* module_name,
                            ULONGLONG* base, ULONG* mod_size);
NTSTATUS find_process_id(const WCHAR* name, ULONG* pid_out);
void clean_piddb_cache();
void clean_unloaded_drivers(const UNICODE_STRING* driver_name);
