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

Shared.LocalPlayer = Shared.Players.LocalPlayer
Shared.Camera = Shared.Workspace.CurrentCamera
Shared.Mouse = Shared.LocalPlayer:GetMouse()

-- Fluent Reference (will be set by main loader)
Shared.Fluent = nil

function Shared.Notify(title, content, duration)
    pcall(function()
        if Shared.Fluent then
            Shared.Fluent:Notify({
                Title = title,
                Content = content,
                Duration = duration or 3
            })
        else
            warn("[" .. tostring(title) .. "] " .. tostring(content))
        end
    end)
end

function Shared.PlaySound(soundId, delayTime)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = Shared.SoundService
        sound:Play()
        task.delay(delayTime, function()
            if sound and sound.IsPlaying then
                sound:Stop()
                sound:Destroy()
            end
        end)
    end)
end

function Shared.GetCharHumanoid()
    local character = Shared.LocalPlayer and Shared.LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

function Shared.GetRoot(player)
    player = player or Shared.LocalPlayer
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

return Shared
