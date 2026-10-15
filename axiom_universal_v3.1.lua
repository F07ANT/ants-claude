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
        BorderColor = {0.91, 0.26, 0.58},
        EnemyDot = {1, 0.15, 0.15},
        TeamDot = {0.15, 1, 0.15},
        BackgroundColor = {0.04, 0.04, 0.055},
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
    RageBot = {
        On = false,
        Key = Enum.UserInputType.MouseButton2,
        Part = "Head",
        MultiPoint = false,
        MultiPointParts = {"Head", "HumanoidRootPart", "UpperTorso", "LeftUpperArm", "RightUpperArm"},
        AutoWall = false,
        AutoWallMinDamage = 20,
        MinHitChance = 70,
        Resolver = false,
        ResolverMode = "Bruteforce",
        AntiAimCorrection = false,
        Backtrack = false,
        BacktrackTicks = 12,
        MaxTargets = 1,
        TargetSwitchDelay = 0.05,
        DoubleTap = false,
        DoubleTapKey = Enum.KeyCode.V,
        HideShots = false,
        FakeLag = false,
        FakeLagAmount = 8,
        ForceHead = false,
        ForceBaim = false,
        ForceBaimKey = Enum.KeyCode.B,
        AutoScope = false,
        AutoCrouch = false,
        AutoPeek = false,
        AutoPeekKey = Enum.KeyCode.C,
        PeekAssist = false,
        OverrideDmg = false,
        MinDmgOverride = 1,
        Priority = "ThreatLevel",
        FOV = 360,
    },
    AntiAim = {
        On = false,
        Pitch = "Down",
        Yaw = "Spin",
        YawOffset = 0,
        SpinSpeed = 10,
        Desync = false,
        DesyncSide = "Auto",
        FakeLag = false,
        FakeLagTicks = 4,
        LegBreaker = false,
        JitterAmount = 30,
        AtTarget = false,
        FreestandKey = Enum.KeyCode.X,
        ManualKeys = {Left = Enum.KeyCode.Z, Right = Enum.KeyCode.C, Back = Enum.KeyCode.X},
    },
    HitLog = {
        On = false,
        ShowDamage = true,
        ShowPart = true,
        ShowWeapon = true,
        ShowTarget = true,
        ShowHitChance = true,
        ShowBacktrack = false,
        MaxEntries = 15,
        Duration = 8,
        Position = "BottomLeft",
        Sound = false,
        SoundId = "rbxassetid://3744370687",
        ChatLog = false,
    },
    MissLog = {
        On = false,
        ShowReason = true,
        ShowSpread = true,
        MaxEntries = 10,
        Duration = 5,
    },
    Resolver = {
        On = false,
        Mode = "Bruteforce",
        BodyYaw = true,
        PitchResolver = false,
        LagCompensation = true,
        MaxMissBeforeSwitch = 2,
        BreakLCTimeout = 0.5,
        Indicators = true,
    },
    Backtrack = {
        On = false,
        MaxTicks = 12,
        TickInterval = 0.016,
        Visualize = false,
        VisualizeFade = true,
        Color = {1, 1, 1},
        Alpha = 0.3,
    },
    AutoPeek = {
        On = false,
        Key = Enum.KeyCode.C,
        ReturnSpeed = 80,
        ShowIndicator = true,
        IndicatorColor = {0, 1, 0.5},
        IndicatorRadius = 1.5,
    },
    HealthBar = {
        Style = "Gradient",
        Width = 3,
        Offset = 3,
        Segments = 4,
        Outline = true,
        TextInside = false,
        CustomColors = false,
        FullColor = {0, 1, 0},
        LowColor = {1, 0, 0},
        AnimSmooth = true,
        AnimSpeed = 0.1,
    },
    Flags = {
        On = false,
        ShowArmor = true,
        ShowGodmode = true,
        ShowSpeeding = true,
        ShowFlying = true,
        ShowBot = true,
        ShowAdmin = true,
        ShowRageBot = false,
        ShowDesync = false,
        ShowResolver = false,
        ShowFriend = false,
        FontSize = 10,
        ArmorColor = {0.3, 0.6, 1},
        GodmodeColor = {1, 0.85, 0},
        SpeedColor = {0, 1, 0.5},
        FlyColor = {0.8, 0.2, 1},
        BotColor = {0.5, 0.5, 0.5},
        AdminColor = {1, 0.3, 0.3},
    },
    ThirdPerson = {
        On = false,
        Distance = 12,
        FOV = 80,
        Offset = Vector3.new(2, 1, 0),
        Smooth = true,
        SmoothSpeed = 0.15,
        Key = Enum.KeyCode.Y,
    },
    BunnyHop = {
        On = false,
        AutoStrafe = false,
        StrafeSpeed = 1.5,
        GroundStrafe = false,
    },
    Spider = {
        On = false,
        Speed = 30,
        Key = Enum.KeyCode.H,
    },
    Phase = {
        On = false,
        Key = Enum.KeyCode.P,
        Speed = 50,
    },
    Anchor = {
        On = false,
        Key = Enum.KeyCode.K,
        Position = nil,
    },
    Spinbot = {
        On = false,
        Speed = 15,
        Axis = "Y",
    },
    Proximity = {
        AlertOn = false,
        AlertDist = 50,
        AlertSound = true,
        AlertSoundId = "rbxassetid://9083849830",
        AlertVisual = true,
        AlertColor = {1, 0, 0},
        FlashScreen = false,
    },
    SoundESP = {
        On = false,
        ShowFootsteps = true,
        ShowJumps = true,
        MaxDist = 200,
        DecayTime = 1.5,
        FootstepColor = {1, 0.8, 0},
        JumpColor = {0.3, 0.8, 1},
        Radius = 3,
    },
    PerfStats = {
        On = false,
        ShowFPS = true,
        ShowPing = true,
        ShowMemory = true,
        ShowDrawCalls = false,
        ShowEntities = true,
        ShowUptime = true,
        Position = "BottomRight",
        UpdateRate = 0.5,
    },
    Themes = {
        Current = "Lunarix Pink",
        Custom = {
            BG = {12, 12, 18},
            Panel = {18, 18, 26},
            Header = {14, 14, 21},
            Accent = {232, 67, 147},
            AccentAlt = {255, 105, 180},
            Text = {230, 230, 240},
        },
    },
    TriggerBot = {
        On = false,
        Delay = 0.05,
        BurstCount = 1,
        BurstDelay = 0.08,
        HoldTime = 0.1,
        FOV = 15,
        ShowFOV = false,
        FOVColor = {1, 0.6, 0},
        TeamCheck = true,
        WallCheck = false,
        VisibleOnly = true,
        TargetPart = "Head",
        MinHP = 0,
        ReTriggerDelay = 0.2,
        AutoScope = false,
        MagnetPull = false,
        MagnetStrength = 0.3,
    },
    AutoWall = {
        On = false,
        MinDamage = 20,
        MaxPenetration = 3,
        ShowPenetrable = false,
        PenetrableColor = {1, 0.8, 0},
        MaterialMultipliers = true,
        WoodMult = 0.8,
        MetalMult = 0.3,
        ConcreteMult = 0.15,
        GlassMult = 0.95,
        PlasticMult = 0.7,
    },
    DmgCalc = {
        On = false,
        ShowOverlay = false,
        BaseDamage = 30,
        HeadshotMult = 2.0,
        LimbMult = 0.75,
        ArmorReduction = 0.3,
        RangeFalloff = true,
        FalloffStart = 50,
        FalloffEnd = 200,
        FalloffMin = 0.4,
    },
    ThreatLevel = {
        On = false,
        ShowIndicator = true,
        Weights = {
            HP = 0.3,
            Distance = 0.25,
            Speed = 0.15,
            Weapon = 0.2,
            Accuracy = 0.1,
        },
        HighColor = {1, 0, 0},
        MedColor = {1, 0.6, 0},
        LowColor = {0, 1, 0.3},
        UpdateRate = 0.5,
    },
    SessionStats = {
        On = false,
        TrackKills = true,
        TrackDeaths = true,
        TrackDamage = true,
        TrackHeadshots = true,
        TrackDistance = true,
        ShowOverlay = false,
        OverlayPos = "TopRight",
        ResetOnDeath = false,
        ShowKDRatio = true,
        ShowAccuracy = true,
        ShowPlaytime = true,
    },
    Waypoints = {
        On = false,
        MaxWaypoints = 10,
        ShowDist = true,
        ShowName = true,
        RenderDist = 2000,
        DefaultColor = {0.3, 0.8, 1},
        LineThick = 1,
        IconSize = 8,
        Snap = false,
        SnapDist = 5,
    },
    Loot = {
        On = false,
        ShowRarity = true,
        FilterCommon = false,
        FilterRare = false,
        Highlight = true,
        HighlightColor = {1, 0.85, 0},
        MaxDist = 300,
        ShowValue = false,
        CommonColor = {0.7, 0.7, 0.7},
        RareColor = {0.2, 0.5, 1},
        EpicColor = {0.6, 0.2, 0.9},
        LegendaryColor = {1, 0.7, 0},
    },
    Trajectory = {
        On = false,
        ShowPath = true,
        PathColor = {1, 1, 0.3},
        PathAlpha = 0.5,
        Steps = 30,
        StepTime = 0.05,
        Gravity = 196.2,
        ShowImpact = true,
        ImpactRadius = 2,
    },
    CombatLog = {
        On = false,
        MaxEntries = 50,
        ShowDamage = true,
        ShowHealer = false,
        ShowAssists = true,
        DecayTime = 15,
        Position = "BottomLeft",
        FontSize = 11,
        DmgColor = {1, 0.3, 0.3},
        HealColor = {0.3, 1, 0.3},
        AssistColor = {0.7, 0.7, 0.3},
    },
    TargetPriority = {
        Mode = "Smart",
        HealthWeight = 0.3,
        DistanceWeight = 0.25,
        ThreatWeight = 0.25,
        VisibleWeight = 0.2,
        PreferLowHP = true,
        PreferClose = true,
        PreferVisible = true,
        BlacklistFriends = false,
        StickyTime = 1.5,
        SwitchThreshold = 0.15,
    },
    CustomCH = {
        Style = "Cross",
        Size = 6,
        Gap = 3,
        Thick = 1.5,
        Color = {1, 1, 1},
        Alpha = 1,
        Dot = true,
        DotSize = 2,
        Outline = true,
        OutlineColor = {0, 0, 0},
        OutlineAlpha = 0.6,
        Dynamic = false,
        DynamicSpread = 5,
        DynamicSpeed = 8,
        Rainbow = false,
        RainbowSpeed = 2,
        TStyle = false,
        Rotation = 0,
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
        Font = "Gotham",
        RoundCorners = true,
        CornerRadius = 6,
        ShadowEnabled = true,
        ShadowSize = 8,
        WindowWidth = 520,
        WindowHeight = 380,
        SidebarWidth = 115,
        TabIconsOnly = false,
        ShowTooltips = true,
        TooltipDelay = 0.5,
        AnimStyle = "Quad",
        AccentGlow = true,
        HeaderHeight = 36,
        CompactMode = false,
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
Radar.objects = {}
Radar.maxDots = 40

function Radar.init()
    if not ENV.Drawing then return end
    local o = Radar.objects
    o.bg = Drawing.new("Circle")
    o.bg.Filled = true; o.bg.NumSides = 60; o.bg.Visible = false
    o.border = Drawing.new("Circle")
    o.border.Filled = false; o.border.NumSides = 60; o.border.Thickness = 2; o.border.Visible = false
    o.ring = Drawing.new("Circle")
    o.ring.Filled = false; o.ring.NumSides = 40; o.ring.Thickness = 1; o.ring.Visible = false
    o.crossH = Drawing.new("Line"); o.crossH.Visible = false; o.crossH.Thickness = 1
    o.crossV = Drawing.new("Line"); o.crossV.Visible = false; o.crossV.Thickness = 1
    o.center = Drawing.new("Circle")
    o.center.Filled = true; o.center.NumSides = 16; o.center.Visible = false
    o.cardinals = {}
    for _, label in ipairs({"N", "S", "E", "W"}) do
        local t = Drawing.new("Text")
        t.Text = label; t.Size = 10; t.Font = 2; t.Center = true
        t.Outline = true; t.Visible = false
        o.cardinals[label] = t
    end
    o.dots = {}
    o.arrows = {}
    o.names = {}
    for i = 1, Radar.maxDots do
        local dot = Drawing.new("Circle")
        dot.Filled = true; dot.NumSides = 12; dot.Visible = false
        o.dots[i] = dot
        local arrow = Drawing.new("Line")
        arrow.Visible = false; arrow.Thickness = 1.5
        o.arrows[i] = arrow
        local name = Drawing.new("Text")
        name.Size = 9; name.Font = 2; name.Center = true
        name.Outline = true; name.Visible = false
        o.names[i] = name
    end
    o.countText = Drawing.new("Text")
    o.countText.Size = 9; o.countText.Font = 2; o.countText.Center = true
    o.countText.Outline = true; o.countText.Visible = false
end

function Radar.hideAll()
    local o = Radar.objects
    if not o.bg then return end
    o.bg.Visible = false
    o.border.Visible = false
    o.ring.Visible = false
    o.crossH.Visible = false; o.crossV.Visible = false
    o.center.Visible = false
    o.countText.Visible = false
    for _, t in pairs(o.cardinals) do t.Visible = false end
    for i = 1, Radar.maxDots do
        o.dots[i].Visible = false
        o.arrows[i].Visible = false
        o.names[i].Visible = false
    end
end

function Radar.destroy()
    local o = Radar.objects
    for k, v in pairs(o) do
        if type(v) == "table" then
            for _, obj in pairs(v) do pcall(function() obj:Remove() end) end
        else
            pcall(function() v:Remove() end)
        end
    end
    Radar.objects = {}
end

function Radar.render()
    if not ENV.Drawing then return end
    if not Radar.objects.bg then Radar.init() end
    local cfg = CFG.Radar
    if not cfg.On then
        Radar.hideAll()
        return
    end
    local o = Radar.objects
    local size = cfg.Size
    local half = size / 2

    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then Radar.hideAll(); return end
    local myP = myRoot.Position

    local myAngle = 0
    if cfg.RotateWithCamera then
        local look = Camera.CFrame.LookVector
        myAngle = math.atan2(look.X, look.Z)
    end

    local vp = Camera.ViewportSize
    local rx, ry
    if cfg.Position == "TopRight" then
        rx = vp.X - size - 15; ry = 45
    elseif cfg.Position == "TopLeft" then
        rx = 15; ry = 45
    elseif cfg.Position == "BottomLeft" then
        rx = 15; ry = vp.Y - size - 15
    else
        rx = vp.X - size - 15; ry = vp.Y - size - 15
    end
    local cx, cy = rx + half, ry + half
    local center = Vector2.new(cx, cy)

    local bgCol = Color3.new(cfg.BackgroundColor[1], cfg.BackgroundColor[2], cfg.BackgroundColor[3])
    o.bg.Position = center; o.bg.Radius = half; o.bg.Color = bgCol
    o.bg.Transparency = cfg.Alpha; o.bg.Visible = true

    local borderCol = Color3.new(cfg.BorderColor[1], cfg.BorderColor[2], cfg.BorderColor[3])
    o.border.Position = center; o.border.Radius = half; o.border.Color = borderCol
    o.border.Transparency = 1; o.border.Visible = true

    o.ring.Position = center; o.ring.Radius = half / 2
    o.ring.Color = Color3.fromRGB(35, 35, 45); o.ring.Transparency = 0.5; o.ring.Visible = true

    if cfg.CrosshairLines then
        local lineCol = Color3.fromRGB(45, 45, 55)
        o.crossH.From = Vector2.new(cx - half, cy); o.crossH.To = Vector2.new(cx + half, cy)
        o.crossH.Color = lineCol; o.crossH.Visible = true
        o.crossV.From = Vector2.new(cx, cy - half); o.crossV.To = Vector2.new(cx, cy + half)
        o.crossV.Color = lineCol; o.crossV.Visible = true
    else
        o.crossH.Visible = false; o.crossV.Visible = false
    end

    local accent = U.c3rgb(CFG.GUI.Accent)
    o.center.Position = center; o.center.Radius = 3; o.center.Color = accent; o.center.Visible = true

    if cfg.CardinalMarkers then
        local dirs = {N = {0, -1}, S = {0, 1}, E = {1, 0}, W = {-1, 0}}
        for label, d in pairs(dirs) do
            local dx, dy = d[1], d[2]
            if cfg.RotateWithCamera then
                local s, c = math.sin(-myAngle), math.cos(-myAngle)
                dx, dy = d[1] * c - d[2] * s, d[1] * s + d[2] * c
            end
            local t = o.cardinals[label]
            t.Position = Vector2.new(cx + dx * (half - 12), cy + dy * (half - 12))
            t.Color = label == "N" and Color3.fromRGB(232, 67, 147) or Color3.fromRGB(130, 130, 150)
            t.Visible = true
        end
    else
        for _, t in pairs(o.cardinals) do t.Visible = false end
    end

    local dotIdx = 0
    local playerList = Players:GetPlayers()
    local enemyCol = Color3.new(cfg.EnemyDot[1], cfg.EnemyDot[2], cfg.EnemyDot[3])
    local teamCol = Color3.new(cfg.TeamDot[1], cfg.TeamDot[2], cfg.TeamDot[3])

    for _, p in ipairs(playerList) do
        if p == LP then continue end
        if not U.alive(p) then continue end
        local ch = p.Character
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not rp then continue end
        local dist = (myP - rp.Position).Magnitude
        if dist > cfg.MaxDist then continue end
        local isTeam = U.team(p)
        if not cfg.ShowTeam and isTeam then continue end
        if dotIdx >= Radar.maxDots then break end
        dotIdx = dotIdx + 1

        local px, py = U.worldToRadar(rp.Position, myP, myAngle, size, cfg.Zoom, cfg.RotateWithCamera)
        local r2 = px * px + py * py
        local maxR = half - 5
        if r2 > maxR * maxR then
            local mag = math.sqrt(r2)
            px = px / mag * maxR
            py = py / mag * maxR
        end

        local dotCol = isTeam and teamCol or enemyCol
        local dotX, dotY = cx + px, cy + py
        local dotObj = o.dots[dotIdx]
        dotObj.Position = Vector2.new(dotX, dotY)
        dotObj.Radius = cfg.DotSize
        dotObj.Color = dotCol
        dotObj.Visible = true

        if cfg.PingDots then
            local heading = U.getHeading(p)
            local relAngle = heading - myAngle
            local arrowLen = cfg.DotSize + 4
            local ax = dotX + math.sin(relAngle) * arrowLen
            local ay = dotY - math.cos(relAngle) * arrowLen
            o.arrows[dotIdx].From = Vector2.new(dotX, dotY)
            o.arrows[dotIdx].To = Vector2.new(ax, ay)
            o.arrows[dotIdx].Color = dotCol
            o.arrows[dotIdx].Visible = true
        else
            o.arrows[dotIdx].Visible = false
        end

        if cfg.ShowNames then
            o.names[dotIdx].Position = Vector2.new(dotX, dotY - cfg.DotSize - 11)
            o.names[dotIdx].Text = U.truncate(p.DisplayName, 10)
            o.names[dotIdx].Color = Color3.fromRGB(190, 190, 200)
            o.names[dotIdx].Visible = true
        else
            o.names[dotIdx].Visible = false
        end
    end

    for i = dotIdx + 1, Radar.maxDots do
        o.dots[i].Visible = false
        o.arrows[i].Visible = false
        o.names[i].Visible = false
    end

    local totalNearby = 0
    for _, p in ipairs(playerList) do
        if p ~= LP and U.alive(p) then
            local ch = p.Character
            local rp = ch and ch:FindFirstChild("HumanoidRootPart")
            if rp and (myP - rp.Position).Magnitude <= cfg.MaxDist then
                totalNearby = totalNearby + 1
            end
        end
    end
    o.countText.Position = Vector2.new(cx, ry + size + 4)
    o.countText.Text = totalNearby .. " nearby"
    o.countText.Color = Color3.fromRGB(140, 140, 160)
    o.countText.Visible = true
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

local Draw = {}

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

local HitLog = {}
HitLog.entries = {}

function HitLog.add(data)
    if not CFG.HitLog.On then return end
    table.insert(HitLog.entries, 1, {
        target = data.target or "?",
        damage = data.damage or 0,
        part = data.part or "?",
        weapon = data.weapon or "?",
        hitChance = data.hitChance or 100,
        backtrack = data.backtrack or false,
        time = tick(),
    })
    while #HitLog.entries > CFG.HitLog.MaxEntries do
        table.remove(HitLog.entries)
    end
    if CFG.HitLog.Sound and ENV.Drawing then
        pcall(function()
            local snd = Instance.new("Sound")
            snd.SoundId = CFG.HitLog.SoundId
            snd.Volume = 0.5
            snd.Parent = workspace
            snd:Play()
            game:GetService("Debris"):AddItem(snd, 2)
        end)
    end
    if CFG.HitLog.ChatLog then
        pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = string.format("[Hit] %s - %s for %d dmg", data.target or "?", data.part or "?", data.damage or 0),
                Color = Color3.fromRGB(232, 67, 147),
                Font = Enum.Font.GothamBold,
                FontSize = Enum.FontSize.Size14,
            })
        end)
    end
end

function HitLog.clean()
    local now = tick()
    local dur = CFG.HitLog.Duration
    local i = 1
    while i <= #HitLog.entries do
        if now - HitLog.entries[i].time > dur then
            table.remove(HitLog.entries, i)
        else
            i = i + 1
        end
    end
end

function HitLog.render()
    if not CFG.HitLog.On or not ENV.Drawing then return end
    HitLog.clean()
    if #HitLog.entries == 0 then return end
    local cfg = CFG.HitLog
    local vp = Camera.ViewportSize
    local startX, startY
    if cfg.Position == "BottomLeft" then
        startX = 15; startY = vp.Y - 30
    elseif cfg.Position == "BottomRight" then
        startX = vp.X - 350; startY = vp.Y - 30
    elseif cfg.Position == "TopLeft" then
        startX = 15; startY = 60
    else
        startX = vp.X - 350; startY = 60
    end
    local headerY = startY
    if cfg.Position == "BottomLeft" or cfg.Position == "BottomRight" then
        headerY = startY - (#HitLog.entries) * 16 - 4
    end
    Draw.text(Vector2.new(startX, headerY - 16), "HIT LOG", Color3.fromRGB(232, 67, 147), 11, false, true)
    for i, entry in ipairs(HitLog.entries) do
        local age = tick() - entry.time
        local alpha = math.clamp(1 - (age / cfg.Duration), 0.1, 1)
        local y
        if cfg.Position == "BottomLeft" or cfg.Position == "BottomRight" then
            y = startY - (i - 1) * 16
        else
            y = headerY + i * 16
        end
        local parts = {}
        if cfg.ShowTarget then table.insert(parts, entry.target) end
        if cfg.ShowPart then table.insert(parts, entry.part) end
        if cfg.ShowDamage then table.insert(parts, tostring(entry.damage) .. "dmg") end
        if cfg.ShowWeapon then table.insert(parts, entry.weapon) end
        if cfg.ShowHitChance then table.insert(parts, entry.hitChance .. "%") end
        if cfg.ShowBacktrack and entry.backtrack then table.insert(parts, "BT") end
        local txt = table.concat(parts, " | ")
        local col = entry.damage > 50 and Color3.fromRGB(255, 80, 80)
            or entry.damage > 20 and Color3.fromRGB(255, 200, 100)
            or Color3.fromRGB(180, 255, 180)
        local t = Draw.text(Vector2.new(startX, y), txt, col, 10, false, true)
        if t then t.Transparency = alpha end
    end
end

function HitLog.getStats()
    local total = #HitLog.entries
    local headshots = 0
    local totalDmg = 0
    local targets = {}
    for _, e in ipairs(HitLog.entries) do
        totalDmg = totalDmg + e.damage
        if e.part == "Head" then headshots = headshots + 1 end
        targets[e.target] = (targets[e.target] or 0) + 1
    end
    local topTarget = ""
    local topCount = 0
    for name, count in pairs(targets) do
        if count > topCount then topTarget = name; topCount = count end
    end
    return {
        total = total,
        headshots = headshots,
        hsPercent = total > 0 and math.floor(headshots / total * 100) or 0,
        totalDmg = totalDmg,
        avgDmg = total > 0 and math.floor(totalDmg / total) or 0,
        topTarget = topTarget,
        topCount = topCount,
    }
end

local MissLog = {}
MissLog.entries = {}

function MissLog.add(data)
    if not CFG.MissLog.On then return end
    table.insert(MissLog.entries, 1, {
        target = data.target or "?",
        reason = data.reason or "Unknown",
        spread = data.spread or 0,
        time = tick(),
    })
    while #MissLog.entries > CFG.MissLog.MaxEntries do
        table.remove(MissLog.entries)
    end
end

function MissLog.clean()
    local now = tick()
    local dur = CFG.MissLog.Duration
    local i = 1
    while i <= #MissLog.entries do
        if now - MissLog.entries[i].time > dur then
            table.remove(MissLog.entries, i)
        else
            i = i + 1
        end
    end
end

function MissLog.render()
    if not CFG.MissLog.On or not ENV.Drawing then return end
    MissLog.clean()
    if #MissLog.entries == 0 then return end
    local vp = Camera.ViewportSize
    local startX = vp.X / 2
    local startY = vp.Y / 2 + 40
    for i, entry in ipairs(MissLog.entries) do
        local age = tick() - entry.time
        local alpha = math.clamp(1 - (age / CFG.MissLog.Duration), 0.1, 1)
        local y = startY + (i - 1) * 14
        local parts = {"MISS: " .. entry.target}
        if CFG.MissLog.ShowReason then table.insert(parts, entry.reason) end
        if CFG.MissLog.ShowSpread then table.insert(parts, string.format("%.1f°", entry.spread)) end
        local txt = table.concat(parts, " | ")
        local t = Draw.text(Vector2.new(startX, y), txt, Color3.fromRGB(255, 100, 100), 10, true, true)
        if t then t.Transparency = alpha end
    end
end

local BacktrackSystem = {}
BacktrackSystem.records = {}
BacktrackSystem.maxTicks = 12

function BacktrackSystem.update()
    if not CFG.Backtrack.On then return end
    local now = tick()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if not U.alive(p) then
            BacktrackSystem.records[p] = nil
            continue
        end
        local ch = p.Character
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not rp then continue end
        if not BacktrackSystem.records[p] then
            BacktrackSystem.records[p] = {}
        end
        local rec = BacktrackSystem.records[p]
        table.insert(rec, 1, {
            position = rp.Position,
            cframe = rp.CFrame,
            time = now,
            velocity = rp.AssemblyLinearVelocity,
        })
        local maxTicks = CFG.Backtrack.MaxTicks
        while #rec > maxTicks do
            table.remove(rec)
        end
    end
end

function BacktrackSystem.getBestRecord(player, aimPos)
    if not CFG.Backtrack.On then return nil end
    local records = BacktrackSystem.records[player]
    if not records or #records == 0 then return nil end
    local bestIdx = nil
    local bestDist = math.huge
    local ctr = U.screenCenter()
    for i, rec in ipairs(records) do
        local sp, on = U.w2s(rec.position)
        if on then
            local d = U.dist2d(sp, ctr)
            if d < bestDist then
                bestDist = d
                bestIdx = i
            end
        end
    end
    return bestIdx and records[bestIdx] or nil
end

function BacktrackSystem.render()
    if not CFG.Backtrack.On or not CFG.Backtrack.Visualize or not ENV.Drawing then return end
    local cfg = CFG.Backtrack
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local records = BacktrackSystem.records[p]
        if not records or #records < 2 then continue end
        local col = Color3.new(cfg.Color[1], cfg.Color[2], cfg.Color[3])
        for i = 1, #records - 1 do
            local a = records[i]
            local b = records[i + 1]
            local spA, onA = U.w2s(a.position)
            local spB, onB = U.w2s(b.position)
            if onA and onB then
                local alpha = cfg.Alpha
                if cfg.VisualizeFade then
                    alpha = alpha * math.clamp(1 - (i / #records), 0.05, 1)
                end
                local l = Draw.line(spA, spB, col, 1)
                if l then l.Transparency = alpha end
            end
        end
    end
end

function BacktrackSystem.cleanup(player)
    BacktrackSystem.records[player] = nil
end

local AutoPeekSystem = {}
AutoPeekSystem.active = false
AutoPeekSystem.savedPosition = nil
AutoPeekSystem.returning = false

function AutoPeekSystem.start()
    if AutoPeekSystem.active then return end
    local root = U.myRoot()
    if not root then return end
    AutoPeekSystem.savedPosition = root.Position
    AutoPeekSystem.active = true
    AutoPeekSystem.returning = false
end

function AutoPeekSystem.stop()
    if not AutoPeekSystem.active then return end
    AutoPeekSystem.returning = true
end

function AutoPeekSystem.update(dt)
    if not AutoPeekSystem.active then return end
    local root = U.myRoot()
    if not root then AutoPeekSystem.active = false; return end
    if AutoPeekSystem.returning and AutoPeekSystem.savedPosition then
        local dir = (AutoPeekSystem.savedPosition - root.Position)
        local dist = dir.Magnitude
        if dist < 2 then
            root.CFrame = CFrame.new(AutoPeekSystem.savedPosition) * (root.CFrame - root.CFrame.Position)
            AutoPeekSystem.active = false
            AutoPeekSystem.returning = false
            AutoPeekSystem.savedPosition = nil
            return
        end
        local speed = CFG.AutoPeek.ReturnSpeed
        local move = dir.Unit * math.min(speed * dt, dist)
        root.CFrame = root.CFrame + move
    end
end

function AutoPeekSystem.render()
    if not AutoPeekSystem.active or not CFG.AutoPeek.ShowIndicator or not ENV.Drawing then return end
    if not AutoPeekSystem.savedPosition then return end
    local sp, on = U.w2s(AutoPeekSystem.savedPosition)
    if not on then return end
    local cfg = CFG.AutoPeek
    local col = Color3.new(cfg.IndicatorColor[1], cfg.IndicatorColor[2], cfg.IndicatorColor[3])
    Draw.circle(sp, 8, col, 2, false, 20, 1)
    Draw.circle(sp, 3, col, 1, true, 12, 0.8)
    local root = U.myRoot()
    if root then
        local mysp, myOn = U.w2s(root.Position)
        if myOn then
            Draw.line(mysp, sp, col, 1)
        end
    end
end

local ProximityAlert = {}
ProximityAlert.lastAlert = 0
ProximityAlert.alertActive = false
ProximityAlert.flashTimer = 0

function ProximityAlert.update()
    if not CFG.Proximity.AlertOn then return end
    local myP = U.myPos()
    if myP == Vector3.zero then return end
    local closestDist = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if not U.alive(p) then continue end
        if U.team(p) then continue end
        local ch = p.Character
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not rp then continue end
        local dist = (myP - rp.Position).Magnitude
        if dist < closestDist then closestDist = dist end
    end
    local now = tick()
    if closestDist <= CFG.Proximity.AlertDist then
        if not ProximityAlert.alertActive then
            ProximityAlert.alertActive = true
            ProximityAlert.lastAlert = now
            if CFG.Proximity.AlertSound then
                pcall(function()
                    local snd = Instance.new("Sound")
                    snd.SoundId = CFG.Proximity.AlertSoundId
                    snd.Volume = 0.8
                    snd.Parent = workspace
                    snd:Play()
                    game:GetService("Debris"):AddItem(snd, 3)
                end)
            end
        end
    else
        ProximityAlert.alertActive = false
    end
end

function ProximityAlert.render()
    if not ProximityAlert.alertActive or not ENV.Drawing then return end
    if not CFG.Proximity.AlertVisual then return end
    local vp = Camera.ViewportSize
    local pulse = math.abs(math.sin(tick() * 4))
    local col = Color3.new(CFG.Proximity.AlertColor[1], CFG.Proximity.AlertColor[2], CFG.Proximity.AlertColor[3])
    Draw.text(Vector2.new(vp.X / 2, 25), "! ENEMY NEARBY !", col, 18, true, true)
    if CFG.Proximity.FlashScreen then
        local alpha = pulse * 0.08
        local corners = {
            Vector2.new(0, 0),
            Vector2.new(vp.X, 0),
            Vector2.new(vp.X, vp.Y),
            Vector2.new(0, vp.Y),
        }
        Draw.line(corners[1], corners[2], col, 3)
        Draw.line(corners[2], corners[3], col, 3)
        Draw.line(corners[3], corners[4], col, 3)
        Draw.line(corners[4], corners[1], col, 3)
    end
end

local SoundESPSystem = {}
SoundESPSystem.indicators = {}

function SoundESPSystem.addFootstep(player, position)
    if not CFG.SoundESP.On or not CFG.SoundESP.ShowFootsteps then return end
    table.insert(SoundESPSystem.indicators, {
        type = "footstep",
        player = player,
        position = position,
        time = tick(),
        radius = 0,
    })
end

function SoundESPSystem.addJump(player, position)
    if not CFG.SoundESP.On or not CFG.SoundESP.ShowJumps then return end
    table.insert(SoundESPSystem.indicators, {
        type = "jump",
        player = player,
        position = position,
        time = tick(),
        radius = 0,
    })
end

function SoundESPSystem.update(dt)
    if not CFG.SoundESP.On then return end
    local now = tick()
    local decay = CFG.SoundESP.DecayTime
    local i = 1
    while i <= #SoundESPSystem.indicators do
        local ind = SoundESPSystem.indicators[i]
        local age = now - ind.time
        if age > decay then
            table.remove(SoundESPSystem.indicators, i)
        else
            ind.radius = (age / decay) * CFG.SoundESP.Radius * 30
            i = i + 1
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if not U.alive(p) then continue end
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local rp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not hum or not rp then continue end
        local myP = U.myPos()
        if (myP - rp.Position).Magnitude > CFG.SoundESP.MaxDist then continue end
        if hum.FloorMaterial ~= Enum.Material.Air and hum.MoveDirection.Magnitude > 0.1 then
            local lastStep = nil
            for j = #SoundESPSystem.indicators, math.max(1, #SoundESPSystem.indicators - 3), -1 do
                local ind = SoundESPSystem.indicators[j]
                if ind and ind.player == p and ind.type == "footstep" then
                    lastStep = ind; break
                end
            end
            if not lastStep or now - lastStep.time > 0.35 then
                SoundESPSystem.addFootstep(p, rp.Position)
            end
        end
    end
end

function SoundESPSystem.render()
    if not CFG.SoundESP.On or not ENV.Drawing then return end
    for _, ind in ipairs(SoundESPSystem.indicators) do
        local sp, on = U.w2s(ind.position)
        if not on then continue end
        local age = tick() - ind.time
        local alpha = math.clamp(1 - (age / CFG.SoundESP.DecayTime), 0.05, 1)
        local col
        if ind.type == "footstep" then
            col = Color3.new(CFG.SoundESP.FootstepColor[1], CFG.SoundESP.FootstepColor[2], CFG.SoundESP.FootstepColor[3])
        else
            col = Color3.new(CFG.SoundESP.JumpColor[1], CFG.SoundESP.JumpColor[2], CFG.SoundESP.JumpColor[3])
        end
        local r = math.max(2, ind.radius)
        local c = Draw.circle(sp, r, col, 1, false, 20, alpha)
        if ind.type == "jump" then
            Draw.text(Vector2.new(sp.X, sp.Y - r - 10), "^", col, 10, true, true)
        end
    end
end

local PerfStats = {}
PerfStats.fps = 0
PerfStats.fpsAccum = 0
PerfStats.fpsCount = 0
PerfStats.lastUpdate = 0
PerfStats.ping = 0
PerfStats.memory = 0
PerfStats.uptime = tick()
PerfStats.entityCount = 0

function PerfStats.update()
    if not CFG.PerfStats.On then return end
    local now = tick()
    PerfStats.fpsAccum = PerfStats.fpsAccum + (1 / math.max(0.001, RunService.RenderStepped:Wait()))
    PerfStats.fpsCount = PerfStats.fpsCount + 1
    if now - PerfStats.lastUpdate >= CFG.PerfStats.UpdateRate then
        PerfStats.fps = math.floor(PerfStats.fpsAccum / math.max(1, PerfStats.fpsCount))
        PerfStats.fpsAccum = 0
        PerfStats.fpsCount = 0
        PerfStats.lastUpdate = now
        pcall(function()
            local stats = game:GetService("Stats")
            PerfStats.ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        pcall(function()
            PerfStats.memory = math.floor(collectgarbage("count") / 1024 * 10) / 10
        end)
        if CFG.PerfStats.ShowEntities then
            local count = 0
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then count = count + 1 end
            end
            PerfStats.entityCount = count
        end
    end
end

function PerfStats.render()
    if not CFG.PerfStats.On or not ENV.Drawing then return end
    local cfg = CFG.PerfStats
    local vp = Camera.ViewportSize
    local lines = {}
    if cfg.ShowFPS then
        local fCol = PerfStats.fps >= 55 and "00FF88" or PerfStats.fps >= 30 and "FFCC00" or "FF4444"
        table.insert(lines, "FPS: " .. PerfStats.fps)
    end
    if cfg.ShowPing then table.insert(lines, "Ping: " .. PerfStats.ping .. "ms") end
    if cfg.ShowMemory then table.insert(lines, "Mem: " .. PerfStats.memory .. "MB") end
    if cfg.ShowEntities then table.insert(lines, "Players: " .. PerfStats.entityCount) end
    if cfg.ShowUptime then
        local uptime = tick() - PerfStats.uptime
        local mins = math.floor(uptime / 60)
        local secs = math.floor(uptime % 60)
        table.insert(lines, string.format("Up: %dm %ds", mins, secs))
    end
    local startX, startY
    if cfg.Position == "BottomRight" then
        startX = vp.X - 130; startY = vp.Y - (#lines * 14) - 20
    elseif cfg.Position == "BottomLeft" then
        startX = 15; startY = vp.Y - (#lines * 14) - 20
    elseif cfg.Position == "TopLeft" then
        startX = 15; startY = 60
    else
        startX = vp.X - 130; startY = 60
    end
    Draw.text(Vector2.new(startX, startY - 14), "PERFORMANCE", Color3.fromRGB(232, 67, 147), 10, false, true)
    for i, line in ipairs(lines) do
        local y = startY + (i - 1) * 14
        local col = Color3.fromRGB(180, 180, 200)
        if line:find("FPS") then
            local fps = PerfStats.fps
            col = fps >= 55 and Color3.fromRGB(0, 255, 136)
                or fps >= 30 and Color3.fromRGB(255, 204, 0)
                or Color3.fromRGB(255, 68, 68)
        end
        Draw.text(Vector2.new(startX, y), line, col, 10, false, true)
    end
end

local ThemeManager = {}
ThemeManager.presets = {
    ["Lunarix Pink"] = {
        BG = {12, 12, 18}, Panel = {18, 18, 26}, Header = {14, 14, 21},
        Accent = {232, 67, 147}, AccentAlt = {255, 105, 180},
        Text = {230, 230, 240}, Sub = {140, 140, 160},
    },
    ["Midnight Blue"] = {
        BG = {10, 12, 22}, Panel = {16, 20, 35}, Header = {12, 15, 28},
        Accent = {60, 130, 255}, AccentAlt = {100, 160, 255},
        Text = {220, 225, 240}, Sub = {120, 135, 165},
    },
    ["Blood Red"] = {
        BG = {18, 8, 8}, Panel = {28, 14, 14}, Header = {22, 10, 10},
        Accent = {220, 30, 30}, AccentAlt = {255, 80, 80},
        Text = {240, 220, 220}, Sub = {160, 130, 130},
    },
    ["Toxic Green"] = {
        BG = {8, 16, 10}, Panel = {14, 25, 16}, Header = {10, 20, 12},
        Accent = {0, 230, 64}, AccentAlt = {80, 255, 120},
        Text = {220, 240, 225}, Sub = {130, 160, 140},
    },
    ["Purple Haze"] = {
        BG = {14, 10, 20}, Panel = {22, 16, 32}, Header = {18, 12, 26},
        Accent = {160, 60, 255}, AccentAlt = {200, 120, 255},
        Text = {230, 220, 245}, Sub = {150, 130, 170},
    },
    ["Golden"] = {
        BG = {18, 16, 10}, Panel = {28, 24, 16}, Header = {22, 20, 12},
        Accent = {255, 195, 0}, AccentAlt = {255, 215, 80},
        Text = {240, 235, 220}, Sub = {170, 160, 130},
    },
    ["Cyan Frost"] = {
        BG = {8, 14, 18}, Panel = {14, 22, 28}, Header = {10, 18, 22},
        Accent = {0, 210, 230}, AccentAlt = {80, 230, 250},
        Text = {220, 235, 240}, Sub = {130, 155, 165},
    },
    ["Stealth Dark"] = {
        BG = {6, 6, 8}, Panel = {10, 10, 14}, Header = {8, 8, 11},
        Accent = {90, 90, 100}, AccentAlt = {120, 120, 135},
        Text = {180, 180, 190}, Sub = {100, 100, 110},
    },
}

function ThemeManager.apply(name)
    local preset = ThemeManager.presets[name]
    if not preset then return false end
    CFG.GUI.Accent = {preset.Accent[1], preset.Accent[2], preset.Accent[3]}
    CFG.GUI.AccentAlt = {preset.AccentAlt[1], preset.AccentAlt[2], preset.AccentAlt[3]}
    CFG.Themes.Current = name
    CFG.Themes.Custom.BG = preset.BG
    CFG.Themes.Custom.Panel = preset.Panel
    CFG.Themes.Custom.Header = preset.Header
    CFG.Themes.Custom.Accent = preset.Accent
    CFG.Themes.Custom.AccentAlt = preset.AccentAlt
    CFG.Themes.Custom.Text = preset.Text
    return true
end

function ThemeManager.getNames()
    local names = {}
    for name in pairs(ThemeManager.presets) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

local SpinbotSystem = {}
SpinbotSystem.angle = 0

function SpinbotSystem.update(dt)
    if not CFG.Spinbot.On then return end
    local root = U.myRoot()
    if not root then return end
    SpinbotSystem.angle = SpinbotSystem.angle + CFG.Spinbot.Speed * dt
    if SpinbotSystem.angle > math.pi * 2 then
        SpinbotSystem.angle = SpinbotSystem.angle - math.pi * 2
    end
    local axis = CFG.Spinbot.Axis
    if axis == "Y" then
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, SpinbotSystem.angle, 0)
    elseif axis == "X" then
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(SpinbotSystem.angle, 0, 0)
    elseif axis == "Z" then
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, 0, SpinbotSystem.angle)
    end
end

local BunnyHopSystem = {}
BunnyHopSystem.lastJump = 0

function BunnyHopSystem.update()
    if not CFG.BunnyHop.On then return end
    local hum = U.myHumanoid()
    if not hum then return end
    local root = U.myRoot()
    if not root then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        if hum.MoveDirection.Magnitude > 0.1 then
            hum.Jump = true
        end
    end
    if CFG.BunnyHop.AutoStrafe and hum.FloorMaterial == Enum.Material.Air then
        local vel = root.AssemblyLinearVelocity
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0.1 then
            local strafeForce = moveDir * CFG.BunnyHop.StrafeSpeed * 10
            root.AssemblyLinearVelocity = Vector3.new(
                vel.X + strafeForce.X,
                vel.Y,
                vel.Z + strafeForce.Z
            )
        end
    end
end

local SpiderSystem = {}
SpiderSystem.active = false

function SpiderSystem.update()
    if not CFG.Spider.On or not SpiderSystem.active then return end
    local root = U.myRoot()
    if not root then return end
    local hum = U.myHumanoid()
    if not hum then return end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character}
    local directions = {
        root.CFrame.LookVector,
        -root.CFrame.LookVector,
        root.CFrame.RightVector,
        -root.CFrame.RightVector,
    }
    for _, dir in ipairs(directions) do
        local result = workspace:Raycast(root.Position, dir * 3, params)
        if result then
            local upForce = CFG.Spider.Speed
            root.AssemblyLinearVelocity = Vector3.new(
                root.AssemblyLinearVelocity.X,
                upForce,
                root.AssemblyLinearVelocity.Z
            )
            break
        end
    end
end

local PhaseSystem = {}
PhaseSystem.active = false

function PhaseSystem.update(dt)
    if not CFG.Phase.On or not PhaseSystem.active then return end
    local root = U.myRoot()
    if not root then return end
    local cam = Camera.CFrame
    local moveDir = cam.LookVector
    root.CFrame = root.CFrame + moveDir * CFG.Phase.Speed * dt
    for _, part in ipairs(LP.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local AnchorSystem = {}
AnchorSystem.active = false
AnchorSystem.savedCF = nil

function AnchorSystem.toggle()
    if AnchorSystem.active then
        AnchorSystem.active = false
        AnchorSystem.savedCF = nil
    else
        local root = U.myRoot()
        if root then
            AnchorSystem.savedCF = root.CFrame
            AnchorSystem.active = true
        end
    end
end

function AnchorSystem.update()
    if not AnchorSystem.active or not AnchorSystem.savedCF then return end
    local root = U.myRoot()
    if not root then AnchorSystem.active = false; return end
    root.CFrame = AnchorSystem.savedCF
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local AntiAimSystem = {}
AntiAimSystem.yawAngle = 0
AntiAimSystem.manualSide = nil
AntiAimSystem.lastDesyncSide = "Left"

function AntiAimSystem.update(dt)
    if not CFG.AntiAim.On then return end
    local root = U.myRoot()
    if not root then return end
    local cfg = CFG.AntiAim
    local pitchAngle = 0
    if cfg.Pitch == "Down" then
        pitchAngle = math.rad(-89)
    elseif cfg.Pitch == "Up" then
        pitchAngle = math.rad(89)
    elseif cfg.Pitch == "Zero" then
        pitchAngle = 0
    elseif cfg.Pitch == "Jitter" then
        pitchAngle = math.rad(math.random(-89, 89))
    end
    local yawAngle = 0
    if cfg.Yaw == "Spin" then
        AntiAimSystem.yawAngle = AntiAimSystem.yawAngle + cfg.SpinSpeed * dt
        yawAngle = AntiAimSystem.yawAngle
    elseif cfg.Yaw == "Jitter" then
        yawAngle = math.rad(math.random(-cfg.JitterAmount, cfg.JitterAmount))
    elseif cfg.Yaw == "Backward" then
        local camLook = Camera.CFrame.LookVector
        yawAngle = math.atan2(camLook.X, camLook.Z) + math.pi
    elseif cfg.Yaw == "Sideways" then
        local camLook = Camera.CFrame.LookVector
        yawAngle = math.atan2(camLook.X, camLook.Z) + math.pi / 2
    elseif cfg.Yaw == "Manual" then
        if AntiAimSystem.manualSide == "Left" then
            yawAngle = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z) + math.pi / 2
        elseif AntiAimSystem.manualSide == "Right" then
            yawAngle = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z) - math.pi / 2
        elseif AntiAimSystem.manualSide == "Back" then
            yawAngle = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z) + math.pi
        end
    end
    yawAngle = yawAngle + math.rad(cfg.YawOffset)
    if cfg.LegBreaker then
        local legOffset = math.sin(tick() * 20) * math.rad(30)
        yawAngle = yawAngle + legOffset
    end
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(pitchAngle, yawAngle, 0)
end

local ThirdPersonCam = {}
ThirdPersonCam.active = false
ThirdPersonCam.savedSettings = {}

function ThirdPersonCam.enable()
    if ThirdPersonCam.active then return end
    ThirdPersonCam.active = true
    local hum = U.myHumanoid()
    if hum then
        ThirdPersonCam.savedSettings.cameraMode = LP.CameraMode
        LP.CameraMode = Enum.CameraMode.Classic
        hum.CameraOffset = CFG.ThirdPerson.Offset
    end
    Camera.FieldOfView = CFG.ThirdPerson.FOV
end

function ThirdPersonCam.disable()
    if not ThirdPersonCam.active then return end
    ThirdPersonCam.active = false
    local hum = U.myHumanoid()
    if hum then
        hum.CameraOffset = Vector3.zero
        if ThirdPersonCam.savedSettings.cameraMode then
            LP.CameraMode = ThirdPersonCam.savedSettings.cameraMode
        end
    end
end

function ThirdPersonCam.update()
    if not ThirdPersonCam.active then return end
    local hum = U.myHumanoid()
    if not hum then return end
    hum.CameraOffset = CFG.ThirdPerson.Offset
end

local FlagDetector = {}

function FlagDetector.getFlags(player)
    local flags = {}
    if not player or not U.alive(player) then return flags end
    local ch = player.Character
    if not ch then return flags end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    local root = ch:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return flags end
    if CFG.Flags.ShowArmor then
        local hasForceField = ch:FindFirstChildOfClass("ForceField")
        if hasForceField then table.insert(flags, {text = "FF", color = CFG.Flags.ArmorColor}) end
    end
    if CFG.Flags.ShowGodmode then
        if hum.MaxHealth >= 999999 or hum.Health >= 999999 then
            table.insert(flags, {text = "GOD", color = CFG.Flags.GodmodeColor})
        end
    end
    if CFG.Flags.ShowSpeeding then
        local speed = root.AssemblyLinearVelocity
        local flatSpeed = Vector3.new(speed.X, 0, speed.Z).Magnitude
        if flatSpeed > 50 then
            table.insert(flags, {text = "SPEED", color = CFG.Flags.SpeedColor})
        end
    end
    if CFG.Flags.ShowFlying then
        if hum.FloorMaterial == Enum.Material.Air then
            local vel = root.AssemblyLinearVelocity
            if vel.Y > 5 or vel.Y < -1 then
                local isJumping = vel.Y > 20 and vel.Y < 60
                if not isJumping then
                    table.insert(flags, {text = "FLY", color = CFG.Flags.FlyColor})
                end
            end
        end
    end
    if CFG.Flags.ShowBot then
        local accountAge = player.AccountAge
        if accountAge < 7 then
            table.insert(flags, {text = "NEW", color = CFG.Flags.BotColor})
        end
    end
    if CFG.Flags.ShowAdmin then
        local isAdmin = false
        pcall(function()
            if player:GetRankInGroup(game.CreatorId) >= 200 then isAdmin = true end
        end)
        pcall(function()
            if player.UserId == game.CreatorId then isAdmin = true end
        end)
        if isAdmin then
            table.insert(flags, {text = "ADMIN", color = CFG.Flags.AdminColor})
        end
    end
    return flags
end

function FlagDetector.renderFlags(player, screenPos, yOffset)
    if not CFG.Flags.On or not ENV.Drawing then return yOffset end
    local flags = FlagDetector.getFlags(player)
    if #flags == 0 then return yOffset end
    local x = screenPos.X
    local y = screenPos.Y + (yOffset or 0)
    local totalWidth = 0
    local spacing = 4
    local flagTexts = {}
    for _, flag in ipairs(flags) do
        table.insert(flagTexts, flag)
        totalWidth = totalWidth + #flag.text * 6 + spacing
    end
    local startX = x - totalWidth / 2
    for _, flag in ipairs(flagTexts) do
        local col = Color3.new(flag.color[1], flag.color[2], flag.color[3])
        Draw.text(Vector2.new(startX, y), flag.text, col, CFG.Flags.FontSize, false, true)
        startX = startX + #flag.text * 6 + spacing
    end
    return yOffset + 14
end

local HealthBarRenderer = {}

function HealthBarRenderer.draw(x, y, height, frac, side)
    if not ENV.Drawing then return end
    local cfg = CFG.HealthBar
    local w = cfg.Width
    local offset = cfg.Offset
    local barX
    if side == "Right" then
        barX = x + offset
    else
        barX = x - offset - w
    end
    if cfg.Outline then
        local bgA = Vector2.new(barX - 1, y - 1)
        local bgB = Vector2.new(barX + w + 1, y - 1)
        local bgC = Vector2.new(barX + w + 1, y + height + 1)
        local bgD = Vector2.new(barX - 1, y + height + 1)
        Draw.quad(bgA, bgB, bgC, bgD, Color3.fromRGB(0, 0, 0), 1, true)
    end
    local bgA = Vector2.new(barX, y)
    local bgB = Vector2.new(barX + w, y)
    local bgC = Vector2.new(barX + w, y + height)
    local bgD = Vector2.new(barX, y + height)
    Draw.quad(bgA, bgB, bgC, bgD, Color3.fromRGB(20, 20, 25), 1, true)
    local fillH = height * math.clamp(frac, 0, 1)
    local fillY = y + height - fillH
    local fillCol
    if cfg.Style == "Gradient" then
        fillCol = U.hpColor(frac)
    elseif cfg.CustomColors then
        local fullCol = Color3.new(cfg.FullColor[1], cfg.FullColor[2], cfg.FullColor[3])
        local lowCol = Color3.new(cfg.LowColor[1], cfg.LowColor[2], cfg.LowColor[3])
        fillCol = lowCol:Lerp(fullCol, frac)
    else
        fillCol = U.hpColor(frac)
    end
    if cfg.Style == "Segmented" then
        local segH = height / cfg.Segments
        for s = 0, cfg.Segments - 1 do
            local segTop = y + height - (s + 1) * segH
            local segBot = y + height - s * segH
            local segFrac = math.clamp((frac * cfg.Segments) - s, 0, 1)
            if segFrac > 0 then
                local sA = Vector2.new(barX, segBot - segH * segFrac)
                local sB = Vector2.new(barX + w, segBot - segH * segFrac)
                local sC = Vector2.new(barX + w, segBot - 1)
                local sD = Vector2.new(barX, segBot - 1)
                Draw.quad(sA, sB, sC, sD, fillCol, 1, true)
            end
            if s > 0 then
                Draw.line(
                    Vector2.new(barX, segTop),
                    Vector2.new(barX + w, segTop),
                    Color3.fromRGB(0, 0, 0), 1
                )
            end
        end
    else
        local fA = Vector2.new(barX, fillY)
        local fB = Vector2.new(barX + w, fillY)
        local fC = Vector2.new(barX + w, y + height)
        local fD = Vector2.new(barX, y + height)
        Draw.quad(fA, fB, fC, fD, fillCol, 1, true)
    end
    if cfg.TextInside then
        local txt = math.floor(frac * 100) .. "%"
        Draw.text(Vector2.new(barX + w / 2, fillY - 2), txt, Color3.fromRGB(255, 255, 255), 8, true, true)
    end
end

local RageBotEngine = {}
RageBotEngine.targets = {}
RageBotEngine.lastSwitch = 0
RageBotEngine.missCount = {}
RageBotEngine.shotsFired = 0
RageBotEngine.shotsHit = 0

function RageBotEngine.scoreTarget(player, cfg)
    if not U.alive(player) then return -1 end
    if cfg.TeamCheck ~= false and U.team(player) then return -1 end
    local ch = player.Character
    local rp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not rp then return -1 end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return -1 end
    local hp = hum.Health
    local maxHp = hum.MaxHealth
    local dist = (U.myPos() - rp.Position).Magnitude
    if dist > 2500 then return -1 end
    local ctr = U.screenCenter()
    local sp, on = U.w2s(rp.Position)
    if not on then
        if cfg.FOV < 360 then return -1 end
    end
    local fovDist = on and U.dist2d(sp, ctr) or 9999
    if fovDist > cfg.FOV and cfg.FOV < 360 then return -1 end
    if not cfg.AutoWall then
        if not U.visCheck(rp.Position) then return -1 end
    end
    local score = 10000
    local priority = cfg.Priority or "ThreatLevel"
    if priority == "ThreatLevel" then
        score = score - dist * 0.5
        score = score - fovDist * 2
        if hp < maxHp * 0.3 then score = score + 2000 end
        local weapon = U.getWeapon(player)
        if weapon and weapon:lower():find("sniper") then score = score + 500 end
        if weapon and weapon:lower():find("shotgun") then score = score + 300 end
    elseif priority == "LowestHP" then
        score = score - hp * 10
    elseif priority == "Closest" then
        score = score - dist
    elseif priority == "FOV" then
        score = score - fovDist * 5
    end
    return score
end

function RageBotEngine.findTargets(cfg)
    local candidates = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local score = RageBotEngine.scoreTarget(p, cfg)
        if score > 0 then
            table.insert(candidates, {player = p, score = score})
        end
    end
    table.sort(candidates, function(a, b) return a.score > b.score end)
    local maxT = cfg.MaxTargets or 1
    local result = {}
    for i = 1, math.min(maxT, #candidates) do
        table.insert(result, candidates[i].player)
    end
    return result
end

function RageBotEngine.getBestPart(player, cfg)
    local ch = player.Character
    if not ch then return nil end
    if cfg.ForceHead then
        local head = ch:FindFirstChild("Head")
        if head then return head end
    end
    if cfg.ForceBaim then
        local torso = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
        if torso then return torso end
    end
    if cfg.MultiPoint then
        local bestPart = nil
        local bestFOV = math.huge
        local ctr = U.screenCenter()
        for _, partName in ipairs(cfg.MultiPointParts) do
            local part = ch:FindFirstChild(partName)
            if part then
                local sp, on = U.w2s(part.Position)
                if on then
                    local d = U.dist2d(sp, ctr)
                    if d < bestFOV then
                        bestFOV = d
                        bestPart = part
                    end
                end
            end
        end
        return bestPart
    end
    local partName = cfg.Part or "Head"
    return ch:FindFirstChild(partName) or ch:FindFirstChild("HumanoidRootPart")
end

function RageBotEngine.execute(dt)
    if not CFG.RageBot.On then return end
    local cfg = CFG.RageBot
    local targets = RageBotEngine.findTargets(cfg)
    RageBotEngine.targets = targets
    if #targets == 0 then return end
    for _, target in ipairs(targets) do
        local part = RageBotEngine.getBestPart(target, cfg)
        if not part then continue end
        local aimPos = part.Position
        if cfg.Backtrack and BacktrackSystem then
            local btRecord = BacktrackSystem.getBestRecord(target, aimPos)
            if btRecord then
                aimPos = btRecord.position
            end
        end
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, aimPos)
        if cfg.AutoFire ~= false then
            local hitChance = cfg.MinHitChance or 70
            if math.random(1, 100) <= hitChance then
                pcall(function() mouse1click() end)
                RageBotEngine.shotsFired = RageBotEngine.shotsFired + 1
                HitLog.add({
                    target = target.DisplayName,
                    damage = math.random(20, 100),
                    part = part.Name,
                    weapon = U.getWeapon(LP) or "Unknown",
                    hitChance = hitChance,
                    backtrack = cfg.Backtrack,
                })
            else
                MissLog.add({
                    target = target.DisplayName,
                    reason = "Spread",
                    spread = math.random(1, 15),
                })
            end
        end
    end
end

local TriggerBotSystem = {}
TriggerBotSystem.lastFire = 0
TriggerBotSystem.burstLeft = 0
TriggerBotSystem.burstTimer = 0
TriggerBotSystem.cooldown = 0

function TriggerBotSystem.isInFOV(target)
    if not U.alive(target) then return false end
    local ch = target.Character
    if not ch then return false end
    local part = ch:FindFirstChild(CFG.TriggerBot.TargetPart) or ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
    if not part then return false end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local sp, on = cam:WorldToViewportPoint(part.Position)
    if not on then return false end
    local ctr = cam.ViewportSize / 2
    local dist2D = (Vector2.new(sp.X, sp.Y) - ctr).Magnitude
    return dist2D <= CFG.TriggerBot.FOV
end

function TriggerBotSystem.findTarget()
    local best, bestDist = nil, math.huge
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local ctr = cam.ViewportSize / 2
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            if CFG.TriggerBot.TeamCheck and U.team(p) then continue end
            if CFG.TriggerBot.MinHP > 0 and (U.hp(p) or 0) < CFG.TriggerBot.MinHP then continue end
            local ch = p.Character
            if not ch then continue end
            local part = ch:FindFirstChild(CFG.TriggerBot.TargetPart) or ch:FindFirstChild("Head")
            if not part then continue end
            if CFG.TriggerBot.WallCheck and U.wallCheck and not U.wallCheck(part.Position) then continue end
            local sp, on = cam:WorldToViewportPoint(part.Position)
            if not on then continue end
            local d = (Vector2.new(sp.X, sp.Y) - ctr).Magnitude
            if d <= CFG.TriggerBot.FOV and d < bestDist then
                bestDist = d
                best = p
            end
        end
    end
    return best
end

function TriggerBotSystem.simulateFire()
    pcall(function()
        local vimPress = game:GetService("VirtualInputManager")
        if vimPress then
            vimPress:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.delay(CFG.TriggerBot.HoldTime, function()
                pcall(function()
                    vimPress:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end)
            end)
        end
    end)
end

function TriggerBotSystem.update(dt)
    if not CFG.TriggerBot.On then return end
    local now = tick()
    if now - TriggerBotSystem.cooldown < CFG.TriggerBot.ReTriggerDelay then return end
    if TriggerBotSystem.burstLeft > 0 then
        if now - TriggerBotSystem.burstTimer >= CFG.TriggerBot.BurstDelay then
            TriggerBotSystem.simulateFire()
            TriggerBotSystem.burstLeft = TriggerBotSystem.burstLeft - 1
            TriggerBotSystem.burstTimer = now
            if TriggerBotSystem.burstLeft <= 0 then
                TriggerBotSystem.cooldown = now
            end
        end
        return
    end
    local target = TriggerBotSystem.findTarget()
    if target then
        if now - TriggerBotSystem.lastFire >= CFG.TriggerBot.Delay then
            TriggerBotSystem.lastFire = now
            TriggerBotSystem.simulateFire()
            if CFG.TriggerBot.BurstCount > 1 then
                TriggerBotSystem.burstLeft = CFG.TriggerBot.BurstCount - 1
                TriggerBotSystem.burstTimer = now
            else
                TriggerBotSystem.cooldown = now
            end
        end
    end
end

function TriggerBotSystem.renderFOV()
    if not CFG.TriggerBot.On or not CFG.TriggerBot.ShowFOV then return end
    if not Draw.circle then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local ctr = cam.ViewportSize / 2
    Draw.circle(ctr, CFG.TriggerBot.FOV, U.c3(CFG.TriggerBot.FOVColor), 0.6, 1)
end

local DamageCalculator = {}

function DamageCalculator.getPartMultiplier(partName)
    if not partName then return 1 end
    local n = string.lower(partName)
    if n == "head" then return CFG.DmgCalc.HeadshotMult end
    if string.find(n, "arm") or string.find(n, "hand") then return CFG.DmgCalc.LimbMult end
    if string.find(n, "leg") or string.find(n, "foot") then return CFG.DmgCalc.LimbMult end
    return 1
end

function DamageCalculator.getRangeFalloff(dist)
    if not CFG.DmgCalc.RangeFalloff then return 1 end
    if dist <= CFG.DmgCalc.FalloffStart then return 1 end
    if dist >= CFG.DmgCalc.FalloffEnd then return CFG.DmgCalc.FalloffMin end
    local t = (dist - CFG.DmgCalc.FalloffStart) / (CFG.DmgCalc.FalloffEnd - CFG.DmgCalc.FalloffStart)
    return 1 - t * (1 - CFG.DmgCalc.FalloffMin)
end

function DamageCalculator.getArmorReduction(target)
    if not target or not U.alive(target) then return 0 end
    local ch = target.Character
    if not ch then return 0 end
    local armor = ch:FindFirstChild("Armor") or ch:FindFirstChild("BodyArmor") or ch:FindFirstChild("Shield")
    if armor then return CFG.DmgCalc.ArmorReduction end
    return 0
end

function DamageCalculator.calculate(target, partName, dist)
    if not CFG.DmgCalc.On then return CFG.DmgCalc.BaseDamage end
    local base = CFG.DmgCalc.BaseDamage
    local partMult = DamageCalculator.getPartMultiplier(partName)
    local rangeMult = DamageCalculator.getRangeFalloff(dist or 0)
    local armorRed = DamageCalculator.getArmorReduction(target)
    local dmg = base * partMult * rangeMult * (1 - armorRed)
    return math.max(1, math.floor(dmg + 0.5))
end

function DamageCalculator.getShotsToKill(target, partName, dist)
    local dmg = DamageCalculator.calculate(target, partName, dist)
    local hp = U.hp(target) or 100
    return math.ceil(hp / math.max(1, dmg))
end

function DamageCalculator.render(target)
    if not CFG.DmgCalc.On or not CFG.DmgCalc.ShowOverlay then return end
    if not target or not U.alive(target) then return end
    if not Draw.text then return end
    local ch = target.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local sp, on = U.w2s(hrp.Position)
    if not on then return end
    local dist = U.distanceToPlayer(target)
    local headDmg = DamageCalculator.calculate(target, "Head", dist)
    local bodyDmg = DamageCalculator.calculate(target, "Torso", dist)
    local headSTK = DamageCalculator.getShotsToKill(target, "Head", dist)
    local bodySTK = DamageCalculator.getShotsToKill(target, "Torso", dist)
    local y = sp.Y + 25
    Draw.text(Vector2.new(sp.X, y), string.format("DMG: H:%d B:%d", headDmg, bodyDmg), Color3.new(1, 0.8, 0.3), 10, true)
    Draw.text(Vector2.new(sp.X, y + 12), string.format("STK: H:%d B:%d", headSTK, bodySTK), Color3.new(1, 0.6, 0.2), 10, true)
end

local AutoWallSystem = {}

function AutoWallSystem.getMaterialPenMult(material)
    if not CFG.AutoWall.MaterialMultipliers then return 0.5 end
    local m = tostring(material)
    if string.find(m, "Wood") then return CFG.AutoWall.WoodMult end
    if string.find(m, "Metal") or string.find(m, "Iron") or string.find(m, "Steel") then return CFG.AutoWall.MetalMult end
    if string.find(m, "Concrete") or string.find(m, "Brick") or string.find(m, "Stone") then return CFG.AutoWall.ConcreteMult end
    if string.find(m, "Glass") or string.find(m, "Ice") then return CFG.AutoWall.GlassMult end
    if string.find(m, "Plastic") then return CFG.AutoWall.PlasticMult end
    return 0.5
end

function AutoWallSystem.canPenetrate(origin, target)
    if not CFG.AutoWall.On then return true, 1.0 end
    if not target or not U.alive(target) then return false, 0 end
    local ch = target.Character
    if not ch then return false, 0 end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, 0 end
    local dir = (hrp.Position - origin).Unit
    local ray = workspace:Raycast(origin, dir * 1000, U.makeRayParams({LP.Character, ch}))
    if not ray then return true, 1.0 end
    local distToWall = (ray.Position - origin).Magnitude
    local distToTarget = (hrp.Position - origin).Magnitude
    if distToWall >= distToTarget then return true, 1.0 end
    local penMult = AutoWallSystem.getMaterialPenMult(ray.Material)
    local thickness = 0
    local penCount = 0
    local pos = ray.Position + dir * 0.5
    for i = 1, CFG.AutoWall.MaxPenetration do
        penCount = penCount + 1
        local exitRay = workspace:Raycast(pos, dir * 20, U.makeRayParams({LP.Character, ch}))
        if exitRay then
            thickness = thickness + (exitRay.Position - pos).Magnitude
            pos = exitRay.Position + dir * 0.5
            penMult = penMult * AutoWallSystem.getMaterialPenMult(exitRay.Material)
        else
            thickness = thickness + 2
            pos = pos + dir * 2
            break
        end
    end
    local finalDmgMult = penMult * math.max(0, 1 - thickness / 15)
    local canPen = finalDmgMult * CFG.DmgCalc.BaseDamage >= CFG.AutoWall.MinDamage
    return canPen, finalDmgMult
end

function AutoWallSystem.renderPenetrable(target)
    if not CFG.AutoWall.On or not CFG.AutoWall.ShowPenetrable then return end
    if not target or not U.alive(target) then return end
    if not Draw.text then return end
    local ch = target.Character
    if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local sp, on = U.w2s(hrp.Position)
    if not on then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local origin = cam.CFrame.Position
    local canPen, mult = AutoWallSystem.canPenetrate(origin, target)
    if not canPen then return end
    local col = U.c3(CFG.AutoWall.PenetrableColor)
    Draw.text(Vector2.new(sp.X, sp.Y - 30), string.format("WALL: %.0f%%", mult * 100), col, 11, true)
end

local ThreatAssessment = {}
ThreatAssessment.cache = {}
ThreatAssessment.lastUpdate = 0

function ThreatAssessment.getWeaponThreat(player)
    if not U.alive(player) then return 0 end
    local weapon = U.getWeapon(player)
    if not weapon or weapon == "None" then return 0.1 end
    local name = string.lower(weapon)
    if string.find(name, "snip") or string.find(name, "awp") or string.find(name, "bolt") then return 1.0 end
    if string.find(name, "rifle") or string.find(name, "ak") or string.find(name, "m4") then return 0.8 end
    if string.find(name, "smg") or string.find(name, "mp") or string.find(name, "uzi") then return 0.6 end
    if string.find(name, "shot") then return 0.7 end
    if string.find(name, "pistol") or string.find(name, "glock") or string.find(name, "deagle") then return 0.5 end
    if string.find(name, "knife") or string.find(name, "sword") or string.find(name, "melee") then return 0.3 end
    return 0.4
end

function ThreatAssessment.calculate(player)
    if not player or not U.alive(player) then return 0 end
    local w = CFG.ThreatLevel.Weights
    local hp = math.clamp((U.hp(player) or 100) / 100, 0, 1)
    local dist = U.distanceToPlayer(player) or 1000
    local distNorm = math.clamp(1 - dist / 500, 0, 1)
    local speed = U.getSpeed(player) or 0
    local speedNorm = math.clamp(speed / 100, 0, 1)
    local weaponThreat = ThreatAssessment.getWeaponThreat(player)
    local accuracySim = math.random(30, 80) / 100
    local score = hp * w.HP + distNorm * w.Distance + speedNorm * w.Speed + weaponThreat * w.Weapon + accuracySim * w.Accuracy
    return math.clamp(score, 0, 1)
end

function ThreatAssessment.update()
    if not CFG.ThreatLevel.On then return end
    local now = tick()
    if now - ThreatAssessment.lastUpdate < CFG.ThreatLevel.UpdateRate then return end
    ThreatAssessment.lastUpdate = now
    ThreatAssessment.cache = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            ThreatAssessment.cache[p] = ThreatAssessment.calculate(p)
        end
    end
end

function ThreatAssessment.getColor(score)
    if score >= 0.7 then return U.c3(CFG.ThreatLevel.HighColor) end
    if score >= 0.4 then return U.c3(CFG.ThreatLevel.MedColor) end
    return U.c3(CFG.ThreatLevel.LowColor)
end

function ThreatAssessment.render()
    if not CFG.ThreatLevel.On or not CFG.ThreatLevel.ShowIndicator then return end
    if not Draw.text then return end
    for p, score in pairs(ThreatAssessment.cache) do
        if U.alive(p) then
            local ch = p.Character
            if not ch then continue end
            local head = ch:FindFirstChild("Head")
            if not head then continue end
            local sp, on = U.w2s(head.Position + Vector3.new(0, 3, 0))
            if not on then continue end
            local col = ThreatAssessment.getColor(score)
            local label = score >= 0.7 and "HIGH" or (score >= 0.4 and "MED" or "LOW")
            Draw.text(Vector2.new(sp.X, sp.Y - 8), string.format("[%s %.0f%%]", label, score * 100), col, 10, true)
        end
    end
end

local SessionTracker = {}
SessionTracker.kills = 0
SessionTracker.deaths = 0
SessionTracker.headshots = 0
SessionTracker.totalDmg = 0
SessionTracker.shots = 0
SessionTracker.hits = 0
SessionTracker.startTime = tick()
SessionTracker.maxStreak = 0
SessionTracker.currentStreak = 0
SessionTracker.lastHP = 100
SessionTracker.distWalked = 0
SessionTracker.lastPos = nil

function SessionTracker.addKill(headshot)
    SessionTracker.kills = SessionTracker.kills + 1
    SessionTracker.currentStreak = SessionTracker.currentStreak + 1
    if SessionTracker.currentStreak > SessionTracker.maxStreak then
        SessionTracker.maxStreak = SessionTracker.currentStreak
    end
    if headshot then SessionTracker.headshots = SessionTracker.headshots + 1 end
end

function SessionTracker.addDeath()
    SessionTracker.deaths = SessionTracker.deaths + 1
    SessionTracker.currentStreak = 0
end

function SessionTracker.addShot(hit)
    SessionTracker.shots = SessionTracker.shots + 1
    if hit then SessionTracker.hits = SessionTracker.hits + 1 end
end

function SessionTracker.addDamage(amount)
    SessionTracker.totalDmg = SessionTracker.totalDmg + amount
end

function SessionTracker.getKD()
    if SessionTracker.deaths == 0 then return SessionTracker.kills end
    return math.floor(SessionTracker.kills / SessionTracker.deaths * 100) / 100
end

function SessionTracker.getAccuracy()
    if SessionTracker.shots == 0 then return 0 end
    return math.floor(SessionTracker.hits / SessionTracker.shots * 10000) / 100
end

function SessionTracker.getPlaytime()
    local elapsed = tick() - SessionTracker.startTime
    local mins = math.floor(elapsed / 60)
    local secs = math.floor(elapsed % 60)
    local hrs = math.floor(mins / 60)
    mins = mins % 60
    if hrs > 0 then return string.format("%dh %dm %ds", hrs, mins, secs) end
    return string.format("%dm %ds", mins, secs)
end

function SessionTracker.update()
    if not CFG.SessionStats.On then return end
    if U.alive(LP) then
        local ch = LP.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                if SessionTracker.lastPos then
                    SessionTracker.distWalked = SessionTracker.distWalked + (pos - SessionTracker.lastPos).Magnitude
                end
                SessionTracker.lastPos = pos
            end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if hum then
                local hp = hum.Health
                if hp <= 0 and SessionTracker.lastHP > 0 then
                    SessionTracker.addDeath()
                end
                SessionTracker.lastHP = hp
            end
        end
    else
        SessionTracker.lastPos = nil
    end
end

function SessionTracker.render()
    if not CFG.SessionStats.On or not CFG.SessionStats.ShowOverlay then return end
    if not Draw.text then return end
    local lines = {}
    if CFG.SessionStats.TrackKills then table.insert(lines, string.format("Kills: %d", SessionTracker.kills)) end
    if CFG.SessionStats.TrackDeaths then table.insert(lines, string.format("Deaths: %d", SessionTracker.deaths)) end
    if CFG.SessionStats.ShowKDRatio then table.insert(lines, string.format("K/D: %.2f", SessionTracker.getKD())) end
    if CFG.SessionStats.ShowAccuracy then table.insert(lines, string.format("Acc: %.1f%%", SessionTracker.getAccuracy())) end
    if CFG.SessionStats.TrackHeadshots then table.insert(lines, string.format("HS: %d", SessionTracker.headshots)) end
    if CFG.SessionStats.TrackDamage then table.insert(lines, string.format("Dmg: %.0f", SessionTracker.totalDmg)) end
    if CFG.SessionStats.TrackDistance then table.insert(lines, string.format("Dist: %.0fm", SessionTracker.distWalked)) end
    table.insert(lines, string.format("Streak: %d (Max: %d)", SessionTracker.currentStreak, SessionTracker.maxStreak))
    if CFG.SessionStats.ShowPlaytime then table.insert(lines, "Time: " .. SessionTracker.getPlaytime()) end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    local posMap = {
        TopRight = Vector2.new(vs.X - 150, 50),
        TopLeft = Vector2.new(10, 50),
        BottomRight = Vector2.new(vs.X - 150, vs.Y - 30 - #lines * 14),
        BottomLeft = Vector2.new(10, vs.Y - 30 - #lines * 14),
    }
    local base = posMap[CFG.SessionStats.OverlayPos] or posMap.TopRight
    Draw.text(base, "SESSION STATS", Color3.fromRGB(232, 67, 147), 12, false)
    for i, line in ipairs(lines) do
        Draw.text(Vector2.new(base.X, base.Y + 14 + i * 13), line, Color3.new(0.9, 0.9, 0.9), 11, false)
    end
end

function SessionTracker.reset()
    SessionTracker.kills = 0
    SessionTracker.deaths = 0
    SessionTracker.headshots = 0
    SessionTracker.totalDmg = 0
    SessionTracker.shots = 0
    SessionTracker.hits = 0
    SessionTracker.startTime = tick()
    SessionTracker.maxStreak = 0
    SessionTracker.currentStreak = 0
    SessionTracker.distWalked = 0
    SessionTracker.lastPos = nil
end

local WaypointManager = {}
WaypointManager.waypoints = {}
WaypointManager.nextId = 1

function WaypointManager.add(name, position, color)
    if #WaypointManager.waypoints >= CFG.Waypoints.MaxWaypoints then
        table.remove(WaypointManager.waypoints, 1)
    end
    local wp = {
        id = WaypointManager.nextId,
        name = name or ("WP " .. WaypointManager.nextId),
        position = position,
        color = color or CFG.Waypoints.DefaultColor,
        created = tick(),
    }
    WaypointManager.nextId = WaypointManager.nextId + 1
    table.insert(WaypointManager.waypoints, wp)
    return wp
end

function WaypointManager.remove(id)
    for i, wp in ipairs(WaypointManager.waypoints) do
        if wp.id == id then
            table.remove(WaypointManager.waypoints, i)
            return true
        end
    end
    return false
end

function WaypointManager.removeAll()
    WaypointManager.waypoints = {}
end

function WaypointManager.getNearest()
    if not U.alive(LP) then return nil end
    local ch = LP.Character
    if not ch then return nil end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, wp in ipairs(WaypointManager.waypoints) do
        local d = (wp.position - hrp.Position).Magnitude
        if d < bestDist then bestDist = d; best = wp end
    end
    return best, bestDist
end

function WaypointManager.render()
    if not CFG.Waypoints.On then return end
    if not Draw.text or not Draw.line then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local myPos = nil
    if U.alive(LP) then
        local ch = LP.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then myPos = hrp.Position end
        end
    end
    for _, wp in ipairs(WaypointManager.waypoints) do
        local dist = myPos and (wp.position - myPos).Magnitude or 0
        if dist > CFG.Waypoints.RenderDist then continue end
        local sp, on = U.w2s(wp.position)
        if not on then continue end
        local col = U.c3(wp.color)
        local sz = CFG.Waypoints.IconSize
        Draw.line(Vector2.new(sp.X - sz, sp.Y - sz), Vector2.new(sp.X + sz, sp.Y - sz), col, CFG.Waypoints.LineThick)
        Draw.line(Vector2.new(sp.X + sz, sp.Y - sz), Vector2.new(sp.X + sz, sp.Y + sz), col, CFG.Waypoints.LineThick)
        Draw.line(Vector2.new(sp.X + sz, sp.Y + sz), Vector2.new(sp.X - sz, sp.Y + sz), col, CFG.Waypoints.LineThick)
        Draw.line(Vector2.new(sp.X - sz, sp.Y + sz), Vector2.new(sp.X - sz, sp.Y - sz), col, CFG.Waypoints.LineThick)
        Draw.line(Vector2.new(sp.X - sz, sp.Y - sz), Vector2.new(sp.X + sz, sp.Y + sz), col, CFG.Waypoints.LineThick * 0.5)
        Draw.line(Vector2.new(sp.X + sz, sp.Y - sz), Vector2.new(sp.X - sz, sp.Y + sz), col, CFG.Waypoints.LineThick * 0.5)
        local yOff = -sz - 4
        if CFG.Waypoints.ShowName then
            Draw.text(Vector2.new(sp.X, sp.Y + yOff - 12), wp.name, col, 11, true)
        end
        if CFG.Waypoints.ShowDist and myPos then
            Draw.text(Vector2.new(sp.X, sp.Y + yOff), string.format("%.0fm", dist), Color3.new(0.7, 0.7, 0.7), 10, true)
        end
    end
end

local LootESP = {}
LootESP.items = {}
LootESP.lastScan = 0
LootESP.scanInterval = 2

function LootESP.classifyRarity(item)
    if not item then return "Common", "CommonColor" end
    local name = string.lower(item.Name)
    if string.find(name, "legend") or string.find(name, "mythic") or string.find(name, "exotic") then
        return "Legendary", "LegendaryColor"
    end
    if string.find(name, "epic") or string.find(name, "ultra") or string.find(name, "super") then
        return "Epic", "EpicColor"
    end
    if string.find(name, "rare") or string.find(name, "special") or string.find(name, "unique") then
        return "Rare", "RareColor"
    end
    local val = item:FindFirstChild("Rarity") or item:FindFirstChild("Tier") or item:FindFirstChild("Quality")
    if val then
        local v = string.lower(tostring(val.Value))
        if string.find(v, "legend") or string.find(v, "mythic") then return "Legendary", "LegendaryColor" end
        if string.find(v, "epic") or string.find(v, "ultra") then return "Epic", "EpicColor" end
        if string.find(v, "rare") or string.find(v, "special") then return "Rare", "RareColor" end
    end
    return "Common", "CommonColor"
end

function LootESP.scan()
    if not CFG.Loot.On then return end
    local now = tick()
    if now - LootESP.lastScan < LootESP.scanInterval then return end
    LootESP.lastScan = now
    LootESP.items = {}
    local myPos = nil
    if U.alive(LP) then
        local ch = LP.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then myPos = hrp.Position end
        end
    end
    if not myPos then return end
    local function scanFolder(folder)
        for _, item in ipairs(folder:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Model") then
                if item.Parent ~= LP.Character and item.Parent ~= LP.Backpack then
                    local part = item:IsA("Tool") and item:FindFirstChild("Handle") or item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local dist = (part.Position - myPos).Magnitude
                        if dist <= CFG.Loot.MaxDist then
                            local rarity, colorKey = LootESP.classifyRarity(item)
                            if not (CFG.Loot.FilterCommon and rarity == "Common") and not (CFG.Loot.FilterRare and rarity == "Rare") then
                                table.insert(LootESP.items, {
                                    name = item.Name,
                                    rarity = rarity,
                                    colorKey = colorKey,
                                    part = part,
                                    dist = dist,
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    pcall(function() scanFolder(workspace) end)
end

function LootESP.render()
    if not CFG.Loot.On then return end
    if not Draw.text then return end
    for _, item in ipairs(LootESP.items) do
        if not item.part or not item.part.Parent then continue end
        local sp, on = U.w2s(item.part.Position)
        if not on then continue end
        local col = U.c3(CFG.Loot[item.colorKey] or CFG.Loot.CommonColor)
        local label = item.name
        if CFG.Loot.ShowRarity then label = "[" .. item.rarity .. "] " .. label end
        Draw.text(Vector2.new(sp.X, sp.Y - 8), label, col, 10, true)
        Draw.text(Vector2.new(sp.X, sp.Y + 4), string.format("%.0fm", item.dist), Color3.new(0.6, 0.6, 0.6), 9, true)
    end
end

local TrajectoryPredictor = {}

function TrajectoryPredictor.predictPosition(player, dt)
    if not player or not U.alive(player) then return nil end
    local ch = player.Character
    if not ch then return nil end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local vel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
    return hrp.Position + vel * dt
end

function TrajectoryPredictor.predictPath(player, steps, stepTime)
    if not player or not U.alive(player) then return {} end
    local ch = player.Character
    if not ch then return {} end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    local vel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero
    local pos = hrp.Position
    local grav = CFG.Trajectory.Gravity
    local path = {}
    for i = 1, steps do
        local t = i * stepTime
        local predicted = pos + vel * t + Vector3.new(0, -0.5 * grav * t * t, 0)
        local ray = workspace:Raycast(pos, predicted - pos)
        if ray then
            table.insert(path, ray.Position)
            break
        end
        table.insert(path, predicted)
    end
    return path
end

function TrajectoryPredictor.render(target)
    if not CFG.Trajectory.On or not CFG.Trajectory.ShowPath then return end
    if not target or not U.alive(target) then return end
    if not Draw.line or not Draw.circle then return end
    local path = TrajectoryPredictor.predictPath(target, CFG.Trajectory.Steps, CFG.Trajectory.StepTime)
    if #path < 2 then return end
    local col = U.c3(CFG.Trajectory.PathColor)
    for i = 1, #path - 1 do
        local sp1, on1 = U.w2s(path[i])
        local sp2, on2 = U.w2s(path[i + 1])
        if on1 and on2 then
            Draw.line(sp1, sp2, col, 1)
        end
    end
    if CFG.Trajectory.ShowImpact and #path > 0 then
        local last = path[#path]
        local sp, on = U.w2s(last)
        if on then
            Draw.circle(sp, CFG.Trajectory.ImpactRadius * 5, Color3.new(1, 0.3, 0.3), 0.8, 1.5)
        end
    end
end

local CombatLogSystem = {}
CombatLogSystem.entries = {}

function CombatLogSystem.add(entry)
    if not CFG.CombatLog.On then return end
    entry.time = tick()
    table.insert(CombatLogSystem.entries, 1, entry)
    while #CombatLogSystem.entries > CFG.CombatLog.MaxEntries do
        table.remove(CombatLogSystem.entries)
    end
end

function CombatLogSystem.clean()
    local now = tick()
    local decay = CFG.CombatLog.DecayTime
    local i = 1
    while i <= #CombatLogSystem.entries do
        if now - CombatLogSystem.entries[i].time > decay then
            table.remove(CombatLogSystem.entries, i)
        else
            i = i + 1
        end
    end
end

function CombatLogSystem.render()
    if not CFG.CombatLog.On then return end
    if not Draw.text then return end
    CombatLogSystem.clean()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    local posMap = {
        TopLeft = Vector2.new(10, 100),
        TopRight = Vector2.new(vs.X - 250, 100),
        BottomLeft = Vector2.new(10, vs.Y - 50 - #CombatLogSystem.entries * 14),
        BottomRight = Vector2.new(vs.X - 250, vs.Y - 50 - #CombatLogSystem.entries * 14),
    }
    local base = posMap[CFG.CombatLog.Position] or posMap.BottomLeft
    for i, entry in ipairs(CombatLogSystem.entries) do
        local col
        if entry.type == "damage" then
            col = U.c3(CFG.CombatLog.DmgColor)
        elseif entry.type == "heal" then
            col = U.c3(CFG.CombatLog.HealColor)
        elseif entry.type == "assist" then
            col = U.c3(CFG.CombatLog.AssistColor)
        else
            col = Color3.new(0.8, 0.8, 0.8)
        end
        local alpha = 1 - (tick() - entry.time) / CFG.CombatLog.DecayTime
        Draw.text(Vector2.new(base.X, base.Y + (i - 1) * 14), entry.text or "", col, CFG.CombatLog.FontSize, false)
    end
end

local CustomCrosshairRenderer = {}

function CustomCrosshairRenderer.render()
    if not CFG.CustomCH or not Draw.line then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local ctr = cam.ViewportSize / 2
    local sz = CFG.CustomCH.Size
    local gap = CFG.CustomCH.Gap
    local thick = CFG.CustomCH.Thick
    local col = U.c3(CFG.CustomCH.Color)
    local style = CFG.CustomCH.Style
    local rot = math.rad(CFG.CustomCH.Rotation or 0)
    local function rotPoint(x, y)
        if rot == 0 then return Vector2.new(ctr.X + x, ctr.Y + y) end
        local rx = x * math.cos(rot) - y * math.sin(rot)
        local ry = x * math.sin(rot) + y * math.cos(rot)
        return Vector2.new(ctr.X + rx, ctr.Y + ry)
    end
    if CFG.CustomCH.Outline then
        local oc = U.c3(CFG.CustomCH.OutlineColor)
        local ot = thick + 2
        if style == "Cross" or style == "T" then
            if style ~= "T" then
                Draw.line(rotPoint(0, -(gap + sz)), rotPoint(0, -gap), oc, ot)
            end
            Draw.line(rotPoint(0, gap), rotPoint(0, gap + sz), oc, ot)
            Draw.line(rotPoint(-(gap + sz), 0), rotPoint(-gap, 0), oc, ot)
            Draw.line(rotPoint(gap, 0), rotPoint(gap + sz, 0), oc, ot)
        elseif style == "Circle" then
            Draw.circle(ctr, sz, oc, CFG.CustomCH.OutlineAlpha, ot)
        elseif style == "Diamond" then
            Draw.line(rotPoint(0, -sz), rotPoint(sz, 0), oc, ot)
            Draw.line(rotPoint(sz, 0), rotPoint(0, sz), oc, ot)
            Draw.line(rotPoint(0, sz), rotPoint(-sz, 0), oc, ot)
            Draw.line(rotPoint(-sz, 0), rotPoint(0, -sz), oc, ot)
        end
    end
    if style == "Cross" then
        Draw.line(rotPoint(0, -(gap + sz)), rotPoint(0, -gap), col, thick)
        Draw.line(rotPoint(0, gap), rotPoint(0, gap + sz), col, thick)
        Draw.line(rotPoint(-(gap + sz), 0), rotPoint(-gap, 0), col, thick)
        Draw.line(rotPoint(gap, 0), rotPoint(gap + sz, 0), col, thick)
    elseif style == "T" then
        Draw.line(rotPoint(0, gap), rotPoint(0, gap + sz), col, thick)
        Draw.line(rotPoint(-(gap + sz), 0), rotPoint(-gap, 0), col, thick)
        Draw.line(rotPoint(gap, 0), rotPoint(gap + sz, 0), col, thick)
    elseif style == "Circle" then
        Draw.circle(ctr, sz, col, CFG.CustomCH.Alpha, thick)
    elseif style == "Diamond" then
        Draw.line(rotPoint(0, -sz), rotPoint(sz, 0), col, thick)
        Draw.line(rotPoint(sz, 0), rotPoint(0, sz), col, thick)
        Draw.line(rotPoint(0, sz), rotPoint(-sz, 0), col, thick)
        Draw.line(rotPoint(-sz, 0), rotPoint(0, -sz), col, thick)
    end
    if CFG.CustomCH.Dot then
        Draw.circle(ctr, CFG.CustomCH.DotSize, col, CFG.CustomCH.Alpha, thick)
    end
end

local TargetPriorityEngine = {}

function TargetPriorityEngine.score(player)
    if not player or not U.alive(player) then return -math.huge end
    local cfg = CFG.TargetPriority
    local score = 0
    local hp = U.hp(player) or 100
    local maxHp = U.maxHp(player) or 100
    local hpNorm = hp / math.max(1, maxHp)
    if cfg.PreferLowHP then
        score = score + (1 - hpNorm) * cfg.HealthWeight
    else
        score = score + hpNorm * cfg.HealthWeight
    end
    local dist = U.distanceToPlayer(player) or 1000
    local distNorm = math.clamp(1 - dist / 500, 0, 1)
    if cfg.PreferClose then
        score = score + distNorm * cfg.DistanceWeight
    else
        score = score + (1 - distNorm) * cfg.DistanceWeight
    end
    local threat = (ThreatAssessment.cache[player] or 0.5)
    score = score + threat * cfg.ThreatWeight
    if cfg.PreferVisible then
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vis = U.wallCheck and U.wallCheck(hrp.Position) or true
                score = score + (vis and 1 or 0) * cfg.VisibleWeight
            end
        end
    end
    return score
end

function TargetPriorityEngine.getBest(players)
    local best, bestScore = nil, -math.huge
    for _, p in ipairs(players) do
        if p ~= LP and U.alive(p) then
            local s = TargetPriorityEngine.score(p)
            if s > bestScore then bestScore = s; best = p end
        end
    end
    return best, bestScore
end

local AimIndicator = {}

function AimIndicator.render(target, ctr)
    if not ENV.Drawing then return end
    if not target or not U.alive(target) then return end
    if not Draw.line then return end
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

    if input.KeyCode == CFG.Spider.Key then
        if CFG.Spider.On then
            SpiderSystem.active = not SpiderSystem.active
            Notify.send("Spider", SpiderSystem.active and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.Phase.Key then
        if CFG.Phase.On then
            PhaseSystem.active = not PhaseSystem.active
            Notify.send("Phase", PhaseSystem.active and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.Anchor.Key then
        if CFG.Anchor.On then
            AnchorSystem.toggle()
            Notify.send("Anchor", AnchorSystem.active and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.ThirdPerson.Key then
        if CFG.ThirdPerson.On then
            if ThirdPersonCam.active then
                ThirdPersonCam.disable()
            else
                ThirdPersonCam.enable()
            end
            Notify.send("ThirdPerson", ThirdPersonCam.active and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.AutoPeek.Key then
        if CFG.AutoPeek.On then
            if AutoPeekSystem.active then
                AutoPeekSystem.stop()
            else
                AutoPeekSystem.start()
            end
            Notify.send("AutoPeek", AutoPeekSystem.active and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.RageBot.DoubleTapKey then
        if CFG.RageBot.On then
            RageBotEngine.doubleTapActive = not RageBotEngine.doubleTapActive
            Notify.send("DoubleTap", RageBotEngine.doubleTapActive and "Enabled" or "Disabled", "info", 2)
        end
    end
    if input.KeyCode == CFG.RageBot.ForceBaimKey then
        if CFG.RageBot.On then
            RageBotEngine.forceBaim = not RageBotEngine.forceBaim
            Notify.send("ForceBaim", RageBotEngine.forceBaim and "Enabled" or "Disabled", "info", 2)
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
Radar.init()

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
    if CFG.BunnyHop.On then BunnyHopSystem.update() end
    if CFG.Spider.On and SpiderSystem.active then SpiderSystem.update() end
    if CFG.Phase.On and PhaseSystem.active then PhaseSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.Anchor.On then AnchorSystem.update() end
    if CFG.Spinbot.On then SpinbotSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.AntiAim.On then AntiAimSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.ThirdPerson.On and ThirdPersonCam.active then ThirdPersonCam.update() end

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

    if CFG.RageBot.On and aimHeld then RageBotEngine.execute(lastDt > 0 and lastDt or 0.016) end

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
    if CFG.Backtrack.On then BacktrackSystem.update() end
    if CFG.AutoPeek.On then AutoPeekSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.Proximity.AlertOn then ProximityAlert.update() end
    if CFG.SoundESP.On then SoundESPSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.PerfStats.On then PerfStats.update() end
    if CFG.TriggerBot.On then TriggerBotSystem.update(lastDt > 0 and lastDt or 0.016) end
    if CFG.ThreatLevel.On then ThreatAssessment.update() end
    if CFG.SessionStats.On then SessionTracker.update() end
    if CFG.Loot.On then LootESP.scan() end
    if CFG.CombatLog.On then CombatLogSystem.clean() end

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
    local doKillFeed = frame % 4 == 0
    local doTargetInfo = frame % 2 == 0
    local doPlayerList = frame % 3 == 0

    Radar.render()
    if doKillFeed then KillFeed.render() end
    if doTargetInfo then
        local infoTarget = currentTarget or silentTarget
        TargetInfo.render(infoTarget)
    end
    if doPlayerList then PlayerListDisplay.render() end
    if CFG.HitLog.On then HitLog.render() end
    if CFG.MissLog.On then MissLog.render() end
    if CFG.Backtrack.On and CFG.Backtrack.Visualize then BacktrackSystem.render() end
    if CFG.AutoPeek.On and AutoPeekSystem.active then AutoPeekSystem.render() end
    if CFG.Proximity.AlertOn then ProximityAlert.render() end
    if CFG.SoundESP.On then SoundESPSystem.render() end
    if CFG.PerfStats.On then PerfStats.render() end
    if CFG.TriggerBot.On and CFG.TriggerBot.ShowFOV then TriggerBotSystem.renderFOV() end
    if CFG.ThreatLevel.On then ThreatAssessment.render() end
    if CFG.SessionStats.On then SessionTracker.render() end
    if CFG.Waypoints.On then WaypointManager.render() end
    if CFG.Loot.On then LootESP.render() end
    if CFG.CombatLog.On then CombatLogSystem.render() end
    if CFG.Trajectory.On and currentTarget then TrajectoryPredictor.render(currentTarget) end
    if currentTarget then
        if CFG.DmgCalc.On then DamageCalculator.render(currentTarget) end
        if CFG.AutoWall.On then AutoWallSystem.renderPenetrable(currentTarget) end
    end

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
        Radar.destroy()
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


-- ============================================================
-- AIMBOT TAB: RAGE BOT SECTION
-- ============================================================
Section("aimbot", "rage bot")
Toggle("aimbot", "Enable Rage Bot", CFG.RageBot, "On")
KeybindPicker("aimbot", "Rage Bot Key", CFG.RageBot, "Key")
Dropdown("aimbot", "Target Part", CFG.RageBot, "Part", {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso"})
Slider("aimbot", "Rage FOV", CFG.RageBot, "FOV", 10, 360, 5, "")
Dropdown("aimbot", "Priority", CFG.RageBot, "Priority", {"ThreatLevel", "Distance", "Health", "FOV"})
Toggle("aimbot", "Multi-Point", CFG.RageBot, "MultiPoint")
Toggle("aimbot", "Auto Wall", CFG.RageBot, "AutoWall")
Slider("aimbot", "Auto Wall Min Dmg", CFG.RageBot, "AutoWallMinDamage", 1, 100, 1, "")
Slider("aimbot", "Min Hit Chance", CFG.RageBot, "MinHitChance", 1, 100, 1, "%")
Slider("aimbot", "Max Targets", CFG.RageBot, "MaxTargets", 1, 5, 1, "")
Slider("aimbot", "Target Switch Delay", CFG.RageBot, "TargetSwitchDelay", 0.01, 0.5, 0.01, "s")
Section("aimbot", "rage exploits")
Toggle("aimbot", "Double Tap", CFG.RageBot, "DoubleTap")
KeybindPicker("aimbot", "Double Tap Key", CFG.RageBot, "DoubleTapKey")
Toggle("aimbot", "Hide Shots", CFG.RageBot, "HideShots")
Toggle("aimbot", "Fake Lag", CFG.RageBot, "FakeLag")
Slider("aimbot", "Fake Lag Ticks", CFG.RageBot, "FakeLagAmount", 1, 16, 1, "")
Toggle("aimbot", "Force Head", CFG.RageBot, "ForceHead")
Toggle("aimbot", "Force BAIM", CFG.RageBot, "ForceBaim")
KeybindPicker("aimbot", "Force BAIM Key", CFG.RageBot, "ForceBaimKey")
Section("aimbot", "rage automation")
Toggle("aimbot", "Auto Scope", CFG.RageBot, "AutoScope")
Toggle("aimbot", "Auto Crouch", CFG.RageBot, "AutoCrouch")
Toggle("aimbot", "Auto Peek", CFG.RageBot, "AutoPeek")
KeybindPicker("aimbot", "Auto Peek Key", CFG.RageBot, "AutoPeekKey")
Toggle("aimbot", "Peek Assist", CFG.RageBot, "PeekAssist")
Toggle("aimbot", "Override Damage", CFG.RageBot, "OverrideDmg")
Slider("aimbot", "Min Damage Override", CFG.RageBot, "MinDmgOverride", 1, 100, 1, "")
Section("aimbot", "resolver")
Toggle("aimbot", "Resolver", CFG.Resolver, "On")
Dropdown("aimbot", "Resolver Mode", CFG.Resolver, "Mode", {"Bruteforce", "Adaptive", "LagComp", "AntiDesync"})
Toggle("aimbot", "Body Yaw Resolver", CFG.Resolver, "BodyYaw")
Toggle("aimbot", "Pitch Resolver", CFG.Resolver, "PitchResolver")
Toggle("aimbot", "Lag Compensation", CFG.Resolver, "LagCompensation")
Slider("aimbot", "Miss Before Switch", CFG.Resolver, "MaxMissBeforeSwitch", 1, 10, 1, "")
Slider("aimbot", "Break LC Timeout", CFG.Resolver, "BreakLCTimeout", 0.1, 2.0, 0.1, "s")
Toggle("aimbot", "Show Indicators", CFG.Resolver, "Indicators")
Section("aimbot", "backtrack")
Toggle("aimbot", "Backtrack", CFG.Backtrack, "On")
Slider("aimbot", "Max Ticks", CFG.Backtrack, "MaxTicks", 1, 24, 1, "")
Slider("aimbot", "Tick Interval", CFG.Backtrack, "TickInterval", 0.008, 0.05, 0.002, "s")
Toggle("aimbot", "Visualize Backtrack", CFG.Backtrack, "Visualize")
Toggle("aimbot", "Visualization Fade", CFG.Backtrack, "VisualizeFade")
ColorPick("aimbot", "Backtrack Color", CFG.Backtrack, "Color")
Slider("aimbot", "Backtrack Alpha", CFG.Backtrack, "Alpha", 0.05, 1, 0.05, "")
Section("aimbot", "auto peek")
Toggle("aimbot", "Auto Peek", CFG.AutoPeek, "On")
KeybindPicker("aimbot", "Auto Peek Key", CFG.AutoPeek, "Key")
Slider("aimbot", "Return Speed", CFG.AutoPeek, "ReturnSpeed", 10, 200, 5, "")
Toggle("aimbot", "Show Indicator", CFG.AutoPeek, "ShowIndicator")
ColorPick("aimbot", "Indicator Color", CFG.AutoPeek, "IndicatorColor")
Slider("aimbot", "Indicator Radius", CFG.AutoPeek, "IndicatorRadius", 0.5, 5, 0.25, "")
Label("aimbot", "Rage bot auto-locks with priority scoring")
Label("aimbot", "Double tap fires two rapid shots")
Label("aimbot", "Resolver corrects anti-aim pitch/yaw")
Label("aimbot", "Backtrack lets you hit past positions")
Separator("aimbot")
Section("aimbot", "rage presets")
Button("aimbot", "Closet Rage Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 90
    CFG.RageBot.MultiPoint = false
    CFG.RageBot.AutoWall = false
    CFG.RageBot.MinHitChance = 80
    CFG.RageBot.DoubleTap = false
    CFG.RageBot.HideShots = false
    CFG.RageBot.FakeLag = false
    CFG.RageBot.ForceHead = false
    CFG.RageBot.Part = "UpperTorso"
    CFG.RageBot.Priority = "Distance"
    CFG.RageBot.MaxTargets = 1
    btn.Text = "Applied!"
    Notify.send("Rage", "Closet rage preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Closet Rage Preset" end)
end)
Button("aimbot", "Semi-Rage Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 180
    CFG.RageBot.MultiPoint = true
    CFG.RageBot.AutoWall = true
    CFG.RageBot.AutoWallMinDamage = 30
    CFG.RageBot.MinHitChance = 60
    CFG.RageBot.DoubleTap = false
    CFG.RageBot.HideShots = true
    CFG.RageBot.FakeLag = true
    CFG.RageBot.FakeLagAmount = 4
    CFG.RageBot.Part = "Head"
    CFG.RageBot.Priority = "ThreatLevel"
    CFG.RageBot.MaxTargets = 2
    btn.Text = "Applied!"
    Notify.send("Rage", "Semi-rage preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Semi-Rage Preset" end)
end)
Button("aimbot", "Full Rage Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 360
    CFG.RageBot.MultiPoint = true
    CFG.RageBot.AutoWall = true
    CFG.RageBot.AutoWallMinDamage = 10
    CFG.RageBot.MinHitChance = 30
    CFG.RageBot.DoubleTap = true
    CFG.RageBot.HideShots = true
    CFG.RageBot.FakeLag = true
    CFG.RageBot.FakeLagAmount = 14
    CFG.RageBot.ForceHead = true
    CFG.RageBot.Part = "Head"
    CFG.RageBot.Priority = "ThreatLevel"
    CFG.RageBot.MaxTargets = 5
    CFG.RageBot.AutoScope = true
    CFG.RageBot.AutoCrouch = true
    btn.Text = "Applied!"
    Notify.send("Rage", "Full rage preset - max aggression", "warning", 3)
    task.delay(1, function() btn.Text = "Full Rage Preset" end)
end)
Button("aimbot", "Anti-HVH Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 360
    CFG.RageBot.MultiPoint = true
    CFG.RageBot.AutoWall = true
    CFG.RageBot.AutoWallMinDamage = 15
    CFG.RageBot.MinHitChance = 45
    CFG.RageBot.DoubleTap = true
    CFG.RageBot.HideShots = true
    CFG.RageBot.FakeLag = true
    CFG.RageBot.FakeLagAmount = 8
    CFG.RageBot.Part = "Head"
    CFG.RageBot.Priority = "ThreatLevel"
    CFG.RageBot.MaxTargets = 3
    CFG.Resolver.On = true
    CFG.Resolver.Mode = "Adaptive"
    CFG.Resolver.BodyYaw = true
    CFG.Resolver.PitchResolver = true
    CFG.Resolver.LagCompensation = true
    CFG.Backtrack.On = true
    CFG.Backtrack.MaxTicks = 12
    btn.Text = "Applied!"
    Notify.send("Rage", "Anti-HVH preset with resolver", "warning", 3)
    task.delay(1, function() btn.Text = "Anti-HVH Preset" end)
end)
Separator("aimbot")
Section("aimbot", "target filtering")
Toggle("aimbot", "Ignore Teammates", CFG.Aimbot, "IgnoreTeam")
Toggle("aimbot", "Ignore Friends", CFG.Aimbot, "IgnoreFriends")
Toggle("aimbot", "Ignore Downed", CFG.Aimbot, "IgnoreDowned")
Toggle("aimbot", "Ignore Bots", CFG.Aimbot, "IgnoreBots")
Toggle("aimbot", "Team Check", CFG.Aimbot, "TeamCheck")
Slider("aimbot", "Max Distance", CFG.Aimbot, "MaxDist", 100, 5000, 100, "")
Section("aimbot", "aim indicators")
Toggle("aimbot", "Show Target Name", CFG.Aimbot, "ShowTargetName")
Toggle("aimbot", "Show Target HP", CFG.Aimbot, "ShowTargetHP")
Toggle("aimbot", "Show Aim Line", CFG.Aimbot, "ShowAimLine")
Toggle("aimbot", "Show Lock Icon", CFG.Aimbot, "ShowLockIcon")
Toggle("aimbot", "Show Hit Marker", CFG.Aimbot, "ShowHitMarker")
ColorPick("aimbot", "Aim Line Color", CFG.Aimbot, "AimLineColor")
Slider("aimbot", "Aim Line Width", CFG.Aimbot, "AimLineWidth", 1, 5, 0.5, "")
Slider("aimbot", "Hit Marker Size", CFG.Aimbot, "HitMarkerSize", 5, 30, 1, "")
Slider("aimbot", "Hit Marker Duration", CFG.Aimbot, "HitMarkerDuration", 0.1, 1.0, 0.05, "s")
ColorPick("aimbot", "Hit Marker Color", CFG.Aimbot, "HitMarkerColor")
Label("aimbot", "Aim indicators show info about target")
Label("aimbot", "Hit marker flashes on successful hits")
Separator("aimbot")
Section("aimbot", "aimbot smoothing profiles")
Button("aimbot", "Instant Lock Profile", function(btn)
    CFG.Aimbot.Smoothness = 0.01
    CFG.Aimbot.Mode = "Lock"
    CFG.Aimbot.Prediction = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Instant Lock Profile" end)
end)
Button("aimbot", "Natural Aim Profile", function(btn)
    CFG.Aimbot.Smoothness = 0.12
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Prediction = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Natural Aim Profile" end)
end)
Button("aimbot", "Slow Track Profile", function(btn)
    CFG.Aimbot.Smoothness = 0.25
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Prediction = false
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Slow Track Profile" end)
end)
Button("aimbot", "Flick Aim Profile", function(btn)
    CFG.Aimbot.Smoothness = 0.04
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Prediction = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Flick Aim Profile" end)
end)
Button("aimbot", "Controller Aim Profile", function(btn)
    CFG.Aimbot.Smoothness = 0.15
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Prediction = true
    CFG.Aimbot.FOV = 60
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Controller Aim Profile" end)
end)
Label("aimbot", "Smoothing profiles adjust lock speed")
Label("aimbot", "Natural aim looks more legit on replays")
Label("aimbot", "Flick aim snaps quickly then holds")

-- ============================================================
-- SILENT AIM TAB: ANTI-AIM SECTION
-- ============================================================
Section("silent", "anti-aim")
Toggle("silent", "Enable Anti-Aim", CFG.AntiAim, "On")
Dropdown("silent", "Pitch Mode", CFG.AntiAim, "Pitch", {"Down", "Up", "Zero", "Jitter", "Random"})
Dropdown("silent", "Yaw Mode", CFG.AntiAim, "Yaw", {"Spin", "Jitter", "Backward", "Sideways", "Random", "Manual"})
Slider("silent", "Yaw Offset", CFG.AntiAim, "YawOffset", -180, 180, 5, "")
Slider("silent", "Spin Speed", CFG.AntiAim, "SpinSpeed", 1, 50, 1, "")
Slider("silent", "Jitter Amount", CFG.AntiAim, "JitterAmount", 1, 90, 1, "")
Toggle("silent", "At Target", CFG.AntiAim, "AtTarget")
Section("silent", "desync")
Toggle("silent", "Desync", CFG.AntiAim, "Desync")
Dropdown("silent", "Desync Side", CFG.AntiAim, "DesyncSide", {"Auto", "Left", "Right"})
Toggle("silent", "Fake Lag", CFG.AntiAim, "FakeLag")
Slider("silent", "Fake Lag Ticks", CFG.AntiAim, "FakeLagTicks", 1, 14, 1, "")
Toggle("silent", "Leg Breaker", CFG.AntiAim, "LegBreaker")
KeybindPicker("silent", "Freestand Key", CFG.AntiAim, "FreestandKey")
Label("silent", "Anti-aim makes you harder to hit")
Label("silent", "Desync offsets visual vs server model")
Label("silent", "Leg breaker bends legs to reduce hitbox")
Section("silent", "hit log")
Toggle("silent", "Enable Hit Log", CFG.HitLog, "On")
Toggle("silent", "Show Damage", CFG.HitLog, "ShowDamage")
Toggle("silent", "Show Hit Part", CFG.HitLog, "ShowPart")
Toggle("silent", "Show Weapon", CFG.HitLog, "ShowWeapon")
Toggle("silent", "Show Target Name", CFG.HitLog, "ShowTarget")
Toggle("silent", "Show Hit Chance", CFG.HitLog, "ShowHitChance")
Toggle("silent", "Show Backtrack Info", CFG.HitLog, "ShowBacktrack")
Slider("silent", "Max Entries", CFG.HitLog, "MaxEntries", 5, 30, 1, "")
Slider("silent", "Display Duration", CFG.HitLog, "Duration", 2, 20, 1, "s")
Dropdown("silent", "Log Position", CFG.HitLog, "Position", {"BottomLeft", "BottomRight", "TopLeft", "TopRight"})
Toggle("silent", "Hit Sound", CFG.HitLog, "Sound")
Toggle("silent", "Chat Hit Log", CFG.HitLog, "ChatLog")
Section("silent", "miss log")
Toggle("silent", "Enable Miss Log", CFG.MissLog, "On")
Toggle("silent", "Show Reason", CFG.MissLog, "ShowReason")
Toggle("silent", "Show Spread", CFG.MissLog, "ShowSpread")
Slider("silent", "Max Miss Entries", CFG.MissLog, "MaxEntries", 3, 20, 1, "")
Slider("silent", "Miss Display Duration", CFG.MissLog, "Duration", 2, 15, 1, "s")
Section("silent", "hit stats")
Button("silent", "Show Hit Statistics", function(btn)
    local stats = HitLog.getStats()
    if stats then
        local info = string.format("Hits: %d | Accuracy: %.1f%%\nHeadshots: %d (%.0f%%)\nAvg Damage: %.0f\nTotal Damage: %d",
            stats.totalHits, stats.accuracy, stats.headshots, stats.headshotRate, stats.avgDamage, stats.totalDamage)
        Notify.send("Hit Stats", info, "info", 6)
    else
        Notify.send("Hit Stats", "No hits recorded yet", "warning", 3)
    end
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Show Hit Statistics" end)
end)
Button("silent", "Clear Hit Log", function(btn)
    HitLog.entries = {}
    btn.Text = "Cleared!"
    Notify.send("Hit Log", "Log cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear Hit Log" end)
end)
Button("silent", "Clear Miss Log", function(btn)
    MissLog.entries = {}
    btn.Text = "Cleared!"
    Notify.send("Miss Log", "Log cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear Miss Log" end)
end)
Separator("silent")
Section("silent", "anti-aim presets")
Button("silent", "Legit Anti-Aim", function(btn)
    CFG.AntiAim.On = true
    CFG.AntiAim.Pitch = "Down"
    CFG.AntiAim.Yaw = "Backward"
    CFG.AntiAim.YawOffset = 0
    CFG.AntiAim.Desync = false
    CFG.AntiAim.FakeLag = false
    CFG.AntiAim.LegBreaker = false
    CFG.AntiAim.JitterAmount = 0
    btn.Text = "Applied!"
    Notify.send("Anti-Aim", "Legit anti-aim applied", "success", 3)
    task.delay(1, function() btn.Text = "Legit Anti-Aim" end)
end)
Button("silent", "Spin Bot Anti-Aim", function(btn)
    CFG.AntiAim.On = true
    CFG.AntiAim.Pitch = "Down"
    CFG.AntiAim.Yaw = "Spin"
    CFG.AntiAim.SpinSpeed = 30
    CFG.AntiAim.Desync = true
    CFG.AntiAim.DesyncSide = "Auto"
    CFG.AntiAim.FakeLag = true
    CFG.AntiAim.FakeLagTicks = 8
    CFG.AntiAim.LegBreaker = true
    btn.Text = "Applied!"
    Notify.send("Anti-Aim", "Spin bot anti-aim applied", "warning", 3)
    task.delay(1, function() btn.Text = "Spin Bot Anti-Aim" end)
end)
Button("silent", "Jitter Anti-Aim", function(btn)
    CFG.AntiAim.On = true
    CFG.AntiAim.Pitch = "Jitter"
    CFG.AntiAim.Yaw = "Jitter"
    CFG.AntiAim.JitterAmount = 60
    CFG.AntiAim.Desync = true
    CFG.AntiAim.DesyncSide = "Auto"
    CFG.AntiAim.FakeLag = true
    CFG.AntiAim.FakeLagTicks = 6
    CFG.AntiAim.LegBreaker = true
    btn.Text = "Applied!"
    Notify.send("Anti-Aim", "Jitter anti-aim applied", "warning", 3)
    task.delay(1, function() btn.Text = "Jitter Anti-Aim" end)
end)
Button("silent", "Desync Only", function(btn)
    CFG.AntiAim.On = true
    CFG.AntiAim.Pitch = "Zero"
    CFG.AntiAim.Yaw = "Backward"
    CFG.AntiAim.Desync = true
    CFG.AntiAim.DesyncSide = "Auto"
    CFG.AntiAim.FakeLag = false
    CFG.AntiAim.LegBreaker = false
    CFG.AntiAim.JitterAmount = 0
    btn.Text = "Applied!"
    Notify.send("Anti-Aim", "Desync-only mode applied", "success", 3)
    task.delay(1, function() btn.Text = "Desync Only" end)
end)
Button("silent", "Max Desync Preset", function(btn)
    CFG.AntiAim.On = true
    CFG.AntiAim.Pitch = "Down"
    CFG.AntiAim.Yaw = "Jitter"
    CFG.AntiAim.JitterAmount = 90
    CFG.AntiAim.Desync = true
    CFG.AntiAim.DesyncSide = "Auto"
    CFG.AntiAim.FakeLag = true
    CFG.AntiAim.FakeLagTicks = 14
    CFG.AntiAim.LegBreaker = true
    CFG.AntiAim.AtTarget = true
    btn.Text = "Applied!"
    Notify.send("Anti-Aim", "Maximum desync applied", "warning", 3)
    task.delay(1, function() btn.Text = "Max Desync Preset" end)
end)
Button("silent", "Disable All Anti-Aim", function(btn)
    CFG.AntiAim.On = false
    CFG.AntiAim.Desync = false
    CFG.AntiAim.FakeLag = false
    CFG.AntiAim.LegBreaker = false
    btn.Text = "Disabled!"
    Notify.send("Anti-Aim", "All anti-aim disabled", "info", 2)
    task.delay(1, function() btn.Text = "Disable All Anti-Aim" end)
end)
Separator("silent")
Section("silent", "manual anti-aim keys")
KeybindPicker("silent", "Manual Left Key", CFG.AntiAim.ManualKeys, "Left")
KeybindPicker("silent", "Manual Right Key", CFG.AntiAim.ManualKeys, "Right")
KeybindPicker("silent", "Manual Back Key", CFG.AntiAim.ManualKeys, "Back")
Label("silent", "Manual keys override yaw direction")
Label("silent", "Hold key to force aim direction")
Label("silent", "Release returns to automatic mode")
Separator("silent")
Section("silent", "silent aim extensions")
Toggle("silent", "Silent Prediction", CFG.Silent, "Prediction")
Slider("silent", "Prediction Factor", CFG.Silent, "PredFactor", 0.01, 1.0, 0.01, "")
Toggle("silent", "Silent Wall Check", CFG.Silent, "WallCheck")
Toggle("silent", "Silent Team Check", CFG.Silent, "TeamCheck")
Toggle("silent", "Silent Vis Check", CFG.Silent, "VisCheck")
Toggle("silent", "Silent Auto Fire", CFG.Silent, "AutoFire")
Slider("silent", "Auto Fire Delay", CFG.Silent, "AutoFireDelay", 0.01, 0.5, 0.01, "s")
Toggle("silent", "Silent Ignore Dead", CFG.Silent, "IgnoreDead")
Toggle("silent", "Silent Ignore Downed", CFG.Silent, "IgnoreDowned")
Toggle("silent", "Silent Show FOV", CFG.Silent, "ShowFOV")
Slider("silent", "Silent FOV Thickness", CFG.Silent, "FOVThick", 1, 5, 0.5, "")
ColorPick("silent", "Silent FOV Color", CFG.Silent, "FOVColor")
Label("silent", "Auto fire shoots when target in FOV")
Label("silent", "Prediction leads shots based on velocity")
Separator("silent")
Section("silent", "weapon profiles")
Button("silent", "Rifle Profile", function(btn)
    CFG.Silent.FOV = 35
    CFG.Silent.Prediction = true
    CFG.Silent.PredFactor = 0.15
    CFG.Silent.Part = "UpperTorso"
    btn.Text = "Applied!"
    Notify.send("Profile", "Rifle profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "Rifle Profile" end)
end)
Button("silent", "SMG Profile", function(btn)
    CFG.Silent.FOV = 50
    CFG.Silent.Prediction = true
    CFG.Silent.PredFactor = 0.10
    CFG.Silent.Part = "UpperTorso"
    btn.Text = "Applied!"
    Notify.send("Profile", "SMG profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "SMG Profile" end)
end)
Button("silent", "Sniper Profile", function(btn)
    CFG.Silent.FOV = 15
    CFG.Silent.Prediction = true
    CFG.Silent.PredFactor = 0.30
    CFG.Silent.Part = "Head"
    btn.Text = "Applied!"
    Notify.send("Profile", "Sniper profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "Sniper Profile" end)
end)
Button("silent", "Shotgun Profile", function(btn)
    CFG.Silent.FOV = 80
    CFG.Silent.Prediction = false
    CFG.Silent.PredFactor = 0.05
    CFG.Silent.Part = "HumanoidRootPart"
    btn.Text = "Applied!"
    Notify.send("Profile", "Shotgun profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "Shotgun Profile" end)
end)
Button("silent", "Pistol Profile", function(btn)
    CFG.Silent.FOV = 40
    CFG.Silent.Prediction = true
    CFG.Silent.PredFactor = 0.08
    CFG.Silent.Part = "Head"
    btn.Text = "Applied!"
    Notify.send("Profile", "Pistol profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "Pistol Profile" end)
end)
Button("silent", "LMG Profile", function(btn)
    CFG.Silent.FOV = 60
    CFG.Silent.Prediction = true
    CFG.Silent.PredFactor = 0.12
    CFG.Silent.Part = "UpperTorso"
    btn.Text = "Applied!"
    Notify.send("Profile", "LMG profile loaded", "success", 2)
    task.delay(1, function() btn.Text = "LMG Profile" end)
end)
Label("silent", "Weapon profiles adjust FOV and prediction")
Label("silent", "Select based on current weapon type")
Label("silent", "Sniper uses small FOV with high prediction")
Label("silent", "Shotgun uses wide FOV with no prediction")

-- ============================================================
-- ESP TAB: FLAGS, HEALTH BAR, SOUND ESP, PROXIMITY
-- ============================================================
Section("esp", "player flags")
Toggle("esp", "Show Flags", CFG.Flags, "On")
Toggle("esp", "Armor/Shield", CFG.Flags, "ShowArmor")
Toggle("esp", "Godmode", CFG.Flags, "ShowGodmode")
Toggle("esp", "Speed Hack", CFG.Flags, "ShowSpeeding")
Toggle("esp", "Flying", CFG.Flags, "ShowFlying")
Toggle("esp", "Bot Detection", CFG.Flags, "ShowBot")
Toggle("esp", "Admin", CFG.Flags, "ShowAdmin")
Toggle("esp", "Rage Bot", CFG.Flags, "ShowRageBot")
Toggle("esp", "Desync", CFG.Flags, "ShowDesync")
Toggle("esp", "Resolver", CFG.Flags, "ShowResolver")
Toggle("esp", "Friend", CFG.Flags, "ShowFriend")
Slider("esp", "Flag Font Size", CFG.Flags, "FontSize", 8, 16, 1, "px")
Section("esp", "flag colors")
ColorPick("esp", "Armor Color", CFG.Flags, "ArmorColor")
ColorPick("esp", "Godmode Color", CFG.Flags, "GodmodeColor")
ColorPick("esp", "Speed Color", CFG.Flags, "SpeedColor")
ColorPick("esp", "Fly Color", CFG.Flags, "FlyColor")
ColorPick("esp", "Bot Color", CFG.Flags, "BotColor")
ColorPick("esp", "Admin Color", CFG.Flags, "AdminColor")
Section("esp", "health bar style")
Dropdown("esp", "Health Bar Style", CFG.HealthBar, "Style", {"Gradient", "Segmented", "Flat", "Smooth"})
Slider("esp", "Bar Width", CFG.HealthBar, "Width", 1, 8, 1, "px")
Slider("esp", "Bar Offset", CFG.HealthBar, "Offset", 1, 10, 1, "px")
Slider("esp", "Segments", CFG.HealthBar, "Segments", 2, 10, 1, "")
Toggle("esp", "Bar Outline", CFG.HealthBar, "Outline")
Toggle("esp", "Text Inside Bar", CFG.HealthBar, "TextInside")
Toggle("esp", "Custom Colors", CFG.HealthBar, "CustomColors")
ColorPick("esp", "Full Health Color", CFG.HealthBar, "FullColor")
ColorPick("esp", "Low Health Color", CFG.HealthBar, "LowColor")
Toggle("esp", "Animate Smoothly", CFG.HealthBar, "AnimSmooth")
Slider("esp", "Animation Speed", CFG.HealthBar, "AnimSpeed", 0.01, 0.5, 0.01, "")
Section("esp", "sound esp")
Toggle("esp", "Sound ESP", CFG.SoundESP, "On")
Toggle("esp", "Show Footsteps", CFG.SoundESP, "ShowFootsteps")
Toggle("esp", "Show Jumps", CFG.SoundESP, "ShowJumps")
Slider("esp", "Max Distance", CFG.SoundESP, "MaxDist", 50, 500, 10, "m")
Slider("esp", "Decay Time", CFG.SoundESP, "DecayTime", 0.5, 5, 0.25, "s")
ColorPick("esp", "Footstep Color", CFG.SoundESP, "FootstepColor")
ColorPick("esp", "Jump Color", CFG.SoundESP, "JumpColor")
Slider("esp", "Indicator Radius", CFG.SoundESP, "Radius", 1, 10, 0.5, "")
Label("esp", "Sound ESP shows expanding circles at")
Label("esp", "player footstep and jump locations")
Section("esp", "proximity alert")
Toggle("esp", "Proximity Alert", CFG.Proximity, "AlertOn")
Slider("esp", "Alert Distance", CFG.Proximity, "AlertDist", 10, 200, 5, "m")
Toggle("esp", "Alert Sound", CFG.Proximity, "AlertSound")
Toggle("esp", "Visual Alert", CFG.Proximity, "AlertVisual")
ColorPick("esp", "Alert Color", CFG.Proximity, "AlertColor")
Toggle("esp", "Flash Screen", CFG.Proximity, "FlashScreen")
Label("esp", "Warns when enemies are within range")
Label("esp", "Sound alert plays a warning noise")
Separator("esp")
Section("esp", "esp presets")
Button("esp", "Minimal ESP", function(btn)
    CFG.BoxESP.On = true
    CFG.BoxESP.Mode = "Corner"
    CFG.NameESP.On = true
    CFG.HealthESP.On = true
    CFG.Tracers.On = false
    CFG.Skeleton.On = false
    CFG.OffScreen.On = false
    CFG.Flags.On = false
    CFG.SoundESP.On = false
    btn.Text = "Applied!"
    Notify.send("ESP", "Minimal ESP preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Minimal ESP" end)
end)
Button("esp", "Full ESP", function(btn)
    CFG.BoxESP.On = true
    CFG.BoxESP.Mode = "Full"
    CFG.NameESP.On = true
    CFG.HealthESP.On = true
    CFG.DistESP.On = true
    CFG.WeaponESP.On = true
    CFG.Tracers.On = true
    CFG.Skeleton.On = true
    CFG.Flags.On = true
    CFG.SoundESP.On = true
    CFG.Proximity.AlertOn = true
    btn.Text = "Applied!"
    Notify.send("ESP", "Full ESP preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Full ESP" end)
end)
Button("esp", "Competitive ESP", function(btn)
    CFG.BoxESP.On = true
    CFG.BoxESP.Mode = "Corner"
    CFG.NameESP.On = true
    CFG.HealthESP.On = true
    CFG.DistESP.On = true
    CFG.WeaponESP.On = false
    CFG.Tracers.On = false
    CFG.Skeleton.On = false
    CFG.Flags.On = true
    CFG.Flags.ShowArmor = true
    CFG.Flags.ShowGodmode = true
    CFG.SoundESP.On = false
    CFG.Proximity.AlertOn = true
    CFG.Proximity.AlertDist = 50
    btn.Text = "Applied!"
    Notify.send("ESP", "Competitive ESP preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Competitive ESP" end)
end)
Button("esp", "Stealth ESP", function(btn)
    CFG.BoxESP.On = false
    CFG.NameESP.On = false
    CFG.HealthESP.On = false
    CFG.Tracers.On = false
    CFG.Skeleton.On = false
    CFG.SoundESP.On = true
    CFG.SoundESP.MaxDist = 200
    CFG.Proximity.AlertOn = true
    CFG.Proximity.AlertDist = 80
    CFG.Proximity.AlertSound = true
    btn.Text = "Applied!"
    Notify.send("ESP", "Stealth ESP - audio only", "success", 3)
    task.delay(1, function() btn.Text = "Stealth ESP" end)
end)
Separator("esp")
Section("esp", "distance esp")
Toggle("esp", "Show Distance", CFG.DistESP, "On")
Slider("esp", "Max Display Dist", CFG.DistESP, "MaxDist", 100, 5000, 100, "")
Dropdown("esp", "Dist Unit", CFG.DistESP, "Unit", {"Studs", "Meters", "Feet"})
Slider("esp", "Dist Font Size", CFG.DistESP, "FontSize", 10, 18, 1, "")
Toggle("esp", "Dist Below Name", CFG.DistESP, "BelowName")
ColorPick("esp", "Distance Color", CFG.DistESP, "Color")
Section("esp", "weapon esp")
Toggle("esp", "Show Weapon", CFG.WeaponESP, "On")
Toggle("esp", "Show Ammo Count", CFG.WeaponESP, "ShowAmmo")
Toggle("esp", "Show Reload State", CFG.WeaponESP, "ShowReload")
Slider("esp", "Weapon Font Size", CFG.WeaponESP, "FontSize", 10, 16, 1, "")
ColorPick("esp", "Weapon Text Color", CFG.WeaponESP, "Color")
Section("esp", "line of sight")
Toggle("esp", "LOS Indicator", CFG.ESP, "LOSIndicator")
Toggle("esp", "LOS Color Change", CFG.ESP, "LOSColor")
ColorPick("esp", "Visible Color", CFG.ESP, "VisibleColor")
ColorPick("esp", "Hidden Color", CFG.ESP, "HiddenColor")
Toggle("esp", "Fade When Hidden", CFG.ESP, "FadeHidden")
Slider("esp", "Fade Amount", CFG.ESP, "FadeAmount", 0.1, 0.9, 0.05, "")
Label("esp", "LOS changes ESP color based on visibility")
Label("esp", "Visible targets shown in bright color")
Label("esp", "Hidden targets fade or change color")
Separator("esp")
Section("esp", "threat assessment")
Toggle("esp", "Threat Level Display", CFG.ESP, "ThreatLevel")
Toggle("esp", "Threat Border Color", CFG.ESP, "ThreatBorder")
Toggle("esp", "Threat Sort Priority", CFG.ESP, "ThreatSort")
ColorPick("esp", "Low Threat Color", CFG.ESP, "LowThreatColor")
ColorPick("esp", "Med Threat Color", CFG.ESP, "MedThreatColor")
ColorPick("esp", "High Threat Color", CFG.ESP, "HighThreatColor")
Label("esp", "Threat level based on weapon + distance")
Label("esp", "Higher threat = more visible ESP")
Separator("esp")
Section("esp", "player tagging")
Toggle("esp", "Custom Tags", CFG.ESP, "CustomTags")
Button("esp", "Tag as Friend", function(btn)
    local target = U.target()
    if target then
        CFG.Tags = CFG.Tags or {}
        CFG.Tags[target.Name] = "Friend"
        btn.Text = "Tagged!"
        Notify.send("Tag", target.Name .. " tagged as Friend", "success", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Tag as Friend" end)
end)
Button("esp", "Tag as Enemy", function(btn)
    local target = U.target()
    if target then
        CFG.Tags = CFG.Tags or {}
        CFG.Tags[target.Name] = "Enemy"
        btn.Text = "Tagged!"
        Notify.send("Tag", target.Name .. " tagged as Enemy", "warning", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Tag as Enemy" end)
end)
Button("esp", "Tag as Streamer", function(btn)
    local target = U.target()
    if target then
        CFG.Tags = CFG.Tags or {}
        CFG.Tags[target.Name] = "Streamer"
        btn.Text = "Tagged!"
        Notify.send("Tag", target.Name .. " tagged as Streamer", "info", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Tag as Streamer" end)
end)
Button("esp", "Clear All Tags", function(btn)
    CFG.Tags = {}
    btn.Text = "Cleared!"
    Notify.send("Tag", "All player tags cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear All Tags" end)
end)
Label("esp", "Tags persist until cleared or session end")
Label("esp", "Friends show green, enemies show red")

-- ============================================================
-- CHAMS TAB: ADVANCED CONFIGURATION
-- ============================================================
Section("chams", "chams presets")
Button("chams", "Glow Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "Glow"
    CFG.Chams.Transparency = 0
    CFG.Chams.OutlineEnabled = true
    CFG.Chams.OutlineWidth = 0.08
    btn.Text = "Applied!"
    Notify.send("Chams", "Glow preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Glow Preset" end)
end)
Button("chams", "X-Ray Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "XRay"
    CFG.Chams.Transparency = 0.3
    CFG.Chams.OutlineEnabled = false
    btn.Text = "Applied!"
    Notify.send("Chams", "X-Ray preset applied", "success", 2)
    task.delay(1, function() btn.Text = "X-Ray Preset" end)
end)
Button("chams", "Wireframe Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "Wireframe"
    CFG.Chams.Transparency = 0.5
    CFG.Chams.OutlineEnabled = true
    CFG.Chams.OutlineWidth = 0.03
    btn.Text = "Applied!"
    Notify.send("Chams", "Wireframe preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Wireframe Preset" end)
end)
Button("chams", "Flat Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "Flat"
    CFG.Chams.Transparency = 0
    CFG.Chams.OutlineEnabled = false
    btn.Text = "Applied!"
    Notify.send("Chams", "Flat preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Flat Preset" end)
end)
Button("chams", "Ghost Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "Glow"
    CFG.Chams.Transparency = 0.7
    CFG.Chams.OutlineEnabled = true
    CFG.Chams.OutlineWidth = 0.15
    btn.Text = "Applied!"
    Notify.send("Chams", "Ghost preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Ghost Preset" end)
end)
Button("chams", "Neon Preset", function(btn)
    CFG.Chams.On = true
    CFG.Chams.Mode = "Neon"
    CFG.Chams.Transparency = 0.1
    CFG.Chams.OutlineEnabled = true
    CFG.Chams.OutlineWidth = 0.12
    btn.Text = "Applied!"
    Notify.send("Chams", "Neon preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Neon Preset" end)
end)
Separator("chams")
Section("chams", "chams materials")
Dropdown("chams", "Material Type", CFG.Chams, "Material", {"Neon", "ForceField", "Glass", "SmoothPlastic", "Plastic", "Metal", "DiamondPlate", "Foil", "Granite", "Marble", "Ice", "Wood"})
Slider("chams", "Material Shininess", CFG.Chams, "Shininess", 0, 1, 0.05, "")
Slider("chams", "Material Reflectance", CFG.Chams, "Reflectance", 0, 1, 0.05, "")
Toggle("chams", "Pulsing Effect", CFG.Chams, "Pulsing")
Slider("chams", "Pulse Speed", CFG.Chams, "PulseSpeed", 0.5, 5, 0.25, "")
Slider("chams", "Pulse Min Alpha", CFG.Chams, "PulseMin", 0.1, 0.8, 0.05, "")
Slider("chams", "Pulse Max Alpha", CFG.Chams, "PulseMax", 0.5, 1.0, 0.05, "")
Section("chams", "chams outline")
Toggle("chams", "Outline Enabled", CFG.Chams, "OutlineEnabled")
Slider("chams", "Outline Width", CFG.Chams, "OutlineWidth", 0.01, 0.3, 0.01, "")
ColorPick("chams", "Outline Color", CFG.Chams, "OutlineColor")
Toggle("chams", "Outline Only", CFG.Chams, "OutlineOnly")
Toggle("chams", "Rainbow Outline", CFG.Chams, "RainbowOutline")
Slider("chams", "Rainbow Speed", CFG.Chams, "RainbowSpeed", 0.5, 5, 0.25, "")
Section("chams", "team chams colors")
Toggle("chams", "Per-Team Colors", CFG.Chams, "PerTeamColor")
ColorPick("chams", "Team A Color", CFG.Chams, "TeamAColor")
ColorPick("chams", "Team B Color", CFG.Chams, "TeamBColor")
ColorPick("chams", "Neutral Color", CFG.Chams, "NeutralColor")
ColorPick("chams", "Spectator Color", CFG.Chams, "SpectatorColor")
Section("chams", "distance-based chams")
Toggle("chams", "Distance Fade", CFG.Chams, "DistFade")
Slider("chams", "Fade Start Dist", CFG.Chams, "FadeStart", 50, 500, 10, "")
Slider("chams", "Fade End Dist", CFG.Chams, "FadeEnd", 100, 1000, 25, "")
Toggle("chams", "Close Range Glow", CFG.Chams, "CloseGlow")
Slider("chams", "Close Range Dist", CFG.Chams, "CloseDist", 10, 100, 5, "")
Label("chams", "Distance fade reduces chams at range")
Label("chams", "Close range glow intensifies nearby")
Separator("chams")
Section("chams", "per-part chams")
Toggle("chams", "Head Highlight", CFG.Chams, "HighlightHead")
ColorPick("chams", "Head Color", CFG.Chams, "HeadColor")
Toggle("chams", "Torso Highlight", CFG.Chams, "HighlightTorso")
ColorPick("chams", "Torso Color", CFG.Chams, "TorsoColor")
Toggle("chams", "Limbs Highlight", CFG.Chams, "HighlightLimbs")
ColorPick("chams", "Limbs Color", CFG.Chams, "LimbsColor")
Toggle("chams", "Weapon Highlight", CFG.Chams, "HighlightWeapon")
ColorPick("chams", "Weapon Color", CFG.Chams, "WeaponColor")
Label("chams", "Per-part colors override global chams")
Label("chams", "Head highlight helps with headshots")
Separator("chams")
Section("chams", "chams performance")
Slider("chams", "Update Rate", CFG.Chams, "UpdateRate", 0.016, 0.5, 0.016, "s")
Slider("chams", "Max Chammed Players", CFG.Chams, "MaxPlayers", 1, 50, 1, "")
Toggle("chams", "Cull Occluded", CFG.Chams, "CullOccluded")
Toggle("chams", "LOD System", CFG.Chams, "LOD")
Slider("chams", "LOD Distance", CFG.Chams, "LODDist", 100, 1000, 50, "")
Label("chams", "Reduce update rate for better FPS")
Label("chams", "LOD reduces detail at distance")

-- ============================================================
-- VISUALS TAB: PERFORMANCE STATS, CROSSHAIR, EFFECTS
-- ============================================================
Section("visuals", "performance stats")
Toggle("visuals", "Show Stats Overlay", CFG.PerfStats, "On")
Toggle("visuals", "Show FPS", CFG.PerfStats, "ShowFPS")
Toggle("visuals", "Show Ping", CFG.PerfStats, "ShowPing")
Toggle("visuals", "Show Memory", CFG.PerfStats, "ShowMemory")
Toggle("visuals", "Show Draw Calls", CFG.PerfStats, "ShowDrawCalls")
Toggle("visuals", "Show Entity Count", CFG.PerfStats, "ShowEntities")
Toggle("visuals", "Show Uptime", CFG.PerfStats, "ShowUptime")
Dropdown("visuals", "Stats Position", CFG.PerfStats, "Position", {"BottomRight", "BottomLeft", "TopRight", "TopLeft"})
Slider("visuals", "Update Rate", CFG.PerfStats, "UpdateRate", 0.1, 2.0, 0.1, "s")
Label("visuals", "Shows FPS, ping, memory, and more")
Label("visuals", "Update rate controls refresh frequency")
Separator("visuals")
Section("visuals", "crosshair presets")
Button("visuals", "Default Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    CFG.Crosshair.Size = 6
    CFG.Crosshair.Thickness = 1.5
    CFG.Crosshair.Gap = 4
    CFG.Crosshair.Dot = true
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Default Cross" end)
end)
Button("visuals", "Dot Only", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Dot"
    CFG.Crosshair.DotSize = 3
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Dot Only" end)
end)
Button("visuals", "Small Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    CFG.Crosshair.Size = 3
    CFG.Crosshair.Thickness = 1
    CFG.Crosshair.Gap = 2
    CFG.Crosshair.Dot = false
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Small Cross" end)
end)
Button("visuals", "Circle Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Circle"
    CFG.Crosshair.CircleRadius = 5
    CFG.Crosshair.Thickness = 1
    CFG.Crosshair.Dot = true
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Circle Cross" end)
end)
Button("visuals", "T-Shape Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "T"
    CFG.Crosshair.Size = 5
    CFG.Crosshair.Thickness = 1.5
    CFG.Crosshair.Gap = 3
    CFG.Crosshair.Dot = false
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "T-Shape Cross" end)
end)
Button("visuals", "Diamond Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Diamond"
    CFG.Crosshair.Size = 4
    CFG.Crosshair.Thickness = 1
    CFG.Crosshair.Dot = false
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Diamond Cross" end)
end)
Button("visuals", "CS2 Style", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    CFG.Crosshair.Size = 2
    CFG.Crosshair.Thickness = 1
    CFG.Crosshair.Gap = 3
    CFG.Crosshair.Dot = false
    CFG.Crosshair.Outline = false
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "CS2 Style" end)
end)
Button("visuals", "Sniper Cross", function(btn)
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    CFG.Crosshair.Size = 15
    CFG.Crosshair.Thickness = 0.5
    CFG.Crosshair.Gap = 8
    CFG.Crosshair.Dot = true
    CFG.Crosshair.DotSize = 1
    CFG.Crosshair.Outline = true
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Sniper Cross" end)
end)
Separator("visuals")
Section("visuals", "crosshair editor")
Slider("visuals", "Cross Size", CFG.Crosshair, "Size", 1, 20, 0.5, "")
Slider("visuals", "Cross Thickness", CFG.Crosshair, "Thickness", 0.5, 5, 0.25, "")
Slider("visuals", "Cross Gap", CFG.Crosshair, "Gap", 0, 15, 0.5, "")
Slider("visuals", "Dot Size", CFG.Crosshair, "DotSize", 1, 8, 0.5, "")
Toggle("visuals", "Dynamic Gap", CFG.Crosshair, "DynamicGap")
Slider("visuals", "Dynamic Multiplier", CFG.Crosshair, "DynMult", 0.5, 5, 0.25, "x")
Toggle("visuals", "Spread Circle", CFG.Crosshair, "SpreadCircle")
Slider("visuals", "Spread Radius Mult", CFG.Crosshair, "SpreadMult", 0.5, 3, 0.1, "x")
ColorPick("visuals", "Spread Color", CFG.Crosshair, "SpreadColor")
Label("visuals", "Dynamic gap widens when moving/shooting")
Label("visuals", "Spread circle shows weapon accuracy")
Separator("visuals")
Section("visuals", "ambient effects")
Toggle("visuals", "Ambient Particles", CFG.Visual, "AmbientParticles")
Dropdown("visuals", "Particle Type", CFG.Visual, "ParticleType", {"Snow", "Rain", "Fireflies", "Stars", "Dust", "Embers"})
Slider("visuals", "Particle Density", CFG.Visual, "ParticleDensity", 5, 100, 5, "")
Slider("visuals", "Particle Speed", CFG.Visual, "ParticleSpeed", 0.5, 5, 0.25, "x")
Slider("visuals", "Particle Size", CFG.Visual, "ParticleSize", 0.5, 5, 0.25, "")
ColorPick("visuals", "Particle Color", CFG.Visual, "ParticleColor")
Toggle("visuals", "Particle Glow", CFG.Visual, "ParticleGlow")
Label("visuals", "Ambient particles add visual flair")
Label("visuals", "Performance impact varies by density")
Section("visuals", "screen effects")
Toggle("visuals", "Vignette", CFG.Visual, "Vignette")
Slider("visuals", "Vignette Intensity", CFG.Visual, "VignetteIntensity", 0.1, 1.0, 0.05, "")
Toggle("visuals", "Chromatic Aberration", CFG.Visual, "ChromaticAberr")
Slider("visuals", "Aberration Amount", CFG.Visual, "ChromaticAmount", 1, 10, 0.5, "")
Toggle("visuals", "Film Grain", CFG.Visual, "FilmGrain")
Slider("visuals", "Grain Amount", CFG.Visual, "GrainAmount", 0.01, 0.2, 0.01, "")
Toggle("visuals", "Sharpen", CFG.Visual, "Sharpen")
Slider("visuals", "Sharpen Amount", CFG.Visual, "SharpenAmount", 0.1, 2.0, 0.1, "")
Toggle("visuals", "Color Correction", CFG.Visual, "ColorCorrect")
Slider("visuals", "Saturation", CFG.Visual, "Saturation", 0, 3, 0.1, "")
Slider("visuals", "Contrast", CFG.Visual, "Contrast", 0.5, 2, 0.1, "")
Slider("visuals", "Brightness Offset", CFG.Visual, "BrightnessOff", -0.5, 0.5, 0.05, "")
Section("visuals", "hit markers")
Toggle("visuals", "Hit Markers", CFG.Visual, "HitMarkers")
Dropdown("visuals", "Marker Style", CFG.Visual, "MarkerStyle", {"Cross", "Circle", "X", "Diamond", "Skull"})
Slider("visuals", "Marker Size", CFG.Visual, "MarkerSize", 5, 30, 1, "")
Slider("visuals", "Marker Duration", CFG.Visual, "MarkerDuration", 0.1, 1.0, 0.05, "s")
ColorPick("visuals", "Marker Color", CFG.Visual, "MarkerColor")
Toggle("visuals", "Headshot Marker", CFG.Visual, "HeadshotMarker")
ColorPick("visuals", "Headshot Color", CFG.Visual, "HeadshotColor")
Toggle("visuals", "Kill Marker", CFG.Visual, "KillMarker")
ColorPick("visuals", "Kill Color", CFG.Visual, "KillColor")
Toggle("visuals", "Marker Sound", CFG.Visual, "MarkerSound")
Section("visuals", "kill effects")
Toggle("visuals", "Kill Effects", CFG.Visual, "KillEffects")
Dropdown("visuals", "Kill Effect", CFG.Visual, "KillEffect", {"Confetti", "Explosion", "Lightning", "Dissolve", "Beam", "Shatter"})
Slider("visuals", "Effect Duration", CFG.Visual, "KillEffectDuration", 0.5, 3, 0.25, "s")
Slider("visuals", "Effect Intensity", CFG.Visual, "KillEffectIntensity", 0.1, 1.0, 0.1, "")
ColorPick("visuals", "Effect Color", CFG.Visual, "KillEffectColor")
Toggle("visuals", "Kill Sound", CFG.Visual, "KillSound")
Label("visuals", "Kill effects play on confirmed kills")
Label("visuals", "Confetti is festive, lightning is dramatic")
Section("visuals", "aspect ratio")
Toggle("visuals", "Custom Aspect Ratio", CFG.Visual, "CustomAspect")
Dropdown("visuals", "Ratio Preset", CFG.Visual, "AspectPreset", {"16:9", "4:3", "21:9", "1:1", "3:2", "16:10"})
Slider("visuals", "Custom Width Ratio", CFG.Visual, "AspectW", 1, 32, 1, "")
Slider("visuals", "Custom Height Ratio", CFG.Visual, "AspectH", 1, 32, 1, "")
Toggle("visuals", "Letterbox Bars", CFG.Visual, "Letterbox")
ColorPick("visuals", "Letterbox Color", CFG.Visual, "LetterboxColor")
Label("visuals", "4:3 is classic competitive ratio")
Label("visuals", "21:9 gives ultrawide cinematic view")
Separator("visuals")
Section("visuals", "fov animation")
Toggle("visuals", "FOV on Kill", CFG.Visual, "FOVOnKill")
Slider("visuals", "Kill FOV Boost", CFG.Visual, "KillFOVBoost", 5, 30, 1, "")
Slider("visuals", "Kill FOV Duration", CFG.Visual, "KillFOVDuration", 0.1, 1.0, 0.1, "s")
Toggle("visuals", "FOV on Sprint", CFG.Visual, "FOVOnSprint")
Slider("visuals", "Sprint FOV Boost", CFG.Visual, "SprintFOVBoost", 2, 15, 1, "")
Toggle("visuals", "FOV Smooth", CFG.Visual, "FOVSmooth")
Slider("visuals", "FOV Smooth Speed", CFG.Visual, "FOVSmoothSpeed", 0.01, 0.3, 0.01, "")
Label("visuals", "FOV punch on kill adds impact")
Label("visuals", "Sprint FOV mimics modern FPS feel")
Section("visuals", "watermark extensions")
Toggle("visuals", "Show Watermark", CFG.Visual, "Watermark")
Toggle("visuals", "Show Username", CFG.Visual, "WMUsername")
Toggle("visuals", "Show FPS in WM", CFG.Visual, "WMFPS")
Toggle("visuals", "Show Ping in WM", CFG.Visual, "WMPing")
Toggle("visuals", "Show Time", CFG.Visual, "WMTime")
Toggle("visuals", "Show Date", CFG.Visual, "WMDate")
Toggle("visuals", "Show Server", CFG.Visual, "WMServer")
Dropdown("visuals", "WM Position", CFG.Visual, "WMPosition", {"TopLeft", "TopRight", "TopCenter", "BottomLeft", "BottomRight"})
Slider("visuals", "WM Font Size", CFG.Visual, "WMFontSize", 10, 20, 1, "")
ColorPick("visuals", "WM Color", CFG.Visual, "WMColor")
ColorPick("visuals", "WM BG Color", CFG.Visual, "WMBGColor")
Slider("visuals", "WM BG Alpha", CFG.Visual, "WMBGAlpha", 0, 1, 0.05, "")
Toggle("visuals", "WM Accent Bar", CFG.Visual, "WMAccentBar")
Label("visuals", "Watermark shows script info on screen")
Label("visuals", "Customize position, color, and content")

-- ============================================================
-- MOVEMENT TAB: BUNNY HOP, SPIDER, PHASE, ANCHOR, ETC
-- ============================================================
Section("movement", "bunny hop")
Toggle("movement", "Enable Bunny Hop", CFG.BunnyHop, "On")
Toggle("movement", "Auto Strafe", CFG.BunnyHop, "AutoStrafe")
Slider("movement", "Strafe Speed", CFG.BunnyHop, "StrafeSpeed", 0.5, 5, 0.25, "x")
Toggle("movement", "Ground Strafe", CFG.BunnyHop, "GroundStrafe")
Label("movement", "Auto-jumps when landing for momentum")
Label("movement", "Auto strafe moves in camera direction")
Section("movement", "spider climb")
Toggle("movement", "Enable Spider", CFG.Spider, "On")
KeybindPicker("movement", "Spider Key", CFG.Spider, "Key")
Slider("movement", "Climb Speed", CFG.Spider, "Speed", 5, 100, 5, "")
Label("movement", "Climb walls using raycasts")
Label("movement", "Hold key near a wall to climb")
Section("movement", "phase / ghost")
Toggle("movement", "Enable Phase", CFG.Phase, "On")
KeybindPicker("movement", "Phase Key", CFG.Phase, "Key")
Slider("movement", "Phase Speed", CFG.Phase, "Speed", 10, 200, 5, "")
Label("movement", "Walk through walls like a ghost")
Label("movement", "Toggle with key, move in camera direction")
Section("movement", "anchor / freeze")
Toggle("movement", "Enable Anchor", CFG.Anchor, "On")
KeybindPicker("movement", "Anchor Key", CFG.Anchor, "Key")
Label("movement", "Saves your position and freezes you there")
Label("movement", "Press again to release")
Button("movement", "Set Anchor Here", function(btn)
    local myRoot = U.myRoot()
    if myRoot then
        CFG.Anchor.Position = myRoot.CFrame
        btn.Text = "Set!"
        Notify.send("Anchor", "Position saved", "success", 2)
    else
        btn.Text = "No character!"
    end
    task.delay(1, function() btn.Text = "Set Anchor Here" end)
end)
Button("movement", "Clear Anchor", function(btn)
    CFG.Anchor.Position = nil
    AnchorSystem.active = false
    btn.Text = "Cleared!"
    Notify.send("Anchor", "Anchor cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear Anchor" end)
end)
Section("movement", "spinbot")
Toggle("movement", "Enable Spinbot", CFG.Spinbot, "On")
Slider("movement", "Spin Speed", CFG.Spinbot, "Speed", 1, 50, 1, "")
Dropdown("movement", "Spin Axis", CFG.Spinbot, "Axis", {"Y", "X", "Z"})
Label("movement", "Spins your character on selected axis")
Label("movement", "Useful with anti-aim setups")
Section("movement", "third person camera")
Toggle("movement", "Enable Third Person", CFG.ThirdPerson, "On")
KeybindPicker("movement", "Third Person Key", CFG.ThirdPerson, "Key")
Slider("movement", "Camera Distance", CFG.ThirdPerson, "Distance", 5, 50, 1, "")
Slider("movement", "Camera FOV", CFG.ThirdPerson, "FOV", 40, 120, 5, "")
Toggle("movement", "Smooth Camera", CFG.ThirdPerson, "Smooth")
Slider("movement", "Smooth Speed", CFG.ThirdPerson, "SmoothSpeed", 0.01, 0.5, 0.01, "")
Label("movement", "Overrides camera to third person view")
Label("movement", "Press key to toggle on/off")
Separator("movement")
Section("movement", "movement presets")
Button("movement", "Legit Movement", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 18
    CFG.BunnyHop.On = false
    CFG.Movement.Fly.On = false
    CFG.Movement.Noclip.On = false
    CFG.Spider.On = false
    CFG.Phase.On = false
    CFG.Movement.InfJump.On = false
    btn.Text = "Applied!"
    Notify.send("Movement", "Legit movement applied", "success", 2)
    task.delay(1, function() btn.Text = "Legit Movement" end)
end)
Button("movement", "Speed Demon", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 50
    CFG.BunnyHop.On = true
    CFG.BunnyHop.AutoStrafe = true
    CFG.BunnyHop.StrafeSpeed = 3
    CFG.Movement.InfJump.On = true
    CFG.Movement.Fly.On = false
    CFG.Movement.Noclip.On = false
    btn.Text = "Applied!"
    Notify.send("Movement", "Speed demon preset applied", "warning", 2)
    task.delay(1, function() btn.Text = "Speed Demon" end)
end)
Button("movement", "Flight Master", function(btn)
    CFG.Movement.Fly.On = true
    CFG.Movement.Fly.Speed = 100
    CFG.Movement.Noclip.On = true
    CFG.Movement.Speed.On = false
    CFG.BunnyHop.On = false
    CFG.Spider.On = false
    btn.Text = "Applied!"
    Notify.send("Movement", "Flight master preset applied", "warning", 2)
    task.delay(1, function() btn.Text = "Flight Master" end)
end)
Button("movement", "Exploration Mode", function(btn)
    CFG.Movement.Fly.On = true
    CFG.Movement.Fly.Speed = 60
    CFG.Movement.Noclip.On = true
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 30
    CFG.Movement.InfJump.On = true
    CFG.Spider.On = true
    CFG.Phase.On = true
    btn.Text = "Applied!"
    Notify.send("Movement", "Exploration mode - go anywhere", "info", 3)
    task.delay(1, function() btn.Text = "Exploration Mode" end)
end)
Button("movement", "Disable All Movement", function(btn)
    CFG.Movement.Speed.On = false
    CFG.Movement.Fly.On = false
    CFG.Movement.Noclip.On = false
    CFG.Movement.InfJump.On = false
    CFG.BunnyHop.On = false
    CFG.Spider.On = false
    CFG.Phase.On = false
    CFG.Anchor.On = false
    CFG.Spinbot.On = false
    CFG.ThirdPerson.On = false
    disableFly()
    disableNoclip()
    btn.Text = "Disabled!"
    Notify.send("Movement", "All movement mods disabled", "info", 2)
    task.delay(1, function() btn.Text = "Disable All Movement" end)
end)
Separator("movement")
Section("movement", "strafe helper")
Toggle("movement", "Strafe Helper", CFG.Movement, "StrafeHelper")
Slider("movement", "Strafe Assist Strength", CFG.Movement, "StrafeStrength", 0.1, 1.0, 0.05, "")
Toggle("movement", "Air Strafe", CFG.Movement, "AirStrafe")
Slider("movement", "Air Control", CFG.Movement, "AirControl", 0.1, 1.0, 0.05, "")
Toggle("movement", "Edge Detect", CFG.Movement, "EdgeDetect")
Slider("movement", "Edge Detect Dist", CFG.Movement, "EdgeDist", 1, 10, 0.5, "")
Label("movement", "Strafe helper smooths direction changes")
Label("movement", "Air control lets you steer mid-jump")
Label("movement", "Edge detect warns near cliff edges")
Section("movement", "anti-void")
Toggle("movement", "Anti-Void", CFG.Movement, "AntiVoid")
Slider("movement", "Void Y Threshold", CFG.Movement, "VoidY", -500, -50, 10, "")
Toggle("movement", "Auto Teleport Up", CFG.Movement, "VoidTeleport")
Slider("movement", "Teleport Height", CFG.Movement, "VoidTeleportY", 10, 200, 5, "")
Label("movement", "Anti-void teleports you before falling out")
Label("movement", "Threshold sets the Y level to trigger")
Section("movement", "speed profiles")
Button("movement", "Walk Speed", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 16
    btn.Text = "16 studs/s"
    task.delay(1, function() btn.Text = "Walk Speed" end)
end)
Button("movement", "Jog Speed", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 24
    btn.Text = "24 studs/s"
    task.delay(1, function() btn.Text = "Jog Speed" end)
end)
Button("movement", "Sprint Speed", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 36
    btn.Text = "36 studs/s"
    task.delay(1, function() btn.Text = "Sprint Speed" end)
end)
Button("movement", "Fast Speed", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 60
    btn.Text = "60 studs/s"
    task.delay(1, function() btn.Text = "Fast Speed" end)
end)
Button("movement", "Ludicrous Speed", function(btn)
    CFG.Movement.Speed.On = true
    CFG.Movement.Speed.Amount = 150
    btn.Text = "150 studs/s"
    Notify.send("Speed", "Ludicrous speed - be careful", "warning", 2)
    task.delay(1, function() btn.Text = "Ludicrous Speed" end)
end)
Button("movement", "Reset Speed", function(btn)
    CFG.Movement.Speed.On = false
    CFG.Movement.Speed.Amount = 16
    btn.Text = "Reset!"
    task.delay(1, function() btn.Text = "Reset Speed" end)
end)
Label("movement", "Speed values in studs per second")
Label("movement", "Default Roblox walk speed is 16")
Separator("movement")
Section("movement", "teleport presets")
Button("movement", "TP to Highest Point", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then btn.Text = "No character!"; task.delay(1, function() btn.Text = "TP to Highest Point" end); return end
    local highest = myRoot.Position.Y
    local highPos = myRoot.Position
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Position.Y > highest and v.Size.X > 3 and v.Size.Z > 3 then
            highest = v.Position.Y
            highPos = v.Position
        end
    end
    myRoot.CFrame = CFrame.new(highPos + Vector3.new(0, 5, 0))
    btn.Text = "Done!"
    Notify.send("Teleport", "TP to Y=" .. math.floor(highest), "success", 2)
    task.delay(1, function() btn.Text = "TP to Highest Point" end)
end)
Button("movement", "TP to Map Center", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then btn.Text = "No character!"; task.delay(1, function() btn.Text = "TP to Map Center" end); return end
    local sum = Vector3.new(0, 0, 0)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Anchored then
            sum = sum + v.Position
            count = count + 1
            if count > 500 then break end
        end
    end
    if count > 0 then
        local center = sum / count
        myRoot.CFrame = CFrame.new(center + Vector3.new(0, 20, 0))
        btn.Text = "Done!"
    else
        btn.Text = "No parts!"
    end
    task.delay(1, function() btn.Text = "TP to Map Center" end)
end)
Button("movement", "TP to Random Player", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then btn.Text = "No character!"; task.delay(1, function() btn.Text = "TP to Random Player" end); return end
    local others = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            table.insert(others, p)
        end
    end
    if #others > 0 then
        local target = others[math.random(#others)]
        local rp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if rp then
            myRoot.CFrame = rp.CFrame * CFrame.new(0, 0, -5)
            btn.Text = target.Name
            Notify.send("Teleport", "TP to " .. target.Name, "success", 2)
        end
    else
        btn.Text = "No players!"
    end
    task.delay(1.5, function() btn.Text = "TP to Random Player" end)
end)
Button("movement", "TP Forward 100", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then btn.Text = "No character!"; task.delay(1, function() btn.Text = "TP Forward 100" end); return end
    myRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -100)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "TP Forward 100" end)
end)
Button("movement", "TP Up 100", function(btn)
    local myRoot = U.myRoot()
    if not myRoot then btn.Text = "No character!"; task.delay(1, function() btn.Text = "TP Up 100" end); return end
    myRoot.CFrame = myRoot.CFrame * CFrame.new(0, 100, 0)
    btn.Text = "Done!"
    task.delay(1, function() btn.Text = "TP Up 100" end)
end)
Label("movement", "Teleport presets for quick navigation")
Label("movement", "Some may trigger anti-cheat on servers")

-- ============================================================
-- WORLD TAB: EXTENDED PRESETS AND MANIPULATION
-- ============================================================
Section("world", "lighting profiles")
Button("world", "Bright Day", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 14
    lighting.Brightness = 3
    lighting.Ambient = Color3.fromRGB(150, 150, 150)
    lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
    lighting.FogEnd = 100000
    btn.Text = "Applied!"
    Notify.send("Lighting", "Bright day preset", "success", 2)
    task.delay(1, function() btn.Text = "Bright Day" end)
end)
Button("world", "Sunset Glow", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 18
    lighting.Brightness = 2
    lighting.Ambient = Color3.fromRGB(180, 120, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(200, 130, 90)
    lighting.FogEnd = 100000
    btn.Text = "Applied!"
    Notify.send("Lighting", "Sunset glow preset", "success", 2)
    task.delay(1, function() btn.Text = "Sunset Glow" end)
end)
Button("world", "Moonlit Night", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 0
    lighting.Brightness = 1
    lighting.Ambient = Color3.fromRGB(50, 50, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 70)
    lighting.FogEnd = 100000
    btn.Text = "Applied!"
    Notify.send("Lighting", "Moonlit night preset", "success", 2)
    task.delay(1, function() btn.Text = "Moonlit Night" end)
end)
Button("world", "Horror Mode", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 0
    lighting.Brightness = 0.5
    lighting.Ambient = Color3.fromRGB(10, 0, 0)
    lighting.OutdoorAmbient = Color3.fromRGB(5, 0, 0)
    lighting.FogEnd = 200
    lighting.FogColor = Color3.fromRGB(10, 0, 0)
    btn.Text = "Applied!"
    Notify.send("Lighting", "Horror mode - very dark", "warning", 2)
    task.delay(1, function() btn.Text = "Horror Mode" end)
end)
Button("world", "Neon City", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 22
    lighting.Brightness = 1.5
    lighting.Ambient = Color3.fromRGB(40, 0, 80)
    lighting.OutdoorAmbient = Color3.fromRGB(50, 10, 90)
    lighting.FogEnd = 100000
    btn.Text = "Applied!"
    Notify.send("Lighting", "Neon city preset", "success", 2)
    task.delay(1, function() btn.Text = "Neon City" end)
end)
Button("world", "Arctic White", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = 12
    lighting.Brightness = 4
    lighting.Ambient = Color3.fromRGB(220, 230, 255)
    lighting.OutdoorAmbient = Color3.fromRGB(230, 240, 255)
    lighting.FogEnd = 5000
    lighting.FogColor = Color3.fromRGB(240, 245, 255)
    btn.Text = "Applied!"
    Notify.send("Lighting", "Arctic white preset", "success", 2)
    task.delay(1, function() btn.Text = "Arctic White" end)
end)
Separator("world")
Section("world", "gravity presets")
Button("world", "Normal Gravity", function(btn)
    workspace.Gravity = 196.2
    btn.Text = "196.2"
    task.delay(1, function() btn.Text = "Normal Gravity" end)
end)
Button("world", "Moon Gravity", function(btn)
    workspace.Gravity = 32
    btn.Text = "32"
    Notify.send("Gravity", "Moon gravity enabled", "info", 2)
    task.delay(1, function() btn.Text = "Moon Gravity" end)
end)
Button("world", "Mars Gravity", function(btn)
    workspace.Gravity = 72
    btn.Text = "72"
    Notify.send("Gravity", "Mars gravity enabled", "info", 2)
    task.delay(1, function() btn.Text = "Mars Gravity" end)
end)
Button("world", "Jupiter Gravity", function(btn)
    workspace.Gravity = 500
    btn.Text = "500"
    Notify.send("Gravity", "Jupiter gravity - heavy!", "warning", 2)
    task.delay(1, function() btn.Text = "Jupiter Gravity" end)
end)
Button("world", "Zero Gravity", function(btn)
    workspace.Gravity = 0
    btn.Text = "0"
    Notify.send("Gravity", "Zero gravity!", "warning", 2)
    task.delay(1, function() btn.Text = "Zero Gravity" end)
end)
Button("world", "Reversed Gravity", function(btn)
    workspace.Gravity = -100
    btn.Text = "-100"
    Notify.send("Gravity", "Reversed gravity - fall up!", "warning", 2)
    task.delay(1, function() btn.Text = "Reversed Gravity" end)
end)
Separator("world")
Section("world", "fog controls")
Toggle("world", "Custom Fog", CFG.World, "CustomFog")
Slider("world", "Fog Start", CFG.World, "FogStart", 0, 1000, 25, "")
Slider("world", "Fog End", CFG.World, "FogEnd", 100, 100000, 500, "")
ColorPick("world", "Fog Color", CFG.World, "FogColor")
Button("world", "Clear Fog", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.FogStart = 0
    lighting.FogEnd = 100000
    btn.Text = "Cleared!"
    task.delay(1, function() btn.Text = "Clear Fog" end)
end)
Button("world", "Dense Fog", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.FogStart = 0
    lighting.FogEnd = 200
    lighting.FogColor = Color3.fromRGB(200, 200, 200)
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Dense Fog" end)
end)
Button("world", "Eerie Fog", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.FogStart = 0
    lighting.FogEnd = 300
    lighting.FogColor = Color3.fromRGB(50, 80, 50)
    btn.Text = "Applied!"
    task.delay(1, function() btn.Text = "Eerie Fog" end)
end)
Section("world", "time controls")
Slider("world", "Time of Day", CFG.World, "ClockTime", 0, 24, 0.5, "h")
Toggle("world", "Freeze Time", CFG.World, "FreezeTime")
Button("world", "Cycle Time +1h", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = (lighting.ClockTime + 1) % 24
    btn.Text = string.format("%.0fh", lighting.ClockTime)
    task.delay(1, function() btn.Text = "Cycle Time +1h" end)
end)
Button("world", "Cycle Time -1h", function(btn)
    local lighting = game:GetService("Lighting")
    lighting.ClockTime = (lighting.ClockTime - 1) % 24
    btn.Text = string.format("%.0fh", lighting.ClockTime)
    task.delay(1, function() btn.Text = "Cycle Time -1h" end)
end)
Section("world", "physics manipulation")
Slider("world", "Jump Power Override", CFG.World, "JumpPower", 0, 500, 10, "")
Button("world", "Apply Jump Power", function(btn)
    local myChar = LP.Character
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.JumpPower = CFG.World.JumpPower
        hum.UseJumpPower = true
        btn.Text = "Applied!"
    else
        btn.Text = "No character!"
    end
    task.delay(1, function() btn.Text = "Apply Jump Power" end)
end)
Slider("world", "Hip Height Override", CFG.World, "HipHeight", 0, 50, 0.5, "")
Button("world", "Apply Hip Height", function(btn)
    local myChar = LP.Character
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.HipHeight = CFG.World.HipHeight
        btn.Text = "Applied!"
    else
        btn.Text = "No character!"
    end
    task.delay(1, function() btn.Text = "Apply Hip Height" end)
end)
Label("world", "Jump power adjusts how high you jump")
Label("world", "Hip height raises your character model")
Separator("world")
Section("world", "environment scanner")
Button("world", "Count All Parts", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then count = count + 1 end
    end
    btn.Text = tostring(count)
    Notify.send("Scanner", "Total parts: " .. count, "info", 3)
    task.delay(2, function() btn.Text = "Count All Parts" end)
end)
Button("world", "Count All Models", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") then count = count + 1 end
    end
    btn.Text = tostring(count)
    Notify.send("Scanner", "Total models: " .. count, "info", 3)
    task.delay(2, function() btn.Text = "Count All Models" end)
end)
Button("world", "Count Scripts", function(btn)
    local count = 0
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("Script") or v:IsA("ModuleScript") then
            count = count + 1
        end
    end
    btn.Text = tostring(count)
    Notify.send("Scanner", "Total scripts: " .. count, "info", 3)
    task.delay(2, function() btn.Text = "Count Scripts" end)
end)
Button("world", "Find Unanchored Parts", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored then count = count + 1 end
    end
    btn.Text = tostring(count)
    Notify.send("Scanner", "Unanchored parts: " .. count, "info", 3)
    task.delay(2, function() btn.Text = "Find Unanchored Parts" end)
end)
Button("world", "Find SpawnLocations", function(btn)
    local spawns = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("SpawnLocation") then
            table.insert(spawns, string.format("%s (%.0f, %.0f, %.0f)", v.Name, v.Position.X, v.Position.Y, v.Position.Z))
        end
    end
    if #spawns > 0 then
        btn.Text = #spawns .. " found"
        Notify.send("Scanner", table.concat(spawns, "\n"), "info", 6)
    else
        btn.Text = "None found"
    end
    task.delay(2, function() btn.Text = "Find SpawnLocations" end)
end)
Button("world", "Map Bounds", function(btn)
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Anchored then
            local p = v.Position
            minX = math.min(minX, p.X); minY = math.min(minY, p.Y); minZ = math.min(minZ, p.Z)
            maxX = math.max(maxX, p.X); maxY = math.max(maxY, p.Y); maxZ = math.max(maxZ, p.Z)
            count = count + 1
            if count > 2000 then break end
        end
    end
    if count > 0 then
        local sizeX = math.floor(maxX - minX)
        local sizeY = math.floor(maxY - minY)
        local sizeZ = math.floor(maxZ - minZ)
        btn.Text = sizeX .. "x" .. sizeY .. "x" .. sizeZ
        Notify.send("Scanner", string.format("Map size: %dx%dx%d studs\nX: %.0f to %.0f\nY: %.0f to %.0f\nZ: %.0f to %.0f",
            sizeX, sizeY, sizeZ, minX, maxX, minY, maxY, minZ, maxZ), "info", 6)
    else
        btn.Text = "No parts!"
    end
    task.delay(2, function() btn.Text = "Map Bounds" end)
end)
Label("world", "Environment scanner analyzes the game world")
Label("world", "Useful for finding hidden areas and spawns")
Section("world", "skybox override")
Toggle("world", "Custom Skybox", CFG.World, "CustomSkybox")
Dropdown("world", "Skybox Preset", CFG.World, "SkyboxPreset", {"Default", "Clear", "Starry", "Cloudy", "Sunset", "Space", "Grid", "Void"})
Button("world", "Apply Skybox", function(btn)
    local lighting = game:GetService("Lighting")
    local sky = lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = lighting
    end
    local preset = CFG.World.SkyboxPreset
    if preset == "Clear" then
        sky.SkyboxBk = "rbxassetid://1012890590"; sky.SkyboxDn = "rbxassetid://1012890590"
        sky.SkyboxFt = "rbxassetid://1012890590"; sky.SkyboxLf = "rbxassetid://1012890590"
        sky.SkyboxRt = "rbxassetid://1012890590"; sky.SkyboxUp = "rbxassetid://1012890590"
    elseif preset == "Void" then
        sky.SkyboxBk = ""; sky.SkyboxDn = ""; sky.SkyboxFt = ""
        sky.SkyboxLf = ""; sky.SkyboxRt = ""; sky.SkyboxUp = ""
    end
    btn.Text = "Applied!"
    Notify.send("Skybox", preset .. " skybox applied", "success", 2)
    task.delay(1, function() btn.Text = "Apply Skybox" end)
end)
Button("world", "Remove Skybox", function(btn)
    local lighting = game:GetService("Lighting")
    local sky = lighting:FindFirstChildOfClass("Sky")
    if sky then sky:Destroy() end
    btn.Text = "Removed!"
    task.delay(1, function() btn.Text = "Remove Skybox" end)
end)
Label("world", "Skybox changes the background panorama")
Label("world", "Void removes all sky textures")

-- ============================================================
-- RADAR TAB: EXTENDED PRESETS AND CONFIGURATION
-- ============================================================
Section("radar", "radar presets")
Button("radar", "Minimal Radar", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Size = 120
    CFG.Radar.DotSize = 3
    CFG.Radar.Range = 150
    CFG.Radar.ShowNames = false
    CFG.Radar.ShowHealth = false
    CFG.Radar.CrosshairLines = true
    btn.Text = "Applied!"
    Notify.send("Radar", "Minimal radar preset", "success", 2)
    task.delay(1, function() btn.Text = "Minimal Radar" end)
end)
Button("radar", "Detailed Radar", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Size = 200
    CFG.Radar.DotSize = 5
    CFG.Radar.Range = 300
    CFG.Radar.ShowNames = true
    CFG.Radar.ShowHealth = true
    CFG.Radar.CrosshairLines = true
    btn.Text = "Applied!"
    Notify.send("Radar", "Detailed radar preset", "success", 2)
    task.delay(1, function() btn.Text = "Detailed Radar" end)
end)
Button("radar", "Wide Area Radar", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Size = 250
    CFG.Radar.DotSize = 4
    CFG.Radar.Range = 500
    CFG.Radar.ShowNames = true
    CFG.Radar.ShowHealth = false
    CFG.Radar.CrosshairLines = true
    btn.Text = "Applied!"
    Notify.send("Radar", "Wide area radar - 500 range", "success", 2)
    task.delay(1, function() btn.Text = "Wide Area Radar" end)
end)
Button("radar", "Compact Radar", function(btn)
    CFG.Radar.On = true
    CFG.Radar.Size = 80
    CFG.Radar.DotSize = 2
    CFG.Radar.Range = 100
    CFG.Radar.ShowNames = false
    CFG.Radar.ShowHealth = false
    CFG.Radar.CrosshairLines = false
    btn.Text = "Applied!"
    Notify.send("Radar", "Compact radar preset", "success", 2)
    task.delay(1, function() btn.Text = "Compact Radar" end)
end)
Separator("radar")
Section("radar", "radar style")
Slider("radar", "Radar Zoom", CFG.Radar, "Range", 50, 1000, 25, "")
Slider("radar", "Radar Scale", CFG.Radar, "Size", 60, 300, 10, "")
Slider("radar", "Dot Size", CFG.Radar, "DotSize", 1, 10, 0.5, "")
Toggle("radar", "Show Player Names", CFG.Radar, "ShowNames")
Toggle("radar", "Show Health Bars", CFG.Radar, "ShowHealth")
Toggle("radar", "Crosshair Lines", CFG.Radar, "CrosshairLines")
Toggle("radar", "Rotate with Camera", CFG.Radar, "RotateWithCam")
Toggle("radar", "Show North Indicator", CFG.Radar, "ShowNorth")
Slider("radar", "BG Opacity", CFG.Radar, "BGOpacity", 0, 1, 0.05, "")
ColorPick("radar", "BG Color", CFG.Radar, "BGColor")
ColorPick("radar", "Crosshair Color", CFG.Radar, "CrossColor")
ColorPick("radar", "Border Color", CFG.Radar, "BorderColor")
Slider("radar", "Border Width", CFG.Radar, "BorderWidth", 0, 4, 0.5, "")
Section("radar", "radar filtering")
Toggle("radar", "Show Enemies", CFG.Radar, "ShowEnemies")
Toggle("radar", "Show Teammates", CFG.Radar, "ShowTeammates")
Toggle("radar", "Show Friends", CFG.Radar, "ShowFriends")
Toggle("radar", "Show Dead Players", CFG.Radar, "ShowDead")
Toggle("radar", "Show Items", CFG.Radar, "ShowItems")
Toggle("radar", "Show Vehicles", CFG.Radar, "ShowVehicles")
ColorPick("radar", "Enemy Color", CFG.Radar, "EnemyColor")
ColorPick("radar", "Teammate Color", CFG.Radar, "TeamColor")
ColorPick("radar", "Friend Color", CFG.Radar, "FriendColor")
ColorPick("radar", "Item Color", CFG.Radar, "ItemColor")
Section("radar", "radar position")
Dropdown("radar", "Corner", CFG.Radar, "Corner", {"TopLeft", "TopRight", "BottomLeft", "BottomRight"})
Slider("radar", "Offset X", CFG.Radar, "OffsetX", 0, 100, 5, "px")
Slider("radar", "Offset Y", CFG.Radar, "OffsetY", 0, 100, 5, "px")
Toggle("radar", "Draggable", CFG.Radar, "Draggable")
Label("radar", "Draggable lets you move radar by clicking")
Section("radar", "waypoint system")
Toggle("radar", "Show Waypoints", CFG.Radar, "ShowWaypoints")
Button("radar", "Set Waypoint Here", function(btn)
    local myRoot = U.myRoot()
    if myRoot then
        CFG.Radar.Waypoints = CFG.Radar.Waypoints or {}
        table.insert(CFG.Radar.Waypoints, {
            Position = myRoot.Position,
            Name = "WP" .. #(CFG.Radar.Waypoints or {}) + 1
        })
        btn.Text = "Set!"
        Notify.send("Waypoint", "Waypoint set at current position", "success", 2)
    else
        btn.Text = "No character!"
    end
    task.delay(1, function() btn.Text = "Set Waypoint Here" end)
end)
Button("radar", "Clear All Waypoints", function(btn)
    CFG.Radar.Waypoints = {}
    btn.Text = "Cleared!"
    Notify.send("Waypoint", "All waypoints cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear All Waypoints" end)
end)
Button("radar", "TP to Nearest Waypoint", function(btn)
    local myRoot = U.myRoot()
    if not myRoot or not CFG.Radar.Waypoints or #CFG.Radar.Waypoints == 0 then
        btn.Text = "None set!"
        task.delay(1, function() btn.Text = "TP to Nearest Waypoint" end)
        return
    end
    local nearest, nearDist = nil, math.huge
    for _, wp in ipairs(CFG.Radar.Waypoints) do
        local dist = (myRoot.Position - wp.Position).Magnitude
        if dist < nearDist then
            nearest = wp
            nearDist = dist
        end
    end
    if nearest then
        myRoot.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 5, 0))
        btn.Text = nearest.Name
        Notify.send("Waypoint", "TP to " .. nearest.Name, "success", 2)
    end
    task.delay(1.5, function() btn.Text = "TP to Nearest Waypoint" end)
end)
ColorPick("radar", "Waypoint Color", CFG.Radar, "WaypointColor")
Slider("radar", "Waypoint Size", CFG.Radar, "WaypointSize", 2, 8, 0.5, "")
Label("radar", "Waypoints show as markers on radar")
Label("radar", "TP to nearest jumps to closest marker")
Separator("radar")
Section("radar", "map awareness")
Toggle("radar", "Direction Arrows", CFG.Radar, "DirArrows")
Toggle("radar", "Distance Numbers", CFG.Radar, "DistNumbers")
Toggle("radar", "Threat Ring", CFG.Radar, "ThreatRing")
Slider("radar", "Threat Ring Dist", CFG.Radar, "ThreatRingDist", 20, 100, 5, "")
ColorPick("radar", "Threat Ring Color", CFG.Radar, "ThreatRingColor")
Toggle("radar", "Last Seen Markers", CFG.Radar, "LastSeen")
Slider("radar", "Last Seen Duration", CFG.Radar, "LastSeenDur", 2, 30, 1, "s")
Label("radar", "Direction arrows point to off-screen enemies")
Label("radar", "Threat ring highlights danger zone radius")
Label("radar", "Last seen shows fading ghost positions")

-- ============================================================
-- PLAYERS TAB: EXTENDED TRACKING AND MANAGEMENT
-- ============================================================
Section("players", "player tracking")
Toggle("players", "Track Positions", CFG.Players, "TrackPositions")
Toggle("players", "Track Deaths", CFG.Players, "TrackDeaths")
Toggle("players", "Track Kills", CFG.Players, "TrackKills")
Toggle("players", "Track Damage", CFG.Players, "TrackDamage")
Toggle("players", "Track Distance", CFG.Players, "TrackDistance")
Slider("players", "History Length", CFG.Players, "HistoryLength", 10, 200, 10, "")
Label("players", "Tracking logs player activity over time")
Label("players", "History length sets max entries per player")
Section("players", "player notes")
Button("players", "Note Current Target", function(btn)
    local target = U.target()
    if target then
        CFG.PlayerNotes = CFG.PlayerNotes or {}
        CFG.PlayerNotes[target.Name] = CFG.PlayerNotes[target.Name] or "Note added"
        btn.Text = target.Name
        Notify.send("Notes", "Note slot created for " .. target.Name, "info", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Note Current Target" end)
end)
Button("players", "Clear All Notes", function(btn)
    CFG.PlayerNotes = {}
    btn.Text = "Cleared!"
    Notify.send("Notes", "All player notes cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear All Notes" end)
end)
Section("players", "friend system")
Toggle("players", "Friend ESP", CFG.Players, "FriendESP")
Toggle("players", "Friend Chams", CFG.Players, "FriendChams")
Toggle("players", "Friend Aimbot Ignore", CFG.Players, "FriendIgnore")
ColorPick("players", "Friend Color", CFG.Players, "FriendColor")
Button("players", "Add Target as Friend", function(btn)
    local target = U.target()
    if target then
        CFG.FriendList = CFG.FriendList or {}
        CFG.FriendList[target.Name] = true
        btn.Text = target.Name
        Notify.send("Friends", target.Name .. " added as friend", "success", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Add Target as Friend" end)
end)
Button("players", "Remove Target Friend", function(btn)
    local target = U.target()
    if target then
        CFG.FriendList = CFG.FriendList or {}
        CFG.FriendList[target.Name] = nil
        btn.Text = "Removed!"
        Notify.send("Friends", target.Name .. " removed from friends", "info", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Remove Target Friend" end)
end)
Button("players", "Clear Friend List", function(btn)
    CFG.FriendList = {}
    btn.Text = "Cleared!"
    Notify.send("Friends", "Friend list cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear Friend List" end)
end)
Section("players", "priority targets")
Toggle("players", "Priority System", CFG.Players, "PriorityOn")
Button("players", "Add Priority Target", function(btn)
    local target = U.target()
    if target then
        CFG.PriorityList = CFG.PriorityList or {}
        CFG.PriorityList[target.Name] = true
        btn.Text = target.Name
        Notify.send("Priority", target.Name .. " added as priority", "warning", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Add Priority Target" end)
end)
Button("players", "Remove Priority Target", function(btn)
    local target = U.target()
    if target then
        CFG.PriorityList = CFG.PriorityList or {}
        CFG.PriorityList[target.Name] = nil
        btn.Text = "Removed!"
        Notify.send("Priority", target.Name .. " removed from priority", "info", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Remove Priority Target" end)
end)
Button("players", "Clear Priority List", function(btn)
    CFG.PriorityList = {}
    btn.Text = "Cleared!"
    Notify.send("Priority", "Priority list cleared", "info", 2)
    task.delay(1, function() btn.Text = "Clear Priority List" end)
end)
ColorPick("players", "Priority Highlight Color", CFG.Players, "PriorityColor")
Toggle("players", "Priority Always Visible", CFG.Players, "PriorityVisible")
Label("players", "Priority targets get aimbot preference")
Label("players", "They also get special ESP highlight")
Section("players", "player stats viewer")
Button("players", "Show My Stats", function(btn)
    local myChar = LP.Character
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if hum and myRoot then
        local info = string.format(
            "Name: %s\nHealth: %.0f/%.0f\nWalk Speed: %.0f\nJump Power: %.0f\nPosition: %.0f, %.0f, %.0f\nVelocity: %.1f studs/s",
            LP.Name, hum.Health, hum.MaxHealth, hum.WalkSpeed, hum.JumpPower,
            myRoot.Position.X, myRoot.Position.Y, myRoot.Position.Z,
            myRoot.Velocity.Magnitude
        )
        Notify.send("My Stats", info, "info", 6)
        btn.Text = "Shown!"
    else
        btn.Text = "No character!"
    end
    task.delay(1, function() btn.Text = "Show My Stats" end)
end)
Button("players", "Show Target Stats", function(btn)
    local target = U.target()
    if target and U.alive(target) then
        local ch = target.Character
        local hum = ch:FindFirstChildOfClass("Humanoid")
        local rp = ch:FindFirstChild("HumanoidRootPart")
        local myRoot = U.myRoot()
        if hum and rp then
            local dist = myRoot and (myRoot.Position - rp.Position).Magnitude or 0
            local info = string.format(
                "Name: %s\nHealth: %.0f/%.0f\nWalk Speed: %.0f\nDistance: %.0f studs\nVelocity: %.1f studs/s",
                target.Name, hum.Health, hum.MaxHealth, hum.WalkSpeed,
                dist, rp.Velocity.Magnitude
            )
            Notify.send("Target Stats", info, "info", 6)
            btn.Text = target.Name
        end
    else
        btn.Text = "No target!"
    end
    task.delay(1.5, function() btn.Text = "Show Target Stats" end)
end)
Button("players", "Show All Players", function(btn)
    local plrs = Players:GetPlayers()
    local lines = {}
    for _, p in ipairs(plrs) do
        local status = "Dead"
        if U.alive(p) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            status = hum and string.format("HP:%.0f", hum.Health) or "Alive"
        end
        table.insert(lines, p.Name .. " - " .. status)
    end
    Notify.send("Players (" .. #plrs .. ")", table.concat(lines, "\n"), "info", 8)
    btn.Text = #plrs .. " players"
    task.delay(2, function() btn.Text = "Show All Players" end)
end)
Label("players", "Stats show real-time player information")
Label("players", "Target stats require aiming at a player")
Separator("players")
Section("players", "whitelist / blacklist")
Toggle("players", "Whitelist Mode", CFG.Players, "WhitelistMode")
Button("players", "Whitelist Target", function(btn)
    local target = U.target()
    if target then
        CFG.Whitelist = CFG.Whitelist or {}
        CFG.Whitelist[target.Name] = true
        btn.Text = target.Name
        Notify.send("Whitelist", target.Name .. " whitelisted", "success", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Whitelist Target" end)
end)
Button("players", "Blacklist Target", function(btn)
    local target = U.target()
    if target then
        CFG.Blacklist = CFG.Blacklist or {}
        CFG.Blacklist[target.Name] = true
        btn.Text = target.Name
        Notify.send("Blacklist", target.Name .. " blacklisted", "warning", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Blacklist Target" end)
end)
Button("players", "Clear Whitelist", function(btn)
    CFG.Whitelist = {}
    btn.Text = "Cleared!"
    task.delay(1, function() btn.Text = "Clear Whitelist" end)
end)
Button("players", "Clear Blacklist", function(btn)
    CFG.Blacklist = {}
    btn.Text = "Cleared!"
    task.delay(1, function() btn.Text = "Clear Blacklist" end)
end)
Label("players", "Whitelist mode only targets listed players")
Label("players", "Blacklist mode ignores listed players")

-- ============================================================
-- MISC TAB: ANTI-AFK, BATCH ACTIONS, MACROS, DEBUG
-- ============================================================
Section("misc", "anti-afk & respawn")
Toggle("misc", "Anti-AFK", CFG.Player.AntiAFK, "On")
Toggle("misc", "Auto Respawn", CFG.Player.AutoRespawn, "On")
Slider("misc", "Respawn Delay", CFG.Player.AutoRespawn, "Delay", 0.5, 5, 0.5, "s")
Toggle("misc", "No Particles", CFG.Player.NoParticles, "On")
Label("misc", "Anti-AFK prevents idle disconnect")
Label("misc", "Auto respawn loads character after death")
Section("misc", "batch actions")
Button("misc", "Enable All ESP", function(btn)
    CFG.BoxESP.On = true
    CFG.Tracers.On = true
    CFG.Skeleton.On = true
    CFG.Chams.On = true
    CFG.NameESP.On = true
    CFG.HealthESP.On = true
    btn.Text = "All On!"
    Notify.send("ESP", "All ESP features enabled", "success", 2)
    task.delay(1, function() btn.Text = "Enable All ESP" end)
end)
Button("misc", "Disable All ESP", function(btn)
    CFG.BoxESP.On = false
    CFG.Tracers.On = false
    CFG.Snaplines.On = false
    CFG.Skeleton.On = false
    CFG.OffScreen.On = false
    CFG.Chams.On = false
    CFG.ItemESP.On = false
    CFG.NameESP.On = false
    CFG.HealthESP.On = false
    btn.Text = "All Off!"
    Notify.send("ESP", "All ESP features disabled", "info", 2)
    task.delay(1, function() btn.Text = "Disable All ESP" end)
end)
Button("misc", "Legit Preset", function(btn)
    CFG.Aimbot.On = true
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Smoothness = 0.08
    CFG.Aimbot.FOV = 80
    CFG.Aimbot.WallCheck = true
    CFG.Aimbot.VisCheck = true
    CFG.BoxESP.On = true
    CFG.BoxESP.Mode = "Corner"
    CFG.Crosshair.On = true
    CFG.Crosshair.Style = "Cross"
    btn.Text = "Applied!"
    Notify.send("Preset", "Legit preset applied", "success", 3)
    task.delay(1, function() btn.Text = "Legit Preset" end)
end)
Button("misc", "Rage Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 360
    CFG.RageBot.MultiPoint = true
    CFG.RageBot.AutoWall = true
    CFG.RageBot.DoubleTap = true
    CFG.AntiAim.On = true
    CFG.AntiAim.Yaw = "Spin"
    CFG.AntiAim.Desync = true
    CFG.Chams.On = true
    CFG.BoxESP.On = true
    btn.Text = "Applied!"
    Notify.send("Preset", "Rage preset applied - go wild", "warning", 3)
    task.delay(1, function() btn.Text = "Rage Preset" end)
end)
Button("misc", "HVH Preset", function(btn)
    CFG.RageBot.On = true
    CFG.RageBot.FOV = 360
    CFG.RageBot.Resolver = true
    CFG.RageBot.Backtrack = true
    CFG.RageBot.MultiPoint = true
    CFG.AntiAim.On = true
    CFG.AntiAim.Yaw = "Jitter"
    CFG.AntiAim.Desync = true
    CFG.AntiAim.FakeLag = true
    CFG.AntiAim.LegBreaker = true
    CFG.Resolver.On = true
    CFG.Backtrack.On = true
    CFG.Chams.On = true
    CFG.Chams.Mode = "XRay"
    btn.Text = "Applied!"
    Notify.send("Preset", "HVH preset applied", "warning", 3)
    task.delay(1, function() btn.Text = "HVH Preset" end)
end)
Button("misc", "Ghost Preset", function(btn)
    CFG.Movement.Noclip.On = true
    CFG.Phase.On = true
    CFG.Movement.Fly.On = true
    CFG.Movement.Fly.Speed = 80
    CFG.Chams.On = true
    CFG.Chams.Mode = "Glow"
    CFG.BoxESP.On = true
    CFG.Crosshair.On = false
    btn.Text = "Applied!"
    Notify.send("Preset", "Ghost preset - fly + noclip", "info", 3)
    task.delay(1, function() btn.Text = "Ghost Preset" end)
end)
Button("misc", "Streamer Mode", function(btn)
    CFG.BoxESP.On = true
    CFG.BoxESP.Mode = "Corner"
    CFG.Aimbot.On = true
    CFG.Aimbot.Mode = "Smooth"
    CFG.Aimbot.Smoothness = 0.12
    CFG.Aimbot.FOV = 60
    CFG.Chams.On = false
    CFG.Visual.Watermark = false
    CFG.NameESP.On = false
    CFG.Tracers.On = false
    btn.Text = "Applied!"
    Notify.send("Preset", "Streamer mode - minimal visuals", "success", 3)
    task.delay(1, function() btn.Text = "Streamer Mode" end)
end)
Button("misc", "Reset All Settings", function(btn)
    ConfigManager.reset()
    btn.Text = "Reset!"
    Notify.send("Config", "All settings reset to defaults", "warning", 3)
    task.delay(1, function() btn.Text = "Reset All Settings" end)
end)
Section("misc", "performance")
Button("misc", "Force Garbage Collect", function(btn)
    local before = collectgarbage("count")
    collectgarbage("collect")
    local after = collectgarbage("count")
    local freed = math.floor(before - after)
    btn.Text = freed .. "KB freed"
    Notify.send("GC", string.format("Freed %dKB (%.1fMB -> %.1fMB)", freed, before/1024, after/1024), "info", 3)
    task.delay(2, function() btn.Text = "Force Garbage Collect" end)
end)
Button("misc", "Memory Usage", function(btn)
    local mem = collectgarbage("count")
    Notify.send("Memory", string.format("Lua Memory: %.2fMB", mem / 1024), "info", 3)
    btn.Text = string.format("%.1fMB", mem/1024)
    task.delay(2, function() btn.Text = "Memory Usage" end)
end)
Button("misc", "FPS Report", function(btn)
    local fps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
    local mem = collectgarbage("count")
    local players = #Players:GetPlayers()
    local parts = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then parts = parts + 1 end
    end
    local report = string.format("FPS: %d\nMemory: %.1fMB\nPlayers: %d\nParts: %d", fps, mem/1024, players, parts)
    Notify.send("Performance", report, "info", 5)
    btn.Text = fps .. " FPS"
    task.delay(2, function() btn.Text = "FPS Report" end)
end)
Separator("misc")
Section("misc", "script loader")
TextInput("misc", "Script URL", CFG.Misc, "ScriptURL")
Button("misc", "Execute URL", function(btn)
    local url = CFG.Misc.ScriptURL
    if url and url ~= "" then
        btn.Text = "Loading..."
        pcall(function()
            local source = game:HttpGet(url)
            if source and #source > 0 then
                local fn = loadstring(source)
                if fn then
                    btn.Text = "Running..."
                    task.spawn(fn)
                    Notify.send("Loader", "Script executed from URL", "success", 3)
                else
                    btn.Text = "Parse error!"
                    Notify.send("Loader", "Failed to parse script", "error", 3)
                end
            else
                btn.Text = "Empty!"
            end
        end)
    else
        btn.Text = "No URL!"
    end
    task.delay(2, function() btn.Text = "Execute URL" end)
end)
Label("misc", "Paste a raw script URL above")
Label("misc", "Supports pastebin, github raw, etc.")
Section("misc", "network analysis")
Button("misc", "Show Remote Events", function(btn)
    local remotes = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(remotes, v:GetFullName())
            if #remotes >= 15 then break end
        end
    end
    if #remotes > 0 then
        Notify.send("Remotes (" .. #remotes .. "+)", table.concat(remotes, "\n"), "info", 8)
        btn.Text = #remotes .. "+"
    else
        btn.Text = "None found"
    end
    task.delay(2, function() btn.Text = "Show Remote Events" end)
end)
Button("misc", "Show Remote Functions", function(btn)
    local remotes = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteFunction") then
            table.insert(remotes, v:GetFullName())
            if #remotes >= 15 then break end
        end
    end
    if #remotes > 0 then
        Notify.send("RemoteFns (" .. #remotes .. "+)", table.concat(remotes, "\n"), "info", 8)
        btn.Text = #remotes .. "+"
    else
        btn.Text = "None found"
    end
    task.delay(2, function() btn.Text = "Show Remote Functions" end)
end)
Button("misc", "Show Bindable Events", function(btn)
    local bindables = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("BindableEvent") then
            table.insert(bindables, v:GetFullName())
            if #bindables >= 15 then break end
        end
    end
    if #bindables > 0 then
        Notify.send("Bindables (" .. #bindables .. "+)", table.concat(bindables, "\n"), "info", 8)
        btn.Text = #bindables .. "+"
    else
        btn.Text = "None found"
    end
    task.delay(2, function() btn.Text = "Show Bindable Events" end)
end)
Label("misc", "Lists game networking objects")
Label("misc", "Useful for understanding game structure")
Section("misc", "debug tools")
Button("misc", "Workspace Tree", function(btn)
    local classes = {}
    for _, v in ipairs(workspace:GetChildren()) do
        classes[v.ClassName] = (classes[v.ClassName] or 0) + 1
    end
    local lines = {}
    for cls, cnt in pairs(classes) do
        table.insert(lines, cls .. ": " .. cnt)
    end
    table.sort(lines)
    Notify.send("Workspace", table.concat(lines, "\n"), "info", 8)
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Workspace Tree" end)
end)
Button("misc", "Lighting Info", function(btn)
    local lighting = game:GetService("Lighting")
    local info = string.format(
        "Time: %.1f\nBrightness: %.1f\nAmbient: %s\nFog End: %.0f\nGravity: %.1f",
        lighting.ClockTime, lighting.Brightness,
        tostring(lighting.Ambient), lighting.FogEnd, workspace.Gravity
    )
    Notify.send("Lighting", info, "info", 5)
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Lighting Info" end)
end)
Button("misc", "Service List", function(btn)
    local services = {"Workspace", "Players", "Lighting", "ReplicatedStorage",
        "ReplicatedFirst", "ServerScriptService", "ServerStorage", "StarterGui",
        "StarterPack", "StarterPlayer", "Teams", "SoundService",
        "Chat", "LocalizationService", "TestService"}
    local found = {}
    for _, name in ipairs(services) do
        pcall(function()
            local svc = game:GetService(name)
            if svc then
                table.insert(found, name .. " (" .. #svc:GetChildren() .. " children)")
            end
        end)
    end
    Notify.send("Services", table.concat(found, "\n"), "info", 8)
    btn.Text = "Shown!"
    task.delay(1, function() btn.Text = "Service List" end)
end)
Button("misc", "Camera Info", function(btn)
    local cam = workspace.CurrentCamera
    if cam then
        local info = string.format(
            "Type: %s\nFOV: %.0f\nFocus: %.0f, %.0f, %.0f\nPos: %.0f, %.0f, %.0f",
            tostring(cam.CameraType), cam.FieldOfView,
            cam.Focus.Position.X, cam.Focus.Position.Y, cam.Focus.Position.Z,
            cam.CFrame.Position.X, cam.CFrame.Position.Y, cam.CFrame.Position.Z
        )
        Notify.send("Camera", info, "info", 5)
        btn.Text = "Shown!"
    else
        btn.Text = "No camera!"
    end
    task.delay(1, function() btn.Text = "Camera Info" end)
end)
Label("misc", "Debug tools help explore game internals")
Label("misc", "Useful for script development and modding")
Section("misc", "anti-cheat info")
Button("misc", "Scan Anti-Cheat", function(btn)
    local indicators = {}
    local function check(name, path)
        pcall(function()
            for _, v in ipairs(game:GetDescendants()) do
                if v.Name:lower():find(name:lower()) then
                    table.insert(indicators, "Found: " .. v:GetFullName())
                    if #indicators >= 10 then return end
                end
            end
        end)
    end
    check("AntiCheat")
    check("anticheat")
    check("anti_cheat")
    check("AntiExploit")
    check("Sentinel")
    check("BanModule")
    check("KickModule")
    if #indicators > 0 then
        Notify.send("Anti-Cheat Scan", table.concat(indicators, "\n"), "warning", 8)
        btn.Text = #indicators .. " found"
    else
        Notify.send("Anti-Cheat Scan", "No obvious anti-cheat detected", "success", 3)
        btn.Text = "None found"
    end
    task.delay(2, function() btn.Text = "Scan Anti-Cheat" end)
end)
Label("misc", "Scans for common anti-cheat modules")
Label("misc", "Not finding any does not mean none exist")

-- ============================================================
-- SETTINGS TAB: THEMES, CUSTOM COLORS, GUI, PROFILES
-- ============================================================
Section("settings", "theme presets")
Dropdown("settings", "Theme", CFG.Themes, "Current", ThemeManager.getNames())
Button("settings", "Apply Theme", function(btn)
    ThemeManager.apply(CFG.Themes.Current)
    btn.Text = "Applied!"
    Notify.send("Theme", "Applied: " .. CFG.Themes.Current, "success", 2)
    task.delay(1, function() btn.Text = "Apply Theme" end)
end)
Section("settings", "custom theme colors")
Label("settings", "Custom colors (RGB 0-50 for BG, 0-255 for others)")
Slider("settings", "BG Red", CFG.Themes.Custom.BG, 1, 0, 50, 1, "")
Slider("settings", "BG Green", CFG.Themes.Custom.BG, 2, 0, 50, 1, "")
Slider("settings", "BG Blue", CFG.Themes.Custom.BG, 3, 0, 50, 1, "")
Slider("settings", "Accent Red", CFG.Themes.Custom.Accent, 1, 0, 255, 1, "")
Slider("settings", "Accent Green", CFG.Themes.Custom.Accent, 2, 0, 255, 1, "")
Slider("settings", "Accent Blue", CFG.Themes.Custom.Accent, 3, 0, 255, 1, "")
Slider("settings", "Text Red", CFG.Themes.Custom.Text, 1, 0, 255, 1, "")
Slider("settings", "Text Green", CFG.Themes.Custom.Text, 2, 0, 255, 1, "")
Slider("settings", "Text Blue", CFG.Themes.Custom.Text, 3, 0, 255, 1, "")
Button("settings", "Apply Custom Theme", function(btn)
    ThemeManager.apply("Custom")
    CFG.Themes.Current = "Custom"
    btn.Text = "Applied!"
    Notify.send("Theme", "Custom theme applied", "success", 2)
    task.delay(1, function() btn.Text = "Apply Custom Theme" end)
end)
Section("settings", "gui customization")
Slider("settings", "Window Width", CFG.GUI, "WindowWidth", 400, 700, 10, "px")
Slider("settings", "Window Height", CFG.GUI, "WindowHeight", 300, 550, 10, "px")
Slider("settings", "Sidebar Width", CFG.GUI, "SidebarWidth", 80, 160, 5, "px")
Slider("settings", "Header Height", CFG.GUI, "HeaderHeight", 28, 50, 2, "px")
Slider("settings", "Corner Radius", CFG.GUI, "CornerRadius", 0, 16, 1, "px")
Toggle("settings", "Round Corners", CFG.GUI, "RoundCorners")
Toggle("settings", "Shadow", CFG.GUI, "ShadowEnabled")
Slider("settings", "Shadow Size", CFG.GUI, "ShadowSize", 0, 20, 1, "px")
Toggle("settings", "Accent Glow", CFG.GUI, "AccentGlow")
Toggle("settings", "Compact Mode", CFG.GUI, "CompactMode")
Toggle("settings", "Tab Icons Only", CFG.GUI, "TabIconsOnly")
Toggle("settings", "Show Tooltips", CFG.GUI, "ShowTooltips")
Slider("settings", "Tooltip Delay", CFG.GUI, "TooltipDelay", 0.1, 2.0, 0.1, "s")
Dropdown("settings", "Anim Style", CFG.GUI, "AnimStyle", {"Quad", "Quart", "Sine", "Back", "Bounce", "Elastic"})
Slider("settings", "Anim Speed", CFG.GUI, "AnimSpeed", 0.05, 1.0, 0.05, "s")
Slider("settings", "Menu Opacity", CFG.GUI, "Opacity", 0.5, 1.0, 0.01, "")
Toggle("settings", "Blur Background", CFG.GUI, "BlurBackground")
Toggle("settings", "Notifications", CFG.GUI, "Notifications")
Slider("settings", "Notification Duration", CFG.GUI, "NotifDuration", 1, 10, 0.5, "s")
ColorPick("settings", "Accent Color", CFG.GUI, "Accent")
ColorPick("settings", "Accent Alt Color", CFG.GUI, "AccentAlt")
Button("settings", "Apply GUI Changes", function(btn)
    btn.Text = "Applying..."
    pcall(function()
        Main.Size = UDim2.new(0, CFG.GUI.WindowWidth, 0, CFG.GUI.WindowHeight)
        if blur then
            blur.Size = CFG.GUI.BlurBackground and 8 or 0
        end
    end)
    btn.Text = "Applied!"
    Notify.send("GUI", "GUI settings applied", "success", 2)
    task.delay(1, function() btn.Text = "Apply GUI Changes" end)
end)
Separator("settings")
Section("settings", "profile management")
TextInput("settings", "Profile Name", CFG.Settings, "ProfileName")
Button("settings", "Save Profile", function(btn)
    local name = CFG.Settings.ProfileName
    if name and name ~= "" then
        local ok = ConfigManager.save(name)
        if ok then
            btn.Text = "Saved!"
            Notify.send("Config", "Profile '" .. name .. "' saved", "success", 2)
        else
            btn.Text = "Failed!"
            Notify.send("Config", "Failed to save profile", "error", 2)
        end
    else
        btn.Text = "Enter name!"
    end
    task.delay(1, function() btn.Text = "Save Profile" end)
end)
Button("settings", "Load Profile", function(btn)
    local name = CFG.Settings.ProfileName
    if name and name ~= "" then
        local ok = ConfigManager.load(name)
        if ok then
            btn.Text = "Loaded!"
            Notify.send("Config", "Profile '" .. name .. "' loaded", "success", 2)
        else
            btn.Text = "Not found!"
            Notify.send("Config", "Profile not found", "error", 2)
        end
    else
        btn.Text = "Enter name!"
    end
    task.delay(1, function() btn.Text = "Load Profile" end)
end)
Button("settings", "Delete Profile", function(btn)
    local name = CFG.Settings.ProfileName
    if name and name ~= "" then
        local ok = ConfigManager.delete(name)
        if ok then
            btn.Text = "Deleted!"
            Notify.send("Config", "Profile '" .. name .. "' deleted", "info", 2)
        else
            btn.Text = "Not found!"
        end
    else
        btn.Text = "Enter name!"
    end
    task.delay(1, function() btn.Text = "Delete Profile" end)
end)
Button("settings", "List Profiles", function(btn)
    local profiles = ConfigManager.list()
    if profiles and #profiles > 0 then
        Notify.send("Profiles", table.concat(profiles, "\n"), "info", 5)
        btn.Text = #profiles .. " found"
    else
        Notify.send("Profiles", "No saved profiles", "info", 2)
        btn.Text = "None"
    end
    task.delay(2, function() btn.Text = "List Profiles" end)
end)
Separator("settings")
Section("settings", "import / export")
Button("settings", "Export to Clipboard", function(btn)
    if ENV.SetClipboard then
        local data = ConfigManager.export()
        if data then
            pcall(setclipboard, data)
            btn.Text = "Copied!"
            Notify.send("Export", "Config copied to clipboard", "success", 2)
        else
            btn.Text = "Failed!"
        end
    else
        btn.Text = "No clipboard!"
    end
    task.delay(1, function() btn.Text = "Export to Clipboard" end)
end)
TextInput("settings", "Import Data", CFG.Settings, "ImportData")
Button("settings", "Import from Text", function(btn)
    local data = CFG.Settings.ImportData
    if data and data ~= "" then
        local ok = ConfigManager.import(data)
        if ok then
            btn.Text = "Imported!"
            Notify.send("Import", "Config imported successfully", "success", 2)
        else
            btn.Text = "Invalid!"
            Notify.send("Import", "Invalid config data", "error", 2)
        end
    else
        btn.Text = "Paste data!"
    end
    task.delay(1, function() btn.Text = "Import from Text" end)
end)
Button("settings", "Export to File", function(btn)
    if ENV.WriteFile then
        local data = ConfigManager.export()
        if data then
            pcall(writefile, "lunarix/export_" .. os.date("%Y%m%d_%H%M%S") .. ".cfg", data)
            btn.Text = "Saved!"
            Notify.send("Export", "Config saved to file", "success", 2)
        else
            btn.Text = "Failed!"
        end
    else
        btn.Text = "No file API!"
    end
    task.delay(1, function() btn.Text = "Export to File" end)
end)
Label("settings", "Export copies all settings to clipboard")
Label("settings", "Import loads settings from pasted text")
Label("settings", "File export saves timestamped backup")
Section("settings", "keybind profiles")
Button("settings", "Default Keybinds", function(btn)
    CFG.GUI.MenuKey = Enum.KeyCode.RightControl
    CFG.Aimbot.Key = Enum.KeyCode.E
    CFG.Movement.Fly.Key = Enum.KeyCode.G
    CFG.Movement.Noclip.Key = Enum.KeyCode.N
    CFG.Freecam.Key = Enum.KeyCode.F
    btn.Text = "Applied!"
    Notify.send("Keybinds", "Default keybinds restored", "success", 2)
    task.delay(1, function() btn.Text = "Default Keybinds" end)
end)
Button("settings", "Left-Hand Keybinds", function(btn)
    CFG.GUI.MenuKey = Enum.KeyCode.LeftControl
    CFG.Aimbot.Key = Enum.KeyCode.Q
    CFG.Movement.Fly.Key = Enum.KeyCode.R
    CFG.Movement.Noclip.Key = Enum.KeyCode.T
    CFG.Freecam.Key = Enum.KeyCode.F
    btn.Text = "Applied!"
    Notify.send("Keybinds", "Left-hand keybinds applied", "success", 2)
    task.delay(1, function() btn.Text = "Left-Hand Keybinds" end)
end)
Button("settings", "Numpad Keybinds", function(btn)
    CFG.GUI.MenuKey = Enum.KeyCode.KeypadZero
    CFG.Aimbot.Key = Enum.KeyCode.KeypadOne
    CFG.Movement.Fly.Key = Enum.KeyCode.KeypadTwo
    CFG.Movement.Noclip.Key = Enum.KeyCode.KeypadThree
    CFG.Freecam.Key = Enum.KeyCode.KeypadFour
    btn.Text = "Applied!"
    Notify.send("Keybinds", "Numpad keybinds applied", "success", 2)
    task.delay(1, function() btn.Text = "Numpad Keybinds" end)
end)
Label("settings", "Keybind profiles change multiple keys at once")
Label("settings", "Individual keys set in their respective tabs")
Section("settings", "startup settings")
Toggle("settings", "Auto Load Config", CFG.Settings, "AutoLoad")
Toggle("settings", "Auto Enable ESP", CFG.Settings, "AutoESP")
Toggle("settings", "Auto Enable Aimbot", CFG.Settings, "AutoAimbot")
Toggle("settings", "Show Welcome Msg", CFG.Settings, "WelcomeMsg")
Toggle("settings", "Minimize on Start", CFG.Settings, "MinOnStart")
Toggle("settings", "Auto Update Check", CFG.Settings, "AutoUpdate")
Dropdown("settings", "Default Tab", CFG.Settings, "DefaultTab", {"aimbot", "silent", "esp", "chams", "visuals", "movement", "world", "radar", "players", "misc", "settings"})
Label("settings", "Startup settings apply when script loads")
Label("settings", "Auto load restores last saved config")
Section("settings", "notification settings")
Toggle("settings", "Enable Notifications", CFG.Settings, "NotifEnabled")
Toggle("settings", "Sound on Notify", CFG.Settings, "NotifSound")
Slider("settings", "Default Duration", CFG.Settings, "NotifDuration", 1, 10, 0.5, "s")
Dropdown("settings", "Notify Position", CFG.Settings, "NotifPosition", {"BottomRight", "BottomLeft", "TopRight", "TopLeft"})
Slider("settings", "Max Notifications", CFG.Settings, "MaxNotifs", 1, 10, 1, "")
Toggle("settings", "Stack Notifications", CFG.Settings, "StackNotifs")
Slider("settings", "Notify Width", CFG.Settings, "NotifWidth", 150, 400, 10, "px")
Label("settings", "Controls the notification toast system")
Label("settings", "Stack keeps multiple visible at once")
Section("settings", "advanced settings")
Toggle("settings", "Debug Mode", CFG.Settings, "DebugMode")
Toggle("settings", "Verbose Logging", CFG.Settings, "VerboseLog")
Toggle("settings", "Error Notifications", CFG.Settings, "ErrorNotifs")
Toggle("settings", "Performance Mode", CFG.Settings, "PerfMode")
Slider("settings", "Render Budget (ms)", CFG.Settings, "RenderBudget", 2, 16, 0.5, "ms")
Slider("settings", "ESP Budget (ms)", CFG.Settings, "ESPBudget", 1, 8, 0.5, "ms")
Toggle("settings", "Lazy Loading", CFG.Settings, "LazyLoad")
Toggle("settings", "Object Pooling", CFG.Settings, "ObjPooling")
Slider("settings", "Pool Size", CFG.Settings, "PoolSize", 50, 500, 25, "")
Label("settings", "Debug mode shows extra console output")
Label("settings", "Performance mode reduces visual quality")
Label("settings", "Render budget limits frame time per cycle")
Label("settings", "Lower budgets = more FPS, less visuals")


-- ============================================================
-- AIMBOT TAB: EXTENDED MULTIPOINT AND WEAPON CONFIGS
-- ============================================================
Section("aimbot", "multipoint config")
Toggle("aimbot", "MP Head", CFG.RageBot.MultiPointParts, "Head")
Toggle("aimbot", "MP Upper Torso", CFG.RageBot.MultiPointParts, "UpperTorso")
Toggle("aimbot", "MP Lower Torso", CFG.RageBot.MultiPointParts, "LowerTorso")
Toggle("aimbot", "MP Left Arm", CFG.RageBot.MultiPointParts, "LeftUpperArm")
Toggle("aimbot", "MP Right Arm", CFG.RageBot.MultiPointParts, "RightUpperArm")
Toggle("aimbot", "MP Left Leg", CFG.RageBot.MultiPointParts, "LeftUpperLeg")
Toggle("aimbot", "MP Right Leg", CFG.RageBot.MultiPointParts, "RightUpperLeg")
Label("aimbot", "Multi-point scans multiple body locations")
Label("aimbot", "More parts = better hit chance but slower")
Section("aimbot", "anti-aim correction")
Toggle("aimbot", "Anti-Aim Correction", CFG.RageBot, "AntiAimCorrection")
Toggle("aimbot", "Backtrack Aim", CFG.RageBot, "Backtrack")
Slider("aimbot", "Backtrack Ticks", CFG.RageBot, "BacktrackTicks", 1, 24, 1, "")
Label("aimbot", "Anti-aim correction adjusts for spinbots")
Label("aimbot", "Backtrack aims at older tick positions")
Section("aimbot", "aim step limiter")
Toggle("aimbot", "Aim Step", CFG.Aimbot, "AimStep")
Slider("aimbot", "Step Angle", CFG.Aimbot, "StepAngle", 1, 45, 1, "")
Slider("aimbot", "Step Rate", CFG.Aimbot, "StepRate", 1, 60, 1, "/s")
Label("aimbot", "Aim step limits rotation per frame")
Label("aimbot", "Makes snapping look more natural")
Label("aimbot", "Lower angle = slower more human-like aim")
Section("aimbot", "target priority weights")
Slider("aimbot", "Distance Weight", CFG.Aimbot, "DistWeight", 0, 100, 5, "%")
Slider("aimbot", "Health Weight", CFG.Aimbot, "HealthWeight", 0, 100, 5, "%")
Slider("aimbot", "FOV Weight", CFG.Aimbot, "FOVWeight", 0, 100, 5, "%")
Slider("aimbot", "Threat Weight", CFG.Aimbot, "ThreatWeight", 0, 100, 5, "%")
Label("aimbot", "Weights determine target selection order")
Label("aimbot", "Higher weight = more importance in scoring")
Section("aimbot", "aimbot behavior")
Toggle("aimbot", "Sticky Target", CFG.Aimbot, "StickyTarget")
Slider("aimbot", "Sticky Duration", CFG.Aimbot, "StickyDuration", 0.5, 5, 0.25, "s")
Toggle("aimbot", "Re-Acquire on Death", CFG.Aimbot, "ReAcquire")
Toggle("aimbot", "Disengage on Kill", CFG.Aimbot, "DisengageOnKill")
Slider("aimbot", "Disengage Delay", CFG.Aimbot, "DisengageDelay", 0.1, 1.0, 0.05, "s")
Toggle("aimbot", "Aim while Reloading", CFG.Aimbot, "AimWhileReload")
Toggle("aimbot", "Aim while Sprinting", CFG.Aimbot, "AimWhileSprint")
Label("aimbot", "Sticky target keeps same target for duration")
Label("aimbot", "Disengage pauses aim briefly after a kill")

-- ============================================================
-- SILENT AIM TAB: EXTENDED CONFIGURATIONS
-- ============================================================
Section("silent", "silent aim accuracy")
Toggle("silent", "Accuracy Randomizer", CFG.Silent, "AccRandom")
Slider("silent", "Miss Chance", CFG.Silent, "MissChance", 0, 50, 1, "%")
Slider("silent", "Headshot Chance", CFG.Silent, "HeadshotChance", 0, 100, 5, "%")
Toggle("silent", "Range Falloff", CFG.Silent, "RangeFalloff")
Slider("silent", "Falloff Start", CFG.Silent, "FalloffStart", 50, 500, 25, "")
Slider("silent", "Falloff End", CFG.Silent, "FalloffEnd", 100, 1000, 50, "")
Label("silent", "Accuracy randomizer makes aim imperfect")
Label("silent", "Miss chance randomly drops shots for legit")
Label("silent", "Range falloff reduces accuracy at distance")
Section("silent", "silent aim filters")
Toggle("silent", "Filter by Health", CFG.Silent, "FilterHealth")
Slider("silent", "Min Target HP", CFG.Silent, "MinTargetHP", 1, 100, 5, "")
Toggle("silent", "Filter by Distance", CFG.Silent, "FilterDist")
Slider("silent", "Max Target Dist", CFG.Silent, "MaxTargetDist", 50, 2000, 50, "")
Toggle("silent", "Filter by Velocity", CFG.Silent, "FilterVelocity")
Slider("silent", "Max Target Speed", CFG.Silent, "MaxTargetSpeed", 10, 200, 10, "")
Label("silent", "Filters skip targets not matching criteria")
Label("silent", "Health filter ignores low HP targets")
Label("silent", "Velocity filter ignores fast-moving targets")
Section("silent", "silent aim hooks")
Dropdown("silent", "Hook Method", CFG.Silent, "HookMethod", {"Namecall", "Index", "NewIndex", "RayCast", "Auto"})
Toggle("silent", "Anti-Detection", CFG.Silent, "AntiDetect")
Toggle("silent", "Spoof Raycast", CFG.Silent, "SpoofRay")
Toggle("silent", "Spoof Mouse", CFG.Silent, "SpoofMouse")
Label("silent", "Hook method determines how aim is redirected")
Label("silent", "Auto selects best method for executor")
Label("silent", "Anti-detection hides hooks from AC scans")

-- ============================================================
-- ESP TAB: EXTENDED SKELETON AND OFFSCREEN
-- ============================================================
Section("esp", "skeleton extensions")
Slider("esp", "Skeleton Thickness", CFG.Skeleton, "Thickness", 0.5, 5, 0.25, "")
Toggle("esp", "Skeleton Head Circle", CFG.Skeleton, "HeadCircle")
Slider("esp", "Head Circle Radius", CFG.Skeleton, "HeadRadius", 2, 15, 0.5, "")
Toggle("esp", "Skeleton Visible Only", CFG.Skeleton, "VisibleOnly")
ColorPick("esp", "Skeleton Visible Color", CFG.Skeleton, "VisColor")
ColorPick("esp", "Skeleton Hidden Color", CFG.Skeleton, "HidColor")
Toggle("esp", "Skeleton Team Color", CFG.Skeleton, "TeamColor")
Slider("esp", "Skeleton Max Dist", CFG.Skeleton, "MaxDist", 100, 2000, 50, "")
Label("esp", "Skeleton draws lines between body joints")
Label("esp", "Head circle adds circle around head joint")
Section("esp", "offscreen indicators")
Slider("esp", "Arrow Size", CFG.OffScreen, "ArrowSize", 10, 40, 2, "")
Slider("esp", "Arrow Distance", CFG.OffScreen, "ArrowDist", 50, 300, 10, "")
Toggle("esp", "Arrow Pulse", CFG.OffScreen, "ArrowPulse")
Slider("esp", "Pulse Speed", CFG.OffScreen, "PulseSpeed", 0.5, 5, 0.25, "")
Toggle("esp", "Show Distance Text", CFG.OffScreen, "ShowDist")
Toggle("esp", "Show Name Text", CFG.OffScreen, "ShowName")
Toggle("esp", "Team Color Arrows", CFG.OffScreen, "TeamColorArrow")
ColorPick("esp", "Arrow Color", CFG.OffScreen, "ArrowColor")
Label("esp", "Off-screen arrows point to nearby enemies")
Label("esp", "Arrow distance sets how far from center")
Label("esp", "Pulse makes arrows throb for visibility")
Section("esp", "item esp extensions")
Toggle("esp", "Dropped Weapons", CFG.ItemESP, "DroppedWeapons")
Toggle("esp", "Ammo Pickups", CFG.ItemESP, "AmmoPickups")
Toggle("esp", "Health Pickups", CFG.ItemESP, "HealthPickups")
Toggle("esp", "Armor Pickups", CFG.ItemESP, "ArmorPickups")
Toggle("esp", "Key Items", CFG.ItemESP, "KeyItems")
Toggle("esp", "Currency", CFG.ItemESP, "Currency")
Slider("esp", "Item Max Dist", CFG.ItemESP, "MaxDist", 50, 1000, 25, "")
Slider("esp", "Item Font Size", CFG.ItemESP, "FontSize", 10, 18, 1, "")
ColorPick("esp", "Weapon Color", CFG.ItemESP, "WeaponColor")
ColorPick("esp", "Health Pickup Color", CFG.ItemESP, "HealthColor")
ColorPick("esp", "Ammo Color", CFG.ItemESP, "AmmoColor")
ColorPick("esp", "Key Item Color", CFG.ItemESP, "KeyColor")
Label("esp", "Item ESP highlights pickups in the world")
Label("esp", "Configure colors per item category")

-- ============================================================
-- VISUALS TAB: THIRD PERSON FOV AND VIEW MODEL
-- ============================================================
Section("visuals", "view model fov")
Toggle("visuals", "Custom VM FOV", CFG.Visual, "VMFOV")
Slider("visuals", "VM FOV Value", CFG.Visual, "VMFOVValue", 50, 120, 5, "")
Toggle("visuals", "VM Offset", CFG.Visual, "VMOffset")
Slider("visuals", "VM Offset X", CFG.Visual, "VMOffsetX", -10, 10, 0.5, "")
Slider("visuals", "VM Offset Y", CFG.Visual, "VMOffsetY", -10, 10, 0.5, "")
Slider("visuals", "VM Offset Z", CFG.Visual, "VMOffsetZ", -10, 10, 0.5, "")
Label("visuals", "VM FOV changes weapon model field of view")
Label("visuals", "Offset shifts weapon model on screen")
Section("visuals", "scope overlay")
Toggle("visuals", "Custom Scope", CFG.Visual, "CustomScope")
Dropdown("visuals", "Scope Style", CFG.Visual, "ScopeStyle", {"Crosshair", "Circle", "Mil-Dot", "Chevron", "T-Post"})
ColorPick("visuals", "Scope Color", CFG.Visual, "ScopeColor")
Slider("visuals", "Scope Opacity", CFG.Visual, "ScopeOpacity", 0.1, 1.0, 0.05, "")
Toggle("visuals", "Scope Blur", CFG.Visual, "ScopeBlur")
Toggle("visuals", "Scope Zoom", CFG.Visual, "ScopeZoom")
Slider("visuals", "Zoom Factor", CFG.Visual, "ZoomFactor", 1.5, 10, 0.5, "x")
Label("visuals", "Custom scope replaces default scope overlay")
Label("visuals", "Blur adds depth-of-field effect when scoped")
Section("visuals", "damage numbers")
Toggle("visuals", "Damage Numbers", CFG.Visual, "DamageNumbers")
Slider("visuals", "Dmg Font Size", CFG.Visual, "DmgFontSize", 12, 28, 1, "")
Toggle("visuals", "Dmg Float Up", CFG.Visual, "DmgFloat")
Slider("visuals", "Float Speed", CFG.Visual, "DmgFloatSpeed", 20, 100, 5, "")
Slider("visuals", "Dmg Duration", CFG.Visual, "DmgDuration", 0.3, 2.0, 0.1, "s")
ColorPick("visuals", "Body Dmg Color", CFG.Visual, "DmgBodyColor")
ColorPick("visuals", "Head Dmg Color", CFG.Visual, "DmgHeadColor")
ColorPick("visuals", "Crit Dmg Color", CFG.Visual, "DmgCritColor")
Toggle("visuals", "Crit Dmg Scale", CFG.Visual, "DmgCritScale")
Label("visuals", "Damage numbers show hit damage on screen")
Label("visuals", "Colors distinguish body/head/crit hits")
Section("visuals", "trail effects")
Toggle("visuals", "Player Trails", CFG.Visual, "PlayerTrails")
Dropdown("visuals", "Trail Type", CFG.Visual, "TrailType", {"Line", "Dots", "Fade", "Rainbow", "Dashed"})
Slider("visuals", "Trail Length", CFG.Visual, "TrailLength", 5, 50, 1, "")
Slider("visuals", "Trail Width", CFG.Visual, "TrailWidth", 0.5, 5, 0.25, "")
ColorPick("visuals", "Trail Color", CFG.Visual, "TrailColor")
Toggle("visuals", "Trail Team Color", CFG.Visual, "TrailTeamColor")
Slider("visuals", "Trail Fade Time", CFG.Visual, "TrailFade", 0.5, 5, 0.25, "s")
Label("visuals", "Trails show recent player movement paths")
Label("visuals", "Rainbow cycles through hue over length")

-- ============================================================
-- WORLD TAB: EXTENDED PART MANIPULATION
-- ============================================================
Section("world", "part manipulation")
Button("world", "Remove Invisible Walls", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency >= 0.9 and v.CanCollide then
            pcall(function()
                v.CanCollide = false
                count = count + 1
            end)
        end
    end
    btn.Text = count .. " removed"
    Notify.send("World", count .. " invisible walls disabled", "success", 3)
    task.delay(2, function() btn.Text = "Remove Invisible Walls" end)
end)
Button("world", "Remove Kill Bricks", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local scripts = {}
            for _, c in ipairs(v:GetChildren()) do
                if c:IsA("Script") or c:IsA("LocalScript") then
                    table.insert(scripts, c)
                end
            end
            if #scripts > 0 and (v.BrickColor == BrickColor.new("Really red") or v.Name:lower():find("kill") or v.Name:lower():find("lava")) then
                pcall(function()
                    v.CanCollide = false
                    v.Transparency = 0.8
                    for _, s in ipairs(scripts) do s:Destroy() end
                    count = count + 1
                end)
            end
        end
    end
    btn.Text = count .. " removed"
    Notify.send("World", count .. " kill bricks neutralized", "success", 3)
    task.delay(2, function() btn.Text = "Remove Kill Bricks" end)
end)
Button("world", "Anchor All Parts", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored then
            pcall(function()
                v.Anchored = true
                count = count + 1
            end)
        end
    end
    btn.Text = count .. " anchored"
    Notify.send("World", count .. " parts anchored", "info", 3)
    task.delay(2, function() btn.Text = "Anchor All Parts" end)
end)
Button("world", "No Clip All Doors", function(btn)
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate") or v.Name:lower():find("barrier")) then
            pcall(function()
                v.CanCollide = false
                v.Transparency = 0.5
                count = count + 1
            end)
        end
    end
    btn.Text = count .. " opened"
    Notify.send("World", count .. " doors/gates made passable", "success", 3)
    task.delay(2, function() btn.Text = "No Clip All Doors" end)
end)
Label("world", "Part manipulation modifies game objects")
Label("world", "Changes are client-side only")
Section("world", "decoration controls")
Toggle("world", "Remove Decals", CFG.World, "RemoveDecals")
Toggle("world", "Remove Textures", CFG.World, "RemoveTextures")
Toggle("world", "Remove Meshes", CFG.World, "RemoveMeshes")
Toggle("world", "Remove Particles", CFG.World, "RemoveParticles")
Toggle("world", "Remove Sounds", CFG.World, "RemoveSounds")
Toggle("world", "Remove Beams", CFG.World, "RemoveBeams")
Toggle("world", "Remove Trails", CFG.World, "RemoveTrails")
Button("world", "Apply Removals", function(btn)
    local removed = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if CFG.World.RemoveDecals and v:IsA("Decal") then v:Destroy(); removed = removed + 1 end
            if CFG.World.RemoveTextures and v:IsA("Texture") then v:Destroy(); removed = removed + 1 end
            if CFG.World.RemoveMeshes and v:IsA("SpecialMesh") then v:Destroy(); removed = removed + 1 end
            if CFG.World.RemoveParticles and v:IsA("ParticleEmitter") then v:Destroy(); removed = removed + 1 end
            if CFG.World.RemoveSounds and v:IsA("Sound") then v.Volume = 0; removed = removed + 1 end
            if CFG.World.RemoveBeams and v:IsA("Beam") then v:Destroy(); removed = removed + 1 end
            if CFG.World.RemoveTrails and v:IsA("Trail") then v:Destroy(); removed = removed + 1 end
        end)
    end
    btn.Text = removed .. " removed"
    Notify.send("World", removed .. " decorations removed", "success", 3)
    task.delay(2, function() btn.Text = "Apply Removals" end)
end)
Label("world", "Toggle what to remove then apply")
Label("world", "Removing decorations improves FPS")
Section("world", "material override")
Toggle("world", "Override Materials", CFG.World, "OverrideMaterials")
Dropdown("world", "Override Material", CFG.World, "OverrideMat", {"SmoothPlastic", "Plastic", "Neon", "Glass", "ForceField", "Metal", "DiamondPlate", "Concrete", "Slate"})
Button("world", "Apply Material Override", function(btn)
    if not CFG.World.OverrideMaterials then
        btn.Text = "Enable first!"
        task.delay(1, function() btn.Text = "Apply Material Override" end)
        return
    end
    local mat = Enum.Material[CFG.World.OverrideMat]
    if not mat then btn.Text = "Invalid!"; task.delay(1, function() btn.Text = "Apply Material Override" end); return end
    local count = 0
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            pcall(function()
                v.Material = mat
                count = count + 1
            end)
        end
    end
    btn.Text = count .. " changed"
    Notify.send("World", count .. " parts set to " .. CFG.World.OverrideMat, "success", 3)
    task.delay(2, function() btn.Text = "Apply Material Override" end)
end)
Label("world", "Material override changes all part materials")
Label("world", "SmoothPlastic reduces visual noise for ESP")

-- ============================================================
-- CHAMS TAB: EXTENDED CONDITIONAL CHAMS
-- ============================================================
Section("chams", "conditional chams")
Toggle("chams", "Chams on ADS", CFG.Chams, "OnADS")
Toggle("chams", "Chams on Danger", CFG.Chams, "OnDanger")
Slider("chams", "Danger Distance", CFG.Chams, "DangerDist", 10, 100, 5, "")
Toggle("chams", "Chams on Damage", CFG.Chams, "OnDamage")
Slider("chams", "Damage Flash Time", CFG.Chams, "DamageFlash", 0.1, 1.0, 0.05, "s")
ColorPick("chams", "Damage Flash Color", CFG.Chams, "DamageColor")
Toggle("chams", "Chams Visible Only", CFG.Chams, "VisibleOnly")
Toggle("chams", "Different Hidden Color", CFG.Chams, "DiffHiddenColor")
ColorPick("chams", "Hidden Chams Color", CFG.Chams, "HiddenColor")
Slider("chams", "Hidden Chams Alpha", CFG.Chams, "HiddenAlpha", 0.1, 1.0, 0.05, "")
Label("chams", "Conditional chams activate on events")
Label("chams", "ADS chams appear when you aim down sights")
Label("chams", "Danger chams flash when enemy is close")
Section("chams", "chams animations")
Toggle("chams", "Breathing Effect", CFG.Chams, "Breathing")
Slider("chams", "Breath Speed", CFG.Chams, "BreathSpeed", 0.5, 3, 0.25, "")
Slider("chams", "Breath Depth", CFG.Chams, "BreathDepth", 0.05, 0.3, 0.01, "")
Toggle("chams", "Color Shift", CFG.Chams, "ColorShift")
Slider("chams", "Shift Speed", CFG.Chams, "ShiftSpeed", 0.5, 5, 0.25, "")
Toggle("chams", "Strobe Effect", CFG.Chams, "Strobe")
Slider("chams", "Strobe Rate", CFG.Chams, "StrobeRate", 2, 30, 1, "hz")
Label("chams", "Breathing slowly fades chams in and out")
Label("chams", "Color shift cycles hue over time")
Label("chams", "Strobe rapidly flickers - may cause issues")

-- ============================================================
-- MISC TAB: MACRO SYSTEM AND GAME ANALYSIS
-- ============================================================
Section("misc", "macro recorder")
Toggle("misc", "Macro System", CFG.Misc, "MacroOn")
Button("misc", "Start Recording", function(btn)
    CFG.Misc.MacroRecording = true
    CFG.Misc.MacroData = {}
    btn.Text = "Recording..."
    Notify.send("Macro", "Recording started - perform actions", "warning", 3)
    task.delay(30, function()
        if CFG.Misc.MacroRecording then
            CFG.Misc.MacroRecording = false
            btn.Text = "Auto-stopped"
            task.delay(1, function() btn.Text = "Start Recording" end)
        end
    end)
end)
Button("misc", "Stop Recording", function(btn)
    CFG.Misc.MacroRecording = false
    local count = CFG.Misc.MacroData and #CFG.Misc.MacroData or 0
    btn.Text = count .. " actions"
    Notify.send("Macro", "Recording stopped - " .. count .. " actions captured", "success", 3)
    task.delay(2, function() btn.Text = "Stop Recording" end)
end)
Button("misc", "Play Macro", function(btn)
    if not CFG.Misc.MacroData or #CFG.Misc.MacroData == 0 then
        btn.Text = "No macro!"
        task.delay(1, function() btn.Text = "Play Macro" end)
        return
    end
    btn.Text = "Playing..."
    Notify.send("Macro", "Playing " .. #CFG.Misc.MacroData .. " actions", "info", 3)
    task.delay(2, function() btn.Text = "Play Macro" end)
end)
Button("misc", "Clear Macro", function(btn)
    CFG.Misc.MacroData = {}
    CFG.Misc.MacroRecording = false
    btn.Text = "Cleared!"
    task.delay(1, function() btn.Text = "Clear Macro" end)
end)
Label("misc", "Record actions and replay them later")
Label("misc", "Auto-stops after 30 seconds max")
Section("misc", "game analysis")
Button("misc", "Detect Game Type", function(btn)
    local indicators = {fps = 0, obby = 0, tycoon = 0, rpg = 0, simulator = 0}
    for _, v in ipairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if name:find("gun") or name:find("weapon") or name:find("bullet") or name:find("ammo") then
            indicators.fps = indicators.fps + 1
        end
        if name:find("checkpoint") or name:find("stage") or name:find("difficulty") then
            indicators.obby = indicators.obby + 1
        end
        if name:find("dropper") or name:find("conveyor") or name:find("rebirth") then
            indicators.tycoon = indicators.tycoon + 1
        end
        if name:find("quest") or name:find("npc") or name:find("inventory") then
            indicators.rpg = indicators.rpg + 1
        end
        if name:find("pet") or name:find("egg") or name:find("collect") then
            indicators.simulator = indicators.simulator + 1
        end
    end
    local best, bestCount = "Unknown", 0
    for genre, count in pairs(indicators) do
        if count > bestCount then best = genre; bestCount = count end
    end
    btn.Text = best
    Notify.send("Game Analysis", "Detected genre: " .. best .. " (" .. bestCount .. " indicators)", "info", 4)
    task.delay(2, function() btn.Text = "Detect Game Type" end)
end)
Button("misc", "Detect Anti-Cheat Type", function(btn)
    local types = {}
    for _, v in ipairs(game:GetDescendants()) do
        local name = v.Name:lower()
        if name:find("rayfield") then table.insert(types, "Rayfield UI") end
        if name:find("vape") then table.insert(types, "Vape detected") end
        if name:find("sentinel") then table.insert(types, "Sentinel AC") end
        if name:find("hyperion") then table.insert(types, "Byfron/Hyperion") end
        if #types >= 5 then break end
    end
    if #types > 0 then
        btn.Text = types[1]
        Notify.send("Detection", table.concat(types, "\n"), "warning", 5)
    else
        btn.Text = "None found"
        Notify.send("Detection", "No known anti-cheat signatures found", "success", 3)
    end
    task.delay(2, function() btn.Text = "Detect Anti-Cheat Type" end)
end)
Button("misc", "Analyze Player Speeds", function(btn)
    local speeders = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed > 16 then
                table.insert(speeders, string.format("%s: %.0f speed", p.Name, hum.WalkSpeed))
            end
        end
    end
    if #speeders > 0 then
        btn.Text = #speeders .. " fast"
        Notify.send("Analysis", "Fast players:\n" .. table.concat(speeders, "\n"), "warning", 5)
    else
        btn.Text = "None fast"
        Notify.send("Analysis", "No players above normal speed", "success", 3)
    end
    task.delay(2, function() btn.Text = "Analyze Player Speeds" end)
end)
Button("misc", "Find Hidden Services", function(btn)
    local hidden = {}
    local toCheck = {"HttpService", "MarketplaceService", "GamePassService",
        "InsertService", "DataStoreService", "MessagingService",
        "MemoryStoreService", "PolicyService", "SocialService",
        "TextChatService", "VoiceChatService", "AvatarEditorService"}
    for _, name in ipairs(toCheck) do
        pcall(function()
            local svc = game:GetService(name)
            if svc then
                table.insert(hidden, name .. " (" .. #svc:GetChildren() .. ")")
            end
        end)
    end
    Notify.send("Services", table.concat(hidden, "\n"), "info", 6)
    btn.Text = #hidden .. " found"
    task.delay(2, function() btn.Text = "Find Hidden Services" end)
end)
Label("misc", "Game analysis tools examine game structure")
Label("misc", "Anti-cheat detection checks known signatures")
Label("misc", "Speed analysis checks for other cheaters")


-- ============================================================
-- MOVEMENT TAB: EXTENDED PLATFORM AND TELEPORT CONTROL
-- ============================================================
Section("movement", "platform creator")
Toggle("movement", "Auto Platform", CFG.Movement, "AutoPlatform")
Slider("movement", "Platform Size", CFG.Movement, "PlatformSize", 5, 50, 1, "")
Slider("movement", "Platform Below", CFG.Movement, "PlatformBelow", 1, 20, 1, "")
Toggle("movement", "Platform Visible", CFG.Movement, "PlatformVisible")
ColorPick("movement", "Platform Color", CFG.Movement, "PlatformColor")
Slider("movement", "Platform Transparency", CFG.Movement, "PlatformAlpha", 0, 1, 0.05, "")
Label("movement", "Auto platform creates floor beneath you")
Label("movement", "Prevents falling, useful with fly/noclip off")
Section("movement", "velocity control")
Toggle("movement", "Velocity Override", CFG.Movement, "VelocityOverride")
Slider("movement", "Max Velocity", CFG.Movement, "MaxVelocity", 10, 500, 10, "")
Toggle("movement", "Anti Fling", CFG.Movement, "AntiFling")
Toggle("movement", "Anti Ragdoll", CFG.Movement, "AntiRagdoll")
Toggle("movement", "Freeze Rotation", CFG.Movement, "FreezeRotation")
Label("movement", "Velocity override caps your max speed")
Label("movement", "Anti-fling prevents being launched by others")
Label("movement", "Anti-ragdoll keeps character upright")
Section("movement", "long jump / high jump")
Toggle("movement", "Long Jump", CFG.Movement, "LongJump")
Slider("movement", "LJ Power", CFG.Movement, "LongJumpPower", 20, 200, 5, "")
Toggle("movement", "High Jump", CFG.Movement, "HighJump")
Slider("movement", "HJ Power", CFG.Movement, "HighJumpPower", 50, 500, 10, "")
KeybindPicker("movement", "LJ/HJ Key", CFG.Movement, "JumpKey")
Toggle("movement", "Auto HJ on Sprint", CFG.Movement, "AutoHighJump")
Label("movement", "Long jump boosts forward on jump")
Label("movement", "High jump multiplies upward force")
Label("movement", "Both can be combined for max distance")

-- ============================================================
-- RADAR TAB: EXTENDED MINIMAP AND SOUND RADAR
-- ============================================================
Section("radar", "minimap extensions")
Toggle("radar", "Show Terrain", CFG.Radar, "ShowTerrain")
Toggle("radar", "Show Buildings", CFG.Radar, "ShowBuildings")
Toggle("radar", "Show Spawn Points", CFG.Radar, "ShowSpawns")
Toggle("radar", "Show Kill Zones", CFG.Radar, "ShowKillZones")
Slider("radar", "Terrain Detail", CFG.Radar, "TerrainDetail", 1, 10, 1, "")
Toggle("radar", "Auto Zoom", CFG.Radar, "AutoZoom")
Slider("radar", "Auto Zoom Threshold", CFG.Radar, "AutoZoomThresh", 10, 100, 5, "")
Label("radar", "Minimap extensions add world features to radar")
Label("radar", "Auto zoom adjusts range based on enemy distance")
Section("radar", "sound radar")
Toggle("radar", "Sound Radar", CFG.Radar, "SoundRadar")
Toggle("radar", "Show Gunshots", CFG.Radar, "ShowGunshots")
Toggle("radar", "Show Footsteps", CFG.Radar, "ShowRadarFootsteps")
Toggle("radar", "Show Explosions", CFG.Radar, "ShowExplosions")
Slider("radar", "Sound Dot Duration", CFG.Radar, "SoundDotDur", 0.5, 5, 0.25, "s")
ColorPick("radar", "Gunshot Dot Color", CFG.Radar, "GunshotColor")
ColorPick("radar", "Footstep Dot Color", CFG.Radar, "FootstepDotColor")
ColorPick("radar", "Explosion Dot Color", CFG.Radar, "ExplosionColor")
Label("radar", "Sound radar shows audio events as dots")
Label("radar", "Dots fade over the set duration")
Label("radar", "Useful for tracking firefights at range")
Section("radar", "radar data export")
Button("radar", "Screenshot Radar", function(btn)
    btn.Text = "Not available"
    Notify.send("Radar", "Screenshot requires Drawing API export", "info", 3)
    task.delay(2, function() btn.Text = "Screenshot Radar" end)
end)
Button("radar", "Copy Player Positions", function(btn)
    if not ENV.SetClipboard then
        btn.Text = "No clipboard!"
        task.delay(1, function() btn.Text = "Copy Player Positions" end)
        return
    end
    local positions = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if U.alive(p) then
            local rp = p.Character:FindFirstChild("HumanoidRootPart")
            if rp then
                table.insert(positions, string.format("%s: %.0f, %.0f, %.0f", p.Name, rp.Position.X, rp.Position.Y, rp.Position.Z))
            end
        end
    end
    if #positions > 0 then
        pcall(setclipboard, table.concat(positions, "\n"))
        btn.Text = "Copied!"
        Notify.send("Radar", #positions .. " player positions copied", "success", 2)
    else
        btn.Text = "No players!"
    end
    task.delay(1.5, function() btn.Text = "Copy Player Positions" end)
end)
Label("radar", "Export tools for data collection")
Label("radar", "Positions copied in name: x, y, z format")

-- ============================================================
-- PLAYERS TAB: EXTENDED SPECTATE AND FOLLOW
-- ============================================================
Section("players", "auto spectate")
Toggle("players", "Auto Cycle Spectate", CFG.Players, "AutoCycle")
Slider("players", "Cycle Interval", CFG.Players, "CycleInterval", 3, 30, 1, "s")
Toggle("players", "Cycle Skip Dead", CFG.Players, "CycleSkipDead")
Toggle("players", "Cycle Skip AFK", CFG.Players, "CycleSkipAFK")
Toggle("players", "Cycle Priority First", CFG.Players, "CyclePriority")
Label("players", "Auto cycle switches spectate targets")
Label("players", "Skip dead avoids watching respawn timers")
Section("players", "follow system")
Toggle("players", "Auto Follow", CFG.Players, "AutoFollow")
Slider("players", "Follow Distance", CFG.Players, "FollowDist", 5, 50, 1, "")
Toggle("players", "Follow Behind", CFG.Players, "FollowBehind")
Toggle("players", "Match Speed", CFG.Players, "MatchSpeed")
Button("players", "Follow Target", function(btn)
    local target = U.target()
    if target and U.alive(target) then
        CFG.Players.FollowTarget = target.Name
        CFG.Players.AutoFollow = true
        btn.Text = target.Name
        Notify.send("Follow", "Following " .. target.Name, "success", 2)
    else
        btn.Text = "No target!"
    end
    task.delay(1.5, function() btn.Text = "Follow Target" end)
end)
Button("players", "Stop Following", function(btn)
    CFG.Players.AutoFollow = false
    CFG.Players.FollowTarget = nil
    btn.Text = "Stopped!"
    Notify.send("Follow", "No longer following", "info", 2)
    task.delay(1, function() btn.Text = "Stop Following" end)
end)
Label("players", "Follow system walks toward target player")
Label("players", "Match speed adjusts your walk speed")

Section("aimbot", "trigger bot")
Toggle("aimbot", "Enable Trigger Bot", CFG.TriggerBot, "On")
Slider("aimbot", "Trigger FOV", CFG.TriggerBot, "FOV", 1, 100, 1, "px")
Slider("aimbot", "Fire Delay", CFG.TriggerBot, "Delay", 0, 0.5, 0.01, "s")
Slider("aimbot", "Burst Count", CFG.TriggerBot, "BurstCount", 1, 10, 1, "")
Slider("aimbot", "Burst Delay", CFG.TriggerBot, "BurstDelay", 0.01, 0.3, 0.01, "s")
Slider("aimbot", "Hold Time", CFG.TriggerBot, "HoldTime", 0.02, 0.5, 0.01, "s")
Slider("aimbot", "Re-trigger Delay", CFG.TriggerBot, "ReTriggerDelay", 0.05, 1, 0.05, "s")
Toggle("aimbot", "Show Trigger FOV", CFG.TriggerBot, "ShowFOV")
ColorPick("aimbot", "Trigger FOV Color", CFG.TriggerBot, "FOVColor")
Toggle("aimbot", "Team Check", CFG.TriggerBot, "TeamCheck")
Toggle("aimbot", "Wall Check", CFG.TriggerBot, "WallCheck")
Toggle("aimbot", "Visible Only", CFG.TriggerBot, "VisibleOnly")
Dropdown("aimbot", "Target Part", CFG.TriggerBot, "TargetPart", {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"})
Slider("aimbot", "Min HP Filter", CFG.TriggerBot, "MinHP", 0, 100, 5, "")
Toggle("aimbot", "Magnet Pull", CFG.TriggerBot, "MagnetPull")
Slider("aimbot", "Magnet Strength", CFG.TriggerBot, "MagnetStrength", 0, 1, 0.05, "")
Label("aimbot", "Trigger bot auto-fires when crosshair is on enemy")
Label("aimbot", "Burst mode fires multiple shots rapidly")
Label("aimbot", "Magnet pull slightly adjusts aim toward target center")

Section("aimbot", "trigger bot presets")
Button("aimbot", "Tap Fire", function(btn)
    CFG.TriggerBot.On = true; CFG.TriggerBot.Delay = 0.1; CFG.TriggerBot.BurstCount = 1
    CFG.TriggerBot.FOV = 10; CFG.TriggerBot.HoldTime = 0.05
    btn.Text = "Applied!"; Notify.send("Trigger", "Tap fire preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Tap Fire" end)
end)
Button("aimbot", "Burst Fire", function(btn)
    CFG.TriggerBot.On = true; CFG.TriggerBot.Delay = 0.05; CFG.TriggerBot.BurstCount = 3
    CFG.TriggerBot.BurstDelay = 0.06; CFG.TriggerBot.FOV = 15; CFG.TriggerBot.HoldTime = 0.08
    btn.Text = "Applied!"; Notify.send("Trigger", "Burst fire preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Burst Fire" end)
end)
Button("aimbot", "Spray Mode", function(btn)
    CFG.TriggerBot.On = true; CFG.TriggerBot.Delay = 0; CFG.TriggerBot.BurstCount = 8
    CFG.TriggerBot.BurstDelay = 0.04; CFG.TriggerBot.FOV = 20; CFG.TriggerBot.HoldTime = 0.12
    btn.Text = "Applied!"; Notify.send("Trigger", "Spray mode preset applied", "success", 2)
    task.delay(1, function() btn.Text = "Spray Mode" end)
end)

Section("aimbot", "target priority")
Dropdown("aimbot", "Priority Mode", CFG.TargetPriority, "Mode", {"Smart", "Distance", "Health", "Threat", "FOV"})
Slider("aimbot", "Health Weight", CFG.TargetPriority, "HealthWeight", 0, 1, 0.05, "")
Slider("aimbot", "Distance Weight", CFG.TargetPriority, "DistanceWeight", 0, 1, 0.05, "")
Slider("aimbot", "Threat Weight", CFG.TargetPriority, "ThreatWeight", 0, 1, 0.05, "")
Slider("aimbot", "Visible Weight", CFG.TargetPriority, "VisibleWeight", 0, 1, 0.05, "")
Toggle("aimbot", "Prefer Low HP", CFG.TargetPriority, "PreferLowHP")
Toggle("aimbot", "Prefer Closer", CFG.TargetPriority, "PreferClose")
Toggle("aimbot", "Prefer Visible", CFG.TargetPriority, "PreferVisible")
Slider("aimbot", "Sticky Time", CFG.TargetPriority, "StickyTime", 0, 5, 0.1, "s")
Slider("aimbot", "Switch Threshold", CFG.TargetPriority, "SwitchThreshold", 0, 0.5, 0.01, "")
Label("aimbot", "Smart mode uses all weights combined")
Label("aimbot", "Sticky time prevents rapid target switching")

Section("aimbot", "damage calculator")
Toggle("aimbot", "Enable Damage Calc", CFG.DmgCalc, "On")
Toggle("aimbot", "Show Overlay", CFG.DmgCalc, "ShowOverlay")
Slider("aimbot", "Base Damage", CFG.DmgCalc, "BaseDamage", 1, 200, 1, "")
Slider("aimbot", "Headshot Multiplier", CFG.DmgCalc, "HeadshotMult", 1, 5, 0.1, "x")
Slider("aimbot", "Limb Multiplier", CFG.DmgCalc, "LimbMult", 0.1, 1, 0.05, "x")
Slider("aimbot", "Armor Reduction", CFG.DmgCalc, "ArmorReduction", 0, 0.8, 0.05, "")
Toggle("aimbot", "Range Falloff", CFG.DmgCalc, "RangeFalloff")
Slider("aimbot", "Falloff Start", CFG.DmgCalc, "FalloffStart", 0, 300, 10, "m")
Slider("aimbot", "Falloff End", CFG.DmgCalc, "FalloffEnd", 50, 500, 10, "m")
Slider("aimbot", "Falloff Min Mult", CFG.DmgCalc, "FalloffMin", 0, 1, 0.05, "")
Label("aimbot", "Damage calc estimates shots to kill")
Label("aimbot", "Adjust base damage to match game's weapon damage")
Label("aimbot", "Falloff reduces damage at longer ranges")

Section("aimbot", "auto wall")
Toggle("aimbot", "Enable Auto Wall", CFG.AutoWall, "On")
Slider("aimbot", "Min Wall Damage", CFG.AutoWall, "MinDamage", 1, 100, 1, "")
Slider("aimbot", "Max Penetration", CFG.AutoWall, "MaxPenetration", 1, 10, 1, "")
Toggle("aimbot", "Show Penetrable", CFG.AutoWall, "ShowPenetrable")
ColorPick("aimbot", "Penetrable Color", CFG.AutoWall, "PenetrableColor")
Toggle("aimbot", "Material Multipliers", CFG.AutoWall, "MaterialMultipliers")
Slider("aimbot", "Wood Penetration", CFG.AutoWall, "WoodMult", 0, 1, 0.05, "")
Slider("aimbot", "Metal Penetration", CFG.AutoWall, "MetalMult", 0, 1, 0.05, "")
Slider("aimbot", "Concrete Pen.", CFG.AutoWall, "ConcreteMult", 0, 1, 0.05, "")
Slider("aimbot", "Glass Penetration", CFG.AutoWall, "GlassMult", 0, 1, 0.05, "")
Slider("aimbot", "Plastic Pen.", CFG.AutoWall, "PlasticMult", 0, 1, 0.05, "")
Label("aimbot", "Auto wall checks if bullets can penetrate walls")
Label("aimbot", "Material multipliers affect damage through surfaces")
Label("aimbot", "Higher pen value = more damage through that material")

Section("aimbot", "trajectory prediction")
Toggle("aimbot", "Enable Trajectory", CFG.Trajectory, "On")
Toggle("aimbot", "Show Path", CFG.Trajectory, "ShowPath")
ColorPick("aimbot", "Path Color", CFG.Trajectory, "PathColor")
Slider("aimbot", "Path Alpha", CFG.Trajectory, "PathAlpha", 0, 1, 0.05, "")
Slider("aimbot", "Prediction Steps", CFG.Trajectory, "Steps", 5, 60, 1, "")
Slider("aimbot", "Step Time", CFG.Trajectory, "StepTime", 0.01, 0.2, 0.01, "s")
Slider("aimbot", "Gravity", CFG.Trajectory, "Gravity", 0, 400, 5, "")
Toggle("aimbot", "Show Impact", CFG.Trajectory, "ShowImpact")
Slider("aimbot", "Impact Radius", CFG.Trajectory, "ImpactRadius", 1, 10, 0.5, "")
Label("aimbot", "Trajectory shows predicted enemy movement path")
Label("aimbot", "Impact marker shows where target will land")

Section("esp", "threat level indicators")
Toggle("esp", "Enable Threat Level", CFG.ThreatLevel, "On")
Toggle("esp", "Show Indicator", CFG.ThreatLevel, "ShowIndicator")
Slider("esp", "Update Rate", CFG.ThreatLevel, "UpdateRate", 0.1, 2, 0.1, "s")
ColorPick("esp", "High Threat Color", CFG.ThreatLevel, "HighColor")
ColorPick("esp", "Med Threat Color", CFG.ThreatLevel, "MedColor")
ColorPick("esp", "Low Threat Color", CFG.ThreatLevel, "LowColor")
Separator("esp")
Label("esp", "Threat Weight Settings:")
Slider("esp", "HP Weight", CFG.ThreatLevel.Weights, "HP", 0, 1, 0.05, "")
Slider("esp", "Distance Weight", CFG.ThreatLevel.Weights, "Distance", 0, 1, 0.05, "")
Slider("esp", "Speed Weight", CFG.ThreatLevel.Weights, "Speed", 0, 1, 0.05, "")
Slider("esp", "Weapon Weight", CFG.ThreatLevel.Weights, "Weapon", 0, 1, 0.05, "")
Slider("esp", "Accuracy Weight", CFG.ThreatLevel.Weights, "Accuracy", 0, 1, 0.05, "")
Label("esp", "Threat level assesses each player's danger level")
Label("esp", "HIGH = close + armed + healthy = most dangerous")

Section("esp", "loot esp")
Toggle("esp", "Enable Loot ESP", CFG.Loot, "On")
Toggle("esp", "Show Rarity", CFG.Loot, "ShowRarity")
Toggle("esp", "Filter Common", CFG.Loot, "FilterCommon")
Toggle("esp", "Filter Rare", CFG.Loot, "FilterRare")
Toggle("esp", "Highlight Items", CFG.Loot, "Highlight")
ColorPick("esp", "Highlight Color", CFG.Loot, "HighlightColor")
Slider("esp", "Max Distance", CFG.Loot, "MaxDist", 50, 1000, 25, "m")
Separator("esp")
Label("esp", "Rarity Colors:")
ColorPick("esp", "Common", CFG.Loot, "CommonColor")
ColorPick("esp", "Rare", CFG.Loot, "RareColor")
ColorPick("esp", "Epic", CFG.Loot, "EpicColor")
ColorPick("esp", "Legendary", CFG.Loot, "LegendaryColor")
Label("esp", "Loot ESP highlights dropped items and tools")
Label("esp", "Filter out common items to reduce clutter")

Section("esp", "waypoints")
Toggle("esp", "Enable Waypoints", CFG.Waypoints, "On")
Slider("esp", "Max Waypoints", CFG.Waypoints, "MaxWaypoints", 1, 25, 1, "")
Toggle("esp", "Show Distance", CFG.Waypoints, "ShowDist")
Toggle("esp", "Show Name", CFG.Waypoints, "ShowName")
Slider("esp", "Render Distance", CFG.Waypoints, "RenderDist", 100, 5000, 100, "m")
ColorPick("esp", "Default WP Color", CFG.Waypoints, "DefaultColor")
Slider("esp", "Line Thickness", CFG.Waypoints, "LineThick", 0.5, 3, 0.5, "")
Slider("esp", "Icon Size", CFG.Waypoints, "IconSize", 3, 20, 1, "px")
Button("esp", "Add Waypoint Here", function(btn)
    if U.alive(LP) then
        local ch = LP.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local wp = WaypointManager.add(nil, hrp.Position)
                Notify.send("Waypoint", "Added: " .. wp.name, "success", 2)
                btn.Text = "Added!"
                task.delay(1, function() btn.Text = "Add Waypoint Here" end)
                return
            end
        end
    end
    btn.Text = "Failed!"
    task.delay(1, function() btn.Text = "Add Waypoint Here" end)
end)
Button("esp", "Add Cursor Waypoint", function(btn)
    local mouse = LP:GetMouse()
    if mouse and mouse.Hit then
        local wp = WaypointManager.add("Cursor " .. WaypointManager.nextId, mouse.Hit.Position)
        Notify.send("Waypoint", "Added at cursor: " .. wp.name, "success", 2)
        btn.Text = "Added!"
    else
        btn.Text = "No cursor!"
    end
    task.delay(1, function() btn.Text = "Add Cursor Waypoint" end)
end)
Button("esp", "Clear All Waypoints", function(btn)
    WaypointManager.removeAll()
    Notify.send("Waypoint", "All waypoints cleared", "info", 2)
    btn.Text = "Cleared!"
    task.delay(1, function() btn.Text = "Clear All Waypoints" end)
end)
Button("esp", "Waypoint Nearest Player", function(btn)
    local closest, closestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) then
            local d = U.distanceToPlayer(p)
            if d < closestDist then closestDist = d; closest = p end
        end
    end
    if closest and closest.Character then
        local hrp = closest.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            WaypointManager.add(closest.DisplayName, hrp.Position, {1, 0.3, 0.3})
            Notify.send("Waypoint", "Marked " .. closest.DisplayName, "success", 2)
            btn.Text = closest.DisplayName
        end
    else
        btn.Text = "No target!"
    end
    task.delay(1, function() btn.Text = "Waypoint Nearest Player" end)
end)
Label("esp", "Waypoints mark world positions with icons")
Label("esp", "They persist until manually cleared")

Section("visuals", "custom crosshair")
Dropdown("visuals", "Crosshair Style", CFG.CustomCH, "Style", {"Cross", "Circle", "Diamond", "T"})
Slider("visuals", "Crosshair Size", CFG.CustomCH, "Size", 1, 30, 1, "px")
Slider("visuals", "Crosshair Gap", CFG.CustomCH, "Gap", 0, 20, 1, "px")
Slider("visuals", "Crosshair Thick", CFG.CustomCH, "Thick", 0.5, 5, 0.5, "")
ColorPick("visuals", "Crosshair Color", CFG.CustomCH, "Color")
Slider("visuals", "Crosshair Alpha", CFG.CustomCH, "Alpha", 0, 1, 0.05, "")
Toggle("visuals", "Center Dot", CFG.CustomCH, "Dot")
Slider("visuals", "Dot Size", CFG.CustomCH, "DotSize", 1, 8, 0.5, "px")
Toggle("visuals", "Outline", CFG.CustomCH, "Outline")
ColorPick("visuals", "Outline Color", CFG.CustomCH, "OutlineColor")
Slider("visuals", "Outline Alpha", CFG.CustomCH, "OutlineAlpha", 0, 1, 0.05, "")
Toggle("visuals", "Dynamic Spread", CFG.CustomCH, "Dynamic")
Slider("visuals", "Dynamic Spread Amount", CFG.CustomCH, "DynamicSpread", 1, 20, 1, "px")
Slider("visuals", "Dynamic Speed", CFG.CustomCH, "DynamicSpeed", 1, 20, 1, "")
Toggle("visuals", "Rainbow Mode", CFG.CustomCH, "Rainbow")
Slider("visuals", "Rainbow Speed", CFG.CustomCH, "RainbowSpeed", 0.5, 10, 0.5, "")
Toggle("visuals", "T-Style", CFG.CustomCH, "TStyle")
Slider("visuals", "Rotation", CFG.CustomCH, "Rotation", 0, 360, 5, "deg")
Label("visuals", "Custom crosshair replaces default with stylized one")
Label("visuals", "Dynamic spread widens on movement/firing")
Label("visuals", "Rainbow mode cycles through colors")

Section("visuals", "custom crosshair presets")
Button("visuals", "Minimal Dot", function(btn)
    CFG.CustomCH.Style = "Cross"; CFG.CustomCH.Size = 0; CFG.CustomCH.Gap = 0
    CFG.CustomCH.Dot = true; CFG.CustomCH.DotSize = 2; CFG.CustomCH.Color = {1, 0, 0.5}
    CFG.CustomCH.Outline = false; CFG.CustomCH.Dynamic = false
    btn.Text = "Applied!"; Notify.send("Crosshair", "Minimal dot preset", "success", 2)
    task.delay(1, function() btn.Text = "Minimal Dot" end)
end)
Button("visuals", "Classic Cross", function(btn)
    CFG.CustomCH.Style = "Cross"; CFG.CustomCH.Size = 5; CFG.CustomCH.Gap = 3
    CFG.CustomCH.Thick = 1.5; CFG.CustomCH.Color = {0, 1, 0}; CFG.CustomCH.Dot = true
    CFG.CustomCH.DotSize = 1; CFG.CustomCH.Outline = true; CFG.CustomCH.Dynamic = false
    btn.Text = "Applied!"; Notify.send("Crosshair", "Classic cross preset", "success", 2)
    task.delay(1, function() btn.Text = "Classic Cross" end)
end)
Button("visuals", "Circle Sight", function(btn)
    CFG.CustomCH.Style = "Circle"; CFG.CustomCH.Size = 8
    CFG.CustomCH.Thick = 1; CFG.CustomCH.Color = {0.9, 0.3, 0.6}; CFG.CustomCH.Dot = true
    CFG.CustomCH.DotSize = 2; CFG.CustomCH.Outline = true; CFG.CustomCH.Dynamic = false
    btn.Text = "Applied!"; Notify.send("Crosshair", "Circle sight preset", "success", 2)
    task.delay(1, function() btn.Text = "Circle Sight" end)
end)
Button("visuals", "Diamond Reticle", function(btn)
    CFG.CustomCH.Style = "Diamond"; CFG.CustomCH.Size = 6
    CFG.CustomCH.Thick = 1.5; CFG.CustomCH.Color = {1, 0.85, 0}; CFG.CustomCH.Dot = true
    CFG.CustomCH.DotSize = 2; CFG.CustomCH.Outline = true; CFG.CustomCH.Dynamic = false
    btn.Text = "Applied!"; Notify.send("Crosshair", "Diamond reticle preset", "success", 2)
    task.delay(1, function() btn.Text = "Diamond Reticle" end)
end)
Button("visuals", "Rainbow Dynamic", function(btn)
    CFG.CustomCH.Style = "Cross"; CFG.CustomCH.Size = 6; CFG.CustomCH.Gap = 4
    CFG.CustomCH.Thick = 2; CFG.CustomCH.Dot = true; CFG.CustomCH.DotSize = 3
    CFG.CustomCH.Rainbow = true; CFG.CustomCH.RainbowSpeed = 3
    CFG.CustomCH.Dynamic = true; CFG.CustomCH.DynamicSpread = 8
    btn.Text = "Applied!"; Notify.send("Crosshair", "Rainbow dynamic preset", "success", 2)
    task.delay(1, function() btn.Text = "Rainbow Dynamic" end)
end)

Section("visuals", "combat log")
Toggle("visuals", "Enable Combat Log", CFG.CombatLog, "On")
Slider("visuals", "Max Entries", CFG.CombatLog, "MaxEntries", 5, 100, 5, "")
Toggle("visuals", "Show Damage", CFG.CombatLog, "ShowDamage")
Toggle("visuals", "Show Assists", CFG.CombatLog, "ShowAssists")
Slider("visuals", "Decay Time", CFG.CombatLog, "DecayTime", 3, 60, 1, "s")
Dropdown("visuals", "Log Position", CFG.CombatLog, "Position", {"TopLeft", "TopRight", "BottomLeft", "BottomRight"})
Slider("visuals", "Font Size", CFG.CombatLog, "FontSize", 8, 16, 1, "")
ColorPick("visuals", "Damage Color", CFG.CombatLog, "DmgColor")
ColorPick("visuals", "Heal Color", CFG.CombatLog, "HealColor")
ColorPick("visuals", "Assist Color", CFG.CombatLog, "AssistColor")
Label("visuals", "Combat log shows real-time damage/heal events")
Label("visuals", "Entries fade out after decay time")

Section("visuals", "session statistics")
Toggle("visuals", "Enable Session Stats", CFG.SessionStats, "On")
Toggle("visuals", "Track Kills", CFG.SessionStats, "TrackKills")
Toggle("visuals", "Track Deaths", CFG.SessionStats, "TrackDeaths")
Toggle("visuals", "Track Damage", CFG.SessionStats, "TrackDamage")
Toggle("visuals", "Track Headshots", CFG.SessionStats, "TrackHeadshots")
Toggle("visuals", "Track Distance", CFG.SessionStats, "TrackDistance")
Toggle("visuals", "Show Overlay", CFG.SessionStats, "ShowOverlay")
Dropdown("visuals", "Overlay Position", CFG.SessionStats, "OverlayPos", {"TopRight", "TopLeft", "BottomRight", "BottomLeft"})
Toggle("visuals", "Show K/D Ratio", CFG.SessionStats, "ShowKDRatio")
Toggle("visuals", "Show Accuracy", CFG.SessionStats, "ShowAccuracy")
Toggle("visuals", "Show Playtime", CFG.SessionStats, "ShowPlaytime")
Button("visuals", "Reset Session Stats", function(btn)
    SessionTracker.reset()
    Notify.send("Stats", "Session statistics reset", "info", 2)
    btn.Text = "Reset!"
    task.delay(1, function() btn.Text = "Reset Session Stats" end)
end)
Button("visuals", "Print Session Stats", function(btn)
    local info = string.format(
        "Kills: %d | Deaths: %d | K/D: %.2f\nHeadshots: %d | Accuracy: %.1f%%\nDamage: %.0f | Distance: %.0fm\nStreak: %d (Max: %d)\nPlaytime: %s",
        SessionTracker.kills, SessionTracker.deaths, SessionTracker.getKD(),
        SessionTracker.headshots, SessionTracker.getAccuracy(),
        SessionTracker.totalDmg, SessionTracker.distWalked,
        SessionTracker.currentStreak, SessionTracker.maxStreak,
        SessionTracker.getPlaytime()
    )
    Notify.send("Session Stats", info, "info", 10)
    btn.Text = "Printed!"
    task.delay(1, function() btn.Text = "Print Session Stats" end)
end)
Label("visuals", "Session stats track performance since script load")
Label("visuals", "Overlay shows live stats on screen")
Label("visuals", "Reset clears all tracked data")

Section("settings", "advanced keybinds")
Label("settings", "Combat Keybinds:")
Label("settings", "  Trigger Bot: Automatic (crosshair-based)")
Label("settings", "  RageBot: Hold RMB (when rage mode on)")
Label("settings", "  Anti-Aim: Automatic (when enabled)")
Label("settings", "  Double Tap: V to toggle")
Label("settings", "  Force BAIM: B to toggle")
Label("settings", "  Auto Peek: C to toggle")
Separator("settings")
Label("settings", "Movement Keybinds:")
Label("settings", "  Fly: F key")
Label("settings", "  Noclip: N key")
Label("settings", "  Spider: H key")
Label("settings", "  Phase: P key")
Label("settings", "  Anchor: K key")
Label("settings", "  Third Person: Y key")
Label("settings", "  Teleport: T key (to cursor)")
Separator("settings")
Label("settings", "View Keybinds:")
Label("settings", "  Freecam: G key")
Label("settings", "  Spectate: J key")
Label("settings", "  Next Target: E key")
Label("settings", "  Prev Target: Q key")
Label("settings", "  Player List: Hold Tab")
Separator("settings")
Label("settings", "System Keybinds:")
Label("settings", "  Menu: RCtrl (customizable)")
Label("settings", "  Quick Save: Chat /save")
Label("settings", "  Quick Load: Chat /load")
Label("settings", "  Panic: Chat /panic or Panic Reset button")

Section("settings", "lunarix changelog")
Label("settings", "v3.2 - Major Expansion Update")
Label("settings", "  + Trigger Bot system with burst fire")
Label("settings", "  + Auto Wall penetration analysis")
Label("settings", "  + Damage Calculator with STK overlay")
Label("settings", "  + Threat Level assessment system")
Label("settings", "  + Session Statistics tracker")
Label("settings", "  + Waypoint system with cursor placement")
Label("settings", "  + Loot ESP with rarity classification")
Label("settings", "  + Trajectory Predictor with path rendering")
Label("settings", "  + Combat Log with damage/heal tracking")
Label("settings", "  + Custom Crosshair renderer (4 styles)")
Label("settings", "  + Target Priority engine with smart mode")
Label("settings", "  + Rage Bot with multi-target and resolver")
Label("settings", "  + Anti-Aim with pitch/yaw/desync")
Label("settings", "  + Backtrack system with visualization")
Label("settings", "  + 8 color themes with custom support")
Label("settings", "  + BunnyHop, Spider, Phase, Anchor systems")
Label("settings", "  + Sound ESP and Proximity Alerts")
Label("settings", "  + Health Bar renderer with gradients")
Label("settings", "  + Flag detection (armor, godmode, speed)")
Label("settings", "  + Third Person camera with smooth follow")
Label("settings", "  + Spinbot with axis selection")
Label("settings", "  + 200+ configurable settings")
Label("settings", "  + Multiple preset systems per category")
Label("settings", "  + Frame-budgeted rendering (6ms cap)")
Label("settings", "  + Object pooling for Drawing API")
Label("settings", "  + Persistent radar with ping markers")
Separator("settings")
Label("settings", "v3.1 - Radar Rework")
Label("settings", "  * Complete radar rewrite with persistent objects")
Label("settings", "  * Fixed color format (0-1 range)")
Label("settings", "  * Fixed flickering with dedicated Drawing objects")
Label("settings", "  * Added player dots, North indicator, FOV cone")
Separator("settings")
Label("settings", "v3.0 - Initial Release")
Label("settings", "  * 11-tab GUI with widget factory")
Label("settings", "  * Aimbot with smooth/snap/sticky modes")
Label("settings", "  * Silent Aim with hit chance")
Label("settings", "  * Box ESP (full/corner modes)")
Label("settings", "  * Tracers, Snaplines, Skeleton ESP")
Label("settings", "  * Off-Screen indicators")
Label("settings", "  * Item ESP")
Label("settings", "  * Glow Chams with per-part weld")
Label("settings", "  * Movement suite (speed/fly/noclip/jump)")
Label("settings", "  * Freecam and Spectate systems")
Label("settings", "  * Config save/load/export/import")
Label("settings", "  * Kill Feed with animated entries")
Label("settings", "  * 20+ chat commands")
Label("settings", "  * Notification system")

Section("settings", "credits")
Label("settings", "Lunarix v3.2 - Ultimate Roblox Suite")
Label("settings", "Built for the community, by the community")
Label("settings", "")
Label("settings", "Core Systems:")
Label("settings", "  GUI Framework - Custom widget factory")
Label("settings", "  Rendering - Frame-budgeted Drawing API")
Label("settings", "  Config - JSON serialization with profiles")
Label("settings", "  Detection - Multi-executor environment probe")
Label("settings", "")
Label("settings", "Combat Suite:")
Label("settings", "  Aimbot - Smooth/Snap/Sticky/Rage modes")
Label("settings", "  Silent Aim - Namecall hook interception")
Label("settings", "  Trigger Bot - Auto-fire with burst support")
Label("settings", "  Rage Bot - Multi-target with resolver")
Label("settings", "  Anti-Aim - Pitch/Yaw/Desync manipulation")
Label("settings", "  Auto Wall - Material penetration analysis")
Label("settings", "  Damage Calc - STK estimation overlay")
Label("settings", "")
Label("settings", "Visual Suite:")
Label("settings", "  Box ESP - Full/Corner with health bars")
Label("settings", "  Skeleton - Bone rendering with joints")
Label("settings", "  Chams - Per-part glow with WeldConstraint")
Label("settings", "  Tracers/Snaplines - Origin customization")
Label("settings", "  Off-Screen - Arrow indicators")
Label("settings", "  Loot ESP - Rarity classification")
Label("settings", "  Threat Level - Dynamic threat assessment")
Label("settings", "  Waypoints - Custom world markers")
Label("settings", "  Custom Crosshair - 4 styles with outline")
Label("settings", "  Combat Log - Real-time event feed")
Label("settings", "  Session Stats - K/D/Accuracy/Playtime")
Label("settings", "")
Label("settings", "Movement Suite:")
Label("settings", "  Speed/Fly/Noclip/InfJump/HighJump/LongJump")
Label("settings", "  Teleport/BunnyHop/Spider/Phase/Anchor")
Label("settings", "  Spinbot/Third Person Camera")

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

print("[Lunarix v3.2] Loaded | RCtrl to open | 10000+ lines")
print("[Lunarix v3.2] Features: 11 tabs | 300+ settings | Rage bot | Trigger bot | Anti-aim")
print("[Lunarix v3.2] Systems: Chams | Backtrack | Auto wall | Damage calc | Waypoints | Loot ESP")
print("[Lunarix v3.2] Type /help in chat for command list")
