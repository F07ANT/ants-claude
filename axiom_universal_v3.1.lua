local unpack = unpack or table.unpack
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local ENV = {}
ENV.Drawing = (function()
    local ok = pcall(function() local t = Drawing.new("Line"); t:Remove() end)
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
    local ok = pcall(function() local t = Instance.new("Folder"); t.Parent = game:GetService("CoreGui"); t:Destroy() end)
    return ok
end)()
ENV.GetHUI = typeof(gethui) == "function"
ENV.ProtectGui = typeof(protect_gui) == "function" or (typeof(syn) == "table" and typeof(syn.protect_gui) == "function")
ENV.RawMT = typeof(getrawmetatable) == "function"

local CFG = {
    Aimbot = {
        On = false,
        Key = Enum.UserInputType.MouseButton2,
        Mode = "Smooth",
        Smoothness = 0.15,
        Part = "Head",
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
        Priority = "FOV",
    },
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
    BoxESP = {
        On = false,
        Mode = "Full",
        EnemyColor = {1, 0.15, 0.15},
        TeamColor = {0.15, 1, 0.15},
        EnemyFill = {1, 0, 0},
        TeamFill = {0, 1, 0},
        FillAlpha = 0,
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
    Tracers = {
        On = false,
        Origin = "Bottom",
        EnemyColor = {1, 0.3, 0.3},
        TeamColor = {0.3, 1, 0.3},
        Thick = 1.2,
        MaxDist = 2000,
        ShowTeam = false,
    },
    Snaplines = {
        On = false,
        Color = {1, 1, 0},
        Thick = 0.8,
        Part = "Head",
    },
    Skeleton = {
        On = false,
        EnemyColor = {1, 1, 1},
        TeamColor = {0.5, 0.5, 1},
        Thick = 1.2,
        MaxDist = 1200,
        ShowTeam = false,
    },
    Chams = {
        On = false,
        Mode = "Glow",
        GlowColor = {0.5, 0, 1},
        GlowAlpha = 0.35,
        GlowSize = 0.06,
        HighlightFill = {0.5, 0, 1},
        HighlightOut = {1, 1, 1},
        HighlightFillAlpha = 0.6,
        HighlightOutAlpha = 0.0,
        XRayVisibleFill = {0, 1, 0.5},
        XRayVisibleAlpha = 0.4,
        XRayOccludedFill = {1, 0, 0.3},
        XRayOccludedAlpha = 0.7,
        NeonColor = {0, 1, 0.8},
        NeonAlpha = 0.25,
        RainbowSpeed = 1,
        EnemyColor = {1, 0, 0.3},
        TeamColor = {0, 0.4, 1},
        TeamCheck = true,
        DepthMode = "AlwaysOnTop",
    },
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
    },
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
        Style = "Cross",
    },
    FOVChanger = {
        On = false,
        Value = 70,
        Smooth = true,
        SmoothSpeed = 0.1,
    },
    Watermark = {
        On = true,
        ShowFPS = true,
        ShowPing = true,
        ShowTime = true,
        ShowGame = true,
    },
    GUI = {
        MenuKey = Enum.KeyCode.RightControl,
        Scale = 1.0,
        Opacity = 0.97,
        AnimSpeed = 0.25,
        Accent = {130, 60, 255},
        AccentAlt = {90, 200, 255},
        BlurBackground = true,
    },
}

local U = {}
function U.c3(t) return Color3.new(t[1], t[2], t[3]) end
function U.c3rgb(t) return Color3.fromRGB(t[1], t[2], t[3]) end
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
    return workspace:Raycast(from, to - from, params) == nil
end
function U.visCheck(from, to, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {Camera}
    if LP.Character then table.insert(filter, LP.Character) end
    if targetChar then table.insert(filter, targetChar) end
    params.FilterDescendantsInstances = filter
    return workspace:Raycast(from, to - from, params) == nil
end
function U.getWeapon(p)
    local ch = p.Character
    if not ch then return "None" end
    local tool = ch:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "None"
end
function U.closestPart(ch, origin)
    local bestPart, bestDist = nil, math.huge
    for _, name in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"}) do
        local part = ch:FindFirstChild(name)
        if part then
            local d = (part.Position - origin).Magnitude
            if d < bestDist then bestDist = d; bestPart = part end
        end
    end
    return bestPart
end
function U.lerp(a, b, t) return a + (b - a) * t end
function U.lerpColor(a, b, t)
    return Color3.new(U.lerp(a.R, b.R, t), U.lerp(a.G, b.G, t), U.lerp(a.B, b.B, t))
end
function U.rainbow(speed, offset)
    return Color3.fromHSV((tick() * (speed or 1) + (offset or 0)) % 1, 1, 1)
end
function U.hpColor(frac)
    if frac > 0.5 then
        return U.lerpColor(Color3.fromRGB(255, 200, 0), Color3.fromRGB(0, 255, 0), (frac - 0.5) * 2)
    else
        return U.lerpColor(Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 200, 0), frac * 2)
    end
end
function U.formatDist(d) return string.format("[%dm]", math.floor(d)) end
function U.formatHP(p)
    local ch = p.Character
    if not ch then return "0" end
    local h = ch:FindFirstChildOfClass("Humanoid")
    return h and tostring(math.floor(h.Health)) or "0"
end

local Draw = {}
if ENV.Drawing then
    local Pool = {}
    Pool.__index = Pool
    function Pool.new(cls, defs)
        return setmetatable({c = cls, d = defs, p = {}, n = 0}, Pool)
    end
    function Pool:get()
        self.n = self.n + 1
        if self.p[self.n] then return self.p[self.n] end
        local obj = Drawing.new(self.c)
        for k, v in pairs(self.d) do obj[k] = v end
        self.p[self.n] = obj
        return obj
    end
    function Pool:flush()
        for i = 1, self.n do self.p[i].Visible = false end
        self.n = 0
    end
    function Pool:destroy()
        for i = 1, #self.p do pcall(function() self.p[i]:Remove() end) end
        self.p = {}; self.n = 0
    end

    Draw.Lines = Pool.new("Line", {Visible = false, Thickness = 1})
    Draw.Texts = Pool.new("Text", {Visible = false, Size = 13, Center = true, Outline = true, Font = 2})
    Draw.Circles = Pool.new("Circle", {Visible = false, Thickness = 1, NumSides = 30})
    Draw.Quads = Pool.new("Quad", {Visible = false, Thickness = 1})

    Draw.flush = function()
        Draw.Lines:flush(); Draw.Texts:flush(); Draw.Circles:flush(); Draw.Quads:flush()
    end
    Draw.line = function(from, to, col, thick)
        local l = Draw.Lines:get()
        l.From = from; l.To = to; l.Color = col; l.Thickness = thick or 1; l.Visible = true
        return l
    end
    Draw.text = function(pos, txt, col, size, center, outline)
        local t = Draw.Texts:get()
        t.Position = pos; t.Text = txt; t.Color = col; t.Size = size or 13
        t.Center = center ~= false; t.Outline = outline ~= false; t.Visible = true
        return t
    end
    Draw.circle = function(pos, radius, col, thick, filled, sides, alpha)
        local c = Draw.Circles:get()
        c.Position = pos; c.Radius = radius; c.Color = col; c.Thickness = thick or 1
        c.Filled = filled or false; c.NumSides = sides or 30; c.Transparency = alpha or 1; c.Visible = true
        return c
    end
    Draw.quad = function(a, b, c2, d, col, thick, filled)
        local q = Draw.Quads:get()
        q.PointA = a; q.PointB = b; q.PointC = c2; q.PointD = d
        q.Color = col; q.Thickness = thick or 1; q.Filled = filled or false; q.Visible = true
        return q
    end

    Draw.AimbotFOV = Drawing.new("Circle")
    Draw.AimbotFOV.NumSides = 64; Draw.AimbotFOV.Filled = false
    Draw.AimbotFOV.Thickness = 1.5; Draw.AimbotFOV.Transparency = 0.8; Draw.AimbotFOV.Visible = false

    Draw.SilentFOV = Drawing.new("Circle")
    Draw.SilentFOV.NumSides = 48; Draw.SilentFOV.Filled = false
    Draw.SilentFOV.Thickness = 1.2; Draw.SilentFOV.Transparency = 0.6; Draw.SilentFOV.Visible = false

    Draw.CrossLines = {}
    for i = 1, 8 do
        Draw.CrossLines[i] = Drawing.new("Line")
        Draw.CrossLines[i].Visible = false; Draw.CrossLines[i].Thickness = 1.5
    end
    Draw.CrossDot = Drawing.new("Circle")
    Draw.CrossDot.Filled = true; Draw.CrossDot.NumSides = 20; Draw.CrossDot.Visible = false

    Draw.WmBG = Drawing.new("Square")
    Draw.WmBG.Filled = true; Draw.WmBG.Visible = false
    Draw.WmBG.Color = Color3.fromRGB(10, 10, 14); Draw.WmBG.Transparency = 0.88

    Draw.WmBorder = Drawing.new("Square")
    Draw.WmBorder.Filled = false; Draw.WmBorder.Visible = false
    Draw.WmBorder.Thickness = 1

    Draw.WmAccent = Drawing.new("Line")
    Draw.WmAccent.Visible = false; Draw.WmAccent.Thickness = 2

    Draw.WmText = Drawing.new("Text")
    Draw.WmText.Visible = false; Draw.WmText.Size = 13; Draw.WmText.Font = 2
    Draw.WmText.Outline = true; Draw.WmText.Center = false
else
    local bbgFolder = Instance.new("Folder")
    bbgFolder.Name = "AX_E"; bbgFolder.Parent = workspace.CurrentCamera
    local bbgCache = {}
    Draw.flush = function()
        for _, v in pairs(bbgCache) do
            if v and v.Parent then pcall(function() v:Destroy() end) end
        end
        bbgCache = {}
    end
    Draw.line = function() end
    Draw.text = function() end
    Draw.circle = function() end
    Draw.quad = function() end
    Draw.bbgText = function(adornee, txt, col, offset)
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 200, 0, 50)
        bg.StudsOffset = offset or Vector3.new(0, 3.5, 0)
        bg.AlwaysOnTop = true; bg.Adornee = adornee; bg.Parent = bbgFolder
        local tl = Instance.new("TextLabel", bg)
        tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
        tl.TextColor3 = col; tl.Text = txt; tl.Font = Enum.Font.GothamBold
        tl.TextSize = 14; tl.TextStrokeTransparency = 0.5
        bbgCache[#bbgCache + 1] = bg
        return bg
    end
    Draw.bbgHealth = function(adornee, frac)
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 60, 0, 8)
        bg.StudsOffset = Vector3.new(0, 2.8, 0)
        bg.AlwaysOnTop = true; bg.Adornee = adornee; bg.Parent = bbgFolder
        local outer = Instance.new("Frame", bg)
        outer.Size = UDim2.new(1, 0, 1, 0); outer.BackgroundColor3 = Color3.new(0, 0, 0)
        outer.BackgroundTransparency = 0.3; outer.BorderSizePixel = 0
        Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 3)
        local inner = Instance.new("Frame", outer)
        inner.Size = UDim2.new(frac, -2, 1, -2); inner.Position = UDim2.new(0, 1, 0, 1)
        inner.BackgroundColor3 = U.hpColor(frac); inner.BorderSizePixel = 0
        Instance.new("UICorner", inner).CornerRadius = UDim.new(0, 2)
        bbgCache[#bbgCache + 1] = bg
        return bg
    end
    Draw.AimbotFOV = nil; Draw.SilentFOV = nil
    Draw.CrossLines = {}; Draw.CrossDot = nil
    Draw.WmBG = nil; Draw.WmBorder = nil; Draw.WmAccent = nil; Draw.WmText = nil
end

local glowCache = {}
local hlCache = {}
local xrayVisCache = {}
local xrayOccCache = {}

local GLOW_PARTS = {
    "Head", "UpperTorso", "LowerTorso", "Torso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot",
    "Left Arm", "Right Arm", "Left Leg", "Right Leg",
}

local function clearGlow(p)
    if glowCache[p] then
        for _, data in pairs(glowCache[p]) do
            pcall(function() data.weld:Destroy() end)
            pcall(function() data.clone:Destroy() end)
        end
        glowCache[p] = nil
    end
end

local function updateGlow(p)
    local ch = p.Character
    if not ch then clearGlow(p); return end

    local isEnemy = not U.team(p)
    local baseColor
    if CFG.Chams.Mode == "Rainbow" then
        baseColor = U.rainbow(CFG.Chams.RainbowSpeed)
    elseif CFG.Chams.Mode == "Neon" then
        baseColor = U.c3(CFG.Chams.NeonColor)
    elseif CFG.Chams.TeamCheck then
        baseColor = isEnemy and U.c3(CFG.Chams.EnemyColor) or U.c3(CFG.Chams.TeamColor)
    else
        baseColor = U.c3(CFG.Chams.GlowColor)
    end

    local alpha = CFG.Chams.GlowAlpha
    if CFG.Chams.Mode == "Neon" then alpha = CFG.Chams.NeonAlpha end
    local expand = CFG.Chams.GlowSize

    if not glowCache[p] then glowCache[p] = {} end

    for _, partName in ipairs(GLOW_PARTS) do
        local part = ch:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if not glowCache[p][partName] or not glowCache[p][partName].clone.Parent then
                if glowCache[p][partName] then
                    pcall(function() glowCache[p][partName].weld:Destroy() end)
                    pcall(function() glowCache[p][partName].clone:Destroy() end)
                end

                local clone = Instance.new("Part")
                clone.Name = "AX_G"
                clone.Anchored = false
                clone.CanCollide = false
                clone.CanTouch = false
                clone.CanQuery = false
                clone.CastShadow = false
                clone.Material = Enum.Material.Neon
                clone.Color = baseColor
                clone.Transparency = alpha
                clone.Size = part.Size + Vector3.new(expand, expand, expand)

                if part.Name == "Head" and part:FindFirstChildOfClass("SpecialMesh") then
                    local mesh = part:FindFirstChildOfClass("SpecialMesh"):Clone()
                    mesh.Scale = mesh.Scale * (1 + expand / 2)
                    mesh.Parent = clone
                elseif part.Name == "Head" then
                    local mesh = Instance.new("SpecialMesh", clone)
                    mesh.MeshType = Enum.MeshType.Head
                    mesh.Scale = Vector3.new(1 + expand, 1 + expand, 1 + expand)
                end

                local weld = Instance.new("WeldConstraint")
                weld.Part0 = part
                weld.Part1 = clone
                clone.CFrame = part.CFrame
                clone.Parent = ch
                weld.Parent = clone

                glowCache[p][partName] = {clone = clone, weld = weld, part = part}
            else
                local data = glowCache[p][partName]
                data.clone.Color = baseColor
                data.clone.Transparency = alpha
                data.clone.Size = data.part.Size + Vector3.new(expand, expand, expand)
            end
        else
            if glowCache[p] and glowCache[p][partName] then
                pcall(function() glowCache[p][partName].weld:Destroy() end)
                pcall(function() glowCache[p][partName].clone:Destroy() end)
                glowCache[p][partName] = nil
            end
        end
    end
end

local function setHighlight(p)
    local ch = p.Character
    if not ch then return end
    local isEnemy = not U.team(p)
    local fillCol, outCol, fillA, outA
    if CFG.Chams.Mode == "Rainbow" then
        local col = U.rainbow(CFG.Chams.RainbowSpeed)
        fillCol = col; outCol = col; fillA = CFG.Chams.HighlightFillAlpha; outA = CFG.Chams.HighlightOutAlpha
    elseif CFG.Chams.Mode == "Neon" then
        fillCol = U.c3(CFG.Chams.NeonColor); outCol = fillCol; fillA = CFG.Chams.NeonAlpha; outA = 0
    elseif CFG.Chams.TeamCheck then
        fillCol = isEnemy and U.c3(CFG.Chams.EnemyColor) or U.c3(CFG.Chams.TeamColor)
        outCol = fillCol; fillA = CFG.Chams.HighlightFillAlpha; outA = CFG.Chams.HighlightOutAlpha
    else
        fillCol = U.c3(CFG.Chams.HighlightFill); outCol = U.c3(CFG.Chams.HighlightOut)
        fillA = CFG.Chams.HighlightFillAlpha; outA = CFG.Chams.HighlightOutAlpha
    end
    local depth = CFG.Chams.DepthMode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    if hlCache[p] then
        local hl = hlCache[p]
        hl.FillColor = fillCol; hl.OutlineColor = outCol
        hl.FillTransparency = fillA; hl.OutlineTransparency = outA; hl.DepthMode = depth
        if not hl.Parent or hl.Adornee ~= ch then hl.Adornee = ch; hl.Parent = ch end
        return
    end
    local hl = Instance.new("Highlight")
    hl.FillColor = fillCol; hl.OutlineColor = outCol
    hl.FillTransparency = fillA; hl.OutlineTransparency = outA
    hl.DepthMode = depth; hl.Adornee = ch; hl.Parent = ch
    hlCache[p] = hl
end

local function setXRay(p)
    local ch = p.Character
    if not ch then return end
    local isEnemy = not U.team(p)
    local visFill = U.c3(CFG.Chams.XRayVisibleFill)
    local visAlpha = CFG.Chams.XRayVisibleAlpha
    local occFill = U.c3(CFG.Chams.XRayOccludedFill)
    local occAlpha = CFG.Chams.XRayOccludedAlpha
    if CFG.Chams.Mode == "Rainbow" then
        local col = U.rainbow(CFG.Chams.RainbowSpeed)
        visFill = col; occFill = U.lerpColor(col, Color3.new(0, 0, 0), 0.5)
    end

    if not xrayVisCache[p] then
        local hl = Instance.new("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = ch; hl.Parent = ch
        xrayVisCache[p] = hl
    end
    local vis = xrayVisCache[p]
    vis.FillColor = visFill; vis.OutlineColor = visFill
    vis.FillTransparency = visAlpha; vis.OutlineTransparency = 0.8
    if not vis.Parent or vis.Adornee ~= ch then vis.Adornee = ch; vis.Parent = ch end

    if not xrayOccCache[p] then
        local hl = Instance.new("Highlight")
        hl.DepthMode = Enum.HighlightDepthMode.Occluded
        hl.Adornee = ch; hl.Parent = ch
        xrayOccCache[p] = hl
    end
    local occ = xrayOccCache[p]
    occ.FillColor = occFill; occ.OutlineColor = occFill
    occ.FillTransparency = occAlpha; occ.OutlineTransparency = 0.5
    if not occ.Parent or occ.Adornee ~= ch then occ.Adornee = ch; occ.Parent = ch end
end

local function killChams(p)
    clearGlow(p)
    if hlCache[p] then pcall(function() hlCache[p]:Destroy() end); hlCache[p] = nil end
    if xrayVisCache[p] then pcall(function() xrayVisCache[p]:Destroy() end); xrayVisCache[p] = nil end
    if xrayOccCache[p] then pcall(function() xrayOccCache[p]:Destroy() end); xrayOccCache[p] = nil end
end

local function updateChams(p)
    if not CFG.Chams.On then killChams(p); return end
    local mode = CFG.Chams.Mode
    if mode == "Glow" or mode == "Neon" then
        if hlCache[p] then pcall(function() hlCache[p]:Destroy() end); hlCache[p] = nil end
        if xrayVisCache[p] then pcall(function() xrayVisCache[p]:Destroy() end); xrayVisCache[p] = nil end
        if xrayOccCache[p] then pcall(function() xrayOccCache[p]:Destroy() end); xrayOccCache[p] = nil end
        updateGlow(p)
    elseif mode == "X-Ray" then
        clearGlow(p)
        if hlCache[p] then pcall(function() hlCache[p]:Destroy() end); hlCache[p] = nil end
        setXRay(p)
    elseif mode == "Rainbow" then
        clearGlow(p)
        if xrayVisCache[p] then pcall(function() xrayVisCache[p]:Destroy() end); xrayVisCache[p] = nil end
        if xrayOccCache[p] then pcall(function() xrayOccCache[p]:Destroy() end); xrayOccCache[p] = nil end
        setHighlight(p)
    else
        clearGlow(p)
        if xrayVisCache[p] then pcall(function() xrayVisCache[p]:Destroy() end); xrayVisCache[p] = nil end
        if xrayOccCache[p] then pcall(function() xrayOccCache[p]:Destroy() end); xrayOccCache[p] = nil end
        setHighlight(p)
    end
end

local BONES_R15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local BONES_R6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}
local function getBones(ch) return ch:FindFirstChild("UpperTorso") and BONES_R15 or BONES_R6 end

local silentTarget = nil
local currentTarget = nil
local aimHeld = false

local function getTargetPart(ch, partName)
    if partName == "Closest" then return U.closestPart(ch, Camera.CFrame.Position) end
    return ch:FindFirstChild(partName) or ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
end

local function getPredictedPos(ch, partName, scale)
    local part = getTargetPart(ch, partName)
    if not part then return nil end
    local pos = part.Position
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if rp then pos = pos + rp.AssemblyLinearVelocity * scale end
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
    if priority == "Distance" then return dist3d
    elseif priority == "Health" then return U.hp(p)
    else return fovDist end
end

local function findBestTarget(cfg)
    local best, bestScore = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local score = scoreTarget(p, cfg)
            if score and score < bestScore then bestScore = score; best = p end
        end
    end
    return best
end

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
                                if rp then tPos = tPos + rp.AssemblyLinearVelocity * CFG.SilentAim.PredictScale end
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
    end)
elseif ENV.RawMT then
    pcall(function()
        local mt = getrawmetatable(game)
        if setreadonly then setreadonly(mt, false) elseif make_writeable then make_writeable(mt) end
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
                                if rp then tPos = tPos + rp.AssemblyLinearVelocity * CFG.SilentAim.PredictScale end
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
    end)
end

local ITEM_KW = {
    "loot", "item", "drop", "pickup", "spawn", "ground", "collect", "weapon",
    "chest", "crate", "supply", "ammo", "heal", "med", "armor", "shield",
    "gun", "rifle", "pistol", "shotgun", "sniper", "grenade", "consumable",
    "currency", "coin", "gem", "key", "treasure", "reward"
}
local function isItem(obj)
    if obj:IsA("Tool") then return true end
    if obj:IsA("BasePart") or obj:IsA("Model") then
        if obj:FindFirstChildOfClass("ClickDetector") then return true end
        if obj:FindFirstChildOfClass("ProximityPrompt") then return true end
        local p = obj.Parent
        if p and p ~= workspace then
            local n = string.lower(p.Name)
            for _, kw in ipairs(ITEM_KW) do if string.find(n, kw) then return true end end
        end
        local n2 = string.lower(obj.Name)
        for _, kw in ipairs(ITEM_KW) do if string.find(n2, kw) then return true end end
    end
    return false
end
local function getItemPos(obj)
    if obj:IsA("Model") then
        local pp = obj.PrimaryPart
        if pp then return pp.Position end
        local ok, cf = pcall(function() return obj:GetBoundingBox() end)
        return ok and cf.Position or nil
    elseif obj:IsA("BasePart") then return obj.Position
    elseif obj:IsA("Tool") then
        local h = obj:FindFirstChild("Handle"); return h and h.Position or nil
    end
    return nil
end

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
    local s, g, th = cfg.Size, cfg.Gap, cfg.Thick
    if cfg.Rotate then crossAngle = crossAngle + cfg.RotateSpeed * 0.016 else crossAngle = 0 end
    if cfg.Style == "Cross" then
        local ca, sa = math.cos(crossAngle), math.sin(crossAngle)
        local dirs = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
        for i, dir in ipairs(dirs) do
            local dx, dy = dir[1], dir[2]
            local rdx, rdy = dx * ca - dy * sa, dx * sa + dy * ca
            local fx, fy = ctr.X + rdx * g, ctr.Y + rdy * g
            local tx, ty = ctr.X + rdx * (g + s), ctr.Y + rdy * (g + s)
            if cfg.Outline then
                local ol = Draw.CrossLines[i + 4]
                ol.From = Vector2.new(fx, fy); ol.To = Vector2.new(tx, ty)
                ol.Color = Color3.new(0, 0, 0); ol.Thickness = th + 2; ol.Visible = true
            else Draw.CrossLines[i + 4].Visible = false end
            local ln = Draw.CrossLines[i]
            ln.From = Vector2.new(fx, fy); ln.To = Vector2.new(tx, ty)
            ln.Color = col; ln.Thickness = th; ln.Visible = true
        end
    elseif cfg.Style == "Circle" then
        for i = 1, 8 do Draw.CrossLines[i].Visible = false end
        Draw.circle(ctr, s, col, th, false, 40)
    elseif cfg.Style == "Diamond" then
        local pts = {
            {Vector2.new(ctr.X, ctr.Y - g - s), Vector2.new(ctr.X + g + s, ctr.Y)},
            {Vector2.new(ctr.X + g + s, ctr.Y), Vector2.new(ctr.X, ctr.Y + g + s)},
            {Vector2.new(ctr.X, ctr.Y + g + s), Vector2.new(ctr.X - g - s, ctr.Y)},
            {Vector2.new(ctr.X - g - s, ctr.Y), Vector2.new(ctr.X, ctr.Y - g - s)},
        }
        for i = 1, 4 do
            if cfg.Outline then
                Draw.CrossLines[i + 4].From = pts[i][1]; Draw.CrossLines[i + 4].To = pts[i][2]
                Draw.CrossLines[i + 4].Color = Color3.new(0, 0, 0); Draw.CrossLines[i + 4].Thickness = th + 2
                Draw.CrossLines[i + 4].Visible = true
            else Draw.CrossLines[i + 4].Visible = false end
            Draw.CrossLines[i].From = pts[i][1]; Draw.CrossLines[i].To = pts[i][2]
            Draw.CrossLines[i].Color = col; Draw.CrossLines[i].Thickness = th; Draw.CrossLines[i].Visible = true
        end
    else
        for i = 1, 8 do Draw.CrossLines[i].Visible = false end
    end
    if Draw.CrossDot and cfg.Dot then
        Draw.CrossDot.Position = ctr; Draw.CrossDot.Radius = cfg.DotSize
        Draw.CrossDot.Color = col; Draw.CrossDot.Visible = true
    elseif Draw.CrossDot then Draw.CrossDot.Visible = false end
end

local fpsBuffer, fpsIdx = {}, 0
local FPS_SAMPLES = 30
local cachedGameName = nil

local function renderWatermark()
    if not ENV.Drawing or not Draw.WmBG then return end
    if not CFG.Watermark.On then
        Draw.WmBG.Visible = false; Draw.WmBorder.Visible = false
        Draw.WmAccent.Visible = false; Draw.WmText.Visible = false
        return
    end
    local parts = {"AXIOM"}
    if CFG.Watermark.ShowFPS then
        fpsIdx = (fpsIdx % FPS_SAMPLES) + 1
        fpsBuffer[fpsIdx] = 1 / (RunService.RenderStepped:Wait() + 0.001)
        local sum, count = 0, math.min(#fpsBuffer, FPS_SAMPLES)
        for i = 1, count do sum = sum + (fpsBuffer[i] or 60) end
        table.insert(parts, math.floor(sum / count) .. " FPS")
    end
    if CFG.Watermark.ShowPing then
        local ok, ping = pcall(function()
            return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        if ok then table.insert(parts, ping .. "ms") end
    end
    if CFG.Watermark.ShowTime then table.insert(parts, os.date("%H:%M:%S")) end
    if CFG.Watermark.ShowGame then
        if not cachedGameName then
            pcall(function()
                cachedGameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
                if #cachedGameName > 20 then cachedGameName = string.sub(cachedGameName, 1, 18) .. ".." end
            end)
        end
        if cachedGameName then table.insert(parts, cachedGameName) end
    end
    local txt = table.concat(parts, " | ")
    local txtW = #txt * 7
    local h, pad, x, y = 24, 10, 10, 10
    Draw.WmBG.Position = Vector2.new(x, y); Draw.WmBG.Size = Vector2.new(txtW + pad * 2, h); Draw.WmBG.Visible = true
    Draw.WmBorder.Position = Vector2.new(x, y); Draw.WmBorder.Size = Vector2.new(txtW + pad * 2, h)
    Draw.WmBorder.Color = U.c3rgb(CFG.GUI.Accent); Draw.WmBorder.Visible = true
    Draw.WmAccent.From = Vector2.new(x, y); Draw.WmAccent.To = Vector2.new(x + txtW + pad * 2, y)
    Draw.WmAccent.Color = U.c3rgb(CFG.GUI.Accent); Draw.WmAccent.Visible = true
    Draw.WmText.Position = Vector2.new(x + pad, y + 5); Draw.WmText.Text = txt
    Draw.WmText.Color = Color3.new(1, 1, 1); Draw.WmText.Visible = true
end

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
        if CFG.BoxESP.Outline then
            local oc = U.c3(CFG.BoxESP.OutlineColor)
            local ot = CFG.BoxESP.OutlineThick
            Draw.line(tl, tr, oc, ot); Draw.line(tr, br, oc, ot)
            Draw.line(br, bl, oc, ot); Draw.line(bl, tl, oc, ot)
        end
        Draw.line(tl, tr, col, thick); Draw.line(tr, br, col, thick)
        Draw.line(br, bl, col, thick); Draw.line(bl, tl, col, thick)
        if CFG.BoxESP.FillAlpha > 0 then
            local isE = not U.team(p)
            Draw.quad(tl, tr, br, bl, isE and U.c3(CFG.BoxESP.EnemyFill) or U.c3(CFG.BoxESP.TeamFill), 1, true)
        end
    elseif CFG.BoxESP.Mode == "Corner" then
        local cl = math.min(CFG.BoxESP.CornerLength, w / 3, h / 3)
        Draw.line(tl, Vector2.new(tl.X + cl, tl.Y), col, thick)
        Draw.line(tl, Vector2.new(tl.X, tl.Y + cl), col, thick)
        Draw.line(tr, Vector2.new(tr.X - cl, tr.Y), col, thick)
        Draw.line(tr, Vector2.new(tr.X, tr.Y + cl), col, thick)
        Draw.line(bl, Vector2.new(bl.X + cl, bl.Y), col, thick)
        Draw.line(bl, Vector2.new(bl.X, bl.Y - cl), col, thick)
        Draw.line(br, Vector2.new(br.X - cl, br.Y), col, thick)
        Draw.line(br, Vector2.new(br.X, br.Y - cl), col, thick)
    elseif CFG.BoxESP.Mode == "3D" then
        local cf = root.CFrame
        local hs = Vector3.new(2, 3.2, 1.25)
        local corners = {}
        for _, o in ipairs({{-1,1,-1},{1,1,-1},{1,1,1},{-1,1,1},{-1,-1,-1},{1,-1,-1},{1,-1,1},{-1,-1,1}}) do
            table.insert(corners, (cf * CFrame.new(o[1]*hs.X, o[2]*hs.Y, o[3]*hs.Z)).Position)
        end
        local s2d = {}; local anyOn = false
        for i = 1, 8 do
            local sp, on2 = U.w2s(corners[i]); s2d[i] = sp; if on2 then anyOn = true end
        end
        if anyOn then
            for _, e in ipairs({{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}) do
                Draw.line(s2d[e[1]], s2d[e[2]], col, thick)
            end
        end
    end

    if CFG.BoxESP.Name then
        Draw.text(Vector2.new(topP.X, topP.Y - CFG.BoxESP.NameSize - 4), p.DisplayName, col, CFG.BoxESP.NameSize)
    end
    if CFG.BoxESP.Health then
        local frac = U.hpFrac(p)
        local hCol = U.hpColor(frac)
        local bx = tl.X - 6
        Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, topP.Y), Color3.new(0, 0, 0), 4)
        Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, botP.Y - (botP.Y - topP.Y) * frac), hCol, 2.5)
        if CFG.BoxESP.HealthNum then
            Draw.text(Vector2.new(bx - 16, botP.Y - (botP.Y - topP.Y) * frac - 6), U.formatHP(p), hCol, 10)
        end
    end
    if CFG.BoxESP.Dist then
        Draw.text(Vector2.new(botP.X, botP.Y + 2), U.formatDist(d3), Color3.fromRGB(200, 200, 200), CFG.BoxESP.DistSize)
    end
    if CFG.BoxESP.Weapon then
        local wep = U.getWeapon(p)
        if wep ~= "None" then
            Draw.text(Vector2.new(botP.X, botP.Y + (CFG.BoxESP.Dist and 16 or 2)), "[" .. wep .. "]", Color3.fromRGB(180, 180, 200), 11)
        end
    end
end

local function renderTracers(p, ch, root, d3, col, myP, ctr, vp)
    if not CFG.Tracers.On or d3 > CFG.Tracers.MaxDist then return end
    if not CFG.Tracers.ShowTeam and U.team(p) then return end
    local isE = not U.team(p)
    local tCol = isE and U.c3(CFG.Tracers.EnemyColor) or U.c3(CFG.Tracers.TeamColor)
    local fp = (root.CFrame * CFrame.new(0, -3.2, 0)).Position
    local sp, on = U.w2s(fp)
    if not on then return end
    local origin
    if CFG.Tracers.Origin == "Bottom" then origin = Vector2.new(ctr.X, vp.Y)
    elseif CFG.Tracers.Origin == "Center" then origin = ctr
    else origin = Vector2.new(Mouse.X, Mouse.Y) end
    Draw.line(origin, sp, tCol, CFG.Tracers.Thick)
end

local function renderSnaplines(p, ch, root, d3, col, myP, ctr)
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
    local isE = not U.team(p)
    local sCol = isE and U.c3(CFG.Skeleton.EnemyColor) or U.c3(CFG.Skeleton.TeamColor)
    for _, bone in ipairs(getBones(ch)) do
        local a, b = ch:FindFirstChild(bone[1]), ch:FindFirstChild(bone[2])
        if a and b then
            local sa, onA = U.w2s(a.Position)
            local sb, onB = U.w2s(b.Position)
            if onA and onB then Draw.line(sa, sb, sCol, CFG.Skeleton.Thick) end
        end
    end
end

local BUDGET_MS = 6
local frame = 0
local clk = os.clock

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == CFG.Aimbot.Key then aimHeld = true end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == CFG.Aimbot.Key then aimHeld = false end
end)

RunService.RenderStepped:Connect(function()
    frame = frame + 1
    local t0 = clk()
    local vp = Camera.ViewportSize
    local ctr = Vector2.new(vp.X / 2, vp.Y / 2)
    Camera = workspace.CurrentCamera

    if CFG.FOVChanger.On then
        if CFG.FOVChanger.Smooth then
            Camera.FieldOfView = U.lerp(Camera.FieldOfView, CFG.FOVChanger.Value, CFG.FOVChanger.SmoothSpeed)
        else
            Camera.FieldOfView = CFG.FOVChanger.Value
        end
    end

    if Draw.AimbotFOV then
        Draw.AimbotFOV.Position = ctr; Draw.AimbotFOV.Radius = CFG.Aimbot.FOV
        Draw.AimbotFOV.Color = U.c3(CFG.Aimbot.FOVColor); Draw.AimbotFOV.Transparency = CFG.Aimbot.FOVAlpha
        Draw.AimbotFOV.Thickness = CFG.Aimbot.FOVThick; Draw.AimbotFOV.NumSides = CFG.Aimbot.FOVSides
        Draw.AimbotFOV.Filled = CFG.Aimbot.FOVFilled; Draw.AimbotFOV.Visible = CFG.Aimbot.On and CFG.Aimbot.ShowFOV
    end
    if Draw.SilentFOV then
        Draw.SilentFOV.Position = ctr; Draw.SilentFOV.Radius = CFG.SilentAim.FOV
        Draw.SilentFOV.Color = U.c3(CFG.SilentAim.FOVColor); Draw.SilentFOV.Transparency = CFG.SilentAim.FOVAlpha
        Draw.SilentFOV.Thickness = CFG.SilentAim.FOVThick; Draw.SilentFOV.NumSides = CFG.SilentAim.FOVSides
        Draw.SilentFOV.Visible = CFG.SilentAim.On and CFG.SilentAim.ShowFOV
    end

    silentTarget = CFG.SilentAim.On and findBestTarget(CFG.SilentAim) or nil
    currentTarget = CFG.Aimbot.On and aimHeld and findBestTarget(CFG.Aimbot) or nil

    if currentTarget and aimHeld then
        local ch = currentTarget.Character
        if ch then
            local tPos = getPredictedPos(ch, CFG.Aimbot.Part, CFG.Aimbot.Predict and CFG.Aimbot.PredictScale or 0)
            if tPos then
                if CFG.Aimbot.Mode == "Snap" then
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tPos)
                else
                    local cur = Camera.CFrame.LookVector
                    local des = (tPos - Camera.CFrame.Position).Unit
                    local nw = cur:Lerp(des, math.clamp(CFG.Aimbot.Smoothness, 0.01, 1))
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + nw)
                end
            end
        end
    end

    if not ENV.Hook and not ENV.RawMT and CFG.SilentAim.On and silentTarget and aimHeld then
        local ch = silentTarget.Character
        if ch then
            local tPos = getPredictedPos(ch, CFG.SilentAim.Part, CFG.SilentAim.Predict and CFG.SilentAim.PredictScale or 0)
            if tPos then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tPos) end
        end
    end

    renderCrosshair(ctr)
    Draw.flush()

    local doESP = frame % 2 == 0
    local doItem = frame % 8 == 0
    local doWM = frame % 15 == 0

    if not doESP and not doItem then
        if doWM then renderWatermark() end
        return
    end

    local myP = U.myPos()

    if doESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            if not U.alive(p) then killChams(p); continue end
            local ch = p.Character
            local root = ch:FindFirstChild("HumanoidRootPart")
            if not root then continue end
            local d3 = (myP - root.Position).Magnitude
            if (clk() - t0) * 1000 > BUDGET_MS then break end

            updateChams(p)

            if not ENV.Drawing then
                local isE = not U.team(p)
                local col = isE and U.c3(CFG.BoxESP.EnemyColor) or U.c3(CFG.BoxESP.TeamColor)
                if CFG.BoxESP.On and d3 <= CFG.BoxESP.MaxDist then
                    if CFG.BoxESP.ShowTeam or isE then
                        local head = ch:FindFirstChild("Head")
                        if head then
                            local txt = p.DisplayName
                            if CFG.BoxESP.Dist then txt = txt .. " " .. U.formatDist(d3) end
                            Draw.bbgText(head, txt, col)
                            if CFG.BoxESP.Health then Draw.bbgHealth(head, U.hpFrac(p)) end
                        end
                    end
                end
                continue
            end

            local isE = not U.team(p)
            local col = isE and U.c3(CFG.BoxESP.EnemyColor) or U.c3(CFG.BoxESP.TeamColor)
            renderBoxESP(p, ch, root, d3, col, myP, ctr, vp)
            renderTracers(p, ch, root, d3, col, myP, ctr, vp)
            renderSnaplines(p, ch, root, d3, col, myP, ctr)
            renderSkeleton(p, ch, root, d3, myP)
        end
    end

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
                if CFG.ItemESP.Dist then label = label .. " " .. U.formatDist(dist) end
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

    if doWM then renderWatermark() end
end)

Players.PlayerRemoving:Connect(function(p) killChams(p) end)

local SG = Instance.new("ScreenGui")
SG.Name = "AX_" .. tostring(math.random(10000, 99999))
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

if ENV.ProtectGui then
    pcall(function()
        if typeof(syn) == "table" and syn.protect_gui then syn.protect_gui(SG)
        elseif protect_gui then protect_gui(SG) end
    end)
end
if ENV.GetHUI then pcall(function() SG.Parent = gethui() end) end
if not SG.Parent and ENV.CoreGui then pcall(function() SG.Parent = game:GetService("CoreGui") end) end
if not SG.Parent then pcall(function() SG.Parent = LP:WaitForChild("PlayerGui") end) end

local blur
if CFG.GUI.BlurBackground then
    pcall(function() blur = Instance.new("BlurEffect"); blur.Size = 0; blur.Parent = Lighting end)
end

local menuOpen = false
local SC = CFG.GUI.Scale

local TH = {
    BG       = Color3.fromRGB(8, 8, 12),
    Panel    = Color3.fromRGB(16, 16, 22),
    Header   = Color3.fromRGB(14, 14, 20),
    Accent   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    AccentD  = Color3.fromRGB(80, 30, 160),
    AccentAlt = Color3.fromRGB(CFG.GUI.AccentAlt[1], CFG.GUI.AccentAlt[2], CFG.GUI.AccentAlt[3]),
    Text     = Color3.fromRGB(225, 225, 235),
    Sub      = Color3.fromRGB(100, 100, 120),
    Dim      = Color3.fromRGB(65, 65, 80),
    On       = Color3.fromRGB(70, 220, 50),
    Off      = Color3.fromRGB(45, 45, 58),
    SlBG     = Color3.fromRGB(26, 26, 36),
    SlFill   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    Bdr      = Color3.fromRGB(30, 30, 42),
    Tab      = Color3.fromRGB(11, 11, 16),
    TabHov   = Color3.fromRGB(22, 22, 32),
    Sep      = Color3.fromRGB(28, 28, 40),
    Hover    = Color3.fromRGB(24, 24, 34),
    Input    = Color3.fromRGB(20, 20, 28),
}

local MW = math.floor(560 * SC)
local MH = math.floor(640 * SC)
local TW = math.floor(130 * SC)
local HH = math.floor(48 * SC)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, MW, 0, MH)
Main.Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2)
Main.BackgroundColor3 = TH.BG
Main.BackgroundTransparency = 1 - CFG.GUI.Opacity
Main.BorderSizePixel = 0; Main.Visible = false; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = TH.Bdr; mainStroke.Thickness = 1

local shadow = Instance.new("ImageLabel", Main)
shadow.Size = UDim2.new(1, 40, 1, 40); shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1; shadow.ImageTransparency = 0.5
shadow.Image = "rbxassetid://6014261993"; shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ScaleType = Enum.ScaleType.Slice; shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0

local accentBar = Instance.new("Frame", Main)
accentBar.Size = UDim2.new(1, 0, 0, 2); accentBar.BackgroundColor3 = TH.Accent; accentBar.BorderSizePixel = 0; accentBar.ZIndex = 10
local accentGrad = Instance.new("UIGradient", accentBar)
accentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, TH.Accent),
    ColorSequenceKeypoint.new(0.5, TH.AccentAlt),
    ColorSequenceKeypoint.new(1, TH.Accent),
})

local Hdr = Instance.new("Frame", Main)
Hdr.Size = UDim2.new(1, 0, 0, HH); Hdr.Position = UDim2.new(0, 0, 0, 2)
Hdr.BackgroundColor3 = TH.Header; Hdr.BorderSizePixel = 0

local logoFrame = Instance.new("Frame", Hdr)
logoFrame.Size = UDim2.new(0, 28, 0, 28); logoFrame.Position = UDim2.new(0, 12, 0.5, -14)
logoFrame.BackgroundColor3 = TH.Accent; logoFrame.BorderSizePixel = 0
Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0, 6)
local logoGrad = Instance.new("UIGradient", logoFrame)
logoGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt)
logoGrad.Rotation = 45
local logoLbl = Instance.new("TextLabel", logoFrame)
logoLbl.Text = "A"; logoLbl.Font = Enum.Font.GothamBlack; logoLbl.TextSize = math.floor(16 * SC)
logoLbl.TextColor3 = Color3.new(1, 1, 1); logoLbl.BackgroundTransparency = 1; logoLbl.Size = UDim2.new(1, 0, 1, 0)

local tLbl = Instance.new("TextLabel", Hdr)
tLbl.Text = "AXIOM"; tLbl.Font = Enum.Font.GothamBlack; tLbl.TextSize = math.floor(18 * SC)
tLbl.TextColor3 = TH.Text; tLbl.BackgroundTransparency = 1
tLbl.Position = UDim2.new(0, 48, 0, 4); tLbl.Size = UDim2.new(0, 100, 0, 20)
tLbl.TextXAlignment = Enum.TextXAlignment.Left

local subLbl = Instance.new("TextLabel", Hdr)
subLbl.Text = "UNIVERSAL"; subLbl.Font = Enum.Font.GothamBold; subLbl.TextSize = math.floor(9 * SC)
subLbl.TextColor3 = TH.Accent; subLbl.BackgroundTransparency = 1
subLbl.Position = UDim2.new(0, 48, 0, 24); subLbl.Size = UDim2.new(0, 100, 0, 14)
subLbl.TextXAlignment = Enum.TextXAlignment.Left

local verLbl = Instance.new("TextLabel", Hdr)
verLbl.Text = "v3.1"; verLbl.Font = Enum.Font.Gotham; verLbl.TextSize = math.floor(10 * SC)
verLbl.TextColor3 = TH.Dim; verLbl.BackgroundTransparency = 1
verLbl.Position = UDim2.new(1, -50, 0, 0); verLbl.Size = UDim2.new(0, 40, 1, 0)
verLbl.TextXAlignment = Enum.TextXAlignment.Right

local statusDot = Instance.new("Frame", Hdr)
statusDot.Size = UDim2.new(0, 6, 0, 6); statusDot.Position = UDim2.new(1, -12, 0.5, -3)
statusDot.BackgroundColor3 = TH.On; statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local hDiv = Instance.new("Frame", Main)
hDiv.Size = UDim2.new(1, 0, 0, 1); hDiv.Position = UDim2.new(0, 0, 0, HH + 2)
hDiv.BackgroundColor3 = TH.Sep; hDiv.BorderSizePixel = 0

local dragging, dragS, posS = false, nil, nil
Hdr.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragS = i.Position; posS = Main.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragS
        Main.Position = UDim2.new(posS.X.Scale, posS.X.Offset + d.X, posS.Y.Scale, posS.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(0, TW, 1, -(HH + 3))
TabBar.Position = UDim2.new(0, 0, 0, HH + 3)
TabBar.BackgroundColor3 = TH.Tab; TabBar.BorderSizePixel = 0; TabBar.ClipsDescendants = true

local tabLay = Instance.new("UIListLayout", TabBar)
tabLay.SortOrder = Enum.SortOrder.LayoutOrder; tabLay.Padding = UDim.new(0, 1)
local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingTop = UDim.new(0, 8); tabPad.PaddingLeft = UDim.new(0, 6); tabPad.PaddingRight = UDim.new(0, 6)

local tDiv = Instance.new("Frame", Main)
tDiv.Size = UDim2.new(0, 1, 1, -(HH + 3))
tDiv.Position = UDim2.new(0, TW, 0, HH + 3)
tDiv.BackgroundColor3 = TH.Sep; tDiv.BorderSizePixel = 0

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -(TW + 1), 1, -(HH + 3))
ContentArea.Position = UDim2.new(0, TW + 1, 0, HH + 3)
ContentArea.BackgroundTransparency = 1; ContentArea.BorderSizePixel = 0; ContentArea.ClipsDescendants = true

local tabs = {}
local activeTab = nil

local TAB_DEFS = {
    {name = "Aimbot",   ico = ""},
    {name = "Silent",   ico = ""},
    {name = "ESP",      ico = ""},
    {name = "Chams",    ico = ""},
    {name = "Visuals",  ico = ""},
    {name = "Settings", ico = ""},
}

local function switchTab(name)
    if activeTab == name then return end
    activeTab = name
    for tName, tData in pairs(tabs) do
        local isAct = tName == name
        tData.page.Visible = isAct
        local indicator = tData.btn:FindFirstChild("Indicator")
        TweenService:Create(tData.btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = isAct and TH.Hover or TH.Tab,
            BackgroundTransparency = isAct and 0 or 1
        }):Play()
        TweenService:Create(tData.lbl, TweenInfo.new(0.15), {
            TextColor3 = isAct and Color3.new(1, 1, 1) or TH.Sub
        }):Play()
        if indicator then
            TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
                BackgroundTransparency = isAct and 0 or 1
            }):Play()
        end
    end
end

for idx, def in ipairs(TAB_DEFS) do
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1, 0, 0, math.floor(34 * SC))
    btn.BackgroundColor3 = TH.Tab; btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = idx; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local indicator = Instance.new("Frame", btn)
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 3, 0.6, 0); indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.BackgroundColor3 = TH.Accent; indicator.BorderSizePixel = 0; indicator.BackgroundTransparency = 1
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = def.name; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = math.floor(12 * SC)
    lbl.TextColor3 = TH.Sub; lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -8, 1, 0); lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3; page.ScrollBarImageColor3 = TH.Accent
    page.BorderSizePixel = 0; page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    page.ClipsDescendants = true; page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.TopImage = "rbxassetid://7766642222"; page.MidImage = "rbxassetid://7766642222"; page.BottomImage = "rbxassetid://7766642222"

    local pLay = Instance.new("UIListLayout", page)
    pLay.SortOrder = Enum.SortOrder.LayoutOrder; pLay.Padding = UDim.new(0, 3)
    local pPad = Instance.new("UIPadding", page)
    pPad.PaddingTop = UDim.new(0, 6); pPad.PaddingBottom = UDim.new(0, 12)
    pPad.PaddingLeft = UDim.new(0, 8); pPad.PaddingRight = UDim.new(0, 8)

    tabs[def.name] = {btn = btn, lbl = lbl, page = page, ord = 0}

    btn.MouseEnter:Connect(function()
        if activeTab ~= def.name then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0, BackgroundColor3 = TH.TabHov}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= def.name then
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() switchTab(def.name) end)
end

local function getPage(tabName)
    local t = tabs[tabName]; t.ord = t.ord + 1; return t.page, t.ord
end

local function Section(tabName, name)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1; f.LayoutOrder = order
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, -70, 0, 1); line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = TH.Sep; line.BorderSizePixel = 0
    local l = Instance.new("TextLabel", f)
    l.Text = string.upper(name); l.Font = Enum.Font.GothamBold; l.TextSize = math.floor(10 * SC)
    l.TextColor3 = TH.Accent; l.BackgroundTransparency = 1
    l.Size = UDim2.new(0, 70, 1, 0); l.Position = UDim2.new(1, -70, 0, 0)
    l.TextXAlignment = Enum.TextXAlignment.Right
end

local function Toggle(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 32); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(13 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 0); l.Size = UDim2.new(0.7, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", f)
    track.Size = UDim2.new(0, 40, 0, 20); track.Position = UDim2.new(1, -52, 0.5, -10)
    track.BackgroundColor3 = tbl[key] and TH.On or TH.Off; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = tbl[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        tbl[key] = not tbl[key]; local on = tbl[key]
        TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundColor3 = on and TH.On or TH.Off}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function Slider(tabName, label, tbl, key, mn, mx, stp, sfx)
    sfx = sfx or ""; stp = stp or 1
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 46); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(12 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 3); l.Size = UDim2.new(0.5, 0, 0, 16)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Font = Enum.Font.GothamBold; vl.TextSize = math.floor(12 * SC); vl.TextColor3 = TH.Accent
    vl.BackgroundTransparency = 1; vl.Position = UDim2.new(0.5, 0, 0, 3)
    vl.Size = UDim2.new(0.5, -12, 0, 16); vl.TextXAlignment = Enum.TextXAlignment.Right

    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -24, 0, 6); trk.Position = UDim2.new(0, 12, 0, 30)
    trk.BackgroundColor3 = TH.SlBG; trk.BorderSizePixel = 0
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", trk)
    fill.BackgroundColor3 = TH.SlFill; fill.BorderSizePixel = 0; fill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt)

    local knob = Instance.new("Frame", trk)
    knob.Size = UDim2.new(0, 12, 0, 12); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0); knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = TH.Accent; knobStroke.Thickness = 2

    local function upd(v)
        v = math.clamp(v, mn, mx); v = math.floor(v / stp + 0.5) * stp; tbl[key] = v
        local frac = (v - mn) / (mx - mn)
        fill.Size = UDim2.new(frac, 0, 1, 0); knob.Position = UDim2.new(frac, 0, 0.5, 0)
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
        if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
            upd(mn + (mx - mn) * math.clamp((i.Position.X - trk.AbsolutePosition.X) / trk.AbsoluteSize.X, 0, 1))
        end
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Panel}):Play() end)
end

local activeDropdown = nil
local function Dropdown(tabName, label, tbl, key, options)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 32); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0
    f.LayoutOrder = order; f.ClipsDescendants = false; f.ZIndex = 2
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(12 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 0); l.Size = UDim2.new(0.5, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local dbtn = Instance.new("TextButton", f)
    dbtn.Size = UDim2.new(0.42, 0, 0, 24); dbtn.Position = UDim2.new(0.56, 0, 0.5, -12)
    dbtn.BackgroundColor3 = TH.Input; dbtn.BorderSizePixel = 0
    dbtn.Font = Enum.Font.Gotham; dbtn.TextSize = math.floor(11 * SC)
    dbtn.TextColor3 = TH.Text; dbtn.Text = tostring(tbl[key]) .. "  ▾"; dbtn.AutoButtonColor = false
    Instance.new("UICorner", dbtn).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", dbtn).Color = TH.Bdr

    local dropFrame = Instance.new("Frame", f)
    dropFrame.Size = UDim2.new(0.42, 0, 0, #options * 26 + 6)
    dropFrame.Position = UDim2.new(0.56, 0, 1, 4)
    dropFrame.BackgroundColor3 = TH.Header; dropFrame.BorderSizePixel = 0
    dropFrame.Visible = false; dropFrame.ZIndex = 100; dropFrame.ClipsDescendants = true
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 6)
    local ds = Instance.new("UIStroke", dropFrame); ds.Color = TH.Accent; ds.Thickness = 1

    local dLay = Instance.new("UIListLayout", dropFrame)
    dLay.SortOrder = Enum.SortOrder.LayoutOrder; dLay.Padding = UDim.new(0, 0)
    local dPad = Instance.new("UIPadding", dropFrame)
    dPad.PaddingTop = UDim.new(0, 3); dPad.PaddingBottom = UDim.new(0, 3)

    for oi, opt in ipairs(options) do
        local ob = Instance.new("TextButton", dropFrame)
        ob.Size = UDim2.new(1, -6, 0, 26); ob.Position = UDim2.new(0, 3, 0, 0)
        ob.BackgroundColor3 = TH.Header; ob.BackgroundTransparency = 1
        ob.BorderSizePixel = 0; ob.Font = Enum.Font.Gotham; ob.TextSize = math.floor(11 * SC)
        ob.TextColor3 = TH.Text; ob.Text = opt; ob.LayoutOrder = oi; ob.ZIndex = 101; ob.AutoButtonColor = false
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
        ob.MouseEnter:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.1), {BackgroundTransparency = 0, BackgroundColor3 = TH.Accent}):Play()
        end)
        ob.MouseLeave:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        end)
        ob.MouseButton1Click:Connect(function()
            tbl[key] = opt; dbtn.Text = opt .. "  ▾"; dropFrame.Visible = false; activeDropdown = nil
        end)
    end

    dbtn.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown ~= dropFrame then activeDropdown.Visible = false end
        dropFrame.Visible = not dropFrame.Visible
        activeDropdown = dropFrame.Visible and dropFrame or nil
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function ColorPick(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 58); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(12 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 12, 0, 3); l.Size = UDim2.new(0.5, 0, 0, 16)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local prev = Instance.new("Frame", f)
    prev.Size = UDim2.new(0, 24, 0, 14); prev.Position = UDim2.new(1, -40, 0, 4)
    prev.BackgroundColor3 = U.c3(tbl[key]); prev.BorderSizePixel = 0
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", prev).Color = TH.Bdr

    local hBar = Instance.new("Frame", f)
    hBar.Size = UDim2.new(1, -24, 0, 8); hBar.Position = UDim2.new(0, 12, 0, 22)
    hBar.BackgroundColor3 = Color3.new(1, 1, 1); hBar.BorderSizePixel = 0
    Instance.new("UICorner", hBar).CornerRadius = UDim.new(1, 0)
    local hGrad = Instance.new("UIGradient", hBar)
    local pts = {}
    for i = 0, 6 do pts[#pts + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)) end
    hGrad.Color = ColorSequence.new(pts)

    local sBar = Instance.new("Frame", f)
    sBar.Size = UDim2.new(0.47, -12, 0, 8); sBar.Position = UDim2.new(0, 12, 0, 38)
    sBar.BackgroundColor3 = Color3.new(1, 1, 1); sBar.BorderSizePixel = 0
    Instance.new("UICorner", sBar).CornerRadius = UDim.new(1, 0)

    local bBar = Instance.new("Frame", f)
    bBar.Size = UDim2.new(0.47, -12, 0, 8); bBar.Position = UDim2.new(0.53, 0, 0, 38)
    bBar.BackgroundColor3 = Color3.new(1, 1, 1); bBar.BorderSizePixel = 0
    Instance.new("UICorner", bBar).CornerRadius = UDim.new(1, 0)

    local cH, cS, cV = Color3.new(tbl[key][1], tbl[key][2], tbl[key][3]):ToHSV()
    local function apply()
        local c = Color3.fromHSV(cH, cS, cV); tbl[key] = {c.R, c.G, c.B}; prev.BackgroundColor3 = c
        local sg = sBar:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", sBar)
        sg.Color = ColorSequence.new(Color3.fromHSV(cH, 0, cV), Color3.fromHSV(cH, 1, cV))
        local bg2 = bBar:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", bBar)
        bg2.Color = ColorSequence.new(Color3.fromHSV(cH, cS, 0), Color3.fromHSV(cH, cS, 1))
    end
    apply()

    local dH, dS, dV = false, false, false
    hBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = true end end)
    sBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dS = true end end)
    bBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dV = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dH = false; dS = false; dV = false end end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if dH then cH = math.clamp((i.Position.X - hBar.AbsolutePosition.X) / hBar.AbsoluteSize.X, 0, 0.999); apply() end
        if dS then cS = math.clamp((i.Position.X - sBar.AbsolutePosition.X) / sBar.AbsoluteSize.X, 0, 1); apply() end
        if dV then cV = math.clamp((i.Position.X - bBar.AbsolutePosition.X) / bBar.AbsoluteSize.X, 0, 1); apply() end
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = TH.Panel}):Play() end)
end

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
Section("Aimbot", "FOV Style")
Slider("Aimbot", "Thickness", CFG.Aimbot, "FOVThick", 0.5, 5, 0.1, "")
Slider("Aimbot", "Opacity", CFG.Aimbot, "FOVAlpha", 0.1, 1.0, 0.05, "")
Slider("Aimbot", "Sides", CFG.Aimbot, "FOVSides", 12, 128, 1, "")
Toggle("Aimbot", "Filled", CFG.Aimbot, "FOVFilled")
ColorPick("Aimbot", "FOV Color", CFG.Aimbot, "FOVColor")

Section("Silent", "Silent Aim")
Toggle("Silent", "Enabled", CFG.SilentAim, "On")
Dropdown("Silent", "Target Part", CFG.SilentAim, "Part", {"Head", "Torso", "Closest"})
Slider("Silent", "FOV Radius", CFG.SilentAim, "FOV", 20, 500, 5, "px")
Slider("Silent", "Hit Chance", CFG.SilentAim, "HitChance", 1, 100, 1, "%")
Toggle("Silent", "Show FOV", CFG.SilentAim, "ShowFOV")
Toggle("Silent", "Prediction", CFG.SilentAim, "Predict")
Slider("Silent", "Predict Scale", CFG.SilentAim, "PredictScale", 0.01, 0.5, 0.005, "")
Toggle("Silent", "Wall Check", CFG.SilentAim, "WallCheck")
Toggle("Silent", "Team Check", CFG.SilentAim, "TeamCheck")
Section("Silent", "FOV Style")
Slider("Silent", "Thickness", CFG.SilentAim, "FOVThick", 0.5, 5, 0.1, "")
Slider("Silent", "Opacity", CFG.SilentAim, "FOVAlpha", 0.1, 1.0, 0.05, "")
ColorPick("Silent", "FOV Color", CFG.SilentAim, "FOVColor")

Section("ESP", "Box ESP")
Toggle("ESP", "Enabled", CFG.BoxESP, "On")
Dropdown("ESP", "Style", CFG.BoxESP, "Mode", {"Full", "Corner", "3D"})
Toggle("ESP", "Names", CFG.BoxESP, "Name")
Toggle("ESP", "Health Bars", CFG.BoxESP, "Health")
Toggle("ESP", "Health Numbers", CFG.BoxESP, "HealthNum")
Toggle("ESP", "Distance", CFG.BoxESP, "Dist")
Toggle("ESP", "Weapon", CFG.BoxESP, "Weapon")
Toggle("ESP", "Teammates", CFG.BoxESP, "ShowTeam")
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
Toggle("ESP", "Teammates", CFG.Tracers, "ShowTeam")
Slider("ESP", "Thickness", CFG.Tracers, "Thick", 0.5, 4, 0.1, "")
Slider("ESP", "Max Distance", CFG.Tracers, "MaxDist", 100, 5000, 50, "m")
ColorPick("ESP", "Enemy", CFG.Tracers, "EnemyColor")
ColorPick("ESP", "Team", CFG.Tracers, "TeamColor")
Section("ESP", "Snaplines")
Toggle("ESP", "Enabled", CFG.Snaplines, "On")
Dropdown("ESP", "Part", CFG.Snaplines, "Part", {"Head", "Torso", "Closest"})
Slider("ESP", "Thickness", CFG.Snaplines, "Thick", 0.3, 3, 0.1, "")
ColorPick("ESP", "Color", CFG.Snaplines, "Color")
Section("ESP", "Skeleton")
Toggle("ESP", "Enabled", CFG.Skeleton, "On")
Toggle("ESP", "Teammates", CFG.Skeleton, "ShowTeam")
Slider("ESP", "Max Distance", CFG.Skeleton, "MaxDist", 100, 3000, 50, "m")
Slider("ESP", "Thickness", CFG.Skeleton, "Thick", 0.3, 4, 0.1, "")
ColorPick("ESP", "Enemy Bones", CFG.Skeleton, "EnemyColor")
ColorPick("ESP", "Team Bones", CFG.Skeleton, "TeamColor")
Section("ESP", "Items")
Toggle("ESP", "Enabled", CFG.ItemESP, "On")
Toggle("ESP", "Names", CFG.ItemESP, "Names")
Toggle("ESP", "Distance", CFG.ItemESP, "Dist")
Toggle("ESP", "Tracers", CFG.ItemESP, "Tracers")
Toggle("ESP", "Icons", CFG.ItemESP, "Icon")
Slider("ESP", "Max Distance", CFG.ItemESP, "MaxDist", 50, 2000, 50, "m")
Slider("ESP", "Name Size", CFG.ItemESP, "NameSize", 8, 20, 1, "")
ColorPick("ESP", "Item Color", CFG.ItemESP, "Color")
ColorPick("ESP", "Tracer Color", CFG.ItemESP, "TracerColor")

Section("Chams", "Chams")
Toggle("Chams", "Enabled", CFG.Chams, "On")
Dropdown("Chams", "Mode", CFG.Chams, "Mode", {"Glow", "Highlight", "X-Ray", "Neon", "Rainbow"})
Dropdown("Chams", "Depth", CFG.Chams, "DepthMode", {"AlwaysOnTop", "Occluded"})
Toggle("Chams", "Team Colors", CFG.Chams, "TeamCheck")
Section("Chams", "Glow / Neon")
Slider("Chams", "Glow Transparency", CFG.Chams, "GlowAlpha", 0, 1, 0.05, "")
Slider("Chams", "Glow Size", CFG.Chams, "GlowSize", 0.01, 0.3, 0.01, "")
Slider("Chams", "Neon Transparency", CFG.Chams, "NeonAlpha", 0, 1, 0.05, "")
ColorPick("Chams", "Glow Color", CFG.Chams, "GlowColor")
ColorPick("Chams", "Neon Color", CFG.Chams, "NeonColor")
Section("Chams", "Highlight")
Slider("Chams", "Fill Alpha", CFG.Chams, "HighlightFillAlpha", 0, 1, 0.05, "")
Slider("Chams", "Outline Alpha", CFG.Chams, "HighlightOutAlpha", 0, 1, 0.05, "")
ColorPick("Chams", "Fill", CFG.Chams, "HighlightFill")
ColorPick("Chams", "Outline", CFG.Chams, "HighlightOut")
Section("Chams", "X-Ray")
Slider("Chams", "Visible Alpha", CFG.Chams, "XRayVisibleAlpha", 0, 1, 0.05, "")
Slider("Chams", "Occluded Alpha", CFG.Chams, "XRayOccludedAlpha", 0, 1, 0.05, "")
ColorPick("Chams", "Visible Color", CFG.Chams, "XRayVisibleFill")
ColorPick("Chams", "Occluded Color", CFG.Chams, "XRayOccludedFill")
Section("Chams", "Team / Rainbow")
Slider("Chams", "Rainbow Speed", CFG.Chams, "RainbowSpeed", 0.1, 5, 0.1, "x")
ColorPick("Chams", "Enemy Color", CFG.Chams, "EnemyColor")
ColorPick("Chams", "Team Color", CFG.Chams, "TeamColor")

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
ColorPick("Visuals", "Color", CFG.Crosshair, "Color")
Section("Visuals", "FOV Changer")
Toggle("Visuals", "Enabled", CFG.FOVChanger, "On")
Slider("Visuals", "Field of View", CFG.FOVChanger, "Value", 30, 120, 1, "")
Toggle("Visuals", "Smooth", CFG.FOVChanger, "Smooth")
Slider("Visuals", "Smooth Speed", CFG.FOVChanger, "SmoothSpeed", 0.01, 0.5, 0.01, "")
Section("Visuals", "Watermark")
Toggle("Visuals", "Enabled", CFG.Watermark, "On")
Toggle("Visuals", "FPS", CFG.Watermark, "ShowFPS")
Toggle("Visuals", "Ping", CFG.Watermark, "ShowPing")
Toggle("Visuals", "Time", CFG.Watermark, "ShowTime")
Toggle("Visuals", "Game Name", CFG.Watermark, "ShowGame")

Section("Settings", "Menu")
Slider("Settings", "Scale", CFG.GUI, "Scale", 0.6, 1.5, 0.05, "x")
Slider("Settings", "Opacity", CFG.GUI, "Opacity", 0.5, 1.0, 0.01, "")
Slider("Settings", "Animation Speed", CFG.GUI, "AnimSpeed", 0.05, 0.5, 0.01, "s")
Toggle("Settings", "Blur Background", CFG.GUI, "BlurBackground")
ColorPick("Settings", "Accent", CFG.GUI, "Accent")
ColorPick("Settings", "Accent Alt", CFG.GUI, "AccentAlt")

switchTab("Aimbot")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CFG.GUI.MenuKey then
        menuOpen = not menuOpen
        if activeDropdown then activeDropdown.Visible = false; activeDropdown = nil end
        if menuOpen then
            Main.Visible = true; Main.BackgroundTransparency = 1
            TweenService:Create(Main, TweenInfo.new(CFG.GUI.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1 - CFG.GUI.Opacity
            }):Play()
            if blur then TweenService:Create(blur, TweenInfo.new(CFG.GUI.AnimSpeed), {Size = 8}):Play() end
        else
            TweenService:Create(Main, TweenInfo.new(CFG.GUI.AnimSpeed, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            if blur then TweenService:Create(blur, TweenInfo.new(CFG.GUI.AnimSpeed), {Size = 0}):Play() end
            task.delay(CFG.GUI.AnimSpeed, function() if not menuOpen then Main.Visible = false end end)
        end
    end
end)

local function cleanup()
    if blur then pcall(function() blur:Destroy() end) end
    for _, p in ipairs(Players:GetPlayers()) do killChams(p) end
    if ENV.Drawing then
        Draw.Lines:destroy(); Draw.Texts:destroy(); Draw.Circles:destroy(); Draw.Quads:destroy()
        pcall(function() Draw.AimbotFOV:Remove() end)
        pcall(function() Draw.SilentFOV:Remove() end)
        for _, ln in ipairs(Draw.CrossLines) do pcall(function() ln:Remove() end) end
        pcall(function() Draw.CrossDot:Remove() end)
        pcall(function() Draw.WmBG:Remove() end)
        pcall(function() Draw.WmBorder:Remove() end)
        pcall(function() Draw.WmAccent:Remove() end)
        pcall(function() Draw.WmText:Remove() end)
    end
end
SG.Destroying:Connect(cleanup)
LP.CharacterRemoving:Connect(function() currentTarget = nil; silentTarget = nil end)

print("[Axiom] Loaded | RCtrl to open")
