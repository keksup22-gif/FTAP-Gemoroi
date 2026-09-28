local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
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

Teleports.SafePlatform = nil

function Teleports.TeleportTo(cframe)
    local root = Shared.GetRoot(Shared.LocalPlayer)
    if root then
        root.CFrame = cframe
        Shared.StopAllVelocity()
    end
end

function Teleports.StartLoopTP(target)
    Teleports.LoopTP.enabled = true
    Teleports.LoopTP.target = target
    if Teleports.LoopTP.loopThread then task.cancel(Teleports.LoopTP.loopThread) end
    Teleports.LoopTP.loopThread = task.spawn(function()
        while Teleports.LoopTP.enabled do
            local root = Shared.GetRoot(Shared.LocalPlayer)
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

-- XOCU Safe Sky Platform
function Teleports.SpawnSafeSkyPlatform()
    local root = Shared.GetRoot(Shared.LocalPlayer)
    if not root then return end

    if Teleports.SafePlatform and Teleports.SafePlatform.Parent then
        Teleports.SafePlatform:Destroy()
    end

    local model = Instance.new("Model", Shared.Workspace)
    model.Name = "XOCU_SafePlatform"

    local base = Instance.new("Part", model)
    base.Name = "Base"
    base.Size = Vector3.new(30, 2, 30)
    base.Position = Vector3.new(root.Position.X, 1500, root.Position.Z)
    base.Anchored = true
    base.Material = Enum.Material.ForceField
    base.Color = Color3.fromRGB(180, 0, 255)
    base.Transparency = 0.3

    Teleports.SafePlatform = model
    root.CFrame = base.CFrame * CFrame.new(0, 5, 0)
    Shared.StopAllVelocity()
    Shared.Notify("Teleports", "Teleported to Safe Sky Base! ☁️", 2)
end

function Teleports.RemoveSafeSkyPlatform()
    if Teleports.SafePlatform and Teleports.SafePlatform.Parent then
        Teleports.SafePlatform:Destroy()
        Teleports.SafePlatform = nil
        Shared.Notify("Teleports", "Safe Sky Base removed", 2)
    end
end

return Teleports
