#pragma once
#include <windows.h>
#include <string>

struct Config {
    // aimbot
    bool aim_enabled     = true;
    int  aim_key         = VK_RBUTTON;
    float aim_fov        = 120.f;
    float aim_smooth     = 5.f;
    bool aim_head_only   = true;

    // esp
    bool esp_enabled     = true;
    bool esp_box         = true;
    bool esp_health      = true;
    bool esp_name        = true;
    bool esp_distance    = true;
    bool esp_snapline    = false;
    bool esp_team        = false;

    // misc
    int  menu_key        = VK_INSERT;
    bool running         = true;

    void load(const std::string& path);
    void save(const std::string& path) const;
};
