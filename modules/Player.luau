local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Player = {}

-- Noclip
Player.Noclip = {
    enabled = false,
    connections = {},
    parts = {}
}

-- WalkSpeed
Player.Speed = {
    value = 16,
    enabled = false,
    connection = nil,
    charConnection = nil
}

-- Infinite Jump
Player.InfiniteJump = {
    enabled = false,
    connection = nil
}

-- Fly
Player.Fly = {
    enabled = false,
    speed = 50,
    connection = nil,
    bodyGyro = nil,
    bodyVelocity = nil
}

-- Third Person View
Player.ThirdPerson = {
    enabled = false,
    distance = 15,
    connection = nil
}

-- Spin
Player.Spin = {
    enabled = false,
    speed = 20,
    connection = nil
}

function Player.ApplySpeed(dt)
    if not Player.Speed.enabled then return end
    local char = Shared.LocalPlayer.Character
    if not char then return end
    local root = Shared.GetRoot(Shared.LocalPlayer)
    local humanoid = Shared.GetCharHumanoid(Shared.LocalPlayer)
    if not root or not humanoid then return end
    
    humanoid.WalkSpeed = Player.Speed.value
    local move = humanoid.MoveDirection
    if move.Magnitude > 0 then
        local delta = move.Unit * Player.Speed.value * dt * 0.15
        root.CFrame = root.CFrame + Vector3.new(delta.X, 0, delta.Z)
    end
end

function Player.EnableSpeed()
    Player.Speed.enabled = true
    if Player.Speed.connection then Player.Speed.connection:Disconnect() end
    Player.Speed.connection = Shared.RunService.Stepped:Connect(function(_, dt)
        Player.ApplySpeed(dt)
    end)
end

function Player.DisableSpeed()
    Player.Speed.enabled = false
    if Player.Speed.connection then
        Player.Speed.connection:Disconnect()
        Player.Speed.connection = nil
    end
    local hum = Shared.GetCharHumanoid(Shared.LocalPlayer)
    if hum then hum.WalkSpeed = 16 end
end

function Player.ToggleInfiniteJump(state)
    Player.InfiniteJump.enabled = state
    if state then
        if Player.InfiniteJump.connection then Player.InfiniteJump.connection:Disconnect() end
        Player.InfiniteJump.connection = Shared.UserInputService.JumpRequest:Connect(function()
            if Player.InfiniteJump.enabled then
                local hum = Shared.GetCharHumanoid(Shared.LocalPlayer)
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        Shared.Notify("Player", "Infinite Jump Enabled", 2)
    else
        if Player.InfiniteJump.connection then
            Player.InfiniteJump.connection:Disconnect()
            Player.InfiniteJump.connection = nil
        end
        Shared.Notify("Player", "Infinite Jump Disabled", 2)
    end
end

function Player.ToggleFly(state, speed)
    Player.Fly.enabled = state
    Player.Fly.speed = speed or Player.Fly.speed or 50

    local root = Shared.GetRoot(Shared.LocalPlayer)
    if not root then return end

    if state then
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root
        Player.Fly.bodyGyro = bg

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        Player.Fly.bodyVelocity = bv

        if Player.Fly.connection then Player.Fly.connection:Disconnect() end
        Player.Fly.connection = Shared.RunService.RenderStepped:Connect(function()
            if not Player.Fly.enabled or not root then return end
            local cam = Shared.GetCamera()
            bg.CFrame = cam.CFrame

            local moveDir = Vector3.zero
            local uis = Shared.UserInputService
            if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            bv.Velocity = moveDir * Player.Fly.speed
        end)
        Shared.Notify("Fly", "Fly Mode Enabled 🚀", 2)
    else
        if Player.Fly.connection then
            Player.Fly.connection:Disconnect()
            Player.Fly.connection = nil
        end
        if Player.Fly.bodyGyro then Player.Fly.bodyGyro:Destroy(); Player.Fly.bodyGyro = nil end
        if Player.Fly.bodyVelocity then Player.Fly.bodyVelocity:Destroy(); Player.Fly.bodyVelocity = nil end
        Shared.Notify("Fly", "Fly Mode Disabled", 2)
    end
end

function Player.ToggleNoclip(state)
    Player.Noclip.enabled = state
    if state then
        Player.Noclip.connections.stepped = Shared.RunService.Stepped:Connect(function()
            if not Player.Noclip.enabled then return end
            local char = Shared.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        Shared.Notify("Noclip", "Noclip Enabled", 2)
        Shared.PlayEnableSound()
    else
        for _, conn in pairs(Player.Noclip.connections) do
            if conn then conn:Disconnect() end
        end
        Player.Noclip.connections = {}
        Shared.Notify("Noclip", "Noclip Disabled", 2)
    end
end

function Player.DeleteLegs()
    local char = Shared.LocalPlayer.Character
    if not char then return end
    local root = Shared.GetRoot(Shared.LocalPlayer)
    
    Shared.Workspace.FallenPartsDestroyHeight = -1000
    pcall(function()
        for _, partName in ipairs({"Left Leg", "Right Leg", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}) do
            local limb = char:FindFirstChild(partName)
            if limb then
                for _, child in ipairs(limb:GetChildren()) do
                    if child:IsA("JointInstance") or child:IsA("Weld") or child:IsA("Motor6D") then
                        child:Destroy()
                    end
                end
                limb.CFrame = CFrame.new(0, -5000, 0)
                limb:Destroy()
            end
        end
    end)

    if root then
        Shared.Ragdoll(root, 2)
    end
    Shared.Notify("Delete Legs", "Legs removed (Hitbox Glitch Active)!", 2)
end

function Player.ToggleThirdPerson(state, distance)
    Player.ThirdPerson.enabled = state
    Player.ThirdPerson.distance = distance or Player.ThirdPerson.distance or 15

    if state then
        pcall(function()
            Shared.LocalPlayer.CameraMode = Enum.CameraMode.Classic
            Shared.LocalPlayer.CameraMinZoomDistance = Player.ThirdPerson.distance
            Shared.LocalPlayer.CameraMaxZoomDistance = Player.ThirdPerson.distance
            Shared.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        end)
        if Player.ThirdPerson.connection then Player.ThirdPerson.connection:Disconnect() end
        Player.ThirdPerson.connection = Shared.RunService.RenderStepped:Connect(function()
            if Player.ThirdPerson.enabled then
                pcall(function()
                    Shared.LocalPlayer.CameraMode = Enum.CameraMode.Classic
                    Shared.LocalPlayer.CameraMinZoomDistance = Player.ThirdPerson.distance
                    Shared.LocalPlayer.CameraMaxZoomDistance = Player.ThirdPerson.distance
                end)
            end
        end)
        Shared.Notify("3rd Person Fix", "3rd Person View Enabled - enforced via RenderStepped (" .. tostring(Player.ThirdPerson.distance) .. " studs)", 2)
    else
        if Player.ThirdPerson.connection then
            Player.ThirdPerson.connection:Disconnect()
            Player.ThirdPerson.connection = nil
        end
        pcall(function()
            Shared.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            Shared.LocalPlayer.CameraMinZoomDistance = 0.5
            Shared.LocalPlayer.CameraMaxZoomDistance = 0.5
            Shared.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end)
        Shared.Notify("3rd Person Fix", "3rd Person View Disabled - first person restored", 2)
    end
end

function Player.SetThirdPersonDistance(dist)
    Player.ThirdPerson.distance = dist
    if Player.ThirdPerson.enabled then
        pcall(function()
            Shared.LocalPlayer.CameraMinZoomDistance = dist
            Shared.LocalPlayer.CameraMaxZoomDistance = dist
        end)
    end
end

function Player.ToggleSpin(state, speed)
    Player.Spin.enabled = state
    Player.Spin.speed = speed or Player.Spin.speed or 20

    if state then
        if Player.Spin.connection then Player.Spin.connection:Disconnect() end
        Player.Spin.connection = Shared.RunService.RenderStepped:Connect(function()
            local root = Shared.GetRoot(Shared.LocalPlayer)
            if root and Player.Spin.enabled then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Player.Spin.speed), 0)
            end
        end)
        Shared.Notify("Spin", "Spin Bot Enabled 🌀", 2)
    else
        if Player.Spin.connection then
            Player.Spin.connection:Disconnect()
            Player.Spin.connection = nil
        end
        Shared.Notify("Spin", "Spin Bot Disabled", 2)
    end
end

return Player
