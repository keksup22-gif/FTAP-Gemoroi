local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
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
    if Target.PlayerDropDown and typeof(Target.PlayerDropDown.SetValues) == "function" then
        Target.PlayerDropDown:SetValues(Target.PlayerNames)
    end
end

function Target.SetSelectedPlayer(name)
    if not name or name == "None" then
        Target.SelectedPlayer = nil
        return
    end
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player.Name == name or player.DisplayName == name then
            Target.SelectedPlayer = player
            return
        end
    end
    Target.SelectedPlayer = nil
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
    if Target.LoopKill.loopThread then
        task.cancel(Target.LoopKill.loopThread)
    end
    Target.LoopKill.loopThread = task.spawn(function()
        local grabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
        local setOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
        while Target.LoopKill.enabled and Target.LoopKill.target do
            pcall(function()
                local char = Target.LoopKill.target.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if root then
                    if setOwner then
                        setOwner:FireServer(root, root.CFrame)
                    end
                    root.AssemblyLinearVelocity = Vector3.new(0, -1e6, 0)
                    root.CFrame = CFrame.new(root.Position.X, -2000, root.Position.Z)
                end
            end)
            task.wait(Target.LoopKill.delay)
        end
    end)
    Shared.Notify("Target", "Loop Kill Started on " .. target.Name, 2)
end

function Target.StopLoopKill()
    Target.LoopKill.enabled = false
    if Target.LoopKill.loopThread then
        task.cancel(Target.LoopKill.loopThread)
        Target.LoopKill.loopThread = nil
    end
    Target.LoopKill.target = nil
    Shared.Notify("Target", "Loop Kill Stopped", 2)
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
