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
        Misc.BreakBarriers.connection = Shared.RunService.RenderStepped:Connect(function()
            for _, plot in ipairs(Shared.Workspace.Plots:GetChildren()) do
                local barrier = plot:FindFirstChild("Barrier")
                if barrier then
                    for _, part in ipairs(barrier:GetChildren()) do
                        if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                            part.CanCollide = false
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

-- Loop Explode
Misc.LoopExplode = {
    enabled = false,
    loopThread = nil,
    bombType = "Bomb",
    count = 5,
    interval = 0.5,
    prediction = false,
    target = nil
}

-- Sparklers / Figures
Misc.Sparklers = {
    enabled = false,
    figure = "Planet",
    sparklers = {},
    connection = nil,
    figures = {
        "Planet", "Sphere", "Torus", "Spiral", "Heart", "Double Helix", "Galaxy"
    }
}

-- Coconuts
Misc.Coconuts = {
    enabled = false,
    mode = "Penis", -- "Penis", "Boobs"
    coconuts = {},
    connection = nil
}

-- Auto Spin Slots
Misc.AutoSpinSlots = {
    enabled = false,
    connection = nil,
    targetTime = "00:00"
}

-- Bring Train
Misc.BringTrain = {
    enabled = false,
    connection = nil
}

-- Find Closest BaseGround
Misc.FindBaseGround = {
    enabled = false,
    connection = nil
}

-- Figure Grab Poses
Misc.FigurePresets = {
    Pose1 = {HoldPosition={X=0,Y=0,Z=-7.5},HoldRotation={X=90,Y=0,Z=108},LeftArmPosition={X=-1.5,Y=1,Z=-1},LeftArmRotation={X=283,Y=0,Z=0},RightArmPosition={X=1.5,Y=0.5,Z=1},RightArmRotation={X=270,Y=0,Z=0},LeftLegPosition={X=0.5,Y=-1.5,Z=0.5},LeftLegRotation={X=312,Y=0,Z=0},RightLegPosition={X=-0.5,Y=-1.5,Z=0.5},RightLegRotation={X=283,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose2 = {HoldPosition={X=0,Y=-1.5,Z=-12.5},HoldRotation={X=272,Y=0,Z=0},LeftArmPosition={X=-1,Y=1,Z=-0.5},LeftArmRotation={X=90,Y=0,Z=0},RightArmPosition={X=1,Y=1,Z=-0.5},RightArmRotation={X=90,Y=0,Z=0},LeftLegPosition={X=1,Y=-1,Z=-0.5},LeftLegRotation={X=90,Y=0,Z=0},RightLegPosition={X=-1,Y=-1,Z=-0.5},RightLegRotation={X=90,Y=0,Z=0},HeadPosition={X=0,Y=1,Z=1},HeadRotation={X=90,Y=0,Z=0}},
    Pose3 = {HoldPosition={X=0,Y=-5.5,Z=-4},HoldRotation={X=0,Y=0,Z=0},LeftArmPosition={X=1,Y=7.5,Z=1.5},LeftArmRotation={X=0,Y=0,Z=0},RightArmPosition={X=1,Y=6,Z=1.5},RightArmRotation={X=0,Y=0,Z=0},LeftLegPosition={X=0.5,Y=5,Z=1.5},LeftLegRotation={X=0,Y=0,Z=92},RightLegPosition={X=-0.5,Y=5,Z=1.5},RightLegRotation={X=0,Y=0,Z=90},HeadPosition={X=0,Y=0,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose4 = {HoldPosition={X=1.5,Y=-8.5,Z=-1.5},HoldRotation={X=0,Y=0,Z=0},LeftArmPosition={X=0,Y=0,Z=0},LeftArmRotation={X=0,Y=0,Z=0},RightArmPosition={X=0,Y=0,Z=0},RightArmRotation={X=0,Y=0,Z=0},LeftLegPosition={X=0,Y=0,Z=0},LeftLegRotation={X=0,Y=0,Z=0},RightLegPosition={X=1.5,Y=0,Z=0},RightLegRotation={X=0,Y=0,Z=0},HeadPosition={X=0,Y=9,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    Pose5 = {HoldPosition={X=0,Y=-3,Z=-6},HoldRotation={X=270,Y=0,Z=0},LeftArmPosition={X=-1,Y=0.5,Z=0},LeftArmRotation={X=180,Y=0,Z=0},RightArmPosition={X=1,Y=0.5,Z=0},RightArmRotation={X=180,Y=0,Z=0},LeftLegPosition={X=0,Y=-3,Z=0},LeftLegRotation={X=0,Y=0,Z=0},RightLegPosition={X=0,Y=-2,Z=0.5},RightLegRotation={X=45,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=-0.5},HeadRotation={X=270,Y=0,Z=0}},
    Pose6 = {HoldPosition={X=5.5,Y=0.5,Z=-1.5},HoldRotation={X=345,Y=39,Z=0},LeftArmPosition={X=2,Y=0.5,Z=0},LeftArmRotation={X=0,Y=43,Z=121},RightArmPosition={X=-2,Y=0,Z=0},RightArmRotation={X=64,Y=112,Z=0},LeftLegPosition={X=-0.5,Y=-2,Z=0},LeftLegRotation={X=349,Y=0,Z=360},RightLegPosition={X=0.5,Y=-2,Z=0},RightLegRotation={X=345,Y=360,Z=10},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=344,Z=0}},
    Pose7 = {HoldPosition={X=0,Y=-2,Z=-10},HoldRotation={X=90,Y=0,Z=0},LeftArmPosition={X=-1.5,Y=0,Z=0},LeftArmRotation={X=270,Y=0,Z=315},RightArmPosition={X=1.5,Y=0,Z=0},RightArmRotation={X=270,Y=0,Z=45},LeftLegPosition={X=-1,Y=-1.5,Z=0},LeftLegRotation={X=90,Y=0,Z=0},RightLegPosition={X=1,Y=-1.5,Z=0},RightLegRotation={X=90,Y=0,Z=0},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=0,Z=0}},
    JojoStand = {HoldPosition={X=-4.5,Y=0.5,Z=-1.5},HoldRotation={X=8,Y=349,Z=0},LeftArmPosition={X=1.5,Y=0,Z=0},LeftArmRotation={X=15,Y=62,Z=41},RightArmPosition={X=-1.5,Y=0.5,Z=-0.5},RightArmRotation={X=65,Y=149,Z=6},LeftLegPosition={X=-0.5,Y=-2,Z=0},LeftLegRotation={X=349,Y=0,Z=360},RightLegPosition={X=0.5,Y=-2,Z=0},RightLegRotation={X=345,Y=360,Z=10},HeadPosition={X=0,Y=1.5,Z=0},HeadRotation={X=0,Y=344,Z=0}}
}

function Misc.ApplyFigurePose(presetName, targetCharacter)
    local preset = Misc.FigurePresets[presetName]
    if not preset or not targetCharacter then return end

    local targetTorso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    if not myRoot or not targetTorso then return end

    local holdCFrame = myRoot.CFrame * CFrame.new(preset.HoldPosition.X, preset.HoldPosition.Y, preset.HoldPosition.Z) *
        CFrame.Angles(math.rad(preset.HoldRotation.X), math.rad(preset.HoldRotation.Y), math.rad(preset.HoldRotation.Z))

    targetTorso.CFrame = holdCFrame
    Shared.Notify("Figure Pose", "Applied pose: " .. presetName, 2)
end

return Misc