--// ═══════════════════════════════════════════════════════════════════
--// AXIOM UNIVERSAL SUITE v3.1 — FULL BUILD
--// Maximum Executor Compatibility
--// Synapse X | Fluxus | Hydrogen | Delta | Arceus | Solara | Wave | AWP
--// ═══════════════════════════════════════════════════════════════════
--// MODULES:
--//   Silent Aim | Aimbot (Smoothed) | FOV Circle | FOV Changer
--//   Box ESP | Name ESP | Health Bar | Distance | Tracers | Snaplines
--//   Skeleton ESP (R6/R15) | Chams (Standard/Neon/Rainbow)
--//   Item ESP | Crosshair | Watermark | FPS Counter
--//   Full Tabbed GUI | Color Pickers | Menu Scaling | Keybinds
--// ═══════════════════════════════════════════════════════════════════

local unpack = unpack or table.unpack

--------------------------------------------------------------
-- SERVICES
--------------------------------------------------------------
local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local StarterGui      = game:GetService("StarterGui")
local Lighting        = game:GetService("Lighting")
local Camera          = workspace.CurrentCamera
local LP              = Players.LocalPlayer
local Mouse           = LP:GetMouse()

--------------------------------------------------------------
-- EXECUTOR FEATURE DETECTION
--------------------------------------------------------------
local ENV = {}

ENV.Drawing = (function()
    local ok = pcall(function()
        local t = Drawing.new("Line")
        t:Remove()
    end)
    return ok
end)()

ENV.Hook = (function()
    if typeof(hookmetamethod) == "function" then return "hookmetamethod" end
    if typeof(hookfunction) == "function" then return "hookfunction" end
    return nil
end)()

ENV.Namecall = typeof(getnamecallmethod) == "function"
ENV.CClosure = typeof(newcclosure) == "function"
local wrap = ENV.CClosure and newcclosure or function(f) return f end

ENV.CoreGui = (function()
    local ok = pcall(function()
        local t = Instance.new("Folder")
        t.Parent = game:GetService("CoreGui")
        t:Destroy()
    end)
    return ok
end)()

ENV.GetHUI = typeof(gethui) == "function"
ENV.ProtectGui = typeof(protect_gui) == "function" or (typeof(syn) == "table" and typeof(syn.protect_gui) == "function")
ENV.ReadOnly = typeof(setreadonly) == "function" or typeof(make_writeable) == "function"
ENV.Mouse1 = typeof(mouse1click) == "function"
ENV.RawMT = typeof(getrawmetatable) == "function"
ENV.CheckCaller = typeof(checkcaller) == "function"

local tag = "[Axiom v3.1]"
print(tag .. " ═══════════════════════════════════════")
print(tag .. " Drawing: " .. tostring(ENV.Drawing))
print(tag .. " Hook: " .. tostring(ENV.Hook))
print(tag .. " Namecall: " .. tostring(ENV.Namecall))
print(tag .. " CoreGui: " .. tostring(ENV.CoreGui))
print(tag .. " CClosure: " .. tostring(ENV.CClosure))
print(tag .. " ═══════════════════════════════════════")

if not ENV.Drawing then
    warn(tag .. " NO DRAWING API — ESP will use BillboardGui fallback")
end
if not ENV.Hook then
    warn(tag .. " NO HOOK — Silent Aim using camera-based redirect")
end

--------------------------------------------------------------
-- MASTER CONFIG
--------------------------------------------------------------
local CFG = {
    -- AIMBOT
    Aimbot = {
        On = false,
        Key = Enum.UserInputType.MouseButton2,
        Mode = "Smooth",          -- "Snap" or "Smooth"
        Smoothness = 0.15,        -- lower = faster (0.01 to 1)
        Part = "Head",            -- "Head", "Torso", "Closest"
        FOV = 200,
        ShowFOV = true,
        FOVColor = {1, 0.2, 0.2},
        FOVAlpha = 0.8,
        FOVThick = 1.5,
        FOVSides = 64,
        FOVFilled = false,
        Predict = true,
        PredictScale = 0.155,
        TeamCheck = true,
        WallCheck = false,
        VisCheck = false,
        MaxDist = 2500,
        Priority = "FOV",         -- "FOV", "Distance", "Health"
    },

    -- SILENT AIM
    SilentAim = {
        On = false,
        FOV = 180,
        ShowFOV = true,
        FOVColor = {0.2, 0.6, 1},
        FOVAlpha = 0.6,
        FOVThick = 1.2,
        FOVSides = 48,
        Part = "Head",
        Predict = true,
        PredictScale = 0.155,
        WallCheck = false,
        TeamCheck = true,
        HitChance = 100,
    },

    -- BOX ESP
    BoxESP = {
        On = false,
        Mode = "Full",            -- "Full", "Corner", "3D"
        EnemyColor = {1, 0.15, 0.15},
        TeamColor = {0.15, 1, 0.15},
        EnemyFill = {1, 0, 0},
        TeamFill = {0, 1, 0},
        FillAlpha = 0,            -- 0=off, >0=filled box
        Thick = 1.4,
        CornerLength = 6,
        Name = true,
        NameSize = 14,
        Health = true,
        HealthNum = false,
        Dist = true,
        DistSize = 12,
        Weapon = false,
        MaxDist = 1500,
        ShowTeam = false,
        Outline = true,
        OutlineColor = {0, 0, 0},
        OutlineThick = 3,
    },

    -- TRACERS
    Tracers = {
        On = false,
        Origin = "Bottom",        -- "Bottom", "Center", "Mouse"
        EnemyColor = {1, 0.3, 0.3},
        TeamColor = {0.3, 1, 0.3},
        Thick = 1.2,
        MaxDist = 2000,
        ShowTeam = false,
    },

    -- SNAPLINES
    Snaplines = {
        On = false,
        Color = {1, 1, 0},
        Thick = 0.8,
        Part = "Head",
    },

    -- SKELETON ESP
    Skeleton = {
        On = false,
        EnemyColor = {1, 1, 1},
        TeamColor = {0.5, 0.5, 1},
        Thick = 1.2,
        MaxDist = 1200,
        ShowTeam = false,
    },

    -- CHAMS
    Chams = {
        On = false,
        Mode = "Standard",        -- "Standard", "Neon", "Rainbow", "Flat"
        FillColor = {0.5, 0, 1},
        OutColor = {1, 1, 1},
        FillAlpha = 0.6,
        OutAlpha = 0.0,
        NeonColor = {0, 1, 0.8},
        NeonAlpha = 0.3,
        NeonOutAlpha = 0,
        RainbowSpeed = 1,
        EnemyFill = {1, 0, 0.3},
        TeamFill = {0, 0.4, 1},
        EnemyOut = {1, 0.5, 0.5},
        TeamOut = {0.5, 0.5, 1},
        TeamCheck = true,
        VisibleOnly = false,
        DepthMode = "AlwaysOnTop",-- "AlwaysOnTop", "Occluded"
    },

    -- ITEM ESP
    ItemESP = {
        On = false,
        Color = {1, 1, 0},
        TracerColor = {1, 0.78, 0},
        MaxDist = 800,
        Names = true,
        NameSize = 13,
        Dist = true,
        Tracers = true,
        TracerThick = 1,
        Icon = true,
        Filter = {},              -- empty = show all
    },

    -- CROSSHAIR
    Crosshair = {
        On = false,
        Color = {0, 1, 0},
        Size = 12,
        Gap = 4,
        Thick = 1.5,
        Dot = true,
        DotSize = 2,
        Outline = true,
        Rotate = false,
        RotateSpeed = 2,
        Style = "Cross",          -- "Cross", "Circle", "Dot", "Diamond"
    },

    -- FOV CHANGER
    FOVChanger = {
        On = false,
        Value = 70,
        Smooth = true,
        SmoothSpeed = 0.1,
    },

    -- WATERMARK
    Watermark = {
        On = true,
        ShowFPS = true,
        ShowPing = true,
        ShowTime = true,
        ShowGame = true,
    },

    -- GUI
    GUI = {
        MenuKey = Enum.KeyCode.RightControl,
        Scale = 1.0,
        Opacity = 0.96,
        AnimSpeed = 0.2,
        Accent = {130, 60, 255},
        AccentAlt = {90, 200, 255},
        BlurBackground = true,
    },
}

--------------------------------------------------------------
-- UTILITIES
--------------------------------------------------------------
local U = {}

function U.c3(t) return Color3.new(t[1], t[2], t[3]) end
function U.c3rgb(t) return Color3.fromRGB(t[1], t[2], t[3]) end
function U.rgb(r, g, b) return Color3.fromRGB(r, g, b) end

function U.w2s(pos)
    local s, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), on, s.Z
end

function U.dist2d(a, b) return ((a.X - b.X) ^ 2 + (a.Y - b.Y) ^ 2) ^ 0.5 end

function U.dist3d(a, b) return (a - b).Magnitude end

function U.alive(p)
    if not p then return false end
    local ch = p.Character
    if not ch then return false end
    local h = ch:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return false end
    return ch:FindFirstChild("HumanoidRootPart") ~= nil
end

function U.hpFrac(p)
    local ch = p.Character
    if not ch then return 0 end
    local h = ch:FindFirstChildOfClass("Humanoid")
    return h and math.clamp(h.Health / h.MaxHealth, 0, 1) or 0
end

function U.hp(p)
    local ch = p.Character
    if not ch then return 0 end
    local h = ch:FindFirstChildOfClass("Humanoid")
    return h and h.Health or 0
end

function U.team(p) return LP.Team and p.Team and LP.Team == p.Team end

function U.myPos()
    local ch = LP.Character
    local r = ch and ch:FindFirstChild("HumanoidRootPart")
    return r and r.Position or Camera.CFrame.Position
end

function U.wallCheck(from, to)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {Camera}
    if LP.Character then table.insert(filter, LP.Character) end
    params.FilterDescendantsInstances = filter
    local result = workspace:Raycast(from, to - from, params)
    return result == nil
end

function U.visCheck(from, to, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {Camera}
    if LP.Character then table.insert(filter, LP.Character) end
    if targetChar then table.insert(filter, targetChar) end
    params.FilterDescendantsInstances = filter
    local result = workspace:Raycast(from, to - from, params)
    return result == nil
end

function U.getWeapon(p)
    local ch = p.Character
    if not ch then return "None" end
    local tool = ch:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "None"
end

function U.closestPart(ch, origin)
    local bestPart, bestDist = nil, math.huge
    for _, partName in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"}) do
        local part = ch:FindFirstChild(partName)
        if part then
            local d = (part.Position - origin).Magnitude
            if d < bestDist then
                bestDist = d
                bestPart = part
            end
        end
    end
    return bestPart
end

function U.lerp(a, b, t) return a + (b - a) * t end

function U.lerpColor(a, b, t)
    return Color3.new(
        U.lerp(a.R, b.R, t),
        U.lerp(a.G, b.G, t),
        U.lerp(a.B, b.B, t)
    )
end

function U.rainbow(speed, offset)
    offset = offset or 0
    return Color3.fromHSV((tick() * (speed or 1) + offset) % 1, 1, 1)
end

function U.formatDist(d) return string.format("[%dm]", math.floor(d)) end

function U.formatHP(p)
    local ch = p.Character
    if not ch then return "0" end
    local h = ch:FindFirstChildOfClass("Humanoid")
    return h and tostring(math.floor(h.Health)) or "0"
end

function U.hpColor(frac)
    if frac > 0.5 then
        return U.lerpColor(Color3.fromRGB(255, 200, 0), Color3.fromRGB(0, 255, 0), (frac - 0.5) * 2)
    else
        return U.lerpColor(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 200, 0), frac * 2)
    end
end

--------------------------------------------------------------
-- DRAWING LAYER (Drawing API or BillboardGui fallback)
--------------------------------------------------------------
local Draw = {}

if ENV.Drawing then
    -- Object pool for performant drawing
    local Pool = {}
    Pool.__index = Pool

    function Pool.new(cls, defs)
        return setmetatable({c = cls, d = defs, p = {}, n = 0, peak = 0}, Pool)
    end

    function Pool:get()
        self.n = self.n + 1
        if self.n > self.peak then self.peak = self.n end
        if self.p[self.n] then return self.p[self.n] end
        local obj = Drawing.new(self.c)
        for k, v in pairs(self.d) do obj[k] = v end
        self.p[self.n] = obj
        return obj
    end

    function Pool:flush()
        for i = 1, self.n do
            self.p[i].Visible = false
        end
        self.n = 0
    end

    function Pool:destroy()
        for i = 1, #self.p do
            pcall(function() self.p[i]:Remove() end)
        end
        self.p = {}
        self.n = 0
    end

    Draw.Lines   = Pool.new("Line", {Visible = false, Thickness = 1})
    Draw.Texts   = Pool.new("Text", {Visible = false, Size = 13, Center = true, Outline = true, Font = 2})
    Draw.Circles = Pool.new("Circle", {Visible = false, Thickness = 1, NumSides = 30})
    Draw.Squares = Pool.new("Square", {Visible = false, Thickness = 1})
    Draw.Quads   = Pool.new("Quad", {Visible = false, Thickness = 1})

    Draw.flush = function()
        Draw.Lines:flush()
        Draw.Texts:flush()
        Draw.Circles:flush()
        Draw.Squares:flush()
        Draw.Quads:flush()
    end

    Draw.line = function(from, to, col, thick)
        local l = Draw.Lines:get()
        l.From = from
        l.To = to
        l.Color = col
        l.Thickness = thick or 1
        l.Visible = true
        return l
    end

    Draw.text = function(pos, txt, col, size, center, outline)
        local t = Draw.Texts:get()
        t.Position = pos
        t.Text = txt
        t.Color = col
        t.Size = size or 13
        t.Center = center ~= false
        t.Outline = outline ~= false
        t.Visible = true
        return t
    end

    Draw.circle = function(pos, radius, col, thick, filled, sides, alpha)
        local c = Draw.Circles:get()
        c.Position = pos
        c.Radius = radius
        c.Color = col
        c.Thickness = thick or 1
        c.Filled = filled or false
        c.NumSides = sides or 30
        c.Transparency = alpha or 1
        c.Visible = true
        return c
    end

    Draw.square = function(pos, size, col, thick, filled)
        local s = Draw.Squares:get()
        s.Position = pos
        s.Size = size
        s.Color = col
        s.Thickness = thick or 1
        s.Filled = filled or false
        s.Visible = true
        return s
    end

    Draw.quad = function(a, b, c2, d, col, thick, filled)
        local q = Draw.Quads:get()
        q.PointA = a
        q.PointB = b
        q.PointC = c2
        q.PointD = d
        q.Color = col
        q.Thickness = thick or 1
        q.Filled = filled or false
        q.Visible = true
        return q
    end

    -- Persistent drawing objects
    Draw.AimbotFOV = Drawing.new("Circle")
    Draw.AimbotFOV.NumSides = 64
    Draw.AimbotFOV.Filled = false
    Draw.AimbotFOV.Thickness = 1.5
    Draw.AimbotFOV.Transparency = 0.8
    Draw.AimbotFOV.Visible = false

    Draw.SilentFOV = Drawing.new("Circle")
    Draw.SilentFOV.NumSides = 48
    Draw.SilentFOV.Filled = false
    Draw.SilentFOV.Thickness = 1.2
    Draw.SilentFOV.Transparency = 0.6
    Draw.SilentFOV.Visible = false

    -- Crosshair lines (persistent)
    Draw.CrossLines = {}
    for i = 1, 8 do
        Draw.CrossLines[i] = Drawing.new("Line")
        Draw.CrossLines[i].Visible = false
        Draw.CrossLines[i].Thickness = 1.5
    end

    Draw.CrossDot = Drawing.new("Circle")
    Draw.CrossDot.Filled = true
    Draw.CrossDot.NumSides = 20
    Draw.CrossDot.Visible = false

    -- Watermark
    Draw.WatermarkBG = Drawing.new("Square")
    Draw.WatermarkBG.Filled = true
    Draw.WatermarkBG.Visible = false
    Draw.WatermarkBG.Color = Color3.fromRGB(14, 14, 18)
    Draw.WatermarkBG.Transparency = 0.85

    Draw.WatermarkBorder = Drawing.new("Square")
    Draw.WatermarkBorder.Filled = false
    Draw.WatermarkBorder.Visible = false
    Draw.WatermarkBorder.Color = Color3.fromRGB(130, 60, 255)
    Draw.WatermarkBorder.Thickness = 1

    Draw.WatermarkAccent = Drawing.new("Line")
    Draw.WatermarkAccent.Visible = false
    Draw.WatermarkAccent.Thickness = 2

    Draw.WatermarkText = Drawing.new("Text")
    Draw.WatermarkText.Visible = false
    Draw.WatermarkText.Size = 13
    Draw.WatermarkText.Font = 2
    Draw.WatermarkText.Outline = true
    Draw.WatermarkText.Center = false

else
    -- BillboardGui fallback
    local bbgFolder = Instance.new("Folder")
    bbgFolder.Name = "AxiomESP"
    bbgFolder.Parent = workspace.CurrentCamera

    local bbgCache = {}

    Draw.flush = function()
        for _, v in pairs(bbgCache) do
            if v and v.Parent then
                pcall(function() v:Destroy() end)
            end
        end
        bbgCache = {}
    end

    Draw.line = function() end
    Draw.text = function() end
    Draw.circle = function() end
    Draw.square = function() end
    Draw.quad = function() end

    Draw.bbgText = function(adornee, txt, col, offset)
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 200, 0, 50)
        bg.StudsOffset = offset or Vector3.new(0, 3.5, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = adornee
        bg.Parent = bbgFolder

        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1, 0, 1, 0)
        tl.BackgroundTransparency = 1
        tl.TextColor3 = col
        tl.Text = txt
        tl.Font = Enum.Font.GothamBold
        tl.TextSize = 14
        tl.TextStrokeTransparency = 0.5

        bbgCache[#bbgCache + 1] = bg
        return bg
    end

    Draw.bbgHealth = function(adornee, frac)
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 60, 0, 8)
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true
        bg.Adornee = adornee
        bg.Parent = bbgFolder

        local outer = Instance.new("Frame", bg)
        outer.Size = UDim2.new(1, 0, 1, 0)
        outer.BackgroundColor3 = Color3.new(0, 0, 0)
        outer.BackgroundTransparency = 0.3
        outer.BorderSizePixel = 0
        Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 3)

        local inner = Instance.new("Frame", outer)
        inner.Size = UDim2.new(frac, -2, 1, -2)
        inner.Position = UDim2.new(0, 1, 0, 1)
        inner.BackgroundColor3 = U.hpColor(frac)
        inner.BorderSizePixel = 0
        Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 2)

        bbgCache[#bbgCache + 1] = bg
        return bg
    end

    Draw.AimbotFOV = nil
    Draw.SilentFOV = nil
    Draw.CrossLines = {}
    Draw.CrossDot = nil
    Draw.WatermarkBG = nil
    Draw.WatermarkBorder = nil
    Draw.WatermarkAccent = nil
    Draw.WatermarkText = nil
end

--------------------------------------------------------------
-- CHAMS SYSTEM (Standard / Neon / Rainbow / Flat)
--------------------------------------------------------------
local chamsCache = {}
local rainbowTick = 0

local function getChamsColors(p)
    local mode = CFG.Chams.Mode
    local isEnemy = not U.team(p)

    if mode == "Neon" then
        return U.c3(CFG.Chams.NeonColor), U.c3(CFG.Chams.NeonColor),
               CFG.Chams.NeonAlpha, CFG.Chams.NeonOutAlpha
    elseif mode == "Rainbow" then
        local hue = (tick() * CFG.Chams.RainbowSpeed) % 1
        local col = Color3.fromHSV(hue, 0.8, 1)
        return col, col, CFG.Chams.FillAlpha, CFG.Chams.OutAlpha
    elseif mode == "Flat" then
        local fill = isEnemy and U.c3(CFG.Chams.EnemyFill) or U.c3(CFG.Chams.TeamFill)
        return fill, fill, 0.5, 1
    else -- Standard
        if CFG.Chams.TeamCheck then
            local fill = isEnemy and U.c3(CFG.Chams.EnemyFill) or U.c3(CFG.Chams.TeamFill)
            local out = isEnemy and U.c3(CFG.Chams.EnemyOut) or U.c3(CFG.Chams.TeamOut)
            return fill, out, CFG.Chams.FillAlpha, CFG.Chams.OutAlpha
        else
            return U.c3(CFG.Chams.FillColor), U.c3(CFG.Chams.OutColor),
                   CFG.Chams.FillAlpha, CFG.Chams.OutAlpha
        end
    end
end

local function setChams(p)
    local ch = p.Character
    if not ch then return end

    if CFG.Chams.VisibleOnly and not U.visCheck(U.myPos(), ch:FindFirstChild("HumanoidRootPart") and ch.HumanoidRootPart.Position or ch:GetPivot().Position, ch) then
        killChams(p)
        return
    end

    local fillCol, outCol, fillA, outA = getChamsColors(p)
    local depthMode = CFG.Chams.DepthMode == "AlwaysOnTop"
        and Enum.HighlightDepthMode.AlwaysOnTop
        or Enum.HighlightDepthMode.Occluded

    if chamsCache[p] then
        local hl = chamsCache[p]
        hl.FillColor = fillCol
        hl.OutlineColor = outCol
        hl.FillTransparency = fillA
        hl.OutlineTransparency = outA
        hl.DepthMode = depthMode
        if not hl.Parent or hl.Adornee ~= ch then
            hl.Adornee = ch
            hl.Parent = ch
        end
        return
    end

    local hl = Instance.new("Highlight")
    hl.FillColor = fillCol
    hl.OutlineColor = outCol
    hl.FillTransparency = fillA
    hl.OutlineTransparency = outA
    hl.DepthMode = depthMode
    hl.Adornee = ch
    hl.Parent = ch
    chamsCache[p] = hl
end

function killChams(p)
    if chamsCache[p] then
        pcall(function() chamsCache[p]:Destroy() end)
        chamsCache[p] = nil
    end
end

--------------------------------------------------------------
-- SKELETON BONES
--------------------------------------------------------------
local BONES_R15 = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local BONES_R6 = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}

local function getBones(ch)
    return ch:FindFirstChild("UpperTorso") and BONES_R15 or BONES_R6
end

--------------------------------------------------------------
-- TARGET ACQUISITION
--------------------------------------------------------------
local currentTarget = nil
local silentTarget = nil
local aimHeld = false

local function getTargetPart(ch, partName)
    if partName == "Closest" then
        return U.closestPart(ch, Camera.CFrame.Position)
    end
    return ch:FindFirstChild(partName) or ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
end

local function getPredictedPos(ch, partName)
    local part = getTargetPart(ch, partName)
    if not part then return nil end
    local pos = part.Position
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if rp then
        pos = pos + rp.AssemblyLinearVelocity * CFG.Aimbot.PredictScale
    end
    return pos
end

local function scoreTarget(p, cfg)
    local ch = p.Character
    if not ch then return nil end
    local part = getTargetPart(ch, cfg.Part or "Head")
    if not part then return nil end

    local sp, on = U.w2s(part.Position)
    if not on then return nil end

    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local fovDist = U.dist2d(center, sp)
    if fovDist > (cfg.FOV or 500) then return nil end

    local dist3d = U.dist3d(U.myPos(), part.Position)
    if dist3d > (cfg.MaxDist or 2500) then return nil end

    if cfg.TeamCheck ~= false and U.team(p) then return nil end
    if cfg.WallCheck and not U.wallCheck(U.myPos(), part.Position) then return nil end
    if cfg.VisCheck and not U.visCheck(U.myPos(), part.Position, ch) then return nil end

    local priority = cfg.Priority or "FOV"
    if priority == "Distance" then
        return dist3d
    elseif priority == "Health" then
        return U.hp(p)
    else
        return fovDist
    end
end

local function findBestTarget(cfg)
    local best, bestScore = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local score = scoreTarget(p, cfg)
            if score and score < bestScore then
                bestScore = score
                best = p
            end
        end
    end
    return best
end

--------------------------------------------------------------
-- SILENT AIM HOOKS
--------------------------------------------------------------
if ENV.Hook == "hookmetamethod" and ENV.Namecall then
    pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if CFG.SilentAim.On and silentTarget then
                if math.random(1, 100) <= CFG.SilentAim.HitChance then
                    local ch = silentTarget.Character
                    if ch and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
                        local tp = getTargetPart(ch, CFG.SilentAim.Part)
                        if tp then
                            local tPos = tp.Position
                            if CFG.SilentAim.Predict then
                                local rp = ch:FindFirstChild("HumanoidRootPart")
                                if rp then
                                    tPos = tPos + rp.AssemblyLinearVelocity * CFG.SilentAim.PredictScale
                                end
                            end
                            if typeof(args[1]) == "Ray" then
                                args[1] = Ray.new(args[1].Origin, (tPos - args[1].Origin).Unit * 5000)
                            end
                        end
                    end
                end
            end
            return old(self, unpack(args))
        end))
        print(tag .. " Silent Aim: hookmetamethod active")
    end)

elseif ENV.RawMT then
    pcall(function()
        local mt = getrawmetatable(game)
        if setreadonly then
            setreadonly(mt, false)
        elseif make_writeable then
            make_writeable(mt)
        end
        local oldNC = mt.__namecall
        mt.__namecall = wrap(function(self, ...)
            local args = {...}
            local method = getnamecallmethod and getnamecallmethod() or ""
            if CFG.SilentAim.On and silentTarget then
                if math.random(1, 100) <= CFG.SilentAim.HitChance then
                    local ch = silentTarget.Character
                    if ch and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
                        local tp = getTargetPart(ch, CFG.SilentAim.Part)
                        if tp then
                            local tPos = tp.Position
                            if CFG.SilentAim.Predict then
                                local rp = ch:FindFirstChild("HumanoidRootPart")
                                if rp then
                                    tPos = tPos + rp.AssemblyLinearVelocity * CFG.SilentAim.PredictScale
                                end
                            end
                            if typeof(args[1]) == "Ray" then
                                args[1] = Ray.new(args[1].Origin, (tPos - args[1].Origin).Unit * 5000)
                            end
                        end
                    end
                end
            end
            return oldNC(self, unpack(args))
        end)
        if setreadonly then setreadonly(mt, true) end
        print(tag .. " Silent Aim: rawmetatable active")
    end)

else
    print(tag .. " Silent Aim: camera redirect mode (no hook available)")
end

--------------------------------------------------------------
-- ITEM DETECTION
--------------------------------------------------------------
local ITEM_KEYWORDS = {
    "loot", "item", "drop", "pickup", "spawn", "ground", "collect",
    "weapon", "chest", "crate", "supply", "ammo", "heal", "med",
    "armor", "shield", "gun", "rifle", "pistol", "shotgun", "sniper",
    "grenade", "explosive", "consumable", "currency", "coin", "gem",
    "key", "card", "relic", "artifact", "treasure", "reward"
}

local function isItem(obj)
    if obj:IsA("Tool") then return true end
    if obj:IsA("BasePart") or obj:IsA("Model") then
        if obj:FindFirstChildOfClass("ClickDetector") then return true end
        if obj:FindFirstChildOfClass("ProximityPrompt") then return true end
        local p = obj.Parent
        if p and p ~= workspace then
            local n = string.lower(p.Name)
            for _, kw in ipairs(ITEM_KEYWORDS) do
                if string.find(n, kw) then return true end
            end
        end
        local n2 = string.lower(obj.Name)
        for _, kw in ipairs(ITEM_KEYWORDS) do
            if string.find(n2, kw) then return true end
        end
    end
    return false
end

local function getItemPos(obj)
    if obj:IsA("Model") then
        local pp = obj.PrimaryPart
        if pp then return pp.Position end
        local ok, cf = pcall(function() return obj:GetBoundingBox() end)
        return ok and cf.Position or nil
    elseif obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Tool") then
        local h = obj:FindFirstChild("Handle")
        return h and h.Position or nil
    end
    return nil
end

--------------------------------------------------------------
-- CROSSHAIR SYSTEM
--------------------------------------------------------------
local crossAngle = 0

local function renderCrosshair(ctr)
    if not ENV.Drawing then return end
    local cfg = CFG.Crosshair
    if not cfg.On then
        for i = 1, 8 do Draw.CrossLines[i].Visible = false end
        if Draw.CrossDot then Draw.CrossDot.Visible = false end
        return
    end

    local col = U.c3(cfg.Color)
    local s = cfg.Size
    local g = cfg.Gap
    local th = cfg.Thick

    if cfg.Rotate then
        crossAngle = crossAngle + cfg.RotateSpeed * 0.016
    else
        crossAngle = 0
    end

    if cfg.Style == "Cross" then
        local cos_a = math.cos(crossAngle)
        local sin_a = math.sin(crossAngle)

        local dirs = {
            {0, -1}, {0, 1}, {-1, 0}, {1, 0}
        }

        for i, dir in ipairs(dirs) do
            local dx, dy = dir[1], dir[2]
            local rdx = dx * cos_a - dy * sin_a
            local rdy = dx * sin_a + dy * cos_a

            local fromX = ctr.X + rdx * g
            local fromY = ctr.Y + rdy * g
            local toX = ctr.X + rdx * (g + s)
            local toY = ctr.Y + rdy * (g + s)

            if cfg.Outline then
                local ol = Draw.CrossLines[i + 4]
                ol.From = Vector2.new(fromX, fromY)
                ol.To = Vector2.new(toX, toY)
                ol.Color = Color3.new(0, 0, 0)
                ol.Thickness = th + 2
                ol.Visible = true
            else
                Draw.CrossLines[i + 4].Visible = false
            end

            local ln = Draw.CrossLines[i]
            ln.From = Vector2.new(fromX, fromY)
            ln.To = Vector2.new(toX, toY)
            ln.Color = col
            ln.Thickness = th
            ln.Visible = true
        end

    elseif cfg.Style == "Circle" then
        for i = 1, 8 do Draw.CrossLines[i].Visible = false end
        Draw.circle(ctr, s, col, th, false, 40)

    elseif cfg.Style == "Diamond" then
        local offsets = {
            {Vector2.new(ctr.X, ctr.Y - g - s), Vector2.new(ctr.X + g + s, ctr.Y)},
            {Vector2.new(ctr.X + g + s, ctr.Y), Vector2.new(ctr.X, ctr.Y + g + s)},
            {Vector2.new(ctr.X, ctr.Y + g + s), Vector2.new(ctr.X - g - s, ctr.Y)},
            {Vector2.new(ctr.X - g - s, ctr.Y), Vector2.new(ctr.X, ctr.Y - g - s)},
        }
        for i = 1, 4 do
            if cfg.Outline then
                local ol = Draw.CrossLines[i + 4]
                ol.From = offsets[i][1]
                ol.To = offsets[i][2]
                ol.Color = Color3.new(0, 0, 0)
                ol.Thickness = th + 2
                ol.Visible = true
            else
                Draw.CrossLines[i + 4].Visible = false
            end
            local ln = Draw.CrossLines[i]
            ln.From = offsets[i][1]
            ln.To = offsets[i][2]
            ln.Color = col
            ln.Thickness = th
            ln.Visible = true
        end
        Draw.CrossLines[5].Visible = false
        Draw.CrossLines[6].Visible = false
        Draw.CrossLines[7].Visible = false
        Draw.CrossLines[8].Visible = false
    else
        for i = 1, 8 do Draw.CrossLines[i].Visible = false end
    end

    if Draw.CrossDot and cfg.Dot then
        Draw.CrossDot.Position = ctr
        Draw.CrossDot.Radius = cfg.DotSize
        Draw.CrossDot.Color = col
        Draw.CrossDot.Visible = true
    elseif Draw.CrossDot then
        Draw.CrossDot.Visible = false
    end
end

--------------------------------------------------------------
-- WATERMARK SYSTEM
--------------------------------------------------------------
local fpsBuffer = {}
local fpsIdx = 0
local FPS_SAMPLES = 30

local function renderWatermark()
    if not ENV.Drawing or not Draw.WatermarkBG then return end
    if not CFG.Watermark.On then
        Draw.WatermarkBG.Visible = false
        Draw.WatermarkBorder.Visible = false
        Draw.WatermarkAccent.Visible = false
        Draw.WatermarkText.Visible = false
        return
    end

    local parts = {"AXIOM v3.1"}

    if CFG.Watermark.ShowFPS then
        fpsIdx = (fpsIdx % FPS_SAMPLES) + 1
        fpsBuffer[fpsIdx] = 1 / RunService.RenderStepped:Wait()
        local sum = 0
        local count = math.min(#fpsBuffer, FPS_SAMPLES)
        for i = 1, count do sum = sum + (fpsBuffer[i] or 60) end
        table.insert(parts, math.floor(sum / count) .. " FPS")
    end

    if CFG.Watermark.ShowPing then
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        table.insert(parts, ping .. "ms")
    end

    if CFG.Watermark.ShowTime then
        table.insert(parts, os.date("%H:%M:%S"))
    end

    if CFG.Watermark.ShowGame then
        local gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        if #gname > 20 then gname = string.sub(gname, 1, 18) .. ".." end
        table.insert(parts, gname)
    end

    local txt = table.concat(parts, " | ")
    local txtW = #txt * 7
    local h = 24
    local pad = 10
    local x = 10
    local y = 10

    Draw.WatermarkBG.Position = Vector2.new(x, y)
    Draw.WatermarkBG.Size = Vector2.new(txtW + pad * 2, h)
    Draw.WatermarkBG.Visible = true

    Draw.WatermarkBorder.Position = Vector2.new(x, y)
    Draw.WatermarkBorder.Size = Vector2.new(txtW + pad * 2, h)
    Draw.WatermarkBorder.Color = U.c3rgb(CFG.GUI.Accent)
    Draw.WatermarkBorder.Visible = true

    Draw.WatermarkAccent.From = Vector2.new(x, y)
    Draw.WatermarkAccent.To = Vector2.new(x + txtW + pad * 2, y)
    Draw.WatermarkAccent.Color = U.c3rgb(CFG.GUI.Accent)
    Draw.WatermarkAccent.Visible = true

    Draw.WatermarkText.Position = Vector2.new(x + pad, y + 5)
    Draw.WatermarkText.Text = txt
    Draw.WatermarkText.Color = Color3.new(1, 1, 1)
    Draw.WatermarkText.Visible = true
end

--------------------------------------------------------------
-- ESP RENDERERS
--------------------------------------------------------------
local function renderBoxESP(p, ch, root, d3, col, myP, ctr, vp)
    if not CFG.BoxESP.On or d3 > CFG.BoxESP.MaxDist then return end
    if not CFG.BoxESP.ShowTeam and U.team(p) then return end

    local topP, topOn = U.w2s((root.CFrame * CFrame.new(0, 3.2, 0)).Position)
    local botP, botOn = U.w2s((root.CFrame * CFrame.new(0, -3.2, 0)).Position)
    if not topOn and not botOn then return end

    local h = math.abs(topP.Y - botP.Y)
    local w = h * 0.55
    local thick = CFG.BoxESP.Thick

    local tl = Vector2.new(topP.X - w / 2, topP.Y)
    local tr = Vector2.new(topP.X + w / 2, topP.Y)
    local bl = Vector2.new(botP.X - w / 2, botP.Y)
    local br = Vector2.new(botP.X + w / 2, botP.Y)

    if CFG.BoxESP.Mode == "Full" then
        -- Outline
        if CFG.BoxESP.Outline then
            local oc = U.c3(CFG.BoxESP.OutlineColor)
            local ot = CFG.BoxESP.OutlineThick
            Draw.line(tl, tr, oc, ot)
            Draw.line(tr, br, oc, ot)
            Draw.line(br, bl, oc, ot)
            Draw.line(bl, tl, oc, ot)
        end
        -- Box
        Draw.line(tl, tr, col, thick)
        Draw.line(tr, br, col, thick)
        Draw.line(br, bl, col, thick)
        Draw.line(bl, tl, col, thick)

        -- Fill
        if CFG.BoxESP.FillAlpha > 0 then
            local isEnemy = not U.team(p)
            local fillCol = isEnemy and U.c3(CFG.BoxESP.EnemyFill) or U.c3(CFG.BoxESP.TeamFill)
            Draw.quad(tl, tr, br, bl, fillCol, 1, true)
        end

    elseif CFG.BoxESP.Mode == "Corner" then
        local cl = CFG.BoxESP.CornerLength
        local cLen = math.min(cl, w / 3, h / 3)

        -- Top-left
        Draw.line(tl, Vector2.new(tl.X + cLen, tl.Y), col, thick)
        Draw.line(tl, Vector2.new(tl.X, tl.Y + cLen), col, thick)
        -- Top-right
        Draw.line(tr, Vector2.new(tr.X - cLen, tr.Y), col, thick)
        Draw.line(tr, Vector2.new(tr.X, tr.Y + cLen), col, thick)
        -- Bottom-left
        Draw.line(bl, Vector2.new(bl.X + cLen, bl.Y), col, thick)
        Draw.line(bl, Vector2.new(bl.X, bl.Y - cLen), col, thick)
        -- Bottom-right
        Draw.line(br, Vector2.new(br.X - cLen, br.Y), col, thick)
        Draw.line(br, Vector2.new(br.X, br.Y - cLen), col, thick)

    elseif CFG.BoxESP.Mode == "3D" then
        local cf = root.CFrame
        local size = Vector3.new(4, 6.4, 2.5)
        local hs = size / 2
        local corners3D = {
            cf * CFrame.new(-hs.X,  hs.Y, -hs.Z),
            cf * CFrame.new( hs.X,  hs.Y, -hs.Z),
            cf * CFrame.new( hs.X,  hs.Y,  hs.Z),
            cf * CFrame.new(-hs.X,  hs.Y,  hs.Z),
            cf * CFrame.new(-hs.X, -hs.Y, -hs.Z),
            cf * CFrame.new( hs.X, -hs.Y, -hs.Z),
            cf * CFrame.new( hs.X, -hs.Y,  hs.Z),
            cf * CFrame.new(-hs.X, -hs.Y,  hs.Z),
        }
        local s2d = {}
        local anyOn = false
        for i = 1, 8 do
            local sp, on2 = U.w2s(corners3D[i].Position)
            s2d[i] = sp
            if on2 then anyOn = true end
        end
        if anyOn then
            local edges = {
                {1,2},{2,3},{3,4},{4,1},
                {5,6},{6,7},{7,8},{8,5},
                {1,5},{2,6},{3,7},{4,8},
            }
            for _, e in ipairs(edges) do
                Draw.line(s2d[e[1]], s2d[e[2]], col, thick)
            end
        end
    end

    -- Name
    if CFG.BoxESP.Name then
        Draw.text(
            Vector2.new(topP.X, topP.Y - CFG.BoxESP.NameSize - 4),
            p.DisplayName,
            col,
            CFG.BoxESP.NameSize
        )
    end

    -- Health bar
    if CFG.BoxESP.Health then
        local frac = U.hpFrac(p)
        local hCol = U.hpColor(frac)
        local bx = tl.X - 6

        -- Background
        Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, topP.Y), Color3.new(0, 0, 0), 4)
        -- Fill
        Draw.line(
            Vector2.new(bx, botP.Y),
            Vector2.new(bx, botP.Y - (botP.Y - topP.Y) * frac),
            hCol, 2.5
        )

        if CFG.BoxESP.HealthNum then
            Draw.text(
                Vector2.new(bx - 16, botP.Y - (botP.Y - topP.Y) * frac - 6),
                U.formatHP(p),
                hCol, 10, true
            )
        end
    end

    -- Distance
    if CFG.BoxESP.Dist then
        Draw.text(
            Vector2.new(botP.X, botP.Y + 2),
            U.formatDist(d3),
            Color3.fromRGB(200, 200, 200),
            CFG.BoxESP.DistSize
        )
    end

    -- Weapon
    if CFG.BoxESP.Weapon then
        local wep = U.getWeapon(p)
        if wep ~= "None" then
            local yOff = CFG.BoxESP.Dist and 16 or 2
            Draw.text(
                Vector2.new(botP.X, botP.Y + yOff),
                "[" .. wep .. "]",
                Color3.fromRGB(180, 180, 200),
                11
            )
        end
    end
end

local function renderTracers(p, ch, root, d3, col, myP, ctr, vp)
    if not CFG.Tracers.On or d3 > CFG.Tracers.MaxDist then return end
    if not CFG.Tracers.ShowTeam and U.team(p) then return end

    local isEnemy = not U.team(p)
    local tCol = isEnemy and U.c3(CFG.Tracers.EnemyColor) or U.c3(CFG.Tracers.TeamColor)

    local footPos = (root.CFrame * CFrame.new(0, -3.2, 0)).Position
    local sp, on = U.w2s(footPos)
    if not on then return end

    local origin
    if CFG.Tracers.Origin == "Bottom" then
        origin = Vector2.new(ctr.X, vp.Y)
    elseif CFG.Tracers.Origin == "Center" then
        origin = ctr
    else
        origin = Vector2.new(Mouse.X, Mouse.Y)
    end

    Draw.line(origin, sp, tCol, CFG.Tracers.Thick)
end

local function renderSnaplines(p, ch, root, d3, col, myP, ctr, vp)
    if not CFG.Snaplines.On then return end

    local part = ch:FindFirstChild(CFG.Snaplines.Part) or ch:FindFirstChild("Head")
    if not part then return end

    local sp, on = U.w2s(part.Position)
    if not on then return end

    Draw.line(ctr, sp, U.c3(CFG.Snaplines.Color), CFG.Snaplines.Thick)
end

local function renderSkeleton(p, ch, root, d3, myP)
    if not CFG.Skeleton.On or d3 > CFG.Skeleton.MaxDist then return end
    if not CFG.Skeleton.ShowTeam and U.team(p) then return end

    local isEnemy = not U.team(p)
    local sCol = isEnemy and U.c3(CFG.Skeleton.EnemyColor) or U.c3(CFG.Skeleton.TeamColor)

    for _, bone in ipairs(getBones(ch)) do
        local a = ch:FindFirstChild(bone[1])
        local b = ch:FindFirstChild(bone[2])
        if a and b then
            local sa, onA = U.w2s(a.Position)
            local sb, onB = U.w2s(b.Position)
            if onA and onB then
                Draw.line(sa, sb, sCol, CFG.Skeleton.Thick)
            end
        end
    end
end

--------------------------------------------------------------
-- MAIN RENDER LOOP
--------------------------------------------------------------
local BUDGET_MS = 6
local ESP_RATE = 2
local ITEM_RATE = 8
local WATERMARK_RATE = 15
local frame = 0
local clk = os.clock

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == CFG.Aimbot.Key then
        aimHeld = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == CFG.Aimbot.Key then
        aimHeld = false
    end
end)

RunService.RenderStepped:Connect(function(dt)
    frame = frame + 1
    local t0 = clk()
    local vp = Camera.ViewportSize
    local ctr = Vector2.new(vp.X / 2, vp.Y / 2)
    Camera = workspace.CurrentCamera

    -- FOV CHANGER
    if CFG.FOVChanger.On then
        if CFG.FOVChanger.Smooth then
            Camera.FieldOfView = U.lerp(Camera.FieldOfView, CFG.FOVChanger.Value, CFG.FOVChanger.SmoothSpeed)
        else
            Camera.FieldOfView = CFG.FOVChanger.Value
        end
    end

    -- FOV CIRCLES
    if Draw.AimbotFOV then
        Draw.AimbotFOV.Position = ctr
        Draw.AimbotFOV.Radius = CFG.Aimbot.FOV
        Draw.AimbotFOV.Color = U.c3(CFG.Aimbot.FOVColor)
        Draw.AimbotFOV.Transparency = CFG.Aimbot.FOVAlpha
        Draw.AimbotFOV.Thickness = CFG.Aimbot.FOVThick
        Draw.AimbotFOV.NumSides = CFG.Aimbot.FOVSides
        Draw.AimbotFOV.Filled = CFG.Aimbot.FOVFilled
        Draw.AimbotFOV.Visible = CFG.Aimbot.On and CFG.Aimbot.ShowFOV
    end

    if Draw.SilentFOV then
        Draw.SilentFOV.Position = ctr
        Draw.SilentFOV.Radius = CFG.SilentAim.FOV
        Draw.SilentFOV.Color = U.c3(CFG.SilentAim.FOVColor)
        Draw.SilentFOV.Transparency = CFG.SilentAim.FOVAlpha
        Draw.SilentFOV.Thickness = CFG.SilentAim.FOVThick
        Draw.SilentFOV.NumSides = CFG.SilentAim.FOVSides
        Draw.SilentFOV.Visible = CFG.SilentAim.On and CFG.SilentAim.ShowFOV
    end

    -- TARGET ACQUISITION
    silentTarget = CFG.SilentAim.On and findBestTarget(CFG.SilentAim) or nil
    currentTarget = CFG.Aimbot.On and aimHeld and findBestTarget(CFG.Aimbot) or nil

    -- AIMBOT (smoothed or snap)
    if currentTarget and aimHeld then
        local ch = currentTarget.Character
        if ch then
            local tPos = getPredictedPos(ch, CFG.Aimbot.Part)
            if tPos then
                if CFG.Aimbot.Mode == "Snap" then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tPos)
                else
                    local currentLook = Camera.CFrame.LookVector
                    local desiredDir = (tPos - Camera.CFrame.Position).Unit
                    local newDir = currentLook:Lerp(desiredDir, math.clamp(CFG.Aimbot.Smoothness, 0.01, 1))
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + newDir)
                end
            end
        end
    end

    -- SILENT AIM CAMERA REDIRECT (fallback, no hook)
    if not ENV.Hook and not ENV.RawMT and CFG.SilentAim.On and silentTarget and aimHeld then
        local ch = silentTarget.Character
        if ch then
            local tPos = getPredictedPos(ch, CFG.SilentAim.Part)
            if tPos then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tPos)
            end
        end
    end

    -- CROSSHAIR
    renderCrosshair(ctr)

    -- FLUSH POOLED DRAWINGS
    Draw.flush()

    local doESP = frame % ESP_RATE == 0
    local doItem = frame % ITEM_RATE == 0
    local doWM = frame % WATERMARK_RATE == 0

    if not doESP and not doItem then
        if doWM then renderWatermark() end
        return
    end

    local myP = U.myPos()

    -- PLAYER ESP
    if doESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            if not U.alive(p) then
                killChams(p)
                continue
            end

            local ch = p.Character
            local root = ch:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local d3 = (myP - root.Position).Magnitude
            if (clk() - t0) * 1000 > BUDGET_MS then break end

            -- Chams (Instance-based, always works)
            if CFG.Chams.On then
                setChams(p)
            else
                killChams(p)
            end

            if not ENV.Drawing then
                -- BillboardGui fallback
                local isEnemy = not U.team(p)
                local col = isEnemy and U.c3(CFG.BoxESP.EnemyColor) or U.c3(CFG.BoxESP.TeamColor)

                if CFG.BoxESP.On and d3 <= CFG.BoxESP.MaxDist then
                    if not CFG.BoxESP.ShowTeam and not isEnemy then continue end
                    local head = ch:FindFirstChild("Head")
                    if head then
                        local txt = p.DisplayName
                        if CFG.BoxESP.Dist then
                            txt = txt .. " " .. U.formatDist(d3)
                        end
                        Draw.bbgText(head, txt, col)
                        if CFG.BoxESP.Health then
                            Draw.bbgHealth(head, U.hpFrac(p))
                        end
                    end
                end
                continue
            end

            -- Drawing API renderers
            local isEnemy = not U.team(p)
            local col = isEnemy and U.c3(CFG.BoxESP.EnemyColor) or U.c3(CFG.BoxESP.TeamColor)

            renderBoxESP(p, ch, root, d3, col, myP, ctr, vp)
            renderTracers(p, ch, root, d3, col, myP, ctr, vp)
            renderSnaplines(p, ch, root, d3, col, myP, ctr, vp)
            renderSkeleton(p, ch, root, d3, myP)
        end
    end

    -- ITEM ESP
    if doItem and CFG.ItemESP.On and ENV.Drawing then
        local iCol = U.c3(CFG.ItemESP.Color)
        local tCol = U.c3(CFG.ItemESP.TracerColor)

        for _, obj in ipairs(workspace:GetDescendants()) do
            if (clk() - t0) * 1000 > BUDGET_MS then break end
            if not isItem(obj) then continue end

            local pos = getItemPos(obj)
            if not pos then continue end

            local dist = (myP - pos).Magnitude
            if dist > CFG.ItemESP.MaxDist then continue end

            local sp, on = U.w2s(pos)
            if not on then continue end

            if CFG.ItemESP.Names then
                local label = obj.Name
                if CFG.ItemESP.Dist then
                    label = label .. " " .. U.formatDist(dist)
                end
                Draw.text(sp, label, iCol, CFG.ItemESP.NameSize)
            end

            if CFG.ItemESP.Tracers then
                Draw.line(Vector2.new(ctr.X, vp.Y), sp, tCol, CFG.ItemESP.TracerThick)
            end

            if CFG.ItemESP.Icon then
                Draw.text(Vector2.new(sp.X, sp.Y - 16), "[*]", Color3.fromRGB(255, 200, 50), 11)
            end
        end
    end

    -- WATERMARK (every N frames)
    if doWM then
        renderWatermark()
    end
end)

Players.PlayerRemoving:Connect(function(p) killChams(p) end)

--------------------------------------------------------------
-- GUI — PROFESSIONAL TABBED MENU
--------------------------------------------------------------
local SG = Instance.new("ScreenGui")
SG.Name = "AX_" .. tostring(math.random(10000, 99999))
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

if ENV.ProtectGui then
    pcall(function()
        if typeof(syn) == "table" and syn.protect_gui then
            syn.protect_gui(SG)
        elseif protect_gui then
            protect_gui(SG)
        end
    end)
end

if ENV.GetHUI then
    pcall(function() SG.Parent = gethui() end)
end
if not SG.Parent and ENV.CoreGui then
    pcall(function() SG.Parent = game:GetService("CoreGui") end)
end
if not SG.Parent then
    pcall(function() SG.Parent = LP:WaitForChild("PlayerGui") end)
end

if not SG.Parent then
    warn(tag .. " CRITICAL: Could not parent GUI anywhere")
end

-- Blur effect
local blur = nil
if CFG.GUI.BlurBackground then
    pcall(function()
        blur = Instance.new("BlurEffect")
        blur.Size = 0
        blur.Parent = Lighting
    end)
end

local menuOpen = false

-- Theme colors
local TH = {
    BG       = Color3.fromRGB(12, 12, 16),
    Panel    = Color3.fromRGB(20, 20, 26),
    Header   = Color3.fromRGB(24, 24, 32),
    Accent   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    AccentD  = Color3.fromRGB(90, 40, 180),
    AccentAlt = Color3.fromRGB(CFG.GUI.AccentAlt[1], CFG.GUI.AccentAlt[2], CFG.GUI.AccentAlt[3]),
    Text     = Color3.fromRGB(220, 220, 230),
    Sub      = Color3.fromRGB(120, 120, 140),
    On       = Color3.fromRGB(80, 220, 60),
    Off      = Color3.fromRGB(55, 55, 70),
    SlBG     = Color3.fromRGB(32, 32, 44),
    SlFill   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    Bdr      = Color3.fromRGB(40, 40, 54),
    Tab      = Color3.fromRGB(18, 18, 24),
    TabHov   = Color3.fromRGB(28, 28, 38),
    TabAct   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    Hover    = Color3.fromRGB(28, 28, 36),
    Sep      = Color3.fromRGB(36, 36, 48),
}

-- Dimensions
local MENU_W = math.floor(520 * CFG.GUI.Scale)
local MENU_H = math.floor(620 * CFG.GUI.Scale)
local TAB_W = math.floor(120 * CFG.GUI.Scale)
local HDR_H = math.floor(44 * CFG.GUI.Scale)

-- Main frame
local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, MENU_W, 0, MENU_H)
Main.Position = UDim2.new(0.5, -MENU_W / 2, 0.5, -MENU_H / 2)
Main.BackgroundColor3 = TH.BG
Main.BackgroundTransparency = 1 - CFG.GUI.Opacity
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = TH.Bdr
mainStroke.Thickness = 1

-- Accent line at top
local accentLine = Instance.new("Frame", Main)
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.BackgroundColor3 = TH.Accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 10

local accentGrad = Instance.new("UIGradient", accentLine)
accentGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt)

-- Header
local Hdr = Instance.new("Frame", Main)
Hdr.Size = UDim2.new(1, 0, 0, HDR_H)
Hdr.Position = UDim2.new(0, 0, 0, 2)
Hdr.BackgroundColor3 = TH.Header
Hdr.BorderSizePixel = 0

local tLbl = Instance.new("TextLabel", Hdr)
tLbl.Text = "  AXIOM UNIVERSAL"
tLbl.Font = Enum.Font.GothamBold
tLbl.TextSize = math.floor(16 * CFG.GUI.Scale)
tLbl.TextColor3 = TH.Accent
tLbl.BackgroundTransparency = 1
tLbl.Position = UDim2.new(0, 0, 0, 0)
tLbl.Size = UDim2.new(0.5, 0, 1, 0)
tLbl.TextXAlignment = Enum.TextXAlignment.Left

local vLbl = Instance.new("TextLabel", Hdr)
vLbl.Text = "v3.1 | Universal  "
vLbl.Font = Enum.Font.Gotham
vLbl.TextSize = math.floor(11 * CFG.GUI.Scale)
vLbl.TextColor3 = TH.Sub
vLbl.BackgroundTransparency = 1
vLbl.Position = UDim2.new(0.5, 0, 0, 0)
vLbl.Size = UDim2.new(0.5, 0, 1, 0)
vLbl.TextXAlignment = Enum.TextXAlignment.Right

-- Status dot
local statusDot = Instance.new("Frame", Hdr)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 6, 0.5, -4)
statusDot.BackgroundColor3 = TH.On
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

-- Divider under header
local hDiv = Instance.new("Frame", Main)
hDiv.Size = UDim2.new(1, 0, 0, 1)
hDiv.Position = UDim2.new(0, 0, 0, HDR_H + 2)
hDiv.BackgroundColor3 = TH.Sep
hDiv.BorderSizePixel = 0

-- Drag
local dragging, dragS, posS = false, nil, nil
Hdr.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragS = i.Position
        posS = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragS
        Main.Position = UDim2.new(posS.X.Scale, posS.X.Offset + d.X, posS.Y.Scale, posS.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Tab sidebar
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, TAB_W, 1, -(HDR_H + 3))
TabBar.Position = UDim2.new(0, 0, 0, HDR_H + 3)
TabBar.BackgroundColor3 = TH.Tab
TabBar.BorderSizePixel = 0

local tabLayout = Instance.new("UIListLayout", TabBar)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)

local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingTop = UDim.new(0, 6)
tabPad.PaddingLeft = UDim.new(0, 4)
tabPad.PaddingRight = UDim.new(0, 4)

-- Tab divider
local tDiv = Instance.new("Frame", Main)
tDiv.Size = UDim2.new(0, 1, 1, -(HDR_H + 3))
tDiv.Position = UDim2.new(0, TAB_W, 0, HDR_H + 3)
tDiv.BackgroundColor3 = TH.Sep
tDiv.BorderSizePixel = 0

-- Content area
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -(TAB_W + 1), 1, -(HDR_H + 3))
ContentArea.Position = UDim2.new(0, TAB_W + 1, 0, HDR_H + 3)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true

--------------------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------------------
local tabs = {}
local activeTab = nil

local TAB_DEFS = {
    {name = "Aimbot",   icon = ""},
    {name = "Silent",   icon = ""},
    {name = "ESP",      icon = ""},
    {name = "Chams",    icon = ""},
    {name = "Visuals",  icon = ""},
    {name = "Settings", icon = ""},
}

local function switchTab(name)
    if activeTab == name then return end
    activeTab = name
    for tName, tData in pairs(tabs) do
        local isActive = tName == name
        tData.page.Visible = isActive
        TweenService:Create(tData.btn, TweenInfo.new(CFG.GUI.AnimSpeed), {
            BackgroundColor3 = isActive and TH.Accent or TH.Tab,
            BackgroundTransparency = isActive and 0 or 1
        }):Play()
        tData.lbl.TextColor3 = isActive and Color3.new(1, 1, 1) or TH.Sub
    end
end

for idx, def in ipairs(TAB_DEFS) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, math.floor(32 * CFG.GUI.Scale))
    btn.BackgroundColor3 = TH.Tab
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.LayoutOrder = idx
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = def.icon .. " " .. def.name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = math.floor(12 * CFG.GUI.Scale)
    lbl.TextColor3 = TH.Sub
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = TH.Accent
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false

    local pLay = Instance.new("UIListLayout", page)
    pLay.SortOrder = Enum.SortOrder.LayoutOrder
    pLay.Padding = UDim.new(0, 4)

    local pPad = Instance.new("UIPadding", page)
    pPad.PaddingTop = UDim.new(0, 6)
    pPad.PaddingBottom = UDim.new(0, 10)
    pPad.PaddingLeft = UDim.new(0, 6)
    pPad.PaddingRight = UDim.new(0, 6)

    tabs[def.name] = {btn = btn, lbl = lbl, page = page, ord = 0}

    btn.MouseEnter:Connect(function()
        if activeTab ~= def.name then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0, BackgroundColor3 = TH.TabHov}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= def.name then
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(def.name) end)
end

--------------------------------------------------------------
-- UI COMPONENT BUILDERS
--------------------------------------------------------------
local function getPage(tabName)
    local t = tabs[tabName]
    t.ord = t.ord + 1
    return t.page, t.ord
end

local function Section(tabName, name)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order

    local l = Instance.new("TextLabel", f)
    l.Text = "▸ " .. string.upper(name)
    l.Font = Enum.Font.GothamBold
    l.TextSize = math.floor(11 * CFG.GUI.Scale)
    l.TextColor3 = TH.Accent
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Position = UDim2.new(0, 4, 0, 0)
end

local function Toggle(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = math.floor(13 * CFG.GUI.Scale)
    l.TextColor3 = TH.Text
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", f)
    bg.Size = UDim2.new(0, 38, 0, 18)
    bg.Position = UDim2.new(1, -48, 0.5, -9)
    bg.BackgroundColor3 = tbl[key] and TH.On or TH.Off
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = tbl[key] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        tbl[key] = not tbl[key]
        local on = tbl[key]
        TweenService:Create(bg, TweenInfo.new(0.15), {BackgroundColor3 = on and TH.On or TH.Off}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

local function Slider(tabName, label, tbl, key, mn, mx, stp, sfx)
    sfx = sfx or ""
    stp = stp or 1
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 44)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = math.floor(12 * CFG.GUI.Scale)
    l.TextColor3 = TH.Text
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 2)
    l.Size = UDim2.new(0.5, 0, 0, 18)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = math.floor(12 * CFG.GUI.Scale)
    vl.TextColor3 = TH.Accent
    vl.BackgroundTransparency = 1
    vl.Position = UDim2.new(0.5, 0, 0, 2)
    vl.Size = UDim2.new(0.5, -10, 0, 18)
    vl.TextXAlignment = Enum.TextXAlignment.Right

    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -20, 0, 6)
    trk.Position = UDim2.new(0, 10, 0, 30)
    trk.BackgroundColor3 = TH.SlBG
    trk.BorderSizePixel = 0
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", trk)
    fill.BackgroundColor3 = TH.SlFill
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt)

    local knob = Instance.new("Frame", trk)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function upd(v)
        v = math.clamp(v, mn, mx)
        v = math.floor(v / stp + 0.5) * stp
        tbl[key] = v
        local frac = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(frac, 0, 1, 0)
        knob.Position = UDim2.new(frac, 0, 0.5, 0)
        vl.Text = tostring(math.floor(v * 1000 + 0.5) / 1000) .. sfx
    end
    upd(tbl[key])

    local sliding = false
    trk.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            upd(mn + (mx - mn) * math.clamp((i.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1))
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            upd(mn + (mx - mn) * math.clamp((i.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1))
        end
    end)
end

local function Dropdown(tabName, label, tbl, key, options)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.ClipsDescendants = false
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = math.floor(12 * CFG.GUI.Scale)
    l.TextColor3 = TH.Text
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0)
    l.Size = UDim2.new(0.5, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local dbtn = Instance.new("TextButton", f)
    dbtn.Size = UDim2.new(0.45, -10, 0, 22)
    dbtn.Position = UDim2.new(0.55, 0, 0.5, -11)
    dbtn.BackgroundColor3 = TH.SlBG
    dbtn.BorderSizePixel = 0
    dbtn.Font = Enum.Font.Gotham
    dbtn.TextSize = math.floor(11 * CFG.GUI.Scale)
    dbtn.TextColor3 = TH.Text
    dbtn.Text = tostring(tbl[key]) .. " ▾"
    Instance.new("UICorner", dbtn).CornerRadius = UDim.new(0, 4)

    local dropFrame = Instance.new("Frame", f)
    dropFrame.Size = UDim2.new(0.45, -10, 0, #options * 24 + 4)
    dropFrame.Position = UDim2.new(0.55, 0, 1, 4)
    dropFrame.BackgroundColor3 = TH.Header
    dropFrame.BorderSizePixel = 0
    dropFrame.Visible = false
    dropFrame.ZIndex = 50
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", dropFrame).Color = TH.Bdr

    local dLay = Instance.new("UIListLayout", dropFrame)
    dLay.SortOrder = Enum.SortOrder.LayoutOrder
    dLay.Padding = UDim.new(0, 0)

    local dPad = Instance.new("UIPadding", dropFrame)
    dPad.PaddingTop = UDim.new(0, 2)

    for oi, opt in ipairs(options) do
        local ob = Instance.new("TextButton", dropFrame)
        ob.Size = UDim2.new(1, -4, 0, 24)
        ob.Position = UDim2.new(0, 2, 0, 0)
        ob.BackgroundColor3 = TH.Header
        ob.BackgroundTransparency = 1
        ob.BorderSizePixel = 0
        ob.Font = Enum.Font.Gotham
        ob.TextSize = math.floor(11 * CFG.GUI.Scale)
        ob.TextColor3 = TH.Text
        ob.Text = opt
        ob.LayoutOrder = oi
        ob.ZIndex = 51

        ob.MouseEnter:Connect(function()
            ob.BackgroundTransparency = 0
            ob.BackgroundColor3 = TH.Hover
        end)
        ob.MouseLeave:Connect(function()
            ob.BackgroundTransparency = 1
        end)
        ob.MouseButton1Click:Connect(function()
            tbl[key] = opt
            dbtn.Text = opt .. " ▾"
            dropFrame.Visible = false
        end)
    end

    dbtn.MouseButton1Click:Connect(function()
        dropFrame.Visible = not dropFrame.Visible
    end)
end

local function ColorPick(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 56)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = math.floor(12 * CFG.GUI.Scale)
    l.TextColor3 = TH.Text
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 2)
    l.Size = UDim2.new(0.6, 0, 0, 18)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local prev = Instance.new("Frame", f)
    prev.Size = UDim2.new(0, 22, 0, 12)
    prev.Position = UDim2.new(1, -36, 0, 5)
    prev.BackgroundColor3 = U.c3(tbl[key])
    prev.BorderSizePixel = 0
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", prev).Color = TH.Bdr

    local hBar = Instance.new("Frame", f)
    hBar.Size = UDim2.new(1, -20, 0, 8)
    hBar.Position = UDim2.new(0, 10, 0, 22)
    hBar.BackgroundColor3 = Color3.new(1, 1, 1)
    hBar.BorderSizePixel = 0
    Instance.new("UICorner", hBar).CornerRadius = UDim.new(1, 0)
    local hGrad = Instance.new("UIGradient", hBar)
    local pts = {}
    for i = 0, 6 do
        pts[#pts + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1))
    end
    hGrad.Color = ColorSequence.new(pts)

    local sBar = Instance.new("Frame", f)
    sBar.Size = UDim2.new(0.47, -10, 0, 8)
    sBar.Position = UDim2.new(0, 10, 0, 36)
    sBar.BackgroundColor3 = Color3.new(1, 1, 1)
    sBar.BorderSizePixel = 0
    Instance.new("UICorner", sBar).CornerRadius = UDim.new(1, 0)

    local bBar = Instance.new("Frame", f)
    bBar.Size = UDim2.new(0.47, -10, 0, 8)
    bBar.Position = UDim2.new(0.53, 0, 0, 36)
    bBar.BackgroundColor3 = Color3.new(1, 1, 1)
    bBar.BorderSizePixel = 0
    Instance.new("UICorner", bBar).CornerRadius = UDim.new(1, 0)

    local cH, cS, cV = Color3.new(tbl[key][1], tbl[key][2], tbl[key][3]):ToHSV()

    local function apply()
        local c = Color3.fromHSV(cH, cS, cV)
        tbl[key] = {c.R, c.G, c.B}
        prev.BackgroundColor3 = c
        local sg = sBar:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", sBar)
        sg.Color = ColorSequence.new(Color3.fromHSV(cH, 0, cV), Color3.fromHSV(cH, 1, cV))
        local bg2 = bBar:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", bBar)
        bg2.Color = ColorSequence.new(Color3.fromHSV(cH, cS, 0), Color3.fromHSV(cH, cS, 1))
    end
    apply()

    local dH, dS, dV = false, false, false
    hBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = true end
    end)
    sBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dS = true end
    end)
    bBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dV = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = false; dS = false; dV = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if dH then
            cH = math.clamp((i.Position.X - hBar.AbsolutePosition.X) / hBar.AbsoluteSize.X, 0, 0.999)
            apply()
        end
        if dS then
            cS = math.clamp((i.Position.X - sBar.AbsolutePosition.X) / sBar.AbsoluteSize.X, 0, 1)
            apply()
        end
        if dV then
            cV = math.clamp((i.Position.X - bBar.AbsolutePosition.X) / bBar.AbsoluteSize.X, 0, 1)
            apply()
        end
    end)
end

--------------------------------------------------------------
-- BUILD ALL TABS
--------------------------------------------------------------

-- ═══ AIMBOT TAB ═══
Section("Aimbot", "Aimbot")
Toggle("Aimbot", "Enabled", CFG.Aimbot, "On")
Dropdown("Aimbot", "Mode", CFG.Aimbot, "Mode", {"Smooth", "Snap"})
Dropdown("Aimbot", "Target Part", CFG.Aimbot, "Part", {"Head", "Torso", "Closest"})
Dropdown("Aimbot", "Priority", CFG.Aimbot, "Priority", {"FOV", "Distance", "Health"})
Slider("Aimbot", "FOV Radius", CFG.Aimbot, "FOV", 20, 600, 5, "px")
Slider("Aimbot", "Smoothness", CFG.Aimbot, "Smoothness", 0.01, 1.0, 0.01, "")
Slider("Aimbot", "Max Distance", CFG.Aimbot, "MaxDist", 100, 5000, 50, "m")
Toggle("Aimbot", "Show FOV Circle", CFG.Aimbot, "ShowFOV")
Toggle("Aimbot", "Prediction", CFG.Aimbot, "Predict")
Slider("Aimbot", "Predict Scale", CFG.Aimbot, "PredictScale", 0.01, 0.5, 0.005, "")
Toggle("Aimbot", "Team Check", CFG.Aimbot, "TeamCheck")
Toggle("Aimbot", "Wall Check", CFG.Aimbot, "WallCheck")
Toggle("Aimbot", "Visibility Check", CFG.Aimbot, "VisCheck")

Section("Aimbot", "FOV Circle Style")
Slider("Aimbot", "FOV Thickness", CFG.Aimbot, "FOVThick", 0.5, 5, 0.1, "")
Slider("Aimbot", "FOV Opacity", CFG.Aimbot, "FOVAlpha", 0.1, 1.0, 0.05, "")
Slider("Aimbot", "FOV Sides", CFG.Aimbot, "FOVSides", 12, 128, 1, "")
Toggle("Aimbot", "FOV Filled", CFG.Aimbot, "FOVFilled")
ColorPick("Aimbot", "FOV Color", CFG.Aimbot, "FOVColor")

-- ═══ SILENT AIM TAB ═══
Section("Silent", "Silent Aim")
Toggle("Silent", "Enabled", CFG.SilentAim, "On")
Dropdown("Silent", "Target Part", CFG.SilentAim, "Part", {"Head", "Torso", "Closest"})
Slider("Silent", "FOV Radius", CFG.SilentAim, "FOV", 20, 500, 5, "px")
Slider("Silent", "Hit Chance", CFG.SilentAim, "HitChance", 1, 100, 1, "%")
Toggle("Silent", "Show FOV Circle", CFG.SilentAim, "ShowFOV")
Toggle("Silent", "Prediction", CFG.SilentAim, "Predict")
Slider("Silent", "Predict Scale", CFG.SilentAim, "PredictScale", 0.01, 0.5, 0.005, "")
Toggle("Silent", "Wall Check", CFG.SilentAim, "WallCheck")
Toggle("Silent", "Team Check", CFG.SilentAim, "TeamCheck")

Section("Silent", "FOV Circle Style")
Slider("Silent", "FOV Thickness", CFG.SilentAim, "FOVThick", 0.5, 5, 0.1, "")
Slider("Silent", "FOV Opacity", CFG.SilentAim, "FOVAlpha", 0.1, 1.0, 0.05, "")
ColorPick("Silent", "FOV Color", CFG.SilentAim, "FOVColor")

-- ═══ ESP TAB ═══
Section("ESP", "Box ESP")
Toggle("ESP", "Enabled", CFG.BoxESP, "On")
Dropdown("ESP", "Box Mode", CFG.BoxESP, "Mode", {"Full", "Corner", "3D"})
Toggle("ESP", "Names", CFG.BoxESP, "Name")
Toggle("ESP", "Health Bars", CFG.BoxESP, "Health")
Toggle("ESP", "Health Numbers", CFG.BoxESP, "HealthNum")
Toggle("ESP", "Distance", CFG.BoxESP, "Dist")
Toggle("ESP", "Weapon Name", CFG.BoxESP, "Weapon")
Toggle("ESP", "Show Teammates", CFG.BoxESP, "ShowTeam")
Toggle("ESP", "Outline", CFG.BoxESP, "Outline")
Slider("ESP", "Max Distance", CFG.BoxESP, "MaxDist", 100, 5000, 50, "m")
Slider("ESP", "Thickness", CFG.BoxESP, "Thick", 0.5, 5, 0.1, "")
Slider("ESP", "Name Size", CFG.BoxESP, "NameSize", 8, 22, 1, "")
Slider("ESP", "Corner Length", CFG.BoxESP, "CornerLength", 2, 20, 1, "")
Slider("ESP", "Fill Opacity", CFG.BoxESP, "FillAlpha", 0, 1, 0.05, "")
ColorPick("ESP", "Enemy Color", CFG.BoxESP, "EnemyColor")
ColorPick("ESP", "Team Color", CFG.BoxESP, "TeamColor")
ColorPick("ESP", "Enemy Fill", CFG.BoxESP, "EnemyFill")
ColorPick("ESP", "Team Fill", CFG.BoxESP, "TeamFill")
ColorPick("ESP", "Outline Color", CFG.BoxESP, "OutlineColor")

Section("ESP", "Tracers")
Toggle("ESP", "Enabled", CFG.Tracers, "On")
Dropdown("ESP", "Origin", CFG.Tracers, "Origin", {"Bottom", "Center", "Mouse"})
Toggle("ESP", "Show Teammates", CFG.Tracers, "ShowTeam")
Slider("ESP", "Tracer Thickness", CFG.Tracers, "Thick", 0.5, 4, 0.1, "")
Slider("ESP", "Max Distance", CFG.Tracers, "MaxDist", 100, 5000, 50, "m")
ColorPick("ESP", "Enemy Tracer", CFG.Tracers, "EnemyColor")
ColorPick("ESP", "Team Tracer", CFG.Tracers, "TeamColor")

Section("ESP", "Snaplines")
Toggle("ESP", "Enabled", CFG.Snaplines, "On")
Dropdown("ESP", "Target Part", CFG.Snaplines, "Part", {"Head", "Torso", "Closest"})
Slider("ESP", "Thickness", CFG.Snaplines, "Thick", 0.3, 3, 0.1, "")
ColorPick("ESP", "Snapline Color", CFG.Snaplines, "Color")

Section("ESP", "Skeleton")
Toggle("ESP", "Enabled", CFG.Skeleton, "On")
Toggle("ESP", "Show Teammates", CFG.Skeleton, "ShowTeam")
Slider("ESP", "Max Distance", CFG.Skeleton, "MaxDist", 100, 3000, 50, "m")
Slider("ESP", "Thickness", CFG.Skeleton, "Thick", 0.3, 4, 0.1, "")
ColorPick("ESP", "Enemy Bones", CFG.Skeleton, "EnemyColor")
ColorPick("ESP", "Team Bones", CFG.Skeleton, "TeamColor")

Section("ESP", "Item ESP")
Toggle("ESP", "Enabled", CFG.ItemESP, "On")
Toggle("ESP", "Names", CFG.ItemESP, "Names")
Toggle("ESP", "Distance", CFG.ItemESP, "Dist")
Toggle("ESP", "Tracers", CFG.ItemESP, "Tracers")
Toggle("ESP", "Icons", CFG.ItemESP, "Icon")
Slider("ESP", "Max Distance", CFG.ItemESP, "MaxDist", 50, 2000, 50, "m")
Slider("ESP", "Name Size", CFG.ItemESP, "NameSize", 8, 20, 1, "")
Slider("ESP", "Tracer Thickness", CFG.ItemESP, "TracerThick", 0.5, 3, 0.1, "")
ColorPick("ESP", "Item Color", CFG.ItemESP, "Color")
ColorPick("ESP", "Tracer Color", CFG.ItemESP, "TracerColor")

-- ═══ CHAMS TAB ═══
Section("Chams", "Chams")
Toggle("Chams", "Enabled", CFG.Chams, "On")
Dropdown("Chams", "Mode", CFG.Chams, "Mode", {"Standard", "Neon", "Rainbow", "Flat"})
Dropdown("Chams", "Depth Mode", CFG.Chams, "DepthMode", {"AlwaysOnTop", "Occluded"})
Toggle("Chams", "Team Colors", CFG.Chams, "TeamCheck")
Toggle("Chams", "Visible Only", CFG.Chams, "VisibleOnly")

Section("Chams", "Standard Colors")
Slider("Chams", "Fill Transparency", CFG.Chams, "FillAlpha", 0, 1, 0.05, "")
Slider("Chams", "Outline Transparency", CFG.Chams, "OutAlpha", 0, 1, 0.05, "")
ColorPick("Chams", "Fill Color", CFG.Chams, "FillColor")
ColorPick("Chams", "Outline Color", CFG.Chams, "OutColor")

Section("Chams", "Team-Based Colors")
ColorPick("Chams", "Enemy Fill", CFG.Chams, "EnemyFill")
ColorPick("Chams", "Team Fill", CFG.Chams, "TeamFill")
ColorPick("Chams", "Enemy Outline", CFG.Chams, "EnemyOut")
ColorPick("Chams", "Team Outline", CFG.Chams, "TeamOut")

Section("Chams", "Neon Settings")
Slider("Chams", "Neon Fill Alpha", CFG.Chams, "NeonAlpha", 0, 1, 0.05, "")
Slider("Chams", "Neon Outline Alpha", CFG.Chams, "NeonOutAlpha", 0, 1, 0.05, "")
ColorPick("Chams", "Neon Color", CFG.Chams, "NeonColor")

Section("Chams", "Rainbow Settings")
Slider("Chams", "Rainbow Speed", CFG.Chams, "RainbowSpeed", 0.1, 5, 0.1, "x")

-- ═══ VISUALS TAB ═══
Section("Visuals", "Crosshair")
Toggle("Visuals", "Enabled", CFG.Crosshair, "On")
Dropdown("Visuals", "Style", CFG.Crosshair, "Style", {"Cross", "Circle", "Dot", "Diamond"})
Slider("Visuals", "Size", CFG.Crosshair, "Size", 2, 40, 1, "px")
Slider("Visuals", "Gap", CFG.Crosshair, "Gap", 0, 20, 1, "px")
Slider("Visuals", "Thickness", CFG.Crosshair, "Thick", 0.5, 5, 0.1, "")
Toggle("Visuals", "Center Dot", CFG.Crosshair, "Dot")
Slider("Visuals", "Dot Size", CFG.Crosshair, "DotSize", 1, 6, 0.5, "")
Toggle("Visuals", "Outline", CFG.Crosshair, "Outline")
Toggle("Visuals", "Rotate", CFG.Crosshair, "Rotate")
Slider("Visuals", "Rotate Speed", CFG.Crosshair, "RotateSpeed", 0.5, 10, 0.5, "")
ColorPick("Visuals", "Crosshair Color", CFG.Crosshair, "Color")

Section("Visuals", "FOV Changer")
Toggle("Visuals", "Enabled", CFG.FOVChanger, "On")
Slider("Visuals", "Field of View", CFG.FOVChanger, "Value", 30, 120, 1, "")
Toggle("Visuals", "Smooth Transition", CFG.FOVChanger, "Smooth")
Slider("Visuals", "Smooth Speed", CFG.FOVChanger, "SmoothSpeed", 0.01, 0.5, 0.01, "")

Section("Visuals", "Watermark")
Toggle("Visuals", "Enabled", CFG.Watermark, "On")
Toggle("Visuals", "Show FPS", CFG.Watermark, "ShowFPS")
Toggle("Visuals", "Show Ping", CFG.Watermark, "ShowPing")
Toggle("Visuals", "Show Time", CFG.Watermark, "ShowTime")
Toggle("Visuals", "Show Game Name", CFG.Watermark, "ShowGame")

-- ═══ SETTINGS TAB ═══
Section("Settings", "Menu")
Slider("Settings", "Menu Scale", CFG.GUI, "Scale", 0.6, 1.5, 0.05, "x")
Slider("Settings", "Menu Opacity", CFG.GUI, "Opacity", 0.5, 1.0, 0.01, "")
Slider("Settings", "Animation Speed", CFG.GUI, "AnimSpeed", 0.05, 0.5, 0.01, "s")
Toggle("Settings", "Blur Background", CFG.GUI, "BlurBackground")
ColorPick("Settings", "Accent Color", CFG.GUI, "Accent")
ColorPick("Settings", "Accent Alt", CFG.GUI, "AccentAlt")

--------------------------------------------------------------
-- MENU TOGGLE + ANIMATION
--------------------------------------------------------------
switchTab("Aimbot")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CFG.GUI.MenuKey then
        menuOpen = not menuOpen

        if menuOpen then
            Main.Visible = true
            Main.Size = UDim2.new(0, MENU_W, 0, 0)
            TweenService:Create(Main, TweenInfo.new(CFG.GUI.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, MENU_W, 0, MENU_H)
            }):Play()
            if blur then
                TweenService:Create(blur, TweenInfo.new(CFG.GUI.AnimSpeed), {Size = 6}):Play()
            end
        else
            TweenService:Create(Main, TweenInfo.new(CFG.GUI.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, MENU_W, 0, 0)
            }):Play()
            if blur then
                TweenService:Create(blur, TweenInfo.new(CFG.GUI.AnimSpeed), {Size = 0}):Play()
            end
            task.delay(CFG.GUI.AnimSpeed, function()
                if not menuOpen then Main.Visible = false end
            end)
        end
    end
end)

--------------------------------------------------------------
-- CLEANUP ON DESTROY
--------------------------------------------------------------
local function cleanup()
    if blur then pcall(function() blur:Destroy() end) end
    for _, p in ipairs(Players:GetPlayers()) do killChams(p) end

    if ENV.Drawing then
        Draw.Lines:destroy()
        Draw.Texts:destroy()
        Draw.Circles:destroy()
        Draw.Squares:destroy()
        Draw.Quads:destroy()
        pcall(function() Draw.AimbotFOV:Remove() end)
        pcall(function() Draw.SilentFOV:Remove() end)
        for _, ln in ipairs(Draw.CrossLines) do pcall(function() ln:Remove() end) end
        pcall(function() Draw.CrossDot:Remove() end)
        pcall(function() Draw.WatermarkBG:Remove() end)
        pcall(function() Draw.WatermarkBorder:Remove() end)
        pcall(function() Draw.WatermarkAccent:Remove() end)
        pcall(function() Draw.WatermarkText:Remove() end)
    end
end

SG.Destroying:Connect(cleanup)
LP.CharacterRemoving:Connect(function()
    currentTarget = nil
    silentTarget = nil
end)

--------------------------------------------------------------
-- DONE
--------------------------------------------------------------
print(tag .. " ═══════════════════════════════════════")
print(tag .. " Full build loaded successfully.")
print(tag .. " Press Right Control to open menu.")
print(tag .. " Features: " .. (ENV.Drawing and "Drawing OK" or "Drawing NO"))
print(tag .. " Hook: " .. (ENV.Hook or "None (camera fallback)"))
print(tag .. " GUI: " .. (ENV.GetHUI and "gethui" or ENV.CoreGui and "CoreGui" or "PlayerGui"))
print(tag .. " ═══════════════════════════════════════")
