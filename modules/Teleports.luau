local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Teleports = {}

Teleports.Houses = {
    {"Pink House", CFrame.new(-491, -7, -166)},
    {"Green House", CFrame.new(-535, -7, 93)},
    {"Purple House", CFrame.new(250, -6, 463)},
    {"China House", CFrame.new(554, 123, -72)},
    {"Blue House", CFrame.new(510, 83, -339)},
    {"Spawn", CFrame.new(3, -7, -2)},
    {"Train Station", CFrame.new(-210, 60, -420)},
    {"High Mountain", CFrame.new(700, 320, -600)},
    {"Sky Safe Base", CFrame.new(0, 500, 0)},
    {"Void", CFrame.new(0, -250, 0)},
    {"Secret Cave", CFrame.new(-620, -40, 300)},
}

-- Click TP: left-click teleports you to the mouse hit point
Teleports.ClickTP = { enabled = false, connection = nil }

function Teleports.ToggleClickTP(state)
    Teleports.ClickTP.enabled = state
    if state then
        if Teleports.ClickTP.connection then Teleports.ClickTP.connection:Disconnect() end
        Teleports.ClickTP.connection = Shared.UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                pcall(function()
                    local mouse = Shared.LocalPlayer:GetMouse()
                    if mouse.Hit then
                        local root = Shared.GetRoot(Shared.LocalPlayer)
                        if root then
                            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                        end
                    end
                end)
            end
        end)
        Shared.Notify("Click TP", "Enabled - click anywhere to teleport", 2)
    else
        if Teleports.ClickTP.connection then
            Teleports.ClickTP.connection:Disconnect()
            Teleports.ClickTP.connection = nil
        end
        Shared.Notify("Click TP", "Disabled", 2)
    end
end

-- Teleport to a player by name
function Teleports.TeleportToPlayer(player)
    if typeof(player) == "string" then
        player = Shared.Players:FindFirstChild(player)
    end
    if not player then
        Shared.Notify("Teleport", "Player not found!", 2)
        return
    end
    local root = Shared.GetRoot(player)
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    if root and myRoot then
        myRoot.CFrame = root.CFrame * CFrame.new(0, 0, 3)
        Shared.Notify("Teleport", "Teleported to " .. player.Name, 2)
    end
end

-- Plot bases teleport (Plot1..Plot5, dynamic lookup)
function Teleports.GetPlotCFrames()
    local result = {}
    pcall(function()
        local plots = Shared.Workspace:FindFirstChild("Plots")
        if plots then
            for i = 1, 12 do
                local plot = plots:FindFirstChild("Plot" .. i)
                if plot then
                    local base = plot:FindFirstChild("PlotArea") or plot:FindFirstChildOfClass("BasePart") or plot.PrimaryPart
                    if base then
                        table.insert(result, { "Plot " .. i, base.CFrame * CFrame.new(0, 5, 0) })
                    end
                end
            end
        end
    end)
    return result
end

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
    base.Position = Vector3.new(root.Position.X, 500, root.Position.Z)
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
