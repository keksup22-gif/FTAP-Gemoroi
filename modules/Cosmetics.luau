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

return Cosmetics