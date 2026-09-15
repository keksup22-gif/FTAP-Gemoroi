-- FTAP-Gemoroi Loader
-- Modularized Version

local baseUrl = "https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/modules/"

local function loadModule(name)
    local success, result = pcall(function()
        local folder = (typeof(script) == "Instance" and script:FindFirstChild("modules")) 
            or (typeof(script) == "Instance" and script.Parent and script.Parent:FindFirstChild("modules")) 
            or game:GetService("ReplicatedStorage"):FindFirstChild("modules")
        if folder and folder:FindFirstChild(name) then
            return require(folder[name])
        end
    end)
    if success and result then
        return result
    end
    local code = game:HttpGet(baseUrl .. name .. ".luau")
    return loadstring(code)()
end

local Shared = loadModule("Shared")
if getgenv then getgenv().FTAP_Shared = Shared end

local Defense = loadModule("Defense")
local Player = loadModule("Player")
local Visuals = loadModule("Visuals")
local Cosmetics = loadModule("Cosmetics")
local Teleports = loadModule("Teleports")
local Combat = loadModule("Combat")
local Target = loadModule("Target")
local Auras = loadModule("Auras")
local Server = loadModule("Server")
local Misc = loadModule("Misc")
local Protection = loadModule("Protection")
local Keybinds = loadModule("Keybinds")

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/Fluent.luau"))()
end)

if not success then
    warn("Failed to load Fluent UI")
    return
end

Shared.Fluent = Fluent

local UI = loadModule("UI")
local Window, Tabs = UI.CreateWindow()

-- ==================== COMBAT TAB ====================
Tabs.Combat:AddSection("Silent Aim & Targeting")

Tabs.Combat:AddToggle("SilentAimToggle", {
    Title = "Silent Aim",
    Default = false,
    Callback = function(Value)
        Combat.Config.SilentAimEnabled = Value
    end
})

Tabs.Combat:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Default = true,
    Callback = function(Value)
        Combat.Config.WallCheck = Value
    end
})

Tabs.Combat:AddToggle("ShowFOVToggle", {
    Title = "Show FOV",
    Default = false,
    Callback = function(Value)
        Combat.Config.ShowFOV = Value
    end
})

Tabs.Combat:AddSlider("FOVSizeSlider", {
    Title = "FOV Size",
    Default = 120,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Combat.Config.FOVRadius = Value
    end
})

Tabs.Combat:AddSlider("MaxDistanceSlider", {
    Title = "Max Distance",
    Default = 200,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        Combat.Config.MaxDistance = Value
    end
})

Tabs.Combat:AddDropdown("HitboxDropdown", {
    Title = "Target Hitbox",
    Values = { "Head", "HumanoidRootPart", "Torso" },
    Default = "Head",
    Callback = function(Value)
        Combat.Config.Hitbox = Value
    end
})

Tabs.Combat:AddSection("Fling Utilities")

Tabs.Combat:AddSlider("FlingPowerSlider", {
    Title = "Fling Power Level",
    Default = 1,
    Min = 1,
    Max = 6,
    Rounding = 0,
    Callback = function(Value)
        Combat.Config.FlingPower = Value
    end
})

Tabs.Combat:AddButton({
    Title = "Fling Closest Target (Hotkey: F)",
    Callback = function()
        Combat.FlingClosestTarget()
    end
})

-- ==================== PLAYER TAB ====================
Tabs.Player:AddSection("Movement & Physics")

Tabs.Player:AddToggle("SpeedToggle", {
    Title = "WalkSpeed Loop",
    Default = false,
    Callback = function(Value)
        if Value then Player.EnableSpeed() else Player.DisableSpeed() end
    end
})

Tabs.Player:AddSlider("SpeedSlider", {
    Title = "WalkSpeed Value",
    Default = 16,
    Min = 16,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        Player.Speed.value = Value
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip (Players & Items)",
    Default = false,
    Callback = function(Value)
        Player.ToggleNoclip(Value)
    end
})

Tabs.Player:AddButton({
    Title = "Delete Legs",
    Callback = function()
        Player.DeleteLegs()
    end
})

Tabs.Player:AddSection("Camera & View Modes")

Tabs.Player:AddToggle("ThirdPersonToggle", {
    Title = "3rd Person View Mode",
    Default = false,
    Callback = function(Value)
        Player.ToggleThirdPerson(Value, Player.ThirdPerson.distance)
    end
})

Tabs.Player:AddSlider("ThirdPersonDistanceSlider", {
    Title = "3rd Person Camera Distance",
    Default = 15,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Player.SetThirdPersonDistance(Value)
    end
})

-- ==================== VISUALS TAB ====================
Tabs.Visuals:AddSection("ESP & Highlights")

Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Player ESP",
    Default = false,
    Callback = function(Value)
        Visuals.Config.ESPEnabled = Value
        Visuals.UpdateESPHighlights()
    end
})

Tabs.Visuals:AddToggle("RainbowESPToggle", {
    Title = "Rainbow ESP Highlights",
    Default = false,
    Callback = function(Value)
        Visuals.ToggleRainbowESP(Value)
    end
})

Tabs.Visuals:AddToggle("ModelHighlightToggle", {
    Title = "Model Highlights",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelHighlights(Value)
    end
})

Tabs.Visuals:AddToggle("ModelBillboardToggle", {
    Title = "Model Billboards",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelBillboards(Value)
    end
})

Tabs.Visuals:AddToggle("PCLDESPToggle", {
    Title = "PCLD ESP",
    Default = false,
    Callback = function(Value)
        Visuals.Config.PCLD_ESPEnabled = Value
        Visuals.UpdatePCLDESP()
    end
})

-- ==================== NEON DREAM SHADER ====================
Tabs.Visuals:AddSection("Neon Dream Shader")

local NeonDreamToggle = Tabs.Visuals:AddToggle("NeonDreamToggle", {
    Title = "Enable Neon Dream Shader",
    Default = false,
    Callback = function(Value)
        Visuals.ToggleNeonDream(Value)
    end
})

local GlowIntensitySlider = Tabs.Visuals:AddSlider("NeonDreamGlowSlider", {
    Title = "Glow Intensity",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1,
    Callback = function(Value)
        Visuals.NeonDreamConfig.GlowIntensity = Value
    end
})

local PulseSpeedSlider = Tabs.Visuals:AddSlider("NeonDreamPulseSlider", {
    Title = "Pulse Speed",
    Min = 0,
    Max = 5,
    Default = 1.5,
    Rounding = 1,
    Callback = function(Value)
        Visuals.NeonDreamConfig.PulseSpeed = Value
    end
})

local ParticleDensitySlider = Tabs.Visuals:AddSlider("NeonDreamDensitySlider", {
    Title = "Particle Density",
    Min = 0,
    Max = 100,
    Default = 30,
    Rounding = 0,
    Callback = function(Value)
        Visuals.NeonDreamConfig.ParticleDensity = Value
    end
})

local VignetteSlider = Tabs.Visuals:AddSlider("NeonDreamVignetteSlider", {
    Title = "Vignette Transparency",
    Min = 0,
    Max = 1,
    Default = 0.4,
    Rounding = 2,
    Callback = function(Value)
        Visuals.NeonDreamConfig.VignetteTransparency = Value
    end
})

local PaletteDropdown = Tabs.Visuals:AddDropdown("NeonDreamPaletteDropdown", {
    Title = "Palette",
    Values = { "Neon Purple", "Cyber Blue", "Sunset Pink", "Matrix Green", "Custom" },
    Default = "Neon Purple",
    Callback = function(Value)
        Visuals.NeonDreamConfig.Palette = Value
    end
})

local CustomColorPicker = Tabs.Visuals:AddColorpicker("NeonDreamCustomColor", {
    Title = "Custom Palette Color",
    Default = Color3.fromRGB(180, 0, 255),
    Callback = function(Value)
        Visuals.NeonDreamConfig.CustomColor = Value
        Visuals.NeonDreamConfig.CustomR = math.floor(Value.R * 255)
        Visuals.NeonDreamConfig.CustomG = math.floor(Value.G * 255)
        Visuals.NeonDreamConfig.CustomB = math.floor(Value.B * 255)
    end
})

local CustomRSlider = Tabs.Visuals:AddSlider("NeonDreamCustomR", {
    Title = "Custom R",
    Min = 0,
    Max = 255,
    Default = 180,
    Rounding = 0,
    Callback = function(Value)
        Visuals.NeonDreamConfig.CustomR = Value
        Visuals.NeonDreamConfig.CustomColor = Color3.fromRGB(Value, Visuals.NeonDreamConfig.CustomG, Visuals.NeonDreamConfig.CustomB)
    end
})

local CustomGSlider = Tabs.Visuals:AddSlider("NeonDreamCustomG", {
    Title = "Custom G",
    Min = 0,
    Max = 255,
    Default = 0,
    Rounding = 0,
    Callback = function(Value)
        Visuals.NeonDreamConfig.CustomG = Value
        Visuals.NeonDreamConfig.CustomColor = Color3.fromRGB(Visuals.NeonDreamConfig.CustomR, Value, Visuals.NeonDreamConfig.CustomB)
    end
})

local CustomBSlider = Tabs.Visuals:AddSlider("NeonDreamCustomB", {
    Title = "Custom B",
    Min = 0,
    Max = 255,
    Default = 255,
    Rounding = 0,
    Callback = function(Value)
        Visuals.NeonDreamConfig.CustomB = Value
        Visuals.NeonDreamConfig.CustomColor = Color3.fromRGB(Visuals.NeonDreamConfig.CustomR, Visuals.NeonDreamConfig.CustomG, Value)
    end
})

Tabs.Visuals:AddButton({
    Title = "Reset Settings",
    Description = "Reset Neon Dream Shader settings to default",
    Callback = function()
        pcall(function()
            NeonDreamToggle:SetValue(false)
            GlowIntensitySlider:SetValue(3)
            PulseSpeedSlider:SetValue(1.5)
            ParticleDensitySlider:SetValue(30)
            VignetteSlider:SetValue(0.4)
            PaletteDropdown:SetValue("Neon Purple")
            CustomColorPicker:SetValue(Color3.fromRGB(180, 0, 255))
            CustomRSlider:SetValue(180)
            CustomGSlider:SetValue(0)
            CustomBSlider:SetValue(255)
            Visuals.ResetNeonDreamConfig()
        end)
    end
})

-- ==================== COSMETICS & SHADERS TAB ====================
Tabs.Cosmetics:AddSection("Cosmetic Accessories")

Tabs.Cosmetics:AddToggle("AngelWingsToggle", {
    Title = "Angel Wings",
    Default = false,
    Callback = function(Value)
        Cosmetics.ToggleAngelWings(Value)
    end
})

Tabs.Cosmetics:AddSection("Lighting & Atmosphere Shaders")

Tabs.Cosmetics:AddButton({
    Title = "Shader: Warm Sunshine",
    Callback = function() Cosmetics.ApplyWarmSunshine() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Sakura Dream",
    Callback = function() Cosmetics.ApplySakuraDream() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Clear Sky",
    Callback = function() Cosmetics.ApplyClearSky() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Mint Fresh",
    Callback = function() Cosmetics.ApplyMintFresh() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Peach Smooth",
    Callback = function() Cosmetics.ApplyPeachSmooth() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Ocean Breeze",
    Callback = function() Cosmetics.ApplyOceanBreeze() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Golden Hour",
    Callback = function() Cosmetics.ApplyGoldenHour() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Frost Morning",
    Callback = function() Cosmetics.ApplyFrostMorning() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Soft Sunset",
    Callback = function() Cosmetics.ApplySoftSunset() end
})
Tabs.Cosmetics:AddButton({
    Title = "Shader: Bright Environment",
    Callback = function() Cosmetics.ApplyBrightPreset() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Desert Wasteland",
    Callback = function() Cosmetics.ApplyDesertPreset() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Dreamy Atmosphere",
    Callback = function() Cosmetics.ApplyDreamyPreset() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Rainy Mood",
    Callback = function() Cosmetics.ApplyRainyPreset() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Sunset Glow",
    Callback = function() Cosmetics.ApplySunsetPreset() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Cyberpunk",
    Callback = function() Cosmetics.ApplyCyberpunk() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Night Vision",
    Callback = function() Cosmetics.ApplyNightVision() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Synthwave",
    Callback = function() Cosmetics.ApplySynthwave() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Matrix",
    Callback = function() Cosmetics.ApplyMatrix() end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Purple Vibe",
    Callback = function() Cosmetics.ApplyPurpleVibe() end
})

Tabs.Cosmetics:AddButton({
    Title = "Reset Shaders (Default)",
    Callback = function()
        Cosmetics.ClearShaders()
        Shared.Notify("Shaders", "Reset to default!", 2)
    end
})

-- ==================== TARGET TAB ====================
Tabs.Target:AddSection("Select Target Player")

Target.PlayerDropDown = Tabs.Target:AddDropdown("SelectedPlayerDropdown", {
    Title = "Target Player",
    Values = Target.PlayerNames,
    Default = "None",
    Callback = function(Value)
        Target.SetSelectedPlayer(Value)
    end
})

Tabs.Target:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        Target.RefreshPlayerList()
        Shared.Notify("Target", "Player list refreshed!", 2)
    end
})

Tabs.Target:AddSection("Target Actions")

Tabs.Target:AddButton({
    Title = "Fling Selected Target",
    Callback = function()
        local target = Target.GetTarget()
        if target then
            local root = Shared.GetRoot(target)
            if root then
                Combat.FlingForces[Combat.Config.FlingPower](root)
                Shared.Notify("Target", "Flinged " .. target.Name, 2)
            end
        else
            Shared.Notify("Target", "No target selected!", 2)
        end
    end
})

Tabs.Target:AddButton({
    Title = "Teleport to Target",
    Callback = function()
        local target = Target.GetTarget()
        if target then
            local root = Shared.GetRoot(target)
            if root then
                Teleports.TeleportTo(root.CFrame)
                Shared.Notify("Teleport", "Teleported to " .. target.Name, 2)
            end
        else
            Shared.Notify("Target", "No target selected!", 2)
        end
    end
})

Target.RefreshPlayerList()

-- ==================== MASS / TROLL TAB ====================
Tabs.Mass:AddSection("Server Interaction & Mass Actions")

Tabs.Mass:AddButton({
    Title = "Kill All Players",
    Callback = function()
        for _, player in ipairs(Shared.Players:GetPlayers()) do
            if player ~= Shared.LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
            end
        end
        Shared.Notify("Mass", "Attempted to kill all players", 2)
    end
})

-- ==================== PROTECTION & DEFENSE TAB ====================
Tabs.Defense:AddSection("Anti-Function & Protection")

Tabs.Defense:AddToggle("AntiGrabToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(Value)
        Defense.AntiGrab.enabled = Value
        if Value then Defense.StartAntiGrab() else Defense.StopAntiGrab() end
    end
})

Tabs.Defense:AddToggle("AntiKickStickToggle", {
    Title = "Anti-Kick Stick (Automatic)",
    Default = false,
    Callback = function(Value)
        Defense.AntiKickStick.enabled = Value
        if Value then Defense.StartAntiKickStick() else Defense.StopAntiKickStick() end
    end
})

Tabs.Defense:AddDropdown("KickStickItemDropdown", {
    Title = "Anti-Kick Item",
    Values = Defense.AntiKickStick.items,
    Default = Defense.AntiKickStick.selectedItem,
    Callback = function(Value)
        Defense.AntiKickStick.selectedItem = Value
    end
})

Tabs.Defense:AddToggle("AntiInputLagToggle", {
    Title = "Anti Input Lag (Auto Clear Lag Items)",
    Default = false,
    Callback = function(Value)
        Defense.AntiInputLag.enabled = Value
        if Value then Defense.StartAntiInputLag() else Defense.StopAntiInputLag() end
    end
})

Tabs.Defense:AddToggle("AntiVoidToggle", {
    Title = "Anti Void",
    Default = false,
    Callback = function(Value)
        Defense.AntiVoid.enabled = Value
        if Value then Defense.StartAntiVoid() else Defense.StopAntiVoid() end
    end
})

Tabs.Defense:AddToggle("AntiExplodeToggle", {
    Title = "Anti Explode",
    Default = false,
    Callback = function(Value)
        Defense.AntiExplode.enabled = Value
        if Value then Defense.StartAntiExplode() else Defense.StopAntiExplode() end
    end
})

Tabs.Defense:AddToggle("AntiPaintToggle", {
    Title = "Anti Paint",
    Default = false,
    Callback = function(Value)
        Defense.AntiPaint.enabled = Value
        if Value then Defense.StartAntiPaint() else Defense.StopAntiPaint() end
    end
})

Tabs.Defense:AddToggle("AntiStickyToggle", {
    Title = "Anti Sticky",
    Default = false,
    Callback = function(Value)
        Defense.AntiSticky.enabled = Value
        if Value then Defense.StartAntiSticky() else Defense.StopAntiSticky() end
    end
})

-- ==================== AURAS TAB ====================
Tabs.Auras:AddSection("Proximity Auras")

Tabs.Auras:AddSlider("AuraRadiusSlider", {
    Title = "Aura Radius",
    Default = 30,
    Min = 10,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Auras.TelekinesisAura.radius = Value
        Auras.DeathAura.radius = Value
        Auras.LaunchAura.radius = Value
        Auras.RemoveAntiKickAura.radius = Value
    end
})

Tabs.Auras:AddToggle("RemoveAntiKickAuraToggle", {
    Title = "Remove Anti-Kick Aura (Strip Anti-Kick from target)",
    Default = false,
    Callback = function(Value)
        Auras.ToggleRemoveAntiKickAura(Value, Auras.RemoveAntiKickAura.radius)
    end
})

-- ==================== SERVER TAB ====================
Tabs.Server:AddSection("Server Manipulation")

Tabs.Server:AddToggle("PacketLagToggle", {
    Title = "Packet / Server Lag",
    Default = false,
    Callback = function(Value)
        if Value then Server.StartPacketLag() else Server.StopPacketLag() end
    end
})

Tabs.Server:AddToggle("LineLagToggle", {
    Title = "Line Lag",
    Default = false,
    Callback = function(Value)
        if Value then Server.StartLineLag() else Server.StopLineLag() end
    end
})

Tabs.Server:AddButton({
    Title = "Destroy Server",
    Callback = function()
        Server.DestroyServerAction()
        Shared.Notify("Server", "Destroy Server Triggered!", 3)
    end
})
Tabs.Server:AddSection("Server Hop & Utilities")

Tabs.Server:AddButton({
    Title = "Rejoin Current Server",
    Callback = function()
        Server.Rejoin()
    end
})

Tabs.Server:AddButton({
    Title = "Server Hop (Different Server)",
    Callback = function()
        Server.ServerHop()
    end
})

-- ==================== TELEPORTS TAB ====================
Tabs.Teleports:AddSection("Location Teleports")

for _, house in ipairs(Teleports.Houses) do
    Tabs.Teleports:AddButton({
        Title = "Teleport to " .. house[1],
        Callback = function()
            Teleports.TeleportTo(house[2])
            Shared.Notify("Teleport", "Teleported to " .. house[1], 2)
        end
    })
end

-- ==================== MISC TAB ====================
Tabs.Misc:AddSection("Map & Utilities")

Tabs.Misc:AddToggle("BreakBarriersToggle", {
    Title = "Break House Barriers",
    Default = false,
    Callback = function(Value)
        Misc.ToggleBreakBarriers(Value)
    end
})

Tabs.Misc:AddSection("Figure Poses (Target Grab)")

local poseNames = {"Pose1", "Pose2", "Pose3", "Pose4", "Pose5", "Pose6", "Pose7", "JojoStand"}
for _, pose in ipairs(poseNames) do
    Tabs.Misc:AddButton({
        Title = "Apply Figure " .. pose,
        Callback = function()
            local target = Target.GetTarget()
            if target and target.Character then
                Misc.ApplyFigurePose(pose, target.Character)
            else
                Shared.Notify("Figure Pose", "Select target first in Target tab!", 2)
            end
        end
    })
end

-- Hotkey Connection (F Key Fling)
Shared.UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F then
        Combat.FlingClosestTarget()
    end
end)

Shared.Notify("FTAP Gemoroi", "XOCU Enhanced Edition Loaded Successfully!", 4)

