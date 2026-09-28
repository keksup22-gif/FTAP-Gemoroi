local Shared = {}

-- Services
Shared.Players = game:GetService("Players")
Shared.RunService = game:GetService("RunService")
Shared.UserInputService = game:GetService("UserInputService")
Shared.ReplicatedStorage = game:GetService("ReplicatedStorage")
Shared.Workspace = game:GetService("Workspace")
Shared.CoreGui = game:GetService("CoreGui")
Shared.TweenService = game:GetService("TweenService")
Shared.Lighting = game:GetService("Lighting")
Shared.TextService = game:GetService("TextService")
Shared.SoundService = game:GetService("SoundService")
Shared.TeleportService = game:GetService("TeleportService")
Shared.HttpService = game:GetService("HttpService")
Shared.StarterGui = game:GetService("StarterGui")
Shared.Debris = game:GetService("Debris")

Shared.LocalPlayer = Shared.Players.LocalPlayer
Shared.Camera = Shared.Workspace.CurrentCamera
Shared.Mouse = Shared.LocalPlayer:GetMouse()

-- GemoroiUI Reference (set by main loader)
Shared.GemoroiUI = nil
-- Legacy Fluent reference (aliased to GemoroiUI for backward compatibility)
Shared.Fluent = nil

-- Core FTAP Remotes Cache
Shared.Remotes = {
    SetNetworkOwner = nil,
    StickyEvent = nil,
    DestroyToy = nil,
    Struggle = nil,
    CreateGrabLine = nil,
    DestroyGrabLine = nil,
    SetLineColor = nil,
    SpawnToyRemote = nil,
    RagdollRemote = nil
}

function Shared.InitRemotes()
    local RS = Shared.ReplicatedStorage
    pcall(function()
        local ge = RS:WaitForChild("GrabEvents", 3)
        if ge then
            Shared.Remotes.SetNetworkOwner = ge:FindFirstChild("SetNetworkOwner")
            Shared.Remotes.CreateGrabLine = ge:FindFirstChild("CreateGrabLine")
            Shared.Remotes.DestroyGrabLine = ge:FindFirstChild("DestroyGrabLine")
        end
    end)
    pcall(function()
        local pe = RS:WaitForChild("PlayerEvents", 3)
        if pe then
            Shared.Remotes.StickyEvent = pe:FindFirstChild("StickyPartEvent")
        end
    end)
    pcall(function()
        local mt = RS:WaitForChild("MenuToys", 3)
        if mt then
            Shared.Remotes.DestroyToy = mt:FindFirstChild("DestroyToy")
            Shared.Remotes.SpawnToyRemote = mt:FindFirstChild("SpawnToyRemoteFunction")
        end
    end)
    pcall(function()
        local ce = RS:WaitForChild("CharacterEvents", 3)
        if ce then
            Shared.Remotes.Struggle = ce:FindFirstChild("Struggle")
            Shared.Remotes.RagdollRemote = ce:FindFirstChild("RagdollRemote")
        end
    end)
    pcall(function()
        local de = RS:WaitForChild("DataEvents", 3)
        if de then
            Shared.Remotes.SetLineColor = de:FindFirstChild("UpdateLineColorsEvent")
        end
    end)
end

Shared.InitRemotes()

function Shared.GetRemote(name)
    if Shared.Remotes[name] then return Shared.Remotes[name] end
    for _, desc in ipairs(Shared.ReplicatedStorage:GetDescendants()) do
        if desc.Name == name and (desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction")) then
            Shared.Remotes[name] = desc
            return desc
        end
    end
    return nil
end

-- Core Remote Helper Functions
function Shared.SetNetworkOwner(part, cframe)
    if not part then return end
    local remote = Shared.Remotes.SetNetworkOwner or Shared.GetRemote("SetNetworkOwner")
    if remote then
        pcall(function()
            remote:FireServer(part, cframe or part.CFrame)
        end)
    end
end

function Shared.Struggle()
    local remote = Shared.Remotes.Struggle or Shared.GetRemote("Struggle")
    if remote then
        pcall(function()
            remote:FireServer(Shared.LocalPlayer)
        end)
    end
end

function Shared.Ragdoll(part, duration)
    local remote = Shared.Remotes.RagdollRemote or Shared.GetRemote("RagdollRemote")
    if remote and part then
        pcall(function()
            remote:FireServer(part, duration or 0)
        end)
    end
end

function Shared.SpawnToy(toyName, cframe, velocity)
    local remote = Shared.Remotes.SpawnToyRemote or Shared.GetRemote("SpawnToyRemoteFunction")
    if remote then
        local success, res = pcall(function()
            return remote:InvokeServer(toyName, cframe or CFrame.new(0, 10, 0), velocity or Vector3.zero)
        end)
        if success then return res end
    end
    return nil
end

function Shared.DestroyToy(toyInstance)
    if not toyInstance then return end
    local remote = Shared.Remotes.DestroyToy or Shared.GetRemote("DestroyToy")
    if remote then
        pcall(function()
            remote:FireServer(toyInstance)
        end)
    end
end

function Shared.StickyAttach(stickyPart, targetPart, offsetCFrame)
    if not stickyPart or not targetPart then return end
    local remote = Shared.Remotes.StickyEvent or Shared.GetRemote("StickyPartEvent")
    if remote then
        pcall(function()
            remote:FireServer(stickyPart, targetPart, offsetCFrame or CFrame.new(0, 0, 0))
        end)
    end
end

function Shared.CreateGrabLine(part, cframe)
    if not part then return end
    local remote = Shared.Remotes.CreateGrabLine or Shared.GetRemote("CreateGrabLine")
    if remote then
        pcall(function()
            remote:FireServer(part, cframe or part.CFrame)
        end)
    end
end

function Shared.DestroyGrabLine(part)
    local remote = Shared.Remotes.DestroyGrabLine or Shared.GetRemote("DestroyGrabLine")
    if remote then
        pcall(function()
            if part then
                remote:FireServer(part)
            else
                remote:FireServer()
            end
        end)
    end
end

function Shared.GetToyFolder(player)
    local target = player or Shared.LocalPlayer
    if not target then return nil end
    return Shared.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
end

-- Script Toggle Helpers
function Shared.ToggleAntiLineLag(state)
    pcall(function()
        local ps = Shared.LocalPlayer:FindFirstChild("PlayerScripts")
        local scriptObj = ps and ps:FindFirstChild("CharacterAndBeamMove")
        if scriptObj then
            scriptObj.Disabled = state
        end
    end)
end

function Shared.ToggleAntiShuriLag(state)
    pcall(function()
        local ps = Shared.LocalPlayer:FindFirstChild("PlayerScripts")
        local scriptObj = ps and ps:FindFirstChild("StickyPartsTouchDetection")
        if scriptObj then
            scriptObj.Disabled = state
        end
    end)
end

function Shared.GetCamera()
    return Shared.Workspace.CurrentCamera or Shared.Camera
end

function Shared.Notify(title, content, duration)
    pcall(function()
        local ui = Shared.GemoroiUI or Shared.Fluent
        if ui and typeof(ui.Notify) == "function" then
            ui:Notify({
                Title = tostring(title or "FTAP-Gemoroi"),
                Content = tostring(content or ""),
                Duration = duration or 3
            })
        else
            Shared.StarterGui:SetCore("SendNotification", {
                Title = tostring(title or "FTAP-Gemoroi"),
                Text = tostring(content or ""),
                Duration = duration or 3
            })
        end
    end)
end

function Shared.PlaySound(soundId, delayTime)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = 0.5
        sound.Parent = Shared.SoundService
        sound:Play()
        task.delay(delayTime or 1, function()
            if sound and sound.Parent then
                pcall(function()
                    sound:Stop()
                    sound:Destroy()
                end)
            end
        end)
    end)
end

function Shared.PlayEnableSound()
    Shared.PlaySound(6895079853, 1)
end

function Shared.PlayKickSound()
    Shared.PlaySound(79150789336480, 1)
end

function Shared.GetCharHumanoid(player)
    local targetPlayer = player or Shared.LocalPlayer
    local character = targetPlayer and targetPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

function Shared.GetRoot(player)
    local targetPlayer = player or Shared.LocalPlayer
    local char = targetPlayer and targetPlayer.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

return Shared
