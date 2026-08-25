local Fluent = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

pcall(function()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "FTAPFluentUI" then
            v:Destroy()
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FTAPFluentUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function Fluent:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 260, 0, 60)
    NotifFrame.Position = UDim2.new(1, -280, 1, -80)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 24)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -20, 0, 26)
    DescLabel.Position = UDim2.new(0, 10, 0, 28)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = content
    DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = NotifFrame

    task.delay(duration, function()
        pcall(function() NotifFrame:Destroy() end)
    end)
end

function Fluent:CreateWindow(options)
    local WindowObj = {}
    local titleText = options.Title or "FTAP UI"
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainWindow"
    MainFrame.Size = options.Size or UDim2.fromOffset(580, 460)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -230)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 300, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 160, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = Sidebar

    local tabsList = {}

    function WindowObj:AddTab(tabOptions)
        local tabTitle = tabOptions.Title or "Tab"
        local TabObj = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TabButton.BorderSizePixel = 0
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  " .. tabTitle
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabButton

        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Size = UDim2.new(1, -185, 1, -55)
        TabContainer.Position = UDim2.new(0, 175, 0, 45)
        TabContainer.BackgroundTransparency = 1
        TabContainer.BorderSizePixel = 0
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContainer.Visible = false
        TabContainer.Parent = MainFrame

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Padding = UDim.new(0, 8)
        TabListLayout.Parent = TabContainer

        table.insert(tabsList, { Button = TabButton, Container = TabContainer })

        if #tabsList == 1 then
            TabContainer.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(tabsList) do
                t.Container.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            TabContainer.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        function TabObj:AddSection(secTitle)
            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 25)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Font = Enum.Font.GothamBold
            SecLabel.Text = secTitle
            SecLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            SecLabel.TextSize = 13
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = TabContainer
        end

        function TabObj:AddParagraph(paraOptions)
            local Para = Instance.new("Frame")
            Para.Size = UDim2.new(1, 0, 0, 50)
            Para.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Para.BorderSizePixel = 0
            Para.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Para

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, -20, 0, 20)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamBold
            Title.Text = paraOptions.Title or ""
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = Para

            local Content = Instance.new("TextLabel")
            Content.Size = UDim2.new(1, -20, 0, 20)
            Content.Position = UDim2.new(0, 10, 0, 25)
            Content.BackgroundTransparency = 1
            Content.Font = Enum.Font.Gotham
            Content.Text = paraOptions.Content or ""
            Content.TextColor3 = Color3.fromRGB(160, 160, 160)
            Content.TextSize = 12
            Content.TextXAlignment = Enum.TextXAlignment.Left
            Content.Parent = Para
        end

        function TabObj:AddToggle(flagName, toggleOptions)
            local toggled = toggleOptions.Default or false
            local callback = toggleOptions.Callback or function() end

            local Elem = Instance.new("Frame")
            Elem.Size = UDim2.new(1, 0, 0, 38)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = toggleOptions.Title or flagName
            Label.TextColor3 = Color3.fromRGB(240, 240, 240)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Elem

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 36, 0, 20)
            ToggleBtn.Position = UDim2.new(1, -46, 0.5, -10)
            ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.Parent = Elem

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(1, 0)
            TCorner.Parent = ToggleBtn

            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
                pcall(function() callback(toggled) end)
            end)
        end

        function TabObj:AddSlider(flagName, sliderOptions)
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local callback = sliderOptions.Callback or function() end

            local Elem = Instance.new("Frame")
            Elem.Size = UDim2.new(1, 0, 0, 52)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 24)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = (sliderOptions.Title or flagName) .. ": " .. tostring(default)
            Label.TextColor3 = Color3.fromRGB(240, 240, 240)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Elem

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 0, 35)
            SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Elem

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = SliderBar

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(math.clamp((default - min)/(max - min), 0, 1), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = SliderBar

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local dragging = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local absPos = SliderBar.AbsolutePosition.X
                    local absSize = SliderBar.AbsoluteSize.X
                    local val = math.clamp((mousePos - absPos) / absSize, 0, 1)
                    local currentVal = math.floor(min + (max - min) * val)
                    Fill.Size = UDim2.new(val, 0, 1, 0)
                    Label.Text = (sliderOptions.Title or flagName) .. ": " .. tostring(currentVal)
                    pcall(function() callback(currentVal) end)
                end
            end)

            local SliderObj = {
                GetUI = function(self)
                    return Elem
                end,
                SetValue = function(self, val)
                    local clamped = math.clamp((val - min) / (max - min), 0, 1)
                    Fill.Size = UDim2.new(clamped, 0, 1, 0)
                    Label.Text = (sliderOptions.Title or flagName) .. ": " .. tostring(val)
                    pcall(function() callback(val) end)
                end
            }
            return SliderObj
        end

        function TabObj:AddDropdown(flagName, dropOptions)
            local values = dropOptions.Values or {}
            local callback = dropOptions.Callback or function() end

            local Elem = Instance.new("Frame")
            Elem.Size = UDim2.new(1, 0, 0, 40)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = dropOptions.Title or flagName
            Label.TextColor3 = Color3.fromRGB(240, 240, 240)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Elem

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(0, 130, 0, 26)
            DropBtn.Position = UDim2.new(1, -140, 0.5, -13)
            DropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.Text = dropOptions.Default or values[1] or "Select"
            DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropBtn.TextSize = 12
            DropBtn.Parent = Elem

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 4)
            DCorner.Parent = DropBtn

            local idx = 1
            DropBtn.MouseButton1Click:Connect(function()
                idx = idx % #values + 1
                local selected = values[idx]
                DropBtn.Text = tostring(selected)
                pcall(function() callback(selected) end)
            end)

            function TabObj:SetValues(newVals)
                values = newVals or {"None"}
                idx = 1
                DropBtn.Text = tostring(values[1])
            end
        end

        function TabObj:AddButton(btnOptions)
            local Elem = Instance.new("TextButton")
            Elem.Size = UDim2.new(1, 0, 0, 36)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Font = Enum.Font.GothamSemibold
            Elem.Text = "  " .. (btnOptions.Title or "Button")
            Elem.TextColor3 = Color3.fromRGB(240, 240, 240)
            Elem.TextSize = 13
            Elem.TextXAlignment = Enum.TextXAlignment.Left
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            Elem.MouseButton1Click:Connect(function()
                pcall(function()
                    if btnOptions.Callback then btnOptions.Callback() end
                end)
            end)
        end

        return TabObj
    end

    function WindowObj:SelectTab(index)
        if tabsList[index] then
            for _, t in ipairs(tabsList) do
                t.Container.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            tabsList[index].Container.Visible = true
            tabsList[index].Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            tabsList[index].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    return WindowObj
end

return Fluent
