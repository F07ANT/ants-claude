#include "memory.h"
#include "game.h"
#include "overlay.h"
#include "aimbot.h"
#include "esp.h"
#include "config.h"
#include <cstdio>

int WINAPI wWinMain(HINSTANCE, HINSTANCE, LPWSTR, int) {
    Config cfg;
    cfg.load("config.ini");

    Memory mem;
    std::printf("[*] waiting for RainbowSix.exe...\n");
    while (!mem.attach(L"RainbowSix.exe")) {
        Sleep(1000);
        if (GetAsyncKeyState(VK_END) & 0x8000) return 0;
    }
    std::printf("[+] attached pid %lu\n", GetCurrentProcessId());

    Game game(mem);
    Aimbot aimbot;
    ESP esp;
    Overlay overlay;

    if (!overlay.init(game.screen_w(), game.screen_h())) {
        std::printf("[-] overlay init failed\n");
        return 1;
    }

    bool esp_inited = false;

    overlay.set_render_callback([&](ID2D1RenderTarget* rt, IDWriteFactory* dw) {
        if (!esp_inited) {
            esp_inited = esp.init(rt, dw);
        }

        if (!mem.is_attached()) {
            cfg.running = false;
            PostQuitMessage(0);
            return;
        }

        // toggle key
        static bool insert_held = false;
        if (GetAsyncKeyState(cfg.menu_key) & 0x8000) {
            if (!insert_held) {
                cfg.esp_enabled = !cfg.esp_enabled;
                insert_held = true;
            }
        } else {
            insert_held = false;
        }

        // exit key
        if (GetAsyncKeyState(VK_END) & 0x8000) {
            cfg.running = false;
            PostQuitMessage(0);
            return;
        }

        if (!game.refresh()) return;

        aimbot.tick(game, cfg);
        esp.render(rt, game, cfg);
    });

    int ret = overlay.run();

    esp.release();
    overlay.shutdown();
    cfg.save("config.ini");
    mem.detach();

    return ret;
}
