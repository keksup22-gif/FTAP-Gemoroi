--[[
    ============================================================
    GemoroiUI v1.1.0 — Custom UI Library for FTAP-Gemoroi
    Theme  : Lime Dark Neon
    Layout : Vertical Sidebar + Scrollable Content
    Author : keksup22

    Drop-in replacement for the old Fluent bindings with a
    Fluent-compatible API surface:
      GemoroiUI:CreateWindow({ Title, SubTitle, TabWidth, Size,
                                Theme, Acrylic, MinimizeKey })
      Window:AddTab({ Title, Icon })
      Tab:AddSection(title | {Title = ...})
      Tab:AddToggle(id,   {Title, Description, Default, Callback})   -> :SetValue(bool)
      Tab:AddSlider(id,   {Title, Description, Default, Min, Max,
                           Rounding, Suffix, Callback})               -> :SetValue(number)
      Tab:AddDropdown(id, {Title, Description, Values, Default,
                           Callback})                                 -> :SetValue / :SetValues / :Refresh
      Tab:AddButton({Title, Description, Callback})
      Tab:AddColorpicker(id, {Title, Default, Callback})              -> :SetValue(Color3)
      Tab:AddKeybind(id, {Title, Description, Default, Callback})      -> :SetValue(KeyCode)
      Tab:AddParagraph({Title, Content})
      GemoroiUI:Notify({Title, Content, Duration})

    SYNCED COPY: /GemoroiUI.luau  <->  /modules/GemoroiUI.luau
    Keep both files identical!
    ============================================================
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local SoundService = game:GetService("SoundService")

local GemoroiUI = {
    Version   = "1.1.0",
    ThemeName = "Lime Dark Neon",
    Sounds    = true, -- confirmation sounds for notifications
}

local function playNotifySound()
    if not GemoroiUI.Sounds then
        return
    end
    pcall(function()
        local snd = Instance.new("Sound")
        snd.SoundId = "rbxassetid://6895079853"
        snd.Volume = 0.3
        snd.PlaybackSpeed = 1.4
        snd.Parent = SoundService
        snd:Play()
        task.delay(0.6, function()
            if snd and snd.Parent then
                snd:Destroy()
            end
        end)
    end)
end

-- ============================== THEME ==============================
local Theme = {
    -- Lime Dark Neon palette
    Background    = Color3.fromRGB(15, 17, 22),
    Sidebar       = Color3.fromRGB(19, 22, 28),
    Topbar        = Color3.fromRGB(17, 20, 26),
    Element       = Color3.fromRGB(24, 28, 35),
    ElementHover  = Color3.fromRGB(31, 36, 45),
    ElementActive = Color3.fromRGB(37, 43, 53),
    OptionHover   = Color3.fromRGB(30, 35, 44),
    Stroke        = Color3.fromRGB(42, 49, 60),
    Accent        = Color3.fromRGB(57, 255, 20),   -- neon lime
    AccentDark    = Color3.fromRGB(31, 140, 12),
    KnobOff       = Color3.fromRGB(110, 120, 132),
    Text          = Color3.fromRGB(240, 244, 248),
    SubText       = Color3.fromRGB(148, 158, 170),
    Faint         = Color3.fromRGB(100, 110, 122),
    Danger        = Color3.fromRGB(255, 82, 82),
    Track         = Color3.fromRGB(33, 39, 48),
}

local ICONS = {
    ["sword"]        = "⚔️",
    ["user"]         = "👤",
    ["users"]        = "👥",
    ["eye"]          = "👁️",
    ["sparkles"]     = "✨",
    ["crosshair"]    = "🎯",
    ["zap"]          = "⚡",
    ["shield"]       = "🛡️",
    ["shield-alert"] = "🚨",
    ["flame"]        = "🔥",
    ["server"]       = "🖥️",
    ["map-pin"]      = "📍",
    ["box"]          = "📦",
    ["settings"]     = "⚙️",
    ["target"]       = "🎯",
    ["star"]         = "⭐",
    ["lock"]         = "🔒",
    ["home"]         = "🏠",
    ["globe"]        = "🌐",
    ["activity"]     = "📈",
    ["gift"]         = "🎁",
    ["gifts"]        = "🎁",
    ["crown"]        = "👑",
    ["wand"]         = "🪄",
    ["keyboard"]     = "⌨️",
    ["bolt"]         = "⚡",
}

-- ============================ HELPERS =============================
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function tween(inst, time, props, style, dir)
    if not time or time <= 0 then
        for k, v in pairs(props) do
            inst[k] = v
        end
        return
    end
    TweenService:Create(
        inst,
        TweenInfo.new(time, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function createScreenGui(name, reuse)
    local candidates = {}
    pcall(function()
        if gethui then
            table.insert(candidates, gethui())
        end
    end)
    table.insert(candidates, CoreGui)
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then
        pg = LocalPlayer:WaitForChild("PlayerGui", 5)
    end
    if pg then
        table.insert(candidates, pg)
    end

    for _, parent in ipairs(candidates) do
        if parent then
            if reuse then
                local existing = parent:FindFirstChild(name)
                if existing then
                    return existing
                end
            end
            local ok, gui = pcall(function()
                local g = Instance.new("ScreenGui")
                g.Name = name
                g.ResetOnSpawn = false
                g.IgnoreGuiInset = true
                g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                g.DisplayOrder = 9999
                g.Parent = parent
                return g
            end)
            if ok and gui then
                return gui
            end
        end
    end
    return nil
end

-- ========================= NOTIFICATIONS ==========================
local notifyHolder = nil
local notifyList = {}

local function getNotifyHolder()
    if notifyHolder and notifyHolder.Parent then
        return notifyHolder
    end
    local gui = createScreenGui("GemoroiUI_Notifications", true)
    if not gui then
        return nil
    end
    if gui:FindFirstChild("Holder") then
        notifyHolder = gui.Holder
        return notifyHolder
    end
    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.AnchorPoint = Vector2.new(1, 0)
    holder.Position = UDim2.new(1, -14, 0, 14)
    holder.Size = UDim2.new(0, 300, 1, -28)
    holder.BackgroundTransparency = 1
    holder.Parent = gui
    notifyHolder = holder
    notifyList = {}
    return holder
end

local function layoutNotifications(animate)
    local y = 0
    for _, item in ipairs(notifyList) do
        local target = UDim2.new(1, 0, 0, y)
        if animate then
            tween(item.frame, 0.28, { Position = target }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        else
            item.frame.Position = target
        end
        y = y + item.height + 8
    end
end

local function dismissNotification(item, instant)
    for i, v in ipairs(notifyList) do
        if v == item then
            table.remove(notifyList, i)
            break
        end
    end
    if instant and item.frame then
        pcall(function() item.frame:Destroy() end)
    elseif item.frame then
        tween(item.frame, 0.22, { Position = UDim2.new(1, 340, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        task.delay(0.25, function()
            pcall(function()
                if item.frame then
                    item.frame:Destroy()
                end
            end)
        end)
    end
    layoutNotifications(true)
end

function GemoroiUI:Notify(props)
    props = (type(props) == "table") and props or {}
    task.spawn(function()
        local holder = getNotifyHolder()
        if not holder then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = tostring(props.Title or "GemoroiUI"),
                    Text = tostring(props.Content or ""),
                    Duration = tonumber(props.Duration) or 5,
                })
            end)
            return
        end

        if #notifyList >= 8 then
            dismissNotification(notifyList[1], false)
        end

        local height = 64
        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.AnchorPoint = Vector2.new(1, 0)
        notif.Size = UDim2.new(1, 0, 0, height)
        notif.BackgroundColor3 = Color3.fromRGB(17, 22, 18)
        notif.BorderSizePixel = 0
        notif.Position = UDim2.new(1, 340, 0, 0)
        notif.Parent = holder
        corner(notif, 8)
        stroke(notif, Theme.Stroke, 1, 0.25)

        local accentBar = Instance.new("Frame")
        accentBar.Name = "AccentBar"
        accentBar.Position = UDim2.new(0, 0, 0, 7)
        accentBar.Size = UDim2.new(0, 3, 1, -14)
        accentBar.BackgroundColor3 = Theme.Accent
        accentBar.BorderSizePixel = 0
        accentBar.Parent = notif
        corner(accentBar, 2)

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.new(0, 14, 0, 9)
        titleLabel.Size = UDim2.new(1, -24, 0, 16)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextColor3 = Theme.Text
        titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        titleLabel.Text = tostring(props.Title or "GemoroiUI")
        titleLabel.Parent = notif

        local contentLabel = Instance.new("TextLabel")
        contentLabel.Name = "Content"
        contentLabel.BackgroundTransparency = 1
        contentLabel.Position = UDim2.new(0, 14, 0, 28)
        contentLabel.Size = UDim2.new(1, -24, 0, 30)
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextSize = 12
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.TextWrapped = true
        contentLabel.TextColor3 = Theme.SubText
        contentLabel.TextTruncate = Enum.TextTruncate.AtEnd
        contentLabel.Text = tostring(props.Content or "")
        contentLabel.Parent = notif

        playNotifySound()

        local item = { frame = notif, height = height }
        local targetY = 0
        for _, existing in ipairs(notifyList) do
            targetY = targetY + existing.height + 8
        end
        table.insert(notifyList, item)
        tween(notif, 0.32, { Position = UDim2.new(1, 0, 0, targetY) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        notif.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dismissNotification(item, false)
            end
        end)

        task.delay(math.max(tonumber(props.Duration) or 5, 1), function()
            if notif and notif.Parent then
                dismissNotification(item, false)
            end
        end)
    end)
end

-- ============================ WINDOW ==============================
function GemoroiUI:CreateWindow(config)
    config = (type(config) == "table") and config or {}

    local gui = createScreenGui("GemoroiUI", true)
    if not gui then
        warn("[GemoroiUI] Failed to create ScreenGui")
        return nil
    end

    local prevWindow = gui:FindFirstChild("GemoroiWindow")
    if prevWindow then
        prevWindow:Destroy()
    end
    local prevDock = gui:FindFirstChild("GemoroiDock")
    if prevDock then
        prevDock:Destroy()
    end

    local windowConnections = {}

    local size = config.Size
    if typeof(size) ~= "UDim2" then
        size = UDim2.fromOffset(580, 460)
    end
    local tabWidth = math.clamp(tonumber(config.TabWidth) or 160, 110, 260)
    local minimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl

    local Main = Instance.new("Frame")
    Main.Name = "GemoroiWindow"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = size
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = gui
    corner(Main, 10)
    stroke(Main, Theme.Stroke, 1, 0.1)

    if config.Acrylic then
        Main.BackgroundTransparency = 0.06
    end

    -- ===================== SIDEBAR (VERTICAL) =====================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, tabWidth, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    corner(Sidebar, 10)

    local SideHeader = Instance.new("Frame")
    SideHeader.Name = "Header"
    SideHeader.Size = UDim2.new(1, 0, 0, 74)
    SideHeader.BackgroundTransparency = 1
    SideHeader.Parent = Sidebar

    local BrandDot = Instance.new("Frame")
    BrandDot.Name = "BrandDot"
    BrandDot.Position = UDim2.new(0, 16, 0, 21)
    BrandDot.Size = UDim2.new(0, 7, 0, 7)
    BrandDot.BackgroundColor3 = Theme.Accent
    BrandDot.BorderSizePixel = 0
    BrandDot.Parent = SideHeader
    corner(BrandDot, 4)

    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "Title"
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Position = UDim2.new(0, 30, 0, 14)
    WindowTitle.Size = UDim2.new(1, -42, 0, 18)
    WindowTitle.Font = Enum.Font.GothamBold
    WindowTitle.TextSize = 14
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    WindowTitle.TextColor3 = Theme.Text
    WindowTitle.TextTruncate = Enum.TextTruncate.AtEnd
    WindowTitle.Text = tostring(config.Title or "GemoroiUI")
    WindowTitle.Parent = SideHeader

    local WindowSubTitle = Instance.new("TextLabel")
    WindowSubTitle.Name = "SubTitle"
    WindowSubTitle.BackgroundTransparency = 1
    WindowSubTitle.Position = UDim2.new(0, 16, 0, 36)
    WindowSubTitle.Size = UDim2.new(1, -30, 0, 14)
    WindowSubTitle.Font = Enum.Font.Gotham
    WindowSubTitle.TextSize = 11
    WindowSubTitle.TextXAlignment = Enum.TextXAlignment.Left
    WindowSubTitle.TextColor3 = Theme.SubText
    WindowSubTitle.TextTruncate = Enum.TextTruncate.AtEnd
    WindowSubTitle.Text = tostring(config.SubTitle or "Lime Dark")
    WindowSubTitle.Parent = SideHeader

    local SideDivider = Instance.new("Frame")
    SideDivider.Name = "Divider"
    SideDivider.Position = UDim2.new(0, 0, 0, 74)
    SideDivider.Size = UDim2.new(1, 0, 0, 1)
    SideDivider.BackgroundColor3 = Theme.Stroke
    SideDivider.BackgroundTransparency = 0.35
    SideDivider.BorderSizePixel = 0
    SideDivider.Parent = Sidebar

    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Position = UDim2.new(0, 0, 0, 75)
    TabList.Size = UDim2.new(1, 0, 1, -101)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Theme.Stroke
    TabList.CanvasSize = UDim2.new()
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabList.Parent = Sidebar

    local TabListPadding = Instance.new("UIPadding")
    TabListPadding.PaddingTop = UDim.new(0, 8)
    TabListPadding.PaddingBottom = UDim.new(0, 8)
    TabListPadding.PaddingLeft = UDim.new(0, 8)
    TabListPadding.PaddingRight = UDim.new(0, 8)
    TabListPadding.Parent = TabList

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabList

    local SideFooter = Instance.new("TextLabel")
    SideFooter.Name = "Footer"
    SideFooter.AnchorPoint = Vector2.new(0, 1)
    SideFooter.Position = UDim2.new(0, 0, 1, -4)
    SideFooter.Size = UDim2.new(1, 0, 0, 18)
    SideFooter.BackgroundTransparency = 1
    SideFooter.Font = Enum.Font.Gotham
    SideFooter.TextSize = 10
    SideFooter.TextColor3 = Theme.Faint
    SideFooter.Text = "GemoroiUI v" .. GemoroiUI.Version .. " • Lime Dark"
    SideFooter.Parent = Sidebar

    -- ===================== CONTENT AREA =====================
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Position = UDim2.new(0, tabWidth, 0, 0)
    Content.Size = UDim2.new(1, -tabWidth, 1, 0)
    Content.BackgroundColor3 = Theme.Background
    Content.BorderSizePixel = 0
    Content.Parent = Main
    corner(Content, 10)

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 42)
    Topbar.BackgroundColor3 = Theme.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Content
    corner(Topbar, 10)

    local TopbarDivider = Instance.new("Frame")
    TopbarDivider.Name = "Divider"
    TopbarDivider.Position = UDim2.new(0, 0, 0, 42)
    TopbarDivider.Size = UDim2.new(1, 0, 0, 1)
    TopbarDivider.BackgroundColor3 = Theme.Stroke
    TopbarDivider.BackgroundTransparency = 0.35
    TopbarDivider.BorderSizePixel = 0
    TopbarDivider.Parent = Topbar

    local TopbarTitle = Instance.new("TextLabel")
    TopbarTitle.Name = "ActiveTab"
    TopbarTitle.BackgroundTransparency = 1
    TopbarTitle.Position = UDim2.new(0, 16, 0, 0)
    TopbarTitle.Size = UDim2.new(1, -90, 0, 42)
    TopbarTitle.Font = Enum.Font.GothamSemibold
    TopbarTitle.TextSize = 14
    TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopbarTitle.TextColor3 = Theme.Text
    TopbarTitle.TextTruncate = Enum.TextTruncate.AtEnd
    TopbarTitle.Text = ""
    TopbarTitle.Parent = Topbar

    local function windowButton(xOffset, glyph, hoverColor)
        local btn = Instance.new("TextButton")
        btn.Name = "Btn_" .. glyph
        btn.AnchorPoint = Vector2.new(1, 0)
        btn.Position = UDim2.new(1, xOffset, 0, 8)
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.BackgroundColor3 = Theme.Element
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = Theme.SubText
        btn.Text = glyph
        btn.Parent = Topbar
        btn.MouseEnter:Connect(function()
            tween(btn, 0.1, { TextColor3 = hoverColor })
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, 0.1, { TextColor3 = Theme.SubText })
        end)
        return btn
    end

    local MinimizeBtn = windowButton(-68, "–", Theme.Text)
    local CloseBtn = windowButton(-36, "✕", Theme.Danger)

    -- ===================== DOCK (MINIMIZED) =====================
    local Dock = Instance.new("TextButton")
    Dock.Name = "GemoroiDock"
    Dock.Position = UDim2.new(0, 14, 0, 14)
    Dock.Size = UDim2.new(0, 42, 0, 42)
    Dock.BackgroundColor3 = Theme.Accent
    Dock.BorderSizePixel = 0
    Dock.AutoButtonColor = false
    Dock.Font = Enum.Font.GothamBold
    Dock.TextSize = 18
    Dock.TextColor3 = Color3.fromRGB(17, 22, 18)
    Dock.Text = "≡"
    Dock.Visible = false
    Dock.Parent = gui
    corner(Dock, 12)
    stroke(Dock, Theme.AccentDark, 1, 0.2)

    Dock.MouseEnter:Connect(function()
        tween(Dock, 0.12, { Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 12, 0, 12) })
    end)
    Dock.MouseLeave:Connect(function()
        tween(Dock, 0.12, { Size = UDim2.new(0, 42, 0, 42), Position = UDim2.new(0, 14, 0, 14) })
    end)

    -- ===================== WINDOW OBJECT =====================
    local Window = {}
    local tabs = {}
    local selectedTab = nil
    local minimized = false

    local function setMinimized(state)
        minimized = state and true or false
        Main.Visible = not minimized
        Dock.Visible = minimized
    end

    -- animated fade cover used on tab switch
    local ContentCover = Instance.new("Frame")
    ContentCover.Name = "ContentCover"
    ContentCover.Position = UDim2.new(0, 0, 0, 43)
    ContentCover.Size = UDim2.new(1, 0, 1, -43)
    ContentCover.BackgroundColor3 = Theme.Background
    ContentCover.BackgroundTransparency = 1
    ContentCover.BorderSizePixel = 0
    ContentCover.ZIndex = 50
    ContentCover.Visible = false
    ContentCover.Parent = Content

    local function selectTab(tab)
        if selectedTab == tab then
            return
        end
        selectedTab = tab
        for _, t in ipairs(tabs) do
            local active = (t == tab)
            t.Page.Visible = active
            t.AccentBar.Visible = active
            tween(t.Button, 0.15, {
                BackgroundColor3 = active and Theme.Element or Theme.Sidebar
            })
            tween(t.TitleLabel, 0.15, {
                TextColor3 = active and Theme.Text or Theme.SubText
            })
            if active then
                -- smooth content entrance: slide + fade via TweenService
                t.Page.Position = UDim2.new(0, 0, 0, 55)
                t.Page.CanvasPosition = Vector2.new(0, 0)
                tween(t.Page, 0.22, { Position = UDim2.new(0, 0, 0, 43) }, Enum.EasingStyle.Quint)
            end
        end
        TopbarTitle.Text = tab.Title
        -- fade cover flash
        ContentCover.Visible = true
        ContentCover.BackgroundTransparency = 0.45
        tween(ContentCover, 0.25, { BackgroundTransparency = 1 })
        task.delay(0.3, function()
            ContentCover.Visible = false
        end)
    end

    -- ===================== ELEMENT FACTORY =====================
    local function newElement(page, height, transparent)
        page.NextOrder = (page.NextOrder or 0) + 1
        local frame = Instance.new("Frame")
        frame.Name = "Element_" .. page.NextOrder
        frame.Size = UDim2.new(1, 0, 0, height)
        frame.BackgroundColor3 = Theme.Element
        frame.BackgroundTransparency = transparent and 1 or 0
        frame.BorderSizePixel = 0
        frame.LayoutOrder = page.NextOrder
        frame.Parent = page
        if not transparent then
            corner(frame, 7)
            stroke(frame, Theme.Stroke, 1, 0.35)
        end
        return frame
    end

    local function addTexts(frame, props, height, rightReserve)
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamMedium
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextYAlignment = hasDesc and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        title.TextColor3 = Theme.Text
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Text = tostring(props.Title or "")
        title.Parent = frame

        if hasDesc then
            title.Position = UDim2.new(0, 12, 0, 9)
            title.Size = UDim2.new(1, -24 - (rightReserve or 0), 0, 16)
            local desc = Instance.new("TextLabel")
            desc.Name = "Description"
            desc.BackgroundTransparency = 1
            desc.Position = UDim2.new(0, 12, 0, 27)
            desc.Size = UDim2.new(1, -24 - (rightReserve or 0), 0, 13)
            desc.Font = Enum.Font.Gotham
            desc.TextSize = 11
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.TextWrapped = true
            desc.TextColor3 = Theme.SubText
            desc.TextTruncate = Enum.TextTruncate.AtEnd
            desc.Text = props.Description
            desc.Parent = frame
        else
            title.Position = UDim2.new(0, 12, 0, 0)
            title.Size = UDim2.new(1, -24 - (rightReserve or 0), 0, height)
        end
        return hasDesc
    end

    local function connectBarDrag(barBg, callback)
        local dragging = false
        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                callback(math.clamp((input.Position.X - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1))
            end
        end)
        local moveConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                callback(math.clamp((input.Position.X - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1))
            end
        end)
        local endConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        table.insert(windowConnections, moveConn)
        table.insert(windowConnections, endConn)
    end

    local function addSection(page, title)
        if type(title) == "table" then
            title = title.Title or ""
        end
        title = tostring(title or "")
        local frame = newElement(page, 30, true)

        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.Position = UDim2.new(0, 2, 0, 13)
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.BackgroundColor3 = Theme.Accent
        dot.BorderSizePixel = 0
        dot.Parent = frame
        corner(dot, 2)

        local label = Instance.new("TextLabel")
        label.Name = "Title"
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 13, 0, 0)
        label.Size = UDim2.new(1, -13, 0, 30)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextColor3 = Theme.SubText
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.Text = title
        label.Parent = frame

        local line = Instance.new("Frame")
        line.Name = "Line"
        line.Position = UDim2.new(0, 0, 1, -1)
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = Theme.Stroke
        line.BackgroundTransparency = 0.4
        line.BorderSizePixel = 0
        line.Parent = frame

        return frame
    end

    local function addToggle(page, id, props)
        props = props or {}
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local height = hasDesc and 56 or 38
        local frame = newElement(page, height)
        addTexts(frame, props, height, 56)

        local switch = Instance.new("Frame")
        switch.Name = "Switch"
        switch.AnchorPoint = Vector2.new(1, 0.5)
        switch.Position = UDim2.new(1, -10, 0.5, 0)
        switch.Size = UDim2.new(0, 38, 0, 20)
        switch.BackgroundColor3 = Theme.Track
        switch.BorderSizePixel = 0
        switch.Parent = frame
        corner(switch, 10)

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0, 5, 0.5, 0)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.BackgroundColor3 = Theme.KnobOff
        knob.BorderSizePixel = 0
        knob.Parent = switch
        corner(knob, 7)

        local state = (props.Default == true)
        local Toggle = {}

        local function render(animate)
            local t = animate and 0.18 or 0
            if state then
                tween(switch, t, { BackgroundColor3 = Theme.Accent })
                tween(knob, t, {
                    Position = UDim2.new(1, -5, 0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(17, 22, 18)
                })
            else
                tween(switch, t, { BackgroundColor3 = Theme.Track })
                tween(knob, t, {
                    Position = UDim2.new(0, 5, 0.5, 0),
                    BackgroundColor3 = Theme.KnobOff
                })
            end
        end

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                render(true)
                if type(props.Callback) == "function" then
                    task.spawn(props.Callback, state)
                end
            end
        end)
        frame.MouseEnter:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.ElementHover })
        end)
        frame.MouseLeave:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.Element })
        end)

        function Toggle:SetValue(v)
            state = (v == true)
            render(false)
        end

        render(false)
        return Toggle
    end

    local function addSlider(page, id, props)
        props = props or {}
        local min = tonumber(props.Min) or 0
        local max = tonumber(props.Max) or 100
        if max < min then
            max = min
        end
        local rounding = math.clamp(tonumber(props.Rounding) or 0, 0, 3)
        local suffix = (type(props.Suffix) == "string") and props.Suffix or ""
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local height = hasDesc and 78 or 62

        local frame = newElement(page, height)
        addTexts(frame, props, hasDesc and 38 or 22, 70)

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.BackgroundTransparency = 1
        valueLabel.AnchorPoint = Vector2.new(1, 0)
        valueLabel.Position = UDim2.new(1, -12, 0, hasDesc and 8 or 0)
        valueLabel.Size = UDim2.new(0, 150, 0, hasDesc and 16 or 22)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.TextYAlignment = Enum.TextYAlignment.Center
        valueLabel.TextColor3 = Theme.Accent
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        valueLabel.Text = ""
        valueLabel.Parent = frame

        local barBg = Instance.new("Frame")
        barBg.Name = "Bar"
        barBg.Position = UDim2.new(0, 12, 1, -18)
        barBg.Size = UDim2.new(1, -24, 0, 6)
        barBg.BackgroundColor3 = Theme.Track
        barBg.BorderSizePixel = 0
        barBg.Parent = frame
        corner(barBg, 3)

        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = barBg
        corner(fill, 3)

        local knob = Instance.new("Frame")
        knob.Name = "Knob"
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(0, 0, 0.5, 0)
        knob.Size = UDim2.new(0, 12, 0, 12)
        knob.BackgroundColor3 = Theme.Text
        knob.BorderSizePixel = 0
        knob.Parent = barBg
        corner(knob, 6)

        local value = tonumber(props.Default) or min
        local Slider = {}

        local function renderValue()
            local pct = (max == min) and 0 or math.clamp((value - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            knob.Position = UDim2.new(pct, 0, 0.5, 0)
            valueLabel.Text = string.format("%." .. rounding .. "f", value) .. suffix
        end

        local function updateFromFraction(fraction, fire)
            local newValue = min + (max - min) * fraction
            newValue = tonumber(string.format("%." .. rounding .. "f", newValue)) or min
            if newValue ~= value then
                value = newValue
                renderValue()
                if fire and type(props.Callback) == "function" then
                    task.spawn(props.Callback, value)
                end
            end
        end

        connectBarDrag(barBg, function(fraction)
            updateFromFraction(fraction, true)
        end)

        function Slider:SetValue(v)
            v = tonumber(v) or min
            if v < min then
                v = min
            elseif v > max then
                v = max
            end
            value = tonumber(string.format("%." .. rounding .. "f", v)) or min
            renderValue()
        end

        renderValue()
        return Slider
    end

    local function addDropdown(page, id, props)
        props = props or {}
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local headerH = hasDesc and 56 or 38
        local frame = newElement(page, headerH)
        addTexts(frame, props, headerH, 96)

        local chevron = Instance.new("TextLabel")
        chevron.Name = "Chevron"
        chevron.BackgroundTransparency = 1
        chevron.AnchorPoint = Vector2.new(1, 0)
        chevron.Position = UDim2.new(1, -10, 0, hasDesc and 8 or 0)
        chevron.Size = UDim2.new(0, 14, 0, hasDesc and 16 or headerH)
        chevron.Font = Enum.Font.GothamBold
        chevron.TextSize = 12
        chevron.TextXAlignment = Enum.TextXAlignment.Right
        chevron.TextYAlignment = Enum.TextYAlignment.Center
        chevron.TextColor3 = Theme.SubText
        chevron.Text = "▾"
        chevron.Parent = frame

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.BackgroundTransparency = 1
        valueLabel.AnchorPoint = Vector2.new(1, 0)
        valueLabel.Position = UDim2.new(1, -28, 0, hasDesc and 8 or 0)
        valueLabel.Size = UDim2.new(0, 160, 0, hasDesc and 16 or headerH)
        valueLabel.Font = Enum.Font.GothamMedium
        valueLabel.TextSize = 12
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.TextYAlignment = Enum.TextYAlignment.Center
        valueLabel.TextColor3 = Theme.SubText
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        valueLabel.Text = ""
        valueLabel.Parent = frame

        local listFrame = Instance.new("ScrollingFrame")
        listFrame.Name = "Options"
        listFrame.Position = UDim2.new(0, 6, 0, headerH)
        listFrame.Size = UDim2.new(1, -12, 0, 0)
        listFrame.BackgroundColor3 = Theme.OptionHover
        listFrame.BackgroundTransparency = 0.25
        listFrame.BorderSizePixel = 0
        listFrame.Visible = false
        listFrame.ScrollBarThickness = 3
        listFrame.ScrollBarImageColor3 = Theme.Stroke
        listFrame.CanvasSize = UDim2.new()
        listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        listFrame.Parent = frame
        corner(listFrame, 6)

        local listPadding = Instance.new("UIPadding")
        listPadding.PaddingTop = UDim.new(0, 4)
        listPadding.PaddingBottom = UDim.new(0, 4)
        listPadding.PaddingLeft = UDim.new(0, 4)
        listPadding.PaddingRight = UDim.new(0, 6)
        listPadding.Parent = listFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = listFrame

        local values = {}
        local current = nil
        local open = false
        local optionButtons = {}
        local Dropdown = {}

        local function setHeight()
            local h = headerH
            if open then
                h = headerH + 8 + math.min(#values * 28, 164)
            end
            frame.Size = UDim2.new(1, 0, 0, h)
        end

        local function rebuild()
            for _, b in ipairs(optionButtons) do
                pcall(function() b:Destroy() end)
            end
            optionButtons = {}
            for i, v in ipairs(values) do
                local opt = Instance.new("TextButton")
                opt.Name = "Option_" .. i
                opt.Size = UDim2.new(1, 0, 0, 26)
                opt.BackgroundColor3 = Theme.Element
                opt.BackgroundTransparency = 1
                opt.BorderSizePixel = 0
                opt.AutoButtonColor = false
                opt.Text = ""
                opt.LayoutOrder = i
                opt.Parent = listFrame
                corner(opt, 5)

                local lbl = Instance.new("TextLabel")
                lbl.BackgroundTransparency = 1
                lbl.Position = UDim2.new(0, 8, 0, 0)
                lbl.Size = UDim2.new(1, -16, 1, 0)
                lbl.Font = Enum.Font.GothamMedium
                lbl.TextSize = 12
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextYAlignment = Enum.TextYAlignment.Center
                lbl.TextColor3 = (v == current) and Theme.Accent or Theme.SubText
                lbl.TextTruncate = Enum.TextTruncate.AtEnd
                lbl.Text = tostring(v) .. ((v == current) and "   ✓" or "")
                lbl.Parent = opt

                opt.MouseEnter:Connect(function()
                    opt.BackgroundTransparency = 0
                end)
                opt.MouseLeave:Connect(function()
                    opt.BackgroundTransparency = 1
                end)
                opt.Activated:Connect(function()
                    current = v
                    valueLabel.Text = tostring(v)
                    rebuild()
                    open = false
                    listFrame.Visible = false
                    chevron.Text = "▾"
                    setHeight()
                    if type(props.Callback) == "function" then
                        task.spawn(props.Callback, current)
                    end
                end)

                table.insert(optionButtons, opt)
            end
        end

        local headerHit = Instance.new("TextButton")
        headerHit.Name = "HeaderHit"
        headerHit.Size = UDim2.new(1, 0, 0, headerH)
        headerHit.BackgroundColor3 = Theme.Element
        headerHit.BackgroundTransparency = 1
        headerHit.BorderSizePixel = 0
        headerHit.AutoButtonColor = false
        headerHit.Text = ""
        headerHit.Parent = frame

        headerHit.MouseEnter:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.ElementHover })
        end)
        headerHit.MouseLeave:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.Element })
        end)

        headerHit.Activated:Connect(function()
            open = not open
            listFrame.Visible = open
            chevron.Text = open and "▴" or "▾"
            setHeight()
        end)

        function Dropdown:SetValue(v)
            for _, val in ipairs(values) do
                if val == v then
                    current = v
                    valueLabel.Text = tostring(v)
                    rebuild()
                    return
                end
            end
            current = v
            valueLabel.Text = tostring(v or "")
            rebuild()
        end

        function Dropdown:SetValues(newValues)
            values = {}
            if type(newValues) == "table" then
                for _, v in ipairs(newValues) do
                    table.insert(values, v)
                end
            end
            local stillThere = false
            for _, v in ipairs(values) do
                if v == current then
                    stillThere = true
                    break
                end
            end
            if not stillThere then
                current = values[1]
            end
            valueLabel.Text = tostring(current or "")
            rebuild()
            setHeight()
        end

        function Dropdown:Refresh(newValues, keepSelection)
            if keepSelection and current ~= nil then
                local old = current
                Dropdown:SetValues(newValues)
                current = old
                valueLabel.Text = tostring(current or "")
                rebuild()
            else
                Dropdown:SetValues(newValues)
            end
        end

        Dropdown:SetValues(props.Values)
        if props.Default ~= nil then
            Dropdown:SetValue(props.Default)
        end
        setHeight()
        return Dropdown
    end

    local function addButton(page, props)
        props = props or {}
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local height = hasDesc and 56 or 38
        local frame = newElement(page, height)
        addTexts(frame, props, height, 0)

        local arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.BackgroundTransparency = 1
        arrow.AnchorPoint = Vector2.new(1, 0)
        arrow.Position = UDim2.new(1, -12, 0, hasDesc and 8 or 0)
        arrow.Size = UDim2.new(0, 16, 0, hasDesc and 16 or height)
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 13
        arrow.TextXAlignment = Enum.TextXAlignment.Right
        arrow.TextYAlignment = Enum.TextYAlignment.Center
        arrow.TextColor3 = Theme.Accent
        arrow.Text = "→"
        arrow.Parent = frame

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                tween(frame, 0.07, { BackgroundColor3 = Theme.ElementActive })
                task.delay(0.12, function()
                    tween(frame, 0.18, { BackgroundColor3 = Theme.ElementHover })
                end)
                if type(props.Callback) == "function" then
                    task.spawn(props.Callback)
                end
            end
        end)
        frame.MouseEnter:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.ElementHover })
        end)
        frame.MouseLeave:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.Element })
        end)

        return frame
    end

    local function addColorpicker(page, id, props)
        props = props or {}
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local headerH = hasDesc and 56 or 38
        local frame = newElement(page, headerH)
        addTexts(frame, props, headerH, 56)

        local swatch = Instance.new("Frame")
        swatch.Name = "Swatch"
        swatch.AnchorPoint = Vector2.new(1, 0.5)
        swatch.Position = UDim2.new(1, -10, 0.5, 0)
        swatch.Size = UDim2.new(0, 24, 0, 24)
        swatch.BackgroundColor3 = props.Default or Theme.Accent
        swatch.BorderSizePixel = 0
        swatch.Parent = frame
        corner(swatch, 6)
        stroke(swatch, Theme.Stroke, 1, 0.2)

        local color = props.Default or Theme.Accent
        local open = false
        local pickerRowsH = 100
        local Colorpicker = {}

        local function setHeight()
            local h = headerH
            if open then
                h = headerH + 10 + pickerRowsH
            end
            frame.Size = UDim2.new(1, 0, 0, h)
        end

        local panel = Instance.new("Frame")
        panel.Name = "Panel"
        panel.Position = UDim2.new(0, 10, 0, headerH + 5)
        panel.Size = UDim2.new(1, -20, 0, pickerRowsH)
        panel.BackgroundColor3 = Theme.OptionHover
        panel.BackgroundTransparency = 0.25
        panel.BorderSizePixel = 0
        panel.Visible = false
        panel.Parent = frame
        corner(panel, 6)

        local channels = {
            { name = "R", value = math.floor(color.R * 255 + 0.5), fill = Color3.fromRGB(248, 113, 113) },
            { name = "G", value = math.floor(color.G * 255 + 0.5), fill = Color3.fromRGB(74, 222, 128) },
            { name = "B", value = math.floor(color.B * 255 + 0.5), fill = Color3.fromRGB(96, 165, 250) },
        }

        local function renderColor()
            color = Color3.fromRGB(channels[1].value, channels[2].value, channels[3].value)
            swatch.BackgroundColor3 = color
        end

        for i, ch in ipairs(channels) do
            local row = Instance.new("Frame")
            row.Name = "Row_" .. ch.name
            row.Position = UDim2.new(0, 0, 0, (i - 1) * 32)
            row.Size = UDim2.new(1, 0, 0, 32)
            row.BackgroundTransparency = 1
            row.Parent = panel

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.Size = UDim2.new(0, 14, 0, 32)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.TextColor3 = ch.fill
            lbl.Text = ch.name
            lbl.Parent = row

            local val = Instance.new("TextLabel")
            val.Name = "Value"
            val.BackgroundTransparency = 1
            val.AnchorPoint = Vector2.new(1, 0)
            val.Position = UDim2.new(1, -8, 0, 0)
            val.Size = UDim2.new(0, 30, 0, 32)
            val.Font = Enum.Font.GothamMedium
            val.TextSize = 11
            val.TextXAlignment = Enum.TextXAlignment.Right
            val.TextYAlignment = Enum.TextYAlignment.Center
            val.TextColor3 = Theme.SubText
            val.Text = tostring(ch.value)
            val.Parent = row

            local barBg = Instance.new("Frame")
            barBg.Name = "Bar"
            barBg.AnchorPoint = Vector2.new(0, 0.5)
            barBg.Position = UDim2.new(0, 28, 0.5, 0)
            barBg.Size = UDim2.new(1, -78, 0, 6)
            barBg.BackgroundColor3 = Theme.Track
            barBg.BorderSizePixel = 0
            barBg.Parent = row
            corner(barBg, 3)

            local fillBar = Instance.new("Frame")
            fillBar.Name = "Fill"
            fillBar.Size = UDim2.new(ch.value / 255, 0, 1, 0)
            fillBar.BackgroundColor3 = ch.fill
            fillBar.BorderSizePixel = 0
            fillBar.Parent = barBg
            corner(fillBar, 3)

            connectBarDrag(barBg, function(fraction)
                ch.value = math.floor(fraction * 255 + 0.5)
                fillBar.Size = UDim2.new(ch.value / 255, 0, 1, 0)
                val.Text = tostring(ch.value)
                renderColor()
                if type(props.Callback) == "function" then
                    task.spawn(props.Callback, color)
                end
            end)
        end

        local headerHit = Instance.new("TextButton")
        headerHit.Name = "HeaderHit"
        headerHit.Size = UDim2.new(1, 0, 0, headerH)
        headerHit.BackgroundColor3 = Theme.Element
        headerHit.BackgroundTransparency = 1
        headerHit.BorderSizePixel = 0
        headerHit.AutoButtonColor = false
        headerHit.Text = ""
        headerHit.Parent = frame

        headerHit.MouseEnter:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.ElementHover })
        end)
        headerHit.MouseLeave:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.Element })
        end)

        headerHit.Activated:Connect(function()
            open = not open
            panel.Visible = open
            setHeight()
        end)

        function Colorpicker:SetValue(c)
            if typeof(c) ~= "Color3" then
                return
            end
            channels[1].value = math.floor(c.R * 255 + 0.5)
            channels[2].value = math.floor(c.G * 255 + 0.5)
            channels[3].value = math.floor(c.B * 255 + 0.5)
            for i, ch in ipairs(channels) do
                local row = panel:FindFirstChild("Row_" .. ch.name)
                if row then
                    local barBg = row:FindFirstChild("Bar")
                    local fillBar = barBg and barBg:FindFirstChild("Fill")
                    local val = row:FindFirstChild("Value")
                    if fillBar then
                        fillBar.Size = UDim2.new(ch.value / 255, 0, 1, 0)
                    end
                    if val then
                        val.Text = tostring(ch.value)
                    end
                end
            end
            renderColor()
        end

        setHeight()
        return Colorpicker
    end

    local function addKeybind(page, id, props)
        props = props or {}
        local hasDesc = (type(props.Description) == "string" and props.Description ~= "")
        local height = hasDesc and 56 or 38
        local frame = newElement(page, height)
        addTexts(frame, props, height, 96)

        local keyLabel = Instance.new("TextLabel")
        keyLabel.Name = "Key"
        keyLabel.BackgroundTransparency = 1
        keyLabel.AnchorPoint = Vector2.new(1, 0)
        keyLabel.Position = UDim2.new(1, -10, 0, hasDesc and 8 or 0)
        keyLabel.Size = UDim2.new(0, 110, 0, hasDesc and 16 or height)
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 12
        keyLabel.TextXAlignment = Enum.TextXAlignment.Right
        keyLabel.TextYAlignment = Enum.TextYAlignment.Center
        keyLabel.TextColor3 = Theme.Accent
        keyLabel.TextTruncate = Enum.TextTruncate.AtEnd
        keyLabel.Text = "None"
        keyLabel.Parent = frame

        local currentKey = props.Default
        local listening = false
        local Keybind = {}

        local function renderKey()
            if listening then
                keyLabel.Text = "Listening..."
                keyLabel.TextColor3 = Theme.Danger
            elseif currentKey then
                keyLabel.Text = currentKey.Name
                keyLabel.TextColor3 = Theme.Accent
            else
                keyLabel.Text = "None"
                keyLabel.TextColor3 = Theme.SubText
            end
        end

        local listenConn = nil
        local function stopListening()
            listening = false
            if listenConn then
                listenConn:Disconnect()
                listenConn = nil
            end
            renderKey()
        end

        local headerHit = Instance.new("TextButton")
        headerHit.Name = "HeaderHit"
        headerHit.Size = UDim2.new(1, 0, 0, height)
        headerHit.BackgroundColor3 = Theme.Element
        headerHit.BackgroundTransparency = 1
        headerHit.BorderSizePixel = 0
        headerHit.AutoButtonColor = false
        headerHit.Text = ""
        headerHit.Parent = frame

        headerHit.MouseEnter:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.ElementHover })
        end)
        headerHit.MouseLeave:Connect(function()
            tween(frame, 0.12, { BackgroundColor3 = Theme.Element })
        end)

        headerHit.Activated:Connect(function()
            if listening then
                stopListening()
                return
            end
            listening = true
            renderKey()
            listenConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then
                    return
                end
                if input.KeyCode == Enum.KeyCode.Escape then
                    stopListening()
                    return
                end
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
                    currentKey = input.KeyCode
                    stopListening()
                    if type(props.Callback) == "function" then
                        task.spawn(props.Callback, currentKey)
                    end
                end
            end)
        end)

        function Keybind:SetValue(keyCode)
            currentKey = keyCode
            renderKey()
        end

        renderKey()
        return Keybind
    end

    local function addParagraph(page, props)
        props = props or {}
        local frame = newElement(page, 0, true)
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.Size = UDim2.new(1, 0, 0, 0)

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 2, 0, 6)
        title.Size = UDim2.new(1, -4, 0, 16)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Theme.Accent
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.Text = tostring(props.Title or "")
        title.Parent = frame

        local content = Instance.new("TextLabel")
        content.Name = "Content"
        content.BackgroundTransparency = 1
        content.Position = UDim2.new(0, 2, 0, 24)
        content.Size = UDim2.new(1, -4, 0, 0)
        content.AutomaticSize = Enum.AutomaticSize.Y
        content.Font = Enum.Font.Gotham
        content.TextSize = 12
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextYAlignment = Enum.TextYAlignment.Top
        content.TextWrapped = true
        content.TextColor3 = Theme.SubText
        content.Text = tostring(props.Content or "")
        content.Parent = frame

        return frame
    end

    -- ===================== TAB CREATION =====================
    function Window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tab = {}
        tab.Title = tostring(tabConfig.Title or "Tab")
        tab.NextOrder = 0

        local Button = Instance.new("Frame")
        Button.Name = "TabButton"
        Button.Size = UDim2.new(1, 0, 0, 34)
        Button.BackgroundColor3 = Theme.Sidebar
        Button.BorderSizePixel = 0
        Button.LayoutOrder = (#tabs + 1)
        Button.Parent = TabList
        corner(Button, 6)

        local AccentBar = Instance.new("Frame")
        AccentBar.Name = "AccentBar"
        AccentBar.Position = UDim2.new(0, 0, 0, 6)
        AccentBar.Size = UDim2.new(0, 3, 1, -12)
        AccentBar.BackgroundColor3 = Theme.Accent
        AccentBar.BorderSizePixel = 0
        AccentBar.Visible = false
        AccentBar.Parent = Button
        corner(AccentBar, 2)

        local iconKey = tostring(tabConfig.Icon or "")
        local iconText = ICONS[iconKey] or ""

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Name = "Icon"
        IconLabel.BackgroundTransparency = 1
        IconLabel.Position = UDim2.new(0, 9, 0, 0)
        IconLabel.Size = UDim2.new(0, 22, 1, 0)
        IconLabel.Font = Enum.Font.GothamMedium
        IconLabel.TextSize = 14
        IconLabel.TextXAlignment = Enum.TextXAlignment.Center
        IconLabel.TextYAlignment = Enum.TextYAlignment.Center
        IconLabel.TextColor3 = Theme.SubText
        IconLabel.Text = iconText
        IconLabel.Parent = Button

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "Title"
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, iconText ~= "" and 34 or 12, 0, 0)
        TitleLabel.Size = UDim2.new(1, (iconText ~= "" and 44 or 22), 1, 0)
        TitleLabel.Font = Enum.Font.GothamMedium
        TitleLabel.TextSize = 12
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center
        TitleLabel.TextColor3 = Theme.SubText
        TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        TitleLabel.Text = tab.Title
        TitleLabel.Parent = Button

        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                selectTab(tab)
            end
        end)
        Button.MouseEnter:Connect(function()
            if selectedTab ~= tab then
                tween(Button, 0.12, { BackgroundColor3 = Theme.ElementHover })
            end
        end)
        Button.MouseLeave:Connect(function()
            if selectedTab ~= tab then
                tween(Button, 0.12, { BackgroundColor3 = Theme.Sidebar })
            end
        end)

        local Page = Instance.new("ScrollingFrame")
        Page.Name = "Page"
        Page.Position = UDim2.new(0, 0, 0, 43)
        Page.Size = UDim2.new(1, 0, 1, -43)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 4
        Page.ScrollBarImageColor3 = Theme.Stroke
        Page.CanvasSize = UDim2.new()
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollingDirection = Enum.ScrollingDirection.Y
        Page.Visible = false
        Page.Parent = Content

        local pagePadding = Instance.new("UIPadding")
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingBottom = UDim.new(0, 12)
        pagePadding.PaddingLeft = UDim.new(0, 12)
        pagePadding.PaddingRight = UDim.new(0, 12)
        pagePadding.Parent = Page

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.Parent = Page

        tab.Button = Button
        tab.AccentBar = AccentBar
        tab.Page = Page

        function tab:AddSection(title)
            return addSection(Page, title)
        end

        function tab:AddToggle(elementId, elementProps)
            return addToggle(Page, elementId, elementProps)
        end

        function tab:AddSlider(elementId, elementProps)
            return addSlider(Page, elementId, elementProps)
        end

        function tab:AddDropdown(elementId, elementProps)
            return addDropdown(Page, elementId, elementProps)
        end

        function tab:AddButton(elementProps)
            return addButton(Page, elementProps)
        end

        function tab:AddColorpicker(elementId, elementProps)
            return addColorpicker(Page, elementId, elementProps)
        end

        function tab:AddKeybind(elementId, elementProps)
            return addKeybind(Page, elementId, elementProps)
        end

        function tab:AddParagraph(elementProps)
            return addParagraph(Page, elementProps)
        end

        table.insert(tabs, tab)
        if #tabs == 1 then
            selectTab(tab)
        end
        return tab
    end

    -- ===================== WINDOW CONTROLS =====================
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function makeDraggable(handle)
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
            end
        end)
    end
    makeDraggable(Topbar)
    makeDraggable(SideHeader)

    local dragMoveConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    local dragEndConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(windowConnections, dragMoveConn)
    table.insert(windowConnections, dragEndConn)

    MinimizeBtn.Activated:Connect(function()
        setMinimized(true)
    end)
    CloseBtn.Activated:Connect(function()
        Window:Destroy()
    end)
    Dock.Activated:Connect(function()
        setMinimized(false)
    end)

    local keyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.KeyCode == minimizeKey then
            setMinimized(not minimized)
        end
    end)
    table.insert(windowConnections, keyConn)

    function Window:Destroy()
        for _, c in ipairs(windowConnections) do
            pcall(function() c:Disconnect() end)
        end
        windowConnections = {}
        pcall(function() Main:Destroy() end)
        pcall(function() Dock:Destroy() end)
    end

    function Window:Toggle()
        setMinimized(not minimized)
    end

    function Window:Minimize()
        setMinimized(true)
    end

    function Window:SetTitle(title, subTitle)
        if title then
            WindowTitle.Text = tostring(title)
        end
        if subTitle then
            WindowSubTitle.Text = tostring(subTitle)
        end
    end

    return Window
end

return GemoroiUI
