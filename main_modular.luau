-- FTAP-Gemoroi Loader
-- Modularized Edition v3.5 (Lime Dark / GemoroiUI)

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

local success, GemoroiUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/GemoroiUI.luau"))()
end)

if not success or not GemoroiUI then
    -- fallback: load the synced module copy from /modules/GemoroiUI.luau
    local ok2, modUI = pcall(function()
        return loadModule("GemoroiUI")
    end)
    if ok2 and modUI then
        GemoroiUI = modUI
    end
end

if not GemoroiUI then
    warn("[FTAP-Gemoroi] Failed to load GemoroiUI (Lime Dark)")
    return
end

Shared.GemoroiUI = GemoroiUI
Shared.Fluent = GemoroiUI -- backward compatibility alias

local UI = loadModule("UI")
local Window, Tabs = UI.CreateWindow()

-- ==================== COMBAT TAB ====================
Tabs.Combat:AddSection("Silent Aim & Targeting")

Tabs.Combat:AddToggle("SilentAimToggle", {
    Title = "Enable Silent Aim",
    Default = false,
    Callback = function(Value)
        Combat.Config.SilentAimEnabled = Value
        if Combat.FovCircle then
            Combat.FovCircle.Visible = Value and Combat.Config.ShowFOV
        end
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
    Title = "Show FOV Circle",
    Default = false,
    Callback = function(Value)
        Combat.Config.ShowFOV = Value
        if Combat.FovCircle then
            Combat.FovCircle.Visible = Value and Combat.Config.SilentAimEnabled
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
        Combat.Config.FOVRadius = Value
        if Combat.FovCircle then
            Combat.FovCircle.Radius = Value
        end
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

Tabs.Combat:AddSection("TriggerBot (Auto-Grab on Aim)")

Tabs.Combat:AddToggle("TriggerBotToggle", {
    Title = "Enable TriggerBot",
    Default = false,
    Callback = function(Value)
        Combat.ToggleTriggerBot(Value)
    end
})

Tabs.Combat:AddSlider("TriggerBotDistance", {
    Title = "TriggerBot Max Distance",
    Default = 60,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        Combat.TriggerBot.maxDistance = Value
    end
})

Tabs.Combat:AddSection("Grab Modifiers & Physics")

Tabs.Combat:AddToggle("SuperStrengthToggle", {
    Title = "Super Strength Throw",
    Default = false,
    Callback = function(Value)
        Combat.GrabMods.SuperStrength = Value
    end
})

Tabs.Combat:AddSlider("ThrowPowerSlider", {
    Title = "Throw Power Multiplier",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        Combat.GrabMods.ThrowPower = Value
    end
})

Tabs.Combat:AddToggle("KillGrabToggle", {
    Title = "Kill Grab (Instant Void Throw on Grab)",
    Default = false,
    Callback = function(Value)
        Combat.GrabMods.KillGrab = Value
    end
})

Tabs.Combat:AddSection("Fling Utilities")

Tabs.Combat:AddSlider("FlingPowerSlider", {
    Title = "Fling Power",
    Default = 1,
    Min = 1,
    Max = 6,
    Rounding = 0,
    Callback = function(Value)
        Combat.Config.FlingPower = Value
    end
})

Tabs.Combat:AddButton({
    Title = "Fling Closest Target",
    Callback = function()
        Combat.FlingClosestTarget()
    end
})

Tabs.Combat:AddButton({
    Title = "Fling All Players",
    Callback = function()
        Combat.FlingAllPlayers()
    end
})

-- ==================== PLAYER TAB ====================
Tabs.Player:AddSection("Movement & Physics")

Tabs.Player:AddToggle("SpeedToggle", {
    Title = "Enable Speed Multiplier",
    Default = false,
    Callback = function(Value)
        if Value then Player.EnableSpeed() else Player.DisableSpeed() end
    end
})

Tabs.Player:AddSlider("SpeedSlider", {
    Title = "Speed Value",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Player.Speed.value = Value
        if Player.Speed.enabled then
            local hum = Shared.GetCharHumanoid()
            if hum then hum.WalkSpeed = Value end
        end
    end
})

Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Player.ToggleInfiniteJump(Value)
    end
})

Tabs.Player:AddToggle("FlyToggle", {
    Title = "Fly Mode (WASD + Space/Shift)",
    Default = false,
    Callback = function(Value)
        Player.ToggleFly(Value, Player.Fly.speed)
    end
})

Tabs.Player:AddSlider("FlySpeedSlider", {
    Title = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        Player.Fly.speed = Value
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip (Players & Objects)",
    Default = false,
    Callback = function(Value)
        Player.ToggleNoclip(Value)
    end
})

Tabs.Player:AddButton({
    Title = "Delete Legs (Hitbox Bug)",
    Callback = function()
        Player.DeleteLegs()
    end
})

Tabs.Player:AddSection("Camera & View Modes")

Tabs.Player:AddToggle("ThirdPersonToggle", {
    Title = "Third Person View Fix (RenderStepped)",
    Description = "Unlocks the forced first-person camera every frame",
    Default = false,
    Callback = function(Value)
        Player.ToggleThirdPerson(Value, Player.ThirdPerson.distance)
    end
})

Tabs.Player:AddSlider("ThirdPersonDistanceSlider", {
    Title = "3rd Person Distance",
    Default = 15,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Player.SetThirdPersonDistance(Value)
    end
})

Tabs.Player:AddToggle("SpinBotToggle", {
    Title = "Spin Bot",
    Default = false,
    Callback = function(Value)
        Player.ToggleSpin(Value, Player.Spin.speed)
    end
})

-- ==================== VISUALS TAB ====================
Tabs.Visuals:AddSection("ESP & Highlights")

Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable Player ESP (Highlights)",
    Default = false,
    Callback = function(Value)
        Visuals.Config.ESPEnabled = Value
        Visuals.UpdateESPHighlights()
    end
})

Tabs.Visuals:AddToggle("RainbowESPToggle", {
    Title = "Rainbow ESP Color",
    Default = false,
    Callback = function(Value)
        Visuals.ToggleRainbowESP(Value)
    end
})

Tabs.Visuals:AddToggle("ModelHighlightToggle", {
    Title = "Highlight Workspace Models",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelHighlights(Value)
    end
})

Tabs.Visuals:AddToggle("ModelBillboardToggle", {
    Title = "Show Model Names (BillboardGui)",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelBillboards(Value)
    end
})

Tabs.Visuals:AddToggle("PCLDESPToggle", {
    Title = "PCLD ESP (Hidden Physics Hitboxes)",
    Default = false,
    Callback = function(Value)
        Visuals.Config.PCLD_ESPEnabled = Value
        Visuals.UpdatePCLDESP()
    end
})

-- ==================== GEMOROI VISUALS & OPTIMIZATION ====================
Tabs.Visuals:AddSection("Gemoroi Visuals & Optimization")

Tabs.Visuals:AddToggle("PCLDBoxESPToggle", {
    Title = "PCLD Box ESP (BoxHandleAdornments)",
    Description = "Draws 3D boxes on hidden physics hitboxes",
    Default = false,
    Callback = function(Value)
        Visuals.Config.PCLD_BoxesEnabled = Value
        Visuals.UpdatePCLDBoxes()
    end
})

Tabs.Visuals:AddColorpicker("PCLDBoxColorPicker", {
    Title = "PCLD Box Color",
    Default = Color3.fromRGB(163, 230, 53),
    Callback = function(Value)
        Visuals.SetPCLDBoxColor(Value)
    end
})

Tabs.Visuals:AddToggle("ProfileESPToggle", {
    Title = "Profile ESP (Avatars Above Head)",
    Description = "Shows player avatars, names and health above heads",
    Default = false,
    Callback = function(Value)
        Visuals.ToggleProfileESP(Value)
    end
})

Tabs.Visuals:AddToggle("SoapTexturesToggle", {
    Title = "Soap Textures (FPS Boost)",
    Description = "Smooth-plastic everything + hides decals & textures",
    Default = false,
    Callback = function(Value)
        Visuals.ToggleSoapTextures(Value)
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

Tabs.Cosmetics:AddButton({ Title = "Warm Sunshine", Callback = function() Cosmetics.ApplyWarmSunshine() end })
Tabs.Cosmetics:AddButton({ Title = "Sakura Dream", Callback = function() Cosmetics.ApplySakuraDream() end })
Tabs.Cosmetics:AddButton({ Title = "Clear Sky", Callback = function() Cosmetics.ApplyClearSky() end })
Tabs.Cosmetics:AddButton({ Title = "Mint Fresh", Callback = function() Cosmetics.ApplyMintFresh() end })
Tabs.Cosmetics:AddButton({ Title = "Peach Smooth", Callback = function() Cosmetics.ApplyPeachSmooth() end })
Tabs.Cosmetics:AddButton({ Title = "Ocean Breeze", Callback = function() Cosmetics.ApplyOceanBreeze() end })
Tabs.Cosmetics:AddButton({ Title = "Golden Hour", Callback = function() Cosmetics.ApplyGoldenHour() end })
Tabs.Cosmetics:AddButton({ Title = "Frost Morning", Callback = function() Cosmetics.ApplyFrostMorning() end })
Tabs.Cosmetics:AddButton({ Title = "Soft Sunset", Callback = function() Cosmetics.ApplySoftSunset() end })
Tabs.Cosmetics:AddButton({ Title = "Bright Environment", Callback = function() Cosmetics.ApplyBrightPreset() end })
Tabs.Cosmetics:AddButton({ Title = "Desert Wasteland", Callback = function() Cosmetics.ApplyDesertPreset() end })
Tabs.Cosmetics:AddButton({ Title = "Dreamy Atmosphere", Callback = function() Cosmetics.ApplyDreamyPreset() end })
Tabs.Cosmetics:AddButton({ Title = "Rainy Mood", Callback = function() Cosmetics.ApplyRainyPreset() end })
Tabs.Cosmetics:AddButton({ Title = "Sunset Glow", Callback = function() Cosmetics.ApplySunsetPreset() end })
Tabs.Cosmetics:AddButton({ Title = "Cyberpunk", Callback = function() Cosmetics.ApplyCyberpunk() end })
Tabs.Cosmetics:AddButton({ Title = "Night Vision", Callback = function() Cosmetics.ApplyNightVision() end })
Tabs.Cosmetics:AddButton({ Title = "Synthwave", Callback = function() Cosmetics.ApplySynthwave() end })
Tabs.Cosmetics:AddButton({ Title = "Matrix", Callback = function() Cosmetics.ApplyMatrix() end })
Tabs.Cosmetics:AddButton({ Title = "Purple Vibe", Callback = function() Cosmetics.ApplyPurpleVibe() end })
Tabs.Cosmetics:AddButton({ Title = "Reset Shaders to Default", Callback = function() Cosmetics.ClearShaders(); Shared.Notify("Shaders", "Reset to default!", 2) end })

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

Tabs.Target:AddSection("XOCU Kick Execution Matrix")

Tabs.Target:AddDropdown("XOCUKickModeDropdown", {
    Title = "XOCU Kick Mode",
    Values = Target.XOCUKickModes,
    Default = "Kill",
    Callback = function(Value)
        Target.SelectedKickMode = Value
    end
})

Tabs.Target:AddButton({
    Title = "Execute XOCU Kick 💥",
    Callback = function()
        local target = Target.GetTarget()
        if target then
            Target.ExecuteXOCUKick(target, Target.SelectedKickMode)
        else
            Shared.Notify("Target", "Select a target first!", 2)
        end
    end
})

Tabs.Target:AddSection("Target Actions")

Tabs.Target:AddButton({
    Title = "Fling Selected Target",
    Callback = function()
        local target = Target.GetTarget()
        if target then
            Combat.FlingTarget(target, Combat.Config.FlingPower)
            Shared.Notify("Target", "Flinged " .. target.Name, 2)
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

Tabs.Target:AddToggle("LoopKillTargetToggle", {
    Title = "Loop Kill Target (Void Drop)",
    Default = false,
    Callback = function(Value)
        local target = Target.GetTarget()
        if Value then
            if target then
                Target.StartLoopKill(target, 0.5)
            else
                Shared.Notify("Target", "Select a target first!", 2)
            end
        else
            Target.StopLoopKill()
        end
    end
})

Tabs.Target:AddToggle("DualHandLoopKickToggle", {
    Title = "Dual Hand Loop Kick (Blobman Engine)",
    Default = false,
    Callback = function(Value)
        local target = Target.GetTarget()
        if Value then
            if target then
                Target.StartDualHandLoopKick(target)
            else
                Shared.Notify("Target", "Select a target first!", 2)
            end
        else
            Target.StopDualHandLoopKick()
        end
    end
})

Tabs.Target:AddButton({
    Title = "Strip Anti-Kick from Target",
    Callback = function()
        local target = Target.GetTarget()
        if target then
            Target.StripAntiKick(target)
        else
            Shared.Notify("Target", "Select a target first!", 2)
        end
    end
})

Target.RefreshPlayerList()

-- ==================== MASS / TROLL TAB ====================
Tabs.Mass:AddSection("Server Interaction & Mass Actions")

Tabs.Mass:AddButton({
    Title = "Kill All Players (Void Drop)",
    Callback = function()
        for _, player in ipairs(Shared.Players:GetPlayers()) do
            if player ~= Shared.LocalPlayer and player.Character then
                local root = Shared.GetRoot(player)
                if root then
                    Shared.SetNetworkOwner(root, root.CFrame)
                    root.AssemblyLinearVelocity = Vector3.new(0, -1e6, 0)
                    root.CFrame = CFrame.new(root.Position.X, -3000, root.Position.Z)
                end
            end
        end
        Shared.Notify("Mass", "Mass void kill triggered on all players", 2)
    end
})

Tabs.Mass:AddButton({
    Title = "Fling All Players",
    Callback = function()
        Combat.FlingAllPlayers()
    end
})

-- ==================== PROTECTION TAB ====================
Tabs.Protection:AddSection("Safety & Anti-Troll Measures")

Tabs.Protection:AddToggle("AntiGrabToggle", {
    Title = "Anti Grab (Anchor & Struggle)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiGrab(Value)
    end
})

Tabs.Protection:AddToggle("XOCUCounterAttackToggle", {
    Title = "XOCU Auto-Counter Attack on Grab",
    Default = false,
    Callback = function(Value)
        Defense.ToggleCounterAttack(Value, Defense.CounterAttack.mode)
    end
})

Tabs.Protection:AddDropdown("CounterModeDropdown", {
    Title = "Counter Attack Mode",
    Values = { "Hell", "Kill", "Fling" },
    Default = "Hell",
    Callback = function(Value)
        Defense.CounterAttack.mode = Value
    end
})

Tabs.Protection:AddToggle("AutoPCLDBreakerToggle", {
    Title = "Auto PCLD Breaker (Break Enemy Aimbots)",
    Default = false,
    Callback = function(Value)
        Defense.TogglePCLDBreaker(Value)
    end
})

Tabs.Protection:AddToggle("AntiVoidToggle", {
    Title = "Anti Void (Auto Void Rescue)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiVoid(Value)
    end
})

Tabs.Protection:AddToggle("AntiExplodeToggle", {
    Title = "Anti Explosion (Bombs / Mines)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiExplode(Value)
    end
})

Tabs.Protection:AddToggle("AntiPaintToggle", {
    Title = "Anti Paint (Delete Paint Parts)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiPaint(Value)
    end
})

Tabs.Protection:AddToggle("AntiStickyToggle", {
    Title = "Anti Sticky (Immunity to Shurikens & Glue)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiSticky(Value)
    end
})

Tabs.Protection:AddToggle("AntiLineLagToggle", {
    Title = "Anti Line Lag (Disable Beam Lag)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiLineLag(Value)
    end
})

Tabs.Protection:AddToggle("AntiBlobmanToggle", {
    Title = "Anti Blobman (Destroy Enemy Blobmans)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiBlobman(Value)
    end
})

-- ==================== DEFENSE TAB ====================
Tabs.Defense:AddSection("Weapon & Item Protections")

Tabs.Defense:AddToggle("AntiKickStickToggle", {
    Title = "Anti-Kick Stick (Hold Weapon)",
    Default = false,
    Callback = function(Value)
        if Value then Defense.StartAntiKickStick() else Defense.StopAntiKickStick() end
    end
})

Tabs.Defense:AddDropdown("KickStickItemDropdown", {
    Title = "Anti-Kick Item",
    Values = Defense.AntiKickStick.items,
    Default = "NinjaShuriken",
    Callback = function(Value)
        Defense.AntiKickStick.selectedItem = Value
    end
})

Tabs.Defense:AddToggle("AntiInputLagToggle", {
    Title = "Anti Input Lag (Delete Spam Toys)",
    Default = false,
    Callback = function(Value)
        Defense.ToggleAntiInputLag(Value)
    end
})

Tabs.Defense:AddButton({
    Title = "Purge Orphaned GrabParts (Anti-Lag) 🧹",
    Callback = function()
        Defense.PurgeGrabParts()
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
        Auras.DualKickAura.radius = Value
        Auras.RemoveAntiKickAura.radius = Value
    end
})

Tabs.Auras:AddToggle("LaunchAuraToggle", {
    Title = "Launch Aura",
    Default = false,
    Callback = function(Value)
        Auras.ToggleLaunchAura(Value, Auras.LaunchAura.radius)
    end
})

Tabs.Auras:AddToggle("TelekinesisAuraToggle", {
    Title = "Telekinesis Aura",
    Default = false,
    Callback = function(Value)
        Auras.ToggleTelekinesisAura(Value, Auras.TelekinesisAura.radius)
    end
})

Tabs.Auras:AddToggle("DeathAuraToggle", {
    Title = "Death Aura (Void Fling)",
    Default = false,
    Callback = function(Value)
        Auras.ToggleDeathAura(Value, Auras.DeathAura.radius)
    end
})

Tabs.Auras:AddToggle("DualKickAuraToggle", {
    Title = "Dual Hand Kick Aura (Blobman Engine)",
    Default = false,
    Callback = function(Value)
        Auras.ToggleDualKickAura(Value, Auras.DualKickAura.radius)
    end
})

Tabs.Auras:AddToggle("RemoveAntiKickAuraToggle", {
    Title = "Remove Anti-Kick Aura",
    Default = false,
    Callback = function(Value)
        Auras.ToggleRemoveAntiKickAura(Value, Auras.RemoveAntiKickAura.radius)
    end
})

-- ==================== SERVER TAB ====================
Tabs.Server:AddSection("Server Manipulation")

Tabs.Server:AddToggle("PacketLagToggle", {
    Title = "Packet Lag (Spam Extend Grab Line)",
    Default = false,
    Callback = function(Value)
        if Value then Server.StartPacketLag() else Server.StopPacketLag() end
    end
})

Tabs.Server:AddToggle("LineLagToggle", {
    Title = "Line Lag (Spam Create Grab Line)",
    Default = false,
    Callback = function(Value)
        if Value then Server.StartLineLag() else Server.StopLineLag() end
    end
})

Tabs.Server:AddButton({
    Title = "Destroy Server (Network Desync)",
    Callback = function()
        Server.DestroyServerAction()
    end
})

Tabs.Server:AddSection("Server Hop & Utilities")

Tabs.Server:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        Server.Rejoin()
    end
})

Tabs.Server:AddButton({
    Title = "Server Hop",
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

Tabs.Teleports:AddSection("Safe Platform TP")

Tabs.Teleports:AddButton({
    Title = "Create & Teleport to Safe Sky Base ☁️",
    Callback = function()
        Teleports.SpawnSafeSkyPlatform()
    end
})

Tabs.Teleports:AddButton({
    Title = "Remove Safe Sky Base",
    Callback = function()
        Teleports.RemoveSafeSkyPlatform()
    end
})

-- ==================== MISC TAB ====================
Tabs.Misc:AddSection("Map & Utilities")

Tabs.Misc:AddToggle("BreakBarriersToggle", {
    Title = "Break House Barriers (No Collision)",
    Default = false,
    Callback = function(Value)
        Misc.ToggleBreakBarriers(Value)
        Shared.Notify("Misc", Value and "House barriers broken!" or "Barriers restored", 2)
    end
})

Tabs.Misc:AddButton({
    Title = "Spawn Creature Blobman 👾",
    Callback = function()
        Misc.SpawnGucciBlobman()
    end
})

Tabs.Misc:AddSection("Figure Poses (Target Grab)")

for poseName, _ in pairs(Misc.FigurePresets) do
    Tabs.Misc:AddButton({
        Title = "Apply " .. poseName,
        Callback = function()
            local target = Target.GetTarget()
            if target and target.Character then
                Misc.ApplyFigurePose(poseName, target.Character)
            else
                Shared.Notify("Misc", "Select a target first!", 2)
            end
        end
    })
end

-- ==================== SLOTS FARM ====================
Tabs.Misc:AddSection("Slots Farm")

Tabs.Misc:AddToggle("AutoSpinSlotsToggle", {
    Title = "Auto Spin Slots",
    Description = "Auto-spins the slot machine when its timer hits 0:00",
    Default = false,
    Callback = function(Value)
        Misc.ToggleAutoSpinSlots(Value)
    end
})

Tabs.Misc:AddButton({
    Title = "Check Slot Time",
    Callback = function()
        Misc.CheckSlotTime()
    end
})

Tabs.Misc:AddButton({
    Title = "Teleport to Slots",
    Callback = function()
        Misc.TeleportToSlots()
    end
})

-- ==================== MAIN RUNTIME STEPPED LOOP ====================
Shared.RunService.RenderStepped:Connect(function()
    -- Combat Silent Aim & FOV
    Combat.Update()

    -- ESP highlights update
    if Visuals.Config.ESPEnabled then
        Visuals.UpdateESPHighlights()
    end

    -- PCLD ESP update
    if Visuals.Config.PCLD_ESPEnabled then
        Visuals.UpdatePCLDESP()
    end

    -- PCLD BoxHandleAdornments update
    if Visuals.Config.PCLD_BoxesEnabled then
        Visuals.UpdatePCLDBoxes()
    end
end)

-- Auto refresh player list on player join/leave
Shared.Players.PlayerAdded:Connect(function()
    task.wait(1)
    Target.RefreshPlayerList()
end)

Shared.Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    Target.RefreshPlayerList()
end)

Shared.Notify("FTAP-Gemoroi", "Successfully loaded Lime Dark Edition v3.5 (GemoroiUI)! ⚡", 3)
Shared.PlayEnableSound()
