#include "menu.h"
#include <algorithm>
#include <cstdio>
#include <cmath>

// ════════════════════════════════════════════════
// themes
// ════════════════════════════════════════════════

void Menu::init_themes() {
    themes_.clear();

    // purple (default)
    themes_.push_back({L"Purple",
        {0.55f, 0.35f, 1.0f, 1.f},    // accent
        {0.40f, 0.25f, 0.75f, 0.5f},  // accent_dim
        {0.06f, 0.06f, 0.09f, 0.96f}, // bg
        {0.09f, 0.09f, 0.13f, 0.98f}, // panel
        {0.12f, 0.12f, 0.16f, 1.f},   // card
        {0.95f, 0.95f, 0.97f, 1.f},   // text
        {0.45f, 0.45f, 0.52f, 1.f},   // text_dim
        {0.30f, 0.85f, 0.45f, 1.f},   // toggle_on
        {0.35f, 0.35f, 0.40f, 1.f},   // toggle_off
        {0.18f, 0.18f, 0.22f, 1.f},   // slider_track
        {0.55f, 0.35f, 1.0f, 1.f},    // slider_fill
        {0.15f, 0.15f, 0.20f, 1.f},   // hover
        {0.20f, 0.20f, 0.26f, 0.6f},  // border
    });

    // red
    themes_.push_back({L"Red",
        {0.90f, 0.25f, 0.30f, 1.f},
        {0.65f, 0.18f, 0.22f, 0.5f},
        {0.07f, 0.05f, 0.05f, 0.96f},
        {0.10f, 0.08f, 0.08f, 0.98f},
        {0.14f, 0.11f, 0.11f, 1.f},
        {0.95f, 0.93f, 0.93f, 1.f},
        {0.50f, 0.42f, 0.42f, 1.f},
        {0.30f, 0.85f, 0.45f, 1.f},
        {0.35f, 0.30f, 0.30f, 1.f},
        {0.20f, 0.16f, 0.16f, 1.f},
        {0.90f, 0.25f, 0.30f, 1.f},
        {0.18f, 0.13f, 0.13f, 1.f},
        {0.25f, 0.18f, 0.18f, 0.6f},
    });

    // cyan
    themes_.push_back({L"Cyan",
        {0.20f, 0.80f, 0.90f, 1.f},
        {0.15f, 0.55f, 0.65f, 0.5f},
        {0.04f, 0.06f, 0.08f, 0.96f},
        {0.06f, 0.09f, 0.11f, 0.98f},
        {0.08f, 0.12f, 0.15f, 1.f},
        {0.90f, 0.96f, 0.98f, 1.f},
        {0.40f, 0.50f, 0.55f, 1.f},
        {0.20f, 0.90f, 0.50f, 1.f},
        {0.30f, 0.35f, 0.38f, 1.f},
        {0.12f, 0.16f, 0.18f, 1.f},
        {0.20f, 0.80f, 0.90f, 1.f},
        {0.10f, 0.14f, 0.17f, 1.f},
        {0.15f, 0.22f, 0.25f, 0.6f},
    });

    // green
    themes_.push_back({L"Green",
        {0.30f, 0.85f, 0.45f, 1.f},
        {0.22f, 0.60f, 0.35f, 0.5f},
        {0.04f, 0.07f, 0.05f, 0.96f},
        {0.06f, 0.10f, 0.07f, 0.98f},
        {0.09f, 0.14f, 0.10f, 1.f},
        {0.92f, 0.97f, 0.93f, 1.f},
        {0.42f, 0.52f, 0.44f, 1.f},
        {0.30f, 0.85f, 0.45f, 1.f},
        {0.30f, 0.35f, 0.32f, 1.f},
        {0.14f, 0.18f, 0.14f, 1.f},
        {0.30f, 0.85f, 0.45f, 1.f},
        {0.12f, 0.16f, 0.12f, 1.f},
        {0.18f, 0.24f, 0.18f, 0.6f},
    });

    // orange
    themes_.push_back({L"Orange",
        {1.0f, 0.55f, 0.15f, 1.f},
        {0.75f, 0.40f, 0.10f, 0.5f},
        {0.08f, 0.06f, 0.04f, 0.96f},
        {0.11f, 0.09f, 0.06f, 0.98f},
        {0.15f, 0.12f, 0.08f, 1.f},
        {0.98f, 0.94f, 0.90f, 1.f},
        {0.55f, 0.48f, 0.40f, 1.f},
        {0.30f, 0.85f, 0.45f, 1.f},
        {0.38f, 0.33f, 0.28f, 1.f},
        {0.20f, 0.17f, 0.12f, 1.f},
        {1.0f, 0.55f, 0.15f, 1.f},
        {0.17f, 0.14f, 0.10f, 1.f},
        {0.25f, 0.20f, 0.14f, 0.6f},
    });
}

// ════════════════════════════════════════════════
// init / release
// ════════════════════════════════════════════════

ID2D1SolidColorBrush* Menu::make_brush(ID2D1RenderTarget* rt, D2D1_COLOR_F c) const {
    ID2D1SolidColorBrush* b = nullptr;
    rt->CreateSolidColorBrush(c, &b);
    return b;
}

void Menu::rebuild_brushes(ID2D1RenderTarget* rt) {
    auto safe = [](auto*& p) { if (p) { p->Release(); p = nullptr; } };
    safe(b_accent_); safe(b_accent_dim_); safe(b_bg_); safe(b_panel_);
    safe(b_card_); safe(b_text_); safe(b_text_dim_);
    safe(b_toggle_on_); safe(b_toggle_off_);
    safe(b_slider_trk_); safe(b_slider_fill_);
    safe(b_hover_); safe(b_border_);

    const auto& t = themes_[active_theme_];
    b_accent_      = make_brush(rt, t.accent);
    b_accent_dim_  = make_brush(rt, t.accent_dim);
    b_bg_          = make_brush(rt, t.bg);
    b_panel_       = make_brush(rt, t.panel);
    b_card_        = make_brush(rt, t.card);
    b_text_        = make_brush(rt, t.text);
    b_text_dim_    = make_brush(rt, t.text_dim);
    b_toggle_on_   = make_brush(rt, t.toggle_on);
    b_toggle_off_  = make_brush(rt, t.toggle_off);
    b_slider_trk_  = make_brush(rt, t.slider_track);
    b_slider_fill_ = make_brush(rt, t.slider_fill);
    b_hover_       = make_brush(rt, t.hover);
    b_border_      = make_brush(rt, t.border);

    brushes_valid_ = true;
}

bool Menu::init(ID2D1RenderTarget* rt, IDWriteFactory* dw) {
    init_themes();

    b_white_ = make_brush(rt, {1.f, 1.f, 1.f, 1.f});
    b_black_ = make_brush(rt, {0.f, 0.f, 0.f, 1.f});

    rebuild_brushes(rt);

    HRESULT hr;
    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_BOLD, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        14.f, L"en-us", &f_title_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_SEMI_BOLD, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        12.f, L"en-us", &f_tab_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        12.5f, L"en-us", &f_label_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Consolas", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        11.5f, L"en-us", &f_value_);
    if (FAILED(hr)) return false;
    f_value_->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_TRAILING);

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_BOLD, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        10.5f, L"en-us", &f_header_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        10.f, L"en-us", &f_small_);
    if (FAILED(hr)) return false;

    return true;
}

// ════════════════════════════════════════════════
// tab definitions
// ════════════════════════════════════════════════

void Menu::build_tabs(Config& cfg) {
    tabs_.clear();

    Tab aim;
    aim.icon = L"\x2316"; // crosshair
    aim.name = L"Aimbot";
    aim.widgets.push_back({L"GENERAL",       WidgetType::HEADER});
    aim.widgets.push_back({L"Enable Aimbot", WidgetType::TOGGLE, &cfg.aim_enabled});
    aim.widgets.push_back({L"Head Only",     WidgetType::TOGGLE, &cfg.aim_head_only});
    aim.widgets.push_back({L"",              WidgetType::SEPARATOR});
    aim.widgets.push_back({L"TUNING",        WidgetType::HEADER});
    aim.widgets.push_back({L"FOV Radius",    WidgetType::SLIDER, nullptr, &cfg.aim_fov, nullptr, 10.f, 500.f, 5.f, L"px"});
    aim.widgets.push_back({L"Smoothing",     WidgetType::SLIDER, nullptr, &cfg.aim_smooth, nullptr, 1.f, 25.f, 0.5f, L"x"});
    aim.widgets.push_back({L"",              WidgetType::SEPARATOR});
    aim.widgets.push_back({L"KEYBINDS",      WidgetType::HEADER});
    aim.widgets.push_back({L"Aim Key",       WidgetType::KEYBIND, nullptr, nullptr, &cfg.aim_key});
    tabs_.push_back(std::move(aim));

    Tab esp;
    esp.icon = L"\x25A3"; // square
    esp.name = L"Visuals";
    esp.widgets.push_back({L"PLAYER ESP",    WidgetType::HEADER});
    esp.widgets.push_back({L"Enable ESP",    WidgetType::TOGGLE, &cfg.esp_enabled});
    esp.widgets.push_back({L"Bounding Box",  WidgetType::TOGGLE, &cfg.esp_box});
    esp.widgets.push_back({L"Health Bar",    WidgetType::TOGGLE, &cfg.esp_health});
    esp.widgets.push_back({L"Player Name",   WidgetType::TOGGLE, &cfg.esp_name});
    esp.widgets.push_back({L"Distance",      WidgetType::TOGGLE, &cfg.esp_distance});
    esp.widgets.push_back({L"Snaplines",     WidgetType::TOGGLE, &cfg.esp_snapline});
    esp.widgets.push_back({L"",              WidgetType::SEPARATOR});
    esp.widgets.push_back({L"FILTER",        WidgetType::HEADER});
    esp.widgets.push_back({L"Show Teammates",WidgetType::TOGGLE, &cfg.esp_team});
    tabs_.push_back(std::move(esp));

    Tab settings;
    settings.icon = L"\x2699"; // gear
    settings.name = L"Settings";
    settings.widgets.push_back({L"KEYBINDS",   WidgetType::HEADER});
    settings.widgets.push_back({L"Menu Toggle", WidgetType::KEYBIND, nullptr, nullptr, &cfg.menu_key});
    tabs_.push_back(std::move(settings));

    built_ = true;
}

// ════════════════════════════════════════════════
// mouse state
// ════════════════════════════════════════════════

void Menu::update_mouse() {
    GetCursorPos(&mouse_screen_);
    mx_ = static_cast<float>(mouse_screen_.x);
    my_ = static_cast<float>(mouse_screen_.y);

    bool cur_lmb = (GetAsyncKeyState(VK_LBUTTON) & 0x8000) != 0;
    lmb_pressed_  = cur_lmb && !prev_lmb_;
    lmb_released_ = !cur_lmb && prev_lmb_;
    lmb_down_     = cur_lmb;
    prev_lmb_     = cur_lmb;

    bool cur_rmb = (GetAsyncKeyState(VK_RBUTTON) & 0x8000) != 0;
    rmb_pressed_ = cur_rmb && !prev_rmb_;
    prev_rmb_    = cur_rmb;
}

bool Menu::point_in_rect(float px, float py, float rx, float ry, float rw, float rh) const {
    return px >= rx && px <= rx + rw && py >= ry && py <= ry + rh;
}

// ════════════════════════════════════════════════
// click handling
// ════════════════════════════════════════════════

void Menu::handle_clicks(Config& cfg) {
    // keybind capture — any key press
    if (waiting_keybind_ && keybind_widget_ >= 0) {
        if (GetAsyncKeyState(VK_ESCAPE) & 0x8000) {
            waiting_keybind_ = false;
            keybind_widget_ = -1;
            return;
        }
        for (int vk = 1; vk < 256; ++vk) {
            if (vk == VK_ESCAPE || vk == VK_LBUTTON) continue;
            if (GetAsyncKeyState(vk) & 0x8000) {
                auto& w = tabs_[active_tab_].widgets[keybind_widget_];
                if (w.int_ptr) *w.int_ptr = vk;
                waiting_keybind_ = false;
                keybind_widget_ = -1;
                return;
            }
        }
        return;
    }

    // drag window
    if (dragging_window_) {
        win_x_ = mx_ - drag_off_x_;
        win_y_ = my_ - drag_off_y_;
        if (!lmb_down_) dragging_window_ = false;
        return;
    }

    // resize
    if (resizing_) {
        win_w_ = std::clamp(mx_ - win_x_ + resize_off_x_, MIN_W, MAX_W);
        win_h_ = std::clamp(my_ - win_y_ + resize_off_y_, MIN_H, MAX_H);
        if (!lmb_down_) resizing_ = false;
        return;
    }

    // slider drag
    if (dragging_slider_ && drag_slider_idx_ >= 0) {
        auto& w = tabs_[active_tab_].widgets[drag_slider_idx_];
        float content_x = win_x_ + SIDEBAR_W;
        float content_w = win_w_ - SIDEBAR_W;
        float slider_x = content_x + content_w * 0.45f;
        float slider_w = content_w * 0.38f;

        float t = std::clamp((mx_ - slider_x) / slider_w, 0.f, 1.f);
        float raw = w.slider_min + t * (w.slider_max - w.slider_min);
        // snap to step
        raw = roundf(raw / w.slider_step) * w.slider_step;
        raw = std::clamp(raw, w.slider_min, w.slider_max);
        if (w.float_ptr) *w.float_ptr = raw;

        if (!lmb_down_) {
            dragging_slider_ = false;
            drag_slider_idx_ = -1;
        }
        return;
    }

    if (!lmb_pressed_) return;

    // title bar drag start
    if (point_in_rect(mx_, my_, win_x_, win_y_, win_w_, TITLE_H)) {
        // check theme dots first
        float dot_x = win_x_ + win_w_ - PAD - static_cast<float>(themes_.size()) * 18.f;
        float dot_y = win_y_ + TITLE_H * 0.5f - 5.f;
        for (int i = 0; i < static_cast<int>(themes_.size()); ++i) {
            float cx = dot_x + static_cast<float>(i) * 18.f + 5.f;
            float cy = dot_y + 5.f;
            float dx = mx_ - cx, dy = my_ - cy;
            if (dx * dx + dy * dy <= 36.f) {
                active_theme_ = i;
                brushes_valid_ = false;
                return;
            }
        }
        dragging_window_ = true;
        drag_off_x_ = mx_ - win_x_;
        drag_off_y_ = my_ - win_y_;
        return;
    }

    // resize handle (bottom-right 16x16)
    if (point_in_rect(mx_, my_, win_x_ + win_w_ - 16.f, win_y_ + win_h_ - 16.f, 16.f, 16.f)) {
        resizing_ = true;
        resize_off_x_ = win_w_ - (mx_ - win_x_);
        resize_off_y_ = win_h_ - (my_ - win_y_);
        return;
    }

    // sidebar tab click
    float sidebar_y = win_y_ + TITLE_H + PAD;
    for (int i = 0; i < static_cast<int>(tabs_.size()); ++i) {
        float ty = sidebar_y + static_cast<float>(i) * (ROW_H + 4.f);
        if (point_in_rect(mx_, my_, win_x_, ty, SIDEBAR_W, ROW_H)) {
            active_tab_ = i;
            scroll_y_ = 0.f;
            return;
        }
    }

    // content widget clicks
    if (tabs_.empty()) return;
    float content_x = win_x_ + SIDEBAR_W;
    float content_w = win_w_ - SIDEBAR_W;
    float wy = win_y_ + TITLE_H + PAD + scroll_y_;

    auto& tab = tabs_[active_tab_];
    for (int i = 0; i < static_cast<int>(tab.widgets.size()); ++i) {
        auto& w = tab.widgets[i];
        float row_h = (w.type == WidgetType::SEPARATOR) ? 12.f :
                      (w.type == WidgetType::HEADER) ? 26.f : ROW_H;

        if (w.type == WidgetType::TOGGLE && w.bool_ptr) {
            float toggle_x = content_x + content_w - PAD * 2.f - TOGGLE_W;
            float toggle_y = wy + (row_h - TOGGLE_H) * 0.5f;
            if (point_in_rect(mx_, my_, toggle_x, toggle_y, TOGGLE_W, TOGGLE_H)) {
                *w.bool_ptr = !*w.bool_ptr;
                wy += row_h;
                continue;
            }
        }

        if (w.type == WidgetType::SLIDER && w.float_ptr) {
            float slider_x = content_x + content_w * 0.45f;
            float slider_w = content_w * 0.38f;
            float slider_y = wy + row_h * 0.5f - SLIDER_H * 0.5f;
            if (point_in_rect(mx_, my_, slider_x - HANDLE_R, slider_y - HANDLE_R,
                              slider_w + HANDLE_R * 2.f, SLIDER_H + HANDLE_R * 2.f)) {
                dragging_slider_ = true;
                drag_slider_idx_ = i;
                wy += row_h;
                continue;
            }
        }

        if (w.type == WidgetType::KEYBIND && w.int_ptr) {
            float btn_w = 80.f;
            float btn_x = content_x + content_w - PAD * 2.f - btn_w;
            float btn_y = wy + (row_h - 22.f) * 0.5f;
            if (point_in_rect(mx_, my_, btn_x, btn_y, btn_w, 22.f)) {
                waiting_keybind_ = true;
                keybind_widget_ = i;
                wy += row_h;
                continue;
            }
        }

        wy += row_h;
    }
}

// ════════════════════════════════════════════════
// rendering
// ════════════════════════════════════════════════

void Menu::render(ID2D1RenderTarget* rt, Config& cfg) {
    if (!built_) build_tabs(cfg);
    if (!open_) return;
    if (!brushes_valid_) rebuild_brushes(rt);

    update_mouse();
    handle_clicks(cfg);

    draw_frame(rt);
    draw_sidebar(rt);
    draw_content(rt);
    draw_resize_handle(rt);
}

void Menu::draw_frame(ID2D1RenderTarget* rt) const {
    // drop shadow (outer glow)
    for (int i = 3; i >= 1; --i) {
        float s = static_cast<float>(i) * 2.f;
        D2D1_ROUNDED_RECT shadow = {
            {win_x_ - s, win_y_ - s, win_x_ + win_w_ + s, win_y_ + win_h_ + s},
            CORNER_R + s, CORNER_R + s
        };
        ID2D1SolidColorBrush* sb = nullptr;
        rt->CreateSolidColorBrush({0.f, 0.f, 0.f, 0.08f * static_cast<float>(4 - i)}, &sb);
        if (sb) { rt->FillRoundedRectangle(shadow, sb); sb->Release(); }
    }

    // main bg
    D2D1_ROUNDED_RECT bg = {
        {win_x_, win_y_, win_x_ + win_w_, win_y_ + win_h_},
        CORNER_R, CORNER_R
    };
    rt->FillRoundedRectangle(bg, b_bg_);

    // border
    rt->DrawRoundedRectangle(bg, b_border_, 1.f);

    // title bar
    D2D1_ROUNDED_RECT title_bg = {
        {win_x_, win_y_, win_x_ + win_w_, win_y_ + TITLE_H},
        CORNER_R, CORNER_R
    };
    rt->FillRoundedRectangle(title_bg, b_panel_);

    // accent line under title
    D2D1_RECT_F accent_line = {win_x_ + 1.f, win_y_ + TITLE_H - 2.f,
                                win_x_ + win_w_ - 1.f, win_y_ + TITLE_H};
    rt->FillRectangle(accent_line, b_accent_dim_);

    // title text
    D2D1_RECT_F title_rect = {win_x_ + PAD, win_y_ + 8.f,
                               win_x_ + 200.f, win_y_ + TITLE_H};
    rt->DrawText(L"R6 EXTERNAL", 11, f_title_, title_rect, b_accent_);

    // theme dots
    draw_theme_dots(rt);

    // sidebar divider
    D2D1_RECT_F divider = {win_x_ + SIDEBAR_W - 1.f, win_y_ + TITLE_H,
                            win_x_ + SIDEBAR_W, win_y_ + win_h_};
    rt->FillRectangle(divider, b_border_);
}

void Menu::draw_theme_dots(ID2D1RenderTarget* rt) const {
    float dot_x = win_x_ + win_w_ - PAD - static_cast<float>(themes_.size()) * 18.f;
    float dot_y = win_y_ + TITLE_H * 0.5f;

    for (int i = 0; i < static_cast<int>(themes_.size()); ++i) {
        float cx = dot_x + static_cast<float>(i) * 18.f + 5.f;
        D2D1_ELLIPSE dot = {{cx, dot_y}, 5.f, 5.f};

        ID2D1SolidColorBrush* db = nullptr;
        rt->CreateSolidColorBrush(themes_[i].accent, &db);
        if (db) {
            rt->FillEllipse(dot, db);
            if (i == active_theme_) {
                D2D1_ELLIPSE ring = {{cx, dot_y}, 7.f, 7.f};
                rt->DrawEllipse(ring, b_text_, 1.5f);
            }
            db->Release();
        }
    }
}

void Menu::draw_sidebar(ID2D1RenderTarget* rt) const {
    // sidebar background
    D2D1_RECT_F sidebar_bg = {win_x_, win_y_ + TITLE_H,
                               win_x_ + SIDEBAR_W - 1.f, win_y_ + win_h_};
    rt->FillRectangle(sidebar_bg, b_panel_);

    float sy = win_y_ + TITLE_H + PAD;

    for (int i = 0; i < static_cast<int>(tabs_.size()); ++i) {
        float ty = sy + static_cast<float>(i) * (ROW_H + 4.f);
        bool active = (i == active_tab_);
        bool hovered = point_in_rect(mx_, my_, win_x_, ty, SIDEBAR_W, ROW_H);

        if (active) {
            // active indicator
            D2D1_RECT_F indicator = {win_x_, ty, win_x_ + 3.f, ty + ROW_H};
            rt->FillRectangle(indicator, b_accent_);

            D2D1_RECT_F tab_bg = {win_x_ + 3.f, ty, win_x_ + SIDEBAR_W - 1.f, ty + ROW_H};
            rt->FillRectangle(tab_bg, b_card_);
        } else if (hovered) {
            D2D1_RECT_F tab_bg = {win_x_, ty, win_x_ + SIDEBAR_W - 1.f, ty + ROW_H};
            rt->FillRectangle(tab_bg, b_hover_);
        }

        // icon
        D2D1_RECT_F icon_rect = {win_x_ + PAD, ty + 4.f,
                                  win_x_ + PAD + 20.f, ty + ROW_H - 4.f};
        rt->DrawText(tabs_[i].icon.c_str(), static_cast<UINT32>(tabs_[i].icon.size()),
                     f_tab_, icon_rect, active ? b_accent_ : b_text_dim_);

        // name
        D2D1_RECT_F name_rect = {win_x_ + PAD + 22.f, ty + 6.f,
                                  win_x_ + SIDEBAR_W - PAD, ty + ROW_H};
        rt->DrawText(tabs_[i].name.c_str(), static_cast<UINT32>(tabs_[i].name.size()),
                     f_tab_, name_rect, active ? b_text_ : b_text_dim_);
    }
}

void Menu::draw_content(ID2D1RenderTarget* rt) const {
    if (tabs_.empty()) return;
    const auto& tab = tabs_[active_tab_];

    float content_x = win_x_ + SIDEBAR_W + PAD;
    float content_w = win_w_ - SIDEBAR_W - PAD * 2.f;
    float wy = win_y_ + TITLE_H + PAD + scroll_y_;

    for (int i = 0; i < static_cast<int>(tab.widgets.size()); ++i) {
        const auto& w = tab.widgets[i];

        if (w.type == WidgetType::SEPARATOR) {
            float line_y = wy + 5.f;
            D2D1_RECT_F sep = {content_x, line_y, content_x + content_w, line_y + 1.f};
            rt->FillRectangle(sep, b_border_);
            wy += 12.f;
            continue;
        }

        if (w.type == WidgetType::HEADER) {
            D2D1_RECT_F header_rect = {content_x, wy + 6.f,
                                        content_x + content_w, wy + 24.f};
            rt->DrawText(w.label.c_str(), static_cast<UINT32>(w.label.size()),
                         f_header_, header_rect, b_accent_);
            wy += 26.f;
            continue;
        }

        float row_h = ROW_H;
        bool hovered = point_in_rect(mx_, my_, win_x_ + SIDEBAR_W, wy,
                                     win_w_ - SIDEBAR_W, row_h);

        // row hover highlight
        if (hovered) {
            D2D1_ROUNDED_RECT row_bg = {
                {content_x - 6.f, wy, content_x + content_w + 6.f, wy + row_h - 2.f},
                4.f, 4.f
            };
            rt->FillRoundedRectangle(row_bg, b_hover_);
        }

        // label
        D2D1_RECT_F label_rect = {content_x, wy + 6.f,
                                   content_x + content_w * 0.45f, wy + row_h};
        rt->DrawText(w.label.c_str(), static_cast<UINT32>(w.label.size()),
                     f_label_, label_rect, b_text_);

        switch (w.type) {
        case WidgetType::TOGGLE:
            draw_toggle(rt, content_x + content_w - TOGGLE_W,
                        wy + (row_h - TOGGLE_H) * 0.5f, TOGGLE_W,
                        w.bool_ptr ? *w.bool_ptr : false, hovered);
            break;

        case WidgetType::SLIDER: {
            float slider_x = content_x + content_w * 0.45f;
            float slider_w = content_w * 0.38f;
            float val = w.float_ptr ? *w.float_ptr : 0.f;
            bool is_dragging = (dragging_slider_ && drag_slider_idx_ == i);
            draw_slider(rt, slider_x, wy + row_h * 0.5f - SLIDER_H * 0.5f,
                        slider_w, val, w.slider_min, w.slider_max, hovered, is_dragging);

            // value text
            wchar_t buf[32];
            swprintf(buf, 32, L"%.1f%s", val, w.suffix.c_str());
            D2D1_RECT_F val_rect = {content_x + content_w * 0.85f, wy + 6.f,
                                     content_x + content_w, wy + row_h};
            rt->DrawText(buf, static_cast<UINT32>(wcslen(buf)), f_value_, val_rect, b_text_dim_);
            break;
        }

        case WidgetType::KEYBIND: {
            float btn_w = 80.f;
            float btn_x = content_x + content_w - btn_w;
            float btn_y = wy + (row_h - 22.f) * 0.5f;
            bool is_waiting = (waiting_keybind_ && keybind_widget_ == i);
            draw_keybind_button(rt, btn_x, btn_y, btn_w,
                                w.int_ptr ? *w.int_ptr : 0, is_waiting, hovered);
            break;
        }

        default: break;
        }

        wy += row_h;
    }
}

void Menu::draw_toggle(ID2D1RenderTarget* rt, float x, float y, float w,
                       bool on, bool hovered) const {
    float h = TOGGLE_H;
    float r = h * 0.5f;

    // track
    D2D1_ROUNDED_RECT track = {{x, y, x + w, y + h}, r, r};
    rt->FillRoundedRectangle(track, on ? b_toggle_on_ : b_toggle_off_);

    // circle
    float circle_x = on ? (x + w - r) : (x + r);
    float circle_r = r - 3.f;
    D2D1_ELLIPSE circle = {{circle_x, y + r}, circle_r, circle_r};
    rt->FillEllipse(circle, b_text_);

    (void)hovered;
}

void Menu::draw_slider(ID2D1RenderTarget* rt, float x, float y, float w,
                       float val, float mn, float mx_v, bool hovered, bool dragging) const {
    float pct = (mx_v > mn) ? (val - mn) / (mx_v - mn) : 0.f;
    pct = std::clamp(pct, 0.f, 1.f);

    float cy = y + SLIDER_H * 0.5f;

    // track bg
    D2D1_ROUNDED_RECT track = {{x, y, x + w, y + SLIDER_H}, 3.f, 3.f};
    rt->FillRoundedRectangle(track, b_slider_trk_);

    // filled portion
    D2D1_ROUNDED_RECT fill = {{x, y, x + w * pct, y + SLIDER_H}, 3.f, 3.f};
    rt->FillRoundedRectangle(fill, b_slider_fill_);

    // handle
    float hx = x + w * pct;
    float hr = (hovered || dragging) ? HANDLE_R + 1.f : HANDLE_R;
    D2D1_ELLIPSE handle = {{hx, cy}, hr, hr};
    rt->FillEllipse(handle, b_accent_);

    // inner dot
    D2D1_ELLIPSE inner = {{hx, cy}, 3.f, 3.f};
    rt->FillEllipse(inner, b_text_);
}

void Menu::draw_keybind_button(ID2D1RenderTarget* rt, float x, float y, float w,
                               int vk, bool waiting, bool hovered) const {
    D2D1_ROUNDED_RECT btn = {{x, y, x + w, y + 22.f}, 4.f, 4.f};

    if (waiting) {
        rt->FillRoundedRectangle(btn, b_accent_dim_);
        rt->DrawRoundedRectangle(btn, b_accent_, 1.f);
        D2D1_RECT_F tr = {x, y + 3.f, x + w, y + 22.f};
        rt->DrawText(L"press key...", 12, f_small_, tr, b_accent_);
    } else {
        rt->FillRoundedRectangle(btn, hovered ? b_hover_ : b_card_);
        rt->DrawRoundedRectangle(btn, b_border_, 1.f);
        std::wstring kn = vk_name(vk);
        D2D1_RECT_F tr = {x + 4.f, y + 3.f, x + w - 4.f, y + 22.f};
        rt->DrawText(kn.c_str(), static_cast<UINT32>(kn.size()), f_small_, tr, b_text_dim_);
    }
}

void Menu::draw_resize_handle(ID2D1RenderTarget* rt) const {
    float bx = win_x_ + win_w_;
    float by = win_y_ + win_h_;

    for (int i = 0; i < 3; ++i) {
        float off = 4.f + static_cast<float>(i) * 4.f;
        D2D1_POINT_2F a = {bx - off, by - 2.f};
        D2D1_POINT_2F b = {bx - 2.f, by - off};
        rt->DrawLine(a, b, b_text_dim_, 1.f);
    }
}

// ════════════════════════════════════════════════
// vk name
// ════════════════════════════════════════════════

std::wstring Menu::vk_name(int vk) const {
    switch (vk) {
    case VK_LBUTTON:  return L"Mouse 1";
    case VK_RBUTTON:  return L"Mouse 2";
    case VK_MBUTTON:  return L"Mouse 3";
    case VK_XBUTTON1: return L"Mouse 4";
    case VK_XBUTTON2: return L"Mouse 5";
    case VK_SHIFT:    return L"Shift";
    case VK_CONTROL:  return L"Ctrl";
    case VK_MENU:     return L"Alt";
    case VK_INSERT:   return L"Insert";
    case VK_DELETE:   return L"Delete";
    case VK_HOME:     return L"Home";
    case VK_END:      return L"End";
    case VK_CAPITAL:  return L"CapsLock";
    case VK_TAB:      return L"Tab";
    case VK_SPACE:    return L"Space";
    case VK_BACK:     return L"Backspace";
    case VK_RETURN:   return L"Enter";
    case VK_ESCAPE:   return L"Escape";
    case VK_PRIOR:    return L"PgUp";
    case VK_NEXT:     return L"PgDown";
    case VK_LEFT:     return L"Left";
    case VK_RIGHT:    return L"Right";
    case VK_UP:       return L"Up";
    case VK_DOWN:     return L"Down";
    case VK_NUMLOCK:  return L"NumLock";
    case VK_SCROLL:   return L"ScrLock";
    default: {
        if (vk >= 0x30 && vk <= 0x39) return std::wstring(1, static_cast<wchar_t>(vk));
        if (vk >= 0x41 && vk <= 0x5A) return std::wstring(1, static_cast<wchar_t>(vk));
        if (vk >= VK_F1 && vk <= VK_F24) return L"F" + std::to_wstring(vk - VK_F1 + 1);
        if (vk >= VK_NUMPAD0 && vk <= VK_NUMPAD9) return L"Num" + std::to_wstring(vk - VK_NUMPAD0);
        wchar_t buf[8];
        swprintf(buf, 8, L"0x%02X", vk);
        return buf;
    }
    }
}

// ════════════════════════════════════════════════
// cleanup
// ════════════════════════════════════════════════

void Menu::release() {
    auto safe = [](auto*& p) { if (p) { p->Release(); p = nullptr; } };
    safe(b_accent_); safe(b_accent_dim_); safe(b_bg_); safe(b_panel_);
    safe(b_card_); safe(b_text_); safe(b_text_dim_);
    safe(b_toggle_on_); safe(b_toggle_off_);
    safe(b_slider_trk_); safe(b_slider_fill_);
    safe(b_hover_); safe(b_border_);
    safe(b_white_); safe(b_black_);
    safe(f_title_); safe(f_tab_); safe(f_label_);
    safe(f_value_); safe(f_header_); safe(f_small_);
}
