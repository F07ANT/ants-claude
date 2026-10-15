local unpack = unpack or table.unpack
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
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
ENV.WriteFile = typeof(writefile) == "function"
ENV.ReadFile = typeof(readfile) == "function"
ENV.IsFile = typeof(isfile) == "function"
ENV.IsFolder = typeof(isfolder) == "function"
ENV.MakeFolder = typeof(makefolder) == "function"
ENV.ListFiles = typeof(listfiles) == "function"
ENV.SetClipboard = typeof(setclipboard) == "function"
ENV.Crypt = typeof(crypt) == "table" and typeof(crypt.base64encode) == "function"

local DEFAULT_CFG = {
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
        StickyTarget = false,
        AutoFire = false,
        AutoFireDelay = 0.15,
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
        Method = "Auto",
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
        HealthPos = "Left",
        Dist = true,
        DistSize = 12,
        Weapon = false,
        Flags = false,
        MaxDist = 1500,
        ShowTeam = false,
        Outline = true,
        OutlineColor = {0, 0, 0},
        OutlineThick = 3,
        DynamicColor = false,
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
    OffScreen = {
        On = false,
        Size = 12,
        Radius = 200,
        Color = {1, 0.3, 0.3},
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
        Dynamic = false,
        DynScale = 1.5,
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
        ShowPlayer = false,
    },
    Movement = {
        Speed = {On = false, Value = 24, Key = Enum.KeyCode.LeftShift},
        Fly = {On = false, Speed = 50, Key = Enum.KeyCode.F},
        Noclip = {On = false, Key = Enum.KeyCode.N},
        InfJump = {On = false},
        HighJump = {On = false, Power = 80},
        LongJump = {On = false, Force = 120},
    },
    Player = {
        AntiAFK = {On = false},
        AutoRespawn = {On = false, Delay = 1.0},
        HitboxExpand = {On = false, Size = 10},
        FullBright = {On = false},
        NoFog = {On = false},
        NoParticles = {On = false},
    },
    Teleport = {
        On = false,
        Key = Enum.KeyCode.T,
    },
    Radar = {
        On = false,
        Size = 150,
        Zoom = 1.5,
        Alpha = 0.85,
        ShowTeam = true,
        ShowNames = false,
        Position = "TopRight",
        BorderColor = {232, 67, 147},
        EnemyDot = {1, 0.15, 0.15},
        TeamDot = {0.15, 1, 0.15},
        BackgroundColor = {10, 10, 14},
        CardinalMarkers = true,
        RotateWithCamera = true,
        PingDots = true,
        DotSize = 3,
        CrosshairLines = true,
        MaxDist = 500,
    },
    Freecam = {
        On = false,
        Speed = 1,
        Key = Enum.KeyCode.G,
        Sensitivity = 0.3,
        ShowCursor = true,
    },
    Spectate = {
        On = false,
        Key = Enum.KeyCode.J,
        Mode = "Third",
        Distance = 15,
        AutoCycle = false,
        CycleTime = 5,
    },
    World = {
        TimeOfDay = {On = false, Value = 12},
        CustomGravity = {On = false, Value = 196.2},
        NoClutter = {On = false},
        Atmosphere = {On = false, Density = 0, Haze = 0},
        RemoveShadows = {On = false},
        RemoveWater = {On = false},
        RemoveTerrain = {On = false},
        FlatTerrain = {On = false},
    },
    KillFeed = {
        On = false,
        MaxEntries = 8,
        Duration = 5,
        ShowTimestamp = true,
        Position = "TopRight",
    },
    TargetInfo = {
        On = false,
        ShowHealth = true,
        ShowWeapon = true,
        ShowDistance = true,
        ShowSpeed = true,
        ShowFlags = true,
        Position = "Left",
    },
    ChatCommands = {
        On = false,
        Prefix = "!",
    },
    PlayerList = {
        On = false,
        ShowHealth = true,
        ShowDistance = true,
        ShowWeapon = true,
        SortBy = "Distance",
        Key = Enum.KeyCode.Tab,
        MaxVisible = 12,
    },
    GUI = {
        MenuKey = Enum.KeyCode.RightControl,
        Scale = 1.0,
        Opacity = 0.97,
        AnimSpeed = 0.25,
        Accent = {232, 67, 147},
        AccentAlt = {255, 105, 180},
        BlurBackground = true,
        Notifications = true,
        NotifDuration = 3.0,
    },
}

local function deepCopy(orig)
    if type(orig) ~= "table" then return orig end
    local copy = {}
    for k, v in pairs(orig) do copy[k] = deepCopy(v) end
    return copy
end

local CFG = deepCopy(DEFAULT_CFG)

local CONFIG_DIR = "lunarix"
local CONFIG_EXT = ".json"
local CURRENT_PROFILE = "default"

local ConfigManager = {}

function ConfigManager.ensureDir()
    if ENV.IsFolder and ENV.MakeFolder then
        if not isfolder(CONFIG_DIR) then
            pcall(makefolder, CONFIG_DIR)
        end
    end
end

function ConfigManager.filePath(name)
    return CONFIG_DIR .. "/" .. (name or CURRENT_PROFILE) .. CONFIG_EXT
end

function ConfigManager.serialize(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            result[k] = ConfigManager.serialize(v)
        elseif typeof(v) == "EnumItem" then
            result[k] = {__enum = true, type = tostring(v.EnumType), name = v.Name}
        else
            result[k] = v
        end
    end
    return result
end

function ConfigManager.deserialize(tbl)
    local result = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            if v.__enum then
                local ok, enumVal = pcall(function()
                    return Enum[v.type][v.name]
                end)
                result[k] = ok and enumVal or nil
            else
                result[k] = ConfigManager.deserialize(v)
            end
        else
            result[k] = v
        end
    end
    return result
end

function ConfigManager.merge(dst, src, defaults)
    for k, defVal in pairs(defaults) do
        if src[k] ~= nil then
            if type(defVal) == "table" and type(src[k]) == "table" and type(dst[k]) == "table" then
                if defVal.__enum or (type(src[k]) == "table" and src[k].__enum) then
                    dst[k] = src[k]
                else
                    ConfigManager.merge(dst[k], src[k], defVal)
                end
            else
                dst[k] = ConfigManager.validate(k, src[k], defVal)
            end
        end
    end
end

function ConfigManager.validate(key, value, default)
    if typeof(default) == "EnumItem" then
        if typeof(value) == "EnumItem" then return value end
        return default
    end
    if type(value) ~= type(default) then return default end
    if type(value) == "number" and type(default) == "number" then
        if default >= 0 and value < 0 then return default end
    end
    if type(value) == "string" then
        if #value > 200 then return default end
    end
    return value
end

function ConfigManager.save(name)
    if not ENV.WriteFile then return false, "writefile not available" end
    ConfigManager.ensureDir()
    local path = ConfigManager.filePath(name)
    local data = {
        version = "3.2",
        profile = name or CURRENT_PROFILE,
        timestamp = os.time(),
        config = ConfigManager.serialize(CFG),
    }
    local ok, err = pcall(function()
        writefile(path, HttpService:JSONEncode(data))
    end)
    if ok then CURRENT_PROFILE = name or CURRENT_PROFILE end
    return ok, err
end

function ConfigManager.load(name)
    if not ENV.ReadFile or not ENV.IsFile then return false, "readfile not available" end
    local path = ConfigManager.filePath(name)
    if not isfile(path) then return false, "file not found" end
    local ok, err = pcall(function()
        local raw = readfile(path)
        local data = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then error("invalid config data") end
        local loadedCfg = data.config or data
        local deserialized = ConfigManager.deserialize(loadedCfg)
        ConfigManager.merge(CFG, deserialized, DEFAULT_CFG)
    end)
    if ok then CURRENT_PROFILE = name or CURRENT_PROFILE end
    return ok, err
end

function ConfigManager.delete(name)
    if not ENV.WriteFile then return false end
    local path = ConfigManager.filePath(name)
    if ENV.IsFile and isfile(path) then
        pcall(function() delfile(path) end)
        return true
    end
    return false
end

function ConfigManager.reset()
    CFG = deepCopy(DEFAULT_CFG)
end

function ConfigManager.listProfiles()
    local profiles = {}
    if ENV.IsFolder and ENV.ListFiles and isfolder(CONFIG_DIR) then
        local ok, files = pcall(listfiles, CONFIG_DIR)
        if ok and files then
            for _, f in ipairs(files) do
                local name = f:match("([^/\\]+)%" .. CONFIG_EXT .. "$")
                if name then table.insert(profiles, name) end
            end
        end
    end
    return profiles
end

function ConfigManager.exportString()
    local data = ConfigManager.serialize(CFG)
    local json = HttpService:JSONEncode(data)
    if ENV.Crypt then
        return crypt.base64encode(json)
    end
    return json
end

function ConfigManager.importString(str)
    local ok, err = pcall(function()
        local decoded = str
        if ENV.Crypt then
            local success, result = pcall(crypt.base64decode, str)
            if success then decoded = result end
        end
        local data = HttpService:JSONDecode(decoded)
        local deserialized = ConfigManager.deserialize(data)
        ConfigManager.merge(CFG, deserialized, DEFAULT_CFG)
    end)
    return ok, err
end

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

function U.myRoot()
    local ch = LP.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
end

function U.myHumanoid()
    local ch = LP.Character
    return ch and ch:FindFirstChildOfClass("Humanoid")
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

function U.isMoving(p)
    local ch = p.Character
    if not ch then return false end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    return rp and rp.AssemblyLinearVelocity.Magnitude > 2
end

function U.getSpeed(p)
    local ch = p.Character
    if not ch then return 0 end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return 0 end
    local vel = rp.AssemblyLinearVelocity
    return Vector3.new(vel.X, 0, vel.Z).Magnitude
end

function U.clampAngle(angle)
    while angle > math.pi do angle = angle - 2 * math.pi end
    while angle < -math.pi do angle = angle + 2 * math.pi end
    return angle
end

function U.angleBetween(a, b)
    return math.acos(math.clamp(a:Dot(b) / (a.Magnitude * b.Magnitude), -1, 1))
end

function U.bezierLerp(a, b, t)
    local mid = (a + b) / 2 + Vector3.new(0, (b - a).Magnitude * 0.15, 0)
    local p1 = a:Lerp(mid, t)
    local p2 = mid:Lerp(b, t)
    return p1:Lerp(p2, t)
end

function U.smoothStep(t)
    return t * t * (3 - 2 * t)
end

function U.smootherStep(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function U.pointInTriangle(px, py, x1, y1, x2, y2, x3, y3)
    local function sign(ax, ay, bx, by, cx, cy)
        return (ax - cx) * (by - cy) - (bx - cx) * (ay - cy)
    end
    local d1 = sign(px, py, x1, y1, x2, y2)
    local d2 = sign(px, py, x2, y2, x3, y3)
    local d3 = sign(px, py, x3, y3, x1, y1)
    local hasNeg = (d1 < 0) or (d2 < 0) or (d3 < 0)
    local hasPos = (d1 > 0) or (d2 > 0) or (d3 > 0)
    return not (hasNeg and hasPos)
end

function U.rotatePoint(cx, cy, angle, px, py)
    local s, c = math.sin(angle), math.cos(angle)
    local nx = c * (px - cx) - s * (py - cy) + cx
    local ny = s * (px - cx) + c * (py - cy) + cy
    return nx, ny
end

function U.screenSize()
    return Camera.ViewportSize
end

function U.screenCenter()
    local vp = Camera.ViewportSize
    return Vector2.new(vp.X / 2, vp.Y / 2)
end

function U.isOnScreen(pos, margin)
    margin = margin or 0
    local vp = Camera.ViewportSize
    return pos.X >= -margin and pos.X <= vp.X + margin and pos.Y >= -margin and pos.Y <= vp.Y + margin
end

function U.getPlayerFlags(p)
    local flags = {}
    local ch = p.Character
    if not ch then return flags end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum:GetState() == Enum.HumanoidStateType.Freefall then table.insert(flags, "AIR") end
        if hum:GetState() == Enum.HumanoidStateType.Swimming then table.insert(flags, "SWIM") end
    end
    local tool = ch:FindFirstChildOfClass("Tool")
    if tool then table.insert(flags, tool.Name) end
    local ff = ch:FindFirstChildOfClass("ForceField")
    if ff then table.insert(flags, "FF") end
    return flags
end

function U.getVelocityDirection(p)
    local ch = p.Character
    if not ch then return Vector3.zero end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return Vector3.zero end
    local vel = rp.AssemblyLinearVelocity
    local flat = Vector3.new(vel.X, 0, vel.Z)
    return flat.Magnitude > 0.1 and flat.Unit or Vector3.zero
end

function U.getHeading(p)
    local ch = p.Character
    if not ch then return 0 end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return 0 end
    local look = rp.CFrame.LookVector
    return math.atan2(look.X, look.Z)
end

function U.worldToRadar(targetPos, myPos, myAngle, radarSize, zoom, rotate)
    local dx = targetPos.X - myPos.X
    local dz = targetPos.Z - myPos.Z
    local rx, rz
    if rotate then
        local sin, cos = math.sin(-myAngle), math.cos(-myAngle)
        rx = dx * cos - dz * sin
        rz = dx * sin + dz * cos
    else
        rx = dx
        rz = -dz
    end
    local scale = radarSize / (2 * zoom * 100)
    local px = rx * scale
    local py = rz * scale
    local halfSize = radarSize / 2
    px = math.clamp(px, -halfSize + 4, halfSize - 4)
    py = math.clamp(py, -halfSize + 4, halfSize - 4)
    return px, py
end

function U.isInFOV(targetPos, camCF, fov)
    local dir = (targetPos - camCF.Position).Unit
    local look = camCF.LookVector
    local angle = math.deg(math.acos(math.clamp(dir:Dot(look), -1, 1)))
    return angle <= fov / 2
end

function U.predictPosition(ch, deltaTime)
    local rp = ch:FindFirstChild("HumanoidRootPart")
    if not rp then return nil end
    return rp.Position + rp.AssemblyLinearVelocity * deltaTime
end

function U.getAimAngle(targetPos)
    local camPos = Camera.CFrame.Position
    local look = Camera.CFrame.LookVector
    local dir = (targetPos - camPos).Unit
    return math.deg(math.acos(math.clamp(dir:Dot(look), -1, 1)))
end

function U.formatTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%d:%02d", m, s)
end

function U.formatNumber(n)
    if n >= 1e6 then return string.format("%.1fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

function U.truncate(str, maxLen)
    if #str <= maxLen then return str end
    return string.sub(str, 1, maxLen - 2) .. ".."
end

function U.getCharacterSize(ch)
    if not ch then return Vector3.new(4, 5, 2) end
    local ok, cf, size = pcall(function() return ch:GetBoundingBox() end)
    if ok and size then return size end
    return Vector3.new(4, 5, 2)
end

function U.getCharacterCenter(ch)
    if not ch then return nil end
    local ok, cf = pcall(function() return ch:GetBoundingBox() end)
    if ok and cf then return cf.Position end
    local rp = ch:FindFirstChild("HumanoidRootPart")
    return rp and rp.Position or nil
end

function U.isPlayerBehindWall(p)
    local ch = p.Character
    if not ch then return true end
    local head = ch:FindFirstChild("Head")
    if not head then return true end
    return not U.wallCheck(Camera.CFrame.Position, head.Position)
end

function U.getMaxHealth(p)
    local ch = p.Character
    if not ch then return 100 end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    return hum and hum.MaxHealth or 100
end

function U.getHumanoidState(p)
    local ch = p.Character
    if not ch then return "Unknown" end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return "Unknown" end
    return hum:GetState().Name
end

function U.distanceToPlayer(p)
    if not U.alive(p) then return math.huge end
    local ch = p.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return math.huge end
    return (U.myPos() - rp.Position).Magnitude
end

local Radar = {}
Radar.active = false

function Radar.render(ctr_x, ctr_y)
    if not CFG.Radar.On or not ENV.Drawing then return end
    local cfg = CFG.Radar
    local size = cfg.Size
    local half = size / 2
    local myP = U.myPos()
    local myAngle = 0
    if cfg.RotateWithCamera then
        local look = Camera.CFrame.LookVector
        myAngle = math.atan2(look.X, look.Z)
    end

    local rx, ry
    if cfg.Position == "TopRight" then
        local vp = Camera.ViewportSize
        rx = vp.X - size - 15
        ry = 45
    elseif cfg.Position == "TopLeft" then
        rx = 15
        ry = 45
    elseif cfg.Position == "BottomLeft" then
        rx = 15
        ry = Camera.ViewportSize.Y - size - 15
    else
        local vp = Camera.ViewportSize
        rx = vp.X - size - 15
        ry = vp.Y - size - 15
    end

    local cx, cy = rx + half, ry + half

    Draw.circle(Vector2.new(cx, cy), half, U.c3(cfg.BackgroundColor), 1, true, 40, cfg.Alpha)
    Draw.circle(Vector2.new(cx, cy), half, U.c3(cfg.BorderColor), 1.5, false, 40, 1)

    if cfg.CrosshairLines then
        Draw.line(Vector2.new(cx - half, cy), Vector2.new(cx + half, cy), Color3.fromRGB(40, 40, 50), 1)
        Draw.line(Vector2.new(cx, cy - half), Vector2.new(cx, cy + half), Color3.fromRGB(40, 40, 50), 1)
    end

    Draw.circle(Vector2.new(cx, cy), half / 2, Color3.fromRGB(30, 30, 40), 1, false, 30, 0.5)

    if cfg.CardinalMarkers then
        local markers = {{"N", 0, -1}, {"S", 0, 1}, {"E", 1, 0}, {"W", -1, 0}}
        for _, m in ipairs(markers) do
            local label, dx, dy = m[1], m[2], m[3]
            local mdx, mdy = dx, dy
            if cfg.RotateWithCamera then
                local sin, cos = math.sin(-myAngle), math.cos(-myAngle)
                mdx = dx * cos - dy * sin
                mdy = dx * sin + dy * cos
            end
            local mx = cx + mdx * (half - 10)
            local my = cy + mdy * (half - 10)
            Draw.text(Vector2.new(mx, my), label, Color3.fromRGB(120, 120, 140), 9, true)
        end
    end

    Draw.circle(Vector2.new(cx, cy), 3, U.c3rgb(CFG.GUI.Accent), 1, true, 12, 1)

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if not U.alive(p) then continue end
        local ch = p.Character
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not rp then continue end
        local dist = (myP - rp.Position).Magnitude
        if dist > cfg.MaxDist then continue end
        local isTeam = U.team(p)
        if not cfg.ShowTeam and isTeam then continue end
        local px, py = U.worldToRadar(rp.Position, myP, myAngle, size, cfg.Zoom, cfg.RotateWithCamera)

        local inCircle = (px * px + py * py) <= (half - 4) * (half - 4)
        if not inCircle then
            local mag = math.sqrt(px * px + py * py)
            if mag > 0 then
                px = px / mag * (half - 6)
                py = py / mag * (half - 6)
            end
        end

        local dotCol = isTeam and U.c3(cfg.TeamDot) or U.c3(cfg.EnemyDot)
        local dotX, dotY = cx + px, cy + py
        Draw.circle(Vector2.new(dotX, dotY), cfg.DotSize, dotCol, 1, true, 10, 1)

        if cfg.PingDots then
            local heading = U.getHeading(p)
            local relAngle = heading - myAngle
            local arrowLen = 5
            local ax = dotX + math.sin(relAngle) * arrowLen
            local ay = dotY - math.cos(relAngle) * arrowLen
            Draw.line(Vector2.new(dotX, dotY), Vector2.new(ax, ay), dotCol, 1)
        end

        if cfg.ShowNames then
            Draw.text(Vector2.new(dotX, dotY - 10), U.truncate(p.DisplayName, 10), Color3.fromRGB(180, 180, 190), 8, true)
        end
    end
end

local Freecam = {}
Freecam.active = false
Freecam.savedCF = nil
Freecam.savedSubject = nil
Freecam.position = Vector3.zero
Freecam.rotation = Vector2.zero
Freecam.velocity = Vector3.zero

function Freecam.enable()
    if Freecam.active then return end
    Freecam.active = true
    Freecam.savedCF = Camera.CFrame
    Freecam.savedSubject = Camera.CameraSubject
    Freecam.position = Camera.CFrame.Position
    local look = Camera.CFrame.LookVector
    Freecam.rotation = Vector2.new(
        math.asin(-look.Y),
        math.atan2(look.X, look.Z)
    )
    Freecam.velocity = Vector3.zero
    Camera.CameraType = Enum.CameraType.Scriptable
    if CFG.Freecam.ShowCursor then
        pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
    end
end

function Freecam.disable()
    if not Freecam.active then return end
    Freecam.active = false
    Camera.CameraType = Enum.CameraType.Custom
    if Freecam.savedSubject then
        pcall(function() Camera.CameraSubject = Freecam.savedSubject end)
    end
    pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end)
end

function Freecam.update(dt)
    if not Freecam.active then return end
    local speed = CFG.Freecam.Speed * 50
    local sens = CFG.Freecam.Sensitivity

    local delta = UIS:GetMouseDelta()
    Freecam.rotation = Vector2.new(
        math.clamp(Freecam.rotation.X - delta.Y * sens * 0.01, -math.pi / 2 + 0.01, math.pi / 2 - 0.01),
        Freecam.rotation.Y - delta.X * sens * 0.01
    )

    local yaw = Freecam.rotation.Y
    local pitch = Freecam.rotation.X
    local cf = CFrame.new(Freecam.position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)

    local moveDir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cf.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cf.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cf.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cf.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

    local shiftMul = UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 2.5 or 1
    if moveDir.Magnitude > 0 then
        Freecam.velocity = moveDir.Unit * speed * shiftMul
    else
        Freecam.velocity = Freecam.velocity * 0.85
        if Freecam.velocity.Magnitude < 0.1 then Freecam.velocity = Vector3.zero end
    end

    Freecam.position = Freecam.position + Freecam.velocity * dt
    Camera.CFrame = CFrame.new(Freecam.position) * CFrame.Angles(0, yaw, 0) * CFrame.Angles(pitch, 0, 0)
end

local Spectate = {}
Spectate.active = false
Spectate.target = nil
Spectate.savedSubject = nil
Spectate.cycleTimer = 0
Spectate.playerIndex = 0

function Spectate.getNextPlayer(forward)
    local players = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            table.insert(players, p)
        end
    end
    if #players == 0 then return nil end
    if forward then
        Spectate.playerIndex = (Spectate.playerIndex % #players) + 1
    else
        Spectate.playerIndex = Spectate.playerIndex - 1
        if Spectate.playerIndex < 1 then Spectate.playerIndex = #players end
    end
    return players[Spectate.playerIndex]
end

function Spectate.enable()
    if Spectate.active then return end
    Spectate.active = true
    Spectate.savedSubject = Camera.CameraSubject
    Spectate.cycleTimer = 0
    Spectate.target = Spectate.getNextPlayer(true)
    if Spectate.target then
        Spectate.setTarget(Spectate.target)
    end
end

function Spectate.disable()
    if not Spectate.active then return end
    Spectate.active = false
    Spectate.target = nil
    Camera.CameraType = Enum.CameraType.Custom
    if Spectate.savedSubject then
        pcall(function() Camera.CameraSubject = Spectate.savedSubject end)
    end
end

function Spectate.setTarget(p)
    if not p or not U.alive(p) then return end
    Spectate.target = p
    local ch = p.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if hum then
        Camera.CameraSubject = hum
        Camera.CameraType = Enum.CameraType.Custom
    end
end

function Spectate.update(dt)
    if not Spectate.active then return end
    if Spectate.target and not U.alive(Spectate.target) then
        Spectate.target = Spectate.getNextPlayer(true)
        if Spectate.target then Spectate.setTarget(Spectate.target) end
    end
    if CFG.Spectate.AutoCycle then
        Spectate.cycleTimer = Spectate.cycleTimer + dt
        if Spectate.cycleTimer >= CFG.Spectate.CycleTime then
            Spectate.cycleTimer = 0
            local next = Spectate.getNextPlayer(true)
            if next then Spectate.setTarget(next) end
        end
    end
end

function Spectate.next()
    local next = Spectate.getNextPlayer(true)
    if next then Spectate.setTarget(next) end
end

function Spectate.prev()
    local prev = Spectate.getNextPlayer(false)
    if prev then Spectate.setTarget(prev) end
end

local KillFeed = {}
KillFeed.entries = {}
KillFeed.healthCache = {}

function KillFeed.init()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            KillFeed.healthCache[p] = U.hp(p)
        end
    end
end

function KillFeed.update()
    if not CFG.KillFeed.On then return end
    local now = tick()
    for i = #KillFeed.entries, 1, -1 do
        if now - KillFeed.entries[i].time > CFG.KillFeed.Duration then
            table.remove(KillFeed.entries, i)
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local ch = p.Character
        if not ch then
            if KillFeed.healthCache[p] and KillFeed.healthCache[p] > 0 then
                table.insert(KillFeed.entries, {
                    victim = p.DisplayName,
                    killer = "?",
                    time = now,
                })
                KillFeed.healthCache[p] = 0
            end
            continue
        end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        local currentHP = hum.Health
        local prevHP = KillFeed.healthCache[p] or currentHP
        if prevHP > 0 and currentHP <= 0 then
            local killer = "?"
            local myDist = U.distanceToPlayer(p)
            if currentTarget == p and myDist < 50 then
                killer = LP.DisplayName
            end
            table.insert(KillFeed.entries, {
                victim = p.DisplayName,
                killer = killer,
                time = now,
            })
            if #KillFeed.entries > CFG.KillFeed.MaxEntries then
                table.remove(KillFeed.entries, 1)
            end
        end
        KillFeed.healthCache[p] = currentHP
    end
end

function KillFeed.render()
    if not CFG.KillFeed.On or not ENV.Drawing then return end
    local entries = KillFeed.entries
    if #entries == 0 then return end
    local vp = Camera.ViewportSize
    local startX, startY
    if CFG.KillFeed.Position == "TopRight" then
        startX = vp.X - 200
        startY = 80
    elseif CFG.KillFeed.Position == "TopLeft" then
        startX = 15
        startY = 80
    else
        startX = vp.X - 200
        startY = 80
    end

    for i, entry in ipairs(entries) do
        local age = tick() - entry.time
        local alpha = math.clamp(1 - (age / CFG.KillFeed.Duration), 0, 1)
        local y = startY + (i - 1) * 16
        local txt = entry.killer .. " > " .. entry.victim
        if CFG.KillFeed.ShowTimestamp then
            txt = os.date("[%H:%M:%S] ", entry.time + 0) .. txt
        end
        local col = entry.killer == LP.DisplayName and Color3.fromRGB(232, 67, 147) or Color3.fromRGB(180, 180, 190)
        Draw.text(Vector2.new(startX, y), txt, col, 11, false)
    end
end

local TargetInfo = {}

function TargetInfo.render(target)
    if not CFG.TargetInfo.On or not ENV.Drawing then return end
    if not target or not U.alive(target) then return end
    local ch = target.Character
    if not ch then return end
    local vp = Camera.ViewportSize
    local panelW, panelH = 180, 90
    local px, py
    if CFG.TargetInfo.Position == "Left" then
        px = 15
        py = vp.Y / 2 - panelH / 2
    elseif CFG.TargetInfo.Position == "Right" then
        px = vp.X - panelW - 15
        py = vp.Y / 2 - panelH / 2
    else
        px = vp.X / 2 - panelW / 2
        py = vp.Y - panelH - 80
    end

    local bgA = Vector2.new(px, py)
    local bgB = Vector2.new(px + panelW, py)
    local bgC = Vector2.new(px + panelW, py + panelH)
    local bgD = Vector2.new(px, py + panelH)
    Draw.quad(bgA, bgB, bgC, bgD, Color3.fromRGB(12, 12, 18), 1, true)

    Draw.line(Vector2.new(px, py), Vector2.new(px + panelW, py), U.c3rgb(CFG.GUI.Accent), 2)

    local nameX = px + 10
    local nameY = py + 6
    Draw.text(Vector2.new(nameX, nameY), U.truncate(target.DisplayName, 18), Color3.fromRGB(230, 230, 240), 13, false)

    local infoY = nameY + 18
    if CFG.TargetInfo.ShowHealth then
        local frac = U.hpFrac(target)
        local hCol = U.hpColor(frac)
        Draw.line(Vector2.new(px + 10, infoY + 5), Vector2.new(px + 10 + (panelW - 20), infoY + 5), Color3.fromRGB(30, 30, 40), 4)
        Draw.line(Vector2.new(px + 10, infoY + 5), Vector2.new(px + 10 + (panelW - 20) * frac, infoY + 5), hCol, 3)
        local hpText = math.floor(U.hp(target)) .. " / " .. math.floor(U.getMaxHealth(target))
        Draw.text(Vector2.new(px + panelW / 2, infoY + 1), hpText, Color3.fromRGB(200, 200, 210), 9, true)
        infoY = infoY + 14
    end

    if CFG.TargetInfo.ShowDistance then
        local dist = U.distanceToPlayer(target)
        Draw.text(Vector2.new(nameX, infoY), "Dist: " .. U.formatDist(dist), Color3.fromRGB(150, 150, 170), 10, false)
        infoY = infoY + 14
    end

    if CFG.TargetInfo.ShowWeapon then
        local wep = U.getWeapon(target)
        Draw.text(Vector2.new(nameX, infoY), "Weapon: " .. wep, Color3.fromRGB(150, 150, 170), 10, false)
        infoY = infoY + 14
    end

    if CFG.TargetInfo.ShowSpeed then
        local spd = U.getSpeed(target)
        Draw.text(Vector2.new(nameX + 90, infoY - 14), string.format("%.0f s/s", spd), Color3.fromRGB(150, 150, 170), 10, false)
    end

    if CFG.TargetInfo.ShowFlags then
        local flags = U.getPlayerFlags(target)
        if #flags > 0 then
            Draw.text(Vector2.new(nameX, infoY), table.concat(flags, " | "), Color3.fromRGB(255, 200, 100), 9, false)
        end
    end
end

local PlayerListDisplay = {}
PlayerListDisplay.visible = false

function PlayerListDisplay.render()
    if not CFG.PlayerList.On or not PlayerListDisplay.visible or not ENV.Drawing then return end
    local vp = Camera.ViewportSize
    local panelW = 300
    local lineH = 18
    local headerH = 28
    local px = vp.X / 2 - panelW / 2
    local py = 60

    local sorted = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local dist = U.distanceToPlayer(p)
            local hp = U.hp(p)
            table.insert(sorted, {player = p, dist = dist, hp = hp})
        end
    end

    if CFG.PlayerList.SortBy == "Distance" then
        table.sort(sorted, function(a, b) return a.dist < b.dist end)
    elseif CFG.PlayerList.SortBy == "Health" then
        table.sort(sorted, function(a, b) return a.hp > b.hp end)
    elseif CFG.PlayerList.SortBy == "Name" then
        table.sort(sorted, function(a, b) return a.player.DisplayName < b.player.DisplayName end)
    end

    local visCount = math.min(#sorted, CFG.PlayerList.MaxVisible)
    local totalH = headerH + visCount * lineH + 8

    local bgA = Vector2.new(px, py)
    local bgB = Vector2.new(px + panelW, py)
    local bgC = Vector2.new(px + panelW, py + totalH)
    local bgD = Vector2.new(px, py + totalH)
    Draw.quad(bgA, bgB, bgC, bgD, Color3.fromRGB(12, 12, 18), 1, true)

    Draw.line(Vector2.new(px, py), Vector2.new(px + panelW, py), U.c3rgb(CFG.GUI.Accent), 2)

    local playerCount = #Players:GetPlayers()
    Draw.text(Vector2.new(px + panelW / 2, py + 6), "Players (" .. playerCount .. ")", Color3.fromRGB(220, 220, 230), 12, true)
    Draw.line(Vector2.new(px + 5, py + headerH - 2), Vector2.new(px + panelW - 5, py + headerH - 2), Color3.fromRGB(40, 40, 50), 1)

    for i = 1, visCount do
        local data = sorted[i]
        local p = data.player
        local ly = py + headerH + (i - 1) * lineH
        local isAlive = U.alive(p)
        local isTeam = U.team(p)

        local nameCol = isTeam and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 200, 210)
        if not isAlive then nameCol = Color3.fromRGB(100, 100, 100) end
        Draw.text(Vector2.new(px + 8, ly + 2), U.truncate(p.DisplayName, 16), nameCol, 11, false)

        if CFG.PlayerList.ShowHealth and isAlive then
            local frac = U.hpFrac(p)
            local hCol = U.hpColor(frac)
            Draw.text(Vector2.new(px + 150, ly + 2), math.floor(U.hp(p)) .. "hp", hCol, 10, false)
        end

        if CFG.PlayerList.ShowDistance and isAlive then
            local dist = data.dist
            Draw.text(Vector2.new(px + 200, ly + 2), U.formatDist(dist), Color3.fromRGB(150, 150, 170), 10, false)
        end

        if CFG.PlayerList.ShowWeapon and isAlive then
            local wep = U.getWeapon(p)
            if wep ~= "None" then
                Draw.text(Vector2.new(px + 250, ly + 2), U.truncate(wep, 8), Color3.fromRGB(180, 160, 200), 10, false)
            end
        end
    end
end

local ChatCmds = {}
ChatCmds.commands = {}

function ChatCmds.register(name, desc, callback)
    ChatCmds.commands[string.lower(name)] = {desc = desc, fn = callback}
end

function ChatCmds.parse(msg)
    if not CFG.ChatCommands.On then return false end
    local prefix = CFG.ChatCommands.Prefix
    if string.sub(msg, 1, #prefix) ~= prefix then return false end
    local content = string.sub(msg, #prefix + 1)
    local parts = {}
    for word in string.gmatch(content, "%S+") do
        table.insert(parts, word)
    end
    if #parts == 0 then return false end
    local cmdName = string.lower(parts[1])
    local cmd = ChatCmds.commands[cmdName]
    if not cmd then
        Notify.send("Commands", "Unknown command: " .. cmdName, "error", 2)
        return true
    end
    local args = {}
    for i = 2, #parts do table.insert(args, parts[i]) end
    local ok, err = pcall(cmd.fn, args)
    if not ok then
        Notify.send("Commands", "Error: " .. tostring(err), "error", 3)
    end
    return true
end

function ChatCmds.init()
    ChatCmds.register("speed", "Set walk speed", function(args)
        local val = tonumber(args[1]) or 16
        CFG.Movement.Speed.On = true
        CFG.Movement.Speed.Value = math.clamp(val, 0, 500)
        Notify.send("Speed", "Set to " .. CFG.Movement.Speed.Value, "success", 2)
    end)
    ChatCmds.register("fly", "Toggle fly", function(args)
        if flyActive then disableFly() else
            CFG.Movement.Fly.On = true
            enableFly()
        end
        Notify.send("Fly", flyActive and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("noclip", "Toggle noclip", function(args)
        if noclipActive then disableNoclip() else
            CFG.Movement.Noclip.On = true
            enableNoclip()
        end
        Notify.send("Noclip", noclipActive and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("tp", "Teleport to player", function(args)
        local name = args[1]
        if not name then Notify.send("TP", "Usage: tp <player>", "warning", 2); return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and string.find(string.lower(p.Name), string.lower(name)) then
                local ch = p.Character
                local rp = ch and ch:FindFirstChild("HumanoidRootPart")
                local myRoot = U.myRoot()
                if rp and myRoot then
                    myRoot.CFrame = rp.CFrame * CFrame.new(0, 0, 5)
                    Notify.send("TP", "Teleported to " .. p.DisplayName, "success", 2)
                end
                return
            end
        end
        Notify.send("TP", "Player not found", "error", 2)
    end)
    ChatCmds.register("goto", "Teleport to player", function(args)
        ChatCmds.commands["tp"].fn(args)
    end)
    ChatCmds.register("spectate", "Spectate a player", function(args)
        local name = args[1]
        if not name then
            if Spectate.active then Spectate.disable()
            else Spectate.enable() end
            return
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and string.find(string.lower(p.Name), string.lower(name)) then
                CFG.Spectate.On = true
                Spectate.enable()
                Spectate.setTarget(p)
                Notify.send("Spectate", "Watching " .. p.DisplayName, "info", 2)
                return
            end
        end
        Notify.send("Spectate", "Player not found", "error", 2)
    end)
    ChatCmds.register("unspec", "Stop spectating", function(args)
        Spectate.disable()
        CFG.Spectate.On = false
        Notify.send("Spectate", "Stopped", "info", 2)
    end)
    ChatCmds.register("gravity", "Set gravity", function(args)
        local val = tonumber(args[1]) or 196.2
        workspace.Gravity = math.clamp(val, 0, 1000)
        Notify.send("Gravity", "Set to " .. workspace.Gravity, "success", 2)
    end)
    ChatCmds.register("jump", "Set jump power", function(args)
        local val = tonumber(args[1]) or 50
        CFG.Movement.HighJump.On = true
        CFG.Movement.HighJump.Power = math.clamp(val, 0, 500)
        Notify.send("Jump", "Power set to " .. CFG.Movement.HighJump.Power, "success", 2)
    end)
    ChatCmds.register("fov", "Set field of view", function(args)
        local val = tonumber(args[1]) or 70
        CFG.FOVChanger.On = true
        CFG.FOVChanger.Value = math.clamp(val, 30, 120)
        Notify.send("FOV", "Set to " .. CFG.FOVChanger.Value, "success", 2)
    end)
    ChatCmds.register("time", "Set time of day", function(args)
        local val = tonumber(args[1]) or 12
        CFG.World.TimeOfDay.On = true
        CFG.World.TimeOfDay.Value = math.clamp(val, 0, 24)
        Lighting.ClockTime = CFG.World.TimeOfDay.Value
        Notify.send("Time", "Set to " .. CFG.World.TimeOfDay.Value, "success", 2)
    end)
    ChatCmds.register("reset", "Reset character", function(args)
        local hum = U.myHumanoid()
        if hum then hum.Health = 0 end
    end)
    ChatCmds.register("rejoin", "Rejoin the server", function(args)
        Notify.send("Rejoin", "Rejoining...", "warning", 2)
        task.delay(1, function()
            pcall(function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
            end)
        end)
    end)
    ChatCmds.register("serverhop", "Join a new server", function(args)
        Notify.send("ServerHop", "Finding server...", "warning", 2)
        task.delay(0.5, function()
            pcall(function()
                local ts = game:GetService("TeleportService")
                local servers = HttpService:JSONDecode(
                    game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=10")
                )
                if servers and servers.data then
                    for _, s in ipairs(servers.data) do
                        if s.id ~= game.JobId then
                            ts:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                            return
                        end
                    end
                end
                ts:Teleport(game.PlaceId, LP)
            end)
        end)
    end)
    ChatCmds.register("esp", "Toggle ESP", function(args)
        CFG.BoxESP.On = not CFG.BoxESP.On
        Notify.send("ESP", CFG.BoxESP.On and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("chams", "Toggle chams", function(args)
        CFG.Chams.On = not CFG.Chams.On
        Notify.send("Chams", CFG.Chams.On and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("aimbot", "Toggle aimbot", function(args)
        CFG.Aimbot.On = not CFG.Aimbot.On
        Notify.send("Aimbot", CFG.Aimbot.On and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("silent", "Toggle silent aim", function(args)
        CFG.SilentAim.On = not CFG.SilentAim.On
        Notify.send("Silent", CFG.SilentAim.On and "Enabled" or "Disabled", "info", 2)
    end)
    ChatCmds.register("save", "Save config", function(args)
        local name = args[1] or "default"
        local ok, err = ConfigManager.save(name)
        Notify.send("Config", ok and ("Saved: " .. name) or ("Error: " .. tostring(err)), ok and "success" or "error", 2)
    end)
    ChatCmds.register("load", "Load config", function(args)
        local name = args[1] or "default"
        local ok, err = ConfigManager.load(name)
        Notify.send("Config", ok and ("Loaded: " .. name) or ("Error: " .. tostring(err)), ok and "success" or "error", 2)
    end)
    ChatCmds.register("help", "Show commands", function(args)
        local cmds = {}
        for name, data in pairs(ChatCmds.commands) do
            table.insert(cmds, CFG.ChatCommands.Prefix .. name)
        end
        table.sort(cmds)
        Notify.send("Commands", table.concat(cmds, ", "), "info", 6)
    end)
    ChatCmds.register("players", "List players", function(args)
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(names, p.DisplayName) end
        end
        Notify.send("Players", table.concat(names, ", "), "info", 5)
    end)
    ChatCmds.register("destroy", "Destroy script", function(args)
        Notify.send("Lunarix", "Destroying...", "warning", 2)
        task.delay(1, function()
            disableFly(); disableNoclip()
            for _, p in ipairs(Players:GetPlayers()) do killChams(p) end
            pcall(function() SG:Destroy() end)
        end)
    end)

    pcall(function()
        LP.Chatted:Connect(function(msg)
            ChatCmds.parse(msg)
        end)
    end)
end

local WorldManip = {}

function WorldManip.setTimeOfDay(hour)
    pcall(function() Lighting.ClockTime = hour end)
end

function WorldManip.setGravity(val)
    pcall(function() workspace.Gravity = val end)
end

function WorldManip.removeClutter()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            pcall(function() v.Transparency = 1 end)
        end
    end
end

function WorldManip.removeShadows()
    pcall(function()
        Lighting.GlobalShadows = false
        for _, v in ipairs(Lighting:GetDescendants()) do
            if v:IsA("ShadowMap") then pcall(function() v:Destroy() end) end
        end
    end)
end

function WorldManip.removeWater()
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterTransparency = 1
            terrain.WaterReflectance = 0
        end
    end)
end

function WorldManip.setAtmosphere(density, haze)
    pcall(function()
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmo then
            atmo.Density = density
            atmo.Haze = haze
        end
    end)
end

function WorldManip.applySettings()
    if CFG.World.TimeOfDay.On then WorldManip.setTimeOfDay(CFG.World.TimeOfDay.Value) end
    if CFG.World.CustomGravity.On then WorldManip.setGravity(CFG.World.CustomGravity.Value) end
    if CFG.World.RemoveShadows.On then WorldManip.removeShadows() end
    if CFG.World.RemoveWater.On then WorldManip.removeWater() end
    if CFG.World.Atmosphere.On then WorldManip.setAtmosphere(CFG.World.Atmosphere.Density, CFG.World.Atmosphere.Haze) end
end

local AimIndicator = {}

function AimIndicator.render(target, ctr)
    if not ENV.Drawing then return end
    if not target or not U.alive(target) then return end
    local ch = target.Character
    if not ch then return end
    local part = getTargetPart(ch, CFG.Aimbot.Part)
    if not part then return end
    local sp, on = U.w2s(part.Position)
    if not on then return end

    local col = U.c3rgb(CFG.GUI.Accent)
    local sz = 16
    Draw.line(Vector2.new(sp.X - sz, sp.Y), Vector2.new(sp.X - sz / 2, sp.Y), col, 1.5)
    Draw.line(Vector2.new(sp.X + sz / 2, sp.Y), Vector2.new(sp.X + sz, sp.Y), col, 1.5)
    Draw.line(Vector2.new(sp.X, sp.Y - sz), Vector2.new(sp.X, sp.Y - sz / 2), col, 1.5)
    Draw.line(Vector2.new(sp.X, sp.Y + sz / 2), Vector2.new(sp.X, sp.Y + sz), col, 1.5)

    Draw.line(ctr, sp, Color3.fromRGB(232, 67, 147), 0.5)

    local namePos = Vector2.new(sp.X, sp.Y - sz - 12)
    Draw.text(namePos, target.DisplayName, col, 11, true)
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
    Draw.Triangles = Pool.new("Triangle", {Visible = false, Thickness = 1})

    Draw.flush = function()
        Draw.Lines:flush(); Draw.Texts:flush(); Draw.Circles:flush(); Draw.Quads:flush(); Draw.Triangles:flush()
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
    Draw.triangle = function(a, b, c2, col, thick, filled)
        local t = Draw.Triangles:get()
        t.PointA = a; t.PointB = b; t.PointC = c2
        t.Color = col; t.Thickness = thick or 1; t.Filled = filled or false; t.Visible = true
        return t
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
    bbgFolder.Name = "LX_E"; bbgFolder.Parent = workspace.CurrentCamera
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
    Draw.triangle = function() end
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

local Notify = {}
Notify.queue = {}
Notify.maxVisible = 5
Notify.holder = nil

function Notify.init(parent)
    Notify.holder = Instance.new("Frame", parent)
    Notify.holder.Size = UDim2.new(0, 260, 1, 0)
    Notify.holder.Position = UDim2.new(1, -270, 0, 0)
    Notify.holder.BackgroundTransparency = 1
    Notify.holder.BorderSizePixel = 0
    Notify.holder.ZIndex = 100
    local lay = Instance.new("UIListLayout", Notify.holder)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay.Padding = UDim.new(0, 4)
    lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    local pad = Instance.new("UIPadding", Notify.holder)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
end

function Notify.send(title, msg, notifType, duration)
    if not CFG.GUI.Notifications then return end
    if not Notify.holder then return end
    duration = duration or CFG.GUI.NotifDuration

    local colors = {
        info = Color3.fromRGB(232, 67, 147),
        success = Color3.fromRGB(40, 200, 80),
        warning = Color3.fromRGB(255, 180, 40),
        error = Color3.fromRGB(240, 50, 50),
    }
    local accentCol = colors[notifType] or colors.info

    local f = Instance.new("Frame", Notify.holder)
    f.Size = UDim2.new(0, 250, 0, 0)
    f.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    f.BorderSizePixel = 0; f.ClipsDescendants = true
    f.BackgroundTransparency = 0.08
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = accentCol; stroke.Thickness = 1; stroke.Transparency = 0.6

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = accentCol; bar.BorderSizePixel = 0

    local tLbl = Instance.new("TextLabel", f)
    tLbl.Text = title or "Lunarix"
    tLbl.Font = Enum.Font.GothamBold; tLbl.TextSize = 11
    tLbl.TextColor3 = accentCol; tLbl.BackgroundTransparency = 1
    tLbl.Position = UDim2.new(0, 12, 0, 5)
    tLbl.Size = UDim2.new(1, -16, 0, 14)
    tLbl.TextXAlignment = Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", f)
    mLbl.Text = msg or ""
    mLbl.Font = Enum.Font.Gotham; mLbl.TextSize = 10
    mLbl.TextColor3 = Color3.fromRGB(200, 200, 210)
    mLbl.BackgroundTransparency = 1
    mLbl.Position = UDim2.new(0, 12, 0, 20)
    mLbl.Size = UDim2.new(1, -16, 0, 22)
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.TextWrapped = true
    mLbl.TextYAlignment = Enum.TextYAlignment.Top

    local prog = Instance.new("Frame", f)
    prog.Size = UDim2.new(1, 0, 0, 2)
    prog.Position = UDim2.new(0, 0, 1, -2)
    prog.BackgroundColor3 = accentCol; prog.BorderSizePixel = 0

    TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 250, 0, 48)
    }):Play()

    task.delay(0.1, function()
        TweenService:Create(prog, TweenInfo.new(duration - 0.3, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 2)
        }):Play()
    end)

    task.delay(duration, function()
        TweenService:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 250, 0, 0), BackgroundTransparency = 1
        }):Play()
        task.delay(0.25, function()
            if f and f.Parent then f:Destroy() end
        end)
    end)

    table.insert(Notify.queue, f)
    if #Notify.queue > Notify.maxVisible then
        local oldest = table.remove(Notify.queue, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end
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
                clone.Name = "LX_G"
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
local stickyTarget = nil
local aimHeld = false
local lastAutoFire = 0

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
    local center = U.screenCenter()
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
    if cfg == CFG.Aimbot and CFG.Aimbot.StickyTarget and stickyTarget and U.alive(stickyTarget) then
        local score = scoreTarget(stickyTarget, cfg)
        if score then return stickyTarget end
    end
    local best, bestScore = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local score = scoreTarget(p, cfg)
            if score and score < bestScore then bestScore = score; best = p end
        end
    end
    if cfg == CFG.Aimbot then stickyTarget = best end
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
local dynSpread = 0

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

    if cfg.Dynamic then
        local hum = U.myHumanoid()
        if hum then
            local moveSpeed = hum.MoveDirection.Magnitude
            local target = moveSpeed > 0.1 and (cfg.Gap * cfg.DynScale) or cfg.Gap
            dynSpread = U.lerp(dynSpread, target, 0.1)
            g = math.floor(dynSpread + 0.5)
        end
    end

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
    elseif cfg.Style == "T-Shape" then
        local ca, sa = math.cos(crossAngle), math.sin(crossAngle)
        local dirs = {{0, 1}, {-1, 0}, {1, 0}}
        for i = 4, 8 do Draw.CrossLines[i].Visible = false end
        for i, dir in ipairs(dirs) do
            local dx, dy = dir[1], dir[2]
            local rdx, rdy = dx * ca - dy * sa, dx * sa + dy * ca
            local fx, fy = ctr.X + rdx * g, ctr.Y + rdy * g
            local tx, ty = ctr.X + rdx * (g + s), ctr.Y + rdy * (g + s)
            Draw.CrossLines[i].From = Vector2.new(fx, fy); Draw.CrossLines[i].To = Vector2.new(tx, ty)
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
    local parts = {"LUNARIX"}
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
    if CFG.Watermark.ShowPlayer then
        table.insert(parts, LP.DisplayName)
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

    local espCol = col
    if CFG.BoxESP.DynamicColor then
        espCol = U.hpColor(U.hpFrac(p))
    end

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
        Draw.line(tl, tr, espCol, thick); Draw.line(tr, br, espCol, thick)
        Draw.line(br, bl, espCol, thick); Draw.line(bl, tl, espCol, thick)
        if CFG.BoxESP.FillAlpha > 0 then
            local isE = not U.team(p)
            Draw.quad(tl, tr, br, bl, isE and U.c3(CFG.BoxESP.EnemyFill) or U.c3(CFG.BoxESP.TeamFill), 1, true)
        end
    elseif CFG.BoxESP.Mode == "Corner" then
        local cl = math.min(CFG.BoxESP.CornerLength, w / 3, h / 3)
        if CFG.BoxESP.Outline then
            local oc = U.c3(CFG.BoxESP.OutlineColor)
            local ot = CFG.BoxESP.OutlineThick
            Draw.line(tl, Vector2.new(tl.X + cl, tl.Y), oc, ot)
            Draw.line(tl, Vector2.new(tl.X, tl.Y + cl), oc, ot)
            Draw.line(tr, Vector2.new(tr.X - cl, tr.Y), oc, ot)
            Draw.line(tr, Vector2.new(tr.X, tr.Y + cl), oc, ot)
            Draw.line(bl, Vector2.new(bl.X + cl, bl.Y), oc, ot)
            Draw.line(bl, Vector2.new(bl.X, bl.Y - cl), oc, ot)
            Draw.line(br, Vector2.new(br.X - cl, br.Y), oc, ot)
            Draw.line(br, Vector2.new(br.X, br.Y - cl), oc, ot)
        end
        Draw.line(tl, Vector2.new(tl.X + cl, tl.Y), espCol, thick)
        Draw.line(tl, Vector2.new(tl.X, tl.Y + cl), espCol, thick)
        Draw.line(tr, Vector2.new(tr.X - cl, tr.Y), espCol, thick)
        Draw.line(tr, Vector2.new(tr.X, tr.Y + cl), espCol, thick)
        Draw.line(bl, Vector2.new(bl.X + cl, bl.Y), espCol, thick)
        Draw.line(bl, Vector2.new(bl.X, bl.Y - cl), espCol, thick)
        Draw.line(br, Vector2.new(br.X - cl, br.Y), espCol, thick)
        Draw.line(br, Vector2.new(br.X, br.Y - cl), espCol, thick)
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
                Draw.line(s2d[e[1]], s2d[e[2]], espCol, thick)
            end
        end
    end

    local yOff = 0
    if CFG.BoxESP.Name then
        Draw.text(Vector2.new(topP.X, topP.Y - CFG.BoxESP.NameSize - 4), p.DisplayName, espCol, CFG.BoxESP.NameSize)
    end
    if CFG.BoxESP.Health then
        local frac = U.hpFrac(p)
        local hCol = U.hpColor(frac)
        if CFG.BoxESP.HealthPos == "Left" then
            local bx = tl.X - 6
            Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, topP.Y), Color3.new(0, 0, 0), 4)
            Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, botP.Y - (botP.Y - topP.Y) * frac), hCol, 2.5)
        else
            local bx = br.X + 6
            Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, topP.Y), Color3.new(0, 0, 0), 4)
            Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, botP.Y - (botP.Y - topP.Y) * frac), hCol, 2.5)
        end
        if CFG.BoxESP.HealthNum then
            Draw.text(Vector2.new(tl.X - 22, botP.Y - (botP.Y - topP.Y) * frac - 6), U.formatHP(p), hCol, 10)
        end
    end
    if CFG.BoxESP.Dist then
        Draw.text(Vector2.new(botP.X, botP.Y + 2 + yOff), U.formatDist(d3), Color3.fromRGB(200, 200, 200), CFG.BoxESP.DistSize)
        yOff = yOff + 14
    end
    if CFG.BoxESP.Weapon then
        local wep = U.getWeapon(p)
        if wep ~= "None" then
            Draw.text(Vector2.new(botP.X, botP.Y + 2 + yOff), "[" .. wep .. "]", Color3.fromRGB(180, 180, 200), 11)
            yOff = yOff + 14
        end
    end
    if CFG.BoxESP.Flags then
        local flags = U.getPlayerFlags(p)
        if #flags > 0 then
            local flagStr = table.concat(flags, " | ")
            Draw.text(Vector2.new(botP.X, botP.Y + 2 + yOff), flagStr, Color3.fromRGB(255, 200, 100), 10)
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

local function renderOffScreenArrow(p, ch, root, ctr, vp)
    if not CFG.OffScreen.On then return end
    if not CFG.OffScreen.ShowTeam and U.team(p) then return end
    local sp, on = U.w2s(root.Position)
    if on then return end

    local dir = (sp - ctr).Unit
    local r = CFG.OffScreen.Radius
    local tip = ctr + dir * r
    local arrowSize = CFG.OffScreen.Size
    local perp = Vector2.new(-dir.Y, dir.X)
    local base1 = tip - dir * arrowSize + perp * (arrowSize * 0.4)
    local base2 = tip - dir * arrowSize - perp * (arrowSize * 0.4)
    local col = U.c3(CFG.OffScreen.Color)

    Draw.triangle(tip, base1, base2, col, 1, true)
end

local flyBV = nil
local flyBG = nil
local flyActive = false
local noclipConn = nil
local noclipActive = false
local infJumpConn = nil
local origFog = nil
local origAmbient = nil
local origBrightness = nil

local function enableFly()
    local root = U.myRoot()
    if not root then return end
    local hum = U.myHumanoid()
    if hum then hum.PlatformStand = true end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = root

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBG.D = 200
    flyBG.P = 10000
    flyBG.CFrame = Camera.CFrame
    flyBG.Parent = root

    flyActive = true
end

local function disableFly()
    flyActive = false
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end); flyBG = nil end
    local hum = U.myHumanoid()
    if hum then hum.PlatformStand = false end
end

local function updateFly()
    if not flyActive or not flyBV or not flyBG then return end
    local root = U.myRoot()
    if not root then disableFly(); return end

    local speed = CFG.Movement.Fly.Speed
    local cf = Camera.CFrame
    flyBG.CFrame = cf

    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

    if dir.Magnitude > 0 then
        flyBV.Velocity = dir.Unit * speed
    else
        flyBV.Velocity = Vector3.zero
    end
end

local function enableNoclip()
    if noclipConn then return end
    noclipActive = true
    noclipConn = RunService.Stepped:Connect(function()
        if not noclipActive then return end
        local ch = LP.Character
        if not ch then return end
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    noclipActive = false
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

local function setupInfJump()
    if infJumpConn then return end
    infJumpConn = UIS.JumpRequest:Connect(function()
        if not CFG.Movement.InfJump.On then return end
        local hum = U.myHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function updateSpeed()
    local hum = U.myHumanoid()
    if not hum then return end
    if CFG.Movement.Speed.On then
        hum.WalkSpeed = CFG.Movement.Speed.Value
    end
end

local function updateHighJump()
    local hum = U.myHumanoid()
    if not hum then return end
    if CFG.Movement.HighJump.On then
        hum.JumpPower = CFG.Movement.HighJump.Power
    end
end

local function doLongJump()
    if not CFG.Movement.LongJump.On then return end
    local root = U.myRoot()
    if not root then return end
    local dir = root.CFrame.LookVector
    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + dir * CFG.Movement.LongJump.Force
end

local function doTeleport()
    if not CFG.Teleport.On then return end
    local root = U.myRoot()
    if not root then return end
    local target = Mouse.Hit
    if target then
        root.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
    end
end

local antiAFKConn = nil

local function enableAntiAFK()
    if antiAFKConn then return end
    pcall(function()
        LP.Idled:Connect(function()
            if CFG.Player.AntiAFK.On then
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end
        end)
    end)
    antiAFKConn = true
end

local function updateHitboxExpand()
    if not CFG.Player.HitboxExpand.On then return end
    local sz = CFG.Player.HitboxExpand.Size
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local ch = p.Character
            if ch then
                local head = ch:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    head.Size = Vector3.new(sz, sz, sz)
                    head.Transparency = 0.7
                end
            end
        end
    end
end

local function resetHitboxes()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local ch = p.Character
            if ch then
                local head = ch:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end
        end
    end
end

local function enableFullBright()
    if not origAmbient then
        origAmbient = Lighting.Ambient
        origBrightness = Lighting.Brightness
    end
    Lighting.Ambient = Color3.fromRGB(200, 200, 200)
    Lighting.Brightness = 2
    Lighting.FogEnd = 100000
end

local function disableFullBright()
    if origAmbient then
        Lighting.Ambient = origAmbient
        Lighting.Brightness = origBrightness
    end
end

local function enableNoFog()
    if not origFog then origFog = Lighting.FogEnd end
    Lighting.FogEnd = 100000
end

local function disableNoFog()
    if origFog then Lighting.FogEnd = origFog end
end

local function removeParticles()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            pcall(function() v.Enabled = false end)
        end
    end
end

local function autoRespawn()
    if not CFG.Player.AutoRespawn.On then return end
    local ch = LP.Character
    if ch then
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            task.delay(CFG.Player.AutoRespawn.Delay, function()
                pcall(function()
                    LP:LoadCharacter()
                end)
            end)
        end
    end
end

local BUDGET_MS = 6
local frame = 0
local clk = os.clock
local lastDt = 0

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == CFG.Aimbot.Key then aimHeld = true end

    if input.KeyCode == CFG.Movement.Fly.Key then
        if CFG.Movement.Fly.On then
            if flyActive then disableFly() else enableFly() end
        end
    end

    if input.KeyCode == CFG.Movement.Noclip.Key then
        if CFG.Movement.Noclip.On then
            if noclipActive then disableNoclip() else enableNoclip() end
        end
    end

    if input.KeyCode == CFG.Teleport.Key then
        doTeleport()
    end

    if input.KeyCode == Enum.KeyCode.Space then
        doLongJump()
    end

    if input.KeyCode == CFG.Freecam.Key then
        if CFG.Freecam.On then
            if Freecam.active then Freecam.disable() else Freecam.enable() end
            Notify.send("Freecam", Freecam.active and "Enabled" or "Disabled", "info", 2)
        end
    end

    if input.KeyCode == CFG.Spectate.Key then
        if CFG.Spectate.On then
            if Spectate.active then
                Spectate.disable()
                Notify.send("Spectate", "Disabled", "info", 2)
            else
                Spectate.enable()
                if Spectate.target then
                    Notify.send("Spectate", "Watching: " .. Spectate.target.DisplayName, "info", 2)
                end
            end
        end
    end

    if input.KeyCode == CFG.PlayerList.Key then
        if CFG.PlayerList.On then
            PlayerListDisplay.visible = true
        end
    end

    if Spectate.active then
        if input.KeyCode == Enum.KeyCode.E then
            Spectate.next()
            if Spectate.target then
                Notify.send("Spectate", "Watching: " .. Spectate.target.DisplayName, "info", 1.5)
            end
        elseif input.KeyCode == Enum.KeyCode.Q then
            Spectate.prev()
            if Spectate.target then
                Notify.send("Spectate", "Watching: " .. Spectate.target.DisplayName, "info", 1.5)
            end
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == CFG.Aimbot.Key then aimHeld = false end
    if input.KeyCode == CFG.PlayerList.Key then
        PlayerListDisplay.visible = false
    end
end)

setupInfJump()
enableAntiAFK()
ChatCmds.init()
KillFeed.init()

RunService.RenderStepped:Connect(function()
    frame = frame + 1
    local t0 = clk()
    local vp = Camera.ViewportSize
    local ctr = Vector2.new(vp.X / 2, vp.Y / 2)
    Camera = workspace.CurrentCamera

    if flyActive then updateFly() end
    if CFG.Movement.Speed.On then updateSpeed() end
    if CFG.Movement.HighJump.On then updateHighJump() end
    if CFG.Player.FullBright.On then enableFullBright() end
    if CFG.Player.NoFog.On then enableNoFog() end

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
                elseif CFG.Aimbot.Mode == "Smooth" then
                    local cur = Camera.CFrame.LookVector
                    local des = (tPos - Camera.CFrame.Position).Unit
                    local nw = cur:Lerp(des, math.clamp(CFG.Aimbot.Smoothness, 0.01, 1))
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + nw)
                elseif CFG.Aimbot.Mode == "Bezier" then
                    local cur = Camera.CFrame.LookVector
                    local des = (tPos - Camera.CFrame.Position).Unit
                    local t = U.smoothStep(math.clamp(CFG.Aimbot.Smoothness, 0.01, 1))
                    local nw = cur:Lerp(des, t)
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + nw)
                end
            end
        end

        if CFG.Aimbot.AutoFire and currentTarget then
            local now = tick()
            if now - lastAutoFire >= CFG.Aimbot.AutoFireDelay then
                pcall(function() mouse1click() end)
                lastAutoFire = now
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

    if frame % 30 == 0 and CFG.Player.HitboxExpand.On then updateHitboxExpand() end
    if frame % 60 == 0 and CFG.Player.NoParticles.On then removeParticles() end
    if frame % 120 == 0 then WorldManip.applySettings() end

    if Freecam.active then Freecam.update(lastDt > 0 and lastDt or 0.016) end
    if Spectate.active then Spectate.update(lastDt > 0 and lastDt or 0.016) end

    KillFeed.update()

    renderCrosshair(ctr)
    Draw.flush()

    if currentTarget and aimHeld then
        AimIndicator.render(currentTarget, ctr)
    end

    local doESP = frame % 2 == 0
    local doItem = frame % 8 == 0
    local doWM = frame % 15 == 0
    local doRadar = frame % 3 == 0
    local doKillFeed = frame % 4 == 0
    local doTargetInfo = frame % 2 == 0
    local doPlayerList = frame % 3 == 0

    if doRadar then Radar.render() end
    if doKillFeed then KillFeed.render() end
    if doTargetInfo then
        local infoTarget = currentTarget or silentTarget
        TargetInfo.render(infoTarget)
    end
    if doPlayerList then PlayerListDisplay.render() end

    if Spectate.active and Spectate.target and ENV.Drawing then
        local spName = "Spectating: " .. Spectate.target.DisplayName
        local spDist = ""
        if U.alive(Spectate.target) then
            spDist = " | " .. U.formatDist(U.distanceToPlayer(Spectate.target))
        end
        Draw.text(Vector2.new(vp.X / 2, vp.Y - 50), spName .. spDist, Color3.fromRGB(232, 67, 147), 14, true)
        Draw.text(Vector2.new(vp.X / 2, vp.Y - 34), "[Q] Prev  [E] Next", Color3.fromRGB(150, 150, 170), 10, true)
    end

    if Freecam.active and ENV.Drawing then
        local pos = Freecam.position
        local coordText = string.format("Freecam | X:%.0f Y:%.0f Z:%.0f", pos.X, pos.Y, pos.Z)
        Draw.text(Vector2.new(vp.X / 2, vp.Y - 50), coordText, Color3.fromRGB(232, 67, 147), 13, true)
        Draw.text(Vector2.new(vp.X / 2, vp.Y - 34), "[WASD] Move  [Space/Ctrl] Up/Down  [Shift] Fast", Color3.fromRGB(150, 150, 170), 10, true)
    end

    if not doESP and not doItem then
        if doWM then renderWatermark() end
        lastDt = (clk() - t0)
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
            renderOffScreenArrow(p, ch, root, ctr, vp)
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

LP.CharacterAdded:Connect(function(ch)
    autoRespawn()
    if CFG.Movement.Noclip.On and noclipActive then
        disableNoclip()
        task.delay(0.5, enableNoclip)
    end
    if flyActive then
        disableFly()
        task.delay(0.5, function()
            if CFG.Movement.Fly.On then enableFly() end
        end)
    end
end)

local SG = Instance.new("ScreenGui")
SG.Name = "LX_" .. tostring(math.random(10000, 99999))
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

Notify.init(SG)

local blur
if CFG.GUI.BlurBackground then
    pcall(function() blur = Instance.new("BlurEffect"); blur.Size = 0; blur.Parent = Lighting end)
end

local menuOpen = false
local SC = CFG.GUI.Scale

local TH = {
    BG       = Color3.fromRGB(12, 12, 16),
    Panel    = Color3.fromRGB(20, 20, 27),
    Header   = Color3.fromRGB(15, 15, 20),
    Accent   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    AccentD  = Color3.fromRGB(180, 40, 110),
    AccentAlt = Color3.fromRGB(CFG.GUI.AccentAlt[1], CFG.GUI.AccentAlt[2], CFG.GUI.AccentAlt[3]),
    Text     = Color3.fromRGB(218, 218, 228),
    Sub      = Color3.fromRGB(100, 100, 118),
    Dim      = Color3.fromRGB(56, 56, 70),
    On       = Color3.fromRGB(232, 67, 147),
    Off      = Color3.fromRGB(36, 36, 46),
    SlBG     = Color3.fromRGB(28, 28, 36),
    SlFill   = Color3.fromRGB(CFG.GUI.Accent[1], CFG.GUI.Accent[2], CFG.GUI.Accent[3]),
    Bdr      = Color3.fromRGB(36, 36, 48),
    Tab      = Color3.fromRGB(13, 13, 17),
    TabHov   = Color3.fromRGB(24, 24, 32),
    Sep      = Color3.fromRGB(28, 28, 38),
    Hover    = Color3.fromRGB(26, 26, 34),
    Input    = Color3.fromRGB(22, 22, 29),
    Success  = Color3.fromRGB(40, 200, 80),
    Error    = Color3.fromRGB(240, 50, 50),
    Warning  = Color3.fromRGB(255, 180, 40),
}

local MW = math.floor(640 * SC)
local MH = math.floor(420 * SC)
local TW = math.floor(110 * SC)
local HH = math.floor(34 * SC)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, MW, 0, MH)
Main.Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2)
Main.BackgroundColor3 = TH.BG
Main.BackgroundTransparency = 1 - CFG.GUI.Opacity
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = TH.Accent; mainStroke.Thickness = 1; mainStroke.Transparency = 0.55

local shadow = Instance.new("ImageLabel", Main)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1; shadow.ImageTransparency = 0.5
shadow.Image = "rbxassetid://6014261993"; shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ScaleType = Enum.ScaleType.Slice; shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0

local accentBar = Instance.new("Frame", Main)
accentBar.Size = UDim2.new(1, 0, 0, 2)
accentBar.BackgroundColor3 = TH.Accent; accentBar.BorderSizePixel = 0; accentBar.ZIndex = 10
local accentGrad = Instance.new("UIGradient", accentBar)
accentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, TH.Accent),
    ColorSequenceKeypoint.new(0.5, TH.AccentAlt),
    ColorSequenceKeypoint.new(1, TH.Accent),
})
task.spawn(function()
    while SG and SG.Parent do
        TweenService:Create(accentGrad, TweenInfo.new(2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
        task.wait(2)
        accentGrad.Offset = Vector2.new(-1, 0)
    end
end)

local Hdr = Instance.new("Frame", Main)
Hdr.Size = UDim2.new(1, 0, 0, HH)
Hdr.Position = UDim2.new(0, 0, 0, 2)
Hdr.BackgroundColor3 = TH.Header; Hdr.BorderSizePixel = 0

local logoWrap = Instance.new("Frame", Hdr)
logoWrap.Size = UDim2.new(0, 24, 0, 24); logoWrap.Position = UDim2.new(0, 9, 0.5, -12)
logoWrap.BackgroundTransparency = 1; logoWrap.BorderSizePixel = 0; logoWrap.ClipsDescendants = true
local logoMoon = Instance.new("Frame", logoWrap)
logoMoon.Size = UDim2.new(0, 20, 0, 20); logoMoon.Position = UDim2.new(0, 2, 0, 2)
logoMoon.BackgroundColor3 = TH.Accent; logoMoon.BorderSizePixel = 0
Instance.new("UICorner", logoMoon).CornerRadius = UDim.new(1, 0)
local logoMoonGrad = Instance.new("UIGradient", logoMoon)
logoMoonGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt); logoMoonGrad.Rotation = 135
local logoCut = Instance.new("Frame", logoMoon)
logoCut.Size = UDim2.new(0, 15, 0, 15); logoCut.Position = UDim2.new(0, 7, 0, 2)
logoCut.BackgroundColor3 = TH.Header; logoCut.BorderSizePixel = 0; logoCut.ZIndex = 2
Instance.new("UICorner", logoCut).CornerRadius = UDim.new(1, 0)
local logoGlow = Instance.new("Frame", logoWrap)
logoGlow.Size = UDim2.new(0, 20, 0, 20); logoGlow.Position = UDim2.new(0, 2, 0, 2)
logoGlow.BackgroundColor3 = TH.Accent; logoGlow.BackgroundTransparency = 0.7; logoGlow.BorderSizePixel = 0; logoGlow.ZIndex = 0
Instance.new("UICorner", logoGlow).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    while SG and SG.Parent do
        TweenService:Create(logoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, -2, 0, -2), BackgroundTransparency = 1
        }):Play()
        task.wait(1.5)
        logoGlow.Size = UDim2.new(0, 20, 0, 20); logoGlow.Position = UDim2.new(0, 2, 0, 2); logoGlow.BackgroundTransparency = 0.7
    end
end)

local tLbl = Instance.new("TextLabel", Hdr)
tLbl.Text = "lunarix"; tLbl.Font = Enum.Font.FredokaOne; tLbl.TextSize = math.floor(16 * SC)
tLbl.TextColor3 = TH.Text; tLbl.BackgroundTransparency = 1
tLbl.Position = UDim2.new(0, 38, 0, 0); tLbl.Size = UDim2.new(0, 70, 1, 0)
tLbl.TextXAlignment = Enum.TextXAlignment.Left

local verLbl = Instance.new("TextLabel", Hdr)
verLbl.Text = "[v3.2]"; verLbl.Font = Enum.Font.Gotham; verLbl.TextSize = math.floor(10 * SC)
verLbl.TextColor3 = TH.Dim; verLbl.BackgroundTransparency = 1
verLbl.Position = UDim2.new(0, 108, 0, 0); verLbl.Size = UDim2.new(0, 36, 1, 0)
verLbl.TextXAlignment = Enum.TextXAlignment.Left

local hSepTxt = Instance.new("TextLabel", Hdr)
hSepTxt.Text = "|"; hSepTxt.Font = Enum.Font.Gotham; hSepTxt.TextSize = math.floor(10 * SC)
hSepTxt.TextColor3 = TH.Dim; hSepTxt.BackgroundTransparency = 1
hSepTxt.Position = UDim2.new(0, 146, 0, 0); hSepTxt.Size = UDim2.new(0, 10, 1, 0)

local devLbl = Instance.new("TextLabel", Hdr)
devLbl.RichText = true
devLbl.Text = 'developed by <font color="#e84393"><b>f07ant</b></font>'
devLbl.Font = Enum.Font.Gotham; devLbl.TextSize = math.floor(10 * SC)
devLbl.TextColor3 = TH.Sub; devLbl.BackgroundTransparency = 1
devLbl.Position = UDim2.new(0, 158, 0, 0); devLbl.Size = UDim2.new(0, 150, 1, 0)
devLbl.TextXAlignment = Enum.TextXAlignment.Left

local dateLbl = Instance.new("TextLabel", Hdr)
dateLbl.Text = string.lower(os.date("%A, %d %b %Y"))
dateLbl.Font = Enum.Font.Gotham; dateLbl.TextSize = math.floor(10 * SC)
dateLbl.TextColor3 = TH.Dim; dateLbl.BackgroundTransparency = 1
dateLbl.Position = UDim2.new(1, -160, 0, 0); dateLbl.Size = UDim2.new(0, 150, 1, 0)
dateLbl.TextXAlignment = Enum.TextXAlignment.Right

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

local tabContainer = Instance.new("Frame", TabBar)
tabContainer.Size = UDim2.new(1, 0, 1, -52); tabContainer.BackgroundTransparency = 1; tabContainer.BorderSizePixel = 0
local tabLay = Instance.new("UIListLayout", tabContainer)
tabLay.SortOrder = Enum.SortOrder.LayoutOrder; tabLay.Padding = UDim.new(0, 1)
local tabPad = Instance.new("UIPadding", tabContainer)
tabPad.PaddingTop = UDim.new(0, 6); tabPad.PaddingLeft = UDim.new(0, 4); tabPad.PaddingRight = UDim.new(0, 4)

local sLogo = Instance.new("Frame", TabBar)
sLogo.Size = UDim2.new(1, 0, 0, 48); sLogo.Position = UDim2.new(0, 0, 1, -48)
sLogo.BackgroundTransparency = 1; sLogo.BorderSizePixel = 0

local sIconWrap = Instance.new("Frame", sLogo)
sIconWrap.Size = UDim2.new(0, 18, 0, 18); sIconWrap.Position = UDim2.new(0.5, -9, 0, 4)
sIconWrap.BackgroundTransparency = 1; sIconWrap.BorderSizePixel = 0; sIconWrap.ClipsDescendants = true
local sMoon = Instance.new("Frame", sIconWrap)
sMoon.Size = UDim2.new(0, 15, 0, 15); sMoon.Position = UDim2.new(0, 1, 0, 1)
sMoon.BackgroundColor3 = TH.Accent; sMoon.BorderSizePixel = 0
Instance.new("UICorner", sMoon).CornerRadius = UDim.new(1, 0)
local sMoonGrad = Instance.new("UIGradient", sMoon)
sMoonGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt); sMoonGrad.Rotation = 135
local sCut = Instance.new("Frame", sMoon)
sCut.Size = UDim2.new(0, 11, 0, 11); sCut.Position = UDim2.new(0, 5, 0, 1)
sCut.BackgroundColor3 = TH.Tab; sCut.BorderSizePixel = 0; sCut.ZIndex = 2
Instance.new("UICorner", sCut).CornerRadius = UDim.new(1, 0)

local sName = Instance.new("TextLabel", sLogo)
sName.Text = "lunarix"; sName.Font = Enum.Font.FredokaOne; sName.TextSize = math.floor(9 * SC)
sName.TextColor3 = TH.Dim; sName.BackgroundTransparency = 1
sName.Size = UDim2.new(1, 0, 0, 14); sName.Position = UDim2.new(0, 0, 0, 24)

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
local activeDropdown = nil

local TAB_DEFS = {
    {name = "aimbot"},
    {name = "silent"},
    {name = "esp"},
    {name = "chams"},
    {name = "visuals"},
    {name = "movement"},
    {name = "world"},
    {name = "radar"},
    {name = "players"},
    {name = "misc"},
    {name = "settings"},
}

local function closeActiveDropdown()
    if activeDropdown then
        TweenService:Create(activeDropdown.f, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1, 0, 0, activeDropdown.ch)
        }):Play()
        activeDropdown.open = false
        activeDropdown = nil
    end
end

local function switchTab(name)
    if activeTab == name then return end
    closeActiveDropdown()
    activeTab = name
    for tName, tData in pairs(tabs) do
        local isAct = tName == name
        tData.page.Visible = isAct
        local ind = tData.btn:FindFirstChild("Indicator")
        TweenService:Create(tData.btn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
            BackgroundColor3 = isAct and TH.Hover or TH.Tab,
            BackgroundTransparency = isAct and 0 or 1
        }):Play()
        TweenService:Create(tData.lbl, TweenInfo.new(0.1), {
            TextColor3 = isAct and TH.Accent or TH.Sub
        }):Play()
        if ind then
            TweenService:Create(ind, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
                BackgroundTransparency = isAct and 0 or 1
            }):Play()
        end
    end
end

for idx, def in ipairs(TAB_DEFS) do
    local btn = Instance.new("TextButton", tabContainer)
    btn.Size = UDim2.new(1, 0, 0, math.floor(28 * SC))
    btn.BackgroundColor3 = TH.Tab; btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = idx; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local ind = Instance.new("Frame", btn)
    ind.Name = "Indicator"
    ind.Size = UDim2.new(0, 2, 0.55, 0); ind.Position = UDim2.new(0, 0, 0.225, 0)
    ind.BackgroundColor3 = TH.Accent; ind.BorderSizePixel = 0; ind.BackgroundTransparency = 1
    Instance.new("UICorner", ind).CornerRadius = UDim.new(0, 1)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Text = def.name; lbl.Font = Enum.Font.Gotham; lbl.TextSize = math.floor(11 * SC)
    lbl.TextColor3 = TH.Sub; lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -12, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2; page.ScrollBarImageColor3 = TH.Accent
    page.BorderSizePixel = 0; page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.Visible = false
    page.ClipsDescendants = true; page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.TopImage = "rbxassetid://7766642222"; page.MidImage = "rbxassetid://7766642222"; page.BottomImage = "rbxassetid://7766642222"
    local pLay = Instance.new("UIListLayout", page)
    pLay.SortOrder = Enum.SortOrder.LayoutOrder; pLay.Padding = UDim.new(0, 2)
    local pPad = Instance.new("UIPadding", page)
    pPad.PaddingTop = UDim.new(0, 6); pPad.PaddingBottom = UDim.new(0, 12)
    pPad.PaddingLeft = UDim.new(0, 8); pPad.PaddingRight = UDim.new(0, 8)

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

local function getPage(tabName)
    local t = tabs[tabName]; t.ord = t.ord + 1; return t.page, t.ord
end

local function Section(tabName, name)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 22); f.BackgroundTransparency = 1; f.LayoutOrder = order
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = TH.Sep; line.BorderSizePixel = 0
    local lbg = Instance.new("Frame", f)
    local textW = #name * 6.5 + 10
    lbg.Size = UDim2.new(0, textW, 0, 14); lbg.Position = UDim2.new(0, 2, 0.5, -7)
    lbg.BackgroundColor3 = TH.BG; lbg.BorderSizePixel = 0
    local l = Instance.new("TextLabel", lbg)
    l.Text = string.lower(name); l.Font = Enum.Font.GothamBold; l.TextSize = math.floor(9 * SC)
    l.TextColor3 = TH.Accent; l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 1, 0); l.TextXAlignment = Enum.TextXAlignment.Center
end

local function Label(tabName, text)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 18); f.BackgroundTransparency = 1; f.LayoutOrder = order
    local l = Instance.new("TextLabel", f)
    l.Text = text; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(9 * SC)
    l.TextColor3 = TH.Sub; l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 1, 0); l.Position = UDim2.new(0, 10, 0, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left
end

local function Separator(tabName)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 6); f.BackgroundTransparency = 1; f.LayoutOrder = order
end

local function Toggle(tabName, label, tbl, key, tooltip)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(11 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(0.7, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", f)
    track.Size = UDim2.new(0, 30, 0, 14); track.Position = UDim2.new(1, -42, 0.5, -7)
    track.BackgroundColor3 = tbl[key] and TH.On or TH.Off; track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", track)
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = tbl[key] and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    if tooltip then
        local tip = Instance.new("TextLabel", f)
        tip.Text = tooltip; tip.Font = Enum.Font.Gotham; tip.TextSize = math.floor(8 * SC)
        tip.TextColor3 = TH.Dim; tip.BackgroundTransparency = 1
        tip.Size = UDim2.new(0.6, 0, 0, 10); tip.Position = UDim2.new(0, 10, 1, -12)
        tip.TextXAlignment = Enum.TextXAlignment.Left; tip.Visible = false

        f.MouseEnter:Connect(function() tip.Visible = true end)
        f.MouseLeave:Connect(function() tip.Visible = false end)
    end

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 5
    btn.MouseButton1Click:Connect(function()
        tbl[key] = not tbl[key]; local on = tbl[key]
        TweenService:Create(track, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {BackgroundColor3 = on and TH.On or TH.Off}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = on and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        }):Play()
    end)
    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function Slider(tabName, label, tbl, key, mn, mx, stp, sfx)
    sfx = sfx or ""; stp = stp or 1
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 38); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(10 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 1); l.Size = UDim2.new(0.5, 0, 0, 14)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Font = Enum.Font.GothamBold; vl.TextSize = math.floor(10 * SC); vl.TextColor3 = TH.Accent
    vl.BackgroundTransparency = 1; vl.Position = UDim2.new(0.5, 0, 0, 1)
    vl.Size = UDim2.new(0.5, -10, 0, 14); vl.TextXAlignment = Enum.TextXAlignment.Right

    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -20, 0, 4); trk.Position = UDim2.new(0, 10, 0, 24)
    trk.BackgroundColor3 = TH.SlBG; trk.BorderSizePixel = 0
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", trk)
    fill.BackgroundColor3 = TH.SlFill; fill.BorderSizePixel = 0; fill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new(TH.Accent, TH.AccentAlt)

    local knob = Instance.new("Frame", trk)
    knob.Size = UDim2.new(0, 10, 0, 10); knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0); knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = TH.Accent; knobStroke.Thickness = 1.5

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
    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function Dropdown(tabName, label, tbl, key, options)
    local page, order = getPage(tabName)
    local COL_H = 28
    local ITEM_H = 22
    local EXP_H = COL_H + 4 + (#options * ITEM_H) + 4
    local isOpen = false

    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, COL_H); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0
    f.LayoutOrder = order; f.ClipsDescendants = true
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(11 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(0.45, 0, 0, COL_H)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local dbtn = Instance.new("TextButton", f)
    dbtn.Size = UDim2.new(0.45, 0, 0, 20); dbtn.Position = UDim2.new(0.52, 0, 0, 4)
    dbtn.BackgroundColor3 = TH.Input; dbtn.BorderSizePixel = 0
    dbtn.Font = Enum.Font.Gotham; dbtn.TextSize = math.floor(10 * SC)
    dbtn.TextColor3 = TH.Text; dbtn.Text = tostring(tbl[key]) .. "  ▾"; dbtn.AutoButtonColor = false
    Instance.new("UICorner", dbtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", dbtn).Color = TH.Bdr

    local optBtns = {}
    for oi, opt in ipairs(options) do
        local ob = Instance.new("TextButton", f)
        ob.Size = UDim2.new(1, -8, 0, ITEM_H)
        ob.Position = UDim2.new(0, 4, 0, COL_H + 4 + (oi - 1) * ITEM_H)
        ob.BackgroundTransparency = 1; ob.BackgroundColor3 = TH.Panel
        ob.BorderSizePixel = 0; ob.Font = Enum.Font.Gotham; ob.TextSize = math.floor(10 * SC)
        ob.TextColor3 = tbl[key] == opt and TH.Accent or TH.Text
        ob.Text = opt; ob.AutoButtonColor = false; ob.ZIndex = 5
        Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 3)
        optBtns[oi] = ob

        ob.MouseEnter:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.08), {BackgroundTransparency = 0, BackgroundColor3 = TH.Accent}):Play()
            ob.TextColor3 = Color3.new(1, 1, 1)
        end)
        ob.MouseLeave:Connect(function()
            TweenService:Create(ob, TweenInfo.new(0.08), {BackgroundTransparency = 1}):Play()
            ob.TextColor3 = tbl[key] == opt and TH.Accent or TH.Text
        end)
        ob.MouseButton1Click:Connect(function()
            tbl[key] = opt; dbtn.Text = opt .. "  ▾"
            for _, b in ipairs(optBtns) do b.TextColor3 = b.Text == opt and TH.Accent or TH.Text end
            isOpen = false; activeDropdown = nil
            TweenService:Create(f, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Size = UDim2.new(1, 0, 0, COL_H)
            }):Play()
        end)
    end

    dbtn.MouseButton1Click:Connect(function()
        if activeDropdown and activeDropdown.f ~= f then
            TweenService:Create(activeDropdown.f, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {
                Size = UDim2.new(1, 0, 0, activeDropdown.ch)
            }):Play()
            activeDropdown.open = false; activeDropdown = nil
        end
        isOpen = not isOpen
        activeDropdown = isOpen and {f = f, ch = COL_H, open = true} or nil
        TweenService:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, isOpen and EXP_H or COL_H)
        }):Play()
    end)

    f.MouseEnter:Connect(function()
        if not isOpen then TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end
    end)
    f.MouseLeave:Connect(function()
        if not isOpen then TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end
    end)
end

local function KeybindPicker(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(11 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(0.55, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local kbtn = Instance.new("TextButton", f)
    kbtn.Size = UDim2.new(0.35, 0, 0, 20); kbtn.Position = UDim2.new(0.6, 0, 0, 4)
    kbtn.BackgroundColor3 = TH.Input; kbtn.BorderSizePixel = 0
    kbtn.Font = Enum.Font.GothamBold; kbtn.TextSize = math.floor(10 * SC)
    kbtn.TextColor3 = TH.Accent; kbtn.AutoButtonColor = false
    Instance.new("UICorner", kbtn).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", kbtn).Color = TH.Bdr

    local listening = false
    local conn = nil

    local function updateText()
        local v = tbl[key]
        if typeof(v) == "EnumItem" then
            kbtn.Text = v.Name
        else
            kbtn.Text = tostring(v)
        end
    end
    updateText()

    kbtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kbtn.Text = "..."
        kbtn.TextColor3 = TH.Warning

        conn = UIS.InputBegan:Connect(function(input, gpe)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                tbl[key] = input.KeyCode
                updateText()
                kbtn.TextColor3 = TH.Accent
                listening = false
                if conn then conn:Disconnect(); conn = nil end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.MouseButton2 then
                tbl[key] = input.UserInputType
                updateText()
                kbtn.TextColor3 = TH.Accent
                listening = false
                if conn then conn:Disconnect(); conn = nil end
            end
        end)
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function TextInput(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(11 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 0); l.Size = UDim2.new(0.45, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local tb = Instance.new("TextBox", f)
    tb.Size = UDim2.new(0.45, 0, 0, 20); tb.Position = UDim2.new(0.52, 0, 0, 4)
    tb.BackgroundColor3 = TH.Input; tb.BorderSizePixel = 0
    tb.Font = Enum.Font.Gotham; tb.TextSize = math.floor(10 * SC)
    tb.TextColor3 = TH.Text; tb.Text = tostring(tbl[key])
    tb.PlaceholderText = "..."; tb.PlaceholderColor3 = TH.Dim
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", tb).Color = TH.Bdr

    tb.FocusLost:Connect(function()
        tbl[key] = tb.Text
    end)

    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end)
end

local function Button(tabName, label, callback)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1; f.LayoutOrder = order

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 0, 24); btn.Position = UDim2.new(0, 0, 0, 2)
    btn.BackgroundColor3 = TH.Accent; btn.BorderSizePixel = 0
    btn.Text = label; btn.Font = Enum.Font.GothamMedium; btn.TextSize = math.floor(11 * SC)
    btn.TextColor3 = Color3.new(1, 1, 1); btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        if callback then callback(btn) end
    end)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = TH.AccentAlt}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = TH.Accent}):Play() end)
end

local function ButtonPair(tabName, label1, cb1, label2, cb2)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 28); f.BackgroundTransparency = 1; f.LayoutOrder = order

    local btn1 = Instance.new("TextButton", f)
    btn1.Size = UDim2.new(0.48, 0, 0, 24); btn1.Position = UDim2.new(0, 0, 0, 2)
    btn1.BackgroundColor3 = TH.Accent; btn1.BorderSizePixel = 0; btn1.Text = label1
    btn1.Font = Enum.Font.GothamMedium; btn1.TextSize = math.floor(10 * SC); btn1.TextColor3 = Color3.new(1, 1, 1)
    btn1.AutoButtonColor = false
    Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 4)

    local btn2 = Instance.new("TextButton", f)
    btn2.Size = UDim2.new(0.48, 0, 0, 24); btn2.Position = UDim2.new(0.52, 0, 0, 2)
    btn2.BackgroundColor3 = TH.Off; btn2.BorderSizePixel = 0; btn2.Text = label2
    btn2.Font = Enum.Font.GothamMedium; btn2.TextSize = math.floor(10 * SC); btn2.TextColor3 = TH.Text
    btn2.AutoButtonColor = false
    Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 4)

    btn1.MouseButton1Click:Connect(function() if cb1 then cb1(btn1) end end)
    btn2.MouseButton1Click:Connect(function() if cb2 then cb2(btn2) end end)
    btn1.MouseEnter:Connect(function() TweenService:Create(btn1, TweenInfo.new(0.1), {BackgroundColor3 = TH.AccentAlt}):Play() end)
    btn1.MouseLeave:Connect(function() TweenService:Create(btn1, TweenInfo.new(0.1), {BackgroundColor3 = TH.Accent}):Play() end)
    btn2.MouseEnter:Connect(function() TweenService:Create(btn2, TweenInfo.new(0.1), {BackgroundColor3 = TH.Hover}):Play() end)
    btn2.MouseLeave:Connect(function() TweenService:Create(btn2, TweenInfo.new(0.1), {BackgroundColor3 = TH.Off}):Play() end)
end

local function ColorPick(tabName, label, tbl, key)
    local page, order = getPage(tabName)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 52); f.BackgroundColor3 = TH.Panel; f.BorderSizePixel = 0; f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel", f)
    l.Text = label; l.Font = Enum.Font.Gotham; l.TextSize = math.floor(10 * SC)
    l.TextColor3 = TH.Text; l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 2); l.Size = UDim2.new(0.5, 0, 0, 14)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local prev = Instance.new("Frame", f)
    prev.Size = UDim2.new(0, 20, 0, 12); prev.Position = UDim2.new(1, -34, 0, 4)
    prev.BackgroundColor3 = U.c3(tbl[key]); prev.BorderSizePixel = 0
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0, 3)
    Instance.new("UIStroke", prev).Color = TH.Bdr

    local hBar = Instance.new("Frame", f)
    hBar.Size = UDim2.new(1, -20, 0, 6); hBar.Position = UDim2.new(0, 10, 0, 20)
    hBar.BackgroundColor3 = Color3.new(1, 1, 1); hBar.BorderSizePixel = 0
    Instance.new("UICorner", hBar).CornerRadius = UDim.new(1, 0)
    local hGrad = Instance.new("UIGradient", hBar)
    local pts = {}
    for i = 0, 6 do pts[#pts + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)) end
    hGrad.Color = ColorSequence.new(pts)

    local sBar = Instance.new("Frame", f)
    sBar.Size = UDim2.new(0.47, -10, 0, 6); sBar.Position = UDim2.new(0, 10, 0, 34)
    sBar.BackgroundColor3 = Color3.new(1, 1, 1); sBar.BorderSizePixel = 0
    Instance.new("UICorner", sBar).CornerRadius = UDim.new(1, 0)

    local bBar = Instance.new("Frame", f)
    bBar.Size = UDim2.new(0.47, -10, 0, 6); bBar.Position = UDim2.new(0.53, 0, 0, 34)
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
    f.MouseEnter:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Hover}):Play() end)
    f.MouseLeave:Connect(function() TweenService:Create(f, TweenInfo.new(0.08), {BackgroundColor3 = TH.Panel}):Play() end)
end

Section("aimbot", "aimbot")
Toggle("aimbot", "Enabled", CFG.Aimbot, "On")
Dropdown("aimbot", "Mode", CFG.Aimbot, "Mode", {"Smooth", "Snap", "Bezier"})
Dropdown("aimbot", "Target Part", CFG.Aimbot, "Part", {"Head", "Torso", "Closest"})
Dropdown("aimbot", "Priority", CFG.Aimbot, "Priority", {"FOV", "Distance", "Health"})
Slider("aimbot", "FOV Radius", CFG.Aimbot, "FOV", 20, 600, 5, "px")
Slider("aimbot", "Smoothness", CFG.Aimbot, "Smoothness", 0.01, 1.0, 0.01, "")
Slider("aimbot", "Max Distance", CFG.Aimbot, "MaxDist", 100, 5000, 50, "m")
Toggle("aimbot", "Show FOV Circle", CFG.Aimbot, "ShowFOV")
Toggle("aimbot", "Prediction", CFG.Aimbot, "Predict")
Slider("aimbot", "Predict Scale", CFG.Aimbot, "PredictScale", 0.01, 0.5, 0.005, "")
Toggle("aimbot", "Sticky Target", CFG.Aimbot, "StickyTarget", "Locks on to a target until it's lost")
Toggle("aimbot", "Auto Fire", CFG.Aimbot, "AutoFire", "Automatically clicks when locked on")
Slider("aimbot", "Auto Fire Delay", CFG.Aimbot, "AutoFireDelay", 0.05, 1.0, 0.05, "s")
Toggle("aimbot", "Team Check", CFG.Aimbot, "TeamCheck")
Toggle("aimbot", "Wall Check", CFG.Aimbot, "WallCheck")
Toggle("aimbot", "Visibility Check", CFG.Aimbot, "VisCheck")
KeybindPicker("aimbot", "Aim Key", CFG.Aimbot, "Key")
Section("aimbot", "fov style")
Slider("aimbot", "Thickness", CFG.Aimbot, "FOVThick", 0.5, 5, 0.1, "")
Slider("aimbot", "Opacity", CFG.Aimbot, "FOVAlpha", 0.1, 1.0, 0.05, "")
Slider("aimbot", "Sides", CFG.Aimbot, "FOVSides", 12, 128, 1, "")
Toggle("aimbot", "Filled", CFG.Aimbot, "FOVFilled")
ColorPick("aimbot", "FOV Color", CFG.Aimbot, "FOVColor")
Section("aimbot", "aim tips")
Label("aimbot", "Smooth mode gradually moves to target")
Label("aimbot", "Snap mode instantly locks to target")
Label("aimbot", "Bezier mode uses curved interpolation")
Label("aimbot", "Lower smoothness = faster locking")
Label("aimbot", "FOV Priority sorts by screen distance")
Label("aimbot", "Distance Priority sorts by 3D distance")
Label("aimbot", "Health Priority targets low HP players")
Label("aimbot", "Wall Check blocks aim through walls")
Label("aimbot", "Visibility Check uses raycasting")
Label("aimbot", "Prediction compensates for movement")

Section("silent", "silent aim")
Toggle("silent", "Enabled", CFG.SilentAim, "On")
Dropdown("silent", "Target Part", CFG.SilentAim, "Part", {"Head", "Torso", "Closest"})
Dropdown("silent", "Method", CFG.SilentAim, "Method", {"Auto", "Namecall", "Raycast"})
Slider("silent", "FOV Radius", CFG.SilentAim, "FOV", 20, 500, 5, "px")
Slider("silent", "Hit Chance", CFG.SilentAim, "HitChance", 1, 100, 1, "%")
Toggle("silent", "Show FOV", CFG.SilentAim, "ShowFOV")
Toggle("silent", "Prediction", CFG.SilentAim, "Predict")
Slider("silent", "Predict Scale", CFG.SilentAim, "PredictScale", 0.01, 0.5, 0.005, "")
Toggle("silent", "Wall Check", CFG.SilentAim, "WallCheck")
Toggle("silent", "Team Check", CFG.SilentAim, "TeamCheck")
Section("silent", "fov style")
Slider("silent", "Thickness", CFG.SilentAim, "FOVThick", 0.5, 5, 0.1, "")
Slider("silent", "Opacity", CFG.SilentAim, "FOVAlpha", 0.1, 1.0, 0.05, "")
Slider("silent", "Sides", CFG.SilentAim, "FOVSides", 12, 128, 1, "")
ColorPick("silent", "FOV Color", CFG.SilentAim, "FOVColor")
Section("silent", "info")
Label("silent", "Silent aim redirects raycasts to enemies")
Label("silent", "Works server-side - more reliable than aimbot")
Label("silent", "Hit Chance controls the probability of hits")
Label("silent", "100% = always redirect, 50% = half the time")
Label("silent", "Auto method picks hookmetamethod first")
Label("silent", "then falls back to getrawmetatable method")
Label("silent", "Wall Check prevents shooting through walls")
Label("silent", "Prediction compensates for target movement")
Label("silent", "Lower predict scale for close range")
Label("silent", "Higher predict scale for long range shots")

Section("esp", "box esp")
Toggle("esp", "Enabled", CFG.BoxESP, "On")
Dropdown("esp", "Style", CFG.BoxESP, "Mode", {"Full", "Corner", "3D"})
Dropdown("esp", "Health Position", CFG.BoxESP, "HealthPos", {"Left", "Right"})
Toggle("esp", "Names", CFG.BoxESP, "Name")
Toggle("esp", "Health Bars", CFG.BoxESP, "Health")
Toggle("esp", "Health Numbers", CFG.BoxESP, "HealthNum")
Toggle("esp", "Distance", CFG.BoxESP, "Dist")
Toggle("esp", "Weapon", CFG.BoxESP, "Weapon")
Toggle("esp", "Flags", CFG.BoxESP, "Flags", "Shows player state flags (jumping, tool, etc)")
Toggle("esp", "Dynamic Color", CFG.BoxESP, "DynamicColor", "Colors boxes by player health")
Toggle("esp", "Teammates", CFG.BoxESP, "ShowTeam")
Toggle("esp", "Outline", CFG.BoxESP, "Outline")
Slider("esp", "Max Distance", CFG.BoxESP, "MaxDist", 100, 5000, 50, "m")
Slider("esp", "Thickness", CFG.BoxESP, "Thick", 0.5, 5, 0.1, "")
Slider("esp", "Name Size", CFG.BoxESP, "NameSize", 8, 22, 1, "")
Slider("esp", "Corner Length", CFG.BoxESP, "CornerLength", 2, 20, 1, "")
Slider("esp", "Fill Opacity", CFG.BoxESP, "FillAlpha", 0, 1, 0.05, "")
ColorPick("esp", "Enemy Color", CFG.BoxESP, "EnemyColor")
ColorPick("esp", "Team Color", CFG.BoxESP, "TeamColor")
ColorPick("esp", "Enemy Fill", CFG.BoxESP, "EnemyFill")
ColorPick("esp", "Team Fill", CFG.BoxESP, "TeamFill")
ColorPick("esp", "Outline Color", CFG.BoxESP, "OutlineColor")
Section("esp", "tracers")
Toggle("esp", "Enabled", CFG.Tracers, "On")
Dropdown("esp", "Origin", CFG.Tracers, "Origin", {"Bottom", "Center", "Mouse"})
Toggle("esp", "Teammates", CFG.Tracers, "ShowTeam")
Slider("esp", "Thickness", CFG.Tracers, "Thick", 0.5, 4, 0.1, "")
Slider("esp", "Max Distance", CFG.Tracers, "MaxDist", 100, 5000, 50, "m")
ColorPick("esp", "Enemy", CFG.Tracers, "EnemyColor")
ColorPick("esp", "Team", CFG.Tracers, "TeamColor")
Section("esp", "snaplines")
Toggle("esp", "Enabled", CFG.Snaplines, "On")
Dropdown("esp", "Part", CFG.Snaplines, "Part", {"Head", "Torso", "Closest"})
Slider("esp", "Thickness", CFG.Snaplines, "Thick", 0.3, 3, 0.1, "")
ColorPick("esp", "Color", CFG.Snaplines, "Color")
Section("esp", "skeleton")
Toggle("esp", "Enabled", CFG.Skeleton, "On")
Toggle("esp", "Teammates", CFG.Skeleton, "ShowTeam")
Slider("esp", "Max Distance", CFG.Skeleton, "MaxDist", 100, 3000, 50, "m")
Slider("esp", "Thickness", CFG.Skeleton, "Thick", 0.3, 4, 0.1, "")
ColorPick("esp", "Enemy Bones", CFG.Skeleton, "EnemyColor")
ColorPick("esp", "Team Bones", CFG.Skeleton, "TeamColor")
Section("esp", "off-screen arrows")
Toggle("esp", "Enabled", CFG.OffScreen, "On")
Slider("esp", "Arrow Size", CFG.OffScreen, "Size", 6, 24, 1, "px")
Slider("esp", "Radius", CFG.OffScreen, "Radius", 50, 400, 10, "px")
Toggle("esp", "Teammates", CFG.OffScreen, "ShowTeam")
ColorPick("esp", "Arrow Color", CFG.OffScreen, "Color")
Section("esp", "items")
Toggle("esp", "Enabled", CFG.ItemESP, "On")
Toggle("esp", "Names", CFG.ItemESP, "Names")
Toggle("esp", "Distance", CFG.ItemESP, "Dist")
Toggle("esp", "Tracers", CFG.ItemESP, "Tracers")
Toggle("esp", "Icons", CFG.ItemESP, "Icon")
Slider("esp", "Max Distance", CFG.ItemESP, "MaxDist", 50, 2000, 50, "m")
Slider("esp", "Name Size", CFG.ItemESP, "NameSize", 8, 20, 1, "")
ColorPick("esp", "Item Color", CFG.ItemESP, "Color")
ColorPick("esp", "Tracer Color", CFG.ItemESP, "TracerColor")
Section("esp", "esp info")
Label("esp", "Full mode: complete rectangle around target")
Label("esp", "Corner mode: bracket corners only")
Label("esp", "3D mode: full 3D bounding box")
Label("esp", "Health bars show on left or right side")
Label("esp", "Dynamic Color overrides team/enemy colors")
Label("esp", "Tracers draw lines from screen origin")
Label("esp", "Snaplines draw lines from crosshair to head")
Label("esp", "Skeleton draws bone connections")
Label("esp", "Off-screen arrows point to hidden enemies")
Label("esp", "Item ESP detects tools, chests, loot, etc.")
Label("esp", "Items are found by keyword matching")
Label("esp", "Flags show state: jumping, tool, forcefield")
Separator("esp")
Button("esp", "Toggle All ESP On", function(btn)
    CFG.BoxESP.On = true
    CFG.Tracers.On = true
    CFG.Snaplines.On = true
    CFG.Skeleton.On = true
    CFG.OffScreen.On = true
    CFG.ItemESP.On = true
    btn.Text = "All On!"
    Notify.send("ESP", "All ESP features enabled", "success", 2)
    task.delay(1, function() btn.Text = "Toggle All ESP On" end)
end)
Button("esp", "Toggle All ESP Off", function(btn)
    CFG.BoxESP.On = false
    CFG.Tracers.On = false
    CFG.Snaplines.On = false
    CFG.Skeleton.On = false
    CFG.OffScreen.On = false
    CFG.ItemESP.On = false
    btn.Text = "All Off!"
    Notify.send("ESP", "All ESP features disabled", "info", 2)
    task.delay(1, function() btn.Text = "Toggle All ESP Off" end)
end)

Section("chams", "chams")
Toggle("chams", "Enabled", CFG.Chams, "On")
Dropdown("chams", "Mode", CFG.Chams, "Mode", {"Glow", "Highlight", "X-Ray", "Neon", "Rainbow"})
Dropdown("chams", "Depth", CFG.Chams, "DepthMode", {"AlwaysOnTop", "Occluded"})
Toggle("chams", "Team Colors", CFG.Chams, "TeamCheck")
Section("chams", "glow / neon")
Slider("chams", "Glow Transparency", CFG.Chams, "GlowAlpha", 0, 1, 0.05, "")
Slider("chams", "Glow Size", CFG.Chams, "GlowSize", 0.01, 0.3, 0.01, "")
Slider("chams", "Neon Transparency", CFG.Chams, "NeonAlpha", 0, 1, 0.05, "")
ColorPick("chams", "Glow Color", CFG.Chams, "GlowColor")
ColorPick("chams", "Neon Color", CFG.Chams, "NeonColor")
Section("chams", "highlight")
Slider("chams", "Fill Alpha", CFG.Chams, "HighlightFillAlpha", 0, 1, 0.05, "")
Slider("chams", "Outline Alpha", CFG.Chams, "HighlightOutAlpha", 0, 1, 0.05, "")
ColorPick("chams", "Fill", CFG.Chams, "HighlightFill")
ColorPick("chams", "Outline", CFG.Chams, "HighlightOut")
Section("chams", "x-ray")
Slider("chams", "Visible Alpha", CFG.Chams, "XRayVisibleAlpha", 0, 1, 0.05, "")
Slider("chams", "Occluded Alpha", CFG.Chams, "XRayOccludedAlpha", 0, 1, 0.05, "")
ColorPick("chams", "Visible Color", CFG.Chams, "XRayVisibleFill")
ColorPick("chams", "Occluded Color", CFG.Chams, "XRayOccludedFill")
Section("chams", "team / rainbow")
Slider("chams", "Rainbow Speed", CFG.Chams, "RainbowSpeed", 0.1, 5, 0.1, "x")
ColorPick("chams", "Enemy Color", CFG.Chams, "EnemyColor")
ColorPick("chams", "Team Color", CFG.Chams, "TeamColor")
Section("chams", "info")
Label("chams", "Glow: per-part Neon material clones")
Label("chams", "Visible through walls, very noticeable")
Label("chams", "Highlight: Roblox Highlight instance")
Label("chams", "Cleaner look, supports fill + outline")
Label("chams", "X-Ray: dual highlights (visible + occluded)")
Label("chams", "Different colors for visible vs behind walls")
Label("chams", "Neon: colored glow with custom transparency")
Label("chams", "Rainbow: cycles through HSV color wheel")
Label("chams", "Team Colors uses enemy/team color pairs")
Label("chams", "Glow Size controls expansion of clone parts")
Label("chams", "Smaller size = tighter fit to body")
Separator("chams")
Button("chams", "Remove All Chams", function(btn)
    CFG.Chams.On = false
    for _, p in ipairs(Players:GetPlayers()) do killChams(p) end
    btn.Text = "Cleared!"
    Notify.send("Chams", "All chams removed", "info", 2)
    task.delay(1, function() btn.Text = "Remove All Chams" end)
end)
Button("chams", "Apply to All Now", function(btn)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            updateChams(p)
        end
    end
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Apply to All Now" end)
end)

Section("visuals", "crosshair")
Toggle("visuals", "Enabled", CFG.Crosshair, "On")
Dropdown("visuals", "Style", CFG.Crosshair, "Style", {"Cross", "Circle", "Dot", "Diamond", "T-Shape"})
Slider("visuals", "Size", CFG.Crosshair, "Size", 2, 40, 1, "px")
Slider("visuals", "Gap", CFG.Crosshair, "Gap", 0, 20, 1, "px")
Slider("visuals", "Thickness", CFG.Crosshair, "Thick", 0.5, 5, 0.1, "")
Toggle("visuals", "Center Dot", CFG.Crosshair, "Dot")
Slider("visuals", "Dot Size", CFG.Crosshair, "DotSize", 1, 6, 0.5, "")
Toggle("visuals", "Outline", CFG.Crosshair, "Outline")
Toggle("visuals", "Rotate", CFG.Crosshair, "Rotate")
Slider("visuals", "Rotate Speed", CFG.Crosshair, "RotateSpeed", 0.5, 10, 0.5, "")
Toggle("visuals", "Dynamic Spread", CFG.Crosshair, "Dynamic", "Gap expands while moving")
Slider("visuals", "Dynamic Scale", CFG.Crosshair, "DynScale", 1.0, 4.0, 0.1, "x")
ColorPick("visuals", "Color", CFG.Crosshair, "Color")
Section("visuals", "fov changer")
Toggle("visuals", "Enabled", CFG.FOVChanger, "On")
Slider("visuals", "Field of View", CFG.FOVChanger, "Value", 30, 120, 1, "")
Toggle("visuals", "Smooth", CFG.FOVChanger, "Smooth")
Slider("visuals", "Smooth Speed", CFG.FOVChanger, "SmoothSpeed", 0.01, 0.5, 0.01, "")
Section("visuals", "watermark")
Toggle("visuals", "Enabled", CFG.Watermark, "On")
Toggle("visuals", "FPS", CFG.Watermark, "ShowFPS")
Toggle("visuals", "Ping", CFG.Watermark, "ShowPing")
Toggle("visuals", "Time", CFG.Watermark, "ShowTime")
Toggle("visuals", "Game Name", CFG.Watermark, "ShowGame")
Toggle("visuals", "Player Name", CFG.Watermark, "ShowPlayer")
Section("visuals", "crosshair info")
Label("visuals", "Cross: traditional + shape crosshair")
Label("visuals", "Circle: ring crosshair, good for shotguns")
Label("visuals", "Dot: just a center dot, minimal style")
Label("visuals", "Diamond: rotated square / diamond shape")
Label("visuals", "T-Shape: top arm removed from cross")
Label("visuals", "Dynamic Spread expands gap while moving")
Label("visuals", "Rotate spins the crosshair continuously")
Label("visuals", "Outline adds a black border for visibility")
Separator("visuals")
Section("visuals", "quick presets")
Button("visuals", "Preset: Competitive", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    CFG.Crosshair.Size = 6
    CFG.Crosshair.Gap = 4
    CFG.Crosshair.Thick = 1.5
    CFG.Crosshair.Dot = true
    CFG.Crosshair.DotSize = 2
    CFG.Crosshair.Outline = true
    CFG.Crosshair.Dynamic = true
    CFG.Crosshair.DynScale = 2.0
    CFG.Crosshair.Rotate = false
    CFG.Crosshair.Color = {1, 0.2, 0.8}
    btn.Text = "Applied!"
    Notify.send("Crosshair", "Competitive preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Preset: Competitive" end)
end)
Button("visuals", "Preset: Minimal", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Dot"
    CFG.Crosshair.Dot = true
    CFG.Crosshair.DotSize = 3
    CFG.Crosshair.Dynamic = false
    CFG.Crosshair.Rotate = false
    CFG.Crosshair.Color = {1, 1, 1}
    btn.Text = "Applied!"
    Notify.send("Crosshair", "Minimal preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Preset: Minimal" end)
end)
Button("visuals", "Preset: Flashy", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Diamond"
    CFG.Crosshair.Size = 12
    CFG.Crosshair.Gap = 6
    CFG.Crosshair.Thick = 2
    CFG.Crosshair.Dot = true
    CFG.Crosshair.DotSize = 3
    CFG.Crosshair.Outline = true
    CFG.Crosshair.Rotate = true
    CFG.Crosshair.RotateSpeed = 3
    CFG.Crosshair.Dynamic = true
    CFG.Crosshair.DynScale = 3.0
    CFG.Crosshair.Color = {232/255, 67/255, 147/255}
    btn.Text = "Applied!"
    Notify.send("Crosshair", "Flashy preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Preset: Flashy" end)
end)
Button("visuals", "Disable Crosshair", function(btn)
    CFG.Crosshair.On = false
    btn.Text = "Disabled!"
    task.delay(1, function() btn.Text = "Disable Crosshair" end)
end)

Section("movement", "speed")
Toggle("movement", "Enabled", CFG.Movement.Speed, "On")
Slider("movement", "Walk Speed", CFG.Movement.Speed, "Value", 16, 200, 1, "")
KeybindPicker("movement", "Speed Key", CFG.Movement.Speed, "Key")
Section("movement", "fly")
Toggle("movement", "Enabled", CFG.Movement.Fly, "On")
Slider("movement", "Fly Speed", CFG.Movement.Fly, "Speed", 10, 200, 5, "")
KeybindPicker("movement", "Fly Key", CFG.Movement.Fly, "Key")
Label("movement", "Press fly key to toggle fly mode")
Section("movement", "noclip")
Toggle("movement", "Enabled", CFG.Movement.Noclip, "On")
KeybindPicker("movement", "Noclip Key", CFG.Movement.Noclip, "Key")
Label("movement", "Press noclip key to toggle")
Section("movement", "jumps")
Toggle("movement", "Infinite Jump", CFG.Movement.InfJump, "On")
Toggle("movement", "High Jump", CFG.Movement.HighJump, "On")
Slider("movement", "Jump Power", CFG.Movement.HighJump, "Power", 50, 250, 5, "")
Toggle("movement", "Long Jump", CFG.Movement.LongJump, "On")
Slider("movement", "Long Jump Force", CFG.Movement.LongJump, "Force", 50, 500, 10, "")
Section("movement", "teleport")
Toggle("movement", "Click Teleport", CFG.Teleport, "On")
KeybindPicker("movement", "Teleport Key", CFG.Teleport, "Key")
Label("movement", "Hold key and click to teleport")
Section("movement", "quick actions")
Button("movement", "Reset Walk Speed", function(btn)
    CFG.Movement.Speed.On = false
    local hum = U.myHumanoid()
    if hum then hum.WalkSpeed = 16 end
    btn.Text = "Reset!"
    task.delay(1, function() btn.Text = "Reset Walk Speed" end)
end)
Button("movement", "Reset Jump Power", function(btn)
    CFG.Movement.HighJump.On = false
    local hum = U.myHumanoid()
    if hum then hum.JumpPower = 50 end
    btn.Text = "Reset!"
    task.delay(1, function() btn.Text = "Reset Jump Power" end)
end)
Button("movement", "Stop Fly", function(btn)
    disableFly()
    CFG.Movement.Fly.On = false
    btn.Text = "Stopped!"
    task.delay(1, function() btn.Text = "Stop Fly" end)
end)
Button("movement", "Stop Noclip", function(btn)
    disableNoclip()
    CFG.Movement.Noclip.On = false
    btn.Text = "Stopped!"
    task.delay(1, function() btn.Text = "Stop Noclip" end)
end)
Button("movement", "Stop All Movement Hacks", function(btn)
    disableFly()
    disableNoclip()
    CFG.Movement.Speed.On = false
    CFG.Movement.Fly.On = false
    CFG.Movement.Noclip.On = false
    CFG.Movement.InfJump.On = false
    CFG.Movement.HighJump.On = false
    CFG.Movement.LongJump.On = false
    local hum = U.myHumanoid()
    if hum then hum.WalkSpeed = 16; hum.JumpPower = 50 end
    btn.Text = "All Stopped!"
    Notify.send("Movement", "All movement hacks disabled", "info", 2)
    task.delay(1, function() btn.Text = "Stop All Movement Hacks" end)
end)
Section("movement", "info")
Label("movement", "Speed: modifies WalkSpeed each frame")
Label("movement", "Fly: BodyVelocity + BodyGyro system")
Label("movement", "WASD moves, Space/Ctrl for up/down")
Label("movement", "Noclip: disables collision every frame")
Label("movement", "Infinite Jump: forces Jumping state")
Label("movement", "High Jump: modifies JumpPower")
Label("movement", "Long Jump: adds forward velocity on jump")
Label("movement", "Click Teleport: teleport to mouse position")
Label("movement", "All keybinds can be customized above")

Section("players", "utilities")
Toggle("players", "Anti-AFK", CFG.Player.AntiAFK, "On", "Prevents idle kick")
Toggle("players", "Auto Respawn", CFG.Player.AutoRespawn, "On")
Slider("players", "Respawn Delay", CFG.Player.AutoRespawn, "Delay", 0.1, 5.0, 0.1, "s")
Section("players", "hitbox expand")
Toggle("players", "Enabled", CFG.Player.HitboxExpand, "On")
Slider("players", "Head Size", CFG.Player.HitboxExpand, "Size", 2, 25, 1, "")
Label("players", "Makes enemy head hitboxes larger")
Section("players", "world")
Toggle("players", "Full Bright", CFG.Player.FullBright, "On", "Removes all shadows/darkness")
Toggle("players", "No Fog", CFG.Player.NoFog, "On")
Toggle("players", "No Particles", CFG.Player.NoParticles, "On", "Removes particles for better FPS")
Button("players", "Remove Particles Now", function(btn)
    removeParticles()
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Remove Particles Now" end)
end)
Button("players", "Reset Hitboxes", function(btn)
    resetHitboxes()
    btn.Text = "Reset!"
    task.delay(1, function() btn.Text = "Reset Hitboxes" end)
end)
Section("players", "player actions")
Button("players", "Copy Player List", function(btn)
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        local info = p.DisplayName .. " (@" .. p.Name .. ")"
        if p ~= LP and U.alive(p) then
            info = info .. " [" .. math.floor(U.hp(p)) .. "hp]"
            info = info .. " " .. U.formatDist(U.distanceToPlayer(p))
        elseif p == LP then
            info = info .. " [YOU]"
        else
            info = info .. " [DEAD]"
        end
        table.insert(names, info)
    end
    local text = "Server Players (" .. #names .. "):\n" .. table.concat(names, "\n")
    if ENV.SetClipboard then
        pcall(setclipboard, text)
        btn.Text = "Copied!"
        Notify.send("Players", "Player list copied to clipboard", "success", 2)
    else
        btn.Text = "No clipboard"
    end
    task.delay(1, function() btn.Text = "Copy Player List" end)
end)
Button("players", "Show Nearest Player", function(btn)
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local d = U.distanceToPlayer(p)
            if d < bestDist then bestDist = d; best = p end
        end
    end
    if best then
        btn.Text = best.DisplayName
        Notify.send("Nearest", best.DisplayName .. " | " .. U.formatDist(bestDist) .. " | " .. math.floor(U.hp(best)) .. "hp", "info", 3)
    else
        btn.Text = "No players"
    end
    task.delay(1.5, function() btn.Text = "Show Nearest Player" end)
end)
Button("players", "Show Lowest HP Player", function(btn)
    local best, bestHP = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local h = U.hp(p)
            if h < bestHP then bestHP = h; best = p end
        end
    end
    if best then
        btn.Text = best.DisplayName
        Notify.send("Lowest HP", best.DisplayName .. " | " .. math.floor(bestHP) .. "hp | " .. U.formatDist(U.distanceToPlayer(best)), "info", 3)
    else
        btn.Text = "No players"
    end
    task.delay(1.5, function() btn.Text = "Show Lowest HP Player" end)
end)
Button("players", "Count Alive Players", function(btn)
    local alive, dead, total = 0, 0, 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            total = total + 1
            if U.alive(p) then alive = alive + 1 else dead = dead + 1 end
        end
    end
    btn.Text = alive .. " alive"
    Notify.send("Players", alive .. " alive | " .. dead .. " dead | " .. total .. " total (excl. you)", "info", 3)
    task.delay(1.5, function() btn.Text = "Count Alive Players" end)
end)
Section("players", "player info")
Label("players", "Anti-AFK: prevents idle kick (VirtualUser)")
Label("players", "Auto Respawn: loads character after death")
Label("players", "Hitbox Expand: enlarges enemy head size")
Label("players", "Works per-player, updates every 30 frames")
Label("players", "Full Bright: boosts ambient + brightness")
Label("players", "No Fog: removes distance fog effect")
Label("players", "No Particles: disables particle effects")
Label("players", "Helps FPS on low-end devices")

Section("world", "time of day")
Toggle("world", "Custom Time", CFG.World.TimeOfDay, "On")
Slider("world", "Hour", CFG.World.TimeOfDay, "Value", 0, 24, 0.5, "h")
Label("world", "Forces the in-game clock to a specific hour")
Button("world", "Set Noon", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 12
    WorldManip.setTimeOfDay(12)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Set Noon" end)
end)
Button("world", "Set Midnight", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 0
    WorldManip.setTimeOfDay(0)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Set Midnight" end)
end)
Button("world", "Set Dawn (6AM)", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 6
    WorldManip.setTimeOfDay(6)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Set Dawn (6AM)" end)
end)
Button("world", "Set Dusk (18PM)", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 18
    WorldManip.setTimeOfDay(18)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Set Dusk (18PM)" end)
end)
Section("world", "gravity")
Toggle("world", "Custom Gravity", CFG.World.CustomGravity, "On")
Slider("world", "Gravity Value", CFG.World.CustomGravity, "Value", 0, 500, 5, "")
Label("world", "Default gravity is 196.2")
Button("world", "Zero Gravity", function(btn)
    CFG.World.CustomGravity.On = true
    CFG.World.CustomGravity.Value = 0
    workspace.Gravity = 0
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Zero Gravity" end)
end)
Button("world", "Moon Gravity", function(btn)
    CFG.World.CustomGravity.On = true
    CFG.World.CustomGravity.Value = 32.7
    workspace.Gravity = 32.7
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Moon Gravity" end)
end)
Button("world", "Mars Gravity", function(btn)
    CFG.World.CustomGravity.On = true
    CFG.World.CustomGravity.Value = 73.5
    workspace.Gravity = 73.5
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Mars Gravity" end)
end)
Button("world", "Default Gravity", function(btn)
    CFG.World.CustomGravity.On = false
    workspace.Gravity = 196.2
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Default Gravity" end)
end)
Section("world", "atmosphere")
Toggle("world", "Custom Atmosphere", CFG.World.Atmosphere, "On")
Slider("world", "Density", CFG.World.Atmosphere, "Density", 0, 1, 0.05, "")
Slider("world", "Haze", CFG.World.Atmosphere, "Haze", 0, 10, 0.5, "")
Label("world", "Modifies the Atmosphere effect in Lighting")
Section("world", "cleanup")
Toggle("world", "Remove Shadows", CFG.World.RemoveShadows, "On")
Toggle("world", "Remove Water Effects", CFG.World.RemoveWater, "On")
Toggle("world", "Remove Clutter", CFG.World.NoClutter, "On", "Removes decals and textures")
Button("world", "Remove All Decals", function(btn)
    WorldManip.removeClutter()
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Remove All Decals" end)
end)
Button("world", "Remove Shadows Now", function(btn)
    WorldManip.removeShadows()
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Remove Shadows Now" end)
end)
Button("world", "Clean Water Now", function(btn)
    WorldManip.removeWater()
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "Clean Water Now" end)
end)
Separator("world")
Label("world", "These settings are applied every ~2 seconds")
Section("world", "quick presets")
Button("world", "Bright & Clear", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 14
    CFG.World.Atmosphere.On = true
    CFG.World.Atmosphere.Density = 0
    CFG.World.Atmosphere.Haze = 0
    CFG.World.RemoveShadows.On = true
    CFG.Player.FullBright.On = true
    CFG.Player.NoFog.On = true
    WorldManip.applySettings()
    enableFullBright()
    enableNoFog()
    btn.Text = "Applied!"
    Notify.send("World", "Bright & Clear preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Bright & Clear" end)
end)
Button("world", "Dark & Moody", function(btn)
    CFG.World.TimeOfDay.On = true
    CFG.World.TimeOfDay.Value = 0
    CFG.World.Atmosphere.On = true
    CFG.World.Atmosphere.Density = 0.3
    CFG.World.Atmosphere.Haze = 2
    CFG.Player.FullBright.On = false
    disableFullBright()
    WorldManip.applySettings()
    btn.Text = "Applied!"
    Notify.send("World", "Dark & Moody preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Dark & Moody" end)
end)
Button("world", "Performance Mode", function(btn)
    CFG.World.RemoveShadows.On = true
    CFG.World.NoClutter.On = true
    CFG.World.RemoveWater.On = true
    CFG.World.Atmosphere.On = true
    CFG.World.Atmosphere.Density = 0
    CFG.World.Atmosphere.Haze = 0
    CFG.Player.NoParticles.On = true
    WorldManip.applySettings()
    WorldManip.removeClutter()
    removeParticles()
    btn.Text = "Applied!"
    Notify.send("World", "Performance mode enabled", "success", 2)
    task.delay(1, function() btn.Text = "Performance Mode" end)
end)
Button("world", "Reset All World Settings", function(btn)
    CFG.World.TimeOfDay.On = false
    CFG.World.CustomGravity.On = false
    CFG.World.Atmosphere.On = false
    CFG.World.RemoveShadows.On = false
    CFG.World.RemoveWater.On = false
    CFG.World.NoClutter.On = false
    CFG.Player.FullBright.On = false
    CFG.Player.NoFog.On = false
    CFG.Player.NoParticles.On = false
    disableFullBright()
    disableNoFog()
    workspace.Gravity = 196.2
    pcall(function() Lighting.GlobalShadows = true end)
    btn.Text = "Reset!"
    Notify.send("World", "All world settings reset", "info", 2)
    task.delay(1, function() btn.Text = "Reset All World Settings" end)
end)
Section("world", "world info")
Label("world", "Time: controls Lighting.ClockTime")
Label("world", "Gravity: controls workspace.Gravity")
Label("world", "Default gravity: 196.2 studs/s^2")
Label("world", "Moon gravity: ~32.7 studs/s^2")
Label("world", "Mars gravity: ~73.5 studs/s^2")
Label("world", "Atmosphere affects fog density and haze")
Label("world", "Remove Shadows: disables GlobalShadows")
Label("world", "Remove Water: makes terrain water invisible")
Label("world", "Remove Clutter: makes decals transparent")
Label("world", "Combine with Full Bright for max visibility")
Label("world", "Performance Mode removes all visual clutter")
Label("world", "Useful for competitive or low-end devices")

Section("radar", "minimap")
Toggle("radar", "Enabled", CFG.Radar, "On")
Slider("radar", "Size", CFG.Radar, "Size", 80, 300, 10, "px")
Slider("radar", "Zoom", CFG.Radar, "Zoom", 0.5, 5.0, 0.25, "x")
Slider("radar", "Opacity", CFG.Radar, "Alpha", 0.3, 1.0, 0.05, "")
Toggle("radar", "Show Team Players", CFG.Radar, "ShowTeam")
Toggle("radar", "Show Names", CFG.Radar, "ShowNames")
Toggle("radar", "Direction Indicators", CFG.Radar, "PingDots")
Toggle("radar", "Cardinal Markers", CFG.Radar, "CardinalMarkers")
Toggle("radar", "Rotate With Camera", CFG.Radar, "RotateWithCamera")
Toggle("radar", "Crosshair Lines", CFG.Radar, "CrosshairLines")
Section("radar", "appearance")
Slider("radar", "Dot Size", CFG.Radar, "DotSize", 1, 8, 1, "px")
Slider("radar", "Max Distance", CFG.Radar, "MaxDist", 100, 2000, 50, "st")
Dropdown("radar", "Position", CFG.Radar, "Position", {"TopRight", "TopLeft", "BottomLeft", "BottomRight"})
ColorPick("radar", "Border Color", CFG.Radar, "BorderColor")
ColorPick("radar", "Enemy Dot", CFG.Radar, "EnemyDot")
ColorPick("radar", "Team Dot", CFG.Radar, "TeamDot")
ColorPick("radar", "Background", CFG.Radar, "BackgroundColor")
Section("radar", "radar presets")
Button("radar", "Close Range (PvP)", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Zoom = 1.0
    CFG.Radar.MaxDist = 200
    CFG.Radar.Size = 140
    CFG.Radar.DotSize = 4
    CFG.Radar.CrosshairLines = true
    CFG.Radar.ShowNames = false
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Close Range (PvP)" end)
end)
Button("radar", "Wide View (Exploration)", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Zoom = 3.5
    CFG.Radar.MaxDist = 1500
    CFG.Radar.Size = 200
    CFG.Radar.DotSize = 3
    CFG.Radar.CrosshairLines = false
    CFG.Radar.ShowNames = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Wide View (Exploration)" end)
end)
Button("radar", "Max Range Scout", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Zoom = 5.0
    CFG.Radar.MaxDist = 2000
    CFG.Radar.Size = 250
    CFG.Radar.DotSize = 2
    CFG.Radar.CrosshairLines = true
    CFG.Radar.ShowNames = true
    CFG.Radar.PingDots = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Max Range Scout" end)
end)
Button("radar", "Minimal HUD", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Zoom = 2.0
    CFG.Radar.MaxDist = 500
    CFG.Radar.Size = 100
    CFG.Radar.DotSize = 3
    CFG.Radar.CrosshairLines = false
    CFG.Radar.ShowNames = false
    CFG.Radar.CardinalMarkers = false
    CFG.Radar.Alpha = 0.5
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Minimal HUD" end)
end)
Separator("radar")
Section("radar", "radar info")
Label("radar", "Radar displays nearby players on a 2D minimap")
Label("radar", "Dots show player positions relative to you")
Label("radar", "Red dots = enemies | Blue dots = teammates")
Label("radar", "Center dot = your position and facing direction")
Label("radar", "Use Rotate With Camera for FPS-style rotation")
Label("radar", "Cardinal markers show N/S/E/W directions")
Label("radar", "Crosshair lines divide radar into quadrants")
Label("radar", "Zoom controls the map scale (lower = wider)")
Label("radar", "Max Distance filters out far-away players")
Label("radar", "Direction Indicators show player facing angles")
Separator("radar")
Label("radar", "Tip: Use Close Range preset for PvP combat")
Label("radar", "Tip: Use Wide View for exploring large maps")
Label("radar", "Tip: Minimal HUD keeps radar subtle on screen")

Section("misc", "freecam")
Toggle("misc", "Enable Freecam", CFG.Freecam, "On")
Slider("misc", "Freecam Speed", CFG.Freecam, "Speed", 0.1, 5, 0.1, "x")
Slider("misc", "Mouse Sensitivity", CFG.Freecam, "Sensitivity", 0.05, 1, 0.05, "")
Toggle("misc", "Show Cursor", CFG.Freecam, "ShowCursor")
KeybindPicker("misc", "Freecam Key", CFG.Freecam, "Key")
Label("misc", "Press key to toggle freecam mode")
Label("misc", "WASD to move, Space/Ctrl for up/down")
Label("misc", "Hold Shift for faster movement")
Section("misc", "spectate")
Toggle("misc", "Enable Spectate", CFG.Spectate, "On")
KeybindPicker("misc", "Spectate Key", CFG.Spectate, "Key")
Toggle("misc", "Auto Cycle", CFG.Spectate, "AutoCycle")
Slider("misc", "Cycle Time", CFG.Spectate, "CycleTime", 2, 30, 1, "s")
Label("misc", "Press key to toggle spectate mode")
Label("misc", "Q = Previous player | E = Next player")
Button("misc", "Next Player", function(btn)
    if Spectate.active then
        Spectate.next()
        if Spectate.target then
            btn.Text = Spectate.target.DisplayName
            task.delay(1, function() btn.Text = "Next Player" end)
        end
    else
        btn.Text = "Not active"
        task.delay(1, function() btn.Text = "Next Player" end)
    end
end)
Button("misc", "Stop Spectating", function(btn)
    Spectate.disable()
    CFG.Spectate.On = false
    btn.Text = "Stopped!"
    task.delay(1, function() btn.Text = "Stop Spectating" end)
end)
Section("misc", "target info panel")
Toggle("misc", "Show Target Info", CFG.TargetInfo, "On")
Toggle("misc", "Show Health Bar", CFG.TargetInfo, "ShowHealth")
Toggle("misc", "Show Weapon", CFG.TargetInfo, "ShowWeapon")
Toggle("misc", "Show Distance", CFG.TargetInfo, "ShowDistance")
Toggle("misc", "Show Speed", CFG.TargetInfo, "ShowSpeed")
Toggle("misc", "Show Flags", CFG.TargetInfo, "ShowFlags")
Dropdown("misc", "Panel Position", CFG.TargetInfo, "Position", {"Left", "Right", "Bottom"})
Section("misc", "kill feed")
Toggle("misc", "Kill Feed", CFG.KillFeed, "On")
Slider("misc", "Max Entries", CFG.KillFeed, "MaxEntries", 3, 15, 1, "")
Slider("misc", "Duration", CFG.KillFeed, "Duration", 2, 15, 1, "s")
Toggle("misc", "Show Timestamp", CFG.KillFeed, "ShowTimestamp")
Dropdown("misc", "Feed Position", CFG.KillFeed, "Position", {"TopRight", "TopLeft"})
Section("misc", "player list")
Toggle("misc", "Player List (Hold Key)", CFG.PlayerList, "On")
KeybindPicker("misc", "Player List Key", CFG.PlayerList, "Key")
Toggle("misc", "Show Health", CFG.PlayerList, "ShowHealth")
Toggle("misc", "Show Distance", CFG.PlayerList, "ShowDistance")
Toggle("misc", "Show Weapons", CFG.PlayerList, "ShowWeapon")
Slider("misc", "Max Visible", CFG.PlayerList, "MaxVisible", 4, 20, 1, "")
Dropdown("misc", "Sort By", CFG.PlayerList, "SortBy", {"Distance", "Health", "Name"})
Section("misc", "chat commands")
Toggle("misc", "Chat Commands", CFG.ChatCommands, "On")
Label("misc", "Type commands in chat with prefix")
Label("misc", "Default prefix: ! (e.g. !speed 50)")
Label("misc", "Commands: speed, fly, noclip, tp, goto,")
Label("misc", "spectate, unspec, gravity, jump, fov,")
Label("misc", "time, reset, rejoin, serverhop, esp,")
Label("misc", "chams, aimbot, silent, save, load,")
Label("misc", "help, players, destroy")
Button("misc", "Show All Commands", function(btn)
    local cmds = {}
    for name, data in pairs(ChatCmds.commands) do
        table.insert(cmds, CFG.ChatCommands.Prefix .. name .. " - " .. data.desc)
    end
    table.sort(cmds)
    Notify.send("Commands", table.concat(cmds, "\n"), "info", 8)
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Show All Commands" end)
end)
Section("misc", "teleport tools")
Button("misc", "Teleport to Random Player", function(btn)
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then table.insert(targets, p) end
    end
    if #targets == 0 then
        btn.Text = "No players!"
        task.delay(1, function() btn.Text = "Teleport to Random Player" end)
        return
    end
    local target = targets[math.random(1, #targets)]
    local ch = target.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    local myRoot = U.myRoot()
    if rp and myRoot then
        myRoot.CFrame = rp.CFrame * CFrame.new(0, 0, 5)
        btn.Text = target.DisplayName
        Notify.send("Teleport", "Teleported to " .. target.DisplayName, "success", 2)
        task.delay(1, function() btn.Text = "Teleport to Random Player" end)
    end
end)
Button("misc", "Teleport to Closest Enemy", function(btn)
    local best, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) and not U.team(p) then
            local d = U.distanceToPlayer(p)
            if d < bestDist then bestDist = d; best = p end
        end
    end
    if not best then
        btn.Text = "No enemies!"
        task.delay(1, function() btn.Text = "Teleport to Closest Enemy" end)
        return
    end
    local ch = best.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    local myRoot = U.myRoot()
    if rp and myRoot then
        myRoot.CFrame = rp.CFrame * CFrame.new(0, 0, 5)
        btn.Text = best.DisplayName
        Notify.send("Teleport", "Teleported to " .. best.DisplayName, "success", 2)
        task.delay(1, function() btn.Text = "Teleport to Closest Enemy" end)
    end
end)
Button("misc", "Teleport to Spawn", function(btn)
    local myRoot = U.myRoot()
    if myRoot then
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            myRoot.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 5, 0))
            btn.Text = "Done!"
        else
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("SpawnLocation") then
                    myRoot.CFrame = CFrame.new(v.Position + Vector3.new(0, 5, 0))
                    btn.Text = "Done!"
                    break
                end
            end
        end
        task.delay(1, function() btn.Text = "Teleport to Spawn" end)
    end
end)
Button("misc", "Bring All (Risky)", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then return end
    local brought = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local ch = p.Character
            local rp = ch and ch:FindFirstChild("HumanoidRootPart")
            if rp then
                pcall(function()
                    rp.CFrame = myRoot.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end)
                brought = brought + 1
            end
        end
    end
    btn.Text = brought .. " brought"
    Notify.send("Bring", "Brought " .. brought .. " players", "warning", 2)
    task.delay(1, function() btn.Text = "Bring All (Risky)" end)
end)
Separator("misc")
Section("misc", "server info")
Button("misc", "Show Server Info", function(btn)
    local info = {}
    table.insert(info, "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
    table.insert(info, "PlaceId: " .. game.PlaceId)
    table.insert(info, "JobId: " .. string.sub(game.JobId, 1, 8) .. "...")
    pcall(function()
        table.insert(info, "Server Age: " .. math.floor(workspace.DistributedGameTime / 60) .. " min")
    end)
    pcall(function()
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        table.insert(info, "Ping: " .. ping .. "ms")
    end)
    Notify.send("Server Info", table.concat(info, "\n"), "info", 6)
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Show Server Info" end)
end)
Button("misc", "Copy Server Link", function(btn)
    if ENV.SetClipboard then
        local link = "roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
        pcall(setclipboard, link)
        btn.Text = "Copied!"
        Notify.send("Server", "Link copied to clipboard", "success", 2)
    else
        btn.Text = "No clipboard"
    end
    task.delay(1, function() btn.Text = "Copy Server Link" end)
end)
Button("misc", "Rejoin Server", function(btn)
    btn.Text = "Rejoining..."
    Notify.send("Server", "Rejoining server...", "warning", 2)
    task.delay(1, function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
        end)
    end)
end)
Button("misc", "Server Hop", function(btn)
    btn.Text = "Finding..."
    Notify.send("Server", "Finding new server...", "warning", 2)
    task.delay(0.5, function()
        pcall(function()
            local ts = game:GetService("TeleportService")
            local servers = HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=10")
            )
            if servers and servers.data then
                for _, s in ipairs(servers.data) do
                    if s.id ~= game.JobId then
                        ts:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                        return
                    end
                end
            end
            ts:Teleport(game.PlaceId, LP)
        end)
    end)
end)

Section("settings", "menu")
Slider("settings", "Scale", CFG.GUI, "Scale", 0.6, 1.5, 0.05, "x")
Slider("settings", "Opacity", CFG.GUI, "Opacity", 0.5, 1.0, 0.01, "")
Slider("settings", "Animation Speed", CFG.GUI, "AnimSpeed", 0.05, 0.5, 0.01, "s")
Toggle("settings", "Blur Background", CFG.GUI, "BlurBackground")
Toggle("settings", "Notifications", CFG.GUI, "Notifications")
Slider("settings", "Notif Duration", CFG.GUI, "NotifDuration", 1, 10, 0.5, "s")
KeybindPicker("settings", "Menu Key", CFG.GUI, "MenuKey")
ColorPick("settings", "Accent", CFG.GUI, "Accent")
ColorPick("settings", "Accent Alt", CFG.GUI, "AccentAlt")

Section("settings", "config")

local function flashBtn(btn, ok, origText, origColor)
    btn.Text = ok and "Done!" or "Failed!"
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = ok and TH.Success or TH.Error}):Play()
    task.delay(1.2, function()
        btn.Text = origText
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor}):Play()
    end)
end

ButtonPair("settings", "Save Config", function(btn)
    local ok, err = ConfigManager.save(CURRENT_PROFILE)
    flashBtn(btn, ok, "Save Config", TH.Accent)
    if ok then
        Notify.send("Config", "Saved profile: " .. CURRENT_PROFILE, "success")
    else
        Notify.send("Config", "Save failed: " .. tostring(err), "error")
    end
end, "Load Config", function(btn)
    local ok, err = ConfigManager.load(CURRENT_PROFILE)
    flashBtn(btn, ok, "Load Config", TH.Off)
    if ok then
        Notify.send("Config", "Loaded profile: " .. CURRENT_PROFILE, "success")
    else
        Notify.send("Config", "Load failed: " .. tostring(err), "error")
    end
end)

ButtonPair("settings", "Reset to Default", function(btn)
    ConfigManager.reset()
    flashBtn(btn, true, "Reset to Default", TH.Accent)
    Notify.send("Config", "Reset to defaults", "info")
end, "Copy Config String", function(btn)
    local str = ConfigManager.exportString()
    if ENV.SetClipboard then
        pcall(setclipboard, str)
        flashBtn(btn, true, "Copy Config String", TH.Off)
        Notify.send("Config", "Config copied to clipboard", "success")
    else
        flashBtn(btn, false, "Copy Config String", TH.Off)
        Notify.send("Config", "Clipboard not available", "error")
    end
end)

Section("settings", "profiles")
Label("settings", "Save different configs with unique names")

do
    local profileNameStore = {name = CURRENT_PROFILE}
    TextInput("settings", "Profile Name", profileNameStore, "name")

    ButtonPair("settings", "Save Profile", function(btn)
        local name = profileNameStore.name
        if name == "" then name = "default" end
        local ok, err = ConfigManager.save(name)
        flashBtn(btn, ok, "Save Profile", TH.Accent)
        if ok then Notify.send("Config", "Saved: " .. name, "success") end
    end, "Load Profile", function(btn)
        local name = profileNameStore.name
        if name == "" then name = "default" end
        local ok, err = ConfigManager.load(name)
        flashBtn(btn, ok, "Load Profile", TH.Off)
        if ok then Notify.send("Config", "Loaded: " .. name, "success")
        else Notify.send("Config", "Not found: " .. name, "error") end
    end)

    Button("settings", "List Profiles", function(btn)
        local profiles = ConfigManager.listProfiles()
        if #profiles == 0 then
            Notify.send("Profiles", "No saved profiles found", "info")
        else
            Notify.send("Profiles", table.concat(profiles, ", "), "info", 5)
        end
    end)

    Button("settings", "Delete Current Profile", function(btn)
        local ok = ConfigManager.delete(CURRENT_PROFILE)
        flashBtn(btn, ok, "Delete Current Profile", TH.Accent)
        if ok then Notify.send("Config", "Deleted: " .. CURRENT_PROFILE, "warning") end
    end)
end

Section("settings", "import / export")
Label("settings", "Export your config as a string to share")
Button("settings", "Export to Clipboard", function(btn)
    local str = ConfigManager.exportString()
    if ENV.SetClipboard then
        pcall(setclipboard, str)
        btn.Text = "Exported!"
        Notify.send("Config", "Config exported to clipboard", "success", 2)
    else
        btn.Text = "No clipboard!"
        Notify.send("Config", "Clipboard not available", "error", 2)
    end
    task.delay(1.5, function() btn.Text = "Export to Clipboard" end)
end)
Label("settings", "Import: paste base64 or JSON config string")
do
    local importStore = {text = ""}
    TextInput("settings", "Paste Config String", importStore, "text")
    Button("settings", "Import Config", function(btn)
        if importStore.text == "" then
            btn.Text = "Empty!"
            task.delay(1, function() btn.Text = "Import Config" end)
            return
        end
        local ok, err = ConfigManager.importString(importStore.text)
        if ok then
            btn.Text = "Imported!"
            Notify.send("Config", "Config imported successfully", "success", 2)
        else
            btn.Text = "Failed!"
            Notify.send("Config", "Import failed: " .. tostring(err), "error", 3)
        end
        task.delay(1.5, function() btn.Text = "Import Config" end)
    end)
end
Section("settings", "auto save")
Label("settings", "Auto-save saves on every toggle change")
Button("settings", "Auto-Save Current Config", function(btn)
    local ok, err = ConfigManager.save("autosave")
    if ok then
        btn.Text = "Saved!"
        Notify.send("Config", "Auto-saved as 'autosave'", "success", 2)
    else
        btn.Text = "Failed!"
    end
    task.delay(1, function() btn.Text = "Auto-Save Current Config" end)
end)
Button("settings", "Load Auto-Save", function(btn)
    local ok, err = ConfigManager.load("autosave")
    if ok then
        btn.Text = "Loaded!"
        Notify.send("Config", "Auto-save loaded", "success", 2)
    else
        btn.Text = "Not found!"
        Notify.send("Config", "No auto-save found", "error", 2)
    end
    task.delay(1, function() btn.Text = "Load Auto-Save" end)
end)
Section("settings", "info")
Label("settings", "Lunarix v3.2 | Universal Executor Script")
Label("settings", "Developed by f07ant")
Label("settings", "Press RCtrl (default) to toggle menu")
Label("settings", "")
Label("settings", "Supports: Synapse, Fluxus, Delta,")
Label("settings", "Solara, KRNL, Script-Ware, and more")
Label("settings", "")
Label("settings", "Features: Aimbot, Silent Aim, ESP,")
Label("settings", "Chams, Crosshair, FOV Changer, Radar,")
Label("settings", "Movement, Freecam, Spectate, World,")
Label("settings", "Chat Commands, Kill Feed, Target Info,")
Label("settings", "Player List, Config Profiles, and more")
Label("settings", "")
Label("settings", "Config files saved in /lunarix/ folder")
Label("settings", "Configs persist between sessions")
Separator("settings")
Section("settings", "keybinds reference")
Label("settings", "RCtrl - Toggle menu open/close")
Label("settings", "Aimbot key - Hold to aim assist")
Label("settings", "Freecam key - Toggle free camera")
Label("settings", "Spectate key - Toggle spectate mode")
Label("settings", "Q/E in spectate - Cycle players")
Label("settings", "WASD in freecam - Move camera")
Label("settings", "Space/Ctrl in freecam - Up/Down")
Label("settings", "Shift in freecam - Speed boost")
Label("settings", "Chat /help - List chat commands")
Separator("settings")
Section("settings", "version history")
Label("settings", "v3.2 - Full rewrite, 11 tabs, advanced")
Label("settings", "v3.1 - Rebrand to Lunarix, pink theme")
Label("settings", "v3.0 - Pro UI overhaul, per-part chams")
Label("settings", "v2.0 - Tab system, animations, save cfg")
Label("settings", "v1.0 - Initial universal executor script")
Separator("settings")
Section("settings", "credits & links")
Label("settings", "Script: Lunarix Universal v3.2")
Label("settings", "Author: f07ant")
Label("settings", "Framework: Custom Luau UI Engine")
Label("settings", "Drawing: Object Pooling System")
Label("settings", "Config: JSON Serializer + Base64")
Label("settings", "Targeting: Multi-method hook engine")
Label("settings", "ESP: Frame-budgeted renderer (6ms)")
Label("settings", "Chams: Per-part Neon glow system")
Separator("settings")
Section("settings", "environment")
do
    local envInfo = {}
    table.insert(envInfo, "Drawing API: " .. (ENV.Drawing and "Yes" or "No"))
    table.insert(envInfo, "Hook Method: " .. (ENV.Hook or "None"))
    table.insert(envInfo, "Namecall: " .. (ENV.Namecall and "Yes" or "No"))
    table.insert(envInfo, "CClosure: " .. (ENV.CClosure and "Yes" or "No"))
    table.insert(envInfo, "CoreGui: " .. (ENV.CoreGui and "Yes" or "No"))
    table.insert(envInfo, "GetHUI: " .. (ENV.GetHUI and "Yes" or "No"))
    table.insert(envInfo, "ProtectGui: " .. (ENV.ProtectGui and "Yes" or "No"))
    table.insert(envInfo, "RawMetatable: " .. (ENV.RawMT and "Yes" or "No"))
    table.insert(envInfo, "File System: " .. (ENV.WriteFile and "Yes" or "No"))
    table.insert(envInfo, "Clipboard: " .. (ENV.SetClipboard and "Yes" or "No"))
    table.insert(envInfo, "Base64/Crypt: " .. (ENV.Crypt and "Yes" or "No"))
    for _, info in ipairs(envInfo) do
        Label("settings", info)
    end
end

Button("settings", "Destroy Script", function()
    Notify.send("Lunarix", "Destroying script...", "warning")
    task.delay(1, function()
        disableFly()
        disableNoclip()
        disableFullBright()
        disableNoFog()
        resetHitboxes()
        Freecam.disable()
        Spectate.disable()
        for _, p in ipairs(Players:GetPlayers()) do killChams(p) end
        if ENV.Drawing then
            Draw.Lines:destroy(); Draw.Texts:destroy(); Draw.Circles:destroy(); Draw.Quads:destroy(); Draw.Triangles:destroy()
            pcall(function() Draw.AimbotFOV:Remove() end)
            pcall(function() Draw.SilentFOV:Remove() end)
            for _, ln in ipairs(Draw.CrossLines) do pcall(function() ln:Remove() end) end
            pcall(function() Draw.CrossDot:Remove() end)
            pcall(function() Draw.WmBG:Remove() end)
            pcall(function() Draw.WmBorder:Remove() end)
            pcall(function() Draw.WmAccent:Remove() end)
            pcall(function() Draw.WmText:Remove() end)
        end
        if blur then pcall(function() blur:Destroy() end) end
        pcall(function() SG:Destroy() end)
    end)
end)

switchTab("aimbot")

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CFG.GUI.MenuKey then
        menuOpen = not menuOpen
        closeActiveDropdown()
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

pcall(function()
    if ENV.ReadFile and ENV.IsFile then
        local path = ConfigManager.filePath("default")
        if isfile(path) then
            ConfigManager.load("default")
        end
    end
end)

task.delay(1, function()
    Notify.send("Lunarix", "Loaded successfully | RCtrl to open", "success", 4)
end)

print("[Lunarix v3.2] Loaded | RCtrl to open")
print("[Lunarix v3.2] Features: 11 tabs | Config profiles | 20+ chat commands")
print("[Lunarix v3.2] Type /help in chat for command list")
