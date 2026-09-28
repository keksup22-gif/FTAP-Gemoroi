local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Auras = {}

Auras.Whitelist = {}

-- Telekinesis Aura
Auras.TelekinesisAura = {
    enabled = false,
    loopThread = nil,
    radius = 30
}

-- Death Aura
Auras.DeathAura = {
    enabled = false,
    loopThread = nil,
    radius = 30
}

-- Launch Aura
Auras.LaunchAura = {
    enabled = false,
    loopThread = nil,
    radius = 30
}

-- Dual Hand Kick Aura
Auras.DualKickAura = {
    enabled = false,
    loopThread = nil,
    radius = 30
}

-- Remove Anti-Kick Aura
Auras.FlingAura = {
    enabled = false,
    radius = 30,
    loopThread = nil
}
Auras.RemoveAntiKickAura = {
    enabled = false,
    radius = 30,
    connection = nil
}

function Auras.IsTargetAlive(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

function Auras.IsWhitelisted(player)
    if not player then return false end
    return table.find(Auras.Whitelist, player.Name) ~= nil
end

function Auras.GetNearbyPlayers(range)
    local char = Shared.LocalPlayer.Character
    if not char then return {} end
    local root = Shared.GetRoot(Shared.LocalPlayer)
    if not root then return {} end
    local pos = root.Position
    local near = {}
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and Auras.IsTargetAlive(player) and not Auras.IsWhitelisted(player) then
            local pRoot = Shared.GetRoot(player)
            if pRoot and (pRoot.Position - pos).Magnitude <= range then
                table.insert(near, player)
            end
        end
    end
    return near
end

function Auras.ToggleLaunchAura(state, radius)
    Auras.LaunchAura.enabled = state
    Auras.LaunchAura.radius = radius or Auras.LaunchAura.radius or 30

    if state then
        if Auras.LaunchAura.loopThread then task.cancel(Auras.LaunchAura.loopThread) end
        Auras.LaunchAura.loopThread = task.spawn(function()
            while Auras.LaunchAura.enabled do
                pcall(function()
                    local targets = Auras.GetNearbyPlayers(Auras.LaunchAura.radius)
                    for _, player in ipairs(targets) do
                        local root = Shared.GetRoot(player)
                        if root then
                            -- guaranteed order: RagdollRemote(target, 0) fires BEFORE SetNetworkOwner
                            Shared.TransferOwnership(root, root.CFrame)
                            root.AssemblyLinearVelocity = Vector3.new(0, 200, 0)
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
        Shared.Notify("Auras", "Launch Aura Enabled", 2)
    else
        if Auras.LaunchAura.loopThread then
            task.cancel(Auras.LaunchAura.loopThread)
            Auras.LaunchAura.loopThread = nil
        end
        Shared.Notify("Auras", "Launch Aura Disabled", 2)
    end
end

function Auras.ToggleTelekinesisAura(state, radius)
    Auras.TelekinesisAura.enabled = state
    Auras.TelekinesisAura.radius = radius or Auras.TelekinesisAura.radius or 30

    if state then
        if Auras.TelekinesisAura.loopThread then task.cancel(Auras.TelekinesisAura.loopThread) end
        Auras.TelekinesisAura.loopThread = task.spawn(function()
            while Auras.TelekinesisAura.enabled do
                pcall(function()
                    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                    if not myRoot then return end
                    local targets = Auras.GetNearbyPlayers(Auras.TelekinesisAura.radius)
                    for _, player in ipairs(targets) do
                        local root = Shared.GetRoot(player)
                        if root then
                            Shared.SetNetworkOwner(root, root.CFrame)
                            root.CFrame = myRoot.CFrame * CFrame.new(0, 2, -7)
                            root.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
        Shared.Notify("Auras", "Telekinesis Aura Enabled", 2)
    else
        if Auras.TelekinesisAura.loopThread then
            task.cancel(Auras.TelekinesisAura.loopThread)
            Auras.TelekinesisAura.loopThread = nil
        end
        Shared.Notify("Auras", "Telekinesis Aura Disabled", 2)
    end
end

function Auras.ToggleDeathAura(state, radius)
    Auras.DeathAura.enabled = state
    Auras.DeathAura.radius = radius or Auras.DeathAura.radius or 30

    if state then
        if Auras.DeathAura.loopThread then task.cancel(Auras.DeathAura.loopThread) end
        Auras.DeathAura.loopThread = task.spawn(function()
            while Auras.DeathAura.enabled do
                pcall(function()
                    local targets = Auras.GetNearbyPlayers(Auras.DeathAura.radius)
                    for _, player in ipairs(targets) do
                        local root = Shared.GetRoot(player)
                        if root then
                            Shared.SetNetworkOwner(root, root.CFrame)
                            root.AssemblyLinearVelocity = Vector3.new(0, -1e6, 0)
                            root.CFrame = CFrame.new(root.Position.X, -3000, root.Position.Z)
                        end
                    end
                end)
                task.wait(0.3)
            end
        end)
        Shared.Notify("Auras", "Death Aura Enabled ☠️", 2)
    else
        if Auras.DeathAura.loopThread then
            task.cancel(Auras.DeathAura.loopThread)
            Auras.DeathAura.loopThread = nil
        end
        Shared.Notify("Auras", "Death Aura Disabled", 2)
    end
end

function Auras.ToggleDualKickAura(state, radius)
    Auras.DualKickAura.enabled = state
    Auras.DualKickAura.radius = radius or Auras.DualKickAura.radius or 30

    if state then
        if Auras.DualKickAura.loopThread then task.cancel(Auras.DualKickAura.loopThread) end
        Auras.DualKickAura.loopThread = task.spawn(function()
            while Auras.DualKickAura.enabled do
                pcall(function()
                    local targets = Auras.GetNearbyPlayers(Auras.DualKickAura.radius)
                    local myToys = Shared.GetToyFolder(Shared.LocalPlayer)
                    local blob = myToys and myToys:FindFirstChild("CreatureBlobman")
                    for _, player in ipairs(targets) do
                        local root = Shared.GetRoot(player)
                        if root then
                            if blob and blob:FindFirstChild("BlobmanSeatAndOwnerScript") then
                                local scriptObj = blob.BlobmanSeatAndOwnerScript
                                local grab = scriptObj:FindFirstChild("CreatureGrab")
                                local drop = scriptObj:FindFirstChild("CreatureDrop")
                                local leftDet = blob:FindFirstChild("LeftDetector")
                                local rightDet = blob:FindFirstChild("RightDetector")
                                if grab and drop and leftDet and rightDet then
                                    grab:FireServer(leftDet, root, leftDet:FindFirstChild("LeftWeld"))
                                    drop:FireServer(leftDet:FindFirstChild("LeftWeld"), root)
                                    grab:FireServer(rightDet, root, rightDet:FindFirstChild("RightWeld"))
                                    drop:FireServer(rightDet:FindFirstChild("RightWeld"), root)
                                end
                            else
                                Shared.SetNetworkOwner(root, root.CFrame)
                                root.AssemblyLinearVelocity = Vector3.new(math.random(-1e5, 1e5), 2e5, math.random(-1e5, 1e5))
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
        Shared.Notify("Auras", "Dual Hand Kick Aura Enabled 🥊", 2)
    else
        if Auras.DualKickAura.loopThread then
            task.cancel(Auras.DualKickAura.loopThread)
            Auras.DualKickAura.loopThread = nil
        end
        Shared.Notify("Auras", "Dual Hand Kick Aura Disabled", 2)
    end
end

-- Fling Aura: launches nearby enemies in random directions at extreme speed
function Auras.ToggleFlingAura(state, radius)
    Auras.FlingAura.enabled = state
    Auras.FlingAura.radius = radius or Auras.FlingAura.radius or 30

    if state then
        if Auras.FlingAura.loopThread then task.cancel(Auras.FlingAura.loopThread) end
        Auras.FlingAura.loopThread = task.spawn(function()
            while Auras.FlingAura.enabled do
                pcall(function()
                    local targets = Auras.GetNearbyPlayers(Auras.FlingAura.radius)
                    for _, player in ipairs(targets) do
                        local root = Shared.GetRoot(player)
                        if root then
                            Shared.SetNetworkOwner(root, root.CFrame)
                            local angle = math.rad(math.random(0, 360))
                            root.AssemblyLinearVelocity = Vector3.new(
                                math.cos(angle) * 250,
                                math.random(150, 300),
                                math.sin(angle) * 250
                            )
                            root.AssemblyAngularVelocity = Vector3.new(
                                math.random(-60, 60),
                                math.random(-60, 60),
                                math.random(-60, 60)
                            )
                        end
                    end
                end)
                task.wait(0.25)
            end
        end)
        Shared.Notify("Auras", "Fling Aura Enabled - enemies get randomly flung", 2)
    else
        if Auras.FlingAura.loopThread then
            task.cancel(Auras.FlingAura.loopThread)
            Auras.FlingAura.loopThread = nil
        end
        Shared.Notify("Auras", "Fling Aura Disabled", 2)
    end
end

function Auras.ToggleRemoveAntiKickAura(state, radius)
    Auras.RemoveAntiKickAura.enabled = state
    Auras.RemoveAntiKickAura.radius = radius or Auras.RemoveAntiKickAura.radius or 30

    if state then
        if Auras.RemoveAntiKickAura.connection then Auras.RemoveAntiKickAura.connection:Disconnect() end
        Auras.RemoveAntiKickAura.connection = Shared.RunService.Heartbeat:Connect(function()
            local myRoot = Shared.GetRoot(Shared.LocalPlayer)
            if not myRoot then return end

            for _, target in ipairs(Shared.Players:GetPlayers()) do
                if target ~= Shared.LocalPlayer and not Auras.IsWhitelisted(target) then
                    local tRoot = Shared.GetRoot(target)
                    if tRoot and (tRoot.Position - myRoot.Position).Magnitude <= Auras.RemoveAntiKickAura.radius then
                        local spawned = Shared.GetToyFolder(target)
                        if spawned then
                            for _, toyName in ipairs({"NinjaKunai", "NinjaShuriken", "AntiKick", "ToolPencil", "ToolPickaxe"}) do
                                local toy = spawned:FindFirstChild(toyName)
                                if toy then
                                    local part = toy:FindFirstChild("SoundPart") or toy:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        Shared.SetNetworkOwner(part, part.CFrame)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        Shared.Notify("Auras", "Remove Anti-Kick Aura Enabled", 2)
    else
        if Auras.RemoveAntiKickAura.connection then
            Auras.RemoveAntiKickAura.connection:Disconnect()
            Auras.RemoveAntiKickAura.connection = nil
        end
        Shared.Notify("Auras", "Remove Anti-Kick Aura Disabled", 2)
    end
end

return Auras
