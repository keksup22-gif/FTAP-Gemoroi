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

local function Notify(title, content, duration)
    pcall(function()
        Fluent:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3
        })
    end)
end
local AmethystFeatures = {
    Features = {
        PacketLag = AmethystFeatures and AmethystFeatures.PacketLag or {
            enabled = false,
            loopThread = nil,
            packetSize = 100,
            minSize = 100,
            maxSize = 1000000
        }
    },
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

local function EnableSpeed()
    if SpeedCfg.enabled then
        return
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        SpeedCfg.originalWalkSpeed = humanoid.WalkSpeed
    end
    SpeedCfg.enabled = true
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    SpeedCfg.connection = S.RunService.Stepped:Connect(function(_, dt)
        ApplySpeed(dt)
    end)
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
    end
    SpeedCfg.charConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if SpeedCfg.enabled then
            EnableSpeed()
        end
    end)
end

local function DisableSpeed()
    SpeedCfg.enabled = false
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
        SpeedCfg.charConnection = nil
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        humanoid.WalkSpeed = SpeedCfg.originalWalkSpeed
    end
end

local function ApplyHighlight(model)
    if not model or not model.Parent then
        return
    end
    local existing = model:FindFirstChild("Amethyst_FullHighlight")
    if existing then
        existing:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Amethyst_FullHighlight"
    highlight.FillColor = Color3.fromRGB(170, 100, 255)
    highlight.OutlineColor = Color3.fromRGB(140, 90, 220)
    highlight.OutlineTransparency = .1
    highlight.FillTransparency = .2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = model
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = .95
            if part:FindFirstChildOfClass("Texture") then
                part.Material = Enum.Material.ForceField
            end
        end
    end
    return highlight
end

local function GetStickRemotes()
    local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    local stickyEvent = S.ReplicatedStorage.PlayerEvents:WaitForChild("StickyPartEvent")
    return spawnToy, destroyToy, setOwner, stickyEvent
end

local function PlayerInPlot(playerName)
    local folder = S.Workspace.PlotItems.PlayersInPlots
    if not folder:FindFirstChild(playerName) then
        return false
    end
    for _, plot in pairs(S.Workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local owners = sign:FindFirstChild("ThisPlotsOwners")
            if owners then
                for _, owner in pairs(sign:GetChildren()) do
                    if owner.Name == "Value" and owner.Value == playerName then
                        return true, S.Workspace.PlotItems:FindFirstChild(plot.Name)
                    end
                end
            end
        end
    end
    return false
end

local function GetRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    local newChar = LocalPlayer.CharacterAdded:Wait()
    return newChar:WaitForChild("HumanoidRootPart")
end

local function SpawnSelectedItem()
    local item = AntiKickStickCfg.selectedItem
    while not LocalPlayer.CanSpawnToy.Value do
        if not AntiKickStickCfg.enabled or tick() - tick() > 5 then
            return nil
        end
        task.wait()
    end
    local root = GetRoot()
    if root then
        local cframe = root.CFrame * CFrame.new(0, 12, 20)
        task.spawn(function()
            local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
            spawnToy:InvokeServer(item, cframe, Vector3.new(0, 0, 0))
        end)
    end
    local inPlot, plotFolder = PlayerInPlot(LocalPlayer.Name)
    local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if inPlot then
        return plotFolder:WaitForChild(item, 2)
    end
    return folder:WaitForChild(item, 2) or (S.Workspace.PlotItems.PlayersInPlots:FindFirstChild(LocalPlayer.Name) and folder and folder:WaitForChild(item, 2)) or nil
end

local function DestroyAllItems(player)
    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    if not folder then
        return
    end
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    for _, toy in pairs(folder:GetChildren()) do
        if toy.Name == AntiKickStickCfg.selectedItem then
            destroyToy:FireServer(toy)
        end
    end
end

local function GiveNetworkOwner(model, ownerName)
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    if not GetRoot() then
        return
    end
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= ownerName then
            setOwner:FireServer(soundPart, soundPart.CFrame)
        end
    end
end

local function MakeAntiKick(model, player)
    local lp = player.Character
    if not lp or not lp:FindFirstChild("HumanoidRootPart") then
        return
    end
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    local root = lp.HumanoidRootPart
    local firePart = root:FindFirstChild("FirePlayerPart")
    if not firePart then
        firePart = Instance.new("Part")
        firePart.Name = "FirePlayerPart"
        firePart.Size = Vector3.new(1, 1, 1)
        firePart.Transparency = 1
        firePart.CanCollide = false
        firePart.CanQuery = false
        firePart.Anchored = true
        firePart.Parent = root
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = firePart
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = firePart
    end
    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
    local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= player.Name then
            pcall(function()
                setOwner:FireServer(soundPart, soundPart.CFrame)
            end)
        end
    end
    local playerEvents = S.ReplicatedStorage:WaitForChild("PlayerEvents")
    local stickyEvent = playerEvents:WaitForChild("StickyPartEvent")
    pcall(function()
        stickyEvent:FireServer(model.StickyPart, firePart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
    end)
    local sticky = model:FindFirstChild("StickyPart")
    if sticky then
        sticky.Transparency = 1
        sticky.CanCollide = false
        sticky.CanQuery = false
    end
    local soundPart = model:FindFirstChild("SoundPart")
    if soundPart then
        soundPart.Transparency = 1
        soundPart.CanCollide = false
        soundPart.CanQuery = false
    end
    ApplyHighlight(model)
    if not model:FindFirstChild("Amethyst_Atmosphere") then
        local atmosphere = Instance.new("Atmosphere", model)
        atmosphere.Name = "Amethyst_Atmosphere"
        atmosphere.Color = Color3.fromRGB(170, 100, 255)
        atmosphere.Decay = Color3.fromRGB(50, 30, 80)
        atmosphere.Glare = .2
        atmosphere.Haze = .1
        atmosphere.Density = .3
    end
    if not model:FindFirstChild("Amethyst_PointLight") then
        local light = Instance.new("PointLight", model)
        light.Name = "Amethyst_PointLight"
        light.Color = Color3.fromRGB(170, 100, 255)
        light.Range = 15
        light.Brightness = 0.5
        light.Shadows = true
    end
    if model.PrimaryPart then
        model:SetPrimaryPartCFrame(root.CFrame)
    end
    model.Name = "AntiKick"
    task.delay(.1, function()
        if model and model.Parent then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "StickyPart" and part.Name ~= "SoundPart" then
                    part.Transparency = 0.5
                end
            end
        end
    end)
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
    Defense = Window:AddTab({ Title = "Defense", Icon = "shield" }),
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

-- Amethyst Premium background defense & notification tasks
task.spawn(function()
    print("[AMETHYST] Ожидание загрузки игры...")
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    if not game.Players.LocalPlayer then
        task.wait(.1)
    end
    local lp = game.Players.LocalPlayer
    if lp then
        if not lp.Character then
            lp.CharacterAdded:Wait()
        end
        task.wait(2)
        print("[AMETHYST] ===== АКТИВАЦИЯ ВСЕХ ЗАЩИТНЫХ ФУНКЦИЙ =====")

        pcall(function()
            local ui = Instance.new("ScreenGui")
            ui.Name = "KickNotifyUI"
            ui.Parent = S.CoreGui

            local notifications = {}
            local notificationTimes = {}
            local retentionTime = 30

            local function canNotify(key)
                if not notificationTimes[key] then return true end
                if tick() - notificationTimes[key] > retentionTime then
                    notificationTimes[key] = nil
                    return true
                end
                return false
            end

            local function cleanupNotifications()
                local dead = {}
                for i, v in ipairs(notifications) do
                    if not v or not v.Parent then table.insert(dead, i) end
                end
                for i = #dead, 1, -1 do table.remove(notifications, dead[i]) end
            end

            local function showKickNotify(ownerName, displayName)
                if not canNotify(ownerName) then return end
                notificationTimes[ownerName] = tick()
                local frame = Instance.new("Frame")
                frame.Name = "KickNotification_" .. ownerName .. "_" .. tick()
                frame.Size = UDim2.new(0, 300, 0, 80)
                frame.Position = UDim2.new(1, -320, 0, 80)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                frame.BackgroundTransparency = .1
                frame.BorderSizePixel = 0
                frame.Parent = ui
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(180, 180, 180)
                stroke.Thickness = 2
                stroke.Transparency = .3

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, -20, 0, 20)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "KICK DETECTED"
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 16
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Parent = frame

                local victim = Instance.new("TextLabel")
                victim.Size = UDim2.new(1, -20, 0, 24)
                victim.Position = UDim2.new(0, 10, 0, 30)
                victim.BackgroundTransparency = 1
                victim.Text = displayName .. " (" .. ownerName .. ")"
                victim.TextColor3 = Color3.fromRGB(255, 255, 255)
                victim.Font = Enum.Font.GothamSemibold
                victim.TextSize = 14
                victim.TextXAlignment = Enum.TextXAlignment.Left
                victim.Parent = frame

                table.insert(notifications, frame)
                PlayKickSound()

                local tween = game:GetService("TweenService")
                task.delay(4.7, function()
                    if frame and frame.Parent then
                        tween:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
                        task.wait(0.5)
                        frame:Destroy()
                    end
                end)
            end

            S.Workspace.ChildAdded:Connect(function(child)
                if child.Name == "BlackHoleKick" or child.Name == "BlackHole" then
                    child.Name = "BlackHole_Detected_" .. tick()
                    local snapshot = {}
                    for _, p in pairs(S.Players:GetPlayers()) do
                        if p ~= LocalPlayer then snapshot[p.Name] = p.DisplayName end
                    end
                    task.wait(3.25)
                    local present = {}
                    for _, p in pairs(S.Players:GetPlayers()) do present[p.Name] = true end
                    local left = {}
                    for name, display in pairs(snapshot) do
                        if not present[name] then table.insert(left, {name = name, display = display}) end
                    end
                    if #left > 0 then
                        for _, info in ipairs(left) do
                            cleanupNotifications()
                            showKickNotify(info.name, info.display)
                            task.wait(.1)
                        end
                    end
                end
            end)
        end)
    end
end)

-- === PLAYER TAB (Amethyst Integration) ===
Tabs.Player:AddSection("Player")

Tabs.Player:AddToggle("LoopTPToggle", {
    Title = "Loop Teleport",
    Default = false,
    Callback = function(state)
        if state then
            TeleportCfg.loop.enabled = true
            TeleportCfg.loop.loopThread = task.spawn(function()
                while TeleportCfg.loop.enabled do
                    if LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and TeleportCfg.loop.target then
                            root.CFrame = TeleportCfg.loop.target
                        end
                        task.wait()
                    end
                end
            end)
            Fluent:Notify({ Title = "Loop TP", Content = "Enabled - Looping to selected location", Duration = 3 })
            PlayEnableSound()
        else
            TeleportCfg.loop.enabled = false
            if TeleportCfg.loop.loopThread then
                task.cancel(TeleportCfg.loop.loopThread)
                TeleportCfg.loop.loopThread = nil
            end
            Fluent:Notify({ Title = "Loop TP", Content = "Disabled", Duration = 2 })
        end
    end
})

local houseNames = {}
for _, house in ipairs(TeleportCfg.houses) do
    table.insert(houseNames, house[1])
end

Tabs.Player:AddDropdown("TeleportLocationDropdown", {
    Title = "Teleport Location",
    Values = houseNames,
    Default = "Spawn",
    Callback = function(selected)
        for _, house in ipairs(TeleportCfg.houses) do
            if house[1] == selected then
                TeleportCfg.loop.target = house[2]
                break
            end
        end
    end
})

Tabs.Player:AddButton({
    Title = "Teleport Once",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and TeleportCfg.loop.target then
                root.CFrame = TeleportCfg.loop.target
                Fluent:Notify({ Title = "Teleport", Content = "Teleported to selected location", Duration = 2 })
                PlayEnableSound()
            end
        end
    end
})

Tabs.Player:AddSection("Speed player")

Tabs.Player:AddSlider("SpeedControlSlider", {
    Title = "Speed Control",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        SpeedCfg.value = value
        if SpeedCfg.enabled then
            local humanoid = GetCharHumanoid()
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

Tabs.Player:AddToggle("EnableSpeedToggle", {
    Title = "Enable Speed",
    Default = false,
    Callback = function(state)
        if state then
            EnableSpeed()
            Fluent:Notify({ Title = "Speed", Content = "Enabled - WalkSpeed: " .. SpeedCfg.value, Duration = 2 })
            PlayEnableSound()
        else
            DisableSpeed()
            Fluent:Notify({ Title = "Speed", Content = "Disabled", Duration = 2 })
        end
    end
})


-- === DEFENSE TAB (Amethyst Integration) ===
Tabs.Defense:AddSection("Anti-Function")

Tabs.Defense:AddToggle("AntiGrabAmethystToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(state)
        if state then
            AntiGrabCfg.enabled = true
            AntiGrabCfg.antiGrabEnabled = true
            local antiGrab = { remotes = {}, parts = {}, conns = {} }
            local function getRemote(name)
                if antiGrab.remotes[name] then return antiGrab.remotes[name] end
                for _, desc in ipairs(S.ReplicatedStorage:GetDescendants()) do
                    if desc.Name == name and desc:IsA("RemoteEvent") then
                        antiGrab.remotes[name] = desc
                        return desc
                    end
                end
            end
            local function OnHeartbeat()
                if not antiGrab.parts.IsHeld or not antiGrab.parts.IsHeld.Value then return end
                if not antiGrab.parts.Root or not antiGrab.parts.Humanoid then return end
                antiGrab.parts.Root.Anchored = true
                S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(antiGrab.parts.Root, antiGrab.parts.Root.CFrame)
                antiGrab.parts.Root.Massless = true
                antiGrab.parts.Root.CanCollide = false
                antiGrab.parts.Root.CanQuery = false
                antiGrab.parts.Root.AssemblyLinearVelocity = Vector3.zero
                antiGrab.parts.Root.AssemblyAngularVelocity = Vector3.zero
                local struggle = getRemote("Struggle")
                local ragdoll = getRemote("RagdollRemote")
                if struggle then struggle:FireServer() end
                if ragdoll then ragdoll:FireServer(antiGrab.parts.Root, 0) end
                if antiGrab.parts.originalGrabPosition then
                    antiGrab.parts.Root.CFrame = antiGrab.parts.originalGrabPosition
                end
                antiGrab.parts.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                antiGrab.parts.Humanoid.Sit = false
                antiGrab.parts.Humanoid.PlatformStand = false
            end
            local function OnHeldChanged()
                if not antiGrab.parts.IsHeld then return end
                if antiGrab.parts.IsHeld.Value then
                    antiGrab.parts.grabStartTime = os.clock()
                    if antiGrab.parts.Root then
                        antiGrab.parts.originalGrabPosition = antiGrab.parts.Root.CFrame
                        antiGrab.parts.Root.Anchored = true
                    end
                    if not antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat = S.RunService.Heartbeat:Connect(OnHeartbeat)
                    end
                else
                    if antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat:Disconnect()
                        antiGrab.conns.heartbeat = nil
                    end
                    if antiGrab.parts.Root then
                        antiGrab.parts.Root.Anchored = false
                        antiGrab.parts.Root.Massless = false
                        antiGrab.parts.Root.CanCollide = true
                        antiGrab.parts.Root.CanQuery = true
                    end
                end
            end
            local function OnCharacterAdded(character)
                if not character then return end
                antiGrab.parts.Character = character
                antiGrab.parts.Root = character:WaitForChild("HumanoidRootPart")
                antiGrab.parts.Humanoid = character:WaitForChild("Humanoid")
            end
            antiGrab.parts.IsHeld = LocalPlayer:WaitForChild("IsHeld")
            if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end
            antiGrab.conns.charAdded = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
            antiGrab.conns.heldChanged = antiGrab.parts.IsHeld:GetPropertyChangedSignal("Value"):Connect(OnHeldChanged)
            OnHeldChanged()
            Fluent:Notify({ Title = "Anti Grab", Content = "Enabled - Grab protection active", Duration = 2 })
            PlayEnableSound()
        else
            AntiGrabCfg.enabled = false
            AntiGrabCfg.antiGrabEnabled = false
            Fluent:Notify({ Title = "Anti Grab", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddDropdown("AntiKickStickItemDropdown", {
    Title = "Anti Kick (Stick) Item",
    Values = AntiKickStickCfg.items,
    Default = "NinjaShuriken",
    Callback = function(selected)
        AntiKickStickCfg.selectedItem = selected
        Fluent:Notify({ Title = "Anti Kick", Content = "Selected: " .. selected, Duration = 2 })
    end
})

Tabs.Defense:AddToggle("AntiKickStickToggle", {
    Title = "Anti Kick (Stick)",
    Default = false,
    Callback = function(state)
        if state then
            AntiKickStickCfg.enabled = true
            Fluent:Notify({ Title = "Anti Kick", Content = "Enabled with " .. AntiKickStickCfg.selectedItem, Duration = 2 })
            PlayEnableSound()
            AntiKickStickCfg.loopThread = task.spawn(StartAntiKickStickLoop)
        else
            AntiKickStickCfg.enabled = false
            if AntiKickStickCfg.loopThread then
                task.cancel(AntiKickStickCfg.loopThread)
                AntiKickStickCfg.loopThread = nil
            end
            Fluent:Notify({ Title = "Anti Kick", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddSection("Other Defense")

Tabs.Defense:AddToggle("SafePosToggle", {
    Title = "Safe Pos LP",
    Default = false,
    Callback = function(state)
        if state then
            SafePosCfg.enabled = true
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then SafePosCfg.target = root.CFrame end
            end
            if not SafePosCfg.target then
                Fluent:Notify({ Title = "Safe Pos", Content = "Error: Could not save position!", Duration = 2 })
                return
            end
            SafePosCfg.loopThread = task.spawn(function()
                while SafePosCfg.enabled do
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then root.CFrame = SafePosCfg.target end
                    end
                    task.wait()
                end
            end)
            Fluent:Notify({ Title = "Safe Pos", Content = "Enabled - Position saved", Duration = 2 })
            PlayEnableSound()
        else
            SafePosCfg.enabled = false
            if SafePosCfg.loopThread then
                task.cancel(SafePosCfg.loopThread)
                SafePosCfg.loopThread = nil
            end
            Fluent:Notify({ Title = "Safe Pos", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddToggle("NoclipObjPlayersToggle", {
    Title = "Noclip Obj players",
    Default = false,
    Callback = function(state)
        if state then
            NoclipCfg.enabled = true
            NoclipCfg.parts = {}
            NoclipCfg.connections = {}

            local function IsInputLagItem(name)
                for _, item in ipairs(AntiInputLagCfg.items) do
                    if item == name then
                        return true
                    end
                end
                return false
            end

            local function SetNoclip(model)
                if not model or not model:IsA("Model") then
                    return
                end
                if IsInputLagItem(model.Name) then
                    return
                end
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end

            local function OnCharacter(character)
                if not character then
                    return
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    NoclipCfg.parts[player] = {}
                    if player.Character then
                        OnCharacter(player.Character)
                    end
                    player.CharacterAdded:Connect(function(character)
                        if NoclipCfg.enabled then
                            OnCharacter(character)
                        end
                    end)
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            SetNoclip(toy)
                        end
                    end
                end
            end

            NoclipCfg.connections.descendantAdded = S.Workspace.DescendantAdded:Connect(function(desc)
                if not NoclipCfg.enabled then
                    return
                end
                if desc:IsA("Model") and not IsInputLagItem(desc.Name) then
                    local parent = desc.Parent
                    local isOwnFolder = false
                    while parent do
                        if parent.Name == LocalPlayer.Name .. "SpawnedInToys" then
                            isOwnFolder = true
                            break
                        end
                        parent = parent.Parent
                    end
                    if not isOwnFolder then
                        task.wait(.1)
                        SetNoclip(desc)
                    end
                end
            end)

            NoclipCfg.connections.playerAdded = S.Players.PlayerAdded:Connect(function(player)
                if not NoclipCfg.enabled or player == LocalPlayer then
                    return
                end
                NoclipCfg.parts[player] = {}
                player.CharacterAdded:Connect(function(character)
                    if NoclipCfg.enabled then
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)

            NoclipCfg.connections.periodicCheck = task.spawn(function()
                while NoclipCfg.enabled do
                    for _, player in ipairs(S.Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.CanCollide then
                                    part.CanCollide = false
                                end
                            end
                            local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                            if folder then
                                for _, toy in ipairs(folder:GetChildren()) do
                                    if toy:IsA("Model") and not IsInputLagItem(toy.Name) then
                                        for _, part in ipairs(toy:GetDescendants()) do
                                            if part:IsA("BasePart") and part.CanCollide then
                                                part.CanCollide = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
            Fluent:Notify({ Title = "Noclip", Content = "Enabled - Noclip through players/items", Duration = 2 })
            PlayEnableSound()
        else
            NoclipCfg.enabled = false
            for _, conn in pairs(NoclipCfg.connections) do
                if conn then
                    if typeof(conn) == "RBXScriptConnection" then
                        conn:Disconnect()
                    else
                        task.cancel(conn)
                    end
                end
            end
            NoclipCfg.connections = {}
            NoclipCfg.parts = {}
            Fluent:Notify({ Title = "Noclip", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddButton({
    Title = "Delete Legs",
    Callback = function()
        local lp = LocalPlayer
        local char = lp.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
        if not char or not ragdollRemote then
            return
        end
        if not (char:FindFirstChild("Left Leg")) then
            Fluent:Notify({ Title = "Delete Legs", Content = "Error: Missing body parts", Duration = 3 })
            return
        end
        local torso = char:FindFirstChild("Torso")
        S.Workspace.FallenPartsDestroyHeight = -100
        Fluent:Notify({ Title = "Delete Legs", Content = "Deleting legs...", Duration = 3 })
        PlayEnableSound()
        ragdollRemote:FireServer(root, 2)
        task.wait(0.5)
        char["Right Leg"].CFrame = CFrame.new(0, -10000, 0)
        char["Left Leg"].CFrame = CFrame.new(0, -10000, 0)
        task.wait(.3)
        if torso then
            torso.CFrame = CFrame.new(0, -9970, 0)
        end
        task.wait(0.5)
        if torso then
            local grab = torso.CFrame
            torso.CFrame = grab
        end
        task.wait(0.5)
        S.Workspace.FallenPartsDestroyHeight = S.Workspace.FallenPartsDestroyHeight
        if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
            Fluent:Notify({ Title = "Delete Legs", Content = "Legs successfully deleted!", Duration = 5 })
            PlayEnableSound()
            task.spawn(function()
                while char.Parent do
                    if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            local controls = lp.PlayerGui:FindFirstChild("ControlsGui")
                            local pcFrame = controls and controls:FindFirstChild("PCFrame")
                            local stand = pcFrame and pcFrame:FindFirstChild("Stand")
                            if stand then
                                if stand.Visible == false then
                                    humanoid.HipHeight = 2
                                else
                                    humanoid.HipHeight = 0
                                end
                            end
                        end
                        task.wait()
                    end
                end
            end)
        else
            Fluent:Notify({ Title = "Delete Legs", Content = "Warning: Legs not fully deleted", Duration = 3 })
        end
    end
})


pcall(function()
    print("[AMETHYST] Активация Permanent Pallet...")
    PermanentPalletCfg.enabled = true
    local lp = LocalPlayer
    local spawnToyRemote = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToyRemote = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwnerRemote = S.ReplicatedStorage.GrabEvents.SetNetworkOwner


    local function FindOwnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if not folder then
            return nil
        end
        for _, toy in ipairs(folder:GetChildren()) do
            if toy.Name == "PalletLightBrown" then
                local soundPart = toy:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == lp.Name then
                        return toy
                    else
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                        task.wait(.1)
                        owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return toy
                        end
                    end
                end
            end
        end
        return nil
    end


    local function SpawnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if folder then
            for _, toy in ipairs(folder:GetChildren()) do
                if toy.Name == "PalletLightBrown" then
                    local soundPart = toy:FindFirstChild("SoundPart")
                    if not soundPart or not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= lp.Name then
                        destroyToyRemote:FireServer(toy)
                        task.wait(.1)
                    end
                end
            end
        end
        local canSpawn = lp:FindFirstChild("CanSpawnToy")
        if canSpawn then
            local start = tick()
            while canSpawn.Value do
                if tick() - start < 5 then
                    task.wait(.1)
                    if not PermanentPalletCfg.enabled then
                        return nil
                    end
                end
                local char = lp.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return nil
                    end
                end
                return nil
            end
            local char = lp.Character
            if not char then
                return nil
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then
                return nil
            end
            spawnToyRemote:InvokeServer("PalletLightBrown", root.CFrame * CFrame.new(0, 30, 20), Vector3.new(0, -90, 0))
            for _ = 1, 20 do
                if not PermanentPalletCfg.enabled then
                    return nil
                end
                local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                local pallet = folder and folder:FindFirstChild("PalletLightBrown")
                if pallet then
                    local soundPart = pallet:FindFirstChild("SoundPart")
                    if soundPart then
                        setOwnerRemote:FireServer(soundPart, soundPart.CFrame)
                        task.wait(.1)
                        local owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return pallet
                        else
                            setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                            task.wait(.1)
                            owner = soundPart:FindFirstChild("PartOwner")
                            if owner and owner.Value == lp.Name then
                                return pallet
                            else
                                task.wait(.1)
                            end
                        end
                    end
                end
                task.wait(.1)
            end
            return nil
        end
    end

    local function HidePallet(pallet)
        if not pallet then
            return false
        end
        local soundPart = pallet:FindFirstChild("SoundPart")
        if not soundPart then
            return false
        end
        for _, part in ipairs(pallet:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CanQuery = false
                part.Massless = true
            end
        end
        soundPart.CFrame = CFrame.new(0, 1000000000, 0)
        return true
    end


    PermanentPalletCfg.loopThread = task.spawn(function()
        while PermanentPalletCfg.enabled do
            local pallet = FindOwnPallet()
            if not pallet then
                pallet = SpawnPallet()
            end
            if pallet then
                PermanentPalletCfg.currentPallet = pallet
                PermanentPalletCfg.isReady = true
                HidePallet(pallet)
                local soundPart = pallet:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                    end
                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                end
            else
                PermanentPalletCfg.isReady = false
                PermanentPalletCfg.currentPallet = nil
            end
            task.wait(0.5)
        end
        PermanentPalletCfg.currentPallet = nil
        PermanentPalletCfg.isReady = false
    end)
    print("[AMETHYST] ✅ Permanent Pallet активирован автоматически")
end)


local TargetTab = Window:AddTab({ Title = "Target", Icon = "users" })
local playersInPlotsFolder = S.Workspace:WaitForChild("PlotItems"):WaitForChild("PlayersInPlots")


local function IsPlayerInPlot(player)
    if not player then
        return false
    end
    return playersInPlotsFolder:FindFirstChild(player.Name) ~= nil
end


local targetData = {
    loopKick = {},
    ragdollLoopKick = {},
    loopBring = {}
}


local function ClearTargetGroup(groupName)
    if targetData[groupName] then
        for _, obj in pairs(targetData[groupName]) do
            if obj and typeof(obj) == "Instance" then
                pcall(function()
                    obj:Destroy()
                end)
            end
        end
        targetData[groupName] = {}
    end
end


local function TrackInstance(groupName, obj)
    if not targetData[groupName] then
        targetData[groupName] = {}
    end
    table.insert(targetData[groupName], obj)
    return obj
end


task.wait(0.5)
TargetTab:AddSection("Select Player")


local function PlayerLabel(player)
    local display = player.DisplayName
    local name = player.Name
    if display and display ~= "" and display ~= name then
        return display .. " (" .. name .. ")" .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    else
        return name .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    end
end


local function GetPlayerList()
    local items = {}
    local mapping = {}
    for _, player in ipairs(S.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local label = PlayerLabel(player)
            table.insert(items, label)
            mapping[label] = player
        end
    end
    return items, mapping
end


local targetPlayerName = ""
local targetPlayer = nil


local targetDropdown
local function RefreshPlayerDropdown()
    local items, mapping = GetPlayerList()
    if targetDropdown then
        targetDropdown:Refresh(items, true)
        if AmethystFeatures.Selected.currentPlayer and AmethystFeatures.Selected.currentPlayer.Parent then
            targetDropdown:Set(PlayerLabel(AmethystFeatures.Selected.currentPlayer))
        end
    end
end


task.spawn(function()
    while true do
        task.wait(0.5)
        RefreshPlayerDropdown()
    end
end)


targetDropdown = TargetTab:AddDropdown("TargetPlayerDropdown", {
    Title = "Select Target Player",
    Values = {},
    Default = "",
    Callback = function(selected)
        if selected == "" then
            AmethystFeatures.Selected.kickPlayer = nil
            AmethystFeatures.Selected.currentPlayer = nil
            return
        end
        local items, mapping = GetPlayerList()
        local player = mapping[selected]
        if player then
            AmethystFeatures.Selected.kickPlayer = player
            AmethystFeatures.Selected.currentPlayer = player
            Fluent:Notify({ Title = "Target Selected", Content = "Target: " .. PlayerLabel(player), Duration = 2 })
            PlayEnableSound()
        end
    end
})
RefreshPlayerDropdown()


S.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    RefreshPlayerDropdown()
end)
S.Players.PlayerRemoving:Connect(function(player)
    RefreshPlayerDropdown()
    if AmethystFeatures.Selected.currentPlayer == player then
        AmethystFeatures.Selected.kickPlayer = nil
        AmethystFeatures.Selected.currentPlayer = nil
        targetDropdown:Set("")
        Fluent:Notify({ Title = "Target", Content = "Selected player left the game", Duration = 2 })
    end
end)


playersInPlotsFolder.ChildAdded:Connect(RefreshPlayerDropdown)
playersInPlotsFolder.ChildRemoved:Connect(RefreshPlayerDropdown)


local function IsTargetAlive(player)
    return IsPlayerInPlot(player)
end


TargetTab:AddSection("Grabs func")

TargetTab:AddToggle("FastKickToggle", {
    Title = "Fast kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Fluent:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            ClearTargetGroup("ragdollLoopKick")
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    Fluent:Notify({ Title = "Error", Content = "SoundPart not found!", Duration = 3 })
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                local destroyGrabLine = grabEvents:WaitForChild("DestroyGrabLine")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                local isHeld = false
                local heldSince = 0
                local soundPart = pallet.SoundPart
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetRoot or not targetHum or not IsTargetAlive(target) then
                            ClearTargetGroup("ragdollLoopKick")
                            isHeld = false
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.1)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                task.wait()
                                createGrabLine:FireServer(targetRoot)
                                destroyGrabLine:FireServer(targetRoot, Vector3.zero, targetRoot.Position, false)
                                targetHum.PlatformStand = true
                                targetHum.Sit = true
                                if not isHeld then
                                    heldSince = tick()
                                end
                                if tick() - heldSince > .4 then
                                    if targetHum.PlatformStand then
                                        isHeld = true
                                        myRoot.CFrame = myRoot.CFrame
                                        myRoot.Velocity = Vector3.zero
                                        attachHold = TrackInstance("ragdollLoopKick", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "RagdollLoopKickAttHold"
                                        attachTarget = TrackInstance("ragdollLoopKick", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "RagdollLoopKickAttTarget"
                                        alignPos = TrackInstance("ragdollLoopKick", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = math.huge
                                        alignPos.Name = "RagdollLoopKickAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("ragdollLoopKick", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = math.huge
                                        alignOri.Name = "RagdollLoopKickAlignOri"
                                        alignOri.Parent = targetRoot
                                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                                    else
                                        heldSince = tick()
                                    end
                                end
                                task.wait()
                            end
                            if targetChar and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if attachHold then
                                    attachHold.Position = Vector3.new()
                                    attachTarget.CFrame = CFrame.new(0, 14.5, 0) * CFrame.Angles(math.rad((0 + 0 * .016) % 360), 0, 0)
                                end
                                if tick() - (isHeld and heldSince or 0) >= 0 then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                isHeld = false
            end)
            Fluent:Notify({ Title = "Ragdoll Loop Kick", Content = "Enabled - Target: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            Fluent:Notify({ Title = "Ragdoll Loop Kick", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("ControlKickToggle", {
    Title = "control kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Fluent:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("ragdollLoopKick")
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    Fluent:Notify({ Title = "Error", Content = "SoundPart not found!", Duration = 3 })
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                grabEvents:WaitForChild("CreateGrabLine")
                grabEvents:WaitForChild("DestroyGrabLine")
                local angleCache = {}
                local function getAngle(deg)
                    if not angleCache[deg] then
                        angleCache[deg] = CFrame.Angles(math.rad(deg), 0, 0)
                    end
                    return angleCache[deg]
                end
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        if not targetChar or not targetRoot or not targetHum or targetHum.Health <= 0 then
                            task.wait()
                        else
                            local soundPart = pallet:FindFirstChild("SoundPart")
                            if soundPart then
                                soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                if not soundPart:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(soundPart, soundPart.CFrame)
                                end
                                task.wait()
                                soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                return
            end)
            Fluent:Notify({ Title = "Ragdoll Loop Kick", Content = "Enabled - Target: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            Fluent:Notify({ Title = "Ragdoll Loop Kick", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("LoopBringToggle", {
    Title = "loop bring",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                Fluent:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("loopBring")
            LoopKickCfg.enabled = true
            LoopKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local soundPart = pallet:FindFirstChild("SoundPart")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                while LoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetChar or not targetHum or targetHum.Health <= 0 or not targetRoot then
                            ClearTargetGroup("loopBring")
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.4)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                targetRoot.Velocity = Vector3.zero
                                targetRoot.AssemblyLinearVelocity = Vector3.zero
                                targetRoot.AssemblyAngularVelocity = Vector3.zero
                                targetRoot.RotVelocity = Vector3.zero
                                local holdSince = tick()
                                if tick() - holdSince > .35 then
                                    if targetRoot.Velocity.Magnitude < 5 then
                                        attachHold = TrackInstance("loopBring", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "LoopBringAttHold"
                                        attachTarget = TrackInstance("loopBring", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "LoopBringAttTarget"
                                        alignPos = TrackInstance("loopBring", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = 1000
                                        alignPos.Name = "LoopBringAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("loopBring", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = 1000
                                        alignOri.Name = "LoopBringAlignOri"
                                        alignOri.Parent = targetRoot
                                        if soundPart then
                                            soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                            if not soundPart:FindFirstChild("PartOwner") then
                                                setOwner:FireServer(soundPart, soundPart.CFrame)
                                            end
                                            task.wait()
                                            soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                        end
                                        for _, part in pairs(targetRoot:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                part.CustomPhysicalProperties = PhysicalProperties.new(.2, 0, 10)
                                            end
                                        end
                                    end
                                end
                            end
                            if attachHold and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if soundPart then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("loopBring")
            end)
            Fluent:Notify({ Title = "Loop Kick (Hold + Pallet)", Content = "Holding: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            LoopKickCfg.enabled = false
            if LoopKickCfg.loopThread then
                task.cancel(LoopKickCfg.loopThread)
                LoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("loopBring")
            Fluent:Notify({ Title = "Loop Kick (Hold + Pallet)", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddSection("removed")


TargetTab:AddToggle("RemoveAntiKickToggle", {
    Title = "Remove Anti Kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            RemoveAntiKickCfg.enabled = true
            RemoveAntiKickCfg.targetPlayer = AmethystFeatures.Selected.kickPlayer
            Fluent:Notify({ Title = "Remove Anti Kick", Content = "Enabled - Target: " .. RemoveAntiKickCfg.targetPlayer.Name, Duration = 3 })
            PlayEnableSound()
            RemoveAntiKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local target = RemoveAntiKickCfg.targetPlayer
                local processed = {}


                local function Claim(soundPart)
                    if not soundPart then
                        return false
                    end
                    setOwner:FireServer(soundPart, soundPart.CFrame)
                    task.wait()
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == LocalPlayer.Name then
                        soundPart.CFrame = CFrame.new(0, 1000, 0)
                        return true
                    end
                    return false
                end


                while RemoveAntiKickCfg.enabled and target and target.Parent do
                    local folder = S.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            for _, itemName in ipairs({ "NinjaKunai", "NinjaShuriken", "AntiKick" }) do
                                if toy.Name == itemName then
                                    local key = toy.Name .. "_" .. tostring(toy:GetDebugId())
                                    if not processed[key] then
                                        if Claim(toy) then
                                            processed[key] = true
                                        end
                                    end
                                end
                            end
                        end
                        for key in pairs(processed) do
                            if string.match(key, "_(%d+)$") then
                                local name = string.match(key, "^(.-)_")
                                local item = folder:FindFirstChild(name)
                                if not item or not item:IsDescendantOf(folder) then
                                    processed[key] = nil
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RemoveAntiKickCfg.enabled = false
                RemoveAntiKickCfg.targetPlayer = nil
            end)
        else
            RemoveAntiKickCfg.enabled = false
            RemoveAntiKickCfg.targetPlayer = nil
            if RemoveAntiKickCfg.loopThread then
                task.cancel(RemoveAntiKickCfg.loopThread)
                RemoveAntiKickCfg.loopThread = nil
            end
            Fluent:Notify({ Title = "Remove Anti Kick", Content = "Disabled", Duration = 2 })
        end
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "FTAP-Gemoroi",
    Content = "Fully Operational Core loaded successfully!",
    Duration = 5
})

TargetTab:AddSection("Blob Functions")

TargetTab:AddToggle("AutoSitBlobTargetToggle", {
    Title = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value do
                            if tick() - start < 3 then
                                task.wait()
                            end
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            Fluent:Notify({ Title = "Auto Sit Blob", Content = "Enabled - Auto sitting on blob", Duration = 2 })
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            Fluent:Notify({ Title = "Auto Sit Blob", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("BlobKillToggle", {
    Title = "Blob Kill",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            BlobKillCfg.enabled = true
            BlobKillCfg.selectedPlayers = { AmethystFeatures.Selected.kickPlayer }
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                while BlobKillCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait(0.5)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 or not humanoid.SeatPart then
                            task.wait(0.5)
                        else
                            local blob = humanoid.SeatPart:FindFirstAncestor("CreatureBlobman")
                            local target = BlobKillCfg.selectedPlayers[1]
                            if blob and target and target.Character then
                                local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                                if seatScript then
                                    local grab = seatScript:FindFirstChild("CreatureGrab")
                                    local release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop")
                                    local leftDet = blob:FindFirstChild("LeftDetector")
                                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                                    local rightDet = blob:FindFirstChild("RightDetector")
                                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                                    if grab and release then
                                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                                        if targetRoot then
                                            grab:FireServer(rightDet, targetRoot, rightWeld)
                                            task.wait(.1)
                                            if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                                                target.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                            end
                                            release:FireServer(rightWeld)
                                        end
                                    end
                                end
                            end
                            task.wait(1)
                        end
                    end
                end
                BlobKillCfg.currentBlob = nil
            end)
            Fluent:Notify({ Title = "Blob Kill", Content = "Enabled - Target: " .. AmethystFeatures.Selected.kickPlayer.Name, Duration = 3 })
            PlayEnableSound()
        else
            BlobKillCfg.enabled = false
            if BlobKillCfg.loopThread then
                task.cancel(BlobKillCfg.loopThread)
                BlobKillCfg.loopThread = nil
            end
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.selectedPlayers = {}
            Fluent:Notify({ Title = "Blob Kill", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("BlobSimpleTeleportSpamToggle", {
    Title = "Blob - Simple Teleport Spam",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                Fluent:Notify({ Title = "Error", Content = "Select target!", Duration = 2 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            TargetTab.SimpleSpamData = {
                active = true
            }
            TargetTab.SimpleSpamData.thread = task.spawn(function()
                while TargetTab.SimpleSpamData and TargetTab.SimpleSpamData.active do
                    if not LocalPlayer.Character then
                        task.wait(.1)
                    else
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetChar = target and target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if root and targetRoot then
                            root.CFrame = targetRoot.CFrame
                            task.wait(.05)
                        end
                    end
                end
            end)
            Fluent:Notify({ Title = "Simple Teleport Spam", Content = "Enabled", Duration = 2 })
        else
            if TargetTab.SimpleSpamData then
                TargetTab.SimpleSpamData.active = false
                if TargetTab.SimpleSpamData.thread then
                    task.cancel(TargetTab.SimpleSpamData.thread)
                end
                TargetTab.SimpleSpamData = nil
            end
            Fluent:Notify({ Title = "Simple Teleport Spam", Content = "Disabled", Duration = 2 })
        end
    end
})


-- local AurasTab = Window:AddTab({ Title = "Auras", Icon = "" })
local AurasTab = Tabs.Auras
AurasTab:AddSection("Ragdoll auras")


AurasTab:AddToggle("RagdollAuraToggle", {
    Title = "Ragdoll Aura",
    Default = false,
    Callback = function(state)
        if state then
            if not PermanentPalletCfg.enabled then
                Fluent:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local pallet = PermanentPalletCfg.currentPallet
            if not pallet or not pallet.Parent then
                Fluent:Notify({ Title = "Error", Content = "Permanent Pallet not found!", Duration = 3 })
                return
            end
            local soundPart = pallet:FindFirstChild("SoundPart")
            if not soundPart then
                Fluent:Notify({ Title = "Error", Content = "Pallet has no SoundPart!", Duration = 3 })
                return
            end
            local owner = soundPart:FindFirstChild("PartOwner")
            if not owner or owner.Value ~= LocalPlayer.Name then
                Fluent:Notify({ Title = "Error", Content = "No ownership on pallet!", Duration = 3 })
                return
            end
            RagdollAuraCfg.enabled = true
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            RagdollAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local char = lp.Character
                if not char then
                    return
                end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if not myRoot then
                    return
                end
                local setOwner = S.ReplicatedStorage.GrabEvents.SetNetworkOwner
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote


                local function EnsureOwnership(soundPart)
                    if not soundPart then
                        return false
                    end
                    if not soundPart.Parent then
                        return false
                    end
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    return true
                end


                local function RagdollTarget(player)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root then
                        return false
                    end
                    if (root.Position - myRoot.Position).Magnitude > 30 then
                        RagdollAuraCfg.ragdolledPlayers[player] = nil
                        return false
                    end
                    if soundPart and soundPart.CFrame then
                        setOwner:FireServer(root, root.CFrame)
                        soundPart.CFrame = root.CFrame * CFrame.new(0, 0, 0.5)
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                        task.wait()
                        soundPart.CFrame = CFrame.new(0, 10000, 0)
                        task.wait()
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    RagdollAuraCfg.ragdolledPlayers[player] = os.clock()
                    return true
                end


                while RagdollAuraCfg.enabled do
                    local pChar = lp.Character
                    if pChar then
                        myRoot = pChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                                print("[Ragdoll Aura] Permanent Pallet отключилась")
                            else
                                if not EnsureOwnership(soundPart) then
                                    print("[Ragdoll Aura] Не удалось установить ownership на паллет")
                                else
                                    for player, lastTime in pairs(RagdollAuraCfg.ragdolledPlayers) do
                                        if os.clock() - lastTime > 1 then
                                            RagdollAuraCfg.ragdolledPlayers[player] = nil
                                        end
                                    end
                                    local near = {}
                                    for _, player in pairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            if root and (root.Position - myRoot.Position).Magnitude <= 30 then
                                                table.insert(near, player)
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if RagdollAuraCfg.enabled then
                                            RagdollTarget(player)
                                            if i % 3 == 0 then
                                                task.wait()
                                            end
                                        end
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RagdollAuraCfg.ragdolledPlayers = {}
            end)
            task.spawn(function()
                while RagdollAuraCfg.enabled do
                    if RagdollAuraCfg.enabled and not PermanentPalletCfg.enabled then
                        print("[Ragdoll Aura] Permanent Pallet отключилась, отключаем...")
                        if RagdollAuraCfg.loopThread then
                            task.cancel(RagdollAuraCfg.loopThread)
                            RagdollAuraCfg.loopThread = nil
                        end
                        RagdollAuraCfg.enabled = false
                        RagdollAuraCfg.ragdolledPlayers = {}
                        RagdollAuraCfg.isTeleportingPallet = false
                        break
                    else
                        task.wait(1)
                    end
                end
            end)
            Fluent:Notify({ Title = "Ragdoll Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            RagdollAuraCfg.enabled = false
            if RagdollAuraCfg.loopThread then
                task.cancel(RagdollAuraCfg.loopThread)
                RagdollAuraCfg.loopThread = nil
            end
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            Fluent:Notify({ Title = "Ragdoll Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddSection("Blob Auras")


AurasTab:AddToggle("AutoSitBlobAuraToggle", {
    Title = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value do
                            if tick() - start < 3 then
                                task.wait()
                            end
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            Fluent:Notify({ Title = "Auto Sit Blob", Content = "Enabled - Auto sitting on blob", Duration = 2 })
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            Fluent:Notify({ Title = "Auto Sit Blob", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("KillAuraBlobToggle", {
    Title = "Kill Aura (Blob)",
    Default = false,
    Callback = function(state)
        if state then
            KillAuraCfg.enabled = true
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            KillAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local ws = S.Workspace
                local function FindBlob()
                    local folder = ws:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function GetBlobRemotes(blob)
                    if not blob then
                        return nil
                    end
                    local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                    if not seatScript then
                        return nil
                    end
                    local leftDet = blob:FindFirstChild("LeftDetector")
                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                    local rightDet = blob:FindFirstChild("RightDetector")
                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                    return {
                        grab = seatScript:FindFirstChild("CreatureGrab"),
                        release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop"),
                        leftDet = leftDet,
                        leftWeld = leftWeld,
                        rightDet = rightDet,
                        rightWeld = rightWeld
                    }
                end
                local function TryKill(player, blob, useLeft)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root or not humanoid or humanoid.Health <= 0 then
                        return false
                    end
                    local myChar = lp.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        return false
                    end
                    if (myRoot.Position - root.Position).Magnitude > 30 then
                        return false
                    end
                    local now = tick()
                    if KillAuraCfg.killCooldown[player] and now - KillAuraCfg.killCooldown[player] < 1 then
                        return false
                    end
                    local remotes = GetBlobRemotes(blob)
                    if not remotes or not remotes.grab or not remotes.release then
                        return false
                    end
                    local det = useLeft and remotes.leftDet or remotes.rightDet
                    local weld = useLeft and remotes.leftWeld or remotes.rightWeld
                    if not det or not weld then
                        return false
                    end
                    pcall(function()
                        if remotes.grab and remotes.grab.FireServer then
                            remotes.grab:FireServer(det, root, weld)
                        end
                        task.wait(.0001)
                        if remotes.release and remotes.release.FireServer then
                            remotes.release:FireServer(weld)
                        end
                    end)
                    task.wait(.0002)
                    pcall(function()
                        if humanoid and humanoid.Health > 0 then
                            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                        end
                    end)
                    KillAuraCfg.killCooldown[player] = now
                    KillAuraCfg.lastKillTime = now
                    return true
                end
                while KillAuraCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait()
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(0)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(ws) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    KillAuraCfg.currentBlob = blob
                                    local near = {}
                                    for _, player in ipairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            local human = player.Character:FindFirstChild("Humanoid")
                                            if root and human and human.Health > 0 then
                                                local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                                                if myRoot and (myRoot.Position - root.Position).Magnitude <= 30 then
                                                    table.insert(near, player)
                                                end
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if KillAuraCfg.enabled then
                                            if TryKill(player, blob, true) then
                                                if (i + 1) % 3 == 0 then
                                                    task.wait()
                                                end
                                            end
                                        end
                                    end
                                    KillAuraCfg.targetPlayers = near
                                    for player, cooldown in pairs(KillAuraCfg.killCooldown) do
                                        if tick() - cooldown > 1e-05 then
                                            KillAuraCfg.killCooldown[player] = nil
                                        end
                                    end
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                KillAuraCfg.currentBlob = nil
                KillAuraCfg.spawningBlob = false
                KillAuraCfg.killCooldown = {}
                KillAuraCfg.targetPlayers = {}
                KillAuraCfg.lastKillTime = 0
                print("[Kill Aura] Цикл остановлен")
            end)
            Fluent:Notify({ Title = "Kill Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            KillAuraCfg.enabled = false
            if KillAuraCfg.loopThread then
                task.cancel(KillAuraCfg.loopThread)
                KillAuraCfg.loopThread = nil
            end
            KillAuraCfg.currentBlob = nil
            KillAuraCfg.spawningBlob = false
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            Fluent:Notify({ Title = "Kill Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("DualLockAuraToggle", {
    Title = "Dual Lock Aura",
    Default = false,
    Callback = function(state)
        if state then
            AdvancedDuallockCfg.enabled = true
            AdvancedDuallockCfg.processedPlayers = {}
            AdvancedDuallockCfg.originalBarrierState = {}
            local function DisableBarriers()
                local plots = S.Workspace:FindFirstChild("Plots")
                if plots then
                    for _, plot in ipairs(plots:GetChildren()) do
                        local barrier = plot:FindFirstChild("Barrier")
                        if barrier then
                            for _, part in ipairs(barrier:GetChildren()) do
                                if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                                    AdvancedDuallockCfg.originalBarrierState[part] = part.CanCollide
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
            AdvancedDuallockCfg.loopThread = task.spawn(function()
                while AdvancedDuallockCfg.enabled do
                    DisableBarriers()
                    task.wait()
                end
            end)
            Fluent:Notify({ Title = "Dual Lock Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            AdvancedDuallockCfg.enabled = false
            if AdvancedDuallockCfg.loopThread then
                task.cancel(AdvancedDuallockCfg.loopThread)
                AdvancedDuallockCfg.loopThread = nil
            end
            for part, state in pairs(AdvancedDuallockCfg.originalBarrierState) do
                if part and part:IsA("BasePart") then
                    part.CanCollide = state
                end
            end
            AdvancedDuallockCfg.originalBarrierState = {}
            AdvancedDuallockCfg.currentBlob = nil
            AdvancedDuallockCfg.processedPlayers = {}
            Fluent:Notify({ Title = "Dual Lock Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("DestroyKickAuraToggle", {
    Title = "Destroy Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            DestroyKickAuraCfg.enabled = true
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            DestroyKickAuraCfg.lastSpawnTime = 0
            DestroyKickAuraCfg.spawnInterval = 0
            local function BlobOfSeat(humanoid)
                local seat = humanoid.SeatPart
                if seat then
                    return seat:FindFirstAncestor("CreatureBlobman")
                end
                return nil
            end
            local function IsAlive(player)
                if not player or not player.Character then
                    return false
                end
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                    return false
                end
                return humanoid.Health > 0
            end
            local function CleanupProcessed()
                for player in pairs(DestroyKickAuraCfg.processedPlayers) do
                    if not player:IsDescendantOf(S.Players) or not player.Character or not IsAlive(player) then
                        DestroyKickAuraCfg.processedPlayers[player] = nil
                    end
                end
            end
            local function GetNearbyPlayers(range)
                local char = LocalPlayer.Character
                if not char then
                    return {}
                end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then
                    return {}
                end
                local pos = root.Position
                CleanupProcessed()
                local near = {}
                for _, player in ipairs(S.Players:GetPlayers()) do
                    if player ~= LocalPlayer and IsAlive(player) then
                        local pChar = player.Character
                        if pChar then
                            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                            if pRoot and (pRoot.Position - pos).Magnitude <= range then
                                table.insert(near, player)
                            end
                        end
                    end
                end
                return near
            end
            local function KickPlayer(player)
                local lpChar = LocalPlayer.Character
                if not lpChar then
                    return
                end
                local head = lpChar:WaitForChild("Head", 2)
                local lpRoot = lpChar:WaitForChild("HumanoidRootPart", 2)
                if not head or not lpRoot then
                    return
                end
                local pChar = player.Character
                if not pChar then
                    return
                end
                local pRoot = pChar:WaitForChild("HumanoidRootPart", 2)
                if not pRoot then
                    return
                end
                local grabEvents = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                local createGrabLine = grabEvents and grabEvents:FindFirstChild("CreateGrabLine")
                if createGrabLine then
                    createGrabLine:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    pRoot.CFrame = head.CFrame * CFrame.new(0, 12, 0)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(pRoot)
                    task.wait()
                    S.ReplicatedStorage.GrabEvents.EndGrabEarly:FireServer(pRoot)
                    task.wait()
                end
                local lpHumanoid = lpChar:FindFirstChild("Humanoid")
                if lpHumanoid then
                    local blob = BlobOfSeat(lpHumanoid)
                    if blob then
                        local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                        local rightDet = blob:FindFirstChild("RightDetector")
                        local leftDet = blob:FindFirstChild("LeftDetector")
                        if seatScript then
                            local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                            local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                            local grabRemote = seatScript:FindFirstChild("CreatureGrab")
                            if grabRemote then
                                if rightWeld then
                                    grabRemote:FireServer(rightDet, pChar:WaitForChild("HumanoidRootPart", 2), rightWeld)
                                    task.wait(.1)
                                end
                                if leftWeld then
                                    grabRemote:FireServer(leftDet, pChar:WaitForChild("HumanoidRootPart", 2), leftWeld)
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.processedPlayers[player] = true
            end
            DestroyKickAuraCfg.loopThread = task.spawn(function()
                while DestroyKickAuraCfg.enabled do
                    local char = LocalPlayer.Character
                    if not char then
                        task.wait(.1)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(.1)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(S.Workspace) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    DestroyKickAuraCfg.currentBlob = blob
                                    local near = GetNearbyPlayers(30)
                                    for _, player in ipairs(near) do
                                        if DestroyKickAuraCfg.enabled then
                                            KickPlayer(player)
                                            if #GetNearbyPlayers(30) > 1 then
                                                task.wait(.1)
                                            end
                                        end
                                    end
                                    CleanupProcessed()
                                    if #near == 0 then
                                        task.wait(.1)
                                    else
                                        task.wait()
                                    end
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.currentBlob = nil
                DestroyKickAuraCfg.processedPlayers = {}
                DestroyKickAuraCfg.isSpawning = false
                print("[Destroy Kick Aura] Цикл остановлен")
            end)
            Fluent:Notify({ Title = "Destroy Kick Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            DestroyKickAuraCfg.enabled = false
            if DestroyKickAuraCfg.loopThread then
                task.cancel(DestroyKickAuraCfg.loopThread)
                DestroyKickAuraCfg.loopThread = nil
            end
            DestroyKickAuraCfg.currentBlob = nil
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            Fluent:Notify({ Title = "Destroy Kick Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddSection("Kick Auras")


AurasTab:AddToggle("KickAuraFixedToggle", {
    Title = "Kick Aura (Fixed)",
    Default = false,
    Callback = function(state)
        if state then
            KickAuraFixedCfg.enabled = true
            KickAuraFixedCfg.fixedPlayers = {}
            KickAuraFixedCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
                local offsets = {
                    Vector3.new(-4, 15, -4),
                    Vector3.new(4, 15, -4),
                    Vector3.new(-4, 15, 4),
                    Vector3.new(4, 15, 4)
                }
                while KickAuraFixedCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            Fluent:Notify({ Title = "Kick Aura (Fixed)", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            KickAuraFixedCfg.enabled = false
            if KickAuraFixedCfg.loopThread then
                task.cancel(KickAuraFixedCfg.loopThread)
                KickAuraFixedCfg.loopThread = nil
            end
            for _, data in pairs(KickAuraFixedCfg.fixedPlayers) do
                if data.alignPos and data.alignPos.Parent then
                    data.alignPos:Destroy()
                end
                if data.alignOri and data.alignOri.Parent then
                    data.alignOri:Destroy()
                end
            end
            KickAuraFixedCfg.fixedPlayers = {}
            Fluent:Notify({ Title = "Kick Aura (Fixed)", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("JumpKickAuraToggle", {
    Title = "Jump Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            JumpKickAuraCfg.enabled = true
            JumpKickAuraCfg.processedPlayers = {}
            JumpKickAuraCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                while JumpKickAuraCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            Fluent:Notify({ Title = "Jump Kick Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            JumpKickAuraCfg.enabled = false
            if JumpKickAuraCfg.loopThread then
                task.cancel(JumpKickAuraCfg.loopThread)
                JumpKickAuraCfg.loopThread = nil
            end
            JumpKickAuraCfg.processedPlayers = {}
            Fluent:Notify({ Title = "Jump Kick Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


local ServerTab = Window:AddTab({ Title = "Server", Icon = "" })
ServerTab:AddSection("Server Lag")


local lagRiskLabel = nil
local packetSizeLabel = nil


local function UpdateLagLabels()
    if packetSizeLabel then
        packetSizeLabel.Text = "Size: " .. Features.PacketLag.packetSize
        if Features.PacketLag.packetSize > 600000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            if lagRiskLabel then
                lagRiskLabel.Text = "⚠️ HIGH LAG WARNING! ⚠️"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        elseif Features.PacketLag.packetSize > 200000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            if lagRiskLabel then
                lagRiskLabel.Text = "⚠️ Medium lag risk ⚠️"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            end
        else
            packetSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            if lagRiskLabel then
                lagRiskLabel.Text = "Low lag risk"
                lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end


local function StopPacketLag()
    if Features.PacketLag.loopThread then
        task.cancel(Features.PacketLag.loopThread)
        Features.PacketLag.loopThread = nil
    end
    Features.PacketLag.enabled = false
    if lagRiskLabel then
        lagRiskLabel.Text = "Stopped"
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    Fluent:Notify({ Title = "Packet Lag", Content = "Disabled", Duration = 2 })
    task.delay(2, function()
        if lagRiskLabel then
            UpdateLagLabels()
        end
    end)
end


local function StartPacketLag()
    Features.PacketLag.enabled = true
    if lagRiskLabel then
        lagRiskLabel.Text = "STARTING..."
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    Features.PacketLag.loopThread = task.spawn(function()
        local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
        local extendRemote = grabEvents:WaitForChild("ExtendGrabLine")
        if not extendRemote then
            warn("[Packet Lag] ExtendGrabLine RemoteEvent not found!")
            StopPacketLag()
            return
        end
        if lagRiskLabel then
            lagRiskLabel.Text = "LAGGING SERVER..."
            lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
        Fluent:Notify({ Title = "Packet Lag", Content = "Enabled - Packet Size: " .. Features.PacketLag.packetSize, Duration = 3 })
        PlayEnableSound()
        while Features.PacketLag.enabled do
            extendRemote:FireServer(string.rep("❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️❤️❤️😘😘😘😘😍😍😍😍❤️❤️❤️", math.floor(Features.PacketLag.packetSize / 10)))
            print("[Packet Lag] Sent packet size: " .. Features.PacketLag.packetSize)
            task.wait(3e-05)
        end
    end)
end


local packetSizeSlider = ServerTab:AddSlider("PacketSizeSlider", {
    Title = "Packet Size",
    Min = 100,
    Max = 1000000,
    Default = 50000,
    Rounding = 0,
    Callback = function(value)
        Features.PacketLag.packetSize = value
        UpdateLagLabels()
    end
})


task.spawn(function()
    task.wait(0.5)
    local sliderUI = packetSizeSlider and typeof(packetSizeSlider.GetUI) == "function" and packetSizeSlider:GetUI() or nil
    if sliderUI then
        for _, item in pairs(sliderUI:GetChildren()) do
            if item:IsA("TextLabel") then
                if string.find(item.Text, "Size:") or item.Name == "ValueLabel" or item.Name == "Value" then
                    packetSizeLabel = item
                end
            end
        end
        if not packetSizeLabel then
            packetSizeLabel = Instance.new("TextLabel")
            packetSizeLabel.Size = UDim2.new(1, -20, 0, 20)
            packetSizeLabel.Position = UDim2.new(0, 10, 0, 70)
            packetSizeLabel.BackgroundTransparency = 1
            packetSizeLabel.Text = "Size: " .. Features.PacketLag.packetSize
            packetSizeLabel.Font = Enum.Font.Gotham
            packetSizeLabel.TextSize = 12
            packetSizeLabel.TextXAlignment = Enum.TextXAlignment.Center
            packetSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            packetSizeLabel.Parent = sliderUI
        end
        lagRiskLabel = Instance.new("TextLabel")
        lagRiskLabel.Size = UDim2.new(1, -20, 0, 20)
        lagRiskLabel.Position = UDim2.new(0, 10, 0, 90)
        lagRiskLabel.BackgroundTransparency = 1
        lagRiskLabel.Text = "Low lag risk"
        lagRiskLabel.Font = Enum.Font.GothamBold
        lagRiskLabel.TextSize = 11
        lagRiskLabel.TextXAlignment = Enum.TextXAlignment.Center
        lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        lagRiskLabel.Parent = sliderUI
        UpdateLagLabels()
    end
})


ServerTab:AddToggle("PacketLagToggle", {
    Title = "Packet Lag",
    Default = false,
    Callback = function(state)
        if state then
            StartPacketLag()
        else
            StopPacketLag()
        end
    end
})


ServerTab:AddSection("Line Lag")


ServerTab:AddToggle("LineLagServerLagToggle", {
    Title = "Line Lag (Server Lag)",
    Default = false,
    Callback = function(state)
        if state then
            ServerLagCfg.enabled = true
            task.spawn(function()
                if ServerLagCfg.enabled then
                    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                    local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                    if not createGrabLine then
                        warn("[Server Lag] CreateGrabLine RemoteEvent not found!")
                        ServerLagCfg.enabled = false
                        Fluent:Notify({ Title = "Server Lag", Content = "Error: CreateGrabLine not found!", Duration = 3 })
                        return
                    end
                    print("[Server Lag] Started!")
                    ServerLagCfg.loopThread = task.spawn(function()
                        while ServerLagCfg.enabled do
                            local spawnLoc = S.Workspace:FindFirstChild("SpawnLocation")
                            if spawnLoc then
                                for y = 0, 50 do
                                    if not ServerLagCfg.enabled then
                                        break
                                    end
                                    createGrabLine:FireServer(CFrame.new(0, y, 0))
                                    task.wait(.005)
                                end
                            end
                            task.wait(.1)
                        end
                    end)
                    Fluent:Notify({ Title = "Server Lag", Content = "Enabled - Lagging server with lines", Duration = 3 })
                    PlayEnableSound()
                end
            end)
        else
            ServerLagCfg.enabled = false
            if ServerLagCfg.loopThread then
                task.cancel(ServerLagCfg.loopThread)
                ServerLagCfg.loopThread = nil
            end
            Fluent:Notify({ Title = "Server Lag", Content = "Disabled", Duration = 2 })
            print("[Server Lag] Stopped")
        end
    end
})
