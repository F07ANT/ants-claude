#include "config.h"
#include <fstream>
#include <sstream>
#include <algorithm>
#include <unordered_map>

static std::string trim(const std::string& s) {
    auto start = s.find_first_not_of(" \t\r\n");
    if (start == std::string::npos) return "";
    auto end = s.find_last_not_of(" \t\r\n");
    return s.substr(start, end - start + 1);
}

void Config::load(const std::string& path) {
    std::ifstream file(path);
    if (!file.is_open()) return;

    std::unordered_map<std::string, std::string> kv;
    std::string line;
    while (std::getline(file, line)) {
        line = trim(line);
        if (line.empty() || line[0] == '#' || line[0] == ';') continue;
        auto eq = line.find('=');
        if (eq == std::string::npos) continue;
        kv[trim(line.substr(0, eq))] = trim(line.substr(eq + 1));
    }

    auto get_bool = [&](const std::string& key, bool& val) {
        auto it = kv.find(key);
        if (it != kv.end()) val = (it->second == "1" || it->second == "true");
    };
    auto get_float = [&](const std::string& key, float& val) {
        auto it = kv.find(key);
        if (it != kv.end()) val = std::stof(it->second);
    };
    auto get_int = [&](const std::string& key, int& val) {
        auto it = kv.find(key);
        if (it != kv.end()) val = std::stoi(it->second);
    };

    get_bool("aim_enabled", aim_enabled);
    get_int("aim_key", aim_key);
    get_float("aim_fov", aim_fov);
    get_float("aim_smooth", aim_smooth);
    get_bool("aim_head_only", aim_head_only);

    get_bool("esp_enabled", esp_enabled);
    get_bool("esp_box", esp_box);
    get_bool("esp_health", esp_health);
    get_bool("esp_name", esp_name);
    get_bool("esp_distance", esp_distance);
    get_bool("esp_snapline", esp_snapline);
    get_bool("esp_team", esp_team);

    get_int("menu_key", menu_key);
}

void Config::save(const std::string& path) const {
    std::ofstream file(path);
    if (!file.is_open()) return;

    auto wb = [&](const char* key, bool val) { file << key << " = " << (val ? "true" : "false") << "\n"; };
    auto wf = [&](const char* key, float val) { file << key << " = " << val << "\n"; };
    auto wi = [&](const char* key, int val) { file << key << " = " << val << "\n"; };

    file << "# R6 External Config\n\n";
    file << "[aimbot]\n";
    wb("aim_enabled", aim_enabled);
    wi("aim_key", aim_key);
    wf("aim_fov", aim_fov);
    wf("aim_smooth", aim_smooth);
    wb("aim_head_only", aim_head_only);

    file << "\n[esp]\n";
    wb("esp_enabled", esp_enabled);
    wb("esp_box", esp_box);
    wb("esp_health", esp_health);
    wb("esp_name", esp_name);
    wb("esp_distance", esp_distance);
    wb("esp_snapline", esp_snapline);
    wb("esp_team", esp_team);

    file << "\n[misc]\n";
    wi("menu_key", menu_key);
}
