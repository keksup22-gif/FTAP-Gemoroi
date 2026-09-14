local Shared = require(script.Parent.Shared)
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



return Cosmetics