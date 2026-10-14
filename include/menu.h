#pragma once
#include "config.h"
#include <d2d1.h>
#include <dwrite.h>
#include <vector>
#include <string>

enum class ItemType { TOGGLE, SLIDER, KEYBIND, LABEL };

struct MenuItem {
    std::wstring name;
    ItemType type;
    bool* toggle_val     = nullptr;
    float* slider_val    = nullptr;
    float slider_min     = 0.f;
    float slider_max     = 1.f;
    float slider_step    = 1.f;
    int* keybind_val     = nullptr;
};

struct MenuTab {
    std::wstring name;
    std::vector<MenuItem> items;
};

class Menu {
public:
    bool init(ID2D1RenderTarget* rt, IDWriteFactory* dw);
    void render(ID2D1RenderTarget* rt, Config& cfg);
    void handle_input();
    void release();

    bool is_open() const { return open_; }
    void toggle() { open_ = !open_; }

private:
    void build_tabs(Config& cfg);
    void draw_background(ID2D1RenderTarget* rt) const;
    void draw_tabs(ID2D1RenderTarget* rt) const;
    void draw_items(ID2D1RenderTarget* rt) const;
    std::wstring key_name(int vk) const;

    bool open_ = false;
    bool built_ = false;
    bool waiting_keybind_ = false;

    int active_tab_ = 0;
    int active_item_ = 0;

    std::vector<MenuTab> tabs_;

    // rendering
    ID2D1SolidColorBrush* brush_bg_       = nullptr;
    ID2D1SolidColorBrush* brush_panel_    = nullptr;
    ID2D1SolidColorBrush* brush_accent_   = nullptr;
    ID2D1SolidColorBrush* brush_text_     = nullptr;
    ID2D1SolidColorBrush* brush_dim_      = nullptr;
    ID2D1SolidColorBrush* brush_on_       = nullptr;
    ID2D1SolidColorBrush* brush_off_      = nullptr;
    ID2D1SolidColorBrush* brush_slider_   = nullptr;
    IDWriteTextFormat* font_title_        = nullptr;
    IDWriteTextFormat* font_item_         = nullptr;
    IDWriteTextFormat* font_value_        = nullptr;

    // layout
    static constexpr float MENU_X = 60.f;
    static constexpr float MENU_Y = 80.f;
    static constexpr float MENU_W = 420.f;
    static constexpr float TAB_H  = 32.f;
    static constexpr float ITEM_H = 28.f;
    static constexpr float PAD    = 12.f;
};
