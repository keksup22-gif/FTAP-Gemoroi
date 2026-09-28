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

Shared.LocalPlayer = Shared.Players.LocalPlayer
Shared.Camera = Shared.Workspace.CurrentCamera
Shared.Mouse = Shared.LocalPlayer:GetMouse()

-- Fluent Reference (will be set by main loader)
Shared.Fluent = nil

function Shared.GetCamera()
    return Shared.Workspace.CurrentCamera or Shared.Camera
end

function Shared.Notify(title, content, duration)
    pcall(function()
        if Shared.Fluent and typeof(Shared.Fluent.Notify) == "function" then
            Shared.Fluent:Notify({
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
