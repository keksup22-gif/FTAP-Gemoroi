local Shared = require(script.Parent.Shared)
local Teleports = {}

Teleports.Houses = {
    {"Pink House", CFrame.new(-491, -7, -166)},
    {"Green House", CFrame.new(-535, -7, 93)},
    {"Purple House", CFrame.new(250, -6, 463)},
    {"China House", CFrame.new(554, 123, -72)},
    {"Blue House", CFrame.new(510, 83, -339)},
    {"Spawn", CFrame.new(3, -7, -2)}
}

Teleports.LoopTP = {
    enabled = false,
    target = CFrame.new(3, -7, -2),
    loopThread = nil
}

function Teleports.TeleportTo(cframe)
    local char = Shared.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = cframe
    end
end

function Teleports.StartLoopTP(target)
    Teleports.LoopTP.enabled = true
    Teleports.LoopTP.target = target
    Teleports.LoopTP.loopThread = task.spawn(function()
        while Teleports.LoopTP.enabled do
            local char = Shared.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and Teleports.LoopTP.target then
                root.CFrame = Teleports.LoopTP.target
            end
            task.wait()
        end
    end)
end

function Teleports.StopLoopTP()
    Teleports.LoopTP.enabled = false
    if Teleports.LoopTP.loopThread then
        task.cancel(Teleports.LoopTP.loopThread)
        Teleports.LoopTP.loopThread = nil
    end
end

return Teleports