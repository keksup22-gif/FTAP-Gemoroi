--[[\
    Project: FTAP-Gemoroi\
    Core Script (ftap_core.luau) powered by Fluent UI\
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawidsulfide/fluent/releases/latest/download/main.lua"))()
end)

if not success or not Fluent then
    warn("[FTAP-Gemoroi] Failed to load Fluent UI library.")
    return
end

local Window = Fluent:CreateWindow({
    Title = "FTAP - Gemoroi v2.0 (Ultimate)",
    SubTitle = "by keksup22",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Mass = Window:AddTab({ Title = "Mass / Troll", Icon = "zap" }),
    Protection = Window:AddTab({ Title = "Protection", Icon = "shield" }),
    Auras = Window:AddTab({ Title = "Auras", Icon = "target" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Config = {
    SilentAimEnabled = false,
    FOVRadius = 120,
    MaxDistance = 200,
    Hitbox = "Head",
    ShowFOV = false,
    WallCheck = true,
    
    WalkspeedEnabled = false,
    WalkspeedValue = 16,
    InfiniteJumpEnabled = false,
    JumpPower = 50,
    NoclipEnabled = false,
    
    ESPEnabled = false,
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    ESPMaxDistance = 1000,
    
    StrengthEnabled = false,
    StrengthValue = 1,
    KillGrabEnabled = false,
    AntiGrabEnabled = false,
    AntiFlingEnabled = false,
    AntiRagdollAuto = false,
    
    LaunchAuraEnabled = false,
    TelekinesisAuraEnabled = false,
    DeathAuraEnabled = false,
    AuraRadius = 25,
    
    KillTarget = nil,
    LoopKillEnabled = false,
    LoopKillDelay = 0.5,
    LoopKillTarget = nil
}

-- Safe FOV Circle
local fovCircle
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = Config.FOVRadius
    fovCircle.Filled = false
    fovCircle.Transparency = 1
    fovCircle.Color = Color3.fromRGB(0, 170, 255)
    fovCircle.Visible = false
end)

local function getCharacter(player)
    return player and player.Character
end

local function getHumanoid(player)
    local character = getCharacter(player)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
    local character = getCharacter(player)
    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
end

local function getHitPart(player)
    local character = getCharacter(player)
    if not character then return nil end
    return character:FindFirstChild(Config.Hitbox) or character:FindFirstChild("Head") or getRoot(player)
end

local function isVisible(part)
    if not Config.WallCheck or not part then return true end
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    local result = Workspace:Raycast(origin, part.Position - origin, params)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

-- Safe recursive part checker (avoiding infinite loops / incorrect IsBasePart checks)
local function getSafeParts(model)
    local parts = {}
    if not model then return parts end
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant and descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end
    return parts
end

local playerNames = {"None"}
local function refreshPlayers()
    playerNames = {"None"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
end
refreshPlayers()

-- === COMBAT TAB ===
Tabs.Combat:AddSection("Silent Aim")

Tabs.Combat:AddToggle("SilentAimToggle", {
    Title = "Enable Silent Aim",
    Default = false,
    Callback = function(Value)
        Config.SilentAimEnabled = Value
        if fovCircle then
            fovCircle.Visible = Value and Config.ShowFOV
        end
    end
})

Tabs.Combat:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Default = true,
    Callback = function(Value)
        Config.WallCheck = Value
    end
})

Tabs.Combat:AddToggle("ShowFOVToggle", {
    Title = "Show FOV Circle",
    Default = false,
    Callback = function(Value)
        Config.ShowFOV = Value
        if fovCircle then
            fovCircle.Visible = Value and Config.SilentAimEnabled
        end
    end
})

Tabs.Combat:AddSlider("FOVSizeSlider", {
    Title = "FOV Size",
    Default = 120,
    Min = 20,
    Max = 400,
    Rounding = 0,
    Callback = function(Value)
        Config.FOVRadius = Value
        if fovCircle then
            fovCircle.Radius = Value
        end
    end
})

Tabs.Combat:AddSlider("MaxDistanceSlider", {
    Title = "Max Lock Distance",
    Default = 200,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Config.MaxDistance = Value
    end
})

Tabs.Combat:AddDropdown("HitboxDropdown", {
    Title = "Target Hitbox",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(Option)
        Config.Hitbox = Option
    end
})

-- === PLAYER TAB ===
Tabs.Player:AddSection("Movement & Physics")

Tabs.Player:AddToggle("WalkspeedToggle", {
    Title = "Enable Speed Boost",
    Default = false,
    Callback = function(Value)
        Config.WalkspeedEnabled = Value
    end
})

Tabs.Player:AddSlider("WalkspeedSlider", {
    Title = "Speed Multiplier",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.WalkspeedValue = Value
    end
})

Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Config.InfiniteJumpEnabled = Value
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false,
    Callback = function(Value)
        Config.NoclipEnabled = Value
    end
})

-- === VISUALS TAB ===
Tabs.Visuals:AddSection("ESP Settings")

Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable ESP",
    Default = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
    end
})

Tabs.Visuals:AddToggle("BoxESPToggle", {
    Title = "Box ESP",
    Default = true,
    Callback = function(Value)
        Config.BoxESP = Value
    end
})

Tabs.Visuals:AddToggle("NameESPToggle", {
    Title = "Name ESP",
    Default = true,
    Callback = function(Value)
        Config.NameESP = Value
    end
})

Tabs.Visuals:AddToggle("HealthBarToggle", {
    Title = "Health Bar",
    Default = true,
    Callback = function(Value)
        Config.HealthBar = Value
    end
})

-- === MASS / TROLL TAB ===
Tabs.Mass:AddSection("Server Interaction & Kill")

Tabs.Mass:AddButton({
    Title = "Kill All Players",
    Description = "Sets health to 0 for all players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local humanoid = getHumanoid(player)
                if humanoid then
                    pcall(function()
                        humanoid.Health = 0
                    end)
                end
            end
        end
        Fluent:Notify({ Title = "Mass Action", Content = "Kill All executed!", Duration = 3 })
    end
})

local killDropdown
killDropdown = Tabs.Mass:AddDropdown("KillPlayerDropdown", {
    Title = "Select Target Player",
    Values = playerNames,
    Default = "None",
    Callback = function(Option)
        Config.KillTarget = Option ~= "None" and Players:FindFirstChild(Option) or nil
    end
})

Tabs.Mass:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        refreshPlayers()
        killDropdown:SetValues(playerNames)
        Fluent:Notify({ Title = "Refreshed", Content = "Player list updated", Duration = 2 })
    end
})

Tabs.Mass:AddButton({
    Title = "Kill Selected Player",
    Callback = function()
        if not Config.KillTarget then
            Fluent:Notify({ Title = "Error", Content = "No player selected!", Duration = 2 })
            return
        end
        local humanoid = getHumanoid(Config.KillTarget)
        if humanoid then
            humanoid.Health = 0
            Fluent:Notify({ Title = "Success", Content = "Killed " .. Config.KillTarget.Name, Duration = 2 })
        else
            Fluent:Notify({ Title = "Error", Content = "Target character not found", Duration = 2 })
        end
    end
})

Tabs.Mass:AddToggle("LoopKillToggle", {
    Title = "Enable Loop Kill",
    Default = false,
    Callback = function(Value)
        Config.LoopKillEnabled = Value
    end
})

-- === PROTECTION TAB ===
Tabs.Protection:AddSection("Safety & Anti-Measures")

Tabs.Protection:AddToggle("AntiGrabToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(Value)
        Config.AntiGrabEnabled = Value
    end
})

Tabs.Protection:AddToggle("AntiFlingToggle", {
    Title = "Anti Fling",
    Default = false,
    Callback = function(Value)
        Config.AntiFlingEnabled = Value
    end
})

Tabs.Protection:AddToggle("AutoAntiRagdollToggle", {
    Title = "Auto Anti Ragdoll",
    Default = false,
    Callback = function(Value)
        Config.AntiRagdollAuto = Value
    end
})

Tabs.Protection:AddButton({
    Title = "Anti Ragdoll Once",
    Callback = function()
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                humanoid.Sit = false
            end)
            Fluent:Notify({ Title = "Protection", Content = "Ragdoll cleared", Duration = 2 })
        end
    end
})

Tabs.Protection:AddButton({
    Title = "Delete Void (Save Height)",
    Callback = function()
        pcall(function()
            Workspace.FallenPartsDestroyHeight = -50000
        end)
        Fluent:Notify({ Title = "Protection", Content = "Void height extended", Duration = 2 })
    end
})

-- === AURAS TAB ===
Tabs.Auras:AddSection("Proximity Auras")

Tabs.Auras:AddToggle("LaunchAuraToggle", {
    Title = "Launch Aura",
    Default = false,
    Callback = function(Value)
        Config.LaunchAuraEnabled = Value
    end
})

Tabs.Auras:AddToggle("TelekinesisAuraToggle", {
    Title = "Telekinesis Aura",
    Default = false,
    Callback = function(Value)
        Config.TelekinesisAuraEnabled = Value
    end
})

Tabs.Auras:AddToggle("DeathAuraToggle", {
    Title = "Death Aura",
    Default = false,
    Callback = function(Value)
        Config.DeathAuraEnabled = Value
    end
})

Tabs.Auras:AddSlider("AuraRadiusSlider", {
    Title = "Aura Radius",
    Default = 25,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Config.AuraRadius = Value
    end
})

-- === TELEPORTS TAB ===
Tabs.Teleports:AddSection("Location Teleports")

local houseTeleports = {
    {"Pink House", CFrame.new(-491, -7, -166)},
    {"Green House", CFrame.new(-535, -7, 93)},
    {"Purple House", CFrame.new(250, -6, 463)},
    {"China House", CFrame.new(554, 123, -72)},
    {"Blue House", CFrame.new(510, 83, -339)},
    {"Spawn", CFrame.new(3, -7, -2)}
}

for _, house in ipairs(houseTeleports) do
    Tabs.Teleports:AddButton({
        Title = "Teleport to " .. house[1],
        Callback = function()
            local root = getRoot(LocalPlayer)
            if root then
                root.CFrame = house[2]
                Fluent:Notify({ Title = "Teleport", Content = "Teleported to " .. house[1], Duration = 2 })
            end
        end
    })
end

-- === MAIN RUNTIME LOOPS ===
RunService.RenderStepped:Connect(function()
    -- FOV Circle update
    if fovCircle then
        if Config.SilentAimEnabled and Config.ShowFOV then
            local mousePos = UserInputService:GetMouseLocation()
            fovCircle.Position = mousePos
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end
    end

    -- Walkspeed loop
    if Config.WalkspeedEnabled then
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.WalkSpeed = Config.WalkspeedValue
        end
    end

    -- Noclip loop
    if Config.NoclipEnabled then
        local char = getCharacter(LocalPlayer)
        if char then
            for _, part in ipairs(getSafeParts(char)) do
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump connection
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJumpEnabled then
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Loop Kill task
task.spawn(function()
    while true do
        if Config.LoopKillEnabled and Config.KillTarget then
            pcall(function()
                local humanoid = getHumanoid(Config.KillTarget)
                if humanoid then
                    humanoid.Health = 0
                end
            end)
        end
        task.wait(Config.LoopKillDelay or 0.5)
    end
end)

-- Auras task
task.spawn(function()
    while true do
        pcall(function()
            local myRoot = getRoot(LocalPlayer)
            if myRoot and (Config.LaunchAuraEnabled or Config.DeathAuraEnabled) then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local root = getRoot(player)
                        if root and (root.Position - myRoot.Position).Magnitude <= Config.AuraRadius then
                            local humanoid = getHumanoid(player)
                            if humanoid then
                                if Config.DeathAuraEnabled then
                                    humanoid.Health = 0
                                elseif Config.LaunchAuraEnabled then
                                    root.Velocity = Vector3.new(0, 150, 0)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)

Window:SelectTab(1)
Fluent:Notify({
    Title = "FTAP-Gemoroi",
    Content = "Ultimate Core successfully initialized!",
    Duration = 5
})
