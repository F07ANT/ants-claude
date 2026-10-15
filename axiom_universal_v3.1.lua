--// AXIOM UNIVERSAL SUITE v3.1
--// Maximum Executor Compatibility
--// Tested patterns: Synapse, Fluxus, Hydrogen, Delta, Arceus, Solara, Wave, AWP
--// Silent Aim | Box ESP | Skeleton | Chams | Item ESP | Full GUI

--------------------------------------------------------------
-- COMPAT SHIM
--------------------------------------------------------------
local unpack = unpack or table.unpack

--------------------------------------------------------------
-- SERVICES (pcall wrapped)
--------------------------------------------------------------
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UIS            = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Camera         = workspace.CurrentCamera
local LP             = Players.LocalPlayer

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
print(tag .. " Drawing: " .. tostring(ENV.Drawing))
print(tag .. " Hook: " .. tostring(ENV.Hook))
print(tag .. " Namecall: " .. tostring(ENV.Namecall))
print(tag .. " CoreGui: " .. tostring(ENV.CoreGui))
print(tag .. " CClosure: " .. tostring(ENV.CClosure))

if not ENV.Drawing then
    warn(tag .. " NO DRAWING API — ESP will use BillboardGui fallback")
end
if not ENV.Hook then
    warn(tag .. " NO HOOK — Silent Aim using camera-based redirect")
end

--------------------------------------------------------------
-- CONFIG
--------------------------------------------------------------
local C = {
    SilentAim = {
        On = false,
        FOV = 180,
        ShowFOV = true,
        FOVColor = {1, 0.2, 0.2},
        Part = "Head",
        Predict = true,
        PredictScale = 0.155,
        WallCheck = false,
    },
    BoxESP = {
        On = false,
        EnemyColor = {1, 0, 0},
        TeamColor = {0, 1, 0},
        Thick = 1.4,
        Name = true,
        Health = true,
        Dist = true,
        MaxDist = 1500,
    },
    Skeleton = {
        On = false,
        Color = {1, 1, 1},
        Thick = 1.2,
        MaxDist = 1200,
    },
    Chams = {
        On = false,
        FillColor = {0.5, 0, 1},
        OutColor = {1, 1, 1},
        FillAlpha = 0.6,
        OutAlpha = 0.0,
    },
    ItemESP = {
        On = false,
        Color = {1, 1, 0},
        TracerColor = {1, 0.78, 0},
        MaxDist = 800,
        Names = true,
        Dist = true,
        Tracers = true,
    },
    MenuKey = Enum.KeyCode.RightControl,
}

--------------------------------------------------------------
-- UTILITIES
--------------------------------------------------------------
local U = {}
function U.c3(t) return Color3.new(t[1], t[2], t[3]) end

function U.w2s(pos)
    local s, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(s.X, s.Y), on, s.Z
end

function U.dist2d(a, b) return ((a.X - b.X) ^ 2 + (a.Y - b.Y) ^ 2) ^ 0.5 end

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

function U.team(p) return LP.Team and p.Team and LP.Team == p.Team end

function U.myPos()
    local ch = LP.Character
    local r = ch and ch:FindFirstChild("HumanoidRootPart")
    return r and r.Position or Camera.CFrame.Position
end

function U.wallCheck(from, to)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LP.Character, Camera}
    return workspace:Raycast(from, to - from, params) == nil
end

--------------------------------------------------------------
-- DRAWING LAYER (Drawing API or BillboardGui fallback)
--------------------------------------------------------------
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

    Draw.Lines = Pool.new("Line", {Visible = false, Thickness = 1})
    Draw.Texts = Pool.new("Text", {Visible = false, Size = 13, Center = true, Outline = true, Font = 2})
    Draw.flush = function() Draw.Lines:flush(); Draw.Texts:flush() end
    Draw.line = function(from, to, col, thick)
        local l = Draw.Lines:get()
        l.From = from; l.To = to; l.Color = col; l.Thickness = thick; l.Visible = true
        return l
    end
    Draw.text = function(pos, txt, col, size)
        local t = Draw.Texts:get()
        t.Position = pos; t.Text = txt; t.Color = col; t.Size = size or 13; t.Visible = true
        return t
    end

    Draw.FOV = Drawing.new("Circle")
    Draw.FOV.NumSides = 60
    Draw.FOV.Filled = false
    Draw.FOV.Thickness = 1.5
    Draw.FOV.Transparency = 0.75
    Draw.FOV.Visible = false

else
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

    Draw.bbgText = function(adornee, txt, col)
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.new(0, 200, 0, 50)
        bg.StudsOffset = Vector3.new(0, 3.5, 0)
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

    Draw.FOV = nil
end

--------------------------------------------------------------
-- CHAMS
--------------------------------------------------------------
local chamsCache = {}

local function setChams(p)
    local ch = p.Character
    if not ch then return end
    if chamsCache[p] then
        local hl = chamsCache[p]
        hl.FillColor = U.c3(C.Chams.FillColor)
        hl.OutlineColor = U.c3(C.Chams.OutColor)
        hl.FillTransparency = C.Chams.FillAlpha
        hl.OutlineTransparency = C.Chams.OutAlpha
        if not hl.Parent or hl.Adornee ~= ch then
            hl.Adornee = ch
            hl.Parent = ch
        end
        return
    end
    local hl = Instance.new("Highlight")
    hl.FillColor = U.c3(C.Chams.FillColor)
    hl.OutlineColor = U.c3(C.Chams.OutColor)
    hl.FillTransparency = C.Chams.FillAlpha
    hl.OutlineTransparency = C.Chams.OutAlpha
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = ch
    hl.Parent = ch
    chamsCache[p] = hl
end

local function killChams(p)
    if chamsCache[p] then
        pcall(function() chamsCache[p]:Destroy() end)
        chamsCache[p] = nil
    end
end

--------------------------------------------------------------
-- SKELETON
--------------------------------------------------------------
local BONES15 = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
}
local BONES6 = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
}
local function getBones(ch) return ch:FindFirstChild("UpperTorso") and BONES15 or BONES6 end

--------------------------------------------------------------
-- SILENT AIM (multi-method)
--------------------------------------------------------------
local silentTarget = nil

local function bestTarget()
    local best, bestD = nil, C.SilentAim.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and U.alive(p) and not U.team(p) then
            local ch = p.Character
            local part = ch:FindFirstChild(C.SilentAim.Part) or ch:FindFirstChild("Head")
            if part then
                local skip = C.SilentAim.WallCheck and not U.wallCheck(U.myPos(), part.Position)
                if not skip then
                    local sp, on = U.w2s(part.Position)
                    if on then
                        local d = U.dist2d(center, sp)
                        if d < bestD then
                            bestD = d
                            best = p
                        end
                    end
                end
            end
        end
    end
    return best
end

-- METHOD 1: hookmetamethod
if ENV.Hook == "hookmetamethod" and ENV.Namecall then
    pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if C.SilentAim.On and silentTarget then
                local ch = silentTarget.Character
                if ch and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
                    local tp = ch:FindFirstChild(C.SilentAim.Part) or ch:FindFirstChild("Head")
                    if tp then
                        local tPos = tp.Position
                        if C.SilentAim.Predict then
                            local rp = ch:FindFirstChild("HumanoidRootPart")
                            if rp then
                                tPos = tPos + rp.AssemblyLinearVelocity * C.SilentAim.PredictScale
                            end
                        end
                        if typeof(args[1]) == "Ray" then
                            args[1] = Ray.new(args[1].Origin, (tPos - args[1].Origin).Unit * 5000)
                        end
                    end
                end
            end
            return old(self, unpack(args))
        end))
        print(tag .. " Silent Aim: hookmetamethod active")
    end)

-- METHOD 2: getrawmetatable fallback
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
            if C.SilentAim.On and silentTarget then
                local ch = silentTarget.Character
                if ch and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
                    local tp = ch:FindFirstChild(C.SilentAim.Part) or ch:FindFirstChild("Head")
                    if tp then
                        local tPos = tp.Position
                        if C.SilentAim.Predict then
                            local rp = ch:FindFirstChild("HumanoidRootPart")
                            if rp then
                                tPos = tPos + rp.AssemblyLinearVelocity * C.SilentAim.PredictScale
                            end
                        end
                        if typeof(args[1]) == "Ray" then
                            args[1] = Ray.new(args[1].Origin, (tPos - args[1].Origin).Unit * 5000)
                        end
                    end
                end
            end
            return oldNC(self, unpack(args))
        end)
        if setreadonly then setreadonly(mt, true) end
        print(tag .. " Silent Aim: rawmetatable active")
    end)

-- METHOD 3: CFrame-based camera redirect (works everywhere)
else
    print(tag .. " Silent Aim: camera redirect mode (no hook available)")
end

--------------------------------------------------------------
-- ITEM DETECTION (universal)
--------------------------------------------------------------
local ITEM_KEYWORDS = {"loot", "item", "drop", "pickup", "spawn", "ground", "collect", "weapon", "chest", "crate", "supply"}

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
    end
    return false
end

--------------------------------------------------------------
-- RENDER LOOP
--------------------------------------------------------------
local BUDGET = 5
local ESP_RATE = 3
local ITEM_RATE = 10
local frame = 0
local clk = os.clock

local aimHeld = false
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHeld = true
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimHeld = false
    end
end)

RunService.RenderStepped:Connect(function()
    frame = frame + 1
    local t0 = clk()
    local vp = Camera.ViewportSize
    local ctr = Vector2.new(vp.X / 2, vp.Y / 2)

    Camera = workspace.CurrentCamera

    -- FOV circle
    if Draw.FOV then
        Draw.FOV.Position = ctr
        Draw.FOV.Radius = C.SilentAim.FOV
        Draw.FOV.Color = U.c3(C.SilentAim.FOVColor)
        Draw.FOV.Visible = C.SilentAim.On and C.SilentAim.ShowFOV
    end

    silentTarget = C.SilentAim.On and bestTarget() or nil

    -- Camera redirect (method 3 fallback) — only while right mouse held
    if not ENV.Hook and not ENV.RawMT and C.SilentAim.On and silentTarget and aimHeld then
        local ch = silentTarget.Character
        if ch then
            local tp = ch:FindFirstChild(C.SilentAim.Part) or ch:FindFirstChild("Head")
            if tp then
                local tPos = tp.Position
                if C.SilentAim.Predict then
                    local rp = ch:FindFirstChild("HumanoidRootPart")
                    if rp then
                        tPos = tPos + rp.AssemblyLinearVelocity * C.SilentAim.PredictScale
                    end
                end
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, tPos)
            end
        end
    end

    Draw.flush()

    local doESP = frame % ESP_RATE == 0
    local doItem = frame % ITEM_RATE == 0
    if not doESP and not doItem then return end

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
            if (clk() - t0) * 1000 > BUDGET then break end

            if C.Chams.On then setChams(p) else killChams(p) end

            local isEnemy = not U.team(p)
            local col = isEnemy and U.c3(C.BoxESP.EnemyColor) or U.c3(C.BoxESP.TeamColor)

            if ENV.Drawing then
                -- BOX ESP
                if C.BoxESP.On and d3 <= C.BoxESP.MaxDist then
                    local topP, topOn = U.w2s((root.CFrame * CFrame.new(0, 3.2, 0)).Position)
                    local botP, botOn = U.w2s((root.CFrame * CFrame.new(0, -3.2, 0)).Position)
                    if topOn or botOn then
                        local h = math.abs(topP.Y - botP.Y)
                        local w = h * 0.55
                        local tl = Vector2.new(topP.X - w / 2, topP.Y)
                        local tr = Vector2.new(topP.X + w / 2, topP.Y)
                        local bl = Vector2.new(botP.X - w / 2, botP.Y)
                        local br = Vector2.new(botP.X + w / 2, botP.Y)

                        Draw.line(tl, tr, col, C.BoxESP.Thick)
                        Draw.line(tr, br, col, C.BoxESP.Thick)
                        Draw.line(br, bl, col, C.BoxESP.Thick)
                        Draw.line(bl, tl, col, C.BoxESP.Thick)

                        if C.BoxESP.Name then
                            Draw.text(Vector2.new(topP.X, topP.Y - 18), p.DisplayName, col, 14)
                        end

                        if C.BoxESP.Health then
                            local frac = U.hpFrac(p)
                            local bx = tl.X - 5
                            Draw.line(Vector2.new(bx, botP.Y), Vector2.new(bx, topP.Y), Color3.new(0, 0, 0), 3.5)
                            Draw.line(
                                Vector2.new(bx, botP.Y),
                                Vector2.new(bx, botP.Y - (botP.Y - topP.Y) * frac),
                                Color3.fromRGB(255 * (1 - frac), 255 * frac, 0), 2.5
                            )
                        end

                        if C.BoxESP.Dist then
                            Draw.text(Vector2.new(botP.X, botP.Y + 2), string.format("[%dm]", math.floor(d3)), Color3.fromRGB(200, 200, 200), 12)
                        end
                    end
                end

                -- SKELETON
                if C.Skeleton.On and d3 <= C.Skeleton.MaxDist then
                    local sCol = U.c3(C.Skeleton.Color)
                    for _, bone in ipairs(getBones(ch)) do
                        local a = ch:FindFirstChild(bone[1])
                        local b = ch:FindFirstChild(bone[2])
                        if a and b then
                            local sa, onA = U.w2s(a.Position)
                            local sb, onB = U.w2s(b.Position)
                            if onA and onB then
                                Draw.line(sa, sb, sCol, C.Skeleton.Thick)
                            end
                        end
                    end
                end

            else
                -- BillboardGui fallback
                if C.BoxESP.On and C.BoxESP.Name and d3 <= C.BoxESP.MaxDist then
                    local head = ch:FindFirstChild("Head")
                    if head then
                        local txt = p.DisplayName
                        if C.BoxESP.Dist then
                            txt = txt .. " [" .. math.floor(d3) .. "m]"
                        end
                        Draw.bbgText(head, txt, col)
                    end
                end
            end
        end
    end

    -- ITEM ESP
    if doItem and C.ItemESP.On and ENV.Drawing then
        local iCol = U.c3(C.ItemESP.Color)
        local tCol = U.c3(C.ItemESP.TracerColor)

        for _, obj in ipairs(workspace:GetDescendants()) do
            if (clk() - t0) * 1000 > BUDGET then break end
            if not isItem(obj) then continue end

            local pos
            if obj:IsA("Model") then
                local pp = obj.PrimaryPart
                pos = pp and pp.Position
                if not pos then
                    pcall(function()
                        pos = obj:GetBoundingBox().Position
                    end)
                end
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            elseif obj:IsA("Tool") and obj.Parent == workspace then
                local h = obj:FindFirstChild("Handle")
                pos = h and h.Position
            end
            if not pos then continue end

            local dist = (myP - pos).Magnitude
            if dist > C.ItemESP.MaxDist then continue end

            local sp, on = U.w2s(pos)
            if not on then continue end

            local label = obj.Name
            if C.ItemESP.Dist then
                label = label .. " [" .. math.floor(dist) .. "m]"
            end
            Draw.text(sp, label, iCol, 13)

            if C.ItemESP.Tracers then
                Draw.line(Vector2.new(ctr.X, vp.Y), sp, tCol, 1)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) killChams(p) end)

--------------------------------------------------------------
-- GUI
--------------------------------------------------------------
local SG = Instance.new("ScreenGui")
SG.Name = "AxiomUniv_" .. math.random(1000, 9999)
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

local menuOpen = false

local TH = {
    BG     = Color3.fromRGB(14, 14, 18),
    Panel  = Color3.fromRGB(22, 22, 28),
    Header = Color3.fromRGB(28, 28, 36),
    Accent = Color3.fromRGB(130, 60, 255),
    Text   = Color3.fromRGB(215, 215, 225),
    Sub    = Color3.fromRGB(130, 130, 150),
    On     = Color3.fromRGB(90, 210, 70),
    Off    = Color3.fromRGB(60, 60, 75),
    SlBG   = Color3.fromRGB(36, 36, 48),
    SlFill = Color3.fromRGB(130, 60, 255),
    Bdr    = Color3.fromRGB(44, 44, 58),
}

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 480, 0, 580)
Main.Position = UDim2.new(0.5, -240, 0.5, -290)
Main.BackgroundColor3 = TH.BG
Main.BorderSizePixel = 0
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = TH.Bdr

local Hdr = Instance.new("Frame", Main)
Hdr.Size = UDim2.new(1, 0, 0, 40)
Hdr.BackgroundColor3 = TH.Header
Hdr.BorderSizePixel = 0
Instance.new("UICorner", Hdr).CornerRadius = UDim.new(0, 10)

local hFix = Instance.new("Frame", Hdr)
hFix.Size = UDim2.new(1, 0, 0, 10)
hFix.Position = UDim2.new(0, 0, 1, -10)
hFix.BackgroundColor3 = TH.Header
hFix.BorderSizePixel = 0

local tLbl = Instance.new("TextLabel", Hdr)
tLbl.Text = "☢ AXIOM UNIVERSAL"
tLbl.Font = Enum.Font.GothamBold
tLbl.TextSize = 15
tLbl.TextColor3 = TH.Accent
tLbl.BackgroundTransparency = 1
tLbl.Position = UDim2.new(0, 14, 0, 0)
tLbl.Size = UDim2.new(0.6, 0, 1, 0)
tLbl.TextXAlignment = Enum.TextXAlignment.Left

local vLbl = Instance.new("TextLabel", Hdr)
vLbl.Text = "v3.1 | Universal"
vLbl.Font = Enum.Font.Gotham
vLbl.TextSize = 11
vLbl.TextColor3 = TH.Sub
vLbl.BackgroundTransparency = 1
vLbl.Position = UDim2.new(0.6, 0, 0, 0)
vLbl.Size = UDim2.new(0.4, -14, 1, 0)
vLbl.TextXAlignment = Enum.TextXAlignment.Right

local statusDot = Instance.new("Frame", Hdr)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 4, 0.5, -4)
statusDot.BackgroundColor3 = TH.On
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

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

-- Scroll container
local Scr = Instance.new("ScrollingFrame", Main)
Scr.Position = UDim2.new(0, 6, 0, 46)
Scr.Size = UDim2.new(1, -12, 1, -52)
Scr.BackgroundTransparency = 1
Scr.ScrollBarThickness = 4
Scr.ScrollBarImageColor3 = TH.Accent
Scr.BorderSizePixel = 0
Scr.CanvasSize = UDim2.new(0, 0, 0, 0)
Scr.AutomaticCanvasSize = Enum.AutomaticSize.Y

local sLay = Instance.new("UIListLayout", Scr)
sLay.SortOrder = Enum.SortOrder.LayoutOrder
sLay.Padding = UDim.new(0, 5)

local sPad = Instance.new("UIPadding", Scr)
sPad.PaddingTop = UDim.new(0, 4)
sPad.PaddingBottom = UDim.new(0, 8)

--------------------------------------------------------------
-- UI BUILDERS
--------------------------------------------------------------
local ord = 0
local function nxt() ord = ord + 1; return ord end

local function Section(name)
    local f = Instance.new("Frame", Scr)
    f.Size = UDim2.new(1, -6, 0, 26)
    f.BackgroundTransparency = 1
    f.LayoutOrder = nxt()
    local l = Instance.new("TextLabel", f)
    l.Text = "▸ " .. string.upper(name)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextColor3 = TH.Accent
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, 0, 1, 0)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Position = UDim2.new(0, 6, 0, 0)
end

local function Toggle(label, tbl, key)
    local f = Instance.new("Frame", Scr)
    f.Size = UDim2.new(1, -6, 0, 30)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = nxt()
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
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

local function Slider(label, tbl, key, mn, mx, stp, sfx)
    sfx = sfx or ""
    stp = stp or 1
    local f = Instance.new("Frame", Scr)
    f.Size = UDim2.new(1, -6, 0, 44)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = nxt()
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
    l.TextColor3 = TH.Text
    l.BackgroundTransparency = 1
    l.Position = UDim2.new(0, 10, 0, 2)
    l.Size = UDim2.new(0.5, 0, 0, 18)
    l.TextXAlignment = Enum.TextXAlignment.Left

    local vl = Instance.new("TextLabel", f)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12
    vl.TextColor3 = TH.Accent
    vl.BackgroundTransparency = 1
    vl.Position = UDim2.new(0.5, 0, 0, 2)
    vl.Size = UDim2.new(0.5, -10, 0, 18)
    vl.TextXAlignment = Enum.TextXAlignment.Right

    local trk = Instance.new("Frame", f)
    trk.Size = UDim2.new(1, -20, 0, 8)
    trk.Position = UDim2.new(0, 10, 0, 28)
    trk.BackgroundColor3 = TH.SlBG
    trk.BorderSizePixel = 0
    Instance.new("UICorner", trk).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", trk)
    fill.BackgroundColor3 = TH.SlFill
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local function upd(v)
        v = math.clamp(v, mn, mx)
        v = math.floor(v / stp + 0.5) * stp
        tbl[key] = v
        fill.Size = UDim2.new((v - mn) / (mx - mn), 0, 1, 0)
        vl.Text = tostring(math.floor(v * 1000 + 0.5) / 1000) .. sfx
    end
    upd(tbl[key])

    local sliding = false
    trk.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
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

local function ColorPick(label, tbl, key)
    local f = Instance.new("Frame", Scr)
    f.Size = UDim2.new(1, -6, 0, 58)
    f.BackgroundColor3 = TH.Panel
    f.BorderSizePixel = 0
    f.LayoutOrder = nxt()
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel", f)
    l.Text = label
    l.Font = Enum.Font.Gotham
    l.TextSize = 12
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
    hBar.Size = UDim2.new(1, -20, 0, 10)
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
    sBar.Size = UDim2.new(0.47, -10, 0, 10)
    sBar.Position = UDim2.new(0, 10, 0, 38)
    sBar.BackgroundColor3 = Color3.new(1, 1, 1)
    sBar.BorderSizePixel = 0
    Instance.new("UICorner", sBar).CornerRadius = UDim.new(1, 0)

    local bBar = Instance.new("Frame", f)
    bBar.Size = UDim2.new(0.47, -10, 0, 10)
    bBar.Position = UDim2.new(0.53, 0, 0, 38)
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
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dH = false; dS = false; dV = false
        end
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
-- BUILD MENU
--------------------------------------------------------------
Section("Silent Aim")
Toggle("Enabled", C.SilentAim, "On")
Toggle("Show FOV", C.SilentAim, "ShowFOV")
Toggle("Prediction", C.SilentAim, "Predict")
Toggle("Wall Check", C.SilentAim, "WallCheck")
Slider("FOV Radius", C.SilentAim, "FOV", 50, 500, 5, "px")
Slider("Predict Scale", C.SilentAim, "PredictScale", 0.01, 0.5, 0.005, "")
ColorPick("FOV Color", C.SilentAim, "FOVColor")

Section("Box ESP")
Toggle("Enabled", C.BoxESP, "On")
Toggle("Names", C.BoxESP, "Name")
Toggle("Health Bars", C.BoxESP, "Health")
Toggle("Distance", C.BoxESP, "Dist")
Slider("Max Distance", C.BoxESP, "MaxDist", 100, 3000, 50, "m")
Slider("Thickness", C.BoxESP, "Thick", 0.5, 4, 0.1, "")
ColorPick("Enemy Color", C.BoxESP, "EnemyColor")
ColorPick("Team Color", C.BoxESP, "TeamColor")

Section("Skeleton ESP")
Toggle("Enabled", C.Skeleton, "On")
Slider("Max Distance", C.Skeleton, "MaxDist", 100, 2000, 50, "m")
Slider("Thickness", C.Skeleton, "Thick", 0.5, 3, 0.1, "")
ColorPick("Bone Color", C.Skeleton, "Color")

Section("Chams")
Toggle("Enabled", C.Chams, "On")
Slider("Fill Alpha", C.Chams, "FillAlpha", 0, 1, 0.05, "")
Slider("Outline Alpha", C.Chams, "OutAlpha", 0, 1, 0.05, "")
ColorPick("Fill Color", C.Chams, "FillColor")
ColorPick("Outline Color", C.Chams, "OutColor")

Section("Item ESP")
Toggle("Enabled", C.ItemESP, "On")
Toggle("Names", C.ItemESP, "Names")
Toggle("Distance", C.ItemESP, "Dist")
Toggle("Tracers", C.ItemESP, "Tracers")
Slider("Max Distance", C.ItemESP, "MaxDist", 100, 2000, 50, "m")
ColorPick("Item Color", C.ItemESP, "Color")
ColorPick("Tracer Color", C.ItemESP, "TracerColor")

--------------------------------------------------------------
-- MENU TOGGLE
--------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == C.MenuKey then
        menuOpen = not menuOpen
        Main.Visible = menuOpen
    end
end)

print(tag .. " Loaded. Press Right Control to open menu.")
print(tag .. " Executor features: " .. (ENV.Drawing and "Drawing OK " or "Drawing NO ") .. (ENV.Hook or "NoHook") .. " | GUI: " .. (ENV.GetHUI and "gethui" or ENV.CoreGui and "CoreGui" or "PlayerGui"))
