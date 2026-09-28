local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Misc = {}

-- Break House Barriers
Misc.BreakBarriers = {
    enabled = false,
    connection = nil
}

-- Snowball Blast: spawns a snowball burst into the plot barrier (XOCU trick)
-- before the collision removal pass
function Misc.SnowballBlast(plot)
    pcall(function()
        local barrier = plot and plot:FindFirstChild("Barrier")
        if not barrier then return end
        local base = barrier:FindFirstChildWhichIsA("BasePart")
        if not base then return end
        Shared.SpawnToy("Snowball", base.CFrame, Vector3.new(0, 50, 0))
    end)
end

function Misc.ToggleBreakBarriers(state)
    Misc.BreakBarriers.enabled = state
    if state then
        if Misc.BreakBarriers.connection then Misc.BreakBarriers.connection:Disconnect() end
        Misc.BreakBarriers.connection = Shared.RunService.RenderStepped:Connect(function()
            local plots = Shared.Workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    Misc.SnowballBlast(plot)
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

-- ============================================================================
-- FIGURE GRAB POSE PACK (from "figure grab by akirra4")
-- Simple presets use HoldPosition/HoldRotation; multi-part poses (Dog etc.)
-- use a per-limb CFrame table applied in a Heartbeat loop.
-- ============================================================================
Misc.FigurePresets = {
    Pose1 = {HoldPosition={X=0,Y=0,Z=-7.5},HoldRotation={X=90,Y=0,Z=108}},
    Pose2 = {HoldPosition={X=0,Y=-1.5,Z=-12.5},HoldRotation={X=272,Y=0,Z=0}},
    Pose3 = {HoldPosition={X=0,Y=-5.5,Z=-4},HoldRotation={X=0,Y=0,Z=0}},
    Pose4 = {HoldPosition={X=1.5,Y=-8.5,Z=-1.5},HoldRotation={X=0,Y=0,Z=0}},
    Pose5 = {HoldPosition={X=0,Y=-3,Z=-6},HoldRotation={X=270,Y=0,Z=0}},
    Pose6 = {HoldPosition={X=5.5,Y=0.5,Z=-1.5},HoldRotation={X=345,Y=39,Z=0}},
    Pose7 = {HoldPosition={X=0,Y=-2,Z=-10},HoldRotation={X=90,Y=0,Z=0}},
    JojoStand = {HoldPosition={X=-4.5,Y=0.5,Z=-1.5},HoldRotation={X=8,Y=349,Z=0}},

    -- Multi-part poses (Dog Pose Quick V1 / V2 from akirra4, applied in a loop)
    DogPoseQuickV1 = {
        Loop = true,
        Parts = {
            Torso    = { Offset = CFrame.new(0, -1, -2) * CFrame.Angles(math.rad(-90), 0, math.rad(180)) },
            Head     = { Offset = CFrame.new(0, 1, 0) * CFrame.Angles(math.rad(90), 0, 0), RelativeTo = "Torso" },
            ["Left Arm"]  = { Offset = CFrame.new(-1, 0.5, 0) * CFrame.Angles(math.rad(60), 0, math.rad(-30)), RelativeTo = "Torso" },
            ["Right Arm"] = { Offset = CFrame.new(1, 0.5, 0) * CFrame.Angles(math.rad(60), 0, math.rad(30)), RelativeTo = "Torso" },
            ["Left Leg"]  = { Offset = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(40), 0, 0), RelativeTo = "Torso" },
            ["Right Leg"] = { Offset = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(40), 0, 0), RelativeTo = "Torso" },
        }
    },
    DogPoseQuickV2 = {
        Loop = true,
        Parts = {
            Torso    = { Offset = CFrame.new(0, -1.2, -2.2) * CFrame.Angles(math.rad(-85), 0, math.rad(180)) },
            Head     = { Offset = CFrame.new(0, 1.1, 0.2) * CFrame.Angles(math.rad(85), 0, 0), RelativeTo = "Torso" },
            ["Left Arm"]  = { Offset = CFrame.new(-1.1, 0.6, -0.2) * CFrame.Angles(math.rad(70), 0, math.rad(-40)), RelativeTo = "Torso" },
            ["Right Arm"] = { Offset = CFrame.new(1.1, 0.6, -0.2) * CFrame.Angles(math.rad(70), 0, math.rad(40)), RelativeTo = "Torso" },
            ["Left Leg"]  = { Offset = CFrame.new(-0.5, -1.1, 0.3) * CFrame.Angles(math.rad(55), 0, math.rad(-10)), RelativeTo = "Torso" },
            ["Right Leg"] = { Offset = CFrame.new(0.5, -1.1, 0.3) * CFrame.Angles(math.rad(55), 0, math.rad(10)), RelativeTo = "Torso" },
        }
    },
    BangSlow = {
        Loop = true, Slow = true,
        Parts = {
            Torso    = { Offset = CFrame.new(0, -2.1, -3) * CFrame.Angles(math.rad(90), 0, 0) },
            Head     = { Offset = CFrame.new(0, 0.9, -0.4) * CFrame.Angles(math.rad(-20), 0, 0), RelativeTo = "Torso" },
            ["Left Arm"]  = { Offset = CFrame.new(-0.6, 0.4, -0.6) * CFrame.Angles(math.rad(-80), 0, math.rad(-15)), RelativeTo = "Torso" },
            ["Right Arm"] = { Offset = CFrame.new(0.6, 0.4, -0.6) * CFrame.Angles(math.rad(-80), 0, math.rad(15)), RelativeTo = "Torso" },
            ["Left Leg"]  = { Offset = CFrame.new(-0.4, -0.9, 0.1) * CFrame.Angles(math.rad(10), 0, 0), RelativeTo = "Torso" },
            ["Right Leg"] = { Offset = CFrame.new(0.4, -0.9, 0.1) * CFrame.Angles(math.rad(10), 0, 0), RelativeTo = "Torso" },
        }
    },
}

Misc.ActivePose = { loopThread = nil, name = nil, coconuts = {} }

function Misc.StopActivePose()
    if Misc.ActivePose.loopThread then
        task.cancel(Misc.ActivePose.loopThread)
        Misc.ActivePose.loopThread = nil
    end
    for _, coconut in ipairs(Misc.ActivePose.coconuts) do
        pcall(function()
            Shared.DestroyToy(coconut)
        end)
    end
    Misc.ActivePose.coconuts = {}
    Misc.ActivePose.name = nil
end

function Misc.ApplyFigurePose(presetName, targetCharacter)
    local preset = Misc.FigurePresets[presetName]
    if not preset or not targetCharacter then return end

    if preset.Parts then
        -- multi-part looped pose (Dog / Bang)
        Misc.StopActivePose()
        Misc.ActivePose.name = presetName
        Misc.ActivePose.loopThread = task.spawn(function()
            local phase = 0
            while Misc.ActivePose.name == presetName do
                pcall(function()
                    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                    if not myRoot or not targetCharacter or not targetCharacter.Parent then
                        Misc.StopActivePose()
                        return
                    end
                    local torso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso") or targetCharacter:FindFirstChild("HumanoidRootPart")
                    if not torso then return end
                    Shared.SetNetworkOwner(torso, torso.CFrame)
                    -- ghost collisions so physics does not fight the pose
                    for _, x in ipairs(targetCharacter:GetDescendants()) do
                        if x:IsA("BasePart") then
                            x.CanCollide = false
                        end
                    end
                    local hum = targetCharacter:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = math.max(hum.Health, 50)
                    end
                    phase = phase + (preset.Slow and 0.045 or 0.12)
                    local bob = math.sin(phase) * (preset.Slow and 0.55 or 0.1)
                    local base = myRoot.CFrame * CFrame.new(0, bob, 0)
                    local torsoCF = nil
                    for partName, def in pairs(preset.Parts) do
                        local part = targetCharacter:FindFirstChild(partName)
                        if part then
                            if def.RelativeTo == "Torso" and torsoCF then
                                part.CFrame = torsoCF * def.Offset
                            else
                                torsoCF = base * def.Offset
                                part.CFrame = torsoCF
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
        Shared.Notify("Figure Pose", "Applied pose: " .. presetName, 2)
        return
    end

    -- simple single-part pose
    local targetTorso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso") or targetCharacter:FindFirstChild("HumanoidRootPart")
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    if not myRoot or not targetTorso then return end

    Misc.StopActivePose()
    Shared.SetNetworkOwner(targetTorso, targetTorso.CFrame)
    local holdCFrame = myRoot.CFrame * CFrame.new(preset.HoldPosition.X, preset.HoldPosition.Y, preset.HoldPosition.Z) *
        CFrame.Angles(math.rad(preset.HoldRotation.X), math.rad(preset.HoldRotation.Y), math.rad(preset.HoldRotation.Z))

    targetTorso.CFrame = holdCFrame
    Shared.Notify("Figure Pose", "Applied pose: " .. presetName, 2)
end

-- Reset Pose: stops any active pose and restores the target
function Misc.ResetFigurePose(targetCharacter)
    Misc.StopActivePose()
    if targetCharacter then
        pcall(function()
            local hum = targetCharacter:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            for _, x in ipairs(targetCharacter:GetDescendants()) do
                if x:IsA("BasePart") then
                    x.CanCollide = true
                end
            end
        end)
    end
    Shared.Notify("Figure Pose", "Pose reset - target restored", 2)
end

-- Coconut attachments (Coconut Boobs & Ass / Coconut Penis)
function Misc.AttachCoconuts(targetCharacter, mode)
    if not targetCharacter then return end
    Misc.StopActivePose()
    local myRoot = Shared.GetRoot(Shared.LocalPlayer)
    local torso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
    if not myRoot or not torso then return end

    local offsets
    if mode == "BoobsAss" then
        offsets = {
            { CFrame.new(-0.55, 0.6, -0.45) },   -- left chest
            { CFrame.new(0.55, 0.6, -0.45) },    -- right chest
            { CFrame.new(-0.45, -0.85, 0.5) },   -- left back
            { CFrame.new(0.45, -0.85, 0.5) },    -- right back
        }
    elseif mode == "Penis" then
        offsets = {
            { CFrame.new(0, -1.15, -0.9) },
        }
    else
        return
    end

    Misc.ActivePose.name = "Coconut" .. tostring(mode)
    for _, def in ipairs(offsets) do
        local coconut = Shared.SpawnToy("FoodCoconut", torso.CFrame * def[1], Vector3.zero)
        if coconut then
            pcall(function()
                local basePart = coconut:IsA("Model") and (coconut.PrimaryPart or coconut:FindFirstChildWhichIsA("BasePart")) or coconut
                Shared.SetNetworkOwner(basePart, basePart.CFrame)
                basePart.Anchored = true
                basePart.CFrame = torso.CFrame * def[1]
                -- keep glued in a loop
                table.insert(Misc.ActivePose.coconuts, coconut)
            end)
        end
    end
    Misc.ActivePose.loopThread = task.spawn(function()
        while Misc.ActivePose.name == "Coconut" .. tostring(mode) do
            pcall(function()
                if not targetCharacter or not targetCharacter.Parent or not torso or not torso.Parent then
                    Misc.StopActivePose()
                    return
                end
                for i, coconut in ipairs(Misc.ActivePose.coconuts) do
                    if coconut and coconut.Parent then
                        local basePart = coconut:IsA("Model") and (coconut.PrimaryPart or coconut:FindFirstChildWhichIsA("BasePart")) or coconut
                        if basePart then
                            basePart.CFrame = torso.CFrame * offsets[i][1]
                        end
                    end
                end
            end)
            task.wait()
        end
    end)
    Shared.Notify("Figure Pose", "Coconuts attached (" .. mode .. ")", 2)
end

-- ============================================================================
-- TARGET LIMB CONTROLS
-- ============================================================================
-- main_modular assigns Misc.TargetCharacterProvider = function() ... end
-- so every target-based utility knows the currently selected victim.
Misc.TargetCharacterProvider = nil

local function getTargetChar()
    if type(Misc.TargetCharacterProvider) == "function" then
        local ok, char = pcall(Misc.TargetCharacterProvider)
        if ok then
            return char
        end
    end
    return nil
end

function Misc.FreezeLimbs(targetCharacter)
    targetCharacter = targetCharacter or getTargetChar()
    if not targetCharacter then Shared.Notify("Limbs", "Select a target first!", 2) return end
    pcall(function()
        for _, name in ipairs({ "Left Arm", "Right Arm", "Left Leg", "Right Leg",
            "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
            "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg" }) do
            local limb = targetCharacter:FindFirstChild(name)
            if limb then
                limb.Anchored = true
            end
        end
    end)
    Shared.Notify("Limbs", "Target limbs frozen", 2)
end

function Misc.UnfreezeLimbs(targetCharacter)
    targetCharacter = targetCharacter or getTargetChar()
    if not targetCharacter then Shared.Notify("Limbs", "Select a target first!", 2) return end
    pcall(function()
        for _, part in ipairs(targetCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end)
    Shared.Notify("Limbs", "Target limbs unfrozen", 2)
end

function Misc.RemoveLimbs(targetCharacter, mode)
    targetCharacter = targetCharacter or getTargetChar()
    if not targetCharacter then Shared.Notify("Limbs", "Select a target first!", 2) return end
    pcall(function()
        local names
        if mode == "Arms" then
            names = { "Left Arm", "Right Arm", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm" }
        else
            names = { "Left Leg", "Right Leg", "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg" }
        end
        for _, name in ipairs(names) do
            local limb = targetCharacter:FindFirstChild(name)
            if limb then
                limb:Destroy()
            end
        end
    end)
    Shared.Notify("Limbs", "Removed target " .. (mode == "Arms" and "arms" or "legs"), 2)
end

-- Mirror My Animations: copies our Motor6D transforms onto the target each frame
Misc.MirrorAnimations = { enabled = false, connection = nil }

function Misc.ToggleMirrorAnimations(state, targetCharacter)
    Misc.MirrorAnimations.enabled = state
    if state then
        targetCharacter = targetCharacter or getTargetChar()
        if not targetCharacter then
            Shared.Notify("Mirror", "Select a target first!", 2)
            return
        end
        local myChar = Shared.LocalPlayer.Character
        if not myChar then return end
        if Misc.MirrorAnimations.connection then Misc.MirrorAnimations.connection:Disconnect() end
        Misc.MirrorAnimations.connection = Shared.RunService.RenderStepped:Connect(function()
            pcall(function()
                if not targetCharacter or not targetCharacter.Parent or not myChar or not myChar.Parent then
                    return
                end
                for _, myMotor in ipairs(myChar:GetDescendants()) do
                    if myMotor:IsA("Motor6D") then
                        local theirMotor = targetCharacter:FindFirstChild(myMotor.Name, true)
                        if theirMotor and theirMotor:IsA("Motor6D") then
                            theirMotor.Transform = myMotor.Transform
                        end
                    end
                end
                local theirTorso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
                local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                if theirTorso and myRoot then
                    Shared.SetNetworkOwner(theirTorso, theirTorso.CFrame)
                end
            end)
        end)
        Shared.Notify("Mirror", "Mirroring my animations onto target", 2)
    else
        if Misc.MirrorAnimations.connection then
            Misc.MirrorAnimations.connection:Disconnect()
            Misc.MirrorAnimations.connection = nil
        end
        Shared.Notify("Mirror", "Mirror Animations disabled", 2)
    end
end

-- Face Toward Me: continuously rotates the target to face the local player
Misc.FaceTowardMe = { enabled = false, connection = nil }

function Misc.ToggleFaceTowardMe(state, targetCharacter)
    Misc.FaceTowardMe.enabled = state
    if state then
        targetCharacter = targetCharacter or getTargetChar()
        if not targetCharacter then
            Shared.Notify("Face", "Select a target first!", 2)
            return
        end
        if Misc.FaceTowardMe.connection then Misc.FaceTowardMe.connection:Disconnect() end
        Misc.FaceTowardMe.connection = Shared.RunService.RenderStepped:Connect(function()
            pcall(function()
                if not targetCharacter or not targetCharacter.Parent then return end
                local root = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso")
                local myRoot = Shared.GetRoot(Shared.LocalPlayer)
                if root and myRoot then
                    Shared.SetNetworkOwner(root, root.CFrame)
                    root.CFrame = CFrame.new(root.Position, Vector3.new(myRoot.Position.X, root.Position.Y, myRoot.Position.Z))
                end
            end)
        end)
        Shared.Notify("Face", "Target now faces me", 2)
    else
        if Misc.FaceTowardMe.connection then
            Misc.FaceTowardMe.connection:Disconnect()
            Misc.FaceTowardMe.connection = nil
        end
        Shared.Notify("Face", "Face Toward Me disabled", 2)
    end
end

-- Lock Torso Rotation: anchors the target torso orientation
Misc.LockTorso = { enabled = false, lockedCFrame = nil }

function Misc.ToggleLockTorso(state, targetCharacter)
    Misc.LockTorso.enabled = state
    targetCharacter = targetCharacter or getTargetChar()
    if state then
        if not targetCharacter then
            Shared.Notify("Torso", "Select a target first!", 2)
            return
        end
        local torso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
        if torso then
            Misc.LockTorso.lockedCFrame = torso.CFrame
            torso.Anchored = true
            Shared.Notify("Torso", "Target torso rotation locked", 2)
        end
    else
        if targetCharacter then
            local torso = targetCharacter:FindFirstChild("Torso") or targetCharacter:FindFirstChild("UpperTorso")
            if torso then
                torso.Anchored = false
            end
        end
        Shared.Notify("Torso", "Torso lock released", 2)
    end
end

-- ============================================================================
-- CHAT TROLL SPAMMER
-- ============================================================================
Misc.ChatSpam = {
    enabled = false,
    thread = nil,
    delay = 1,
    phrases = {
        "FTAP-Gemoroi on top!",
        "GemoroiUI Lime Dark Neon",
        "subscribe to keksup22",
        "get grabbed lol",
        "I love this game :3",
    },
}

function Misc.SendChat(message)
    pcall(function()
        local TCS = game:GetService("TextChatService")
        local channel = TCS.ChatInputBarConfiguration and TCS.ChatInputBarConfiguration.TargetTextChannel
        if channel then
            channel:SendAsync(message)
            return
        end
    end)
    pcall(function()
        Shared.LocalPlayer.Character:Chat(message)
    end)
end

function Misc.ToggleChatSpam(state)
    Misc.ChatSpam.enabled = state
    if state then
        Misc.ChatSpam.thread = task.spawn(function()
            local i = 1
            while Misc.ChatSpam.enabled do
                Misc.SendChat(Misc.ChatSpam.phrases[((i - 1) % #Misc.ChatSpam.phrases) + 1])
                i = i + 1
                task.wait(math.max(Misc.ChatSpam.delay, 0.5))
            end
        end)
        Shared.Notify("Chat Spam", "Enabled - trolling the chat", 2)
    else
        if Misc.ChatSpam.thread then
            task.cancel(Misc.ChatSpam.thread)
            Misc.ChatSpam.thread = nil
        end
        Shared.Notify("Chat Spam", "Disabled", 2)
    end
end

-- ============================================================================
-- NINJASHURIKEN DESYNC / CRASH (PoopHub method)
-- Spawns shurikens around the target and abuses network ownership to
-- desync / crash the target's client.
-- ============================================================================
Misc.ShurikenDesync = { enabled = false, thread = nil }

function Misc.ToggleShurikenDesync(state, targetCharacter)
    Misc.ShurikenDesync.enabled = state
    if state then
        targetCharacter = targetCharacter or getTargetChar()
        if not targetCharacter then
            Shared.Notify("Desync", "Select a target first!", 2)
            return
        end
        Misc.ShurikenDesync.thread = task.spawn(function()
            while Misc.ShurikenDesync.enabled do
                pcall(function()
                    if not targetCharacter or not targetCharacter.Parent then
                        return
                    end
                    local root = targetCharacter:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    -- burst of shurikens around the target
                    for i = 1, 4 do
                        local toy = Shared.SpawnToy("NinjaShuriken",
                            root.CFrame * CFrame.new(math.random(-3, 3), 4 + i, math.random(-3, 3)),
                            Vector3.zero)
                        if toy then
                            task.spawn(function()
                                pcall(function()
                                    local basePart = toy:IsA("Model") and (toy.PrimaryPart or toy:FindFirstChildWhichIsA("BasePart")) or toy
                                    if basePart then
                                        Shared.SetNetworkOwner(basePart, basePart.CFrame)
                                        basePart.AssemblyLinearVelocity = Vector3.new(0, -500, 0)
                                        basePart.AssemblyAngularVelocity = Vector3.new(500, 500, 500)
                                    end
                                end)
                            end)
                        end
                        task.wait(0.05)
                    end
                end)
                task.wait(0.4)
            end
        end)
        Shared.Notify("Desync", "NinjaShuriken Desync enabled on target", 2)
    else
        if Misc.ShurikenDesync.thread then
            task.cancel(Misc.ShurikenDesync.thread)
            Misc.ShurikenDesync.thread = nil
        end
        Shared.Notify("Desync", "NinjaShuriken Desync disabled", 2)
    end
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
    teleportPosition = Vector3.new(177, 91.4, 425.8), -- slot machine wheel (XOCU farm point)
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
