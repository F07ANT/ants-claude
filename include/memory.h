#pragma once
#include <Windows.h>
#include <TlHelp32.h>
#include <cstdint>
#include <string>
#include <optional>
#include "driver_interface.h"

enum class ReadMode {
    DRIVER,     // kernel driver — no handle, no RPM, AC invisible
    RPM         // fallback ReadProcessMemory
};

class Memory {
public:
    bool attach(const std::wstring& process_name);
    void detach();
    bool is_attached() const;
    ReadMode mode() const { return mode_; }

    uintptr_t get_module_base(const std::wstring& module_name) const;

    template <typename T>
    T read(uintptr_t address) const {
        if (mode_ == ReadMode::DRIVER) {
            return driver_.read<T>(pid_, address);
        }
        T value{};
        ReadProcessMemory(process_, reinterpret_cast<LPCVOID>(address), &value, sizeof(T), nullptr);
        return value;
    }

    template <typename T>
    bool read(uintptr_t address, T& out) const {
        if (mode_ == ReadMode::DRIVER) {
            return driver_.read<T>(pid_, address, out);
        }
        SIZE_T bytes_read = 0;
        return ReadProcessMemory(process_, reinterpret_cast<LPCVOID>(address), &out, sizeof(T), &bytes_read)
            && bytes_read == sizeof(T);
    }

    uintptr_t resolve_chain(uintptr_t base, std::initializer_list<uintptr_t> offsets) const;

    ~Memory();

private:
    HANDLE process_ = nullptr;
    DWORD pid_ = 0;
    ReadMode mode_ = ReadMode::RPM;
    mutable DriverInterface driver_;

    std::optional<DWORD> find_pid(const std::wstring& name) const;
    bool try_driver(const std::wstring& process_name);
};
