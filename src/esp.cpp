#include "esp.h"
#include <cstdio>

bool ESP::init(ID2D1RenderTarget* rt, IDWriteFactory* dw) {
    HRESULT hr;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(1.f, 0.2f, 0.2f, 1.f), &brush_enemy_);
    if (FAILED(hr)) return false;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.2f, 0.6f, 1.f, 1.f), &brush_team_);
    if (FAILED(hr)) return false;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(0.2f, 1.f, 0.2f, 1.f), &brush_green_);
    if (FAILED(hr)) return false;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(1.f, 0.2f, 0.2f, 1.f), &brush_red_);
    if (FAILED(hr)) return false;

    hr = rt->CreateSolidColorBrush(D2D1::ColorF(1.f, 1.f, 1.f, 1.f), &brush_white_);
    if (FAILED(hr)) return false;

    hr = dw->CreateTextFormat(L"Consolas", nullptr,
        DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL,
        12.f, L"en-us", &text_fmt_);
    if (FAILED(hr)) return false;

    return true;
}

void ESP::render(ID2D1RenderTarget* rt, const Game& game, const Config& cfg) {
    if (!cfg.esp_enabled) return;

    for (const auto& ent : game.entities()) {
        if (!ent.alive) continue;
        if (!cfg.esp_team && ent.team == game.local_team()) continue;

        Vec2 head_screen, feet_screen;
        if (!game.world_to_screen(ent.head, head_screen)) continue;
        if (!game.world_to_screen(ent.feet, feet_screen)) continue;

        bool is_enemy = ent.team != game.local_team();
        auto* brush = is_enemy ? brush_enemy_ : brush_team_;

        if (cfg.esp_box)
            draw_box(rt, head_screen, feet_screen, brush);

        if (cfg.esp_health)
            draw_health_bar(rt, head_screen, feet_screen, ent.health, brush_green_, brush_red_);

        if (cfg.esp_snapline)
            draw_snapline(rt, feet_screen, game.screen_w(), game.screen_h(), brush);

        if (cfg.esp_name || cfg.esp_distance) {
            char info[128]{};
            float dist = game.local_player().head.distance(ent.head);

            if (cfg.esp_name && cfg.esp_distance)
                std::snprintf(info, sizeof(info), "%s [%.0fm]", ent.name, dist);
            else if (cfg.esp_name)
                std::snprintf(info, sizeof(info), "%s", ent.name);
            else
                std::snprintf(info, sizeof(info), "[%.0fm]", dist);

            // convert to wide
            wchar_t winfo[128]{};
            MultiByteToWideChar(CP_UTF8, 0, info, -1, winfo, 128);

            float box_h = feet_screen.y - head_screen.y;
            float box_w = box_h * 0.5f;
            D2D1_RECT_F text_rect = {
                head_screen.x - box_w * 0.5f,
                head_screen.y - 16.f,
                head_screen.x + box_w * 0.5f,
                head_screen.y
            };
            rt->DrawText(winfo, static_cast<UINT32>(wcslen(winfo)),
                         text_fmt_, text_rect, brush_white_);
        }
    }
}

void ESP::draw_box(ID2D1RenderTarget* rt, Vec2 head_screen, Vec2 feet_screen,
                   ID2D1SolidColorBrush* brush) const {
    float h = feet_screen.y - head_screen.y;
    float w = h * 0.5f;

    D2D1_RECT_F rect = {
        head_screen.x - w * 0.5f,
        head_screen.y,
        head_screen.x + w * 0.5f,
        feet_screen.y
    };

    rt->DrawRectangle(rect, brush, 1.5f);
}

void ESP::draw_health_bar(ID2D1RenderTarget* rt, Vec2 head_screen, Vec2 feet_screen,
                          int health, ID2D1SolidColorBrush* green, ID2D1SolidColorBrush* red) const {
    float h = feet_screen.y - head_screen.y;
    float w = h * 0.5f;
    float bar_w = 3.f;

    float x = head_screen.x - w * 0.5f - bar_w - 2.f;
    float hp_ratio = static_cast<float>(health) / 100.f;
    if (hp_ratio < 0.f) hp_ratio = 0.f;
    if (hp_ratio > 1.f) hp_ratio = 1.f;

    // background (damage taken)
    D2D1_RECT_F bg = {x, head_screen.y, x + bar_w, feet_screen.y};
    rt->FillRectangle(bg, red);

    // health fill from bottom
    float fill_h = h * hp_ratio;
    D2D1_RECT_F fg = {x, feet_screen.y - fill_h, x + bar_w, feet_screen.y};
    rt->FillRectangle(fg, green);
}

void ESP::draw_snapline(ID2D1RenderTarget* rt, Vec2 target, int screen_w, int screen_h,
                        ID2D1SolidColorBrush* brush) const {
    D2D1_POINT_2F from = {static_cast<float>(screen_w) * 0.5f, static_cast<float>(screen_h)};
    D2D1_POINT_2F to = {target.x, target.y};
    rt->DrawLine(from, to, brush, 1.f);
}

void ESP::release() {
    auto safe_release = [](auto*& p) { if (p) { p->Release(); p = nullptr; } };
    safe_release(brush_enemy_);
    safe_release(brush_team_);
    safe_release(brush_green_);
    safe_release(brush_red_);
    safe_release(brush_white_);
    safe_release(text_fmt_);
}
