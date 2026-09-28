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

Combat.FovCircle = nil

local function initFovCircle()
    if Combat.FovCircle then return end
    pcall(function()
        if Drawing and typeof(Drawing.new) == "function" then
            local circle = Drawing.new("Circle")
            circle.Thickness = 1.5
            circle.NumSides = 32
            circle.Radius = Combat.Config.FOVRadius
            circle.Filled = false
            circle.Color = Color3.fromRGB(0, 170, 255)
            circle.Transparency = 0.8
            circle.Visible = false
            Combat.FovCircle = circle
        end
    end)
end

initFovCircle()

Combat.FlingForces = {
    [1] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 500, 0))
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
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-1e5, 1e5), 2e5, math.random(-1e5, 1e5))
            bv.Parent = root
            task.delay(0.5, function() pcall(function() bv:Destroy() end) end)
        end)
    end,
    [3] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(math.random(-500, 500), 500, math.random(-500, 500)))
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(math.random(-2e5, 2e5), 5e5, math.random(-2e5, 2e5))
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

            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bav.AngularVelocity = Vector3.new(math.random(-1e3, 1e3), math.random(-1e3, 1e3), math.random(-1e3, 1e3))
            bav.P = 1e4
            bav.Parent = root
            task.delay(0.5, function() pcall(function() bav:Destroy() end) end)
        end)
    end,
    [6] = function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 50000, 0))
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 1e6, 0)
            bv.Parent = root
            task.delay(1, function() pcall(function() bv:Destroy() end) end)
        end)
    end
}

function Combat.FlingTarget(player, powerOverride)
    if not player then return end
    local root = Shared.GetRoot(player)
    if not root then return end

    pcall(function()
        local grabEvents = Shared.ReplicatedStorage:FindFirstChild("GrabEvents")
        local setNetOwner = grabEvents and grabEvents:FindFirstChild("SetNetworkOwner")
        if setNetOwner then
            setNetOwner:FireServer(root, root.CFrame)
        end
    end)
    task.wait(0.05)
    local power = math.clamp(math.floor(powerOverride or Combat.Config.FlingPower or 1), 1, 6)
    pcall(function()
        if Combat.FlingForces[power] then
            Combat.FlingForces[power](root)
        end
    end)
end

function Combat.FlingClosestTarget()
    local closest, dist = nil, 50
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
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
        local power = math.clamp(math.floor(Combat.Config.FlingPower or 1), 1, 6)
        Combat.FlingTarget(closest, power)
        Shared.Notify("Fling", "Flinged " .. closest.Name .. " (Power " .. power .. ")", 2)
    else
        Shared.Notify("Fling", "No player nearby to fling!", 2)
    end
end

function Combat.GetClosestPlayerToMouse()
    local myChar = Shared.LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    local cam = Shared.GetCamera()
    if not myRoot or not cam then return nil end

    local mousePos = Shared.UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local shortestDist = Combat.Config.FOVRadius or 120

    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild(Combat.Config.Hitbox or "Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and targetPart then
                local worldDist = (targetPart.Position - myRoot.Position).Magnitude
                if worldDist <= (Combat.Config.MaxDistance or 200) then
                    local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if screenDist <= shortestDist then
                            if Combat.Config.WallCheck then
                                local rayParams = RaycastParams.new()
                                rayParams.FilterDescendantsInstances = { myChar, player.Character }
                                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                                local result = Shared.Workspace:Raycast(cam.CFrame.Position, targetPart.Position - cam.CFrame.Position, rayParams)
                                if not result then
                                    shortestDist = screenDist
                                    closestPlayer = targetPart
                                end
                            else
                                shortestDist = screenDist
                                closestPlayer = targetPart
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

function Combat.Update()
    if Combat.FovCircle then
        if Combat.Config.SilentAimEnabled and Combat.Config.ShowFOV then
            Combat.FovCircle.Position = Shared.UserInputService:GetMouseLocation()
            Combat.FovCircle.Radius = Combat.Config.FOVRadius or 120
            Combat.FovCircle.Visible = true
        else
            Combat.FovCircle.Visible = false
        end
    end

    if Combat.Config.SilentAimEnabled then
        local target = Combat.GetClosestPlayerToMouse()
        local cam = Shared.GetCamera()
        if target and cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
        end
    end
end

return Combat
