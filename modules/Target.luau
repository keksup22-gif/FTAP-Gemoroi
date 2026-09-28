local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Target = {}

Target.SelectedPlayer = nil
Target.PlayerNames = { "None" }
Target.PlayerDropDown = nil

-- Loop Kill
Target.LoopKill = {
    enabled = false,
    loopThread = nil,
    target = nil,
    delay = 0.5
}

-- Dual Hand Kick
Target.DualHandKick = {
    enabled = false,
    loopThread = nil,
    target = nil
}

function Target.RefreshPlayerList()
    Target.PlayerNames = { "None" }
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer then
            table.insert(Target.PlayerNames, player.Name)
        end
    end
    if Target.PlayerDropDown and typeof(Target.PlayerDropDown.SetValues) == "function" then
        Target.PlayerDropDown:SetValues(Target.PlayerNames)
    end
end

function Target.SetSelectedPlayer(name)
    if not name or name == "None" then
        Target.SelectedPlayer = nil
        return
    end
    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player.Name == name or player.DisplayName == name then
            Target.SelectedPlayer = player
            return
        end
    end
    Target.SelectedPlayer = nil
end

function Target.GetTarget()
    return Target.SelectedPlayer
end

function Target.StartLoopKill(target, delay)
    if not target then return end
    Target.LoopKill.enabled = true
    Target.LoopKill.target = target
    Target.LoopKill.delay = delay or 0.5
    if Target.LoopKill.loopThread then
        task.cancel(Target.LoopKill.loopThread)
    end
    Target.LoopKill.loopThread = task.spawn(function()
        while Target.LoopKill.enabled and Target.LoopKill.target do
            pcall(function()
                local char = Target.LoopKill.target.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if root then
                    Shared.SetNetworkOwner(root, root.CFrame)
                    root.AssemblyLinearVelocity = Vector3.new(0, -1e6, 0)
                    root.CFrame = CFrame.new(root.Position.X, -2000, root.Position.Z)
                end
            end)
            task.wait(Target.LoopKill.delay)
        end
    end)
    Shared.Notify("Target", "Loop Kill Started on " .. target.Name, 2)
end

function Target.StopLoopKill()
    Target.LoopKill.enabled = false
    if Target.LoopKill.loopThread then
        task.cancel(Target.LoopKill.loopThread)
        Target.LoopKill.loopThread = nil
    end
    Target.LoopKill.target = nil
    Shared.Notify("Target", "Loop Kill Stopped", 2)
end

-- Dual Hand Loop Kick (Blobman Engine)
function Target.StartDualHandLoopKick(target)
    if not target then return end
    Target.DualHandKick.enabled = true
    Target.DualHandKick.target = target
    if Target.DualHandKick.loopThread then task.cancel(Target.DualHandKick.loopThread) end
    Target.DualHandKick.loopThread = task.spawn(function()
        local myRoot = Shared.GetRoot(Shared.LocalPlayer)
        local hum = Shared.GetCharHumanoid(Shared.LocalPlayer)
        
        -- Auto-spawn Blobman if not seated
        local blob = nil
        local myToys = Shared.GetToyFolder(Shared.LocalPlayer)
        if myToys and myToys:FindFirstChild("CreatureBlobman") then
            blob = myToys.CreatureBlobman
        else
            if myRoot then
                blob = Shared.SpawnToy("CreatureBlobman", myRoot.CFrame, Vector3.zero)
                task.wait(0.5)
            end
        end

        while Target.DualHandKick.enabled and Target.DualHandKick.target do
            pcall(function()
                local tChar = Target.DualHandKick.target.Character
                local tRoot = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso"))
                if not tRoot then return end

                local blobInst = myToys and myToys:FindFirstChild("CreatureBlobman")
                if blobInst and blobInst:FindFirstChild("BlobmanSeatAndOwnerScript") then
                    local scriptObj = blobInst.BlobmanSeatAndOwnerScript
                    local grab = scriptObj:FindFirstChild("CreatureGrab")
                    local drop = scriptObj:FindFirstChild("CreatureDrop")
                    local leftDet = blobInst:FindFirstChild("LeftDetector")
                    local rightDet = blobInst:FindFirstChild("RightDetector")
                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")

                    if grab and drop and leftDet and rightDet then
                        grab:FireServer(leftDet, tRoot, leftWeld)
                        drop:FireServer(leftWeld, tRoot)
                        task.wait(0.01)
                        grab:FireServer(rightDet, tRoot, rightWeld)
                        drop:FireServer(rightWeld, tRoot)
                    end
                else
                    -- Fallback to standard NetworkOwner Fling
                    Shared.SetNetworkOwner(tRoot, tRoot.CFrame)
                    tRoot.AssemblyLinearVelocity = Vector3.new(math.random(-1e5, 1e5), 2e5, math.random(-1e5, 1e5))
                end
            end)
            task.wait(0.02)
        end
    end)
    Shared.Notify("Target", "Dual Hand Loop Kick Started on " .. target.Name .. " 🥊", 2)
end

function Target.StopDualHandLoopKick()
    Target.DualHandKick.enabled = false
    if Target.DualHandKick.loopThread then
        task.cancel(Target.DualHandKick.loopThread)
        Target.DualHandKick.loopThread = nil
    end
    Target.DualHandKick.target = nil
    Shared.Notify("Target", "Dual Hand Kick Stopped", 2)
end

-- Strip Anti-Kick from target
function Target.StripAntiKick(target)
    if not target then return end
    pcall(function()
        local toys = Shared.GetToyFolder(target)
        if toys then
            for _, item in ipairs(toys:GetChildren()) do
                for _, name in ipairs({ "NinjaKunai", "NinjaShuriken", "AntiKick", "ToolPencil", "ToolPickaxe" }) do
                    if item.Name == name then
                        local soundPart = item:FindFirstChild("SoundPart") or item:FindFirstChildWhichIsA("BasePart")
                        if soundPart then
                            Shared.SetNetworkOwner(soundPart, soundPart.CFrame)
                        end
                    end
                end
            end
        end
    end)
    Shared.Notify("Target", "Stripped Anti-Kick from " .. target.Name, 2)
end

return Target
