local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Cosmetics = {}

-- Hat/Trail/Visual Effects
Cosmetics.ChineseHat = {
    enabled = false,
    model = nil,
    connection = nil
}

Cosmetics.Trails = {
    enabled = false,
    color = Color3.fromRGB(0, 170, 255),
    transparency = 0,
    rainbow = false,
    trails = {},
    connection = nil
}

Cosmetics.ForceField = {
    enabled = false,
    connection = nil
}

Cosmetics.SkinTrails = {
    enabled = false,
    connection = nil
}

Cosmetics.LocalAura = {
    enabled = false,
    assetId = 0,
    model = nil,
    connection = nil
}

Cosmetics.NeonMaterial = {
    enabled = false,
    connection = nil
}

-- World Effects
Cosmetics.Skybox = {
    enabled = false,
    skyboxId = "",
    originalSky = nil
}

Cosmetics.Fog = {
    enabled = false,
    color = Color3.fromRGB(128, 128, 128),
    start = 0,
    endd = 1000
}

Cosmetics.FullBright = {
    enabled = false,
    connection = nil
}

Cosmetics.TimeOfDay = {
    enabled = false,
    time = 12,
    connection = nil
}

Cosmetics.FOV = {
    enabled = false,
    fov = 70,
    connection = nil
}

-- Screen Effects
Cosmetics.ScreenStretch = {
    enabled = false,
    intensity = 1,
    connection = nil
}

Cosmetics.AnimeImage = {
    enabled = false,
    imageId = "",
    gui = nil
}

-- Custom Effects
Cosmetics.CustomEffects = {
    enabled = false,
    selectedEffect = "None",
    connection = nil,
    effects = {
        "None",
        "Rings", "Lightning", "Glitch", "Fire", "Rainbow Body",
        "Bubble", "Stars", "Ice Shards", "Shadow Clones", "Meteor Rain"
    }
}
-- ============================================================================
-- PHANTOM PARTS (Headless / Korblox)
-- ============================================================================
Cosmetics.Phantom = { saved = {}, rainbowThread = nil }

local function phantomTargets()
    local char = Shared.LocalPlayer.Character
    return char
end

function Cosmetics.TogglePhantomHeadless(state)
    pcall(function()
        local char = phantomTargets()
        if not char then return end
        local head = char:FindFirstChild("Head")
        if state then
            if head and not Cosmetics.Phantom.saved.Head then
                Cosmetics.Phantom.saved.Head = { Transparency = head.Transparency }
                head.Transparency = 1
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency = 1
                    end
                end
            end
            Shared.Notify("Phantom", "Headless look enabled", 2)
        else
            if head and Cosmetics.Phantom.saved.Head then
                head.Transparency = Cosmetics.Phantom.saved.Head.Transparency or 0
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency = 0
                    end
                end
            end
            Cosmetics.Phantom.saved.Head = nil
            Shared.Notify("Phantom", "Head restored", 2)
        end
    end)
end

function Cosmetics.TogglePhantomKorblox(state)
    pcall(function()
        local char = phantomTargets()
        if not char then return end
        local leg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
        if state then
            if leg and not Cosmetics.Phantom.saved.Korblox then
                Cosmetics.Phantom.saved.Korblox = { Transparency = leg.Transparency, Material = leg.Material, Color = leg.Color }
                leg.Transparency = 0.45
                leg.Material = Enum.Material.Neon
                leg.Color = Color3.fromRGB(57, 255, 20)
            end
            Shared.Notify("Phantom", "Phantom Korblox Leg enabled", 2)
        else
            if leg and Cosmetics.Phantom.saved.Korblox then
                leg.Transparency = Cosmetics.Phantom.saved.Korblox.Transparency or 0
                leg.Material = Cosmetics.Phantom.saved.Korblox.Material or Enum.Material.Plastic
                leg.Color = Cosmetics.Phantom.saved.Korblox.Color or Color3.fromRGB(255, 255, 255)
            end
            Cosmetics.Phantom.saved.Korblox = nil
            Shared.Notify("Phantom", "Leg restored", 2)
        end
    end)
end

-- ============================================================================
-- RAINBOW HAT & RAINBOW FORCEFIELD
-- ============================================================================
Cosmetics.RainbowHat = { part = nil, thread = nil }
Cosmetics.RainbowForceField = { highlight = nil, thread = nil }

function Cosmetics.ToggleRainbowHat(state)
    if state then
        pcall(function()
            local char = Shared.LocalPlayer.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
            if not head then return end
            if Cosmetics.RainbowHat.part and Cosmetics.RainbowHat.part.Parent then
                Cosmetics.RainbowHat.part:Destroy()
            end
            local hat = Instance.new("Part")
            hat.Name = "Gemoroi_RainbowHat"
            hat.Size = Vector3.new(1.6, 0.9, 1.6)
            hat.Material = Enum.Material.Neon
            hat.CanCollide = false
            hat.Massless = true
            hat.Anchored = false
            hat.Parent = char
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = hat
            weld.Part1 = head
            weld.Parent = hat
            hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
            Cosmetics.RainbowHat.part = hat
            if Cosmetics.RainbowHat.thread then task.cancel(Cosmetics.RainbowHat.thread) end
            Cosmetics.RainbowHat.thread = task.spawn(function()
                local hue = 0
                while Cosmetics.RainbowHat.part and Cosmetics.RainbowHat.part.Parent do
                    Cosmetics.RainbowHat.part.Color = Color3.fromHSV(hue % 1, 1, 1)
                    hue = hue + 0.01
                    task.wait(0.03)
                end
            end)
            Shared.Notify("Cosmetics", "Rainbow Hat equipped", 2)
        end)
    else
        if Cosmetics.RainbowHat.thread then
            task.cancel(Cosmetics.RainbowHat.thread)
            Cosmetics.RainbowHat.thread = nil
        end
        if Cosmetics.RainbowHat.part then
            pcall(function() Cosmetics.RainbowHat.part:Destroy() end)
            Cosmetics.RainbowHat.part = nil
        end
        Shared.Notify("Cosmetics", "Rainbow Hat removed", 2)
    end
end

function Cosmetics.ToggleRainbowForceField(state)
    if state then
        pcall(function()
            local char = Shared.LocalPlayer.Character
            if not char then return end
            if not Cosmetics.RainbowForceField.highlight then
                local hl = Instance.new("Highlight")
                hl.Name = "Gemoroi_RainbowFF"
                hl.Adornee = char
                hl.FillTransparency = 0.55
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = Shared.CoreGui
                Cosmetics.RainbowForceField.highlight = hl
            end
            if Cosmetics.RainbowForceField.thread then task.cancel(Cosmetics.RainbowForceField.thread) end
            Cosmetics.RainbowForceField.thread = task.spawn(function()
                local hue = 0
                while Cosmetics.RainbowForceField.highlight do
                    local color = Color3.fromHSV(hue % 1, 1, 1)
                    Cosmetics.RainbowForceField.highlight.FillColor = color
                    Cosmetics.RainbowForceField.highlight.OutlineColor = color
                    hue = hue + 0.005
                    task.wait(0.03)
                end
            end)
            Shared.Notify("Cosmetics", "Rainbow ForceField enabled", 2)
        end)
    else
        if Cosmetics.RainbowForceField.thread then
            task.cancel(Cosmetics.RainbowForceField.thread)
            Cosmetics.RainbowForceField.thread = nil
        end
        if Cosmetics.RainbowForceField.highlight then
            pcall(function() Cosmetics.RainbowForceField.highlight:Destroy() end)
            Cosmetics.RainbowForceField.highlight = nil
        end
        Shared.Notify("Cosmetics", "Rainbow ForceField disabled", 2)
    end
end

function Cosmetics.ToggleAngelWings(state)
    pcall(function()
        local char = Shared.LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
        if not root then return end

        if char:FindFirstChild("AngelWings") then
            char.AngelWings:Destroy()
        end

        if state then
            local model = Instance.new("Model", char)
            model.Name = "AngelWings"

            local leftWing = Instance.new("Part", model)
            leftWing.Size = Vector3.new(0.5, 3.0, 1.5)
            leftWing.Color = Color3.fromRGB(250, 250, 255)
            leftWing.Material = Enum.Material.Neon
            leftWing.CanCollide = false
            leftWing.CFrame = root.CFrame * CFrame.new(-1.5, 0.5, 0.6)

            local lw = Instance.new("Weld", leftWing)
            lw.Part0 = root
            lw.Part1 = leftWing
            lw.C0 = root.CFrame:ToObjectSpace(leftWing.CFrame)

            local rightWing = Instance.new("Part", model)
            rightWing.Size = Vector3.new(0.5, 3.0, 1.5)
            rightWing.Color = Color3.fromRGB(250, 250, 255)
            rightWing.Material = Enum.Material.Neon
            rightWing.CanCollide = false
            rightWing.CFrame = root.CFrame * CFrame.new(1.5, 0.5, 0.6)

            local rw = Instance.new("Weld", rightWing)
            rw.Part0 = root
            rw.Part1 = rightWing
            rw.C0 = root.CFrame:ToObjectSpace(rightWing.CFrame)
        end
    end)
end

function Cosmetics.ClearShaders()
    pcall(function()
        for _, e in pairs(Shared.Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Sky") or e:IsA("Atmosphere") then
                e:Destroy()
            end
        end
        Shared.Lighting.Brightness = 2
        Shared.Lighting.ClockTime = 14
        Shared.Lighting.GlobalShadows = true
        Shared.Lighting.FogEnd = 100000
    end)
end

function Cosmetics.ApplyShader(cfg)
    Cosmetics.ClearShaders()
    pcall(function()
        if cfg.CC then
            local cc = Instance.new("ColorCorrectionEffect", Shared.Lighting)
            if cfg.CC.Brightness then cc.Brightness = cfg.CC.Brightness end
            if cfg.CC.Contrast then cc.Contrast = cfg.CC.Contrast end
            if cfg.CC.Saturation then cc.Saturation = cfg.CC.Saturation end
            if cfg.CC.TintColor then cc.TintColor = cfg.CC.TintColor end
        end
        if cfg.Bloom then
            local bloom = Instance.new("BloomEffect", Shared.Lighting)
            if cfg.Bloom.Intensity then bloom.Intensity = cfg.Bloom.Intensity end
            if cfg.Bloom.Size then bloom.Size = cfg.Bloom.Size end
            if cfg.Bloom.Threshold then bloom.Threshold = cfg.Bloom.Threshold end
        end
        if cfg.SunRays then
            local sr = Instance.new("SunRaysEffect", Shared.Lighting)
            if cfg.SunRays.Intensity then sr.Intensity = cfg.SunRays.Intensity end
            if cfg.SunRays.Spread then sr.Spread = cfg.SunRays.Spread end
        end
        if cfg.Atmosphere then
            local at = Instance.new("Atmosphere", Shared.Lighting)
            if cfg.Atmosphere.Density then at.Density = cfg.Atmosphere.Density end
            if cfg.Atmosphere.Offset then at.Offset = cfg.Atmosphere.Offset end
            if cfg.Atmosphere.Color then at.Color = cfg.Atmosphere.Color end
            if cfg.Atmosphere.Decay then at.Decay = cfg.Atmosphere.Decay end
            if cfg.Atmosphere.Glare then at.Glare = cfg.Atmosphere.Glare end
            if cfg.Atmosphere.Haze then at.Haze = cfg.Atmosphere.Haze end
        end
        if cfg.Lighting then
            if cfg.Lighting.Brightness then Shared.Lighting.Brightness = cfg.Lighting.Brightness end
            if cfg.Lighting.ClockTime then Shared.Lighting.ClockTime = cfg.Lighting.ClockTime end
            if cfg.Lighting.GlobalShadows ~= nil then Shared.Lighting.GlobalShadows = cfg.Lighting.GlobalShadows end
            if cfg.Lighting.FogColor then Shared.Lighting.FogColor = cfg.Lighting.FogColor end
            if cfg.Lighting.FogEnd then Shared.Lighting.FogEnd = cfg.Lighting.FogEnd end
        end
    end)
end



function Cosmetics.ApplyWarmSunshine()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.25, Contrast = 0.1, Saturation = 0.3, TintColor = Color3.fromRGB(255, 245, 220) },
        SunRays = { Intensity = 0.35 },
        Lighting = { Brightness = 2.5, FogEnd = 2000, ClockTime = 12 }
    })
    Shared.Notify("Shaders", "Warm Sunshine applied!", 2)
end

function Cosmetics.ApplySakuraDream()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.2, Contrast = 0.05, Saturation = 0.2, TintColor = Color3.fromRGB(255, 225, 235) },
        SunRays = { Intensity = 0.25 },
        Lighting = { Brightness = 2.3, FogEnd = 1500, ClockTime = 8 }
    })
    Shared.Notify("Shaders", "Sakura Dream applied!", 2)
end

function Cosmetics.ApplyClearSky()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.15, Contrast = 0.1, Saturation = 0.15, TintColor = Color3.fromRGB(220, 235, 255) },
        SunRays = { Intensity = 0.3 },
        Lighting = { Brightness = 2.8, FogEnd = 5000, ClockTime = 11 }
    })
    Shared.Notify("Shaders", "Clear Sky applied!", 2)
end

function Cosmetics.ApplyMintFresh()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.2, Contrast = 0.08, Saturation = 0.1, TintColor = Color3.fromRGB(200, 240, 220) },
        SunRays = { Intensity = 0.2 },
        Lighting = { Brightness = 2.4, FogEnd = 2000, ClockTime = 10 }
    })
    Shared.Notify("Shaders", "Mint Fresh applied!", 2)
end

function Cosmetics.ApplyPeachSmooth()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.2, Contrast = 0.05, Saturation = 0.25, TintColor = Color3.fromRGB(255, 220, 200) },
        SunRays = { Intensity = 0.3 },
        Lighting = { Brightness = 2.5, FogEnd = 1800, ClockTime = 16 }
    })
    Shared.Notify("Shaders", "Peach Smooth applied!", 2)
end

function Cosmetics.ApplyOceanBreeze()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.15, Contrast = 0.1, Saturation = 0.1, TintColor = Color3.fromRGB(180, 215, 240) },
        Lighting = { Brightness = 2.2, FogEnd = 1200, ClockTime = 13 }
    })
    Shared.Notify("Shaders", "Ocean Breeze applied!", 2)
end

function Cosmetics.ApplyGoldenHour()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.2, Contrast = 0.1, Saturation = 0.3, TintColor = Color3.fromRGB(255, 235, 200) },
        SunRays = { Intensity = 0.4 },
        Lighting = { Brightness = 2.6, FogEnd = 2000, ClockTime = 17 }
    })
    Shared.Notify("Shaders", "Golden Hour applied!", 2)
end

function Cosmetics.ApplyFrostMorning()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.3, Contrast = 0.05, Saturation = -0.2, TintColor = Color3.fromRGB(220, 230, 255) },
        Lighting = { Brightness = 3, FogEnd = 1000, ClockTime = 7 }
    })
    Shared.Notify("Shaders", "Frost Morning applied!", 2)
end

function Cosmetics.ApplySoftSunset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.15, Contrast = 0.08, Saturation = 0.3, TintColor = Color3.fromRGB(255, 210, 190) },
        SunRays = { Intensity = 0.5 },
        Lighting = { Brightness = 2, FogEnd = 1500, ClockTime = 18.5 }
    })
    Shared.Notify("Shaders", "Soft Sunset applied!", 2)
end

function Cosmetics.ApplyCyberpunk()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.1, Contrast = 0.3, Saturation = 0.5, TintColor = Color3.fromRGB(0, 230, 255) },
        Bloom = { Intensity = 1.2, Size = 24, Threshold = 0.8 },
        Lighting = { Brightness = 1.5, ClockTime = 0 }
    })
    Shared.Notify("Shaders", "Cyberpunk applied!", 2)
end

function Cosmetics.ApplyNightVision()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.3, Contrast = 0.4, Saturation = -0.5, TintColor = Color3.fromRGB(50, 255, 50) },
        Bloom = { Intensity = 1.5, Size = 30, Threshold = 0.5 },
        Lighting = { Brightness = 3, ClockTime = 0 }
    })
    Shared.Notify("Shaders", "Night Vision applied!", 2)
end

function Cosmetics.ApplySynthwave()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.15, Contrast = 0.25, Saturation = 0.4, TintColor = Color3.fromRGB(255, 50, 200) },
        Bloom = { Intensity = 1.0, Size = 20, Threshold = 0.7 },
        Lighting = { Brightness = 1.8, ClockTime = 20 }
    })
    Shared.Notify("Shaders", "Synthwave applied!", 2)
end

function Cosmetics.ApplyMatrix()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.1, Contrast = 0.3, Saturation = -0.3, TintColor = Color3.fromRGB(20, 255, 100) },
        Lighting = { Brightness = 1.2, ClockTime = 0 }
    })
    Shared.Notify("Shaders", "Matrix applied!", 2)
end

function Cosmetics.ApplyPurpleVibe()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.2, Contrast = 0.2, Saturation = 0.3, TintColor = Color3.fromRGB(180, 100, 255) },
        Bloom = { Intensity = 0.8, Size = 16, Threshold = 0.8 },
        Lighting = { Brightness = 2, ClockTime = 22 }
    })
    Shared.Notify("Shaders", "Purple Vibe applied!", 2)
end
-- Extra Skyboxes & Preset Environments from extra scripts
function Cosmetics.ApplyBrightPreset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0, Contrast = 0, Saturation = 0.05, TintColor = Color3.fromRGB(255, 224, 219) },
        Bloom = { Intensity = 0.1, Size = 100, Threshold = 0 },
        SunRays = { Intensity = 0.05 },
        Lighting = { Brightness = 2, ClockTime = 10, FogEnd = 10000 }
    })
    Shared.Notify("Shaders", "Bright Environment applied!", 2)
end

function Cosmetics.ApplyDesertPreset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0, Contrast = 0, Saturation = 0.05, TintColor = Color3.fromRGB(255, 200, 150) },
        Lighting = { Brightness = 2.5, ClockTime = 7, FogColor = Color3.fromRGB(100, 55, 20), FogEnd = 1000 }
    })
    Shared.Notify("Shaders", "Desert Wasteland applied!", 2)
end

function Cosmetics.ApplyDreamyPreset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.1, Contrast = 0.1, Saturation = 0.3, TintColor = Color3.fromRGB(255, 180, 220) },
        Bloom = { Intensity = 0.8, Size = 30, Threshold = 0.4 },
        Lighting = { Brightness = 2.2, ClockTime = 18, FogColor = Color3.fromRGB(200, 150, 220), FogEnd = 1500 }
    })
    Shared.Notify("Shaders", "Dreamy Atmosphere applied!", 2)
end

function Cosmetics.ApplyRainyPreset()
    Cosmetics.ApplyShader({
        CC = { Brightness = -0.1, Contrast = 0.15, Saturation = -0.4, TintColor = Color3.fromRGB(160, 190, 210) },
        Lighting = { Brightness = 1.2, ClockTime = 14, FogColor = Color3.fromRGB(120, 140, 160), FogEnd = 800 }
    })
    Shared.Notify("Shaders", "Rainy Mood applied!", 2)
end

function Cosmetics.ApplySunsetPreset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0, Contrast = 0, Saturation = 0.05, TintColor = Color3.fromRGB(255, 224, 219) },
        SunRays = { Intensity = 0.05 },
        Lighting = { Brightness = 3.5, ClockTime = 6.7, FogColor = Color3.fromRGB(94, 76, 106), FogEnd = 1000 }
    })
    Shared.Notify("Shaders", "Sunset Glow applied!", 2)
end

-- ============================================================================
-- GEMOROI PRESET SHADERS v3.6 (Cyberpunk / Midnight / Dreamy / Rainy / Desert)
-- ============================================================================

function Cosmetics.ApplyCyberpunkCity()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.05, Contrast = 0.25, Saturation = 0.35, TintColor = Color3.fromRGB(120, 200, 255) },
        Bloom = { Intensity = 0.8, Size = 40, Threshold = 0.9 },
        SunRays = 0.15,
        L = { Brightness = 1.6, ClockTime = 0, FogEnd = 450, FogColor = Color3.fromRGB(10, 20, 40),
            Ambient = Color3.fromRGB(30, 60, 120), OutdoorAmbient = Color3.fromRGB(40, 80, 140) },
    })
    Shared.Notify("Shaders", "Cyberpunk City applied!", 2)
end

function Cosmetics.ApplyMidnightPurple()
    Cosmetics.ApplyShader({
        CC = { Brightness = -0.05, Contrast = 0.15, Saturation = 0.1, TintColor = Color3.fromRGB(160, 120, 255) },
        Bloom = { Intensity = 0.5, Size = 32, Threshold = 0.8 },
        SunRays = 0.05,
        L = { Brightness = 0.9, ClockTime = 0, FogEnd = 600, FogColor = Color3.fromRGB(40, 20, 70),
            Ambient = Color3.fromRGB(60, 40, 100), OutdoorAmbient = Color3.fromRGB(70, 50, 110) },
    })
    Shared.Notify("Shaders", "Midnight Purple applied!", 2)
end

function Cosmetics.ApplyDreamySunset()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.1, Contrast = 0.1, Saturation = 0.25, TintColor = Color3.fromRGB(255, 180, 140) },
        Bloom = { Intensity = 0.7, Size = 36, Threshold = 0.85 },
        SunRays = 0.4,
        L = { Brightness = 1.4, ClockTime = 17.6, FogEnd = 800, FogColor = Color3.fromRGB(255, 150, 100),
            Ambient = Color3.fromRGB(200, 140, 120), OutdoorAmbient = Color3.fromRGB(255, 170, 120) },
    })
    Shared.Notify("Shaders", "Dreamy Sunset applied!", 2)
end

function Cosmetics.ApplyRainyDay()
    Cosmetics.ApplyShader({
        CC = { Brightness = -0.1, Contrast = 0.05, Saturation = -0.15, TintColor = Color3.fromRGB(180, 200, 220) },
        Bloom = { Intensity = 0.3, Size = 24, Threshold = 0.9 },
        L = { Brightness = 1.0, ClockTime = 14, FogEnd = 250, FogStart = 20, FogColor = Color3.fromRGB(150, 165, 180),
            Ambient = Color3.fromRGB(120, 130, 145), OutdoorAmbient = Color3.fromRGB(130, 140, 155) },
    })
    pcall(function()
        local atmo = Instance.new("Atmosphere")
        atmo.Density = 0.45
        atmo.Color = Color3.fromRGB(180, 195, 210)
        atmo.Glare = 0
        atmo.Haze = 2.5
        atmo.Parent = Shared.Lighting
    end)
    Shared.Notify("Shaders", "Rainy Day applied!", 2)
end

function Cosmetics.ApplyDesertHeat()
    Cosmetics.ApplyShader({
        CC = { Brightness = 0.15, Contrast = 0.2, Saturation = 0.15, TintColor = Color3.fromRGB(255, 220, 160) },
        Bloom = { Intensity = 0.6, Size = 34, Threshold = 0.88 },
        SunRays = 0.5,
        L = { Brightness = 2.0, ClockTime = 13.5, FogEnd = 900, FogColor = Color3.fromRGB(230, 200, 150),
            Ambient = Color3.fromRGB(220, 190, 150), OutdoorAmbient = Color3.fromRGB(235, 205, 160) },
    })
    Shared.Notify("Shaders", "Desert Heat applied!", 2)
end

return Cosmetics