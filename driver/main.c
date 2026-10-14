#include "driver.h"
#include "../include/shared/ioctls.h"

#define DEVICE_NAME     L"\\Device\\r6drv"
#define SYMLINK_NAME    L"\\DosDevices\\r6drv"

static PDEVICE_OBJECT g_device = NULL;
static UNICODE_STRING g_device_name;
static UNICODE_STRING g_symlink;

// ──────────────────────────────────────────────
// dispatch
// ──────────────────────────────────────────────

static NTSTATUS dispatch_ioctl(PDEVICE_OBJECT device, PIRP irp) {
    UNREFERENCED_PARAMETER(device);

    PIO_STACK_LOCATION stack = IoGetCurrentIrpStackLocation(irp);
    ULONG code = stack->Parameters.DeviceIoControl.IoControlCode;
    ULONG in_len = stack->Parameters.DeviceIoControl.InputBufferLength;
    PVOID buffer = irp->AssociatedIrp.SystemBuffer;
    NTSTATUS status = STATUS_INVALID_PARAMETER;
    ULONG info = 0;

    switch (code) {

    case IOCTL_R6_READ_MEMORY: {
        if (in_len < sizeof(R6_READ_REQUEST)) break;
        PR6_READ_REQUEST req = (PR6_READ_REQUEST)buffer;

        if (req->size == 0 || req->size > 0x1000000) break; // 16MB cap

        status = read_kernel_memory(
            req->pid,
            req->address,
            (PVOID)req->buffer,
            req->size
        );
        info = sizeof(R6_READ_REQUEST);
        break;
    }

    case IOCTL_R6_GET_MODULE: {
        if (in_len < sizeof(R6_MODULE_REQUEST)) break;
        PR6_MODULE_REQUEST req = (PR6_MODULE_REQUEST)buffer;
        req->module_name[63] = L'\0';

        status = get_process_module(
            req->pid,
            req->module_name,
            &req->base_address,
            &req->module_size
        );
        info = sizeof(R6_MODULE_REQUEST);
        break;
    }

    case IOCTL_R6_GET_PID: {
        if (in_len < sizeof(R6_PID_REQUEST)) break;
        PR6_PID_REQUEST req = (PR6_PID_REQUEST)buffer;
        req->process_name[63] = L'\0';

        status = find_process_id(req->process_name, &req->pid);
        info = sizeof(R6_PID_REQUEST);
        break;
    }

    case IOCTL_R6_HEARTBEAT: {
        if (in_len < sizeof(R6_HEARTBEAT)) break;
        PR6_HEARTBEAT req = (PR6_HEARTBEAT)buffer;
        if (req->magic == 0xDEAD1337) {
            req->status = 1;
            status = STATUS_SUCCESS;
        }
        info = sizeof(R6_HEARTBEAT);
        break;
    }

    default:
        status = STATUS_INVALID_DEVICE_REQUEST;
        break;
    }

    irp->IoStatus.Status = status;
    irp->IoStatus.Information = NT_SUCCESS(status) ? info : 0;
    IoCompleteRequest(irp, IO_NO_INCREMENT);
    return status;
}

static NTSTATUS dispatch_create_close(PDEVICE_OBJECT device, PIRP irp) {
    UNREFERENCED_PARAMETER(device);
    irp->IoStatus.Status = STATUS_SUCCESS;
    irp->IoStatus.Information = 0;
    IoCompleteRequest(irp, IO_NO_INCREMENT);
    return STATUS_SUCCESS;
}

// ──────────────────────────────────────────────
// unload
// ──────────────────────────────────────────────

static void driver_unload(PDRIVER_OBJECT driver) {
    IoDeleteSymbolicLink(&g_symlink);
    if (g_device) IoDeleteDevice(g_device);

    // scrub traces
    UNICODE_STRING drv_name;
    RtlInitUnicodeString(&drv_name, L"r6drv.sys");
    clean_unloaded_drivers(&drv_name);
    clean_piddb_cache();

    DbgPrint("[r6drv] unloaded\n");
    UNREFERENCED_PARAMETER(driver);
}

// ──────────────────────────────────────────────
// entry
// ──────────────────────────────────────────────

extern "C" NTSTATUS DriverEntry(PDRIVER_OBJECT driver, PUNICODE_STRING registry_path) {
    UNREFERENCED_PARAMETER(registry_path);

    RtlInitUnicodeString(&g_device_name, DEVICE_NAME);
    RtlInitUnicodeString(&g_symlink, SYMLINK_NAME);

    NTSTATUS status = IoCreateDevice(
        driver, 0, &g_device_name,
        FILE_DEVICE_UNKNOWN, FILE_DEVICE_SECURE_OPEN,
        FALSE, &g_device
    );
    if (!NT_SUCCESS(status)) return status;

    status = IoCreateSymbolicLink(&g_symlink, &g_device_name);
    if (!NT_SUCCESS(status)) {
        IoDeleteDevice(g_device);
        return status;
    }

    driver->MajorFunction[IRP_MJ_CREATE] = dispatch_create_close;
    driver->MajorFunction[IRP_MJ_CLOSE]  = dispatch_create_close;
    driver->MajorFunction[IRP_MJ_DEVICE_CONTROL] = dispatch_ioctl;
    driver->DriverUnload = driver_unload;

    g_device->Flags |= DO_BUFFERED_IO;
    g_device->Flags &= ~DO_DEVICE_INITIALIZING;

    DbgPrint("[r6drv] loaded\n");
    return STATUS_SUCCESS;
}
