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
    min = 16,
    max = 10000,
    enabled = false,
    originalWalkSpeed = nil,
    connection = nil,
    charConnection = nil
}

function Player.ApplySpeed(dt)
    if not Player.Speed.enabled then
        return
    end
    local character = Shared.LocalPlayer.Character
    if not character then
        return
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then
        return
    end
    humanoid.WalkSpeed = Player.Speed.value
    local move = humanoid.MoveDirection
    if move.Magnitude > 0 then
        local delta = move.Unit * Player.Speed.value * dt * 0.1
        root.CFrame = root.CFrame + Vector3.new(delta.X, 0, delta.Z)
    end
end

function Player.EnableSpeed()
    if Player.Speed.enabled then
        return
    end
    local humanoid = Shared.GetCharHumanoid()
    if humanoid then
        Player.Speed.originalWalkSpeed = humanoid.WalkSpeed
    end
    Player.Speed.enabled = true
    if Player.Speed.connection then
        Player.Speed.connection:Disconnect()
        Player.Speed.connection = nil
    end
    Player.Speed.connection = Shared.RunService.Stepped:Connect(function(_, dt)
        Player.ApplySpeed(dt)
    end)
    if Player.Speed.charConnection then
        Player.Speed.charConnection:Disconnect()
    end
    Player.Speed.charConnection = Shared.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Player.Speed.enabled then
            Player.EnableSpeed()
        end
    end)
end

function Player.DisableSpeed()
    Player.Speed.enabled = false
    if Player.Speed.connection then
        Player.Speed.connection:Disconnect()
        Player.Speed.connection = nil
    end
    if Player.Speed.charConnection then
        Player.Speed.charConnection:Disconnect()
        Player.Speed.charConnection = nil
    end
    local humanoid = Shared.GetCharHumanoid()
    if humanoid then
        humanoid.WalkSpeed = Player.Speed.originalWalkSpeed
    end
end
local function IsInputLagItem(name)
    local items = {
        "NinjaShuriken", "NinjaKunai", "ToolPencil", "ToolPickaxe",
        "ToolDiggingForkRusty", "ToolCleaver", "NinjaKatana"
    }
    for _, item in ipairs(items) do
        if name == item then return true end
    end
    return false
end

function Player.ToggleNoclip(state)
    if state then
        Player.Noclip.enabled = true
        Player.Noclip.connections.stepped = Shared.RunService.Stepped:Connect(function()
            if not Player.Noclip.enabled then return end
            for _, player in ipairs(Shared.Players:GetPlayers()) do
                if player ~= Shared.LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    local folder = Shared.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            if toy:IsA("Model") and not IsInputLagItem(toy.Name) then
                                for _, part in ipairs(toy:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        Player.Noclip.connections.playerAdded = Shared.Players.PlayerAdded:Connect(function(player)
            if not Player.Noclip.enabled or player == Shared.LocalPlayer then return end
            Player.Noclip.parts[player] = {}
            player.CharacterAdded:Connect(function(character)
                if Player.Noclip.enabled then
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end)

        Player.Noclip.connections.periodicCheck = task.spawn(function()
            while Player.Noclip.enabled do
                for _, player in ipairs(Shared.Players:GetPlayers()) do
                    if player ~= Shared.LocalPlayer and player.Character then
                        for _, part in ipairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                        local folder = Shared.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                        if folder then
                            for _, toy in ipairs(folder:GetChildren()) do
                                if toy:IsA("Model") and not IsInputLagItem(toy.Name) then
                                    for _, part in ipairs(toy:GetDescendants()) do
                                        if part:IsA("BasePart") and part.CanCollide then
                                            part.CanCollide = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
        Shared.Notify("Noclip", "Enabled - Noclip through players/items", 2)
        Shared.PlayEnableSound()
    else
        Player.Noclip.enabled = false
        for _, conn in pairs(Player.Noclip.connections) do
            if conn then
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                else
                    task.cancel(conn)
                end
            end
        end
        Player.Noclip.connections = {}
        Player.Noclip.parts = {}
        Shared.Notify("Noclip", "Disabled", 2)
    end
end

function Player.DeleteLegs()
    local lp = Shared.LocalPlayer
    local char = lp.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local ragdollRemote = Shared.ReplicatedStorage:FindFirstChild("CharacterEvents") and Shared.ReplicatedStorage.CharacterEvents:FindFirstChild("RagdollRemote")
    
    if not char or not ragdollRemote then return end
    if not (char:FindFirstChild("Left Leg")) then
        Shared.Notify("Delete Legs", "Error: Missing body parts", 3)
        return
    end
    
    local torso = char:FindFirstChild("Torso")
    Shared.Workspace.FallenPartsDestroyHeight = -100
    Shared.Notify("Delete Legs", "Deleting legs...", 3)
    Shared.PlayEnableSound()
    
    ragdollRemote:FireServer(root, 2)
    task.wait(0.5)
    if char:FindFirstChild("Right Leg") then char["Right Leg"].CFrame = CFrame.new(0, -10000, 0) end
    if char:FindFirstChild("Left Leg") then char["Left Leg"].CFrame = CFrame.new(0, -10000, 0) end
    task.wait(0.3)
    if torso then torso.CFrame = CFrame.new(0, -9970, 0) end
    task.wait(0.5)
    if torso then
        local grab = torso.CFrame
        torso.CFrame = grab
    end
end



return Player