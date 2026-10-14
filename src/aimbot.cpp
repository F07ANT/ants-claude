#include "aimbot.h"
#include <cmath>
#include <limits>

void Aimbot::tick(const Game& game, const Config& cfg) {
    if (!cfg.aim_enabled) return;
    if (!(GetAsyncKeyState(cfg.aim_key) & 0x8000)) return;

    int target = find_target(game, cfg);
    if (target < 0) return;

    const auto& ent = game.entities()[target];
    Vec3 target_pos = cfg.aim_head_only ? ent.head : ent.feet;

    Vec2 screen_target;
    if (!game.world_to_screen(target_pos, screen_target)) return;

    float cx = static_cast<float>(game.screen_w()) * 0.5f;
    float cy = static_cast<float>(game.screen_h()) * 0.5f;

    Vec2 delta = {screen_target.x - cx, screen_target.y - cy};
    move_mouse(delta, cfg.aim_smooth);
}

int Aimbot::find_target(const Game& game, const Config& cfg) const {
    float cx = static_cast<float>(game.screen_w()) * 0.5f;
    float cy = static_cast<float>(game.screen_h()) * 0.5f;

    int best = -1;
    float best_dist = std::numeric_limits<float>::max();

    for (int i = 0; i < static_cast<int>(game.entities().size()); ++i) {
        const auto& e = game.entities()[i];
        if (!e.alive) continue;
        if (e.team == game.local_team()) continue;

        Vec2 screen_pos;
        Vec3 aim_point = cfg.aim_head_only ? e.head : e.feet;
        if (!game.world_to_screen(aim_point, screen_pos)) continue;

        float dx = screen_pos.x - cx;
        float dy = screen_pos.y - cy;
        float dist = sqrtf(dx * dx + dy * dy);

        if (dist > cfg.aim_fov) continue;
        if (dist < best_dist) {
            best_dist = dist;
            best = i;
        }
    }

    return best;
}

void Aimbot::move_mouse(Vec2 delta, float smooth) const {
    if (smooth < 1.f) smooth = 1.f;

    int move_x = static_cast<int>(delta.x / smooth);
    int move_y = static_cast<int>(delta.y / smooth);

    if (move_x == 0 && move_y == 0) return;

    INPUT input{};
    input.type = INPUT_MOUSE;
    input.mi.dx = move_x;
    input.mi.dy = move_y;
    input.mi.dwFlags = MOUSEEVENTF_MOVE;
    SendInput(1, &input, sizeof(INPUT));
}
