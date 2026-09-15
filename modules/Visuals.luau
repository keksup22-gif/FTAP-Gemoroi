local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Visuals = {}

Visuals.ESPHighlights = {}
Visuals.PCLDHighlights = {}
Visuals.ModelHighlights = {}
Visuals.ModelBillboards = {}

Visuals.Config = {
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(0, 170, 255),
    RainbowESP = false,
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    PCLD_ESPEnabled = false,
    ModelHighlightEnabled = false,
    ModelBillboardEnabled = false
}

Visuals.RainbowConnection = nil

function Visuals.ToggleRainbowESP(state)
    Visuals.Config.RainbowESP = state
    if state then
        if Visuals.RainbowConnection then Visuals.RainbowConnection:Disconnect() end
        Visuals.RainbowConnection = Shared.RunService.RenderStepped:Connect(function()
            if Visuals.Config.RainbowESP and Visuals.Config.ESPEnabled then
                local hue = (tick() % 5) / 5
                local rainbowColor = Color3.fromHSV(hue, 1, 1)
                for _, hl in pairs(Visuals.ESPHighlights) do
                    if hl then
                        hl.FillColor = rainbowColor
                    end
                end
            end
        end)
        Shared.Notify("Visuals", "Rainbow ESP Enabled", 2)
    else
        if Visuals.RainbowConnection then
            Visuals.RainbowConnection:Disconnect()
            Visuals.RainbowConnection = nil
        end
        Shared.Notify("Visuals", "Rainbow ESP Disabled", 2)
    end
end

function Visuals.UpdatePCLDESP()
    if not Visuals.Config.PCLD_ESPEnabled then
        for _, hl in pairs(Visuals.PCLDHighlights) do
            if hl then hl:Destroy() end
        end
        Visuals.PCLDHighlights = {}
        return
    end

    for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector") then
            if not Visuals.PCLDHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Name = "PCLD_ESP_Highlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = Shared.CoreGui
                Visuals.PCLDHighlights[obj] = hl
            end
        end
    end
end

function Visuals.UpdateESPHighlights()
    if not Visuals.Config.ESPEnabled then
        for _, hl in pairs(Visuals.ESPHighlights) do
            if hl then hl:Destroy() end
        end
        Visuals.ESPHighlights = {}
        return
    end

    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and player.Character then
            local char = player.Character
            if not Visuals.ESPHighlights[player] and char:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Name = "FTAP_ESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Visuals.Config.ESPColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = Shared.CoreGui
                Visuals.ESPHighlights[player] = hl
            elseif Visuals.ESPHighlights[player] then
                local hl = Visuals.ESPHighlights[player]
                if hl.Adornee ~= char or not char.Parent then
                    hl:Destroy()
                    Visuals.ESPHighlights[player] = nil
                else
                    hl.FillColor = Visuals.Config.ESPColor
                end
            end
        else
            if Visuals.ESPHighlights[player] then
                Visuals.ESPHighlights[player]:Destroy()
                Visuals.ESPHighlights[player] = nil
            end
        end
    end
end

function Visuals.UpdateModelHighlights(state)
    Visuals.Config.ModelHighlightEnabled = state
    pcall(function()
        if not state then
            for model, hl in pairs(Visuals.ModelHighlights) do
                if hl then
                    pcall(function() hl:Destroy() end)
                end
            end
            Visuals.ModelHighlights = {}
        else
            for _, obj in ipairs(Shared.Workspace:GetChildren()) do
                if obj:IsA("Model") and not Shared.Players:GetPlayerFromCharacter(obj) then
                    if not Visuals.ModelHighlights[obj] or not Visuals.ModelHighlights[obj].Parent then
                        pcall(function()
                            local hl = Instance.new("Highlight")
                            hl.Name = "FTAP_Model_Highlight"
                            hl.Adornee = obj
                            hl.FillColor = Color3.fromRGB(0, 255, 170)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = Shared.CoreGui
                            Visuals.ModelHighlights[obj] = hl
                        end)
                    end
                end
            end
        end
    end)
end
function Visuals.UpdateModelBillboards(state)
    Visuals.Config.ModelBillboardEnabled = state
    pcall(function()
        if not state then
            for model, gui in pairs(Visuals.ModelBillboards) do
                if gui then
                    pcall(function() gui:Destroy() end)
                end
            end
            Visuals.ModelBillboards = {}
        else
            for _, obj in ipairs(Shared.Workspace:GetChildren()) do
                if obj:IsA("Model") and not Shared.Players:GetPlayerFromCharacter(obj) then
                    local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primaryPart and (not Visuals.ModelBillboards[obj] or not Visuals.ModelBillboards[obj].Parent) then
                        pcall(function()
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "FTAP_Model_Billboard"
                            bb.Adornee = primaryPart
                            bb.Size = UDim2.new(0, 100, 0, 50)
                            bb.StudsOffset = Vector3.new(0, 3, 0)
                            bb.AlwaysOnTop = true
                            bb.Parent = Shared.CoreGui
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = obj.Name
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.TextStrokeTransparency = 0
                            label.Parent = bb
                            
                            Visuals.ModelBillboards[obj] = bb
                        end)
                    end
                end
            end
        end
    end)
end



-- ============================================================================
-- NEON DREAM SHADER ENGINE
-- ============================================================================

Visuals.NeonDreamConfig = {
    Enabled = false,
    GlowIntensity = 3.0,        -- 0 to 10
    PulseSpeed = 1.5,           -- 0 to 5
    ParticleDensity = 30,       -- 0 to 100
    VignetteTransparency = 0.4, -- 0 to 1
    Palette = "Neon Purple",    -- Neon Purple, Cyber Blue, Sunset Pink, Matrix Green, Custom
    CustomColor = Color3.fromRGB(180, 0, 255),
    CustomR = 180,
    CustomG = 0,
    CustomB = 255
}

Visuals.NeonDreamPalettes = {
    ["Neon Purple"] = Color3.fromRGB(180, 0, 255),
    ["Cyber Blue"]  = Color3.fromRGB(0, 220, 255),
    ["Sunset Pink"]  = Color3.fromRGB(255, 50, 150),
    ["Matrix Green"] = Color3.fromRGB(0, 255, 100)
}

Visuals.NeonDreamState = {
    OriginalLighting = { Saved = false },
    Bloom = nil,
    ColorCorrection = nil,
    SunRays = nil,
    VignetteGui = nil,
    VignetteImage = nil,
    Attachment = nil,
    ParticleEmitter = nil,
    RenderConnection = nil,
    CharacterConnection = nil
}

function Visuals.GetNeonDreamColor()
    local cfg = Visuals.NeonDreamConfig
    if cfg.Palette == "Custom" then
        return cfg.CustomColor or Color3.fromRGB(cfg.CustomR or 180, cfg.CustomG or 0, cfg.CustomB or 255)
    end
    return Visuals.NeonDreamPalettes[cfg.Palette] or Color3.fromRGB(180, 0, 255)
end

function Visuals.CleanupNeonDreamInstances()
    local st = Visuals.NeonDreamState
    pcall(function()
        if st.Bloom then st.Bloom:Destroy() st.Bloom = nil end
        if st.ColorCorrection then st.ColorCorrection:Destroy() st.ColorCorrection = nil end
        if st.SunRays then st.SunRays:Destroy() st.SunRays = nil end
        if st.VignetteGui then st.VignetteGui:Destroy() st.VignetteGui = nil st.VignetteImage = nil end
        if st.ParticleEmitter then st.ParticleEmitter:Destroy() st.ParticleEmitter = nil end
        if st.Attachment then st.Attachment:Destroy() st.Attachment = nil end
    end)
    pcall(function()
        for _, child in ipairs(Shared.Lighting:GetChildren()) do
            if child.Name:sub(1, 10) == "NeonDream_" then
                pcall(function() child:Destroy() end)
            end
        end
        for _, child in ipairs(Shared.CoreGui:GetChildren()) do
            if child.Name == "NeonDream_VignetteGui" then
                pcall(function() child:Destroy() end)
            end
        end
    end)
end

function Visuals.SetupNeonDreamParticles()
    local st = Visuals.NeonDreamState
    local char = Shared.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if st.Attachment then pcall(function() st.Attachment:Destroy() end) end
    if st.ParticleEmitter then pcall(function() st.ParticleEmitter:Destroy() end) end

    local att = Instance.new("Attachment")
    att.Name = "NeonDream_Attachment"
    att.Parent = root
    st.Attachment = att

    local pe = Instance.new("ParticleEmitter")
    pe.Name = "NeonDream_Particles"
    pe.Texture = "rbxassetid://2581223252"
    pe.Color = ColorSequence.new(Visuals.GetNeonDreamColor())
    pe.Rate = Visuals.NeonDreamConfig.ParticleDensity
    pe.Lifetime = NumberRange.new(0.8, 1.5)
    pe.Speed = NumberRange.new(1, 3.5)
    pe.SpreadAngle = Vector2.new(180, 180)
    pe.LightEmission = 1
    pe.LightInfluence = 0
    pe.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    pe.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    pe.Parent = att
    st.ParticleEmitter = pe
end

function Visuals.ToggleNeonDream(state)
    Visuals.NeonDreamConfig.Enabled = state
    local st = Visuals.NeonDreamState

    if state then
        pcall(function()
            if not st.OriginalLighting.Saved then
                st.OriginalLighting.Ambient = Shared.Lighting.Ambient
                st.OriginalLighting.OutdoorAmbient = Shared.Lighting.OutdoorAmbient
                st.OriginalLighting.Saved = true
            end

            Visuals.CleanupNeonDreamInstances()

            local bloom = Instance.new("BloomEffect")
            bloom.Name = "NeonDream_Bloom"
            bloom.Intensity = Visuals.NeonDreamConfig.GlowIntensity * 0.8
            bloom.Size = 28
            bloom.Threshold = 0.8
            bloom.Parent = Shared.Lighting
            st.Bloom = bloom

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "NeonDream_ColorCorrection"
            cc.TintColor = Visuals.GetNeonDreamColor()
            cc.Brightness = 0.05
            cc.Contrast = 0.15
            cc.Saturation = 0.5
            cc.Parent = Shared.Lighting
            st.ColorCorrection = cc

            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Name = "NeonDream_SunRays"
            sunRays.Intensity = math.clamp(Visuals.NeonDreamConfig.GlowIntensity * 0.08, 0, 1)
            sunRays.Spread = 0.8
            sunRays.Parent = Shared.Lighting
            st.SunRays = sunRays

            local gui = Instance.new("ScreenGui")
            gui.Name = "NeonDream_VignetteGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.Parent = Shared.CoreGui

            local img = Instance.new("ImageLabel")
            img.Name = "VignetteFrame"
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://4576475446"
            img.ImageColor3 = Visuals.GetNeonDreamColor()
            img.ImageTransparency = math.clamp(1 - Visuals.NeonDreamConfig.VignetteTransparency, 0, 1)
            img.Parent = gui
            st.VignetteGui = gui
            st.VignetteImage = img

            Visuals.SetupNeonDreamParticles()

            if not st.CharacterConnection then
                st.CharacterConnection = Shared.LocalPlayer.CharacterAdded:Connect(function()
                    if Visuals.NeonDreamConfig.Enabled then
                        task.wait(0.5)
                        pcall(function() Visuals.SetupNeonDreamParticles() end)
                    end
                end)
            end

            if st.RenderConnection then st.RenderConnection:Disconnect() end
            st.RenderConnection = Shared.RunService.RenderStepped:Connect(function()
                if not Visuals.NeonDreamConfig.Enabled then return end
                pcall(function()
                    local cfg = Visuals.NeonDreamConfig
                    local pulseSpeed = cfg.PulseSpeed
                    local sinVal = (pulseSpeed > 0) and math.sin(tick() * pulseSpeed * 3) or 0
                    local activeColor = Visuals.GetNeonDreamColor()

                    if st.Bloom then
                        st.Bloom.Intensity = math.clamp((cfg.GlowIntensity * 0.5) + (sinVal * 0.25 * cfg.GlowIntensity), 0, 20)
                    end
                    if st.ColorCorrection then
                        st.ColorCorrection.TintColor = activeColor
                        st.ColorCorrection.Saturation = 0.4 + (sinVal * 0.2)
                        st.ColorCorrection.Brightness = (sinVal * 0.04 * (cfg.GlowIntensity / 5))
                    end
                    if st.SunRays then
                        st.SunRays.Intensity = math.clamp((cfg.GlowIntensity * 0.06) + (sinVal * 0.03), 0, 1)
                    end
                    if st.VignetteImage then
                        st.VignetteImage.ImageColor3 = activeColor
                        st.VignetteImage.ImageTransparency = math.clamp(1 - cfg.VignetteTransparency, 0, 1)
                    end
                    if st.ParticleEmitter then
                        st.ParticleEmitter.Color = ColorSequence.new(activeColor)
                        st.ParticleEmitter.Rate = cfg.ParticleDensity
                    end
                end)
            end)

            Shared.Notify("Visuals", "Neon Dream Shader Enabled ✨", 2)
            Shared.PlayEnableSound()
        end)
    else
        pcall(function()
            Visuals.CleanupNeonDreamInstances()
            if st.RenderConnection then
                st.RenderConnection:Disconnect()
                st.RenderConnection = nil
            end
            if st.CharacterConnection then
                st.CharacterConnection:Disconnect()
                st.CharacterConnection = nil
            end

            if st.OriginalLighting.Saved then
                if st.OriginalLighting.Ambient then Shared.Lighting.Ambient = st.OriginalLighting.Ambient end
                if st.OriginalLighting.OutdoorAmbient then Shared.Lighting.OutdoorAmbient = st.OriginalLighting.OutdoorAmbient end
                st.OriginalLighting.Saved = false
            end

            Shared.Notify("Visuals", "Neon Dream Shader Disabled", 2)
        end)
    end
end

function Visuals.ResetNeonDreamConfig()
    Visuals.NeonDreamConfig.GlowIntensity = 3.0
    Visuals.NeonDreamConfig.PulseSpeed = 1.5
    Visuals.NeonDreamConfig.ParticleDensity = 30
    Visuals.NeonDreamConfig.VignetteTransparency = 0.4
    Visuals.NeonDreamConfig.Palette = "Neon Purple"
    Visuals.NeonDreamConfig.CustomColor = Color3.fromRGB(180, 0, 255)
    Visuals.NeonDreamConfig.CustomR = 180
    Visuals.NeonDreamConfig.CustomG = 0
    Visuals.NeonDreamConfig.CustomB = 255
    if Visuals.NeonDreamConfig.Enabled then
        Visuals.ToggleNeonDream(false)
    end
end

return Visuals