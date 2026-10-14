#include "memory.h"
#include "game.h"
#include "overlay.h"
#include "aimbot.h"
#include "esp.h"
#include "menu.h"
#include "config.h"
#include <cstdio>

int main() {
    SetConsoleTitleW(L"R6 External");

    std::printf("=============================\n");
    std::printf("  R6 External  -  by odil9\n");
    std::printf("  press END to quit anytime\n");
    std::printf("=============================\n\n");

    Config cfg;
    cfg.load("config.ini");

    Memory mem;
    std::printf("[*] waiting for RainbowSix.exe...\n");
    std::printf("[*] start the game, this will attach automatically\n");
    while (!mem.attach(L"RainbowSix.exe")) {
        Sleep(1000);
        if (GetAsyncKeyState(VK_END) & 0x8000) return 0;
    }
    std::printf("[+] attached (mode: %s)\n",
                mem.mode() == ReadMode::DRIVER ? "KERNEL" : "RPM");
    std::printf("[+] launching overlay... press INSERT for menu\n");

    Game game(mem);
    Aimbot aimbot;
    ESP esp;
    Menu menu;
    Overlay overlay;

    if (!overlay.init(game.screen_w(), game.screen_h())) {
        std::printf("[-] overlay init failed\n");
        return 1;
    }

    bool esp_inited = false;
    bool menu_inited = false;

    overlay.set_render_callback([&](ID2D1RenderTarget* rt, IDWriteFactory* dw) {
        if (!esp_inited) esp_inited = esp.init(rt, dw);
        if (!menu_inited) menu_inited = menu.init(rt, dw);

        if (!mem.is_attached()) {
            cfg.running = false;
            PostQuitMessage(0);
            return;
        }

        static bool menu_held = false;
        if (GetAsyncKeyState(cfg.menu_key) & 0x8000) {
            if (!menu_held) {
                menu.toggle();
                menu_held = true;
            }
        } else {
            menu_held = false;
        }

        if (GetAsyncKeyState(VK_END) & 0x8000) {
            cfg.running = false;
            PostQuitMessage(0);
            return;
        }

        if (!game.refresh()) return;

        aimbot.tick(game, cfg);
        esp.render(rt, game, cfg);
        menu.render(rt, cfg);
    });

    int ret = overlay.run();

    menu.release();
    esp.release();
    overlay.shutdown();
    cfg.save("config.ini");
    mem.detach();

    return ret;
}
