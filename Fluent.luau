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

    -- Draggable implementation
    local dragging = false
    local dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle visibility on MinimizeKey
    local minimizeKey = options.MinimizeKey or Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == minimizeKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(0, 160, 1, -50)
    Sidebar.Position = UDim2.new(0, 10, 0, 45)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ScrollBarThickness = 2
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
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = "  " .. tabTitle
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 13
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = Sidebar

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton

        local TabContainer = Instance.new("ScrollingFrame")
        TabContainer.Size = UDim2.new(1, -190, 1, -55)
        TabContainer.Position = UDim2.new(0, 180, 0, 45)
        TabContainer.BackgroundTransparency = 1
        TabContainer.BorderSizePixel = 0
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContainer.ScrollBarThickness = 4
        TabContainer.Visible = false
        TabContainer.Parent = MainFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContainer

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingRight = UDim.new(0, 8)
        ContentPadding.Parent = TabContainer

        local currentTabIndex = #tabsList + 1
        table.insert(tabsList, { Button = TabButton, Container = TabContainer })

        TabButton.MouseButton1Click:Connect(function()
            WindowObj:SelectTab(currentTabIndex)
        end)

        if currentTabIndex == 1 then
            WindowObj:SelectTab(1)
        end

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
            return SecLabel
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
            return Para
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

            local function updateToggle(val)
                toggled = val
                ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
                pcall(function() callback(toggled) end)
            end

            ToggleBtn.MouseButton1Click:Connect(function()
                updateToggle(not toggled)
            end)

            local ToggleObj = {
                SetValue = function(self, val)
                    updateToggle(val)
                end,
                GetValue = function(self)
                    return toggled
                end
            }
            return ToggleObj
        end

        function TabObj:AddSlider(flagName, sliderOptions)
            local min = sliderOptions.Min or 0
            local max = sliderOptions.Max or 100
            local default = sliderOptions.Default or min
            local rounding = sliderOptions.Rounding or 0
            local callback = sliderOptions.Callback or function() end

            local Elem = Instance.new("Frame")
            Elem.Size = UDim2.new(1, 0, 0, 52)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            local function formatVal(v)
                if rounding > 0 then
                    return string.format("%." .. rounding .. "f", v)
                else
                    return tostring(math.floor(v))
                end
            end

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 24)
            Label.Position = UDim2.new(0, 12, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = (sliderOptions.Title or flagName) .. ": " .. formatVal(default)
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

            local currentVal = default
            local Fill = Instance.new("Frame")
            local initRatio = (max == min) and 0 or math.clamp((default - min)/(max - min), 0, 1)
            Fill.Size = UDim2.new(initRatio, 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = SliderBar

            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local dragging = false
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    local mousePos = UserInputService:GetMouseLocation().X
                    local absPos = SliderBar.AbsolutePosition.X
                    local absSize = SliderBar.AbsoluteSize.X
                    local val = (absSize == 0) and 0 or math.clamp((mousePos - absPos) / absSize, 0, 1)
                    local mult = 10 ^ rounding
                    currentVal = math.floor((min + (max - min) * val) * mult + 0.5) / mult
                    Fill.Size = UDim2.new(val, 0, 1, 0)
                    Label.Text = (sliderOptions.Title or flagName) .. ": " .. formatVal(currentVal)
                    pcall(function() callback(currentVal) end)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local absPos = SliderBar.AbsolutePosition.X
                    local absSize = SliderBar.AbsoluteSize.X
                    local val = (absSize == 0) and 0 or math.clamp((mousePos - absPos) / absSize, 0, 1)
                    local mult = 10 ^ rounding
                    currentVal = math.floor((min + (max - min) * val) * mult + 0.5) / mult
                    Fill.Size = UDim2.new(val, 0, 1, 0)
                    Label.Text = (sliderOptions.Title or flagName) .. ": " .. formatVal(currentVal)
                    pcall(function() callback(currentVal) end)
                end
            end)

            local SliderObj = {
                GetUI = function(self)
                    return Elem
                end,
                SetValue = function(self, val)
                    val = tonumber(val) or default
                    local mult = 10 ^ rounding
                    currentVal = math.floor(val * mult + 0.5) / mult
                    local clamped = (max == min) and 0 or math.clamp((currentVal - min) / (max - min), 0, 1)
                    Fill.Size = UDim2.new(clamped, 0, 1, 0)
                    Label.Text = (sliderOptions.Title or flagName) .. ": " .. formatVal(currentVal)
                    pcall(function() callback(currentVal) end)
                end,
                GetValue = function(self)
                    return currentVal
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
                if #values > 0 then
                    idx = idx % #values + 1
                    local selected = values[idx]
                    DropBtn.Text = tostring(selected)
                    pcall(function() callback(selected) end)
                end
            end)

            local DropdownObj = {
                SetValues = function(self, newVals)
                    values = newVals or {"None"}
                    idx = 1
                    DropBtn.Text = tostring(values[1])
                end,
                Refresh = function(self, newVals, retain)
                    values = newVals or {}
                    if not retain and #values > 0 then
                        idx = 1
                        DropBtn.Text = tostring(values[1])
                    end
                end,
                Set = function(self, val)
                    DropBtn.Text = tostring(val)
                end,
                SetValue = function(self, val)
                    DropBtn.Text = tostring(val)
                end,
                GetValue = function(self)
                    return DropBtn.Text
                end
            }

            return DropdownObj
        end

        function TabObj:AddColorpicker(flagName, colorOptions)
            local default = colorOptions.Default or Color3.fromRGB(255, 255, 255)
            local callback = colorOptions.Callback or function() end
            local currentColor = default

            local Elem = Instance.new("Frame")
            Elem.Size = UDim2.new(1, 0, 0, 40)
            Elem.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            Elem.BorderSizePixel = 0
            Elem.Parent = TabContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Elem

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = colorOptions.Title or flagName
            Label.TextColor3 = Color3.fromRGB(240, 240, 240)
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Elem

            local ColorBtn = Instance.new("TextButton")
            ColorBtn.Size = UDim2.new(0, 48, 0, 24)
            ColorBtn.Position = UDim2.new(1, -58, 0.5, -12)
            ColorBtn.BackgroundColor3 = currentColor
            ColorBtn.Text = ""
            ColorBtn.AutoButtonColor = false
            ColorBtn.Parent = Elem

            local CCorner = Instance.new("UICorner")
            CCorner.CornerRadius = UDim.new(0, 4)
            CCorner.Parent = ColorBtn

            local presetColors = {
                Color3.fromRGB(180, 0, 255),
                Color3.fromRGB(0, 220, 255),
                Color3.fromRGB(255, 50, 150),
                Color3.fromRGB(0, 255, 100),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(255, 50, 50),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(0, 170, 255)
            }
            local colorIdx = 1

            local function updateColor(newColor)
                currentColor = newColor
                ColorBtn.BackgroundColor3 = currentColor
                pcall(function() callback(currentColor) end)
            end

            ColorBtn.MouseButton1Click:Connect(function()
                colorIdx = (colorIdx % #presetColors) + 1
                updateColor(presetColors[colorIdx])
            end)

            local ColorpickerObj = {
                SetValue = function(self, val)
                    if typeof(val) == "Color3" then
                        updateColor(val)
                    end
                end,
                GetValue = function(self)
                    return currentColor
                end
            }
            return ColorpickerObj
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
            return Elem
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
