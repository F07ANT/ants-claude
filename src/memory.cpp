#include "memory.h"
#include <cstdio>

std::optional<DWORD> Memory::find_pid(const std::wstring& name) const {
    HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (snap == INVALID_HANDLE_VALUE) return std::nullopt;

    PROCESSENTRY32W entry{};
    entry.dwSize = sizeof(entry);

    if (Process32FirstW(snap, &entry)) {
        do {
            if (name == entry.szExeFile) {
                CloseHandle(snap);
                return entry.th32ProcessID;
            }
        } while (Process32NextW(snap, &entry));
    }

    CloseHandle(snap);
    return std::nullopt;
}

bool Memory::try_driver(const std::wstring& process_name) {
    if (!driver_.connect()) return false;
    if (!driver_.is_alive()) { driver_.disconnect(); return false; }

    ULONG dpid = 0;
    if (!driver_.find_pid(process_name, dpid)) {
        driver_.disconnect();
        return false;
    }

    pid_ = dpid;
    mode_ = ReadMode::DRIVER;
    std::printf("[+] driver mode active — no handle, no RPM\n");
    return true;
}

bool Memory::attach(const std::wstring& process_name) {
    // try kernel driver first
    if (try_driver(process_name)) return true;

    // fallback to RPM
    std::printf("[*] driver not loaded, falling back to RPM\n");
    auto pid = find_pid(process_name);
    if (!pid) return false;

    pid_ = *pid;
    mode_ = ReadMode::RPM;
    process_ = OpenProcess(PROCESS_VM_READ | PROCESS_QUERY_INFORMATION, FALSE, pid_);
    return process_ != nullptr;
}

void Memory::detach() {
    if (mode_ == ReadMode::DRIVER) {
        driver_.disconnect();
    }
    if (process_) {
        CloseHandle(process_);
        process_ = nullptr;
    }
    pid_ = 0;
}

bool Memory::is_attached() const {
    if (mode_ == ReadMode::DRIVER) {
        return driver_.is_alive();
    }
    if (!process_) return false;
    DWORD code = 0;
    return GetExitCodeProcess(process_, &code) && code == STILL_ACTIVE;
}

uintptr_t Memory::get_module_base(const std::wstring& module_name) const {
    if (mode_ == ReadMode::DRIVER) {
        uint64_t base = 0;
        ULONG size = 0;
        if (driver_.get_module_base(pid_, module_name, base, size))
            return static_cast<uintptr_t>(base);
        return 0;
    }

    HANDLE snap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, pid_);
    if (snap == INVALID_HANDLE_VALUE) return 0;

    MODULEENTRY32W entry{};
    entry.dwSize = sizeof(entry);

    uintptr_t base = 0;
    if (Module32FirstW(snap, &entry)) {
        do {
            if (module_name == entry.szModule) {
                base = reinterpret_cast<uintptr_t>(entry.modBaseAddr);
                break;
            }
        } while (Module32NextW(snap, &entry));
    }

    CloseHandle(snap);
    return base;
}

uintptr_t Memory::resolve_chain(uintptr_t base, std::initializer_list<uintptr_t> offsets) const {
    uintptr_t addr = base;
    for (auto off : offsets) {
        if (!read(addr, addr)) return 0;
        addr += off;
    }
    return addr;
}

Memory::~Memory() {
    detach();
}
