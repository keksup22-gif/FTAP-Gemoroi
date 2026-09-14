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

return Auras