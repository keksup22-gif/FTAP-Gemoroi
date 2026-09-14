local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Auras = {}

-- Kill Aura
Auras.KillAura = {
    enabled = false,
    loopThread = nil,
    currentBlob = nil,
    spawningBlob = false,
    killCooldown = {},
    targetPlayers = {},
    lastKillTime = 0
}

-- Dual Lock Aura
Auras.DualLockAura = {
    enabled = false,
    loopThread = nil,
    currentBlob = nil,
    targetPlayer = nil,
    processedPlayers = {},
    originalBarrierState = {}
}

-- Destroy Kick Aura
Auras.DestroyKickAura = {
    enabled = false,
    loopThread = nil,
    currentBlob = nil,
    processedPlayers = {},
    spawnInterval = 0,
    isSpawning = false,
    lastSpawnTime = 0
}

-- Ragdoll Aura
Auras.RagdollAura = {
    enabled = false,
    loopThread = nil,
    ragdolledPlayers = {},
    isTeleportingPallet = false
}

-- Telekinesis Aura
Auras.TelekinesisAura = {
    enabled = false,
    loopThread = nil,
    radius = 30,
    strength = 1
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

function Auras.IsTargetAlive(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

function Auras.GetNearbyPlayers(range)
    local char = Shared.LocalPlayer.Character
    if not char then return {} end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return {} end
    local pos = root.Position
    local near = {}
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and Auras.IsTargetAlive(player) then
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

-- Remove Anti-Kick Aura
Auras.RemoveAntiKickAura = {
    enabled = false,
    radius = 30,
    connection = nil
}

function Auras.ToggleRemoveAntiKickAura(state, radius)
    Auras.RemoveAntiKickAura.enabled = state
    Auras.RemoveAntiKickAura.radius = radius or Auras.RemoveAntiKickAura.radius or 30

    if state then
        if Auras.RemoveAntiKickAura.connection then Auras.RemoveAntiKickAura.connection:Disconnect() end
        Auras.RemoveAntiKickAura.connection = Shared.RunService.Heartbeat:Connect(function()
            local myChar = Shared.LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local grabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
            local setNetOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
            if not setNetOwner then return end

            for _, target in ipairs(Shared.Players:GetPlayers()) do
                if target ~= Shared.LocalPlayer then
                    local tChar = target.Character
                    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                    if tRoot and (tRoot.Position - myRoot.Position).Magnitude <= Auras.RemoveAntiKickAura.radius then
                        local spawned = Shared.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                        if spawned then
                            for _, toyName in ipairs({"NinjaKunai", "NinjaShuriken", "AntiKick"}) do
                                local toy = spawned:FindFirstChild(toyName)
                                if toy then
                                    local part = toy:FindFirstChild("SoundPart") or toy:FindFirstChildWhichIsA("BasePart")
                                    if part then
                                        pcall(function()
                                            setNetOwner:FireServer(part, part.CFrame)
                                        end)
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