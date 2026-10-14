#pragma once
#include "memory.h"
#include "vec.h"
#include <vector>
#include <string>

// FILL: these shift every patch — dump them with ReClass/CE on your build
namespace offsets {
    // game manager
    constexpr uintptr_t GAME_MANAGER       = 0x0; // FILL: sig scan or pointer scan
    constexpr uintptr_t ENTITY_LIST        = 0x0; // FILL
    constexpr uintptr_t ENTITY_COUNT       = 0x0; // FILL

    // entity / pawn
    constexpr uintptr_t ENTITY_PAWN        = 0x0; // FILL
    constexpr uintptr_t PAWN_HEALTH        = 0x0; // FILL
    constexpr uintptr_t PAWN_TEAM          = 0x0; // FILL
    constexpr uintptr_t PAWN_HEAD_POS      = 0x0; // FILL
    constexpr uintptr_t PAWN_FEET_POS      = 0x0; // FILL
    constexpr uintptr_t PAWN_NAME          = 0x0; // FILL

    // camera / view matrix
    constexpr uintptr_t VIEW_MATRIX        = 0x0; // FILL
    constexpr uintptr_t LOCAL_PLAYER       = 0x0; // FILL

    // recoil / weapon
    constexpr uintptr_t WEAPON_RECOIL_X    = 0x0; // FILL
    constexpr uintptr_t WEAPON_RECOIL_Y    = 0x0; // FILL
}

struct EntityData {
    Vec3 head;
    Vec3 feet;
    int health;
    int team;
    bool alive;
    char name[64];
};

class Game {
public:
    explicit Game(Memory& mem);

    bool refresh();

    const std::vector<EntityData>& entities() const { return entities_; }
    const EntityData& local_player() const { return local_; }
    const Matrix4x4& view_matrix() const { return view_matrix_; }
    int local_team() const { return local_.team; }
    int screen_w() const { return screen_w_; }
    int screen_h() const { return screen_h_; }

    bool world_to_screen(const Vec3& world, Vec2& screen) const;

private:
    Memory& mem_;
    uintptr_t base_ = 0;
    Matrix4x4 view_matrix_{};
    EntityData local_{};
    std::vector<EntityData> entities_;
    int screen_w_ = 1920;
    int screen_h_ = 1080;
};
