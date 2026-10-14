#include "overlay.h"
#include <dwmapi.h>

#pragma comment(lib, "d2d1.lib")
#pragma comment(lib, "dwrite.lib")
#pragma comment(lib, "dwmapi.lib")

static Overlay* g_overlay = nullptr;

LRESULT CALLBACK Overlay::wnd_proc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
    if (msg == WM_DESTROY) { PostQuitMessage(0); return 0; }
    return DefWindowProcW(hwnd, msg, wp, lp);
}

bool Overlay::init(int width, int height) {
    g_overlay = this;
    width_ = width;
    height_ = height;

    // find game window
    game_hwnd_ = FindWindowW(nullptr, L"Rainbow Six");
    if (!game_hwnd_) game_hwnd_ = FindWindowW(nullptr, L"Tom Clancy's Rainbow Six  Siege");

    WNDCLASSEXW wc{};
    wc.cbSize = sizeof(wc);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = wnd_proc;
    wc.hInstance = GetModuleHandleW(nullptr);
    wc.lpszClassName = L"r6_overlay";
    RegisterClassExW(&wc);

    hwnd_ = CreateWindowExW(
        WS_EX_TOPMOST | WS_EX_TRANSPARENT | WS_EX_LAYERED | WS_EX_NOACTIVATE,
        L"r6_overlay", L"",
        WS_POPUP,
        0, 0, width_, height_,
        nullptr, nullptr, wc.hInstance, nullptr
    );
    if (!hwnd_) return false;

    SetLayeredWindowAttributes(hwnd_, RGB(0, 0, 0), 0, LWA_COLORKEY);

    // extend frame into client area for click-through
    MARGINS margins = {-1, -1, -1, -1};
    DwmExtendFrameIntoClientArea(hwnd_, &margins);

    ShowWindow(hwnd_, SW_SHOWNOACTIVATE);
    UpdateWindow(hwnd_);

    return create_device_resources();
}

bool Overlay::create_device_resources() {
    HRESULT hr = D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED, &d2d_factory_);
    if (FAILED(hr)) return false;

    D2D1_RENDER_TARGET_PROPERTIES rtp = D2D1::RenderTargetProperties(
        D2D1_RENDER_TARGET_TYPE_DEFAULT,
        D2D1::PixelFormat(DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED)
    );

    D2D1_HWND_RENDER_TARGET_PROPERTIES hrtp = D2D1::HwndRenderTargetProperties(
        hwnd_, D2D1::SizeU(width_, height_)
    );

    hr = d2d_factory_->CreateHwndRenderTarget(rtp, hrtp, &render_target_);
    if (FAILED(hr)) return false;

    hr = DWriteCreateFactory(DWRITE_FACTORY_TYPE_SHARED,
        __uuidof(IDWriteFactory), reinterpret_cast<IUnknown**>(&dwrite_factory_));
    if (FAILED(hr)) return false;

    return true;
}

void Overlay::discard_device_resources() {
    if (render_target_) { render_target_->Release(); render_target_ = nullptr; }
    if (dwrite_factory_) { dwrite_factory_->Release(); dwrite_factory_ = nullptr; }
    if (d2d_factory_) { d2d_factory_->Release(); d2d_factory_ = nullptr; }
}

void Overlay::render() {
    if (!render_target_) return;

    // follow game window position
    if (game_hwnd_ && IsWindow(game_hwnd_)) {
        RECT r;
        if (GetWindowRect(game_hwnd_, &r)) {
            SetWindowPos(hwnd_, HWND_TOPMOST, r.left, r.top,
                         r.right - r.left, r.bottom - r.top, SWP_NOACTIVATE);
        }
    }

    render_target_->BeginDraw();
    render_target_->Clear(D2D1::ColorF(0.f, 0.f, 0.f, 0.f));

    if (render_cb_) render_cb_(render_target_, dwrite_factory_);

    HRESULT hr = render_target_->EndDraw();
    if (hr == D2DERR_RECREATE_TARGET) {
        discard_device_resources();
        create_device_resources();
    }
}

int Overlay::run() {
    MSG msg{};
    while (msg.message != WM_QUIT) {
        if (PeekMessageW(&msg, nullptr, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        } else {
            render();
            Sleep(1); // ~1000fps cap, vsync on target does the rest
        }
    }
    return static_cast<int>(msg.wParam);
}

void Overlay::shutdown() {
    discard_device_resources();
    if (hwnd_) { DestroyWindow(hwnd_); hwnd_ = nullptr; }
}
