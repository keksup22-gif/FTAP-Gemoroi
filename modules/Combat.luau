local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Combat = {}

Combat.Config = {
    SilentAimEnabled = false,
    FOVRadius = 120,
    MaxDistance = 200,
    Hitbox = "Head",
    ShowFOV = false,
    WallCheck = true,
    FlingPower = 1,
}

Combat.FlingForces = {
    [1] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 500, 0))
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 1e5, 0)
            bv.Parent = root
            task.delay(0.5, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
    [2] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 1000, 0))
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-1e5,1e5), 2e5, math.random(-1e5,1e5))
            bv.Parent = root
            task.delay(0.5, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
    [3] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(math.random(-500,500), 500, math.random(-500,500)))
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-2e5,2e5), 5e5, math.random(-2e5,2e5))
            bv.Parent = root
            task.delay(0.5, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
    [4] = function(root)
        pcall(function()
            local bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bp.Position = root.Position + Vector3.new(0, 1e4, 0)
            bp.P = 1e4
            bp.Parent = root
            task.delay(0.3, function() pcall(function() bp:Destroy() end) end)
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 5e5, 0)
            bv.Parent = root
            task.delay(0.3, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
    [5] = function(root)
        pcall(function()
            local bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bp.Position = CFrame.new(0, 1e5, 0).Position
            bp.P = 5e4
            bp.Parent = root
            task.delay(0.3, function() pcall(function() bp:Destroy() end) end)
        end)
        pcall(function()
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bav.AngularVelocity = Vector3.new(math.random(-1e3,1e3), math.random(-1e3,1e3), math.random(-1e3,1e3))
            bav.P = 1e4
            bav.Parent = root
            task.delay(0.5, function() pcall(function() bav:Destroy() end) end)
        end)
    end,
    [6] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 50000, 0))
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 1e6, 0)
            bv.Parent = root
            task.delay(1, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
}

function Combat.FlingClosestTarget()
    local closest, dist = nil, 50
    local myRoot = Shared.GetRoot()
    if not myRoot then return end
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer then
            local root = Shared.GetRoot(player)
            if root then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < dist then
                    closest = player
                    dist = d
                end
            end
        end
    end
    if closest then
        local root = Shared.GetRoot(closest)
        if root then
            pcall(function()
                local setNetOwner = Shared.ReplicatedStorage:FindFirstChild("GrabEvents") and Shared.ReplicatedStorage.GrabEvents:FindFirstChild("SetNetworkOwner")
                if setNetOwner then
                    setNetOwner:FireServer(root, root.CFrame)
                end
            end)
            task.wait(0.05)
            local power = math.clamp(math.floor(Combat.Config.FlingPower), 1, 6)
            pcall(function()
                Combat.FlingForces[power](root)
            end)
            Shared.Notify("Fling", "Flinged " .. closest.Name .. " (Power " .. power .. ")", 2)
        end
    else
        Shared.Notify("Fling", "No player nearby to fling!", 2)
    end
end

return Combat