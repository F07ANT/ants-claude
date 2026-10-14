cmake_minimum_required(VERSION 3.20)
project(r6_ext LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(MSVC)
    add_compile_options(/W4 /permissive-)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

add_executable(r6_ext
    src/main.cpp
    src/memory.cpp
    src/game.cpp
    src/overlay.cpp
    src/aimbot.cpp
    src/esp.cpp
    src/config.cpp
    src/menu.cpp
)

target_include_directories(r6_ext PRIVATE include)
target_link_libraries(r6_ext PRIVATE d2d1 dwrite dwmapi ole32 uuid)
