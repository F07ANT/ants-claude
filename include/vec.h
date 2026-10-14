#pragma once
#include <cmath>

struct Vec2 {
    float x = 0.f, y = 0.f;

    float length() const { return std::sqrtf(x * x + y * y); }
    Vec2 operator-(const Vec2& o) const { return {x - o.x, y - o.y}; }
    Vec2 operator+(const Vec2& o) const { return {x + o.x, y + o.y}; }
    Vec2 operator*(float s) const { return {x * s, y * s}; }
};

struct Vec3 {
    float x = 0.f, y = 0.f, z = 0.f;

    float length() const { return std::sqrtf(x * x + y * y + z * z); }
    float distance(const Vec3& o) const { return (*this - o).length(); }
    Vec3 operator-(const Vec3& o) const { return {x - o.x, y - o.y, z - o.z}; }
    Vec3 operator+(const Vec3& o) const { return {x + o.x, y + o.y, z + o.z}; }
    Vec3 operator*(float s) const { return {x * s, y * s, z * s}; }
};

struct Matrix4x4 {
    float m[4][4]{};
};
