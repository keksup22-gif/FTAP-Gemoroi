local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Visuals = {}

Visuals.ESPHighlights = {}
Visuals.PCLDHighlights = {}
Visuals.ModelHighlights = {}
Visuals.ModelBillboards = {}

Visuals.Config = {
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(0, 170, 255),
    RainbowESP = false,
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    PCLD_ESPEnabled = false,
    ModelHighlightEnabled = false,
    ModelBillboardEnabled = false
}

Visuals.RainbowConnection = nil

function Visuals.ToggleRainbowESP(state)
    Visuals.Config.RainbowESP = state
    if state then
        if Visuals.RainbowConnection then Visuals.RainbowConnection:Disconnect() end
        Visuals.RainbowConnection = Shared.RunService.RenderStepped:Connect(function()
            if Visuals.Config.RainbowESP and Visuals.Config.ESPEnabled then
                local hue = (tick() % 5) / 5
                local rainbowColor = Color3.fromHSV(hue, 1, 1)
                for _, hl in pairs(Visuals.ESPHighlights) do
                    if hl then
                        hl.FillColor = rainbowColor
                    end
                end
            end
        end)
        Shared.Notify("Visuals", "Rainbow ESP Enabled", 2)
    else
        if Visuals.RainbowConnection then
            Visuals.RainbowConnection:Disconnect()
            Visuals.RainbowConnection = nil
        end
        Shared.Notify("Visuals", "Rainbow ESP Disabled", 2)
    end
end

function Visuals.UpdatePCLDESP()
    if not Visuals.Config.PCLD_ESPEnabled then
        for _, hl in pairs(Visuals.PCLDHighlights) do
            if hl then hl:Destroy() end
        end
        Visuals.PCLDHighlights = {}
        return
    end

    for _, obj in ipairs(Shared.Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector") then
            if not Visuals.PCLDHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Name = "PCLD_ESP_Highlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = Shared.CoreGui
                Visuals.PCLDHighlights[obj] = hl
            end
        end
    end
end

function Visuals.UpdateESPHighlights()
    if not Visuals.Config.ESPEnabled then
        for _, hl in pairs(Visuals.ESPHighlights) do
            if hl then hl:Destroy() end
        end
        Visuals.ESPHighlights = {}
        return
    end

    for _, player in ipairs(Shared.Players:GetPlayers()) do
        if player ~= Shared.LocalPlayer and player.Character then
            local char = player.Character
            if not Visuals.ESPHighlights[player] and char:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Name = "FTAP_ESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Visuals.Config.ESPColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = Shared.CoreGui
                Visuals.ESPHighlights[player] = hl
            elseif Visuals.ESPHighlights[player] then
                local hl = Visuals.ESPHighlights[player]
                if hl.Adornee ~= char or not char.Parent then
                    hl:Destroy()
                    Visuals.ESPHighlights[player] = nil
                else
                    hl.FillColor = Visuals.Config.ESPColor
                end
            end
        else
            if Visuals.ESPHighlights[player] then
                Visuals.ESPHighlights[player]:Destroy()
                Visuals.ESPHighlights[player] = nil
            end
        end
    end
end

function Visuals.UpdateModelHighlights(state)
    Visuals.Config.ModelHighlightEnabled = state
    pcall(function()
        if not state then
            for model, hl in pairs(Visuals.ModelHighlights) do
                if hl then
                    pcall(function() hl:Destroy() end)
                end
            end
            Visuals.ModelHighlights = {}
        else
            for _, obj in ipairs(Shared.Workspace:GetChildren()) do
                if obj:IsA("Model") and not Shared.Players:GetPlayerFromCharacter(obj) then
                    if not Visuals.ModelHighlights[obj] or not Visuals.ModelHighlights[obj].Parent then
                        pcall(function()
                            local hl = Instance.new("Highlight")
                            hl.Name = "FTAP_Model_Highlight"
                            hl.Adornee = obj
                            hl.FillColor = Color3.fromRGB(0, 255, 170)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = Shared.CoreGui
                            Visuals.ModelHighlights[obj] = hl
                        end)
                    end
                end
            end
        end
    end)
end
function Visuals.UpdateModelBillboards(state)
    Visuals.Config.ModelBillboardEnabled = state
    pcall(function()
        if not state then
            for model, gui in pairs(Visuals.ModelBillboards) do
                if gui then
                    pcall(function() gui:Destroy() end)
                end
            end
            Visuals.ModelBillboards = {}
        else
            for _, obj in ipairs(Shared.Workspace:GetChildren()) do
                if obj:IsA("Model") and not Shared.Players:GetPlayerFromCharacter(obj) then
                    local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primaryPart and (not Visuals.ModelBillboards[obj] or not Visuals.ModelBillboards[obj].Parent) then
                        pcall(function()
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "FTAP_Model_Billboard"
                            bb.Adornee = primaryPart
                            bb.Size = UDim2.new(0, 100, 0, 50)
                            bb.StudsOffset = Vector3.new(0, 3, 0)
                            bb.AlwaysOnTop = true
                            bb.Parent = Shared.CoreGui
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = obj.Name
                            label.TextColor3 = Color3.new(1, 1, 1)
                            label.TextStrokeTransparency = 0
                            label.Parent = bb
                            
                            Visuals.ModelBillboards[obj] = bb
                        end)
                    end
                end
            end
        end
    end)
end



return Visuals