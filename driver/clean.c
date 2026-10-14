#include "driver.h"

// ──────────────────────────────────────────────
// PiDDB cache cleanup
// removes driver entry from the kernel's loaded-driver database
// prevents tools from seeing the driver was ever loaded
// ──────────────────────────────────────────────

typedef struct _PIDDB_CACHE_ENTRY {
    LIST_ENTRY List;
    UNICODE_STRING DriverName;
    ULONG TimeDateStamp;
    NTSTATUS LoadStatus;
    char _pad[16];
} PIDDB_CACHE_ENTRY;

// pattern scan ntoskrnl for PiDDBCacheTable
static PVOID find_pattern(PVOID base, ULONG size, const UCHAR* pattern,
                          const char* mask, ULONG pat_len) {
    PUCHAR start = (PUCHAR)base;
    for (ULONG i = 0; i <= size - pat_len; ++i) {
        BOOLEAN found = TRUE;
        for (ULONG j = 0; j < pat_len; ++j) {
            if (mask[j] == 'x' && start[i + j] != pattern[j]) {
                found = FALSE;
                break;
            }
        }
        if (found) return &start[i];
    }
    return NULL;
}

void clean_piddb_cache() {
    // FILL: sig scan for PiDDBCacheTable + PiDDBLock in ntoskrnl
    // varies per Windows build — use your dumper to get the globals
    // structure: RTL_AVL_TABLE at PiDDBCacheTable, locked by PiDDBLock (ERESOURCE)
    //
    // walk: acquire PiDDBLock exclusive, iterate cache entries,
    //       remove any whose DriverName matches ours, release lock
    //
    // skeleton:
    //   ExAcquireResourceExclusiveLite(PiDDBLock, TRUE);
    //   for each entry in cache:
    //     if RtlCompareUnicodeString(&entry->DriverName, &our_name, TRUE) == 0:
    //       RemoveEntryList(&entry->List);
    //       RtlFreeUnicodeString(&entry->DriverName);  // if allocated
    //   ExReleaseResourceLite(PiDDBLock);
    //
    // without the scanned addresses this is a stub — fill after dumping your build
    DbgPrint("[r6drv] piddb clean: stub — fill sigs for your ntoskrnl build\n");
}

// ──────────────────────────────────────────────
// MmUnloadedDrivers cleanup
// the kernel keeps a circular buffer of the last 50 unloaded drivers
// zeroing our entry prevents forensic "what driver was here" queries
// ──────────────────────────────────────────────

typedef struct _MM_UNLOADED_DRIVER {
    UNICODE_STRING Name;
    PVOID ModuleStart;
    PVOID ModuleEnd;
    LARGE_INTEGER UnloadTime;
} MM_UNLOADED_DRIVER, *PMM_UNLOADED_DRIVER;

void clean_unloaded_drivers(const UNICODE_STRING* driver_name) {
    // FILL: resolve MmUnloadedDrivers and MmLastUnloadedDriver from ntoskrnl
    // these are unexported globals — sig scan or hardcode per build
    //
    // skeleton:
    //   PMM_UNLOADED_DRIVER* MmUnloadedDrivers = <scanned>;
    //   PULONG MmLastUnloadedDriver = <scanned>;
    //   for (ULONG i = 0; i < 50; i++) {
    //       if ((*MmUnloadedDrivers)[i].Name.Buffer &&
    //           RtlCompareUnicodeString(&(*MmUnloadedDrivers)[i].Name, driver_name, TRUE) == 0) {
    //           RtlFreeUnicodeString(&(*MmUnloadedDrivers)[i].Name);
    //           RtlZeroMemory(&(*MmUnloadedDrivers)[i], sizeof(MM_UNLOADED_DRIVER));
    //       }
    //   }
    UNREFERENCED_PARAMETER(driver_name);
    DbgPrint("[r6drv] unloaded drivers clean: stub — fill sigs for your ntoskrnl build\n");
}
