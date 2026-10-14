#include "driver.h"

// ──────────────────────────────────────────────
// kernel read via MmCopyVirtualMemory
// no handle opens, no NtReadVirtualMemory — AC blind
// ──────────────────────────────────────────────

NTSTATUS read_kernel_memory(ULONG pid, ULONGLONG address, PVOID buffer, ULONG size) {
    PEPROCESS process = NULL;
    NTSTATUS status = PsLookupProcessByProcessId((HANDLE)(ULONG_PTR)pid, &process);
    if (!NT_SUCCESS(status)) return status;

    SIZE_T bytes_copied = 0;
    status = MmCopyVirtualMemory(
        process,
        (PVOID)address,
        PsGetCurrentProcess(),
        buffer,
        size,
        KernelMode,
        &bytes_copied
    );

    ObDereferenceObject(process);
    return status;
}

// ──────────────────────────────────────────────
// physical memory read fallback — maps phys pages
// used when virtual read is hooked or paged out
// ──────────────────────────────────────────────

NTSTATUS read_physical_memory(ULONGLONG phys_address, PVOID buffer, ULONG size) {
    if (!buffer || size == 0) return STATUS_INVALID_PARAMETER;

    PHYSICAL_ADDRESS addr;
    addr.QuadPart = (LONGLONG)phys_address;

    PVOID mapped = MmMapIoSpace(addr, size, MmNonCached);
    if (!mapped) return STATUS_UNSUCCESSFUL;

    __try {
        RtlCopyMemory(buffer, mapped, size);
    } __except (EXCEPTION_EXECUTE_HANDLER) {
        MmUnmapIoSpace(mapped, size);
        return STATUS_ACCESS_VIOLATION;
    }

    MmUnmapIoSpace(mapped, size);
    return STATUS_SUCCESS;
}

// ──────────────────────────────────────────────
// virtual-to-physical translation
// walks the page table manually — no API calls to hook
// ──────────────────────────────────────────────

#define PML4_SHIFT 39
#define PDPT_SHIFT 30
#define PD_SHIFT   21
#define PT_SHIFT   12
#define ENTRY_MASK 0x1FF
#define PAGE_PRESENT 1
#define PAGE_LARGE   0x80

NTSTATUS translate_virtual_to_physical(ULONGLONG directory_base, ULONGLONG virtual_addr,
                                        ULONGLONG* phys_out) {
    if (!phys_out) return STATUS_INVALID_PARAMETER;

    ULONGLONG pml4_idx  = (virtual_addr >> PML4_SHIFT) & ENTRY_MASK;
    ULONGLONG pdpt_idx  = (virtual_addr >> PDPT_SHIFT) & ENTRY_MASK;
    ULONGLONG pd_idx    = (virtual_addr >> PD_SHIFT)   & ENTRY_MASK;
    ULONGLONG pt_idx    = (virtual_addr >> PT_SHIFT)    & ENTRY_MASK;

    ULONGLONG entry = 0;

    // PML4
    NTSTATUS status = read_physical_memory(
        directory_base + pml4_idx * sizeof(ULONGLONG), &entry, sizeof(entry));
    if (!NT_SUCCESS(status) || !(entry & PAGE_PRESENT)) return STATUS_NOT_FOUND;

    // PDPT
    ULONGLONG pdpt_base = (entry & 0x000FFFFFFFFFF000ULL);
    status = read_physical_memory(
        pdpt_base + pdpt_idx * sizeof(ULONGLONG), &entry, sizeof(entry));
    if (!NT_SUCCESS(status) || !(entry & PAGE_PRESENT)) return STATUS_NOT_FOUND;

    // 1GB page
    if (entry & PAGE_LARGE) {
        *phys_out = (entry & 0x000FFFFFC0000000ULL) + (virtual_addr & 0x3FFFFFFFULL);
        return STATUS_SUCCESS;
    }

    // PD
    ULONGLONG pd_base = (entry & 0x000FFFFFFFFFF000ULL);
    status = read_physical_memory(
        pd_base + pd_idx * sizeof(ULONGLONG), &entry, sizeof(entry));
    if (!NT_SUCCESS(status) || !(entry & PAGE_PRESENT)) return STATUS_NOT_FOUND;

    // 2MB page
    if (entry & PAGE_LARGE) {
        *phys_out = (entry & 0x000FFFFFFFE00000ULL) + (virtual_addr & 0x1FFFFFULL);
        return STATUS_SUCCESS;
    }

    // PT
    ULONGLONG pt_base = (entry & 0x000FFFFFFFFFF000ULL);
    status = read_physical_memory(
        pt_base + pt_idx * sizeof(ULONGLONG), &entry, sizeof(entry));
    if (!NT_SUCCESS(status) || !(entry & PAGE_PRESENT)) return STATUS_NOT_FOUND;

    // 4KB page
    *phys_out = (entry & 0x000FFFFFFFFFF000ULL) + (virtual_addr & 0xFFFULL);
    return STATUS_SUCCESS;
}
