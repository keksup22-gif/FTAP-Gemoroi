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

local S = {
    Players = Players,
    RunService = RunService,
    ReplicatedStorage = ReplicatedStorage,
    UserInputService = UserInputService,
    Workspace = Workspace,
    CoreGui = CoreGui,
    TweenService = TweenService,
    TextService = game:GetService("TextService")
}

local RAGDOLL_LIMBS = {"Left Leg", "Right Leg", "Left Arm", "Right Arm"}
local AmethystFeatures = {
    Selected = {
        kickPlayer = nil,
        players = {},
        multiSelect = false,
        currentPlayer = nil,
        currentButton = nil
    },
    Teleport = {
        loop = {
            enabled = false,
            target = CFrame.new(3, -7, -2),
            loopThread = nil
        },
        houses = {
            {"Pink House", CFrame.new(-491, -7, -166)},
            {"Green House", CFrame.new(-535, -7, 93)},
            {"Purple House", CFrame.new(250, -6, 463)},
            {"China House", CFrame.new(554, 123, -72)},
            {"Blue House", CFrame.new(510, 83, -339)},
            {"Spawn", CFrame.new(3, -7, -2)}
        }
    },
    Speed = {
        value = 16,
        min = 16,
        max = 10000,
        enabled = false,
        originalWalkSpeed = nil,
        connection = nil
    },
    ThirdPerson = {
        enabled = false
    },
    PCLD = {
        Enabled = false,
        Boxes = {},
        NameTags = {},
        Connections = {}
    },
    PacketLag = {
        enabled = false,
        loopThread = nil,
        packetSize = 100,
        minSize = 100,
        maxSize = 1000000
    },
    KickNotify = {
        enabled = false,
        connection = nil,
        notifications = {},
        notificationQueue = {},
        processedKicks = {}
    },
    Gucci = {
        active = false,
        blobman = nil,
        connection = nil,
        remotes = {}
    },
    GucciTractor = {
        enabled = false,
        busy = false,
        currentTractor = nil,
        seatMonitorConn = nil,
        loopThread = nil
    },
    AntiLag = {
        enabled = false
    },
    RemoveAntiKick = {
        enabled = false,
        targetPlayer = nil,
        loopThread = nil
    },
    AntiGrab = {
        enabled = false,
        antiGrabEnabled = false
    },
    SafePos = {
        enabled = false,
        target = nil,
        loopThread = nil
    },
    AutoSitBlob = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil
    },
    AntiKickReset = {
        enabled = false,
        connection = nil
    },
    AntiStick = {
        enabled = false,
        loopThread = nil
    },
    AntiKickStick = {
        enabled = false,
        loopThread = nil,
        selectedItem = "NinjaShuriken",
        items = {
            "NinjaShuriken",
            "NinjaKunai",
            "ToolPencil",
            "ToolPickaxe",
            "ToolDiggingForkRusty",
            "ToolCleaver",
            "NinjaKatana"
        }
    },
    LoopKick = {
        enabled = false,
        loopThread = nil
    },
    PermanentPallet = {
        enabled = false,
        loopThread = nil,
        currentPallet = nil,
        isReady = false
    },
    RagdollAura = {
        enabled = false,
        loopThread = nil,
        ragdolledPlayers = {},
        isTeleportingPallet = false
    },
    RagdollLoopKick = {
        enabled = false,
        loopThread = nil,
        savedPos = nil,
        dragging = false,
        grabStart = 0
    },
    SelfGrab = {
        enabled = false,
        loopThread = nil,
        MyBlob = nil,
        OriginalMassless = nil,
        OriginalPosition = nil,
        WasGrabbedByEnemy = false,
        ProcessingGrab = false,
        ProcessingRelease = false,
        GrabCooldown = 0,
        RegrabActive = false,
        SpawningBlob = false
    },
    BlobKill = {
        enabled = false,
        selectedPlayers = {},
        loopThread = nil,
        barrierThread = nil,
        currentBlob = nil
    },
    BlobKickDual = {
        enabled = false,
        loopThread = nil,
        bp = nil,
        lastTargetChar = nil
    },
    Fly = {
        Enabled = false,
        Speed = 100,
        BV = nil,
        BG = nil,
        Connections = {}
    },
    ServerLag = {
        enabled = false,
        loopThread = nil
    },
    AntiInputLag = {
        enabled = false,
        loopThread = nil,
        currentItem = nil,
        selectedItem = "FoodHamburger",
        items = {
            "FoodHamburger",
            "InstrumentDrumBongos",
            "InstrumentBrassTrumpet",
            "InstrumentBrassBugle",
            "InstrumentVoiceMicrophone",
            "InstrumentWoodwindOcarina",
            "InstrumentGuitarUkulele",
            "InstrumentGuitarLyre",
            "InstrumentGuitarBanjo",
            "InstrumentGuitarAcoustic",
            "CupMugBrown",
            "CupMugWhite",
            "FoodBanana",
            "FoodBread",
            "FoodBroccoli",
            "FoodCakePink",
            "FoodCoconut",
            "FoodDippyEgg",
            "FoodDonut",
            "FoodFrenchFries",
            "FoodHotdog",
            "FoodMayonnaise",
            "FoodMeatStick",
            "FoodMushroomPoison",
            "FoodPizzaCheese",
            "FoodPizzaPepperoni",
            "FoodSodaCan",
            "PoopPile",
            "PoopPileSparkle"
        }
    },
    AntiRagdoll = {
        enabled = false,
        connections = {},
        ragdolledSit = false
    },
    KillAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        spawningBlob = false,
        killCooldown = {},
        targetPlayers = {},
        lastKillTime = 0
    },
    AntiBlob = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    WaterWalk = {
        enabled = false,
        waterParts = {},
        originalStates = {}
    },
    AntiBurn = {
        enabled = false,
        connection1 = nil,
        connection2 = nil,
        currentBarrier = nil
    },
    AntiVoid = {
        enabled = false,
        loopThread = nil,
        originalDestroyHeight = -100
    },
    AntiPaint = {
        enabled = false,
        connection = nil
    },
    AdvancedDuallock = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        targetPlayer = nil
    },
    LoopSnowball = {
        enabled = false,
        loopThread = nil,
        currentSnowball = nil,
        soundPart = nil,
        selectedPlayer = nil
    },
    DestroyKickAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        processedPlayers = {},
        spawnInterval = 0,
        isSpawning = false,
        lastSpawnTime = 0
    },
    DeleteLegs = {
        enabled = false,
        monitoringThread = nil,
        hipHeightAdjusted = false
    },
    AntiExplode = {
        enabled = false,
        connection = nil,
        bombEvent = nil
    },
    AutoGucci = {
        enabled = false,
        monitoringThread = nil,
        connection = nil,
        safePosition = nil,
        restoreFrames = 0
    },
    AntiBananaEat = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedBananas = {},
        processedFolders = {}
    },
    AntiAntiInput = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedItems = {},
        processedFolders = {}
    },
    AntiBarrier = {
        enabled = false,
        originalStates = {}
    },
    AntiInvisible = {
        enabled = false,
        loopThread = nil
    },
    SantaSleighGucci = {
        enabled = false
    },
    Noclip = {
        enabled = false,
        connection = nil,
        parts = {}
    },
    JumpKickAura = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    KickAuraFixed = {
        enabled = false,
        loopThread = nil,
        fixedPlayers = {}
    }
}

local KickNotify = AmethystFeatures.KickNotify
local TeleportCfg = AmethystFeatures.Teleport
local SpeedCfg = AmethystFeatures.Speed
local AntiGrabCfg = AmethystFeatures.AntiGrab
local SafePosCfg = AmethystFeatures.SafePos
local AutoSitCfg = AmethystFeatures.AutoSitBlob
local AntiKickResetCfg = AmethystFeatures.AntiKickReset
local AntiKickStickCfg = AmethystFeatures.AntiKickStick
local LoopKickCfg = AmethystFeatures.LoopKick
local PermanentPalletCfg = AmethystFeatures.PermanentPallet
local RagdollAuraCfg = AmethystFeatures.RagdollAura
local RagdollLoopKickCfg = AmethystFeatures.RagdollLoopKick
local SelfGrabCfg = AmethystFeatures.SelfGrab
local BlobKillCfg = AmethystFeatures.BlobKill
local BlobKickDualCfg = AmethystFeatures.BlobKickDual
local ServerLagCfg = AmethystFeatures.ServerLag
local AntiInputLagCfg = AmethystFeatures.AntiInputLag
local AntiRagdollCfg = AmethystFeatures.AntiRagdoll
local KillAuraCfg = AmethystFeatures.KillAura
local AntiBlobCfg = AmethystFeatures.AntiBlob
local AntiBurnCfg = AmethystFeatures.AntiBurn
local AntiVoidCfg = AmethystFeatures.AntiVoid
local AntiPaintCfg = AmethystFeatures.AntiPaint
local AdvancedDuallockCfg = AmethystFeatures.AdvancedDuallock
local LoopSnowballCfg = AmethystFeatures.LoopSnowball
local DestroyKickAuraCfg = AmethystFeatures.DestroyKickAura
local DeleteLegsCfg = AmethystFeatures.DeleteLegs
local AutoGucciCfg = AmethystFeatures.AutoGucci
local AntiAntiInputCfg = AmethystFeatures.AntiAntiInput
local AntiBarrierCfg = AmethystFeatures.AntiBarrier
local AntiInvisibleCfg = AmethystFeatures.AntiInvisible
local NoclipCfg = AmethystFeatures.Noclip
local JumpKickAuraCfg = AmethystFeatures.JumpKickAura
local KickAuraFixedCfg = AmethystFeatures.KickAuraFixed

local findFirstChild = function(parent, name)
    if not parent then
        return nil
    end
    return parent:FindFirstChild(name)
end

local function PlaySound(soundId, delayTime)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        task.delay(delayTime, function()
            if sound and sound.IsPlaying then
                sound:Stop()
                sound:Destroy()
            end
        end)
    end)
end

local function PlayEnableSound()
    PlaySound("8745692251", 3)
end

local function PlayKickSound()
    PlaySound("5463227301", 4.7)
end

local function GetCharHumanoid()
    local character = LocalPlayer and LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

local function ApplySpeed(dt)
    if not SpeedCfg.enabled then
        return
    end
    local character = LocalPlayer.Character
    if not character then
        return
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then
        return
    end
    humanoid.WalkSpeed = SpeedCfg.value
    local move = humanoid.MoveDirection
    if move.Magnitude > 0 then
        local delta = move.Unit * SpeedCfg.value * dt * 0.1
        root.CFrame = root.CFrame + Vector3.new(delta.X, 0, delta.Z)
    end
end

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
    Cosmetics = Window:AddTab({ Title = "Cosmetics & Shaders", Icon = "sparkles" }),
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
    LoopKillTarget = nil,
    FlingPower = 1,
    AnchorGrabEnabled = false
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

local function getClosestPlayer()
    local closest, closestDist = nil, Config.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local hitPart = getHitPart(player)
            local humanoid = getHumanoid(player)
            if hitPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if dist < closestDist and (not Config.WallCheck or isVisible(hitPart)) then
                        closest = hitPart
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local flingForces = {
    function(root) root.AssemblyLinearVelocity = Vector3.new(0, 80 * Config.FlingPower, 0) end,
    function(root) root.AssemblyLinearVelocity = Camera.CFrame.LookVector * (120 * Config.FlingPower) + Vector3.new(0, 40, 0) end,
    function(root) root.AssemblyAngularVelocity = Vector3.new(0, 80 * Config.FlingPower, 0); root.AssemblyLinearVelocity = Vector3.new(0, 150 * Config.FlingPower, 0) end,
    function(root) root.CFrame = root.CFrame + Vector3.new(0, 20 * Config.FlingPower, 0); root.AssemblyLinearVelocity = Vector3.new(0, 200 * Config.FlingPower, 0) end,
    function(root) root.AssemblyLinearVelocity = Vector3.new(math.random(-1,1), 1, math.random(-1,1)).Unit * (250 * Config.FlingPower) end,
    function(root) root.CFrame = CFrame.new(root.Position + Vector3.new(0, 500, 0)) end,
}

local function flingClosestTarget()
    local closest, dist = nil, 50
    local myRoot = getRoot(LocalPlayer)
    if not myRoot then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local root = getRoot(player)
            if root then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < dist then
                    closest = player
                    dist = d
                end
            end
        end
    end
    if closest then
        local root = getRoot(closest)
        if root then
            pcall(function()
                local setNetOwner = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("SetNetworkOwner")
                if setNetOwner then
                    setNetOwner:FireServer(root, root.CFrame)
                end
            end)
            task.wait(0.05)
            local power = math.clamp(math.floor(Config.FlingPower), 1, 6)
            pcall(function()
                flingForces[power](root)
            end)
            Fluent:Notify({ Title = "Fling", Content = "Flinged " .. closest.Name .. " (Power " .. power .. ")", Duration = 2 })
        end
    else
        Fluent:Notify({ Title = "Fling", Content = "No player nearby to fling!", Duration = 2 })
    end
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
local pcldHighlights = {}

local function updatePCLDESP()
    if not Config.PCLD_ESPEnabled then
        for _, hl in pairs(pcldHighlights) do
            if hl then hl:Destroy() end
        end
        pcldHighlights = {}
        return
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector") then
            if not pcldHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Name = "PCLD_ESP_Highlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                pcldHighlights[obj] = hl
            end
        end
    end
end

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

Tabs.Visuals:AddToggle("PCLDESPToggle", {
    Title = "PCLD ESP (Hidden Hitboxes)",
    Default = false,
    Callback = function(Value)
        Config.PCLD_ESPEnabled = Value
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

Tabs.Mass:AddSection("Fling Utilities (Zentrix)")

Tabs.Mass:AddSlider("FlingPowerSlider", {
    Title = "Fling Power Level (1-6)",
    Default = 1,
    Min = 1,
    Max = 6,
    Rounding = 0,
    Callback = function(Value)
        Config.FlingPower = Value
    end
})

Tabs.Mass:AddButton({
    Title = "Fling Closest Player (Key F)",
    Callback = function()
        flingClosestTarget()
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

Tabs.Protection:AddToggle("AnchorGrabToggle", {
    Title = "Anchor Grab (Freeze on Drop)",
    Default = false,
    Callback = function(Value)
        Config.AnchorGrabEnabled = Value
        Fluent:Notify({ Title = "Anchor Grab", Content = Value and "Enabled (Dropped items freeze in mid-air)" or "Disabled", Duration = 3 })
    end
})

Tabs.Protection:AddToggle("AntiFlingToggle", {
    Title = "Anti Fling",
    Default = false,
    Callback = function(Value)
        Config.AntiFlingEnabled = Value
    end
})

Tabs.Protection:AddToggle("AntiGucciToggle", {
    Title = "Anti-Gucci (Blobman Seat Protection)",
    Default = false,
    Callback = function(Value)
        Config.AntiGucciEnabled = Value
        if Value then
            task.spawn(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = getRoot(LocalPlayer)
                    local hum = getHumanoid(LocalPlayer)
                    if not char or not hrp or not hum then return end
                    
                    local spawnToy = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
                    if spawnToy then
                        spawnToy:InvokeServer("CreatureBlobman", hrp.CFrame * CFrame.new(0, 5, 0), Vector3.new(0, 0, 0))
                    end
                    task.wait(0.5)
                    local folder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                    local blob = folder and folder:FindFirstChild("CreatureBlobman")
                    local seat = blob and blob:FindFirstChild("VehicleSeat")
                    if seat and seat:IsA("VehicleSeat") then
                        seat:Sit(hum)
                        Fluent:Notify({ Title = "Anti-Gucci", Content = "Protected inside Blobman seat!", Duration = 3 })
                    end
                end)
            end)
        else
            pcall(function()
                local folder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                if folder and folder:FindFirstChild("CreatureBlobman") then
                    folder.CreatureBlobman:Destroy()
                end
            end)
        end
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

Tabs.Protection:AddToggle("TouchQueryToggle", {
    Title = "Ignore Hazards (CanTouch/CanQuery Off)",
    Default = false,
    Callback = function(Value)
        Config.TouchQuerySafe = Value
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanTouch = not Value
                    v.CanQuery = not Value
                end
            end
        end
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
    -- FOV Circle update & Silent Aim / Aimbot lock
    if fovCircle then
        if Config.SilentAimEnabled and Config.ShowFOV then
            local mousePos = UserInputService:GetMouseLocation()
            fovCircle.Position = mousePos
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end
    end

    if Config.SilentAimEnabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
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

    -- PCLD ESP update
    if Config.PCLD_ESPEnabled then
        updatePCLDESP()
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
                if hrp.AssemblyLinearVelocity.Magnitude > 120 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                if hum then
                    if hum.PlatformStand or hum.Sit then
                        hum.PlatformStand = false
                        hum.Sit = false
                        hum.AutoRotate = true
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
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

-- === COSMETICS & SHADERS TAB ===
Tabs.Cosmetics:AddSection("Wings & Accessories")

Tabs.Cosmetics:AddToggle("AngelWingsToggle", {
    Title = "Angel Wings",
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if not root then return end
                if char:FindFirstChild("AngelWings") then char.AngelWings:Destroy() end

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
            end)
        else
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("AngelWings") then
                    char.AngelWings:Destroy()
                end
            end)
        end
    end
})

Tabs.Cosmetics:AddSection("Atmosphere & Lighting Shaders")

local function ClearShaders()
    pcall(function()
        for _, e in pairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Sky") or e:IsA("Atmosphere") then
                e:Destroy()
            end
        end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
    end)
end

local function ApplyShader(cfg)
    ClearShaders()
    pcall(function()
        if cfg.CC then
            local cc = Instance.new("ColorCorrectionEffect", Lighting)
            for k, v in pairs(cfg.CC) do cc[k] = v end
        end
        if cfg.Blur then
            local bu = Instance.new("BlurEffect", Lighting)
            bu.Size = cfg.Blur
        end
        if cfg.SunRays then
            local sr = Instance.new("SunRaysEffect", Lighting)
            sr.Intensity = cfg.SunRays
        end
        if cfg.L then
            for k, v in pairs(cfg.L) do Lighting[k] = v end
        end
    end)
end

Tabs.Cosmetics:AddButton({
    Title = "Shader: Warm Sunshine",
    Callback = function()
        ApplyShader({CC={Brightness=0.25,Contrast=0.1,Saturation=0.3,TintColor=Color3.fromRGB(255,245,220)},SunRays=0.35,L={Brightness=2.5,FogEnd=2000,Ambient=Color3.fromRGB(255,240,200),OutdoorAmbient=Color3.fromRGB(255,230,180),ClockTime=12}})
        Fluent:Notify({ Title = "Shaders", Content = "Warm Sunshine applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Sakura Dream",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.05,Saturation=0.2,TintColor=Color3.fromRGB(255,225,235)},SunRays=0.25,L={Brightness=2.3,FogEnd=1500,Ambient=Color3.fromRGB(255,215,230),OutdoorAmbient=Color3.fromRGB(255,200,220),ClockTime=8}})
        Fluent:Notify({ Title = "Shaders", Content = "Sakura Dream applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Clear Sky",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.1,Saturation=0.15,TintColor=Color3.fromRGB(220,235,255)},SunRays=0.3,L={Brightness=2.8,FogEnd=5000,Ambient=Color3.fromRGB(200,220,250),OutdoorAmbient=Color3.fromRGB(180,200,240),ClockTime=11}})
        Fluent:Notify({ Title = "Shaders", Content = "Clear Sky applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Mint Fresh",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.08,Saturation=0.1,TintColor=Color3.fromRGB(200,240,220)},SunRays=0.2,L={Brightness=2.4,FogEnd=2000,Ambient=Color3.fromRGB(190,230,210),OutdoorAmbient=Color3.fromRGB(170,210,190),ClockTime=10}})
        Fluent:Notify({ Title = "Shaders", Content = "Mint Fresh applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Peach Smooth",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.05,Saturation=0.25,TintColor=Color3.fromRGB(255,220,200)},SunRays=0.3,L={Brightness=2.5,FogEnd=1800,Ambient=Color3.fromRGB(255,210,190),OutdoorAmbient=Color3.fromRGB(255,195,175),ClockTime=16}})
        Fluent:Notify({ Title = "Shaders", Content = "Peach Smooth applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Ocean Breeze",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.1,Saturation=0.1,TintColor=Color3.fromRGB(180,215,240)},Blur=0.3,L={Brightness=2.2,FogEnd=1200,Ambient=Color3.fromRGB(170,210,240),OutdoorAmbient=Color3.fromRGB(150,190,230),ClockTime=13}})
        Fluent:Notify({ Title = "Shaders", Content = "Ocean Breeze applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Golden Hour",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.1,Saturation=0.3,TintColor=Color3.fromRGB(255,235,200)},SunRays=0.4,L={Brightness=2.6,FogEnd=2000,Ambient=Color3.fromRGB(255,225,180),OutdoorAmbient=Color3.fromRGB(255,210,160),ClockTime=17}})
        Fluent:Notify({ Title = "Shaders", Content = "Golden Hour applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Frost Morning",
    Callback = function()
        ApplyShader({CC={Brightness=0.3,Contrast=0.05,Saturation=-0.2,TintColor=Color3.fromRGB(220,230,255)},Blur=0.5,L={Brightness=3,FogEnd=1000,Ambient=Color3.fromRGB(220,225,250),OutdoorAmbient=Color3.fromRGB(200,210,240),ClockTime=7}})
        Fluent:Notify({ Title = "Shaders", Content = "Frost Morning applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Soft Sunset",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.08,Saturation=0.3,TintColor=Color3.fromRGB(255,210,190)},SunRays=0.5,L={Brightness=2,FogEnd=1500,Ambient=Color3.fromRGB(255,180,140),OutdoorAmbient=Color3.fromRGB(255,160,120),ClockTime=18.5}})
        Fluent:Notify({ Title = "Shaders", Content = "Soft Sunset applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Reset / Default",
    Callback = function()
        ClearShaders()
        Fluent:Notify({ Title = "Shaders", Content = "Reset to default!", Duration = 2 })
    end
})

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F then
            flingClosestTarget()
        end
    end
end)

-- Anchor Grab background task (Freeze on Drop)
local anchoredObjects = {}
task.spawn(function()
    while true do
        pcall(function()
            if Config.AnchorGrabEnabled then
                for _, toy in ipairs(Workspace:GetDescendants()) do
                    if toy:IsA("Model") and toy:FindFirstChild("HoldPart") then
                        local holdPart = toy.HoldPart
                        local owner = holdPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == "" and not anchoredObjects[toy] then
                            local root = getRoot(LocalPlayer)
                            if root and (holdPart.Position - root.Position).Magnitude < 15 then
                                anchoredObjects[toy] = true
                                holdPart.Anchored = true
                                holdPart.AssemblyLinearVelocity = Vector3.zero
                                holdPart.AssemblyAngularVelocity = Vector3.zero
                                local bp = Instance.new("BodyPosition", holdPart)
                                bp.Position = holdPart.Position
                                bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                                bp.P = 10000
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
    Content = "Fully Operational Core loaded successfully!",
    Duration = 5
})
