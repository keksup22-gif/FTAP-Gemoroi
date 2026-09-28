local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Misc = {}

-- Break House Barriers
Misc.BreakBarriers = {
    enabled = false,
    connection = nil
}

function Misc.ToggleBreakBarriers(state)
    Misc.BreakBarriers.enabled = state
    if state then
        if Misc.BreakBarriers.connection then Misc.BreakBarriers.connection:Disconnect() end
        Misc.BreakBarriers.connection = Shared.RunService.RenderStepped:Connect(function()
            local plots = Shared.Workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    local barrier = plot:FindFirstChild("Barrier")
                    if barrier then
                        for _, part in ipairs(barrier:GetChildren()) do
                            if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end)
    else
        if Misc.BreakBarriers.connection then
            Misc.BreakBarriers.connection:Disconnect()
            Misc.BreakBarriers.connection = nil
        end
    end
end

-- Figure Grab Poses
Misc.FigurePresets = {
    Pose1 = {HoldPosition={X=0,Y=0,Z=-7.5},HoldRotation={X=90,Y=0,Z=108}},
    Pose2 = {HoldPosition={X=0,Y=-1.5,Z=-12.5},HoldRotation={X=272,Y=0,Z=0}},
    Pose3 = {HoldPosition={X=0,Y=-5.5,Z=-4},HoldRotation={X=0,Y=0,Z=0}},
    Pose4 = {HoldPosition={X=1.5,Y=-8.5,Z=-1.5},HoldRotation={X=0,Y=0,Z=0}},
    Pose5 = {HoldPosition={X=0,Y=-3,Z=-6},HoldRotation={X=270,Y=0,Z=0}},
    Pose6 = {HoldPosition={X=5.5,Y=0.5,Z=-1.5},HoldRotation={X=345,Y=39,Z=0}},
    Pose7 = {HoldPosition={X=0,Y=-2,Z=-10},HoldRotation={X=90,Y=0,Z=0}},
    JojoStand = {HoldPosition={X=-4.5,Y=0.5,Z=-1.5},HoldRotation={X=8,Y=349,Z=0}}
}

function Misc.ApplyFigurePose(presetName, targetCharacter)
    local preset = Misc.FigurePresets[presetName]
    if not preset or not targetCharacter then return end

    local targetTorso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso") or targetCharacter:FindFirstChild("HumanoidRootPart")
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    if not myRoot or not targetTorso then return end

    Shared.SetNetworkOwner(targetTorso, targetTorso.CFrame)
    local holdCFrame = myRoot.CFrame * CFrame.new(preset.HoldPosition.X, preset.HoldPosition.Y, preset.HoldPosition.Z) *
        CFrame.Angles(math.rad(preset.HoldRotation.X), math.rad(preset.HoldRotation.Y), math.rad(preset.HoldRotation.Z))

    targetTorso.CFrame = holdCFrame
    Shared.Notify("Figure Pose", "Applied pose: " .. presetName, 2)
end

-- Spawn Gucci Blobman / Vehicle
function Misc.SpawnGucciBlobman()
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    if not myRoot then return end
    local toy = Shared.SpawnToy("CreatureBlobman", myRoot.CFrame * CFrame.new(0, 3, 0), Vector3.zero)
    Shared.Notify("Misc", "Spawned Creature Blobman 👾", 2)
end

-- ============================================================================
-- AUTO SPIN SLOTS (XOCU method) - GemoroiUI v3.5
-- Auto-spins the slot machine whenever its timer hits 0:00:
-- teleport to the handle, take network ownership, spin it, teleport back.
-- ============================================================================

Misc.Slots = {
    enabled = false,
    thread = nil,
    slotHandle = nil,
    timeText = nil,
    teleportPosition = Vector3.new(-224.941177, 91.364975, 425.75116)
}

function Misc.ResolveSlotsRefs()
    pcall(function()
        local slotsFolder = Shared.Workspace:FindFirstChild("Slots")
        local slotsModel = slotsFolder and slotsFolder:FindFirstChild("Slots")
        if not slotsModel then
            return
        end
        local handleModel = slotsModel:FindFirstChild("SlotHandle")
        Misc.Slots.slotHandle = handleModel and handleModel:FindFirstChild("Handle")
        local screen = slotsModel:FindFirstChild("Screen")
        local slotGui = screen and screen:FindFirstChild("SlotGui")
        local timeFrame = slotGui and slotGui:FindFirstChild("TimeLeftFrame")
        Misc.Slots.timeText = timeFrame and timeFrame:FindFirstChild("TimeText")
    end)
end

function Misc.GetSlotTime()
    if not Misc.Slots.timeText or not Misc.Slots.timeText.Parent then
        Misc.ResolveSlotsRefs()
    end
    if Misc.Slots.timeText then
        return Misc.Slots.timeText.Text
    end
    return nil
end

function Misc.CheckSlotTime()
    local timeText = Misc.GetSlotTime()
    if timeText then
        Shared.Notify("Slot Time", "Time left: " .. tostring(timeText), 3)
    else
        Shared.Notify("Slot Time", "Slot machine not found on this server!", 3)
    end
end

function Misc.TeleportToSlots()
    local root = Shared.GetRoot(Shared.LocalPlayer)
    if root then
        root.CFrame = CFrame.new(Misc.Slots.teleportPosition)
        Shared.Notify("Teleport", "Teleported to the Slots machine", 2)
    end
end

function Misc.ToggleAutoSpinSlots(state)
    Misc.Slots.enabled = state
    if state then
        Misc.ResolveSlotsRefs()
        Misc.Slots.thread = task.spawn(function()
            while Misc.Slots.enabled do
                task.wait(1)
                pcall(function()
                    local root = Shared.GetRoot(Shared.LocalPlayer)
                    if not root then
                        return
                    end
                    local timeText = Misc.GetSlotTime()
                    if timeText == "0:00" and Misc.Slots.slotHandle then
                        local savedCF = root.CFrame
                        root.CFrame = CFrame.new(Misc.Slots.teleportPosition)
                        task.wait(1)
                        Shared.SetNetworkOwner(Misc.Slots.slotHandle, CFrame.new(Misc.Slots.teleportPosition))
                        task.wait(1)
                        if root and root.Parent then
                            root.CFrame = savedCF
                        end
                    end
                end)
            end
        end)
        Shared.Notify("Slots", "Auto Spin Slots Enabled - spinning when timer hits 0:00", 3)
        Shared.PlayEnableSound()
    else
        if Misc.Slots.thread then
            task.cancel(Misc.Slots.thread)
            Misc.Slots.thread = nil
        end
        Shared.Notify("Slots", "Auto Spin Slots Disabled", 2)
    end
end

return Misc
