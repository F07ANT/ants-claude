#pragma once

#ifdef _WIN32
#ifndef CTL_CODE
#include <winioctl.h>
#endif
#endif

#define R6DRV_DEVICE_TYPE 0x8000

#define IOCTL_R6_READ_MEMORY    CTL_CODE(R6DRV_DEVICE_TYPE, 0x800, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_R6_GET_MODULE     CTL_CODE(R6DRV_DEVICE_TYPE, 0x801, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_R6_GET_PID        CTL_CODE(R6DRV_DEVICE_TYPE, 0x802, METHOD_BUFFERED, FILE_ANY_ACCESS)
#define IOCTL_R6_HEARTBEAT      CTL_CODE(R6DRV_DEVICE_TYPE, 0x803, METHOD_BUFFERED, FILE_ANY_ACCESS)

#pragma pack(push, 1)

typedef struct _R6_READ_REQUEST {
    ULONG pid;
    ULONGLONG address;
    ULONGLONG buffer;       // usermode destination pointer
    ULONG size;
} R6_READ_REQUEST, *PR6_READ_REQUEST;

typedef struct _R6_MODULE_REQUEST {
    ULONG pid;
    WCHAR module_name[64];
    ULONGLONG base_address; // out
    ULONG module_size;      // out
} R6_MODULE_REQUEST, *PR6_MODULE_REQUEST;

typedef struct _R6_PID_REQUEST {
    WCHAR process_name[64];
    ULONG pid;              // out
} R6_PID_REQUEST, *PR6_PID_REQUEST;

typedef struct _R6_HEARTBEAT {
    ULONG magic;            // 0xDEAD1337
    ULONG status;           // out: 1 = alive
} R6_HEARTBEAT, *PR6_HEARTBEAT;

#pragma pack(pop)
