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
    Server.PacketLag.loopThread = task.spawn(function()
        local extendGrab = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("ExtendGrabLine")
        while Server.PacketLag.enabled do
            local hugeString = string.rep("a", Server.PacketLag.packetSize)
            pcall(function()
                extendGrab:FireServer(CFrame.new(0, 0, 0), hugeString)
            end)
            task.wait()
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

-- Line Lag
Server.LineLag = {
    enabled = false,
    loopThread = nil
}

function Server.StartLineLag()
    Server.LineLag.enabled = true
    Server.LineLag.loopThread = task.spawn(function()
        local createGrab = Shared.ReplicatedStorage:WaitForChild("GrabEvents"):WaitForChild("CreateGrabLine")
        while Server.LineLag.enabled do
            pcall(function()
                createGrab:FireServer(CFrame.new(math.random(-1e9,1e9), math.random(-1e9,1e9), math.random(-1e9,1e9)))
            end)
            task.wait()
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
    
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function()
                    setOwner:FireServer(root, root.CFrame)
                end)
                pcall(function()
                    createGrab:FireServer(CFrame.new(0, 1e9, 0))
                end)
            end
        end
    end
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