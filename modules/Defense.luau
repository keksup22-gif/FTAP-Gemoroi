local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Defense = {}

Defense.AntiGrab = { enabled = false, connection = nil, isHeldConn = nil, charConn = nil }
Defense.AntiKickStick = { enabled = false, loopThread = nil, currentItem = nil, selectedItem = "NinjaShuriken" }
Defense.AntiVoid = { enabled = false, loopThread = nil, originalDestroyHeight = -100 }
Defense.AntiExplode = { enabled = false, connections = {} }
Defense.AntiBurn = { enabled = false, connection = nil }
Defense.AntiPaint = { enabled = false, connection = nil }
Defense.AntiSticky = { enabled = false }
Defense.AntiLineLag = { enabled = false }
Defense.AntiInputLag = { enabled = false, loopThread = nil }
Defense.AntiBlobman = { enabled = false, loopThread = nil }
Defense.PCLDBreaker = { enabled = false, loopThread = nil }
Defense.CounterAttack = { enabled = false, mode = "Hell", connection = nil }

Defense.AntiKickStick.items = {
    "NinjaShuriken",
    "NinjaKunai",
    "ToolPencil",
    "ToolPickaxe",
    "ToolDiggingForkRusty",
    "ToolCleaver",
    "NinjaKatana"
}

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

-- Anti-Grab (Obsidian / Anchor Grab Engine)
function Defense.ToggleAntiGrab(state)
    Defense.AntiGrab.enabled = state
    local lp = Shared.LocalPlayer

    if state then
        local function onHeldChanged()
            local isHeld = lp:FindFirstChild("IsHeld")
            if isHeld and isHeld.Value then
                local root = Shared.GetRoot(lp)
                local hum = Shared.GetCharHumanoid(lp)
                if root then
                    root.Anchored = true
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    Shared.SetNetworkOwner(root, root.CFrame)
                    Shared.Struggle()
                    Shared.Ragdoll(root, 0)
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Physics)
                        hum.Sit = false
                    end
                end
            else
                local root = Shared.GetRoot(lp)
                if root then
                    root.Anchored = false
                end
            end
        end

        local isHeld = lp:FindFirstChild("IsHeld")
        if isHeld then
            Defense.AntiGrab.isHeldConn = isHeld:GetPropertyChangedSignal("Value"):Connect(onHeldChanged)
        end

        Defense.AntiGrab.charConn = lp.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local newHeld = lp:FindFirstChild("IsHeld")
            if newHeld and Defense.AntiGrab.enabled then
                if Defense.AntiGrab.isHeldConn then Defense.AntiGrab.isHeldConn:Disconnect() end
                Defense.AntiGrab.isHeldConn = newHeld:GetPropertyChangedSignal("Value"):Connect(onHeldChanged)
            end
        end)

        Defense.AntiGrab.connection = Shared.RunService.Heartbeat:Connect(function()
            local curHeld = lp:FindFirstChild("IsHeld")
            if curHeld and curHeld.Value then
                local root = Shared.GetRoot(lp)
                if root then
                    root.Anchored = true
                    Shared.Struggle()
                    Shared.SetNetworkOwner(root, root.CFrame)
                end
            end
        end)

        Shared.Notify("Anti-Grab", "Anti-Grab Protection Active 🛡️", 2)
        Shared.PlayEnableSound()
    else
        if Defense.AntiGrab.connection then Defense.AntiGrab.connection:Disconnect(); Defense.AntiGrab.connection = nil end
        if Defense.AntiGrab.isHeldConn then Defense.AntiGrab.isHeldConn:Disconnect(); Defense.AntiGrab.isHeldConn = nil end
        if Defense.AntiGrab.charConn then Defense.AntiGrab.charConn:Disconnect(); Defense.AntiGrab.charConn = nil end
        local root = Shared.GetRoot(lp)
        if root then root.Anchored = false end
        Shared.Notify("Anti-Grab", "Anti-Grab Disabled", 2)
    end
end

-- XOCU Counter Attack on Grab
function Defense.ToggleCounterAttack(state, mode)
    Defense.CounterAttack.enabled = state
    Defense.CounterAttack.mode = mode or Defense.CounterAttack.mode or "Hell"

    if state then
        if Defense.CounterAttack.connection then Defense.CounterAttack.connection:Disconnect() end
        Defense.CounterAttack.connection = Shared.RunService.Heartbeat:Connect(function()
            local isHeld = Shared.LocalPlayer:FindFirstChild("IsHeld")
            if isHeld and isHeld.Value then
                local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                if myRoot then
                    for _, player in ipairs(Shared.Players:GetPlayers()) do
                        if player ~= Shared.LocalPlayer and player.Character then
                            local pRoot = Shared.GetRoot(player)
                            if pRoot and (pRoot.Position - myRoot.Position).Magnitude <= 20 then
                                Shared.SetNetworkOwner(pRoot, pRoot.CFrame)
                                if Defense.CounterAttack.mode == "Hell" then
                                    pRoot.AssemblyLinearVelocity = Vector3.new(0, -1e8, 0)
                                    pRoot.CFrame = CFrame.new(pRoot.Position.X, -3000, pRoot.Position.Z)
                                elseif Defense.CounterAttack.mode == "Kill" then
                                    pRoot.AssemblyLinearVelocity = Vector3.new(0, 1e9, 0)
                                elseif Defense.CounterAttack.mode == "Fling" then
                                    pRoot.AssemblyLinearVelocity = Vector3.new(math.random(-1e5, 1e5), 90000, math.random(-1e5, 1e5))
                                end
                            end
                        end
                    end
                end
            end
        end)
        Shared.Notify("Counter Attack", "XOCU Auto-Counter Attack Active ⚔️", 2)
    else
        if Defense.CounterAttack.connection then
            Defense.CounterAttack.connection:Disconnect()
            Defense.CounterAttack.connection = nil
        end
        Shared.Notify("Counter Attack", "Counter Attack Disabled", 2)
    end
end

-- XOCU Auto PCLD Breaker (Destroys enemy tracking hitboxes)
function Defense.TogglePCLDBreaker(state)
    Defense.PCLDBreaker.enabled = state
    if state then
        if Defense.PCLDBreaker.loopThread then task.cancel(Defense.PCLDBreaker.loopThread) end
        Defense.PCLDBreaker.loopThread = task.spawn(function()
            while Defense.PCLDBreaker.enabled do
                pcall(function()
                    for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector") then
                            obj:Destroy()
                        end
                    end
                end)
                task.wait(1)
            end
        end)
        Shared.Notify("PCLD Breaker", "Auto PCLD Breaker Active (Invisible to enemy aimbots) 👁️‍🗨️", 2)
    else
        if Defense.PCLDBreaker.loopThread then
            task.cancel(Defense.PCLDBreaker.loopThread)
            Defense.PCLDBreaker.loopThread = nil
        end
        Shared.Notify("PCLD Breaker", "PCLD Breaker Disabled", 2)
    end
end

-- XOCU Purge GrabParts (Anti-Lag)
function Defense.PurgeGrabParts()
    local count = 0
    pcall(function()
        for _, v in ipairs(Shared.Workspace:GetChildren()) do
            if v.Name == "GrabParts" and not v:FindFirstChildOfClass("Humanoid") then
                v:Destroy()
                count = count + 1
            end
        end
    end)
    Shared.Notify("Anti-Lag", "Purged " .. count .. " orphaned GrabParts!", 2)
end

-- Anti-Void (Auto Void Rescue)
function Defense.ToggleAntiVoid(state)
    Defense.AntiVoid.enabled = state
    if state then
        Defense.AntiVoid.originalDestroyHeight = Shared.Workspace.FallenPartsDestroyHeight
        Shared.Workspace.FallenPartsDestroyHeight = -3000
        if Defense.AntiVoid.loopThread then task.cancel(Defense.AntiVoid.loopThread) end
        Defense.AntiVoid.loopThread = task.spawn(function()
            while Defense.AntiVoid.enabled do
                local root = Shared.GetRoot(Shared.LocalPlayer)
                if root and root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 15, root.Position.Z)
                    Shared.StopAllVelocity()
                    Shared.Notify("Anti-Void", "Rescued from void!", 2)
                end
                task.wait(0.1)
            end
        end)
        Shared.Notify("Anti-Void", "Anti-Void Rescue Active 🪂", 2)
    else
        if Defense.AntiVoid.loopThread then
            task.cancel(Defense.AntiVoid.loopThread)
            Defense.AntiVoid.loopThread = nil
        end
        pcall(function()
            Shared.Workspace.FallenPartsDestroyHeight = Defense.AntiVoid.originalDestroyHeight or -500
        end)
        Shared.Notify("Anti-Void", "Anti-Void Disabled", 2)
    end
end

-- Anti-Explosion
function Defense.ToggleAntiExplode(state)
    Defense.AntiExplode.enabled = state
    if state then
        for _, conn in pairs(Defense.AntiExplode.connections or {}) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        Defense.AntiExplode.connections = {}

        local function handleExplosion(pos, radius)
            local root = Shared.GetRoot(Shared.LocalPlayer)
            local hum = Shared.GetCharHumanoid(Shared.LocalPlayer)
            if not root or not hum then return end

            local explosionRadius = radius or 25
            local dist = (pos - root.Position).Magnitude

            if dist <= explosionRadius + 20 then
                pcall(function()
                    root.Anchored = true
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
                task.wait(0.1)
                pcall(function()
                    root.Anchored = false
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end

        Defense.AntiExplode.connections.workspace = Shared.Workspace.DescendantAdded:Connect(function(desc)
            if not Defense.AntiExplode.enabled then return end
            if desc:IsA("Explosion") then
                handleExplosion(desc.Position, desc.BlastRadius or 25)
            end
        end)

        Shared.Notify("Anti-Explode", "Explosion & Mine Defense Enabled 💣", 2)
    else
        Defense.AntiExplode.enabled = false
        for _, conn in pairs(Defense.AntiExplode.connections or {}) do
            if conn then pcall(function() conn:Disconnect() end) end
        end
        Defense.AntiExplode.connections = {}
        Shared.Notify("Anti-Explode", "Anti-Explode Disabled", 2)
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
        Shared.Notify("Anti-Paint", "Anti-Paint Enabled 🎨", 2)
    else
        Defense.AntiPaint.enabled = false
        if Defense.AntiPaint.connection then
            Defense.AntiPaint.connection:Disconnect()
            Defense.AntiPaint.connection = nil
        end
        Shared.Notify("Anti-Paint", "Anti-Paint Disabled", 2)
    end
end

-- Anti-Sticky (Anti-Shuriken Lag)
function Defense.ToggleAntiSticky(state)
    Defense.AntiSticky.enabled = state
    Shared.ToggleAntiShuriLag(state)
    Shared.Notify("Anti-Sticky", state and "Immunity to Sticky items Active" or "Anti-Sticky Disabled", 2)
end

-- Anti-Line Lag
function Defense.ToggleAntiLineLag(state)
    Defense.AntiLineLag.enabled = state
    Shared.ToggleAntiLineLag(state)
    Shared.Notify("Anti-Line Lag", state and "Line Lag Protection Active" or "Line Lag Protection Disabled", 2)
end

-- Anti-Input Lag (Spam Toy Destroyer)
function Defense.ToggleAntiInputLag(state)
    Defense.AntiInputLag.enabled = state
    if state then
        Defense.AntiInputLag.loopThread = task.spawn(function()
            while Defense.AntiInputLag.enabled do
                pcall(function()
                    local myToys = Shared.GetToyFolder(Shared.LocalPlayer)
                    if myToys then
                        for _, item in ipairs(myToys:GetChildren()) do
                            if table.find(Defense.AntiInputLag.items, item.Name) then
                                Shared.DestroyToy(item)
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
        Shared.Notify("Anti-Input Lag", "Input Lag Item Purge Active", 2)
    else
        if Defense.AntiInputLag.loopThread then
            task.cancel(Defense.AntiInputLag.loopThread)
            Defense.AntiInputLag.loopThread = nil
        end
        Shared.Notify("Anti-Input Lag", "Anti-Input Lag Disabled", 2)
    end
end

-- Anti-Blobman (Auto destroy nearby enemy blobmans)
function Defense.ToggleAntiBlobman(state)
    Defense.AntiBlobman.enabled = state
    if state then
        Defense.AntiBlobman.loopThread = task.spawn(function()
            while Defense.AntiBlobman.enabled do
                pcall(function()
                    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                    if myRoot then
                        for _, obj in ipairs(Shared.Workspace:GetChildren()) do
                            if obj.Name == "CreatureBlobman" and not obj:IsDescendantOf(Shared.GetToyFolder(Shared.LocalPlayer)) then
                                local seat = obj:FindFirstChildOfClass("Seat") or obj:FindFirstChild("SeatPart")
                                if seat and (seat.Position - myRoot.Position).Magnitude <= 30 then
                                    Shared.SetNetworkOwner(seat, seat.CFrame)
                                    Shared.DestroyToy(obj)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
        Shared.Notify("Anti-Blobman", "Anti-Blobman Defense Active 👾", 2)
    else
        if Defense.AntiBlobman.loopThread then
            task.cancel(Defense.AntiBlobman.loopThread)
            Defense.AntiBlobman.loopThread = nil
        end
        Shared.Notify("Anti-Blobman", "Anti-Blobman Disabled", 2)
    end
end

-- Anti-Kick Stick Engine
function Defense.MakeAntiKick(model)
    local char = Shared.LocalPlayer.Character
    local root = Shared.GetRoot(Shared.LocalPlayer)
    if not char or not root or not model then return end

    local stickyPart = model:FindFirstChild("StickyPart") or model:FindFirstChildWhichIsA("BasePart")
    local soundPart = model:FindFirstChild("SoundPart") or stickyPart

    local firePart = root:FindFirstChild("FirePlayerPart")
    if not firePart then
        firePart = Instance.new("Part")
        firePart.Name = "FirePlayerPart"
        firePart.Size = Vector3.new(1, 1, 1)
        firePart.Transparency = 1
        firePart.CanCollide = false
        firePart.CanQuery = false
        firePart.Anchored = false
        firePart.Parent = root
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = root
        weld.Part1 = firePart
        weld.Parent = firePart
    end

    if soundPart then
        Shared.SetNetworkOwner(soundPart, soundPart.CFrame)
    end

    if stickyPart then
        Shared.StickyAttach(stickyPart, firePart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
        stickyPart.Transparency = 1
        stickyPart.CanCollide = false
    end
    if soundPart then
        soundPart.Transparency = 1
        soundPart.CanCollide = false
    end
end

function Defense.StartAntiKickStick()
    Defense.AntiKickStick.enabled = true
    if Defense.AntiKickStick.loopThread then task.cancel(Defense.AntiKickStick.loopThread) end
    Defense.AntiKickStick.loopThread = task.spawn(function()
        while Defense.AntiKickStick.enabled do
            pcall(function()
                local root = Shared.GetRoot(Shared.LocalPlayer)
                if not root then task.wait(1); return end
                local myToys = Shared.GetToyFolder(Shared.LocalPlayer)
                local found = false
                if myToys then
                    for _, toy in ipairs(myToys:GetChildren()) do
                        if toy.Name == Defense.AntiKickStick.selectedItem then
                            found = true
                            Defense.MakeAntiKick(toy)
                        end
                    end
                end
                if not found then
                    local toy = Shared.SpawnToy(Defense.AntiKickStick.selectedItem, root.CFrame * CFrame.new(0, 5, 0), Vector3.zero)
                    if toy then
                        Defense.MakeAntiKick(toy)
                    end
                end
            end)
            task.wait(2)
        end
    end)
    Shared.Notify("Anti-Kick", "Anti-Kick Stick Active 🛡️", 2)
end

function Defense.StopAntiKickStick()
    Defense.AntiKickStick.enabled = false
    if Defense.AntiKickStick.loopThread then
        task.cancel(Defense.AntiKickStick.loopThread)
        Defense.AntiKickStick.loopThread = nil
    end
    Shared.Notify("Anti-Kick", "Anti-Kick Stick Disabled", 2)
end

return Defense
