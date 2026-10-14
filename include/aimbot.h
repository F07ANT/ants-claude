#pragma once
#include "game.h"
#include "config.h"

class Aimbot {
public:
    void tick(const Game& game, const Config& cfg);

private:
    int find_target(const Game& game, const Config& cfg) const;
    void move_mouse(Vec2 delta, float smooth) const;
};
