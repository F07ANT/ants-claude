#include "game.h"
#include <cstring>

Game::Game(Memory& mem) : mem_(mem) {
    RECT desktop;
    if (GetWindowRect(GetDesktopWindow(), &desktop)) {
        screen_w_ = desktop.right;
        screen_h_ = desktop.bottom;
    }
}

bool Game::refresh() {
    base_ = mem_.get_module_base(L"RainbowSix.exe");
    if (!base_) return false;

    // view matrix
    if (!mem_.read(base_ + offsets::VIEW_MATRIX, view_matrix_))
        return false;

    // local player
    uintptr_t local_ptr = mem_.read<uintptr_t>(base_ + offsets::LOCAL_PLAYER);
    if (!local_ptr) return false;

    local_.health = mem_.read<int>(local_ptr + offsets::PAWN_HEALTH);
    local_.team   = mem_.read<int>(local_ptr + offsets::PAWN_TEAM);
    mem_.read(local_ptr + offsets::PAWN_HEAD_POS, local_.head);
    mem_.read(local_ptr + offsets::PAWN_FEET_POS, local_.feet);
    local_.alive = local_.health > 0;

    // entity list
    uintptr_t manager = mem_.read<uintptr_t>(base_ + offsets::GAME_MANAGER);
    if (!manager) return false;

    int count = mem_.read<int>(manager + offsets::ENTITY_COUNT);
    if (count <= 0 || count > 64) count = 0;

    uintptr_t list_base = mem_.read<uintptr_t>(manager + offsets::ENTITY_LIST);
    if (!list_base) { entities_.clear(); return true; }

    entities_.clear();
    entities_.reserve(count);

    for (int i = 0; i < count; ++i) {
        uintptr_t ent = mem_.read<uintptr_t>(list_base + i * sizeof(uintptr_t));
        if (!ent) continue;

        uintptr_t pawn = mem_.read<uintptr_t>(ent + offsets::ENTITY_PAWN);
        if (!pawn) continue;

        EntityData e{};
        e.health = mem_.read<int>(pawn + offsets::PAWN_HEALTH);
        e.team   = mem_.read<int>(pawn + offsets::PAWN_TEAM);
        e.alive  = e.health > 0;
        mem_.read(pawn + offsets::PAWN_HEAD_POS, e.head);
        mem_.read(pawn + offsets::PAWN_FEET_POS, e.feet);

        uintptr_t name_ptr = mem_.read<uintptr_t>(pawn + offsets::PAWN_NAME);
        if (name_ptr) {
            char buf[64]{};
            ReadProcessMemory(GetCurrentProcess(), reinterpret_cast<LPCVOID>(name_ptr),
                              buf, sizeof(buf) - 1, nullptr);
            std::memcpy(e.name, buf, sizeof(e.name));
        }

        entities_.push_back(e);
    }

    return true;
}

bool Game::world_to_screen(const Vec3& world, Vec2& screen) const {
    const auto& m = view_matrix_.m;

    float w = m[0][3] * world.x + m[1][3] * world.y + m[2][3] * world.z + m[3][3];
    if (w < 0.001f) return false;

    float inv_w = 1.f / w;
    float sx = m[0][0] * world.x + m[1][0] * world.y + m[2][0] * world.z + m[3][0];
    float sy = m[0][1] * world.x + m[1][1] * world.y + m[2][1] * world.z + m[3][1];

    screen.x = (screen_w_ * 0.5f) + (sx * inv_w) * (screen_w_ * 0.5f);
    screen.y = (screen_h_ * 0.5f) - (sy * inv_w) * (screen_h_ * 0.5f);

    return true;
}
