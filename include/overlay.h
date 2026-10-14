#pragma once
#include <Windows.h>
#include <d2d1.h>
#include <dwrite.h>
#include <functional>

class Overlay {
public:
    using RenderCallback = std::function<void(ID2D1RenderTarget*, IDWriteFactory*)>;

    bool init(int width, int height);
    void set_render_callback(RenderCallback cb) { render_cb_ = std::move(cb); }
    int run();
    void shutdown();

    HWND hwnd() const { return hwnd_; }

private:
    static LRESULT CALLBACK wnd_proc(HWND, UINT, WPARAM, LPARAM);
    bool create_device_resources();
    void discard_device_resources();
    void render();

    HWND hwnd_ = nullptr;
    HWND game_hwnd_ = nullptr;
    ID2D1Factory* d2d_factory_ = nullptr;
    ID2D1HwndRenderTarget* render_target_ = nullptr;
    IDWriteFactory* dwrite_factory_ = nullptr;
    RenderCallback render_cb_;
    int width_ = 1920;
    int height_ = 1080;
};
