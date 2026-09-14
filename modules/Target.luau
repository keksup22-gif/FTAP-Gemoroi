local Shared = require(script.Parent.Shared)
local Target = {}

Target.SelectedPlayer = nil
Target.PlayerNames = { "None" }

Target.PlayerDropDown = nil

function Target.RefreshPlayerList()
    Target.PlayerNames = { "None" }
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer then
            table.insert(Target.PlayerNames, player.Name)
        end
    end
    if Target.PlayerDropDown then
        Target.PlayerDropDown:SetValues(Target.PlayerNames)
    end
end

function Target.SetSelectedPlayer(name)
    if name == "None" then
        Target.SelectedPlayer = nil
        return
    end
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player.Name == name then
            Target.SelectedPlayer = player
            break
        end
    end
end

function Target.GetTarget()
    return Target.SelectedPlayer
end

-- Loop Kill
Target.LoopKill = {
    enabled = false,
    loopThread = nil,
    target = nil,
    delay = 0.5
}

function Target.StartLoopKill(target, delay)
    if not target then return end
    Target.LoopKill.enabled = true
    Target.LoopKill.target = target
    Target.LoopKill.delay = delay or 0.5
    Target.LoopKill.loopThread = task.spawn(function()
        while Target.LoopKill.enabled and Target.LoopKill.target do
            local char = Target.LoopKill.target.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
            task.wait(Target.LoopKill.delay)
        end
    end)
end

function Target.StopLoopKill()
    Target.LoopKill.enabled = false
    if Target.LoopKill.loopThread then
        task.cancel(Target.LoopKill.loopThread)
        Target.LoopKill.loopThread = nil
    end
    Target.LoopKill.target = nil
end

-- Loop Ragdoll
Target.LoopRagdoll = {
    enabled = false,
    loopThread = nil,
    target = nil,
    pallet = nil
}

-- Remove Anti-Kick
Target.RemoveAntiKick = {
    enabled = false,
    loopThread = nil,
    targetPlayer = nil
}

-- Anti Input Lag Removal
Target.RemoveAntiInputLag = {
    enabled = false,
    loopThread = nil,
    targetPlayer = nil
}

return Target