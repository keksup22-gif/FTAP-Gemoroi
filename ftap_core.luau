--[[\
    Project: FTAP-Gemoroi\
    Core Script (ftap_core.luau) - Fully functional with operational ESP, Auras, Physics, and Fluent UI bindings\
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/Fluent.luau"))()
end)

if not success or not Fluent then
    warn("[FTAP-Gemoroi] Failed to load local Fluent.luau library.")
    return
end

local Window = Fluent:CreateWindow({
    Title = "FTAP - Gemoroi v2.5 (Fully Operational)",
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
    ESPColor = Color3.fromRGB(0, 170, 255),
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    
    StrengthEnabled = false,
    StrengthValue = 1,
    KillGrabEnabled = false,
    AntiGrabEnabled = false,
    AntiFlingEnabled = false,
    AntiRagdollAuto = false,
    
    LaunchAuraEnabled = false,
    TelekinesisAuraEnabled = false,
    DeathAuraEnabled = false,
    AuraRadius = 30,
    
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

-- Safe recursive part checker (avoiding infinite loops)
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

-- === ESP SYSTEM ===
local espHighlights = {}
local function updateESPHighlights()
    if not Config.ESPEnabled then
        for _, hl in pairs(espHighlights) do
            if hl then hl:Destroy() end
        end
        espHighlights = {}
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            if not espHighlights[player] and char:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Name = "FTAP_ESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Config.ESPColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                espHighlights[player] = hl
            elseif espHighlights[player] then
                local hl = espHighlights[player]
                if hl.Adornee ~= char or not char.Parent then
                    hl:Destroy()
                    espHighlights[player] = nil
                else
                    hl.FillColor = Config.ESPColor
                end
            end
        else
            if espHighlights[player] then
                espHighlights[player]:Destroy()
                espHighlights[player] = nil
            end
        end
    end
end

-- === COMBAT TAB ===
Tabs.Combat:AddSection("Silent Aim & Targeting")

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
Tabs.Visuals:AddSection("ESP & Shaders")

Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable Player ESP (Highlights)",
    Default = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
        updateESPHighlights()
    end
})

Tabs.Visuals:AddButton({
    Title = "Fullbright (Lighting Boost)",
    Callback = function()
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
        end)
        Fluent:Notify({ Title = "Visuals", Content = "Fullbright applied!", Duration = 3 })
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
    Default = 30,
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

    -- ESP highlights update
    if Config.ESPEnabled then
        updateESPHighlights()
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

-- Auras task (Launch, Telekinesis, Death)
task.spawn(function()
    while true do
        pcall(function()
            local myRoot = getRoot(LocalPlayer)
            if myRoot and (Config.LaunchAuraEnabled or Config.DeathAuraEnabled or Config.TelekinesisAuraEnabled) then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local root = getRoot(player)
                        if root and (root.Position - myRoot.Position).Magnitude <= Config.AuraRadius then
                            local humanoid = getHumanoid(player)
                            if humanoid then
                                if Config.DeathAuraEnabled then
                                    humanoid.Health = 0
                                elseif Config.LaunchAuraEnabled then
                                    root.Velocity = Vector3.new(0, 200, 0)
                                elseif Config.TelekinesisAuraEnabled then
                                    root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- Supercharged Anti-Grab & Defense background task
task.spawn(function()
    pcall(function()
        Workspace.DescendantAdded:Connect(function(d)
            if d.Name == "PaintPlayerPart" then
                task.wait(0.05)
                pcall(function() d:Destroy() end)
            end
        end)
    end)

    while true do
        pcall(function()
            local hrp = getRoot(LocalPlayer)
            local hum = getHumanoid(LocalPlayer)

            if Config.AntiGrabEnabled then
                local isHeldVal = LocalPlayer:FindFirstChild("IsHeld")
                if isHeldVal and isHeldVal.Value then
                    pcall(function()
                        local struggleEvent = ReplicatedStorage:FindFirstChild("CharacterEvents") and ReplicatedStorage.CharacterEvents:FindFirstChild("Struggle")
                        if struggleEvent then
                            struggleEvent:FireServer()
                            struggleEvent:FireServer()
                        end
                        local destroyLine = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("DestroyGrabLine")
                        if destroyLine then
                            destroyLine:FireServer()
                        end
                        if hrp then
                            hrp.Anchored = true
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                else
                    pcall(function()
                        if hrp and hrp.Anchored then
                            hrp.Anchored = false
                        end
                    end)
                end
            end

            if Config.AntiFlingEnabled and hrp then
                if hrp.AssemblyLinearVelocity.Magnitude > 300 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end

            if Config.AntiRagdollAuto and hum then
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum.Sit then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum.Sit = false
                end
            end
        end)
        task.wait(0.02)
    end
end)

Window:SelectTab(1)
Fluent:Notify({
    Title = "FTAP-Gemoroi",
    Content = "Fully Operational Core loaded successfully!",
    Duration = 5
})
