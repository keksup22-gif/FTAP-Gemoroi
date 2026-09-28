local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Server = {}

-- Server Lag / Packet Lag
Server.PacketLag = {
    enabled = false,
    loopThread = nil,
    packetSize = 100,
    minSize = 100,
    maxSize = 1000000
}

function Server.StartPacketLag()
    Server.PacketLag.enabled = true
    if Server.PacketLag.loopThread then task.cancel(Server.PacketLag.loopThread) end
    Server.PacketLag.loopThread = task.spawn(function()
        local grabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
        local extendGrab = grabEvents and grabEvents:WaitForChild("ExtendGrabLine", 5)
        if not extendGrab then return end
        while Server.PacketLag.enabled do
            local hugeString = string.rep("a", Server.PacketLag.packetSize or 100)
            pcall(function()
                extendGrab:FireServer(CFrame.new(0, 0, 0), hugeString)
            end)
            task.wait()
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

-- Line Lag
Server.LineLag = {
    enabled = false,
    loopThread = nil
}

function Server.StartLineLag()
    Server.LineLag.enabled = true
    if Server.LineLag.loopThread then task.cancel(Server.LineLag.loopThread) end
    Server.LineLag.loopThread = task.spawn(function()
        local grabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
        local createGrab = grabEvents and grabEvents:WaitForChild("CreateGrabLine", 5)
        if not createGrab then return end
        while Server.LineLag.enabled do
            pcall(function()
                createGrab:FireServer(CFrame.new(math.random(-1e9, 1e9), math.random(-1e9, 1e9), math.random(-1e9, 1e9)))
            end)
            task.wait()
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
    local grabEvents = Shared.ReplicatedStorage:WaitForChild("GrabEvents", 5)
    if not grabEvents then return end
    local createGrab = grabEvents:FindFirstChild("CreateGrabLine")
    local setOwner = grabEvents:FindFirstChild("SetNetworkOwner")
    
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer then
            local char = player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            if root then
                pcall(function()
                    if setOwner then setOwner:FireServer(root, root.CFrame) end
                    if createGrab then createGrab:FireServer(CFrame.new(0, 1e9, 0)) end
                end)
            end
        end
    end
    Shared.Notify("Server", "Destroy Server Action Triggered!", 2)
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
