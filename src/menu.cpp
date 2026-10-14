#include "menu.h"
#include <cstdio>

bool Menu::init(ID2D1RenderTarget* rt, IDWriteFactory* dw) {
    HRESULT hr;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.05f, 0.05f, 0.08f, 0.92f), &brush_bg_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.10f, 0.10f, 0.14f, 0.95f), &brush_panel_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.55f, 0.35f, 1.0f, 1.0f), &brush_accent_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(1.f, 1.f, 1.f, 0.95f), &brush_text_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.5f, 0.5f, 0.55f, 0.8f), &brush_dim_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.3f, 0.9f, 0.4f, 1.f), &brush_on_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.7f, 0.2f, 0.2f, 1.f), &brush_off_);
    if (FAILED(hr)) return false;
    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.55f, 0.35f, 1.0f, 0.6f), &brush_slider_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_BOLD, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        15.f, L"en-us", &font_title_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Segoe UI", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        13.f, L"en-us", &font_item_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Consolas", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        12.f, L"en-us", &font_value_);
    if (FAILED(hr)) return false;

    font_value_->SetTextAlignment(DWRITE_TEXT_ALIGNMENT_TRAILING);

    return true;
}

void Menu::build_tabs(Config& cfg) {
    tabs_.clear();

    // aimbot tab
    MenuTab aim;
    aim.name = L"AIMBOT";
    aim.items.push_back({L"Enabled",    ItemType::TOGGLE, &cfg.aim_enabled});
    aim.items.push_back({L"Aim Key",    ItemType::KEYBIND, nullptr, nullptr, 0, 0, 0, &cfg.aim_key});
    aim.items.push_back({L"FOV",        ItemType::SLIDER, nullptr, &cfg.aim_fov, 10.f, 500.f, 5.f});
    aim.items.push_back({L"Smoothing",  ItemType::SLIDER, nullptr, &cfg.aim_smooth, 1.f, 20.f, 0.5f});
    aim.items.push_back({L"Head Only",  ItemType::TOGGLE, &cfg.aim_head_only});
    tabs_.push_back(std::move(aim));

    // ESP tab
    MenuTab esp;
    esp.name = L"ESP";
    esp.items.push_back({L"Enabled",    ItemType::TOGGLE, &cfg.esp_enabled});
    esp.items.push_back({L"Boxes",      ItemType::TOGGLE, &cfg.esp_box});
    esp.items.push_back({L"Health Bar", ItemType::TOGGLE, &cfg.esp_health});
    esp.items.push_back({L"Names",      ItemType::TOGGLE, &cfg.esp_name});
    esp.items.push_back({L"Distance",   ItemType::TOGGLE, &cfg.esp_distance});
    esp.items.push_back({L"Snaplines",  ItemType::TOGGLE, &cfg.esp_snapline});
    esp.items.push_back({L"Show Team",  ItemType::TOGGLE, &cfg.esp_team});
    tabs_.push_back(std::move(esp));

    // misc tab
    MenuTab misc;
    misc.name = L"MISC";
    misc.items.push_back({L"Menu Key",  ItemType::KEYBIND, nullptr, nullptr, 0, 0, 0, &cfg.menu_key});
    misc.items.push_back({L"",          ItemType::LABEL});
    misc.items.push_back({L"[arrows] navigate",    ItemType::LABEL});
    misc.items.push_back({L"[enter]  toggle/set",   ItemType::LABEL});
    misc.items.push_back({L"[left/right] adjust",   ItemType::LABEL});
    misc.items.push_back({L"[END] exit",             ItemType::LABEL});
    tabs_.push_back(std::move(misc));

    built_ = true;
}

void Menu::handle_input() {
    if (!open_) return;

    static bool key_up = false, key_down = false, key_left = false, key_right = false, key_enter = false;

    auto pressed = [](int vk, bool& state) -> bool {
        if (GetAsyncKeyState(vk) & 0x8000) {
            if (!state) { state = true; return true; }
        } else { state = false; }
        return false;
    };

    if (tabs_.empty()) return;
    auto& tab = tabs_[active_tab_];

    // keybind capture mode
    if (waiting_keybind_) {
        for (int vk = 1; vk < 256; ++vk) {
            if (vk == VK_ESCAPE) {
                if (GetAsyncKeyState(vk) & 0x8000) { waiting_keybind_ = false; return; }
                continue;
            }
            if (GetAsyncKeyState(vk) & 0x8000) {
                auto& item = tab.items[active_item_];
                if (item.keybind_val) *item.keybind_val = vk;
                waiting_keybind_ = false;
                return;
            }
        }
        return;
    }

    // tab switch with left/right at top-level when on first item
    if (pressed(VK_LEFT, key_left)) {
        auto& item = tab.items[active_item_];
        if (item.type == ItemType::SLIDER && item.slider_val) {
            *item.slider_val -= item.slider_step;
            if (*item.slider_val < item.slider_min) *item.slider_val = item.slider_min;
        } else {
            active_tab_ = (active_tab_ - 1 + static_cast<int>(tabs_.size())) % static_cast<int>(tabs_.size());
            active_item_ = 0;
        }
    }

    if (pressed(VK_RIGHT, key_right)) {
        auto& item = tab.items[active_item_];
        if (item.type == ItemType::SLIDER && item.slider_val) {
            *item.slider_val += item.slider_step;
            if (*item.slider_val > item.slider_max) *item.slider_val = item.slider_max;
        } else {
            active_tab_ = (active_tab_ + 1) % static_cast<int>(tabs_.size());
            active_item_ = 0;
        }
    }

    if (pressed(VK_UP, key_up)) {
        active_item_--;
        // skip labels
        while (active_item_ >= 0 && tab.items[active_item_].type == ItemType::LABEL && tab.items[active_item_].name.empty())
            active_item_--;
        if (active_item_ < 0) active_item_ = static_cast<int>(tab.items.size()) - 1;
    }

    if (pressed(VK_DOWN, key_down)) {
        active_item_++;
        if (active_item_ >= static_cast<int>(tab.items.size())) active_item_ = 0;
        // skip empty labels
        while (active_item_ < static_cast<int>(tab.items.size()) && tab.items[active_item_].type == ItemType::LABEL && tab.items[active_item_].name.empty())
            active_item_++;
        if (active_item_ >= static_cast<int>(tab.items.size())) active_item_ = 0;
    }

    if (pressed(VK_RETURN, key_enter)) {
        auto& item = tab.items[active_item_];
        if (item.type == ItemType::TOGGLE && item.toggle_val) {
            *item.toggle_val = !*item.toggle_val;
        } else if (item.type == ItemType::KEYBIND) {
            waiting_keybind_ = true;
        }
    }
}

void Menu::render(ID2D1RenderTarget* rt, Config& cfg) {
    if (!built_) build_tabs(cfg);
    if (!open_) return;

    handle_input();
    draw_background(rt);
    draw_tabs(rt);
    draw_items(rt);
}

void Menu::draw_background(ID2D1RenderTarget* rt) const {
    float total_items = 0;
    if (!tabs_.empty()) total_items = static_cast<float>(tabs_[active_tab_].items.size());
    float menu_h = TAB_H + PAD * 3.f + total_items * ITEM_H + 20.f;

    // outer shadow
    D2D1_ROUNDED_RECT outer = {
        {MENU_X - 2.f, MENU_Y - 2.f, MENU_X + MENU_W + 2.f, MENU_Y + menu_h + 2.f},
        6.f, 6.f
    };
    rt->FillRoundedRectangle(outer, brush_panel_);

    // main background
    D2D1_ROUNDED_RECT bg = {
        {MENU_X, MENU_Y, MENU_X + MENU_W, MENU_Y + menu_h},
        4.f, 4.f
    };
    rt->FillRoundedRectangle(bg, brush_bg_);

    // title bar accent line
    D2D1_RECT_F accent_line = {MENU_X, MENU_Y, MENU_X + MENU_W, MENU_Y + 3.f};
    rt->FillRectangle(accent_line, brush_accent_);

    // title
    D2D1_RECT_F title_rect = {MENU_X + PAD, MENU_Y + 6.f, MENU_X + MENU_W - PAD, MENU_Y + TAB_H};
    rt->DrawText(L"R6 EXTERNAL", 11, font_title_, title_rect, brush_accent_);
}

void Menu::draw_tabs(ID2D1RenderTarget* rt) const {
    float tab_y = MENU_Y + TAB_H + 4.f;
    float tab_w = (MENU_W - PAD * 2.f) / static_cast<float>(tabs_.size());

    for (int i = 0; i < static_cast<int>(tabs_.size()); ++i) {
        float tx = MENU_X + PAD + tab_w * static_cast<float>(i);
        D2D1_RECT_F tab_rect = {tx, tab_y, tx + tab_w, tab_y + TAB_H - 4.f};

        bool active = (i == active_tab_);
        auto* brush = active ? brush_accent_ : brush_dim_;

        rt->DrawText(tabs_[i].name.c_str(), static_cast<UINT32>(tabs_[i].name.size()),
                     font_title_, tab_rect, brush);

        if (active) {
            D2D1_RECT_F underline = {tx, tab_y + TAB_H - 6.f, tx + tab_w, tab_y + TAB_H - 4.f};
            rt->FillRectangle(underline, brush_accent_);
        }
    }
}

void Menu::draw_items(ID2D1RenderTarget* rt) const {
    if (tabs_.empty()) return;
    const auto& tab = tabs_[active_tab_];

    float start_y = MENU_Y + TAB_H * 2.f + PAD;

    for (int i = 0; i < static_cast<int>(tab.items.size()); ++i) {
        const auto& item = tab.items[i];
        float iy = start_y + static_cast<float>(i) * ITEM_H;
        bool selected = (i == active_item_);

        // highlight bar
        if (selected && item.type != ItemType::LABEL) {
            D2D1_RECT_F sel_rect = {
                MENU_X + PAD - 4.f, iy,
                MENU_X + MENU_W - PAD + 4.f, iy + ITEM_H - 2.f
            };
            rt->FillRectangle(sel_rect, brush_panel_);

            // left accent mark
            D2D1_RECT_F mark = {MENU_X + PAD - 4.f, iy + 4.f, MENU_X + PAD - 1.f, iy + ITEM_H - 6.f};
            rt->FillRectangle(mark, brush_accent_);
        }

        D2D1_RECT_F name_rect = {
            MENU_X + PAD + 8.f, iy,
            MENU_X + MENU_W * 0.6f, iy + ITEM_H
        };

        D2D1_RECT_F val_rect = {
            MENU_X + MENU_W * 0.6f, iy,
            MENU_X + MENU_W - PAD, iy + ITEM_H
        };

        auto* name_brush = (item.type == ItemType::LABEL) ? brush_dim_ : brush_text_;
        if (!item.name.empty()) {
            rt->DrawText(item.name.c_str(), static_cast<UINT32>(item.name.size()),
                         font_item_, name_rect, name_brush);
        }

        switch (item.type) {
        case ItemType::TOGGLE: {
            if (!item.toggle_val) break;
            bool on = *item.toggle_val;
            const wchar_t* label = on ? L"ON" : L"OFF";
            auto* vbrush = on ? brush_on_ : brush_off_;
            rt->DrawText(label, on ? 2 : 3, font_value_, val_rect, vbrush);
            break;
        }
        case ItemType::SLIDER: {
            if (!item.slider_val) break;
            float val = *item.slider_val;
            float pct = (val - item.slider_min) / (item.slider_max - item.slider_min);

            // slider track
            float sx = MENU_X + MENU_W * 0.6f;
            float sw = MENU_W * 0.25f;
            float sy = iy + ITEM_H * 0.5f - 2.f;

            D2D1_RECT_F track = {sx, sy, sx + sw, sy + 4.f};
            rt->FillRectangle(track, brush_panel_);

            D2D1_RECT_F fill = {sx, sy, sx + sw * pct, sy + 4.f};
            rt->FillRectangle(fill, brush_accent_);

            // value text
            wchar_t buf[16];
            swprintf(buf, 16, L"%.1f", val);
            D2D1_RECT_F num_rect = {sx + sw + 4.f, iy, MENU_X + MENU_W - PAD, iy + ITEM_H};
            rt->DrawText(buf, static_cast<UINT32>(wcslen(buf)), font_value_, num_rect, brush_text_);
            break;
        }
        case ItemType::KEYBIND: {
            if (!item.keybind_val) break;
            if (waiting_keybind_ && selected) {
                rt->DrawText(L"[...]", 5, font_value_, val_rect, brush_accent_);
            } else {
                std::wstring kn = key_name(*item.keybind_val);
                rt->DrawText(kn.c_str(), static_cast<UINT32>(kn.size()),
                             font_value_, val_rect, brush_dim_);
            }
            break;
        }
        case ItemType::LABEL:
            break;
        }
    }
}

std::wstring Menu::key_name(int vk) const {
    switch (vk) {
    case VK_LBUTTON:  return L"MOUSE1";
    case VK_RBUTTON:  return L"MOUSE2";
    case VK_MBUTTON:  return L"MOUSE3";
    case VK_XBUTTON1: return L"MOUSE4";
    case VK_XBUTTON2: return L"MOUSE5";
    case VK_SHIFT:    return L"SHIFT";
    case VK_CONTROL:  return L"CTRL";
    case VK_MENU:     return L"ALT";
    case VK_INSERT:   return L"INSERT";
    case VK_DELETE:   return L"DELETE";
    case VK_HOME:     return L"HOME";
    case VK_END:      return L"END";
    case VK_CAPITAL:  return L"CAPSLOCK";
    case VK_TAB:      return L"TAB";
    case VK_SPACE:    return L"SPACE";
    default: {
        if (vk >= 0x30 && vk <= 0x39) return std::wstring(1, static_cast<wchar_t>(vk));
        if (vk >= 0x41 && vk <= 0x5A) return std::wstring(1, static_cast<wchar_t>(vk));
        if (vk >= VK_F1 && vk <= VK_F12) {
            return L"F" + std::to_wstring(vk - VK_F1 + 1);
        }
        wchar_t buf[8];
        swprintf(buf, 8, L"0x%02X", vk);
        return buf;
    }
    }
}

void Menu::release() {
    auto safe = [](auto*& p) { if (p) { p->Release(); p = nullptr; } };
    safe(brush_bg_);
    safe(brush_panel_);
    safe(brush_accent_);
    safe(brush_text_);
    safe(brush_dim_);
    safe(brush_on_);
    safe(brush_off_);
    safe(brush_slider_);
    safe(font_title_);
    safe(font_item_);
    safe(font_value_);
}
