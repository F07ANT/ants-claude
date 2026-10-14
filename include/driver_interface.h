#pragma once
#include <Windows.h>
#include <cstdint>
#include <string>
#include "shared/ioctls.h"

class DriverInterface {
public:
    bool connect() {
        handle_ = CreateFileW(
            L"\\\\.\\r6drv",
            GENERIC_READ | GENERIC_WRITE,
            FILE_SHARE_READ | FILE_SHARE_WRITE,
            nullptr,
            OPEN_EXISTING,
            0,
            nullptr
        );
        return handle_ != INVALID_HANDLE_VALUE;
    }

    void disconnect() {
        if (handle_ != INVALID_HANDLE_VALUE) {
            CloseHandle(handle_);
            handle_ = INVALID_HANDLE_VALUE;
        }
    }

    bool is_alive() {
        R6_HEARTBEAT hb{};
        hb.magic = 0xDEAD1337;
        DWORD bytes = 0;
        if (!DeviceIoControl(handle_, IOCTL_R6_HEARTBEAT,
                             &hb, sizeof(hb), &hb, sizeof(hb), &bytes, nullptr))
            return false;
        return hb.status == 1;
    }

    bool find_pid(const std::wstring& name, ULONG& pid) {
        R6_PID_REQUEST req{};
        wcsncpy_s(req.process_name, name.c_str(), 63);
        DWORD bytes = 0;
        if (!DeviceIoControl(handle_, IOCTL_R6_GET_PID,
                             &req, sizeof(req), &req, sizeof(req), &bytes, nullptr))
            return false;
        pid = req.pid;
        return true;
    }

    bool get_module_base(ULONG pid, const std::wstring& module, uint64_t& base, ULONG& size) {
        R6_MODULE_REQUEST req{};
        req.pid = pid;
        wcsncpy_s(req.module_name, module.c_str(), 63);
        DWORD bytes = 0;
        if (!DeviceIoControl(handle_, IOCTL_R6_GET_MODULE,
                             &req, sizeof(req), &req, sizeof(req), &bytes, nullptr))
            return false;
        base = req.base_address;
        size = req.module_size;
        return true;
    }

    template <typename T>
    T read(ULONG pid, uint64_t address) {
        T value{};
        R6_READ_REQUEST req{};
        req.pid = pid;
        req.address = address;
        req.buffer = reinterpret_cast<ULONGLONG>(&value);
        req.size = sizeof(T);
        DWORD bytes = 0;
        DeviceIoControl(handle_, IOCTL_R6_READ_MEMORY,
                        &req, sizeof(req), &req, sizeof(req), &bytes, nullptr);
        return value;
    }

    template <typename T>
    bool read(ULONG pid, uint64_t address, T& out) {
        R6_READ_REQUEST req{};
        req.pid = pid;
        req.address = address;
        req.buffer = reinterpret_cast<ULONGLONG>(&out);
        req.size = sizeof(T);
        DWORD bytes = 0;
        return DeviceIoControl(handle_, IOCTL_R6_READ_MEMORY,
                               &req, sizeof(req), &req, sizeof(req), &bytes, nullptr) != 0;
    }

    ~DriverInterface() { disconnect(); }

private:
    HANDLE handle_ = INVALID_HANDLE_VALUE;
};
