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
    ModelBillboardEnabled = false,
    PCLD_BoxesEnabled = false,
    PCLD_BoxColor = Color3.fromRGB(57, 255, 20),
    ProfileESPEnabled = false,
    OverheadTagsEnabled = false,
    XRayEnabled = false,
    XRayTransparency = 0.6,
    FullbrightEnabled = false,
    NoFogEnabled = false
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
                    if hl and hl.Parent then
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
            if hl and hl.Parent then hl:Destroy() end
        end
        Visuals.PCLDHighlights = {}
        return
    end

    for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector" or obj.Name == "FirePlayerPart") then
            if not Visuals.PCLDHighlights[obj] or not Visuals.PCLDHighlights[obj].Parent then
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
            if hl and hl.Parent then hl:Destroy() end
        end
        Visuals.ESPHighlights = {}
        return
    end

    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and player.Character then
            local char = player.Character
            local root = Shared.GetRoot(player)
            if not Visuals.ESPHighlights[player] and root then
                local hl = Instance.new("Highlight")
                hl.Name = "FTAP_ESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Visuals.Config.RainbowESP and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Visuals.Config.ESPColor
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
                elseif not Visuals.Config.RainbowESP then
                    hl.FillColor = Visuals.Config.ESPColor
                end
            end
        else
            if Visuals.ESPHighlights[player] then
                pcall(function() Visuals.ESPHighlights[player]:Destroy() end)
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
                if hl and hl.Parent then
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
                if gui and gui.Parent then
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
                            label.Font = Enum.Font.GothamBold
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
    local root = Shared.GetRoot(Shared.LocalPlayer)
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

-- ============================================================================
-- GemoroiUI v3.5 FEATURES: PCLD BoxHandleAdornments, Profile ESP (Avatars),
-- Soap Textures (FPS Boost)
-- ============================================================================

Visuals.PCLDBoxAdornments = {}
Visuals.PCLDBoxWatchers = {}
Visuals.ProfileESP = { records = {}, loop = nil, thumbCache = {} }
Visuals.Soap = { enabled = false, saved = setmetatable({}, { __mode = "k" }), connection = nil }

-- === PCLD BOXHANDLEADORNMENTS ===
local function isPCLDPart(obj)
    return obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector" or obj.Name == "FirePlayerPart")
end

local function addPCLDBox(obj)
    if Visuals.PCLDBoxAdornments[obj] then
        return
    end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "PCLD_BoxAdornment"
    box.Adornee = obj
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Visuals.Config.PCLD_BoxColor
    box.Transparency = 0.3
    box.Size = obj.Size
    box.Parent = Shared.CoreGui
    Visuals.PCLDBoxAdornments[obj] = box

    local conn = obj.AncestryChanged:Connect(function(_, parent)
        if not parent and Visuals.PCLDBoxAdornments[obj] then
            pcall(function() Visuals.PCLDBoxAdornments[obj]:Destroy() end)
            Visuals.PCLDBoxAdornments[obj] = nil
        end
    end)
    table.insert(Visuals.PCLDBoxWatchers, conn)
end

function Visuals.UpdatePCLDBoxes()
    if not Visuals.Config.PCLD_BoxesEnabled then
        for _, box in pairs(Visuals.PCLDBoxAdornments) do
            if box then
                pcall(function() box:Destroy() end)
            end
        end
        Visuals.PCLDBoxAdornments = {}
        for _, c in ipairs(Visuals.PCLDBoxWatchers) do
            pcall(function() c:Disconnect() end)
        end
        Visuals.PCLDBoxWatchers = {}
        return
    end

    for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
        if isPCLDPart(obj) and obj.Parent then
            addPCLDBox(obj)
        end
    end

    for obj, box in pairs(Visuals.PCLDBoxAdornments) do
        if not box or not box.Parent or not obj or not obj.Parent then
            if box then
                pcall(function() box:Destroy() end)
            end
            Visuals.PCLDBoxAdornments[obj] = nil
        end
    end
end

function Visuals.SetPCLDBoxColor(color)
    Visuals.Config.PCLD_BoxColor = color
    for _, box in pairs(Visuals.PCLDBoxAdornments) do
        if box then
            box.Color3 = color
        end
    end
end

-- === PROFILE ESP (AVATARS ABOVE HEAD) ===
-- Avatar headshots via rbxthumb:// (synchronous, no API call needed)
local function getProfileThumb(player)
    return "rbxthumb://type=HeadShot&id=" .. tostring(player.UserId) .. "&w=420&h=420"
end

local function createProfileBillboard(player)
    task.spawn(function()
        if not Visuals.Config.ProfileESPEnabled then
            return
        end
        if Visuals.ProfileESP.records[player] then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local head = char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart")
        if not head then
            return
        end

        local bb = Instance.new("BillboardGui")
        bb.Name = "Gemoroi_ProfileESP"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 64, 0, 84)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1500
        bb.Parent = Shared.CoreGui

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.AnchorPoint = Vector2.new(0.5, 0)
        avatar.Position = UDim2.new(0.5, 0, 0, 0)
        avatar.Size = UDim2.new(0, 52, 0, 52)
        avatar.BackgroundColor3 = Color3.fromRGB(16, 20, 17)
        avatar.BorderSizePixel = 0
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.Image = ""
        avatar.Parent = bb
        local avCorner = Instance.new("UICorner")
        avCorner.CornerRadius = UDim.new(0, 26)
        avCorner.Parent = avatar
        local avStroke = Instance.new("UIStroke")
        avStroke.Color = Visuals.Config.PCLD_BoxColor
        avStroke.Thickness = 1.5
        avStroke.Parent = avatar

        local thumb = getProfileThumb(player)
        if thumb then
            avatar.Image = thumb
        end

        local displayName = Instance.new("TextLabel")
        displayName.Name = "DisplayName"
        displayName.AnchorPoint = Vector2.new(0.5, 0)
        displayName.Position = UDim2.new(0.5, 0, 0, 54)
        displayName.Size = UDim2.new(0, 120, 0, 13)
        displayName.BackgroundTransparency = 1
        displayName.Font = Enum.Font.GothamBold
        displayName.TextSize = 12
        displayName.TextColor3 = Color3.fromRGB(233, 240, 234)
        displayName.TextStrokeTransparency = 0.4
        displayName.TextTruncate = Enum.TextTruncate.AtEnd
        displayName.Text = player.DisplayName or player.Name
        displayName.Parent = bb

        local userName = Instance.new("TextLabel")
        userName.Name = "UserName"
        userName.AnchorPoint = Vector2.new(0.5, 0)
        userName.Position = UDim2.new(0.5, 0, 0, 67)
        userName.Size = UDim2.new(0, 120, 0, 11)
        userName.BackgroundTransparency = 1
        userName.Font = Enum.Font.Gotham
        userName.TextSize = 10
        userName.TextColor3 = Color3.fromRGB(139, 153, 143)
        userName.TextStrokeTransparency = 0.4
        userName.TextTruncate = Enum.TextTruncate.AtEnd
        userName.Text = "@" .. player.Name
        userName.Parent = bb

        local hpBg = Instance.new("Frame")
        hpBg.Name = "HealthBg"
        hpBg.AnchorPoint = Vector2.new(0.5, 0)
        hpBg.Position = UDim2.new(0.5, 0, 0, 80)
        hpBg.Size = UDim2.new(0, 52, 0, 4)
        hpBg.BackgroundColor3 = Color3.fromRGB(11, 14, 12)
        hpBg.BackgroundTransparency = 0.25
        hpBg.BorderSizePixel = 0
        hpBg.Parent = bb
        local hpCorner = Instance.new("UICorner")
        hpCorner.CornerRadius = UDim.new(0, 2)
        hpCorner.Parent = hpBg

        local hpFill = Instance.new("Frame")
        hpFill.Name = "HealthFill"
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(163, 230, 53)
        hpFill.BorderSizePixel = 0
        hpFill.Parent = hpBg
        local hpFillCorner = Instance.new("UICorner")
        hpFillCorner.CornerRadius = UDim.new(0, 2)
        hpFillCorner.Parent = hpFill

        Visuals.ProfileESP.records[player] = { gui = bb, fill = hpFill }
    end)
end

function Visuals.UpdateProfileESP()
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and not Visuals.ProfileESP.records[player] and player.Character then
            createProfileBillboard(player)
        end
    end
    for player, record in pairs(Visuals.ProfileESP.records) do
        if not player.Parent or not record.gui or not record.gui.Parent then
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
            Visuals.ProfileESP.records[player] = nil
        else
            local char = player.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
            if head and record.gui.Adornee ~= head then
                record.gui.Adornee = head
            end
            if not record.gui.Avatar.Image or record.gui.Avatar.Image == "" then
                local thumb = getProfileThumb(player)
                if thumb then
                    record.gui.Avatar.Image = thumb
                end
            end
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and record.fill then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                record.fill.Size = UDim2.new(pct, 0, 1, 0)
                record.fill.BackgroundColor3 = Color3.fromRGB(
                    math.floor(255 * (1 - pct)),
                    math.floor(230 * pct),
                    53
                )
            end
        end
    end
end

function Visuals.ToggleProfileESP(state)
    Visuals.Config.ProfileESPEnabled = state
    if state then
        Visuals.ProfileESP.loop = task.spawn(function()
            while Visuals.Config.ProfileESPEnabled do
                pcall(Visuals.UpdateProfileESP)
                task.wait(0.5)
            end
        end)
        pcall(Visuals.UpdateProfileESP)
        Shared.Notify("Profile ESP", "Enabled - avatars above heads", 2)
    else
        if Visuals.ProfileESP.loop then
            task.cancel(Visuals.ProfileESP.loop)
            Visuals.ProfileESP.loop = nil
        end
        for _, record in pairs(Visuals.ProfileESP.records) do
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
        end
        Visuals.ProfileESP.records = {}
        Shared.Notify("Profile ESP", "Disabled", 2)
    end
end

-- === SOAP TEXTURES (FPS BOOST) ===
local function soapifyObject(obj)
    if obj:IsA("BasePart") then
        if not Visuals.Soap.saved[obj] then
            Visuals.Soap.saved[obj] = { Material = obj.Material, Color = obj.Color }
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.new(obj.Color.R * 0.75, obj.Color.G * 0.75, obj.Color.B * 0.75)
        end
    elseif obj:IsA("Texture") or obj:IsA("Decal") then
        if not Visuals.Soap.saved[obj] then
            Visuals.Soap.saved[obj] = { Transparency = obj.Transparency }
            obj.Transparency = 1
        end
    end
end

-- === OVERHEAD BILLBOARD TAGS (name, @user, distance, health bar) ===
Visuals.OverheadTags = { records = {}, loop = nil }

local function createOverheadTag(player)
    if Visuals.OverheadTags.records[player] then
        return
    end
    local char = player.Character
    local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
    if not head then
        return
    end

    local bb = Instance.new("BillboardGui")
    bb.Name = "Gemoroi_OverheadTag"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 140, 0, 44)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 2000
    bb.Parent = Shared.CoreGui

    local name = Instance.new("TextLabel")
    name.Name = "Name"
    name.BackgroundTransparency = 1
    name.Position = UDim2.new(0, 0, 0, 0)
    name.Size = UDim2.new(1, 0, 0, 14)
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    name.TextColor3 = Color3.fromRGB(240, 244, 248)
    name.TextStrokeTransparency = 0.4
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Text = (player.DisplayName or player.Name)
    name.Parent = bb

    local user = Instance.new("TextLabel")
    user.Name = "User"
    user.BackgroundTransparency = 1
    user.Position = UDim2.new(0, 0, 0, 14)
    user.Size = UDim2.new(1, 0, 0, 11)
    user.Font = Enum.Font.Gotham
    user.TextSize = 10
    user.TextColor3 = Color3.fromRGB(148, 158, 170)
    user.TextStrokeTransparency = 0.4
    user.TextTruncate = Enum.TextTruncate.AtEnd
    user.Text = "@" .. player.Name
    user.Parent = bb

    local dist = Instance.new("TextLabel")
    dist.Name = "Distance"
    dist.BackgroundTransparency = 1
    dist.Position = UDim2.new(0, 0, 0, 25)
    dist.Size = UDim2.new(1, 0, 0, 11)
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 10
    dist.TextColor3 = Color3.fromRGB(57, 255, 20)
    dist.TextStrokeTransparency = 0.4
    dist.Text = "0 studs"
    dist.Parent = bb

    local hpBg = Instance.new("Frame")
    hpBg.Name = "HealthBg"
    hpBg.AnchorPoint = Vector2.new(0.5, 0)
    hpBg.Position = UDim2.new(0.5, 0, 0, 38)
    hpBg.Size = UDim2.new(0, 100, 0, 4)
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
    hpBg.BackgroundTransparency = 0.25
    hpBg.BorderSizePixel = 0
    hpBg.Parent = bb
    local hpC = Instance.new("UICorner")
    hpC.CornerRadius = UDim.new(0, 2)
    hpC.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.Name = "HealthFill"
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg
    local hpFC = Instance.new("UICorner")
    hpFC.CornerRadius = UDim.new(0, 2)
    hpFC.Parent = hpFill

    Visuals.OverheadTags.records[player] = { gui = bb, fill = hpFill, dist = dist }
end

function Visuals.UpdateOverheadTags()
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and not Visuals.OverheadTags.records[player] and player.Character then
            createOverheadTag(player)
        end
    end
    for player, record in pairs(Visuals.OverheadTags.records) do
        if not player.Parent or not record.gui or not record.gui.Parent then
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
            Visuals.OverheadTags.records[player] = nil
        else
            local char = player.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
            if head and record.gui.Adornee ~= head then
                record.gui.Adornee = head
            end
            local root = char and (char:FindFirstChild("HumanoidRootPart") or head)
            if root and myRoot and record.dist then
                record.dist.Text = string.format("%d studs", (root.Position - myRoot.Position).Magnitude)
            end
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and record.fill then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                record.fill.Size = UDim2.new(pct, 0, 1, 0)
                record.fill.BackgroundColor3 = Color3.fromRGB(
                    math.floor(255 * (1 - pct)),
                    math.floor(255 * pct * 0.85 + 30),
                    20
                )
            end
        end
    end
end

function Visuals.ToggleOverheadTags(state)
    Visuals.Config.OverheadTagsEnabled = state
    if state then
        Visuals.OverheadTags.loop = task.spawn(function()
            while Visuals.Config.OverheadTagsEnabled do
                pcall(Visuals.UpdateOverheadTags)
                task.wait(0.25)
            end
        end)
        pcall(Visuals.UpdateOverheadTags)
        Shared.Notify("Overhead Tags", "Enabled - names, distance & health above heads", 2)
    else
        if Visuals.OverheadTags.loop then
            task.cancel(Visuals.OverheadTags.loop)
            Visuals.OverheadTags.loop = nil
        end
        for _, record in pairs(Visuals.OverheadTags.records) do
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
        end
        Visuals.OverheadTags.records = {}
        Shared.Notify("Overhead Tags", "Disabled", 2)
    end
end

-- === X-RAY VISION (semi-transparent map walls) ===
Visuals.XRay = { saved = setmetatable({}, { __mode = "k" }) }

local function isCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    return model ~= nil and Shared.Players:GetPlayerFromCharacter(model) ~= nil
end

function Visuals.ToggleXRay(state)
    Visuals.Config.XRayEnabled = state
    if state then
        task.spawn(function()
            for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isCharacterPart(obj)
                        and obj.Name ~= "HoldPart" and obj.Transparency < 0.5 then
                        if not Visuals.XRay.saved[obj] then
                            Visuals.XRay.saved[obj] = { Transparency = obj.Transparency }
                            obj.Transparency = Visuals.Config.XRayTransparency
                        end
                    elseif (obj:IsA("Decal") or obj:IsA("Texture")) and obj.Transparency < 1 then
                        if not Visuals.XRay.saved[obj] then
                            Visuals.XRay.saved[obj] = { Transparency = obj.Transparency }
                            obj.Transparency = 1
                        end
                    end
                end)
            end
            Shared.Notify("X-Ray Vision", "Enabled - walls are see-through (Transparency 0.6)", 2)
        end)
    else
        task.spawn(function()
            for obj, orig in pairs(Visuals.XRay.saved) do
                pcall(function()
                    if obj and obj.Parent and orig.Transparency then
                        obj.Transparency = orig.Transparency
                    end
                end)
            end
            Visuals.XRay.saved = setmetatable({}, { __mode = "k" })
            Shared.Notify("X-Ray Vision", "Disabled - map restored", 2)
        end)
    end
end

-- === MAP CUSTOMIZER (live Grass/Rock/Sand/Snow recolor + Reset) ===
Visuals.MapCustomizer = { savedParts = setmetatable({}, { __mode = "k" }), savedTerrain = {} }

local MapMaterials = {
    Enum.Material.Grass,
    Enum.Material.Rock,
    Enum.Material.Sand,
    Enum.Material.Snow,
}

function Visuals.ApplyMapColor(material, color)
    local matName = material.Name
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and obj.Material == material and not isCharacterPart(obj) then
                    if not Visuals.MapCustomizer.savedParts[obj] then
                        Visuals.MapCustomizer.savedParts[obj] = { Color = obj.Color }
                    end
                    obj.Color = color
                    count = count + 1
                end
            end)
        end
        pcall(function()
            local terrain = Shared.Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                if not Visuals.MapCustomizer.savedTerrain[matName] then
                    Visuals.MapCustomizer.savedTerrain[matName] = terrain:GetMaterialColor(material)
                end
                terrain:SetMaterialColor(material, color)
            end
        end)
        Shared.Notify("Map Customizer", matName .. " recolored (" .. count .. " parts)", 2)
    end)
end

function Visuals.ResetMapColors()
    task.spawn(function()
        for obj, orig in pairs(Visuals.MapCustomizer.savedParts) do
            pcall(function()
                if obj and obj.Parent and orig.Color then
                    obj.Color = orig.Color
                end
            end)
        end
        Visuals.MapCustomizer.savedParts = setmetatable({}, { __mode = "k" })
        pcall(function()
            local terrain = Shared.Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                for matName, color in pairs(Visuals.MapCustomizer.savedTerrain) do
                    local material = Enum.Material[matName]
                    if material then
                        terrain:SetMaterialColor(material, color)
                    end
                end
            end
        end)
        Visuals.MapCustomizer.savedTerrain = {}
        Shared.Notify("Map Customizer", "Map colors reset to original", 2)
    end)
end

-- === FULLBRIGHT & NOFOG ===
Visuals.LightingSaved = {}

function Visuals.ToggleFullbright(state)
    Visuals.Config.FullbrightEnabled = state
    pcall(function()
        local L = Shared.Lighting
        if state then
            Visuals.LightingSaved.Fullbright = {
                Brightness = L.Brightness,
                ClockTime = L.ClockTime,
                GlobalShadows = L.GlobalShadows,
                FogEnd = L.FogEnd,
                Ambient = L.Ambient,
                OutdoorAmbient = L.OutdoorAmbient,
            }
            L.Brightness = 2.5
            L.ClockTime = 14
            L.GlobalShadows = false
            L.FogEnd = 100000
            L.Ambient = Color3.fromRGB(178, 178, 178)
            L.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
            Shared.Notify("Fullbright", "Enabled - 100% lighting", 2)
        else
            local saved = Visuals.LightingSaved.Fullbright
            if saved then
                L.Brightness = saved.Brightness
                L.ClockTime = saved.ClockTime
                L.GlobalShadows = saved.GlobalShadows
                L.FogEnd = saved.FogEnd
                L.Ambient = saved.Ambient
                L.OutdoorAmbient = saved.OutdoorAmbient
            end
            Shared.Notify("Fullbright", "Disabled", 2)
        end
    end)
end

function Visuals.ToggleNoFog(state)
    Visuals.Config.NoFogEnabled = state
    pcall(function()
        local L = Shared.Lighting
        if state then
            Visuals.LightingSaved.NoFog = {
                FogEnd = L.FogEnd,
                FogStart = L.FogStart,
                FogColor = L.FogColor,
            }
            L.FogEnd = 100000
            L.FogStart = 0
            Shared.Notify("NoFog", "Enabled - fog removed", 2)
        else
            local saved = Visuals.LightingSaved.NoFog
            if saved then
                L.FogEnd = saved.FogEnd
                L.FogStart = saved.FogStart
                L.FogColor = saved.FogColor
            end
            Shared.Notify("NoFog", "Disabled", 2)
        end
    end)
end

function Visuals.ToggleSoapTextures(state)
    Visuals.Soap.enabled = state
    if state then
        Shared.Notify("Optimization", "Applying Soap Textures...", 2)
        task.spawn(function()
            for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
                soapifyObject(obj)
            end
            Shared.Notify("Optimization", "Soap Textures Applied! Everything is soap now", 2)
        end)
        Visuals.Soap.connection = Shared.Workspace.DescendantAdded:Connect(function(obj)
            task.defer(function()
                if Visuals.Soap.enabled then
                    pcall(function() soapifyObject(obj) end)
                end
            end)
        end)
    else
        if Visuals.Soap.connection then
            Visuals.Soap.connection:Disconnect()
            Visuals.Soap.connection = nil
        end
        Shared.Notify("Optimization", "Restoring original textures...", 2)
        task.spawn(function()
            for obj, orig in pairs(Visuals.Soap.saved) do
                pcall(function()
                    if obj and obj.Parent then
                        if orig.Material then
                            obj.Material = orig.Material
                            obj.Color = orig.Color
                        end
                        if orig.Transparency then
                            obj.Transparency = orig.Transparency
                        end
                    end
                end)
            end
            Visuals.Soap.saved = setmetatable({}, { __mode = "k" })
            Shared.Notify("Optimization", "Original textures restored!", 2)
        end)
    end
end

return Visuals