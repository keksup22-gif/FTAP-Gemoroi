local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Server = {}

-- Advanced Server Lag / Packet Lag
Server.PacketLag = {
    enabled = false,
    loopThread = nil,
    packetSize = 1000000 -- 1MB based on XOCU
}

function Server.StartPacketLag()
    Server.PacketLag.enabled = true
    if Server.PacketLag.loopThread then task.cancel(Server.PacketLag.loopThread) end
    Server.PacketLag.loopThread = task.spawn(function()
        local GrabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
        local ExtendGrabLine = GrabEvents and GrabEvents:WaitForChild("ExtendGrabLine", 5)
        if not ExtendGrabLine then return end
        while Server.PacketLag.enabled do
            pcall(function()
                ExtendGrabLine:FireServer(string.rep("A", Server.PacketLag.packetSize))
            end)
            task.wait(3e-05) -- High frequency spam
        end
    end)
    Shared.Notify("Server", "Packet Lag Enabled", 2)
end

function Server.StopPacketLag()
    Server.PacketLag.enabled = false
    if Server.PacketLag.loopThread then
        task.cancel(Server.PacketLag.loopThread)
        Server.PacketLag.loopThread = nil
    end
    Shared.Notify("Server", "Packet Lag Disabled", 2)
end

-- Advanced Line Lag
Server.LineLag = {
    enabled = false,
    loopThread = nil
}

function Server.StartLineLag()
    Server.LineLag.enabled = true
    if Server.LineLag.loopThread then task.cancel(Server.LineLag.loopThread) end
    Server.LineLag.loopThread = task.spawn(function()
        local GrabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
        local CreateGrabLine = GrabEvents and GrabEvents:WaitForChild("CreateGrabLine", 5)
        local spawnLoc = Shared.Workspace:FindFirstChild("SpawnLocation") or Shared.Workspace:FindFirstChild("Spawn") or Shared.GetRoot()
        while Server.LineLag.enabled and spawnLoc and CreateGrabLine do
            for i = 1, 500 do -- Original XOCU spam rate
                pcall(function()
                    CreateGrabLine:FireServer(spawnLoc, CFrame.new(math.random(-1e9, 1e9), math.random(-1e9, 1e9), math.random(-1e9, 1e9)))
                end)
            end
            task.wait(0.5)
        end
    end)
    Shared.Notify("Server", "Line Lag Enabled", 2)
end

function Server.StopLineLag()
    Server.LineLag.enabled = false
    if Server.LineLag.loopThread then
        task.cancel(Server.LineLag.loopThread)
        Server.LineLag.loopThread = nil
    end
    Shared.Notify("Server", "Line Lag Disabled", 2)
end

-- Destroy Server
Server.DestroyServer = {
    active = false
}

function Server.DestroyServerAction()
    local GrabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
    if not GrabEvents then return end
    local createGrab = GrabEvents:FindFirstChild("CreateGrabLine")
    local setOwner = GrabEvents:FindFirstChild("SetNetworkOwner")
    local destroyLine = GrabEvents:FindFirstChild("DestroyGrabLine")
    
    Shared.Notify("Server", "Destroying Server... (Mass Kick & Lag)", 3)
    
    task.spawn(function()
        for i = 1, 10 do -- Repeat to ensure effectiveness
            for _, player in ipairs(Shared.Players:GetPlayers()) do
                if player ~= Shared.LocalPlayer then
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        pcall(function()
                            if setOwner then setOwner:FireServer(root, root.CFrame) end
                            task.wait()
                            if destroyLine then destroyLine:FireServer(root) end
                            -- Rinnegan Fling on mass scale
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(0, math.huge, 0)
                            bv.Velocity = Vector3.new(0, 9e12, 0)
                            bv.Parent = root
                            Shared.Debris:AddItem(bv, 0.1)
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
    Shared.Notify("Server", "Rejoining current server...", 2)
    pcall(function()
        local ts = Shared.TeleportService or game:GetService("TeleportService")
        if ts then
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, Shared.LocalPlayer)
        end
    end)
end

function Server.ServerHop()
    Shared.Notify("Server", "Searching for new server...", 2)
    task.spawn(function()
        pcall(function()
            local ts = Shared.TeleportService or game:GetService("TeleportService")
            local http = Shared.HttpService or game:GetService("HttpService")
            if ts and http then
                local serversApi = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
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
    end)
end

return Server
