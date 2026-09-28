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

return Misc
