local Shared = require(script.Parent.Shared)
local Defense = {}

function Defense.ApplyHighlight(model)
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

function Defense.GiveNetworkOwner(model, ownerName)
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    local root = Shared.GetRoot()
    if not root then
        return
    end
    local setOwner = Shared.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= ownerName then
            setOwner:FireServer(soundPart, soundPart.CFrame)
        end
    end
end

function Defense.MakeAntiKick(model, player)
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
    local grabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents")
    local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= player.Name then
            pcall(function()
                setOwner:FireServer(soundPart, soundPart.CFrame)
            end)
        end
    end
    local playerEvents = Shared.ReplicatedStorage:WaitForChild("PlayerEvents")
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
    Defense.ApplyHighlight(model)
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

-- State holders for defense features
Defense.AntiGrab = { enabled = false, connection = nil, antiGrabProc = false, agWalk = false }
Defense.AntiKickStick = { enabled = false, loopThread = nil, currentItem = nil, selectedItem = "NinjaShuriken" }
Defense.SafePos = { enabled = false, target = nil, loopThread = nil }
Defense.Noclip = { enabled = false, connection = nil, parts = {} }
Defense.AntiInputLag = { enabled = false, loopThread = nil, currentItem = nil, selectedItem = "FoodHamburger" }
Defense.AntiRagdoll = { enabled = false, connections = {}, ragdolledSit = false }
Defense.AntiVoid = { enabled = false, loopThread = nil, originalDestroyHeight = -100 }
Defense.AntiBurn = { enabled = false, connection1 = nil, connection2 = nil, currentBarrier = nil }
Defense.AntiPaint = { enabled = false, connection = nil }
Defense.AntiExplode = { enabled = false, connection = nil, bombEvent = nil }
Defense.AntiBanana = { enabled = false, connection = nil }
Defense.AntiBlob = { enabled = false, loopThread = nil, processedPlayers = {} }
Defense.AutoGucci = { enabled = false, monitoringThread = nil, connection = nil, safePosition = nil, restoreFrames = 0 }

-- Helpers for remote lookup
function Defense.GetRemote(name)
    for _, desc in ipairs(Shared.ReplicatedStorage:GetDescendants()) do
        if desc.Name == name and desc:IsA("RemoteEvent") then
            return desc
        end
    end
    return nil
end

-- Anti-Grab
Defense.antiGrabState = { remotes = {}, parts = {}, conns = {} }

function Defense.ToggleAntiGrab(state)
    Defense.AntiGrab.enabled = state
    Defense.AntiGrab.antiGrabEnabled = state
    local antiGrab = Defense.antiGrabState

    if state then
        local function OnHeartbeat()
            if not antiGrab.parts.IsHeld or not antiGrab.parts.IsHeld.Value then return end
            if not antiGrab.parts.Root or not antiGrab.parts.Humanoid then return end
            antiGrab.parts.Root.Anchored = true
            local grabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
            local setOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
            if setOwner then
                setOwner:FireServer(antiGrab.parts.Root, antiGrab.parts.Root.CFrame)
            end
            antiGrab.parts.Root.Massless = true
            antiGrab.parts.Root.CanCollide = false
            antiGrab.parts.Root.CanQuery = false
            antiGrab.parts.Root.AssemblyLinearVelocity = Vector3.zero
            antiGrab.parts.Root.AssemblyAngularVelocity = Vector3.zero
            local struggle = Defense.GetRemote("Struggle")
            local ragdoll = Defense.GetRemote("RagdollRemote")
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
                    antiGrab.conns.heartbeat = Shared.RunService.Heartbeat:Connect(OnHeartbeat)
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

        local isHeld = Shared.LocalPlayer:FindFirstChild("IsHeld")
        if isHeld then antiGrab.parts.IsHeld = isHeld end
        if Shared.LocalPlayer.Character then OnCharacterAdded(Shared.LocalPlayer.Character) end
        antiGrab.conns.charAdded = Shared.LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
        if antiGrab.parts.IsHeld then
            antiGrab.conns.heldChanged = antiGrab.parts.IsHeld:GetPropertyChangedSignal("Value"):Connect(OnHeldChanged)
        end
        OnHeldChanged()
        Shared.Notify("Anti Grab", "Enabled - Grab protection active", 2)
    else
        if antiGrab.conns.heartbeat then antiGrab.conns.heartbeat:Disconnect() end
        if antiGrab.conns.charAdded then antiGrab.conns.charAdded:Disconnect() end
        if antiGrab.conns.heldChanged then antiGrab.conns.heldChanged:Disconnect() end
        antiGrab.conns = {}
        if antiGrab.parts.Root then
            antiGrab.parts.Root.Anchored = false
            antiGrab.parts.Root.Massless = false
            antiGrab.parts.Root.CanCollide = true
            antiGrab.parts.Root.CanQuery = true
        end
        Shared.Notify("Anti Grab", "Disabled", 2)
    end
end

-- Anti-Kick Stick loop
Defense.AntiKickStick.items = {
    "NinjaShuriken",
    "NinjaKunai",
    "ToolPencil",
    "ToolPickaxe",
    "ToolDiggingForkRusty",
    "ToolCleaver",
    "NinjaKatana"
}

function Defense.StartAntiKickStickLoop()
    while Defense.AntiKickStick.enabled do
        pcall(function()
            local char = Shared.LocalPlayer.Character
            if not char then task.wait(1); return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(1); return end
            local folder = Shared.Workspace:FindFirstChild(Shared.LocalPlayer.Name .. "SpawnedInToys")
            local found = false
            if folder then
                for _, toy in ipairs(folder:GetChildren()) do
                    if toy.Name == Defense.AntiKickStick.selectedItem then
                        found = true
                        Defense.MakeAntiKick(toy, Shared.LocalPlayer)
                    end
                end
            end
            if not found then
                local spawnToy = Shared.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
                local success, toy = pcall(function()
                    return spawnToy:InvokeServer(Defense.AntiKickStick.selectedItem, root.CFrame * CFrame.new(0, 10, 0), Vector3.zero)
                end)
                if success and toy then
                    Defense.MakeAntiKick(toy, Shared.LocalPlayer)
                end
            end
        end)
        task.wait(2)
    end
end

-- Anti-Input Lag removal helper
Defense.AntiInputLag.items = {
    "FoodHamburger",
    "InstrumentDrumBongos",
    "InstrumentBrassTrumpet",
    "InstrumentBrassBugle",
    "InstrumentVoiceMicrophone",
    "InstrumentWoodwindOcarina",
    "InstrumentGuitarUkulele",
    "InstrumentGuitarLyre",
    "InstrumentGuitarBanjo",
    "InstrumentGuitarAcoustic"
}

function Defense.IsInputLagItem(name)
    return table.find(Defense.AntiInputLag.items, name) ~= nil
end

-- Anti-Void
function Defense.ToggleAntiVoid(state)
    Defense.AntiVoid.enabled = state
    if state then
        Defense.AntiVoid.originalDestroyHeight = Shared.Workspace.FallenPartsDestroyHeight
        Defense.AntiVoid.loopThread = task.spawn(function()
            while Defense.AntiVoid.enabled do
                pcall(function()
                    Shared.Workspace.FallenPartsDestroyHeight = 0
                end)
                task.wait(0.5)
            end
        end)
        Shared.Notify("Anti Void", "Enabled - FallenPartsDestroyHeight = 0", 2)
    else
        Defense.AntiVoid.enabled = false
        if Defense.AntiVoid.loopThread then
            task.cancel(Defense.AntiVoid.loopThread)
            Defense.AntiVoid.loopThread = nil
        end
        pcall(function()
            Shared.Workspace.FallenPartsDestroyHeight = Defense.AntiVoid.originalDestroyHeight
        end)
        Shared.Notify("Anti Void", "Disabled", 2)
    end
end

-- Anti-Explode
function Defense.ToggleAntiExplode(state)
    Defense.AntiExplode.enabled = state
    if state then
        Defense.AntiExplode.connection = Shared.RunService.Heartbeat:Connect(function()
            local char = Shared.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        Shared.Notify("Anti Explode", "Enabled", 2)
    else
        Defense.AntiExplode.enabled = false
        if Defense.AntiExplode.connection then
            Defense.AntiExplode.connection:Disconnect()
            Defense.AntiExplode.connection = nil
        end
        Shared.Notify("Anti Explode", "Disabled", 2)
    end
end

-- Anti-Paint
function Defense.ToggleAntiPaint(state)
    Defense.AntiPaint.enabled = state
    if state then
        Defense.AntiPaint.connection = Shared.Workspace.DescendantAdded:Connect(function(desc)
            if desc.Name == "PaintPlayerPart" then
                pcall(function() desc:Destroy() end)
            end
        end)
        for _, desc in ipairs(Shared.Workspace:GetDescendants()) do
            if desc.Name == "PaintPlayerPart" then
                pcall(function() desc:Destroy() end)
            end
        end
        Shared.Notify("Anti Paint", "Enabled", 2)
    else
        Defense.AntiPaint.enabled = false
        if Defense.AntiPaint.connection then
            Defense.AntiPaint.connection:Disconnect()
            Defense.AntiPaint.connection = nil
        end
        Shared.Notify("Anti Paint", "Disabled", 2)
    end
end

-- Anti-Sticky (disable StickyPartsTouchDetection)
function Defense.ToggleAntiSticky(state)
    Defense.AntiSticky = Defense.AntiSticky or { enabled = false, connection = nil }
    Defense.AntiSticky.enabled = state
    local scripts = Shared.LocalPlayer:FindFirstChild("PlayerScripts")
    if scripts then
        local sticky = scripts:FindFirstChild("StickyPartsTouchDetection")
        if sticky then
            sticky.Disabled = not state
            pcall(function() sticky.Disabled = not state end)
        end
    end
    Shared.Notify("Anti Sticky", state and "Enabled" or "Disabled", 2)
end

return Defense
