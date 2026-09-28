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

-- Advanced Target Functions

function Target.PerformAdvancedKick(player)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local GrabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
    local SetNetworkOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
    local DestroyGrabLine = GrabEvents and GrabEvents:FindFirstChild("DestroyGrabLine")
    
    pcall(function()
        if SetNetworkOwner then SetNetworkOwner:FireServer(root, root.CFrame) end
        if DestroyGrabLine then DestroyGrabLine:FireServer(root) end
        
        -- Rinnegan Fling-Kick
        root.CFrame = CFrame.new(0, 999999999999, 0)
        local bv = Instance.new("BodyVelocity")
        bv.Name = "RinneganFling"
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, 99999999999999, 0)
        bv.P = 12500
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.05)
    end)
    Shared.Notify("Target", "Kick command sent to " .. player.Name, 2)
end

function Target.BringTarget(player)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local myRoot = Shared.GetRoot()
    if not root or not myRoot then return end
    
    local GrabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
    local SetNetworkOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
    
    pcall(function()
        if SetNetworkOwner then SetNetworkOwner:FireServer(root, myRoot.CFrame) end
        root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
    end)
    Shared.Notify("Target", "Brought " .. player.Name, 2)
end

function Target.KillTarget(player)
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
        Shared.Notify("Target", "Killed " .. player.Name, 2)
    end
end

function Target.FreezeTarget(player)
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local GrabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
    local SetNetworkOwner = GrabEvents and GrabEvents:FindFirstChild("SetNetworkOwner")
    
    pcall(function()
        if SetNetworkOwner then SetNetworkOwner:FireServer(root, root.CFrame) end
        root.Anchored = true
        task.wait(2)
        root.Anchored = false
    end)
    Shared.Notify("Target", "Froze " .. player.Name, 2)
end

return Target