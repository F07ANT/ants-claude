#pragma once
#include "game.h"
#include "config.h"
#include <d2d1.h>
#include <dwrite.h>

class ESP {
public:
    bool init(ID2D1RenderTarget* rt, IDWriteFactory* dw);
    void render(ID2D1RenderTarget* rt, const Game& game, const Config& cfg);
    void release();

private:
    void draw_box(ID2D1RenderTarget* rt, Vec2 head_screen, Vec2 feet_screen,
                  ID2D1SolidColorBrush* brush) const;
    void draw_health_bar(ID2D1RenderTarget* rt, Vec2 head_screen, Vec2 feet_screen,
                         int health, ID2D1SolidColorBrush* green, ID2D1SolidColorBrush* red) const;
    void draw_snapline(ID2D1RenderTarget* rt, Vec2 target, int screen_w, int screen_h,
                       ID2D1SolidColorBrush* brush) const;

    ID2D1SolidColorBrush* brush_enemy_ = nullptr;
    ID2D1SolidColorBrush* brush_team_ = nullptr;
    ID2D1SolidColorBrush* brush_green_ = nullptr;
    ID2D1SolidColorBrush* brush_red_ = nullptr;
    ID2D1SolidColorBrush* brush_white_ = nullptr;
    IDWriteTextFormat* text_fmt_ = nullptr;
};
