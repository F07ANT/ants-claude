#pragma once
#include "config.h"
#include <d2d1.h>
#include <dwrite.h>
#include <vector>
#include <string>
#include <functional>

// ── widget types ──

enum class WidgetType { TOGGLE, SLIDER, KEYBIND, SEPARATOR, HEADER };

struct Widget {
    std::wstring label;
    WidgetType type;

    bool* bool_ptr         = nullptr;
    float* float_ptr       = nullptr;
    int* int_ptr           = nullptr;

    float slider_min       = 0.f;
    float slider_max       = 1.f;
    float slider_step      = 1.f;
    std::wstring suffix;
};

struct Tab {
    std::wstring icon;
    std::wstring name;
    std::vector<Widget> widgets;
};

// ── color theme ──

struct Theme {
    std::wstring name;
    D2D1_COLOR_F accent;
    D2D1_COLOR_F accent_dim;
    D2D1_COLOR_F bg;
    D2D1_COLOR_F panel;
    D2D1_COLOR_F card;
    D2D1_COLOR_F text;
    D2D1_COLOR_F text_dim;
    D2D1_COLOR_F toggle_on;
    D2D1_COLOR_F toggle_off;
    D2D1_COLOR_F slider_track;
    D2D1_COLOR_F slider_fill;
    D2D1_COLOR_F hover;
    D2D1_COLOR_F border;
};

class Menu {
public:
    bool init(ID2D1RenderTarget* rt, IDWriteFactory* dw);
    void render(ID2D1RenderTarget* rt, Config& cfg);
    void release();

    bool is_open() const { return open_; }
    void toggle() { open_ = !open_; }

private:
    void build_tabs(Config& cfg);
    void update_mouse();
    void handle_clicks(Config& cfg);

    // drawing
    void draw_frame(ID2D1RenderTarget* rt) const;
    void draw_sidebar(ID2D1RenderTarget* rt) const;
    void draw_content(ID2D1RenderTarget* rt) const;
    void draw_toggle(ID2D1RenderTarget* rt, float x, float y, float w, bool on, bool hovered) const;
    void draw_slider(ID2D1RenderTarget* rt, float x, float y, float w,
                     float val, float mn, float mx, bool hovered, bool dragging) const;
    void draw_keybind_button(ID2D1RenderTarget* rt, float x, float y, float w,
                             int vk, bool waiting, bool hovered) const;
    void draw_resize_handle(ID2D1RenderTarget* rt) const;
    void draw_theme_dots(ID2D1RenderTarget* rt) const;

    std::wstring vk_name(int vk) const;
    bool point_in_rect(float px, float py, float rx, float ry, float rw, float rh) const;
    ID2D1SolidColorBrush* make_brush(ID2D1RenderTarget* rt, D2D1_COLOR_F c) const;
    void rebuild_brushes(ID2D1RenderTarget* rt);

    // state
    bool open_ = false;
    bool built_ = false;
    bool brushes_valid_ = false;
    int active_tab_ = 0;
    int hover_widget_ = -1;
    int hover_tab_ = -1;
    bool waiting_keybind_ = false;
    int keybind_widget_ = -1;
    float scroll_y_ = 0.f;

    // mouse
    POINT mouse_screen_{};
    float mx_ = 0.f, my_ = 0.f;
    bool lmb_down_ = false, lmb_pressed_ = false, lmb_released_ = false;
    bool prev_lmb_ = false;
    bool rmb_pressed_ = false, prev_rmb_ = false;

    // drag / resize
    bool dragging_window_ = false;
    float drag_off_x_ = 0.f, drag_off_y_ = 0.f;
    bool resizing_ = false;
    float resize_off_x_ = 0.f, resize_off_y_ = 0.f;
    bool dragging_slider_ = false;
    int drag_slider_idx_ = -1;

    // layout
    float win_x_ = 100.f, win_y_ = 100.f;
    float win_w_ = 520.f, win_h_ = 440.f;
    static constexpr float MIN_W = 400.f;
    static constexpr float MIN_H = 300.f;
    static constexpr float MAX_W = 900.f;
    static constexpr float MAX_H = 800.f;
    static constexpr float TITLE_H = 38.f;
    static constexpr float SIDEBAR_W = 140.f;
    static constexpr float ROW_H = 34.f;
    static constexpr float PAD = 14.f;
    static constexpr float TOGGLE_W = 38.f;
    static constexpr float TOGGLE_H = 20.f;
    static constexpr float SLIDER_H = 6.f;
    static constexpr float HANDLE_R = 7.f;
    static constexpr float CORNER_R = 8.f;

    // tabs
    std::vector<Tab> tabs_;

    // themes
    int active_theme_ = 0;
    std::vector<Theme> themes_;
    void init_themes();

    // brushes — rebuilt on theme change
    ID2D1SolidColorBrush* b_accent_      = nullptr;
    ID2D1SolidColorBrush* b_accent_dim_  = nullptr;
    ID2D1SolidColorBrush* b_bg_          = nullptr;
    ID2D1SolidColorBrush* b_panel_       = nullptr;
    ID2D1SolidColorBrush* b_card_        = nullptr;
    ID2D1SolidColorBrush* b_text_        = nullptr;
    ID2D1SolidColorBrush* b_text_dim_    = nullptr;
    ID2D1SolidColorBrush* b_toggle_on_   = nullptr;
    ID2D1SolidColorBrush* b_toggle_off_  = nullptr;
    ID2D1SolidColorBrush* b_slider_trk_  = nullptr;
    ID2D1SolidColorBrush* b_slider_fill_ = nullptr;
    ID2D1SolidColorBrush* b_hover_       = nullptr;
    ID2D1SolidColorBrush* b_border_      = nullptr;
    ID2D1SolidColorBrush* b_white_       = nullptr;
    ID2D1SolidColorBrush* b_black_       = nullptr;

    IDWriteTextFormat* f_title_  = nullptr;
    IDWriteTextFormat* f_tab_    = nullptr;
    IDWriteTextFormat* f_label_  = nullptr;
    IDWriteTextFormat* f_value_  = nullptr;
    IDWriteTextFormat* f_header_ = nullptr;
    IDWriteTextFormat* f_small_  = nullptr;
};
