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

return Misc