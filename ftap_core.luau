--[[
    Project: FTAP-Gemoroi
    Core Script (ftap_core.luau) - Fully functional with operational ESP, Auras, Physics, and GemoroiUI (Lime Dark) bindings
    v3.6 - GemoroiUI Lime Dark Neon (EMBEDDED), Third Person Fix, PCLD Boxes, Profile ESP,
    Overhead Tags, X-Ray, Map Customizer, Soap FPS Boost, Water Walk, Fly, Pose Pack,
    Limb Controls, Silent Aim Hook, Fling Aura, Chat Spammer, Shuriken Desync,
    Auto Spin Slots, Auto Reconnect, Keybinds Tab (152 UI elements)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local S = {
    Players = Players,
    RunService = RunService,
    ReplicatedStorage = ReplicatedStorage,
    UserInputService = UserInputService,
    Workspace = Workspace,
    CoreGui = CoreGui,
    TweenService = TweenService,
    TextService = game:GetService("TextService"),
    StarterGui = StarterGui,
    TeleportService = TeleportService,
    HttpService = HttpService
}

-- ==== BEGIN EMBEDDED GemoroiUI (Lime Dark Neon) ===================================
-- Auto-synced from /GemoroiUI.luau by the build script - do not edit here.
local GemoroiUI = (function()
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

end)()
-- ==== END EMBEDDED GemoroiUI =====================================================

local function Notify(title, content, duration)
    pcall(function()
        if GemoroiUI and typeof(GemoroiUI.Notify) == "function" then
            GemoroiUI:Notify({
                Title = tostring(title or "FTAP-Gemoroi"),
                Content = tostring(content or ""),
                Duration = duration or 3
            })
        else
            StarterGui:SetCore("SendNotification", {
                Title = tostring(title or "FTAP-Gemoroi"),
                Text = tostring(content or ""),
                Duration = duration or 3
            })
        end
    end)
end
local AmethystFeatures = {
    Selected = {
        kickPlayer = nil,
        players = {},
        multiSelect = false,
        currentPlayer = nil,
        currentButton = nil
    },
    Teleport = {
        loop = {
            enabled = false,
            target = CFrame.new(3, -7, -2),
            loopThread = nil
        },
        houses = {
            {"Pink House", CFrame.new(-491, -7, -166)},
            {"Green House", CFrame.new(-535, -7, 93)},
            {"Purple House", CFrame.new(250, -6, 463)},
            {"China House", CFrame.new(554, 123, -72)},
            {"Blue House", CFrame.new(510, 83, -339)},
            {"Spawn", CFrame.new(3, -7, -2)}
        }
    },
    Speed = {
        value = 16,
        min = 16,
        max = 10000,
        enabled = false,
        originalWalkSpeed = nil,
        connection = nil
    },
    ThirdPerson = {
        enabled = false
    },
    PCLD = {
        Enabled = false,
        Boxes = {},
        NameTags = {},
        Connections = {}
    },
    PacketLag = {
        enabled = false,
        loopThread = nil,
        packetSize = 100,
        minSize = 100,
        maxSize = 1000000
    },
    KickNotify = {
        enabled = false,
        connection = nil,
        notifications = {},
        notificationQueue = {},
        processedKicks = {}
    },
    Gucci = {
        active = false,
        blobman = nil,
        connection = nil,
        remotes = {}
    },
    GucciTractor = {
        enabled = false,
        busy = false,
        currentTractor = nil,
        seatMonitorConn = nil,
        loopThread = nil
    },
    AntiLag = {
        enabled = false
    },
    RemoveAntiKick = {
        enabled = false,
        targetPlayer = nil,
        loopThread = nil
    },
    AntiGrab = {
        enabled = false,
        antiGrabEnabled = false
    },
    SafePos = {
        enabled = false,
        target = nil,
        loopThread = nil
    },
    AutoSitBlob = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil
    },
    AntiKickReset = {
        enabled = false,
        connection = nil
    },
    AntiStick = {
        enabled = false,
        loopThread = nil
    },
    AntiKickStick = {
        enabled = false,
        loopThread = nil,
        selectedItem = "NinjaShuriken",
        items = {
            "NinjaShuriken",
            "NinjaKunai",
            "ToolPencil",
            "ToolPickaxe",
            "ToolDiggingForkRusty",
            "ToolCleaver",
            "NinjaKatana"
        }
    },
    -- XOCU Integration
    XOCU = {
        KickMode = "Kick",
        AntiLag = false,
        LoopThread = nil
    },

    LoopKick = {
        enabled = false,
        loopThread = nil
    },
    PermanentPallet = {
        enabled = false,
        loopThread = nil,
        currentPallet = nil,
        isReady = false
    },
    RagdollAura = {
        enabled = false,
        loopThread = nil,
        ragdolledPlayers = {},
        isTeleportingPallet = false
    },
    RagdollLoopKick = {
        enabled = false,
        loopThread = nil,
        savedPos = nil,
        dragging = false,
        grabStart = 0
    },
    SelfGrab = {
        enabled = false,
        loopThread = nil,
        MyBlob = nil,
        OriginalMassless = nil,
        OriginalPosition = nil,
        WasGrabbedByEnemy = false,
        ProcessingGrab = false,
        ProcessingRelease = false,
        GrabCooldown = 0,
        RegrabActive = false,
        SpawningBlob = false
    },
    BlobKill = {
        enabled = false,
        selectedPlayers = {},
        loopThread = nil,
        barrierThread = nil,
        currentBlob = nil
    },
    BlobKickDual = {
        enabled = false,
        loopThread = nil,
        bp = nil,
        lastTargetChar = nil
    },
    Fly = {
        Enabled = false,
        Speed = 100,
        BV = nil,
        BG = nil,
        Connections = {}
    },
    ServerLag = {
        enabled = false,
        loopThread = nil
    },
    AntiInputLag = {
        enabled = false,
        loopThread = nil,
        currentItem = nil,
        selectedItem = "FoodHamburger",
        items = {
            "FoodHamburger",
            "InstrumentDrumBongos",
            "InstrumentBrassTrumpet",
            "InstrumentBrassBugle",
            "InstrumentVoiceMicrophone",
            "InstrumentWoodwindOcarina",
            "InstrumentGuitarUkulele",
            "InstrumentGuitarLyre",
            "InstrumentGuitarBanjo",
            "InstrumentGuitarAcoustic",
            "CupMugBrown",
            "CupMugWhite",
            "FoodBanana",
            "FoodBread",
            "FoodBroccoli",
            "FoodCakePink",
            "FoodCoconut",
            "FoodDippyEgg",
            "FoodDonut",
            "FoodFrenchFries",
            "FoodHotdog",
            "FoodMayonnaise",
            "FoodMeatStick",
            "FoodMushroomPoison",
            "FoodPizzaCheese",
            "FoodPizzaPepperoni",
            "FoodSodaCan",
            "PoopPile",
            "PoopPileSparkle"
        }
    },
    AntiRagdoll = {
        enabled = false,
        connections = {},
        ragdolledSit = false
    },
    KillAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        spawningBlob = false,
        killCooldown = {},
        targetPlayers = {},
        lastKillTime = 0
    },
    AntiBlob = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    WaterWalk = {
        enabled = false,
        waterParts = {},
        originalStates = {}
    },
    AntiBurn = {
        enabled = false,
        connection1 = nil,
        connection2 = nil,
        currentBarrier = nil
    },
    AntiVoid = {
        enabled = false,
        loopThread = nil,
        originalDestroyHeight = -100
    },
    AntiPaint = {
        enabled = false,
        connection = nil
    },
    AdvancedDuallock = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        targetPlayer = nil
    },
    LoopSnowball = {
        enabled = false,
        loopThread = nil,
        currentSnowball = nil,
        soundPart = nil,
        selectedPlayer = nil
    },
    DestroyKickAura = {
        enabled = false,
        loopThread = nil,
        currentBlob = nil,
        processedPlayers = {},
        spawnInterval = 0,
        isSpawning = false,
        lastSpawnTime = 0
    },
    DeleteLegs = {
        enabled = false,
        monitoringThread = nil,
        hipHeightAdjusted = false
    },
    AntiExplode = {
        enabled = false,
        connection = nil,
        bombEvent = nil
    },
    AutoGucci = {
        enabled = false,
        monitoringThread = nil,
        connection = nil,
        safePosition = nil,
        restoreFrames = 0
    },
    AntiBananaEat = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedBananas = {},
        processedFolders = {}
    },
    AntiAntiInput = {
        enabled = false,
        loopThread = nil,
        scanConnection = nil,
        processedItems = {},
        processedFolders = {}
    },
    AntiBarrier = {
        enabled = false,
        originalStates = {}
    },
    AntiInvisible = {
        enabled = false,
        loopThread = nil
    },
    SantaSleighGucci = {
        enabled = false
    },
    Noclip = {
        enabled = false,
        connection = nil,
        parts = {}
    },
    JumpKickAura = {
        enabled = false,
        loopThread = nil,
        processedPlayers = {}
    },
    KickAuraFixed = {
        enabled = false,
        loopThread = nil,
        fixedPlayers = {}
    }
}

local Features = AmethystFeatures

local KickNotify = AmethystFeatures.KickNotify
local TeleportCfg = AmethystFeatures.Teleport
local SpeedCfg = AmethystFeatures.Speed
local AntiGrabCfg = AmethystFeatures.AntiGrab
local SafePosCfg = AmethystFeatures.SafePos
local AutoSitCfg = AmethystFeatures.AutoSitBlob
local AntiKickResetCfg = AmethystFeatures.AntiKickReset
local AntiKickStickCfg = AmethystFeatures.AntiKickStick
local LoopKickCfg = AmethystFeatures.LoopKick
local PermanentPalletCfg = AmethystFeatures.PermanentPallet
local RagdollAuraCfg = AmethystFeatures.RagdollAura
local RagdollLoopKickCfg = AmethystFeatures.RagdollLoopKick
local SelfGrabCfg = AmethystFeatures.SelfGrab
local BlobKillCfg = AmethystFeatures.BlobKill
local BlobKickDualCfg = AmethystFeatures.BlobKickDual
local ServerLagCfg = AmethystFeatures.ServerLag
local AntiInputLagCfg = AmethystFeatures.AntiInputLag
local AntiRagdollCfg = AmethystFeatures.AntiRagdoll
local KillAuraCfg = AmethystFeatures.KillAura
local AntiBlobCfg = AmethystFeatures.AntiBlob
local AntiBurnCfg = AmethystFeatures.AntiBurn
local AntiVoidCfg = AmethystFeatures.AntiVoid
local AntiPaintCfg = AmethystFeatures.AntiPaint
local AdvancedDuallockCfg = AmethystFeatures.AdvancedDuallock
local LoopSnowballCfg = AmethystFeatures.LoopSnowball
local DestroyKickAuraCfg = AmethystFeatures.DestroyKickAura
local DeleteLegsCfg = AmethystFeatures.DeleteLegs
local AutoGucciCfg = AmethystFeatures.AutoGucci
local AntiAntiInputCfg = AmethystFeatures.AntiAntiInput
local AntiBarrierCfg = AmethystFeatures.AntiBarrier
local AntiInvisibleCfg = AmethystFeatures.AntiInvisible
local NoclipCfg = AmethystFeatures.Noclip
local JumpKickAuraCfg = AmethystFeatures.JumpKickAura
local KickAuraFixedCfg = AmethystFeatures.KickAuraFixed

local findFirstChild = function(parent, name)
    if not parent then
        return nil
    end
    return parent:FindFirstChild(name)
end

local function PlaySound(soundId, delayTime)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        task.delay(delayTime, function()
            if sound and sound.IsPlaying then
                sound:Stop()
                sound:Destroy()
            end
        end)
    end)
end

local function PlayEnableSound()
    PlaySound("8745692251", 3)
end

local function PlayKickSound()
    PlaySound("5463227301", 4.7)
end

local function GetCharHumanoid()
    local character = LocalPlayer and LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

local function ApplySpeed(dt)
    if not SpeedCfg.enabled then
        return
    end
    local character = LocalPlayer.Character
    if not character then
        return
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then
        return
    end
    humanoid.WalkSpeed = SpeedCfg.value
    local move = humanoid.MoveDirection
    if move.Magnitude > 0 then
        local delta = move.Unit * SpeedCfg.value * dt * 0.1
        root.CFrame = root.CFrame + Vector3.new(delta.X, 0, delta.Z)
    end
end

local function EnableSpeed()
    if SpeedCfg.enabled then
        return
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        SpeedCfg.originalWalkSpeed = humanoid.WalkSpeed
    end
    SpeedCfg.enabled = true
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    SpeedCfg.connection = S.RunService.Stepped:Connect(function(_, dt)
        ApplySpeed(dt)
    end)
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
    end
    SpeedCfg.charConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        if SpeedCfg.enabled then
            EnableSpeed()
        end
    end)
end

local function DisableSpeed()
    SpeedCfg.enabled = false
    if SpeedCfg.connection then
        SpeedCfg.connection:Disconnect()
        SpeedCfg.connection = nil
    end
    if SpeedCfg.charConnection then
        SpeedCfg.charConnection:Disconnect()
        SpeedCfg.charConnection = nil
    end
    local humanoid = GetCharHumanoid()
    if humanoid then
        humanoid.WalkSpeed = SpeedCfg.originalWalkSpeed
    end
end

local function ApplyHighlight(model)
    if not model or not model.Parent then
        return
    end
    local existing = model:FindFirstChild("Amethyst_FullHighlight")
    if existing then
        existing:Destroy()
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "Amethyst_FullHighlight"
    highlight.FillColor = Color3.fromRGB(170, 100, 255)
    highlight.OutlineColor = Color3.fromRGB(140, 90, 220)
    highlight.OutlineTransparency = .1
    highlight.FillTransparency = .2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = model
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = .95
            if part:FindFirstChildOfClass("Texture") then
                part.Material = Enum.Material.ForceField
            end
        end
    end
    return highlight
end

local function GetStickRemotes()
    local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    local stickyEvent = S.ReplicatedStorage.PlayerEvents:WaitForChild("StickyPartEvent")
    return spawnToy, destroyToy, setOwner, stickyEvent
end

local function PlayerInPlot(playerName)
    local folder = S.Workspace.PlotItems.PlayersInPlots
    if not folder:FindFirstChild(playerName) then
        return false
    end
    for _, plot in pairs(S.Workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local owners = sign:FindFirstChild("ThisPlotsOwners")
            if owners then
                for _, owner in pairs(sign:GetChildren()) do
                    if owner.Name == "Value" and owner.Value == playerName then
                        return true, S.Workspace.PlotItems:FindFirstChild(plot.Name)
                    end
                end
            end
        end
    end
    return false
end

local function GetRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    local newChar = LocalPlayer.CharacterAdded:Wait()
    return newChar:WaitForChild("HumanoidRootPart")
end

local function SpawnSelectedItem()
    local item = AntiKickStickCfg.selectedItem
    while not LocalPlayer.CanSpawnToy.Value do
        if not AntiKickStickCfg.enabled or tick() - tick() > 5 then
            return nil
        end
        task.wait()
    end
    local root = GetRoot()
    if root then
        local cframe = root.CFrame * CFrame.new(0, 12, 20)
        task.spawn(function()
            local spawnToy = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
            spawnToy:InvokeServer(item, cframe, Vector3.new(0, 0, 0))
        end)
    end
    local inPlot, plotFolder = PlayerInPlot(LocalPlayer.Name)
    local folder = S.Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
    if inPlot then
        return plotFolder:WaitForChild(item, 2)
    end
    return folder:WaitForChild(item, 2) or (S.Workspace.PlotItems.PlayersInPlots:FindFirstChild(LocalPlayer.Name) and folder and folder:WaitForChild(item, 2)) or nil
end

local function DestroyAllItems(player)
    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
    if not folder then
        return
    end
    local destroyToy = S.ReplicatedStorage.MenuToys.DestroyToy
    for _, toy in pairs(folder:GetChildren()) do
        if toy.Name == AntiKickStickCfg.selectedItem then
            destroyToy:FireServer(toy)
        end
    end
end

local function GiveNetworkOwner(model, ownerName)
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    if not GetRoot() then
        return
    end
    local setOwner = S.ReplicatedStorage.GrabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= ownerName then
            setOwner:FireServer(soundPart, soundPart.CFrame)
        end
    end
end

local function MakeAntiKick(model, player)
    local lp = player.Character
    if not lp or not lp:FindFirstChild("HumanoidRootPart") then
        return
    end
    if not model or not model:FindFirstChild("StickyPart") then
        return
    end
    local root = lp.HumanoidRootPart
    local firePart = root:FindFirstChild("FirePlayerPart")
    if not firePart then
        firePart = Instance.new("Part")
        firePart.Name = "FirePlayerPart"
        firePart.Size = Vector3.new(1, 1, 1)
        firePart.Transparency = 1
        firePart.CanCollide = false
        firePart.CanQuery = false
        firePart.Anchored = true
        firePart.Parent = root
        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = firePart
        weld.C0 = CFrame.new(0, 0, 0)
        weld.Parent = firePart
    end
    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
    local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
    if model:FindFirstChild("SoundPart") then
        local soundPart = model.SoundPart
        if not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= player.Name then
            pcall(function()
                setOwner:FireServer(soundPart, soundPart.CFrame)
            end)
        end
    end
    local playerEvents = S.ReplicatedStorage:WaitForChild("PlayerEvents")
    local stickyEvent = playerEvents:WaitForChild("StickyPartEvent")
    pcall(function()
        stickyEvent:FireServer(model.StickyPart, firePart, CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(90), math.rad(90)))
    end)
    local sticky = model:FindFirstChild("StickyPart")
    if sticky then
        sticky.Transparency = 1
        sticky.CanCollide = false
        sticky.CanQuery = false
    end
    local soundPart = model:FindFirstChild("SoundPart")
    if soundPart then
        soundPart.Transparency = 1
        soundPart.CanCollide = false
        soundPart.CanQuery = false
    end
    ApplyHighlight(model)
    if not model:FindFirstChild("Amethyst_Atmosphere") then
        local atmosphere = Instance.new("Atmosphere", model)
        atmosphere.Name = "Amethyst_Atmosphere"
        atmosphere.Color = Color3.fromRGB(170, 100, 255)
        atmosphere.Decay = Color3.fromRGB(50, 30, 80)
        atmosphere.Glare = .2
        atmosphere.Haze = .1
        atmosphere.Density = .3
    end
    if not model:FindFirstChild("Amethyst_PointLight") then
        local light = Instance.new("PointLight", model)
        light.Name = "Amethyst_PointLight"
        light.Color = Color3.fromRGB(170, 100, 255)
        light.Range = 15
        light.Brightness = 0.5
        light.Shadows = true
    end
    if model.PrimaryPart then
        model:SetPrimaryPartCFrame(root.CFrame)
    end
    model.Name = "AntiKick"
    task.delay(.1, function()
        if model and model.Parent then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "StickyPart" and part.Name ~= "SoundPart" then
                    part.Transparency = 0.5
                end
            end
        end
    end)
end

if not GemoroiUI then
    warn("[FTAP-Gemoroi] Failed to load GemoroiUI (Lime Dark) library.")
    return
end

local Window = GemoroiUI:CreateWindow({
    Title = "FTAP - Gemoroi v3.5 (Lime Dark Edition)",
    SubTitle = "by keksup22 - GemoroiUI",
    TabWidth = 170,
    Size = UDim2.fromOffset(620, 480),
    Acrylic = true,
    Theme = "Lime Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

if not Window then
    warn("[FTAP-Gemoroi] GemoroiUI failed to create the window.")
    return
end

local Tabs = {
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Cosmetics = Window:AddTab({ Title = "Cosmetics & Shaders", Icon = "sparkles" }),
    Mass = Window:AddTab({ Title = "Mass / Troll", Icon = "zap" }),
    Protection = Window:AddTab({ Title = "Protection", Icon = "shield" }),
    Defense = Window:AddTab({ Title = "Defense", Icon = "shield" }),
    Auras = Window:AddTab({ Title = "Auras", Icon = "target" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Config = {
    SilentAimEnabled = false,
    FOVRadius = 120,
    MaxDistance = 200,
    Hitbox = "Head",
    ShowFOV = false,
    WallCheck = true,
    
    WalkspeedEnabled = false,
    WalkspeedValue = 16,
    InfiniteJumpEnabled = false,
    JumpPower = 50,
    NoclipEnabled = false,
    
    ESPEnabled = false,
    ESPColor = Color3.fromRGB(0, 170, 255),
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    
    StrengthEnabled = false,
    StrengthValue = 1,
    KillGrabEnabled = false,
    AntiGrabEnabled = false,
    AntiFlingEnabled = false,
    AntiRagdollAuto = false,
    
    LaunchAuraEnabled = false,
    TelekinesisAuraEnabled = false,
    DeathAuraEnabled = false,
    AuraRadius = 30,
    
    KillTarget = nil,
    LoopKillEnabled = false,
    LoopKillDelay = 0.5,
    LoopKillTarget = nil,
    FlingPower = 1,
    AnchorGrabEnabled = false,
    ModelHighlightEnabled = false,
    ModelBillboardEnabled = false,

    -- GemoroiUI v3.5 features
    ThirdPersonFix = false,
    ThirdPersonDistance = 8,
    PCLD_BoxesEnabled = false,
    PCLD_BoxColor = Color3.fromRGB(57, 255, 20),
    ProfileESPEnabled = false,
    OverheadTagsEnabled = false,
    XRayEnabled = false,
    XRayTransparency = 0.6,
    NoFogEnabled = false,
    WaterWalkEnabled = false,
    ChatSpamEnabled = false,
    ChatSpamDelay = 1,
    ShurikenDesyncEnabled = false,
    FlingAuraEnabled = false,
    FlingAuraRadius = 30,
    LaunchGrab = false,
    ZeroVelocityGrab = false,
    SilentAimHook = false,
    ClickTPEnabled = false
}

-- Safe FOV Circle
local fovCircle
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.NumSides = 64
    fovCircle.Radius = Config.FOVRadius
    fovCircle.Filled = false
    fovCircle.Transparency = 1
    fovCircle.Color = Color3.fromRGB(0, 170, 255)
    fovCircle.Visible = false
end)

local function getCharacter(player)
    return player and player.Character
end

local function getHumanoid(player)
    local character = getCharacter(player)
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot(player)
    local character = getCharacter(player)
    return character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))
end

local function getHitPart(player)
    local character = getCharacter(player)
    if not character then return nil end
    return character:FindFirstChild(Config.Hitbox) or character:FindFirstChild("Head") or getRoot(player)
end

local function isVisible(part)
    if not Config.WallCheck or not part then return true end
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    local result = Workspace:Raycast(origin, part.Position - origin, params)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function getClosestPlayer()
    local closest, closestDist = nil, Config.FOVRadius
    local mousePos = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local hitPart = getHitPart(player)
            local humanoid = getHumanoid(player)
            if hitPart and humanoid and humanoid.Health > 0 then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(hitPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                    if dist < closestDist and (not Config.WallCheck or isVisible(hitPart)) then
                        closest = hitPart
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

local flingForces = {
    function(root)
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(0, 80 * Config.FlingPower, 0)
        end)
    end,
    function(root)
        pcall(function()
            root.AssemblyLinearVelocity = Camera.CFrame.LookVector * (120 * Config.FlingPower) + Vector3.new(0, 40, 0)
        end)
    end,
    function(root)
        pcall(function()
            root.AssemblyAngularVelocity = Vector3.new(0, 80 * Config.FlingPower, 0)
            root.AssemblyLinearVelocity = Vector3.new(0, 150 * Config.FlingPower, 0)
        end)
        pcall(function()
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(1, 1, 1) * 1e9
            bav.P = 1e9
            bav.AngularVelocity = Vector3.new(0, 80 * Config.FlingPower, 0)
            bav.Parent = root
            task.delay(0.5, function()
                pcall(function() bav:Destroy() end)
            end)
        end)
    end,
    function(root)
        pcall(function()
            root.CFrame = root.CFrame + Vector3.new(0, 20 * Config.FlingPower, 0)
            root.AssemblyLinearVelocity = Vector3.new(0, 200 * Config.FlingPower, 0)
        end)
    end,
    function(root)
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(math.random(-1,1), 1, math.random(-1,1)).Unit * (250 * Config.FlingPower)
        end)
        pcall(function()
            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(1, 1, 1) * 1e9
            bav.P = 1e9
            bav.AngularVelocity = Vector3.new(1e5, 1e5, 1e5)
            bav.Parent = root
            task.delay(0.5, function()
                pcall(function() bav:Destroy() end)
            end)
        end)
    end,
    function(root)
        pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 500, 0))
        end)
        pcall(function()
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(0, 1e5, 0)
            bv.Parent = root
            task.delay(0.5, function()
                pcall(function() bv:Destroy() end)
            end)
        end)
    end,
}
local playerNames = { "None" }
local function flingClosestTarget()
    local closest, dist = nil, 50
    local myRoot = getRoot(LocalPlayer)
    if not myRoot then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local root = getRoot(player)
            if root then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < dist then
                    closest = player
                    dist = d
                end
            end
        end
    end
    if closest then
        local root = getRoot(closest)
        if root then
            pcall(function()
                local setNetOwner = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("SetNetworkOwner")
                if setNetOwner then
                    setNetOwner:FireServer(root, root.CFrame)
                end
            end)
            task.wait(0.05)
            local power = math.clamp(math.floor(Config.FlingPower), 1, 6)
            pcall(function()
                flingForces[power](root)
            end)
            GemoroiUI:Notify({ Title = "Fling", Content = "Flinged " .. closest.Name .. " (Power " .. power .. ")", Duration = 2 })
        end
    else
        GemoroiUI:Notify({ Title = "Fling", Content = "No player nearby to fling!", Duration = 2 })
    end
end

-- Safe recursive part checker (avoiding infinite loops)
local function getSafeParts(model)
    local parts = {}
    if not model then return parts end
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant and descendant:IsA("BasePart") then
            table.insert(parts, descendant)
        end
    end
    return parts
end

local function refreshPlayers()
    playerNames = { "None" }
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
end
refreshPlayers()

-- === ESP SYSTEM ===
local espHighlights = {}
local pcldHighlights = {}

local function updatePCLDESP()
    if not Config.PCLD_ESPEnabled then
        for _, hl in pairs(pcldHighlights) do
            if hl then hl:Destroy() end
        end
        pcldHighlights = {}
        return
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector" or obj.Name == "FirePlayerPart") then
            if not pcldHighlights[obj] then
                local hl = Instance.new("Highlight")
                hl.Name = "PCLD_ESP_Highlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.3
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                pcldHighlights[obj] = hl
            end
        end
    end
end

local function updateESPHighlights()
    if not Config.ESPEnabled then
        for _, hl in pairs(espHighlights) do
            if hl then hl:Destroy() end
        end
        espHighlights = {}
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            if not espHighlights[player] and char:FindFirstChild("HumanoidRootPart") then
                local hl = Instance.new("Highlight")
                hl.Name = "FTAP_ESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Config.ESPColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = CoreGui
                espHighlights[player] = hl
            elseif espHighlights[player] then
                local hl = espHighlights[player]
                if hl.Adornee ~= char or not char.Parent then
                    hl:Destroy()
                    espHighlights[player] = nil
                else
                    hl.FillColor = Config.ESPColor
                end
            end
        else
            if espHighlights[player] then
                espHighlights[player]:Destroy()
                espHighlights[player] = nil
            end
        end
    end
end

local workspaceModelHighlights = {}
local workspaceModelBillboards = {}

local function updateModelHighlights(state)
    Config.ModelHighlightEnabled = state
    pcall(function()
        if not state then
            for model, hl in pairs(workspaceModelHighlights) do
                if hl then
                    pcall(function() hl:Destroy() end)
                end
            end
            workspaceModelHighlights = {}
        else
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    if not workspaceModelHighlights[obj] or not workspaceModelHighlights[obj].Parent then
                        pcall(function()
                            local hl = Instance.new("Highlight")
                            hl.Name = "FTAP_Model_Highlight"
                            hl.Adornee = obj
                            hl.FillColor = Color3.fromRGB(0, 255, 170)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = CoreGui
                            workspaceModelHighlights[obj] = hl
                        end)
                    end
                end
            end
        end
    end)
end

local function updateModelBillboards(state)
    Config.ModelBillboardEnabled = state
    pcall(function()
        if not state then
            for model, gui in pairs(workspaceModelBillboards) do
                if gui then
                    pcall(function() gui:Destroy() end)
                end
            end
            workspaceModelBillboards = {}
        else
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primaryPart and (not workspaceModelBillboards[obj] or not workspaceModelBillboards[obj].Parent) then
                        pcall(function()
                            local bb = Instance.new("BillboardGui")
                            bb.Name = "FTAP_Model_Billboard"
                            bb.Adornee = primaryPart
                            bb.Size = UDim2.new(0, 100, 0, 30)
                            bb.StudsOffset = Vector3.new(0, 3, 0)
                            bb.AlwaysOnTop = true

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = obj.Name
                            label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            label.TextScaled = true
                            label.Font = Enum.Font.SourceSansBold
                            label.Parent = bb

                            bb.Parent = CoreGui
                            workspaceModelBillboards[obj] = bb
                        end)
                    end
                end
            end
        end
    end)
end


-- ============================================================================
-- GemoroiUI v3.5 FEATURES: Third Person Fix, PCLD BoxHandleAdornments,
-- Profile ESP (Avatars), Soap Textures FPS Boost, Auto Spin Slots
-- ============================================================================

-- === THIRD PERSON VIEW FIX (RenderStepped) ===
-- The game force-locks the camera to first person. This re-enforces Classic
-- camera mode + zoom distances on every RenderStepped frame so it stays unlocked.
local function setThirdPersonFix(state)
    Config.ThirdPersonFix = state
    pcall(function()
        if state then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = Config.ThirdPersonDistance
            Notify("3rd Person Fix", "Enabled - camera unlocked every frame (" .. tostring(Config.ThirdPersonDistance) .. " studs)", 3)
        else
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 0.5
            Notify("3rd Person Fix", "Disabled - first person restored", 2)
        end
    end)
end

-- === PCLD BOXHANDLEADORNMENTS ===
-- Draws lime 3D boxes on the hidden physics hitboxes ("partesp" /
-- "playercharacterlocationdetector") using BoxHandleAdornment.
local pcldBoxAdornments = {}
local pcldBoxWatchers = {}

local function isPCLDPart(obj)
    return obj:IsA("BasePart") and (obj.Name == "partesp" or obj.Name == "playercharacterlocationdetector" or obj.Name == "FirePlayerPart")
end

local function addPCLDBox(obj)
    if pcldBoxAdornments[obj] then
        return
    end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "PCLD_BoxAdornment"
    box.Adornee = obj
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = Config.PCLD_BoxColor
    box.Transparency = 0.3
    box.Size = obj.Size
    box.Parent = CoreGui
    pcldBoxAdornments[obj] = box

    local conn = obj.AncestryChanged:Connect(function(_, parent)
        if not parent and pcldBoxAdornments[obj] then
            pcall(function() pcldBoxAdornments[obj]:Destroy() end)
            pcldBoxAdornments[obj] = nil
        end
    end)
    table.insert(pcldBoxWatchers, conn)
end

local function updatePCLDBoxes()
    if not Config.PCLD_BoxesEnabled then
        for _, box in pairs(pcldBoxAdornments) do
            if box then
                pcall(function() box:Destroy() end)
            end
        end
        pcldBoxAdornments = {}
        for _, c in ipairs(pcldBoxWatchers) do
            pcall(function() c:Disconnect() end)
        end
        pcldBoxWatchers = {}
        return
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isPCLDPart(obj) and obj.Parent then
            addPCLDBox(obj)
        end
    end

    for obj, box in pairs(pcldBoxAdornments) do
        if not box or not box.Parent or not obj or not obj.Parent then
            if box then
                pcall(function() box:Destroy() end)
            end
            pcldBoxAdornments[obj] = nil
        end
    end
end

local pcldBoxLoop = nil

local function setPCLDBoxes(state)
    Config.PCLD_BoxesEnabled = state
    if state then
        pcall(updatePCLDBoxes)
        pcldBoxLoop = task.spawn(function()
            while Config.PCLD_BoxesEnabled do
                task.wait(0.5)
                pcall(updatePCLDBoxes)
            end
        end)
        Notify("PCLD Boxes", "BoxHandleAdornments Enabled (boxes on hidden hitboxes)", 2)
    else
        if pcldBoxLoop then
            task.cancel(pcldBoxLoop)
            pcldBoxLoop = nil
        end
        pcall(updatePCLDBoxes)
        Notify("PCLD Boxes", "Disabled", 2)
    end
end

-- === PROFILE ESP (AVATARS ABOVE HEAD) ===
-- Shows the player's real avatar thumbnail, display name, @username and a
-- health bar floating above their head.
local profileESP = { records = {}, loop = nil, thumbCache = {} }

-- Avatar headshots via rbxthumb:// (synchronous, no API call needed)
local function getProfileThumb(player)
    return "rbxthumb://type=HeadShot&id=" .. tostring(player.UserId) .. "&w=420&h=420"
end

local function createProfileBillboard(player)
    task.spawn(function()
        if not Config.ProfileESPEnabled then
            return
        end
        if profileESP.records[player] then
            return
        end
        local char = player.Character
        if not char then
            return
        end
        local head = char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart")
        if not head then
            return
        end

        local bb = Instance.new("BillboardGui")
        bb.Name = "Gemoroi_ProfileESP"
        bb.Adornee = head
        bb.Size = UDim2.new(0, 64, 0, 84)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 1500
        bb.Parent = CoreGui

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.AnchorPoint = Vector2.new(0.5, 0)
        avatar.Position = UDim2.new(0.5, 0, 0, 0)
        avatar.Size = UDim2.new(0, 52, 0, 52)
        avatar.BackgroundColor3 = Color3.fromRGB(16, 20, 17)
        avatar.BorderSizePixel = 0
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.Image = ""
        avatar.Parent = bb
        local avCorner = Instance.new("UICorner")
        avCorner.CornerRadius = UDim.new(0, 26)
        avCorner.Parent = avatar
        local avStroke = Instance.new("UIStroke")
        avStroke.Color = Config.PCLD_BoxColor
        avStroke.Thickness = 1.5
        avStroke.Parent = avatar

        local thumb = getProfileThumb(player)
        if thumb then
            avatar.Image = thumb
        end

        local displayName = Instance.new("TextLabel")
        displayName.Name = "DisplayName"
        displayName.AnchorPoint = Vector2.new(0.5, 0)
        displayName.Position = UDim2.new(0.5, 0, 0, 54)
        displayName.Size = UDim2.new(0, 120, 0, 13)
        displayName.BackgroundTransparency = 1
        displayName.Font = Enum.Font.GothamBold
        displayName.TextSize = 12
        displayName.TextColor3 = Color3.fromRGB(233, 240, 234)
        displayName.TextStrokeTransparency = 0.4
        displayName.TextTruncate = Enum.TextTruncate.AtEnd
        displayName.Text = player.DisplayName or player.Name
        displayName.Parent = bb

        local userName = Instance.new("TextLabel")
        userName.Name = "UserName"
        userName.AnchorPoint = Vector2.new(0.5, 0)
        userName.Position = UDim2.new(0.5, 0, 0, 67)
        userName.Size = UDim2.new(0, 120, 0, 11)
        userName.BackgroundTransparency = 1
        userName.Font = Enum.Font.Gotham
        userName.TextSize = 10
        userName.TextColor3 = Color3.fromRGB(139, 153, 143)
        userName.TextStrokeTransparency = 0.4
        userName.TextTruncate = Enum.TextTruncate.AtEnd
        userName.Text = "@" .. player.Name
        userName.Parent = bb

        local hpBg = Instance.new("Frame")
        hpBg.Name = "HealthBg"
        hpBg.AnchorPoint = Vector2.new(0.5, 0)
        hpBg.Position = UDim2.new(0.5, 0, 0, 80)
        hpBg.Size = UDim2.new(0, 52, 0, 4)
        hpBg.BackgroundColor3 = Color3.fromRGB(11, 14, 12)
        hpBg.BackgroundTransparency = 0.25
        hpBg.BorderSizePixel = 0
        hpBg.Parent = bb
        local hpCorner = Instance.new("UICorner")
        hpCorner.CornerRadius = UDim.new(0, 2)
        hpCorner.Parent = hpBg

        local hpFill = Instance.new("Frame")
        hpFill.Name = "HealthFill"
        hpFill.Size = UDim2.new(1, 0, 1, 0)
        hpFill.BackgroundColor3 = Color3.fromRGB(163, 230, 53)
        hpFill.BorderSizePixel = 0
        hpFill.Parent = hpBg
        local hpFillCorner = Instance.new("UICorner")
        hpFillCorner.CornerRadius = UDim.new(0, 2)
        hpFillCorner.Parent = hpFill

        profileESP.records[player] = { gui = bb, fill = hpFill }
    end)
end

local function updateProfileESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not profileESP.records[player] and player.Character then
            createProfileBillboard(player)
        end
    end
    for player, record in pairs(profileESP.records) do
        if not player.Parent or not record.gui or not record.gui.Parent then
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
            profileESP.records[player] = nil
        else
            local char = player.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
            if head and record.gui.Adornee ~= head then
                record.gui.Adornee = head
            end
            if not record.gui.Avatar.Image or record.gui.Avatar.Image == "" then
                local thumb = getProfileThumb(player)
                if thumb then
                    record.gui.Avatar.Image = thumb
                end
            end
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and record.fill then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                record.fill.Size = UDim2.new(pct, 0, 1, 0)
                record.fill.BackgroundColor3 = Color3.fromRGB(
                    math.floor(255 * (1 - pct)),
                    math.floor(230 * pct),
                    53
                )
            end
        end
    end
end

local function setProfileESP(state)
    Config.ProfileESPEnabled = state
    if state then
        profileESP.loop = task.spawn(function()
            while Config.ProfileESPEnabled do
                pcall(updateProfileESP)
                task.wait(0.5)
            end
        end)
        pcall(updateProfileESP)
        Notify("Profile ESP", "Enabled - avatars above heads", 2)
    else
        if profileESP.loop then
            task.cancel(profileESP.loop)
            profileESP.loop = nil
        end
        for _, record in pairs(profileESP.records) do
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
        end
        profileESP.records = {}
        Notify("Profile ESP", "Disabled", 2)
    end
end

-- === SOAP TEXTURES (FPS BOOST) ===
-- Turns every part into smooth plastic ("soap") and hides all decals /
-- textures. Originals are remembered and fully restored when disabled.
local Soap = { enabled = false, saved = setmetatable({}, { __mode = "k" }), connection = nil }

local function soapifyObject(obj)
    if obj:IsA("BasePart") then
        if not Soap.saved[obj] then
            Soap.saved[obj] = { Material = obj.Material, Color = obj.Color }
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.new(obj.Color.R * 0.75, obj.Color.G * 0.75, obj.Color.B * 0.75)
        end
    elseif obj:IsA("Texture") or obj:IsA("Decal") then
        if not Soap.saved[obj] then
            Soap.saved[obj] = { Transparency = obj.Transparency }
            obj.Transparency = 1
        end
    end
end

local function setSoapTextures(state)
    Soap.enabled = state
    if state then
        Notify("Optimization", "Applying Soap Textures...", 2)
        task.spawn(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                soapifyObject(obj)
            end
            Notify("Optimization", "Soap Textures Applied! Everything is soap now", 2)
        end)
        Soap.connection = Workspace.DescendantAdded:Connect(function(obj)
            task.defer(function()
                if Soap.enabled then
                    pcall(function() soapifyObject(obj) end)
                end
            end)
        end)
    else
        if Soap.connection then
            Soap.connection:Disconnect()
            Soap.connection = nil
        end
        Notify("Optimization", "Restoring original textures...", 2)
        task.spawn(function()
            for obj, orig in pairs(Soap.saved) do
                pcall(function()
                    if obj and obj.Parent then
                        if orig.Material then
                            obj.Material = orig.Material
                            obj.Color = orig.Color
                        end
                        if orig.Transparency then
                            obj.Transparency = orig.Transparency
                        end
                    end
                end)
            end
            Soap.saved = setmetatable({}, { __mode = "k" })
            Notify("Optimization", "Original textures restored!", 2)
        end)
    end
end

-- === AUTO SPIN SLOTS ===
-- Auto-spins the slot machine whenever its timer hits 0:00 (XOCU method):
-- teleport to the handle, take network ownership, spin it, teleport back.
local SlotsFarm = {
    enabled = false,
    thread = nil,
    slotHandle = nil,
    timeText = nil,
    teleportPosition = Vector3.new(177, 91.4, 425.8), -- slot machine wheel (XOCU farm point)
}

local function resolveSlotsRefs()
    pcall(function()
        local slotsFolder = Workspace:FindFirstChild("Slots")
        local slotsModel = slotsFolder and slotsFolder:FindFirstChild("Slots")
        if not slotsModel then
            return
        end
        local handleModel = slotsModel:FindFirstChild("SlotHandle")
        SlotsFarm.slotHandle = handleModel and handleModel:FindFirstChild("Handle")
        local screen = slotsModel:FindFirstChild("Screen")
        local slotGui = screen and screen:FindFirstChild("SlotGui")
        local timeFrame = slotGui and slotGui:FindFirstChild("TimeLeftFrame")
        SlotsFarm.timeText = timeFrame and timeFrame:FindFirstChild("TimeText")
    end)
end

local function getSlotTimeText()
    if not SlotsFarm.timeText or not SlotsFarm.timeText.Parent then
        resolveSlotsRefs()
    end
    if SlotsFarm.timeText then
        return SlotsFarm.timeText.Text
    end
    return nil
end

local function checkSlotTime()
    local timeText = getSlotTimeText()
    if timeText then
        Notify("Slot Time", "Time left: " .. tostring(timeText), 3)
    else
        Notify("Slot Time", "Slot machine not found on this server!", 3)
    end
end

local function teleportToSlots()
    local root = getRoot(LocalPlayer)
    if root then
        root.CFrame = CFrame.new(SlotsFarm.teleportPosition)
        Notify("Teleport", "Teleported to the Slots machine", 2)
    end
end

local function setAutoSpinSlots(state)
    SlotsFarm.enabled = state
    if state then
        resolveSlotsRefs()
        SlotsFarm.thread = task.spawn(function()
            while SlotsFarm.enabled do
                task.wait(1)
                pcall(function()
                    local root = getRoot(LocalPlayer)
                    if not root then
                        return
                    end
                    local timeText = getSlotTimeText()
                    if timeText == "0:00" and SlotsFarm.slotHandle then
                        local savedCF = root.CFrame
                        root.CFrame = CFrame.new(SlotsFarm.teleportPosition)
                        task.wait(1)
                        local remote = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                        remote = remote and remote:FindFirstChild("SetNetworkOwner")
                        if remote then
                            remote:FireServer(SlotsFarm.slotHandle, CFrame.new(SlotsFarm.teleportPosition))
                        end
                        task.wait(1)
                        if root and root.Parent then
                            root.CFrame = savedCF
                        end
                    end
                end)
            end
        end)
        Notify("Slots", "Auto Spin Slots Enabled - spinning when timer hits 0:00", 3)
        PlayEnableSound()
    else
        if SlotsFarm.thread then
            task.cancel(SlotsFarm.thread)
            SlotsFarm.thread = nil
        end
        Notify("Slots", "Auto Spin Slots Disabled", 2)
    end
end


-- ============================================================================
-- GemoroiUI v3.6 FEATURES (part 2): Overhead Tags, X-Ray, Map Customizer,
-- NoFog, Water Walk, Chat Spammer, Shuriken Desync, Pose Pack, Limb Controls,
-- Mirror Animations, Fling Aura, Silent Aim Hook, Phantom Cosmetics,
-- Click TP, Player TP, Auto Reconnect, Keybinds
-- ============================================================================

local function getTargetChar()
    local target = AmethystFeatures.Selected.kickPlayer
    return target and target.Character or nil
end

-- === OVERHEAD BILLBOARD TAGS (name, @user, distance, health bar) ===
local overheadTags = { records = {}, loop = nil }

local function createOverheadTag(player)
    if overheadTags.records[player] then
        return
    end
    local char = player.Character
    local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
    if not head then
        return
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "Gemoroi_OverheadTag"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 140, 0, 44)
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 2000
    bb.Parent = CoreGui

    local name = Instance.new("TextLabel")
    name.BackgroundTransparency = 1
    name.Position = UDim2.new(0, 0, 0, 0)
    name.Size = UDim2.new(1, 0, 0, 14)
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    name.TextColor3 = Color3.fromRGB(240, 244, 248)
    name.TextStrokeTransparency = 0.4
    name.TextTruncate = Enum.TextTruncate.AtEnd
    name.Text = player.DisplayName or player.Name
    name.Parent = bb

    local user = Instance.new("TextLabel")
    user.BackgroundTransparency = 1
    user.Position = UDim2.new(0, 0, 0, 14)
    user.Size = UDim2.new(1, 0, 0, 11)
    user.Font = Enum.Font.Gotham
    user.TextSize = 10
    user.TextColor3 = Color3.fromRGB(148, 158, 170)
    user.TextStrokeTransparency = 0.4
    user.TextTruncate = Enum.TextTruncate.AtEnd
    user.Text = "@" .. player.Name
    user.Parent = bb

    local dist = Instance.new("TextLabel")
    dist.BackgroundTransparency = 1
    dist.Position = UDim2.new(0, 0, 0, 25)
    dist.Size = UDim2.new(1, 0, 0, 11)
    dist.Font = Enum.Font.Gotham
    dist.TextSize = 10
    dist.TextColor3 = Color3.fromRGB(57, 255, 20)
    dist.TextStrokeTransparency = 0.4
    dist.Text = "0 studs"
    dist.Parent = bb

    local hpBg = Instance.new("Frame")
    hpBg.AnchorPoint = Vector2.new(0.5, 0)
    hpBg.Position = UDim2.new(0.5, 0, 0, 38)
    hpBg.Size = UDim2.new(0, 100, 0, 4)
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
    hpBg.BackgroundTransparency = 0.25
    hpBg.BorderSizePixel = 0
    hpBg.Parent = bb
    local hpC = Instance.new("UICorner")
    hpC.CornerRadius = UDim.new(0, 2)
    hpC.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg
    local hpFC = Instance.new("UICorner")
    hpFC.CornerRadius = UDim.new(0, 2)
    hpFC.Parent = hpFill

    overheadTags.records[player] = { gui = bb, fill = hpFill, dist = dist }
end

local function updateOverheadTags()
    local myRoot = getRoot(LocalPlayer)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and not overheadTags.records[player] and player.Character then
            createOverheadTag(player)
        end
    end
    for player, record in pairs(overheadTags.records) do
        if not player.Parent or not record.gui or not record.gui.Parent then
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
            overheadTags.records[player] = nil
        else
            local char = player.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
            if head and record.gui.Adornee ~= head then
                record.gui.Adornee = head
            end
            local root = char and (char:FindFirstChild("HumanoidRootPart") or head)
            if root and myRoot and record.dist then
                record.dist.Text = string.format("%d studs", (root.Position - myRoot.Position).Magnitude)
            end
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and record.fill then
                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                record.fill.Size = UDim2.new(pct, 0, 1, 0)
                record.fill.BackgroundColor3 = Color3.fromRGB(
                    math.floor(255 * (1 - pct)),
                    math.floor(255 * pct * 0.85 + 30),
                    20
                )
            end
        end
    end
end

local function setOverheadTags(state)
    Config.OverheadTagsEnabled = state
    if state then
        overheadTags.loop = task.spawn(function()
            while Config.OverheadTagsEnabled do
                pcall(updateOverheadTags)
                task.wait(0.25)
            end
        end)
        pcall(updateOverheadTags)
        Notify("Overhead Tags", "Enabled - names, distance & health above heads", 2)
    else
        if overheadTags.loop then
            task.cancel(overheadTags.loop)
            overheadTags.loop = nil
        end
        for _, record in pairs(overheadTags.records) do
            if record.gui then
                pcall(function() record.gui:Destroy() end)
            end
        end
        overheadTags.records = {}
        Notify("Overhead Tags", "Disabled", 2)
    end
end

-- === X-RAY VISION ===
local xraySaved = setmetatable({}, { __mode = "k" })

local function isCharacterPart(part)
    local model = part:FindFirstAncestorOfClass("Model")
    return model ~= nil and Players:GetPlayerFromCharacter(model) ~= nil
end

local function setXRay(state)
    Config.XRayEnabled = state
    if state then
        task.spawn(function()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("BasePart") and not obj:IsA("Terrain") and not isCharacterPart(obj)
                        and obj.Name ~= "HoldPart" and obj.Transparency < 0.5 then
                        if not xraySaved[obj] then
                            xraySaved[obj] = { Transparency = obj.Transparency }
                            obj.Transparency = Config.XRayTransparency
                        end
                    elseif (obj:IsA("Decal") or obj:IsA("Texture")) and obj.Transparency < 1 then
                        if not xraySaved[obj] then
                            xraySaved[obj] = { Transparency = obj.Transparency }
                            obj.Transparency = 1
                        end
                    end
                end)
            end
            Notify("X-Ray Vision", "Enabled - walls are see-through (Transparency 0.6)", 2)
        end)
    else
        task.spawn(function()
            for obj, orig in pairs(xraySaved) do
                pcall(function()
                    if obj and obj.Parent and orig.Transparency then
                        obj.Transparency = orig.Transparency
                    end
                end)
            end
            xraySaved = setmetatable({}, { __mode = "k" })
            Notify("X-Ray Vision", "Disabled - map restored", 2)
        end)
    end
end

-- === MAP CUSTOMIZER (Grass / Rock / Sand / Snow live recolor + Reset) ===
local mapCustomizer = { savedParts = setmetatable({}, { __mode = "k" }), savedTerrain = {} }

local function applyMapColor(material, color)
    local matName = material.Name
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and obj.Material == material and not isCharacterPart(obj) then
                    if not mapCustomizer.savedParts[obj] then
                        mapCustomizer.savedParts[obj] = { Color = obj.Color }
                    end
                    obj.Color = color
                    count = count + 1
                end
            end)
        end
        pcall(function()
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                if not mapCustomizer.savedTerrain[matName] then
                    mapCustomizer.savedTerrain[matName] = terrain:GetMaterialColor(material)
                end
                terrain:SetMaterialColor(material, color)
            end
        end)
        Notify("Map Customizer", matName .. " recolored (" .. count .. " parts)", 2)
    end)
end

local function resetMapColors()
    task.spawn(function()
        for obj, orig in pairs(mapCustomizer.savedParts) do
            pcall(function()
                if obj and obj.Parent and orig.Color then
                    obj.Color = orig.Color
                end
            end)
        end
        mapCustomizer.savedParts = setmetatable({}, { __mode = "k" })
        pcall(function()
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                for matName, color in pairs(mapCustomizer.savedTerrain) do
                    local material = Enum.Material[matName]
                    if material then
                        terrain:SetMaterialColor(material, color)
                    end
                end
            end
        end)
        mapCustomizer.savedTerrain = {}
        Notify("Map Customizer", "Map colors reset to original", 2)
    end)
end

-- === NOFOG ===
local noFogSaved = nil

local function setNoFog(state)
    Config.NoFogEnabled = state
    pcall(function()
        if state then
            noFogSaved = { FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor }
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Notify("NoFog", "Enabled - fog removed", 2)
        else
            if noFogSaved then
                Lighting.FogEnd = noFogSaved.FogEnd
                Lighting.FogStart = noFogSaved.FogStart
                Lighting.FogColor = noFogSaved.FogColor
            end
            Notify("NoFog", "Disabled", 2)
        end
    end)
end

-- === WATER WALK (Amethyst method) ===
local waterWalk = { parts = {}, originals = {}, loopThread = nil, platform = nil }

local function collectWaterParts()
    local found = 0
    pcall(function()
        local ocean = Workspace:FindFirstChild("Ocean")
        local object = ocean and ocean:FindFirstChild("Object")
        if object then
            for _, p in ipairs(object:GetDescendants()) do
                if p:IsA("BasePart") and waterWalk.originals[p] == nil then
                    waterWalk.originals[p] = p.CanCollide
                    table.insert(waterWalk.parts, p)
                    p.CanCollide = true
                    found = found + 1
                end
            end
        end
        for _, name in ipairs({ "Water", "Ocean", "Sea", "Lake", "River", "Pool" }) do
            local folder = Workspace:FindFirstChild(name)
            if folder then
                for _, p in ipairs(folder:GetDescendants()) do
                    if p:IsA("BasePart") and p.Transparency > 0.5 and waterWalk.originals[p] == nil then
                        waterWalk.originals[p] = p.CanCollide
                        table.insert(waterWalk.parts, p)
                        p.CanCollide = true
                        found = found + 1
                    end
                end
            end
        end
    end)
    return found
end

local function setWaterWalk(state)
    Config.WaterWalkEnabled = state
    if state then
        local found = collectWaterParts()
        if waterWalk.platform == nil then
            local platform = Instance.new("Part")
            platform.Name = "Gemoroi_WaterWalkPlatform"
            platform.Size = Vector3.new(6, 0.5, 6)
            platform.Transparency = 1
            platform.Anchored = true
            platform.CanCollide = true
            platform.Parent = Workspace
            waterWalk.platform = platform
        end
        waterWalk.loopThread = task.spawn(function()
            while Config.WaterWalkEnabled do
                pcall(function()
                    for _, p in ipairs(waterWalk.parts) do
                        if p and p.Parent then
                            p.CanCollide = true
                        end
                    end
                    local myRoot = getRoot(LocalPlayer)
                    if waterWalk.platform and myRoot then
                        local ray = Workspace:Raycast(myRoot.Position, Vector3.new(0, -8, 0), RaycastParams.new())
                        local inWater = ray == nil or (ray.Instance and ray.Instance.Material == Enum.Material.Water)
                        if inWater then
                            waterWalk.platform.Position = Vector3.new(myRoot.Position.X, myRoot.Position.Y - 3.4, myRoot.Position.Z)
                            waterWalk.platform.CanCollide = true
                        else
                            waterWalk.platform.CanCollide = false
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
        Notify("Water Walk", "Enabled - found " .. found .. " water parts", 2)
    else
        if waterWalk.loopThread then
            task.cancel(waterWalk.loopThread)
            waterWalk.loopThread = nil
        end
        for p, st in pairs(waterWalk.originals) do
            pcall(function()
                if p and p.Parent then
                    p.CanCollide = st
                end
            end)
        end
        if waterWalk.platform then
            pcall(function() waterWalk.platform:Destroy() end)
            waterWalk.platform = nil
        end
        waterWalk.parts = {}
        waterWalk.originals = {}
        Notify("Water Walk", "Disabled", 2)
    end
end

-- === CHAT TROLL SPAMMER ===
local chatSpam = {
    phrases = {
        "FTAP-Gemoroi on top!",
        "GemoroiUI Lime Dark Neon",
        "subscribe to keksup22",
        "get grabbed lol",
        "I love this game :3",
    },
    thread = nil,
}

local function sendChat(message)
    pcall(function()
        local TCS = game:GetService("TextChatService")
        local channel = TCS.ChatInputBarConfiguration and TCS.ChatInputBarConfiguration.TargetTextChannel
        if channel then
            channel:SendAsync(message)
            return
        end
    end)
    pcall(function()
        LocalPlayer.Character:Chat(message)
    end)
end

local function setChatSpam(state)
    Config.ChatSpamEnabled = state
    if state then
        chatSpam.thread = task.spawn(function()
            local i = 1
            while Config.ChatSpamEnabled do
                sendChat(chatSpam.phrases[((i - 1) % #chatSpam.phrases) + 1])
                i = i + 1
                task.wait(math.max(Config.ChatSpamDelay, 0.5))
            end
        end)
        Notify("Chat Spam", "Enabled - trolling the chat", 2)
    else
        if chatSpam.thread then
            task.cancel(chatSpam.thread)
            chatSpam.thread = nil
        end
        Notify("Chat Spam", "Disabled", 2)
    end
end

-- === NINJASHURIKEN DESYNC / CRASH (PoopHub method) ===
local shurikenDesync = { thread = nil }

local function setShurikenDesync(state)
    Config.ShurikenDesyncEnabled = state
    if state then
        local targetChar = getTargetChar()
        if not targetChar then
            Notify("Desync", "Select a target player first!", 2)
            return
        end
        shurikenDesync.thread = task.spawn(function()
            while Config.ShurikenDesyncEnabled do
                pcall(function()
                    if not targetChar or not targetChar.Parent then
                        return
                    end
                    local root = targetChar:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    for i = 1, 4 do
                        local spawnCF = root.CFrame * CFrame.new(math.random(-3, 3), 4 + i, math.random(-3, 3))
                        local toy = nil
                        pcall(function()
                            local inv = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                            local remote = S.ReplicatedStorage:FindFirstChild("MenuToys")
                            remote = remote and remote:FindFirstChild("SpawnToyRemoteFunction")
                            if remote then
                                toy = remote:InvokeServer("NinjaShuriken", spawnCF, Vector3.zero)
                            end
                        end)
                        if toy then
                            task.spawn(function()
                                pcall(function()
                                    local basePart = toy:IsA("Model") and (toy.PrimaryPart or toy:FindFirstChildWhichIsA("BasePart")) or toy
                                    if basePart then
                                        local ge = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                                        local sno = ge and ge:FindFirstChild("SetNetworkOwner")
                                        if sno then
                                            sno:FireServer(basePart, basePart.CFrame)
                                        end
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
        Notify("Desync", "NinjaShuriken Desync enabled on target", 2)
    else
        if shurikenDesync.thread then
            task.cancel(shurikenDesync.thread)
            shurikenDesync.thread = nil
        end
        Notify("Desync", "NinjaShuriken Desync disabled", 2)
    end
end


-- === FIGURE GRAB POSE PACK (akirra4) ===
local CorePoses = {
    DogPoseQuickV1 = {
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
        Slow = true,
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

local activeCorePose = { thread = nil, name = nil, coconuts = {} }

local function stopCorePose()
    if activeCorePose.thread then
        task.cancel(activeCorePose.thread)
        activeCorePose.thread = nil
    end
    for _, coconut in ipairs(activeCorePose.coconuts) do
        pcall(function()
            local inv = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
            local remote = S.ReplicatedStorage:FindFirstChild("MenuToys")
            remote = remote and remote:FindFirstChild("DestroyToy")
            if remote and coconut and coconut.Parent then
                remote:FireServer(coconut)
            end
        end)
    end
    activeCorePose.coconuts = {}
    activeCorePose.name = nil
end

local function applyCorePose(presetName)
    local preset = CorePoses[presetName]
    local targetChar = getTargetChar()
    if not preset or not targetChar then
        Notify("Figure Pose", "Select a target player first!", 2)
        return
    end
    stopCorePose()
    activeCorePose.name = presetName
    activeCorePose.thread = task.spawn(function()
        local phase = 0
        while activeCorePose.name == presetName do
            pcall(function()
                local myRoot = getRoot(LocalPlayer)
                if not myRoot or not targetChar or not targetChar.Parent then
                    stopCorePose()
                    return
                end
                local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("HumanoidRootPart")
                if not torso then return end
                local ge = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                local sno = ge and ge:FindFirstChild("SetNetworkOwner")
                if sno then
                    sno:FireServer(torso, torso.CFrame)
                end
                for _, x in ipairs(targetChar:GetDescendants()) do
                    if x:IsA("BasePart") then
                        x.CanCollide = false
                    end
                end
                local hum = targetChar:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = math.max(hum.Health, 50)
                end
                phase = phase + (preset.Slow and 0.045 or 0.12)
                local bob = math.sin(phase) * (preset.Slow and 0.55 or 0.1)
                local base = myRoot.CFrame * CFrame.new(0, bob, 0)
                local torsoCF = nil
                for partName, def in pairs(preset.Parts) do
                    local part = targetChar:FindFirstChild(partName)
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
    Notify("Figure Pose", "Applied pose: " .. presetName, 2)
end

local function attachCoreCoconuts(mode)
    local targetChar = getTargetChar()
    if not targetChar then
        Notify("Figure Pose", "Select a target player first!", 2)
        return
    end
    stopCorePose()
    local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
    if not torso then return end
    local offsets
    if mode == "BoobsAss" then
        offsets = {
            CFrame.new(-0.55, 0.6, -0.45),
            CFrame.new(0.55, 0.6, -0.45),
            CFrame.new(-0.45, -0.85, 0.5),
            CFrame.new(0.45, -0.85, 0.5),
        }
    elseif mode == "Penis" then
        offsets = { CFrame.new(0, -1.15, -0.9) }
    else
        return
    end
    activeCorePose.name = "Coconut" .. tostring(mode)
    for _, off in ipairs(offsets) do
        pcall(function()
            local remote = S.ReplicatedStorage:FindFirstChild("MenuToys")
            remote = remote and remote:FindFirstChild("SpawnToyRemoteFunction")
            if remote then
                local toy = remote:InvokeServer("FoodCoconut", torso.CFrame * off, Vector3.zero)
                if toy then
                    table.insert(activeCorePose.coconuts, toy)
                end
            end
        end)
    end
    activeCorePose.thread = task.spawn(function()
        while activeCorePose.name == "Coconut" .. tostring(mode) do
            pcall(function()
                if not targetChar or not targetChar.Parent or not torso or not torso.Parent then
                    stopCorePose()
                    return
                end
                for i, coconut in ipairs(activeCorePose.coconuts) do
                    if coconut and coconut.Parent then
                        local basePart = coconut:IsA("Model") and (coconut.PrimaryPart or coconut:FindFirstChildWhichIsA("BasePart")) or coconut
                        if basePart then
                            basePart.CFrame = torso.CFrame * offsets[i]
                        end
                    end
                end
            end)
            task.wait()
        end
    end)
    Notify("Figure Pose", "Coconuts attached (" .. mode .. ")", 2)
end

local function resetCorePose()
    stopCorePose()
    local targetChar = getTargetChar()
    if targetChar then
        pcall(function()
            local hum = targetChar:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            for _, x in ipairs(targetChar:GetDescendants()) do
                if x:IsA("BasePart") then
                    x.CanCollide = true
                end
            end
        end)
    end
    Notify("Figure Pose", "Pose reset - target restored", 2)
end

-- === TARGET LIMB CONTROLS ===
local function freezeLimbs()
    local targetChar = getTargetChar()
    if not targetChar then Notify("Limbs", "Select a target player first!", 2) return end
    pcall(function()
        for _, name in ipairs({ "Left Arm", "Right Arm", "Left Leg", "Right Leg",
            "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
            "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg" }) do
            local limb = targetChar:FindFirstChild(name)
            if limb then
                limb.Anchored = true
            end
        end
    end)
    Notify("Limbs", "Target limbs frozen", 2)
end

local function unfreezeLimbs()
    local targetChar = getTargetChar()
    if not targetChar then Notify("Limbs", "Select a target player first!", 2) return end
    pcall(function()
        for _, part in ipairs(targetChar:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end)
    Notify("Limbs", "Target limbs unfrozen", 2)
end

local function removeLimbs(mode)
    local targetChar = getTargetChar()
    if not targetChar then Notify("Limbs", "Select a target player first!", 2) return end
    pcall(function()
        local names
        if mode == "Arms" then
            names = { "Left Arm", "Right Arm", "LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm" }
        else
            names = { "Left Leg", "Right Leg", "LeftLowerLeg", "RightLowerLeg", "LeftUpperLeg", "RightUpperLeg" }
        end
        for _, name in ipairs(names) do
            local limb = targetChar:FindFirstChild(name)
            if limb then
                limb:Destroy()
            end
        end
    end)
    Notify("Limbs", "Removed target " .. (mode == "Arms" and "arms" or "legs"), 2)
end

-- === MIRROR MY ANIMATIONS / FACE TOWARD ME / LOCK TORSO ===
local mirrorAnims = { connection = nil }
local faceTowardMe = { connection = nil }

local function setMirrorAnimations(state)
    if state then
        local targetChar = getTargetChar()
        local myChar = LocalPlayer.Character
        if not targetChar or not myChar then
            Notify("Mirror", "Select a target player first!", 2)
            return
        end
        if mirrorAnims.connection then mirrorAnims.connection:Disconnect() end
        mirrorAnims.connection = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not targetChar or not targetChar.Parent or not myChar or not myChar.Parent then
                    return
                end
                for _, myMotor in ipairs(myChar:GetDescendants()) do
                    if myMotor:IsA("Motor6D") then
                        local theirMotor = targetChar:FindFirstChild(myMotor.Name, true)
                        if theirMotor and theirMotor:IsA("Motor6D") then
                            theirMotor.Transform = myMotor.Transform
                        end
                    end
                end
            end)
        end)
        Notify("Mirror", "Mirroring my animations onto target", 2)
    else
        if mirrorAnims.connection then
            mirrorAnims.connection:Disconnect()
            mirrorAnims.connection = nil
        end
        Notify("Mirror", "Mirror Animations disabled", 2)
    end
end

local function setFaceTowardMe(state)
    if state then
        local targetChar = getTargetChar()
        if not targetChar then
            Notify("Face", "Select a target player first!", 2)
            return
        end
        if faceTowardMe.connection then faceTowardMe.connection:Disconnect() end
        faceTowardMe.connection = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not targetChar or not targetChar.Parent then return end
                local root = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
                local myRoot = getRoot(LocalPlayer)
                if root and myRoot then
                    local ge = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                    local sno = ge and ge:FindFirstChild("SetNetworkOwner")
                    if sno then
                        sno:FireServer(root, root.CFrame)
                    end
                    root.CFrame = CFrame.new(root.Position, Vector3.new(myRoot.Position.X, root.Position.Y, myRoot.Position.Z))
                end
            end)
        end)
        Notify("Face", "Target now faces me", 2)
    else
        if faceTowardMe.connection then
            faceTowardMe.connection:Disconnect()
            faceTowardMe.connection = nil
        end
        Notify("Face", "Face Toward Me disabled", 2)
    end
end

local function setLockTorso(state)
    local targetChar = getTargetChar()
    if state then
        if not targetChar then
            Notify("Torso", "Select a target player first!", 2)
            return
        end
        local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
        if torso then
            torso.Anchored = true
            Notify("Torso", "Target torso rotation locked", 2)
        end
    else
        if targetChar then
            local torso = targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
            if torso then
                torso.Anchored = false
            end
        end
        Notify("Torso", "Torso lock released", 2)
    end
end

-- === FLING AURA ===
local flingAura = { thread = nil }

local function setFlingAura(state)
    Config.FlingAuraEnabled = state
    if state then
        if flingAura.thread then task.cancel(flingAura.thread) end
        flingAura.thread = task.spawn(function()
            while Config.FlingAuraEnabled do
                pcall(function()
                    local myRoot = getRoot(LocalPlayer)
                    if not myRoot then return end
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local root = getRoot(player)
                            if root and (root.Position - myRoot.Position).Magnitude <= Config.FlingAuraRadius then
                                local ge = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                                local sno = ge and ge:FindFirstChild("SetNetworkOwner")
                                if sno then
                                    sno:FireServer(root, root.CFrame)
                                end
                                local angle = math.rad(math.random(0, 360))
                                root.AssemblyLinearVelocity = Vector3.new(
                                    math.cos(angle) * 250,
                                    math.random(150, 300),
                                    math.sin(angle) * 250
                                )
                                root.AssemblyAngularVelocity = Vector3.new(
                                    math.random(-60, 60),
                                    math.random(-60, 60),
                                    math.random(-60, 60)
                                )
                            end
                        end
                    end
                end)
                task.wait(0.25)
            end
        end)
        Notify("Auras", "Fling Aura Enabled - enemies get randomly flung", 2)
    else
        if flingAura.thread then
            task.cancel(flingAura.thread)
            flingAura.thread = nil
        end
        Notify("Auras", "Fling Aura Disabled", 2)
    end
end

-- === SILENT AIM HOOK (__namecall) ===
local silentAimHookInstalled = false

local function setSilentAimHook(state)
    Config.SilentAimHook = state
    if state then
        local ok, err = pcall(function()
            if not hookmetamethod or not getnamecallmethod then
                error("hookmetamethod is not available in this executor")
            end
            if silentAimHookInstalled then
                return
            end
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if Config.SilentAimHook and Config.SilentAimEnabled
                    and (method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList"
                        or method == "FindPartOnRayWithWhitelist") then
                    local target = getClosestPlayer()
                    if target then
                        local origin
                        local args = { ... }
                        if method == "Raycast" then
                            if typeof(args[1]) == "CFrame" then
                                origin = args[1].Position
                            elseif typeof(args[1]) == "Vector3" then
                                origin = args[1]
                            end
                            if origin then
                                return oldNamecall(self, origin, target.Position - origin, select(3, ...))
                            end
                        else
                            if typeof(args[1]) == "Ray" then
                                origin = args[1].Origin
                                local direction = Ray.new(origin, target.Position - origin)
                                return oldNamecall(self, direction, select(2, ...))
                            end
                        end
                    end
                end
                return oldNamecall(self, ...)
            end))
            silentAimHookInstalled = true
        end)
        if ok then
            Notify("Silent Aim", "__namecall hook installed (Raycast / FindPartOnRay redirect)", 3)
        else
            Config.SilentAimHook = false
            Notify("Silent Aim", "Hook unavailable: " .. tostring(err), 4)
        end
    else
        Notify("Silent Aim", "__namecall hook redirect disabled", 2)
    end
end

-- === CLICK TP / TP TO PLAYER ===
local clickTPConn = nil

local function setClickTP(state)
    Config.ClickTPEnabled = state
    if state then
        if clickTPConn then clickTPConn:Disconnect() end
        clickTPConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                pcall(function()
                    if Mouse.Hit then
                        local root = getRoot(LocalPlayer)
                        if root then
                            root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
                        end
                    end
                end)
            end
        end)
        Notify("Click TP", "Enabled - click anywhere to teleport", 2)
    else
        if clickTPConn then
            clickTPConn:Disconnect()
            clickTPConn = nil
        end
        Notify("Click TP", "Disabled", 2)
    end
end

local function teleportToPlayerByName(name)
    local player = Players:FindFirstChild(name)
    if not player then
        Notify("Teleport", "Player not found!", 2)
        return
    end
    local root = getRoot(player)
    local myRoot = getRoot(LocalPlayer)
    if root and myRoot then
        myRoot.CFrame = root.CFrame * CFrame.new(0, 0, 3)
        Notify("Teleport", "Teleported to " .. player.Name, 2)
    end
end

-- === AUTO RECONNECT ===
local autoReconnect = { enabled = false, connection = nil }

local function rejoinServer()
    pcall(function()
        TeleportService:Teleport(game.PlaceId)
    end)
end

local function setAutoReconnect(state)
    autoReconnect.enabled = state
    if state then
        autoReconnect.connection = Players.PlayerRemoving:Connect(function(player)
            if player == LocalPlayer and autoReconnect.enabled then
                task.wait(1)
                rejoinServer()
            end
        end)
        task.spawn(function()
            while autoReconnect.enabled do
                if not LocalPlayer.Parent then
                    rejoinServer()
                end
                task.wait(2)
            end
        end)
        Notify("Server", "Auto Reconnect enabled", 2)
    else
        if autoReconnect.connection then
            autoReconnect.connection:Disconnect()
            autoReconnect.connection = nil
        end
        Notify("Server", "Auto Reconnect disabled", 2)
    end
end

-- === FLY ENGINE (BodyVelocity + BodyGyro, WASD + Space/Shift) ===
local flyBV, flyBG = nil, nil
local flyKeys = { W = false, A = false, S = false, D = false, Space = false, Shift = false }

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Shift = false end
end)

local function updateFly()
    local root = getRoot(LocalPlayer)
    if not root then return end
    if AmethystFeatures.Fly.Enabled then
        if not flyBV or not flyBV.Parent then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = root
        end
        if not flyBG or not flyBG.Parent then
            flyBG = Instance.new("BodyGyro")
            flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            flyBG.P = 9000
            flyBG.D = 500
            flyBG.Parent = root
        end
        local speed = AmethystFeatures.Fly.Speed or 100
        local move = Vector3.zero
        local camCF = Camera.CFrame
        if flyKeys.W then move = move + camCF.LookVector end
        if flyKeys.S then move = move - camCF.LookVector end
        if flyKeys.D then move = move + camCF.RightVector end
        if flyKeys.A then move = move - camCF.RightVector end
        if flyKeys.Space then move = move + Vector3.new(0, 1, 0) end
        if flyKeys.Shift then move = move - Vector3.new(0, 1, 0) end
        if move.Magnitude > 0 then
            move = move.Unit * speed
        end
        flyBV.Velocity = move
        flyBG.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z))
    else
        if flyBV and flyBV.Parent then
            flyBV:Destroy()
            flyBV = nil
        end
        if flyBG and flyBG.Parent then
            flyBG:Destroy()
            flyBG = nil
        end
    end
end

-- === KEYBINDS SYSTEM (bind ANY registered function) ===
local KeybindRegistry = {}
local KeybindOrder = {}

local function registerKeybindAction(actionName, defaultKey, fn)
    KeybindRegistry[actionName] = { fn = fn, key = defaultKey }
    table.insert(KeybindOrder, actionName)
end

local function bindActionKey(actionName, keyCode)
    local action = KeybindRegistry[actionName]
    if not action then return end
    if action.conn then
        pcall(function() action.conn:Disconnect() end)
        action.conn = nil
    end
    action.key = keyCode
    if keyCode then
        action.conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == keyCode then
                pcall(action.fn)
            end
        end)
    end
end

-- === COMBAT TAB ===
Tabs.Combat:AddSection("Silent Aim & Targeting")

Tabs.Combat:AddToggle("SilentAimToggle", {
    Title = "Enable Silent Aim",
    Default = false,
    Callback = function(Value)
        Config.SilentAimEnabled = Value
        if fovCircle then
            fovCircle.Visible = Value and Config.ShowFOV
        end
    end
})

Tabs.Combat:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Default = true,
    Callback = function(Value)
        Config.WallCheck = Value
    end
})

Tabs.Combat:AddToggle("ShowFOVToggle", {
    Title = "Show FOV Circle",
    Default = false,
    Callback = function(Value)
        Config.ShowFOV = Value
        if fovCircle then
            fovCircle.Visible = Value and Config.SilentAimEnabled
        end
    end
})

Tabs.Combat:AddSlider("FOVSizeSlider", {
    Title = "FOV Size",
    Default = 120,
    Min = 20,
    Max = 400,
    Rounding = 0,
    Callback = function(Value)
        Config.FOVRadius = Value
        if fovCircle then
            fovCircle.Radius = Value
        end
    end
})

Tabs.Combat:AddSlider("MaxDistanceSlider", {
    Title = "Max Lock Distance",
    Default = 200,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Config.MaxDistance = Value
    end
})

Tabs.Combat:AddDropdown("HitboxDropdown", {
    Title = "Target Hitbox",
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(Option)
        Config.Hitbox = Option
    end
})

Tabs.Combat:AddToggle("SilentAimHookToggle", {
    Title = "Silent Aim (__namecall Hook)",
    Description = "Redirects Raycast / FindPartOnRay to the target hitbox",
    Default = false,
    Callback = function(Value)
        setSilentAimHook(Value)
    end
})

Tabs.Combat:AddSection("Grab Modifiers")

Tabs.Combat:AddToggle("LaunchGrabToggle", {
    Title = "Launch Grab (200 speed upkick)",
    Default = false,
    Callback = function(Value)
        Config.LaunchGrab = Value
    end
})

Tabs.Combat:AddToggle("ZeroVelocityGrabToggle", {
    Title = "Zero Velocity Grab",
    Default = false,
    Callback = function(Value)
        Config.ZeroVelocityGrab = Value
    end
})

-- === PLAYER TAB ===
Tabs.Player:AddSection("Movement & Physics")

Tabs.Player:AddToggle("WalkspeedToggle", {
    Title = "Enable Speed Boost",
    Default = false,
    Callback = function(Value)
        Config.WalkspeedEnabled = Value
    end
})

Tabs.Player:AddSlider("WalkspeedSlider", {
    Title = "Speed Multiplier",
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Callback = function(Value)
        Config.WalkspeedValue = Value
    end
})

Tabs.Player:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        Config.InfiniteJumpEnabled = Value
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip",
    Default = false,
    Callback = function(Value)
        Config.NoclipEnabled = Value
    end
})

-- === PLAYER TAB: THIRD PERSON FIX ===
Tabs.Player:AddToggle("ThirdPersonFixToggle", {
    Title = "Third Person View Fix (RenderStepped)",
    Description = "Unlocks the forced first-person camera every frame",
    Default = false,
    Callback = function(Value)
        setThirdPersonFix(Value)
    end
})

Tabs.Player:AddSlider("ThirdPersonDistanceSlider", {
    Title = "Third Person Camera Distance",
    Default = 8,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        Config.ThirdPersonDistance = Value
        if Config.ThirdPersonFix then
            LocalPlayer.CameraMaxZoomDistance = Value
        end
    end
})

Tabs.Player:AddToggle("WaterWalkToggle", {
    Title = "Water Walk",
    Description = "Walk on water like a god",
    Default = false,
    Callback = function(Value)
        setWaterWalk(Value)
    end
})

-- === VISUALS TAB ===
Tabs.Visuals:AddSection("ESP & Shaders")

Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Enable Player ESP (Highlights)",
    Default = false,
    Callback = function(Value)
        Config.ESPEnabled = Value
        updateESPHighlights()
    end
})

Tabs.Visuals:AddButton({
    Title = "Fullbright (Lighting Boost)",
    Callback = function()
        pcall(function()
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
        end)
        GemoroiUI:Notify({ Title = "Visuals", Content = "Fullbright applied!", Duration = 3 })
    end
})

Tabs.Visuals:AddToggle("PCLDESPToggle", {
    Title = "PCLD ESP (Hidden Hitboxes)",
    Default = false,
    Callback = function(Value)
        Config.PCLD_ESPEnabled = Value
    end
})

-- === VISUALS TAB: GEMOROI VISUALS & OPTIMIZATION ===
Tabs.Visuals:AddSection("Gemoroi Visuals & Optimization")

Tabs.Visuals:AddToggle("PCLDBoxESPToggle", {
    Title = "PCLD Box ESP (BoxHandleAdornments)",
    Description = "Draws 3D boxes on hidden physics hitboxes",
    Default = false,
    Callback = function(Value)
        setPCLDBoxes(Value)
    end
})

Tabs.Visuals:AddColorpicker("PCLDBoxColorPicker", {
    Title = "PCLD Box Color",
    Default = Color3.fromRGB(163, 230, 53),
    Callback = function(Value)
        Config.PCLD_BoxColor = Value
        for _, box in pairs(pcldBoxAdornments) do
            if box then
                box.Color3 = Value
            end
        end
    end
})

Tabs.Visuals:AddToggle("ProfileESPToggle", {
    Title = "Profile ESP (Avatars Above Head)",
    Description = "Shows player avatars, names and health above heads",
    Default = false,
    Callback = function(Value)
        setProfileESP(Value)
    end
})

Tabs.Visuals:AddToggle("SoapTexturesToggle", {
    Title = "Soap Textures (FPS Boost)",
    Description = "Smooth-plastic everything + hides decals & textures",
    Default = false,
    Callback = function(Value)
        setSoapTextures(Value)
    end
})

Tabs.Visuals:AddToggle("OverheadTagsToggle", {
    Title = "Overhead Tags",
    Description = "Name, @user, distance in studs & health bar",
    Default = false,
    Callback = function(Value)
        setOverheadTags(Value)
    end
})

Tabs.Visuals:AddToggle("XRayToggle", {
    Title = "X-Ray Vision",
    Description = "Semi-transparent map walls (Transparency 0.6)",
    Default = false,
    Callback = function(Value)
        setXRay(Value)
    end
})

Tabs.Visuals:AddToggle("NoFogToggle", {
    Title = "NoFog",
    Description = "Removes all fog from the map",
    Default = false,
    Callback = function(Value)
        setNoFog(Value)
    end
})

Tabs.Visuals:AddSection("Map Customizer (Live Recolor)")

local mapMaterials = {
    { Name = "Grass", Material = Enum.Material.Grass },
    { Name = "Rock",  Material = Enum.Material.Rock },
    { Name = "Sand",  Material = Enum.Material.Sand },
    { Name = "Snow",  Material = Enum.Material.Snow },
}

for _, mat in ipairs(mapMaterials) do
    Tabs.Visuals:AddColorpicker("MapColor" .. mat.Name, {
        Title = mat.Name .. " Color",
        Default = Color3.fromRGB(57, 255, 20),
        Callback = function(Value)
            applyMapColor(mat.Material, Value)
        end
    })
end

Tabs.Visuals:AddButton({
    Title = "Reset Map Colors",
    Callback = function()
        resetMapColors()
    end
})

Tabs.Visuals:AddToggle("ModelHighlightToggle", {
    Title = "Enable Workspace Model Highlights",
    Default = false,
    Callback = function(Value)
        updateModelHighlights(Value)
        GemoroiUI:Notify({ Title = "Visuals", Content = Value and "Model Highlights Enabled" or "Model Highlights Disabled", Duration = 2 })
    end
})

Tabs.Visuals:AddToggle("ModelBillboardToggle", {
    Title = "Enable Workspace Model BillboardGui",
    Default = false,
    Callback = function(Value)
        updateModelBillboards(Value)
        GemoroiUI:Notify({ Title = "Visuals", Content = Value and "Model BillboardGui Enabled" or "Model BillboardGui Disabled", Duration = 2 })
    end
})

-- ============================================================================
-- NEON DREAM SHADER ENGINE
-- ============================================================================
local NeonDreamConfig = {
    Enabled = false,
    GlowIntensity = 3.0,
    PulseSpeed = 1.5,
    ParticleDensity = 30,
    VignetteTransparency = 0.4,
    Palette = "Neon Purple",
    CustomColor = Color3.fromRGB(180, 0, 255),
    CustomR = 180,
    CustomG = 0,
    CustomB = 255
}

local NeonDreamPalettes = {
    ["Neon Purple"] = Color3.fromRGB(180, 0, 255),
    ["Cyber Blue"]  = Color3.fromRGB(0, 220, 255),
    ["Sunset Pink"]  = Color3.fromRGB(255, 50, 150),
    ["Matrix Green"] = Color3.fromRGB(0, 255, 100)
}

local NeonDreamState = {
    OriginalLighting = { Saved = false },
    Bloom = nil,
    ColorCorrection = nil,
    SunRays = nil,
    VignetteGui = nil,
    VignetteImage = nil,
    Attachment = nil,
    ParticleEmitter = nil,
    RenderConnection = nil,
    CharacterConnection = nil
}

local function GetNeonDreamColor()
    if NeonDreamConfig.Palette == "Custom" then
        return NeonDreamConfig.CustomColor or Color3.fromRGB(NeonDreamConfig.CustomR or 180, NeonDreamConfig.CustomG or 0, NeonDreamConfig.CustomB or 255)
    end
    return NeonDreamPalettes[NeonDreamConfig.Palette] or Color3.fromRGB(180, 0, 255)
end

local function CleanupNeonDreamInstances()
    pcall(function()
        if NeonDreamState.Bloom then NeonDreamState.Bloom:Destroy() NeonDreamState.Bloom = nil end
        if NeonDreamState.ColorCorrection then NeonDreamState.ColorCorrection:Destroy() NeonDreamState.ColorCorrection = nil end
        if NeonDreamState.SunRays then NeonDreamState.SunRays:Destroy() NeonDreamState.SunRays = nil end
        if NeonDreamState.VignetteGui then NeonDreamState.VignetteGui:Destroy() NeonDreamState.VignetteGui = nil NeonDreamState.VignetteImage = nil end
        if NeonDreamState.ParticleEmitter then NeonDreamState.ParticleEmitter:Destroy() NeonDreamState.ParticleEmitter = nil end
        if NeonDreamState.Attachment then NeonDreamState.Attachment:Destroy() NeonDreamState.Attachment = nil end
    end)
    pcall(function()
        for _, child in ipairs(Lighting:GetChildren()) do
            if child.Name:sub(1, 10) == "NeonDream_" then
                pcall(function() child:Destroy() end)
            end
        end
        for _, child in ipairs(CoreGui:GetChildren()) do
            if child.Name == "NeonDream_VignetteGui" then
                pcall(function() child:Destroy() end)
            end
        end
    end)
end

local function SetupNeonDreamParticles()
    local char = LocalPlayer.Character
    if not char then return end
    local root = getRoot(LocalPlayer)
    if not root then return end

    if NeonDreamState.Attachment then pcall(function() NeonDreamState.Attachment:Destroy() end) end
    if NeonDreamState.ParticleEmitter then pcall(function() NeonDreamState.ParticleEmitter:Destroy() end) end

    local att = Instance.new("Attachment")
    att.Name = "NeonDream_Attachment"
    att.Parent = root
    NeonDreamState.Attachment = att

    local pe = Instance.new("ParticleEmitter")
    pe.Name = "NeonDream_Particles"
    pe.Texture = "rbxassetid://2581223252"
    pe.Color = ColorSequence.new(GetNeonDreamColor())
    pe.Rate = NeonDreamConfig.ParticleDensity
    pe.Lifetime = NumberRange.new(0.8, 1.5)
    pe.Speed = NumberRange.new(1, 3.5)
    pe.SpreadAngle = Vector2.new(180, 180)
    pe.LightEmission = 1
    pe.LightInfluence = 0
    pe.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 1.2),
        NumberSequenceKeypoint.new(1, 0)
    })
    pe.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.2),
        NumberSequenceKeypoint.new(0.8, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    pe.Parent = att
    NeonDreamState.ParticleEmitter = pe
end

local function ToggleNeonDream(state)
    NeonDreamConfig.Enabled = state
    local st = NeonDreamState

    if state then
        pcall(function()
            if not st.OriginalLighting.Saved then
                st.OriginalLighting.Ambient = Lighting.Ambient
                st.OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
                st.OriginalLighting.Saved = true
            end

            CleanupNeonDreamInstances()

            local bloom = Instance.new("BloomEffect")
            bloom.Name = "NeonDream_Bloom"
            bloom.Intensity = NeonDreamConfig.GlowIntensity * 0.8
            bloom.Size = 28
            bloom.Threshold = 0.8
            bloom.Parent = Lighting
            st.Bloom = bloom

            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "NeonDream_ColorCorrection"
            cc.TintColor = GetNeonDreamColor()
            cc.Brightness = 0.05
            cc.Contrast = 0.15
            cc.Saturation = 0.5
            cc.Parent = Lighting
            st.ColorCorrection = cc

            local sunRays = Instance.new("SunRaysEffect")
            sunRays.Name = "NeonDream_SunRays"
            sunRays.Intensity = math.clamp(NeonDreamConfig.GlowIntensity * 0.08, 0, 1)
            sunRays.Spread = 0.8
            sunRays.Parent = Lighting
            st.SunRays = sunRays

            local gui = Instance.new("ScreenGui")
            gui.Name = "NeonDream_VignetteGui"
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            gui.Parent = CoreGui

            local img = Instance.new("ImageLabel")
            img.Name = "VignetteFrame"
            img.Size = UDim2.new(1, 0, 1, 0)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://4576475446"
            img.ImageColor3 = GetNeonDreamColor()
            img.ImageTransparency = math.clamp(1 - NeonDreamConfig.VignetteTransparency, 0, 1)
            img.Parent = gui
            st.VignetteGui = gui
            st.VignetteImage = img

            SetupNeonDreamParticles()

            if not st.CharacterConnection then
                st.CharacterConnection = LocalPlayer.CharacterAdded:Connect(function()
                    if NeonDreamConfig.Enabled then
                        task.wait(0.5)
                        pcall(function() SetupNeonDreamParticles() end)
                    end
                end)
            end

            if st.RenderConnection then st.RenderConnection:Disconnect() end
            st.RenderConnection = RunService.RenderStepped:Connect(function()
                if not NeonDreamConfig.Enabled then return end
                pcall(function()
                    local pulseSpeed = NeonDreamConfig.PulseSpeed
                    local sinVal = (pulseSpeed > 0) and math.sin(tick() * pulseSpeed * 3) or 0
                    local activeColor = GetNeonDreamColor()

                    if st.Bloom then
                        st.Bloom.Intensity = math.clamp((NeonDreamConfig.GlowIntensity * 0.5) + (sinVal * 0.25 * NeonDreamConfig.GlowIntensity), 0, 20)
                    end
                    if st.ColorCorrection then
                        st.ColorCorrection.TintColor = activeColor
                        st.ColorCorrection.Saturation = 0.4 + (sinVal * 0.2)
                        st.ColorCorrection.Brightness = (sinVal * 0.04 * (NeonDreamConfig.GlowIntensity / 5))
                    end
                    if st.SunRays then
                        st.SunRays.Intensity = math.clamp((NeonDreamConfig.GlowIntensity * 0.06) + (sinVal * 0.03), 0, 1)
                    end
                    if st.VignetteImage then
                        st.VignetteImage.ImageColor3 = activeColor
                        st.VignetteImage.ImageTransparency = math.clamp(1 - NeonDreamConfig.VignetteTransparency, 0, 1)
                    end
                    if st.ParticleEmitter then
                        st.ParticleEmitter.Color = ColorSequence.new(activeColor)
                        st.ParticleEmitter.Rate = NeonDreamConfig.ParticleDensity
                    end
                end)
            end)

            Notify("Visuals", "Neon Dream Shader Enabled ✨", 2)
            PlayEnableSound()
        end)
    else
        pcall(function()
            CleanupNeonDreamInstances()
            if st.RenderConnection then
                st.RenderConnection:Disconnect()
                st.RenderConnection = nil
            end
            if st.CharacterConnection then
                st.CharacterConnection:Disconnect()
                st.CharacterConnection = nil
            end

            if st.OriginalLighting.Saved then
                if st.OriginalLighting.Ambient then Lighting.Ambient = st.OriginalLighting.Ambient end
                if st.OriginalLighting.OutdoorAmbient then Lighting.OutdoorAmbient = st.OriginalLighting.OutdoorAmbient end
                st.OriginalLighting.Saved = false
            end

            Notify("Visuals", "Neon Dream Shader Disabled", 2)
        end)
    end
end

local function ResetNeonDreamConfig()
    NeonDreamConfig.GlowIntensity = 3.0
    NeonDreamConfig.PulseSpeed = 1.5
    NeonDreamConfig.ParticleDensity = 30
    NeonDreamConfig.VignetteTransparency = 0.4
    NeonDreamConfig.Palette = "Neon Purple"
    NeonDreamConfig.CustomColor = Color3.fromRGB(180, 0, 255)
    NeonDreamConfig.CustomR = 180
    NeonDreamConfig.CustomG = 0
    NeonDreamConfig.CustomB = 255
    if NeonDreamConfig.Enabled then
        ToggleNeonDream(false)
    end
end

-- === NEON DREAM SHADER UI ===
Tabs.Visuals:AddSection("Neon Dream Shader")

local NeonDreamToggle = Tabs.Visuals:AddToggle("NeonDreamToggle", {
    Title = "Enable Neon Dream Shader",
    Default = false,
    Callback = function(Value)
        ToggleNeonDream(Value)
    end
})

local GlowIntensitySlider = Tabs.Visuals:AddSlider("NeonDreamGlowSlider", {
    Title = "Glow Intensity",
    Min = 0,
    Max = 10,
    Default = 3,
    Rounding = 1,
    Callback = function(Value)
        NeonDreamConfig.GlowIntensity = Value
    end
})

local PulseSpeedSlider = Tabs.Visuals:AddSlider("NeonDreamPulseSlider", {
    Title = "Pulse Speed",
    Min = 0,
    Max = 5,
    Default = 1.5,
    Rounding = 1,
    Callback = function(Value)
        NeonDreamConfig.PulseSpeed = Value
    end
})

local ParticleDensitySlider = Tabs.Visuals:AddSlider("NeonDreamDensitySlider", {
    Title = "Particle Density",
    Min = 0,
    Max = 100,
    Default = 30,
    Rounding = 0,
    Callback = function(Value)
        NeonDreamConfig.ParticleDensity = Value
    end
})

local VignetteSlider = Tabs.Visuals:AddSlider("NeonDreamVignetteSlider", {
    Title = "Vignette Transparency",
    Min = 0,
    Max = 1,
    Default = 0.4,
    Rounding = 2,
    Callback = function(Value)
        NeonDreamConfig.VignetteTransparency = Value
    end
})

local PaletteDropdown = Tabs.Visuals:AddDropdown("NeonDreamPaletteDropdown", {
    Title = "Palette",
    Values = { "Neon Purple", "Cyber Blue", "Sunset Pink", "Matrix Green", "Custom" },
    Default = "Neon Purple",
    Callback = function(Value)
        NeonDreamConfig.Palette = Value
    end
})

local CustomColorPicker = Tabs.Visuals:AddColorpicker("NeonDreamCustomColor", {
    Title = "Custom Palette Color",
    Default = Color3.fromRGB(180, 0, 255),
    Callback = function(Value)
        NeonDreamConfig.CustomColor = Value
        NeonDreamConfig.CustomR = math.floor(Value.R * 255)
        NeonDreamConfig.CustomG = math.floor(Value.G * 255)
        NeonDreamConfig.CustomB = math.floor(Value.B * 255)
    end
})

local CustomRSlider = Tabs.Visuals:AddSlider("NeonDreamCustomR", {
    Title = "Custom R",
    Min = 0,
    Max = 255,
    Default = 180,
    Rounding = 0,
    Callback = function(Value)
        NeonDreamConfig.CustomR = Value
        NeonDreamConfig.CustomColor = Color3.fromRGB(Value, NeonDreamConfig.CustomG, NeonDreamConfig.CustomB)
    end
})

local CustomGSlider = Tabs.Visuals:AddSlider("NeonDreamCustomG", {
    Title = "Custom G",
    Min = 0,
    Max = 255,
    Default = 0,
    Rounding = 0,
    Callback = function(Value)
        NeonDreamConfig.CustomG = Value
        NeonDreamConfig.CustomColor = Color3.fromRGB(NeonDreamConfig.CustomR, Value, NeonDreamConfig.CustomB)
    end
})

local CustomBSlider = Tabs.Visuals:AddSlider("NeonDreamCustomB", {
    Title = "Custom B",
    Min = 0,
    Max = 255,
    Default = 255,
    Rounding = 0,
    Callback = function(Value)
        NeonDreamConfig.CustomB = Value
        NeonDreamConfig.CustomColor = Color3.fromRGB(NeonDreamConfig.CustomR, NeonDreamConfig.CustomG, Value)
    end
})

Tabs.Visuals:AddButton({
    Title = "Reset Settings",
    Description = "Reset Neon Dream Shader settings to default",
    Callback = function()
        pcall(function()
            NeonDreamToggle:SetValue(false)
            GlowIntensitySlider:SetValue(3)
            PulseSpeedSlider:SetValue(1.5)
            ParticleDensitySlider:SetValue(30)
            VignetteSlider:SetValue(0.4)
            PaletteDropdown:SetValue("Neon Purple")
            CustomColorPicker:SetValue(Color3.fromRGB(180, 0, 255))
            CustomRSlider:SetValue(180)
            CustomGSlider:SetValue(0)
            CustomBSlider:SetValue(255)
            ResetNeonDreamConfig()
        end)
    end
})


-- === MASS / TROLL TAB ===
Tabs.Mass:AddSection("Server Interaction & Kill")

Tabs.Mass:AddButton({
    Title = "Kill All Players",
    Description = "Sets health to 0 for all players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local humanoid = getHumanoid(player)
                if humanoid then
                    pcall(function()
                        humanoid.Health = 0
                    end)
                end
            end
        end
        GemoroiUI:Notify({ Title = "Mass Action", Content = "Kill All executed!", Duration = 3 })
    end
})

local killDropdown
killDropdown = Tabs.Mass:AddDropdown("KillPlayerDropdown", {
    Title = "Select Target Player",
    Values = playerNames,
    Default = "None",
    Callback = function(Option)
        Config.KillTarget = Option ~= "None" and Players:FindFirstChild(Option) or nil
    end
})

Tabs.Mass:AddButton({
    Title = "Refresh Player List",
    Callback = function()
        refreshPlayers()
        killDropdown:SetValues(playerNames)
        GemoroiUI:Notify({ Title = "Refreshed", Content = "Player list updated", Duration = 2 })
    end
})

Tabs.Mass:AddButton({
    Title = "Kill Selected Player",
    Callback = function()
        if not Config.KillTarget then
            GemoroiUI:Notify({ Title = "Error", Content = "No player selected!", Duration = 2 })
            return
        end
        local humanoid = getHumanoid(Config.KillTarget)
        if humanoid then
            humanoid.Health = 0
            GemoroiUI:Notify({ Title = "Success", Content = "Killed " .. Config.KillTarget.Name, Duration = 2 })
        else
            GemoroiUI:Notify({ Title = "Error", Content = "Target character not found", Duration = 2 })
        end
    end
})

Tabs.Mass:AddToggle("LoopKillToggle", {
    Title = "Enable Loop Kill",
    Default = false,
    Callback = function(Value)
        Config.LoopKillEnabled = Value
    end
})

Tabs.Mass:AddSection("Fling Utilities (Zentrix)")

Tabs.Mass:AddSlider("FlingPowerSlider", {
    Title = "Fling Power Level (1-6)",
    Default = 1,
    Min = 1,
    Max = 6,
    Rounding = 0,
    Callback = function(Value)
        Config.FlingPower = Value
    end
})

Tabs.Mass:AddButton({
    Title = "Fling Closest Player (Key F)",
    Callback = function()
        flingClosestTarget()
    end
})

-- === PROTECTION TAB ===
Tabs.Protection:AddSection("Safety & Anti-Measures")

Tabs.Protection:AddToggle("AntiGrabToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(Value)
        Config.AntiGrabEnabled = Value
    end
})

Tabs.Protection:AddToggle("AnchorGrabToggle", {
    Title = "Anchor Grab (Freeze on Drop)",
    Default = false,
    Callback = function(Value)
        Config.AnchorGrabEnabled = Value
        GemoroiUI:Notify({ Title = "Anchor Grab", Content = Value and "Enabled (Dropped items freeze in mid-air)" or "Disabled", Duration = 3 })
    end
})

Tabs.Protection:AddToggle("AntiFlingToggle", {
    Title = "Anti Fling",
    Default = false,
    Callback = function(Value)
        Config.AntiFlingEnabled = Value
    end
})

Tabs.Protection:AddToggle("AntiGucciToggle", {
    Title = "Anti-Gucci (Blobman Seat Protection)",
    Default = false,
    Callback = function(Value)
        Config.AntiGucciEnabled = Value
        if Value then
            task.spawn(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    local hrp = getRoot(LocalPlayer)
                    local hum = getHumanoid(LocalPlayer)
                    if not char or not hrp or not hum then return end
                    
                    local spawnToy = ReplicatedStorage:FindFirstChild("MenuToys") and ReplicatedStorage.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
                    if spawnToy then
                        spawnToy:InvokeServer("CreatureBlobman", hrp.CFrame * CFrame.new(0, 5, 0), Vector3.new(0, 0, 0))
                    end
                    task.wait(0.5)
                    local folder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                    local blob = folder and folder:FindFirstChild("CreatureBlobman")
                    local seat = blob and blob:FindFirstChild("VehicleSeat")
                    if seat and seat:IsA("VehicleSeat") then
                        seat:Sit(hum)
                        -- GUCCI GODMODE: lift the seat to 50,000 studs and enable
                        -- free WASD movement via hum.MoveDirection
                        pcall(function()
                            local seatRoot = blob.PrimaryPart or seat
                            local ge = ReplicatedStorage:FindFirstChild("GrabEvents")
                            local sno = ge and ge:FindFirstChild("SetNetworkOwner")
                            if sno then
                                sno:FireServer(seatRoot, seatRoot.CFrame)
                            end
                            seat.Anchored = false
                            AmethystFeatures.Gucci.active = true
                            AmethystFeatures.Gucci.blobman = blob
                            if AmethystFeatures.Gucci.connection then
                                AmethystFeatures.Gucci.connection:Disconnect()
                            end
                            AmethystFeatures.Gucci.connection = RunService.RenderStepped:Connect(function()
                                if not AmethystFeatures.Gucci.active then return end
                                pcall(function()
                                    local move = hum.MoveDirection
                                    local dir = Vector3.new(move.X, 0, move.Z)
                                    if dir.Magnitude > 0 then
                                        seat.AssemblyLinearVelocity = dir.Unit * 60
                                    end
                                    if seat.Position.Y < 50000 then
                                        seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + Vector3.new(0, 500, 0)
                                    end
                                end)
                            end)
                        end)
                        GemoroiUI:Notify({ Title = "Anti-Gucci Godmode", Content = "Seat rising to 50,000 studs - WASD to move!", Duration = 4 })
                    end
                end)
            end)
        else
            AmethystFeatures.Gucci.active = false
            if AmethystFeatures.Gucci.connection then
                AmethystFeatures.Gucci.connection:Disconnect()
                AmethystFeatures.Gucci.connection = nil
            end
            pcall(function()
                local folder = Workspace:FindFirstChild(LocalPlayer.Name .. "SpawnedInToys")
                if folder and folder:FindFirstChild("CreatureBlobman") then
                    folder.CreatureBlobman:Destroy()
                end
            end)
        end
    end
})

Tabs.Protection:AddToggle("AutoAntiRagdollToggle", {
    Title = "Auto Anti Ragdoll",
    Default = false,
    Callback = function(Value)
        Config.AntiRagdollAuto = Value
    end
})

Tabs.Protection:AddButton({
    Title = "Anti Ragdoll Once",
    Callback = function()
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                humanoid.Sit = false
            end)
            GemoroiUI:Notify({ Title = "Protection", Content = "Ragdoll cleared", Duration = 2 })
        end
    end
})

Tabs.Protection:AddButton({
    Title = "Delete Void (Save Height)",
    Callback = function()
        pcall(function()
            Workspace.FallenPartsDestroyHeight = -50000
        end)
        GemoroiUI:Notify({ Title = "Protection", Content = "Void height extended", Duration = 2 })
    end
})

Tabs.Protection:AddToggle("TouchQueryToggle", {
    Title = "Ignore Hazards (CanTouch/CanQuery Off)",
    Default = false,
    Callback = function(Value)
        Config.TouchQuerySafe = Value
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanTouch = not Value
                    v.CanQuery = not Value
                end
            end
        end
    end
})

-- === AURAS TAB ===
Tabs.Auras:AddSection("Proximity Auras")

Tabs.Auras:AddToggle("LaunchAuraToggle", {
    Title = "Launch Aura",
    Default = false,
    Callback = function(Value)
        Config.LaunchAuraEnabled = Value
    end
})

Tabs.Auras:AddToggle("TelekinesisAuraToggle", {
    Title = "Telekinesis Aura",
    Default = false,
    Callback = function(Value)
        Config.TelekinesisAuraEnabled = Value
    end
})

Tabs.Auras:AddToggle("DeathAuraToggle", {
    Title = "Death Aura",
    Default = false,
    Callback = function(Value)
        Config.DeathAuraEnabled = Value
    end
})

Tabs.Auras:AddSlider("AuraRadiusSlider", {
    Title = "Aura Radius",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        Config.AuraRadius = Value
    end
})

AurasTab:AddSection("Fling Aura")

AurasTab:AddToggle("FlingAuraToggle", {
    Title = "Fling Aura",
    Description = "Randomly flings nearby enemies at extreme speed",
    Default = false,
    Callback = function(Value)
        setFlingAura(Value)
    end
})

AurasTab:AddSlider("FlingAuraRadiusSlider", {
    Title = "Fling Aura Radius",
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Suffix = " studs",
    Callback = function(Value)
        Config.FlingAuraRadius = Value
    end
})

-- === TELEPORTS TAB ===
Tabs.Teleports:AddSection("Location Teleports")

local houseTeleports = {
    {"Pink House", CFrame.new(-491, -7, -166)},
    {"Green House", CFrame.new(-535, -7, 93)},
    {"Purple House", CFrame.new(250, -6, 463)},
    {"China House", CFrame.new(554, 123, -72)},
    {"Blue House", CFrame.new(510, 83, -339)},
    {"Spawn", CFrame.new(3, -7, -2)},
    {"Train Station", CFrame.new(-210, 60, -420)},
    {"High Mountain", CFrame.new(700, 320, -600)},
    {"Sky Safe Base", CFrame.new(0, 500, 0)},
    {"Void", CFrame.new(0, -250, 0)},
    {"Secret Cave", CFrame.new(-620, -40, 300)},
}

for _, house in ipairs(houseTeleports) do
    Tabs.Teleports:AddButton({
        Title = "Teleport to " .. house[1],
        Callback = function()
            local root = getRoot(LocalPlayer)
            if root then
                root.CFrame = house[2]
                GemoroiUI:Notify({ Title = "Teleport", Content = "Teleported to " .. house[1], Duration = 2 })
            end
        end
    })
end

Tabs.Teleports:AddSection("Plot Bases")

do
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if plotsFolder then
        for i = 1, 12 do
            local plot = plotsFolder:FindFirstChild("Plot" .. i)
            if plot then
                local base = plot:FindFirstChild("PlotArea") or plot:FindFirstChildOfClass("BasePart") or plot.PrimaryPart
                if base then
                    local plotCF = base.CFrame * CFrame.new(0, 5, 0)
                    Tabs.Teleports:AddButton({
                        Title = "Teleport to Plot " .. i,
                        Callback = function()
                            local root = getRoot(LocalPlayer)
                            if root then
                                root.CFrame = plotCF
                                Notify("Teleport", "Teleported to Plot " .. i, 2)
                            end
                        end
                    })
                end
            end
        end
    end
end

Tabs.Teleports:AddSection("Click & Player Teleports")

Tabs.Teleports:AddToggle("ClickTPToggle", {
    Title = "Click TP (teleport on mouse click)",
    Default = false,
    Callback = function(Value)
        setClickTP(Value)
    end
})

local tpPlayerDropdown
local function refreshTpPlayers()
    local names = { "None" }
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    if tpPlayerDropdown then
        tpPlayerDropdown:SetValues(names)
    end
end

tpPlayerDropdown = Tabs.Teleports:AddDropdown("TeleportPlayerDropdown", {
    Title = "Teleport to Player",
    Values = { "None" },
    Default = "None",
    Callback = function(Value)
        if Value ~= "None" then
            teleportToPlayerByName(Value)
        end
    end
})
refreshTpPlayers()

-- === MAIN RUNTIME LOOPS ===
RunService.RenderStepped:Connect(function()
    -- FOV Circle update & Silent Aim / Aimbot lock
    if fovCircle then
        if Config.SilentAimEnabled and Config.ShowFOV then
            local mousePos = UserInputService:GetMouseLocation()
            fovCircle.Position = mousePos
            fovCircle.Visible = true
        else
            fovCircle.Visible = false
        end
    end

    if Config.SilentAimEnabled then
        local target = getClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- Walkspeed loop
    if Config.WalkspeedEnabled then
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.WalkSpeed = Config.WalkspeedValue
        end
    end

    -- Noclip loop
    if Config.NoclipEnabled then
        local char = getCharacter(LocalPlayer)
        if char then
            for _, part in ipairs(getSafeParts(char)) do
                part.CanCollide = false
            end
        end
    end

    -- Third Person View Fix enforcement (game resets the camera every frame)
    if Config.ThirdPersonFix then
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = Config.ThirdPersonDistance
        end)
    end

    -- Fly engine update
    pcall(updateFly)

    -- ESP highlights update
    if Config.ESPEnabled then
        updateESPHighlights()
    end

    -- PCLD ESP update
    if Config.PCLD_ESPEnabled then
        updatePCLDESP()
    end

    -- Workspace Models Visuals update
    if Config.ModelHighlightEnabled then
        pcall(function() updateModelHighlights(true) end)
    end

    if Config.ModelBillboardEnabled then
        pcall(function() updateModelBillboards(true) end)
    end
end)

-- Infinite Jump connection
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJumpEnabled then
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Loop Kill task
task.spawn(function()
    while true do
        if Config.LoopKillEnabled and Config.KillTarget then
            pcall(function()
                local humanoid = getHumanoid(Config.KillTarget)
                if humanoid then
                    humanoid.Health = 0
                end
            end)
        end
        task.wait(Config.LoopKillDelay or 0.5)
    end
end)

-- Auras task (Launch, Telekinesis, Death)
task.spawn(function()
    while true do
        pcall(function()
            local myRoot = getRoot(LocalPlayer)
            if myRoot and (Config.LaunchAuraEnabled or Config.DeathAuraEnabled or Config.TelekinesisAuraEnabled) then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local root = getRoot(player)
                        if root and (root.Position - myRoot.Position).Magnitude <= Config.AuraRadius then
                            local humanoid = getHumanoid(player)
                            if humanoid then
                                if Config.DeathAuraEnabled then
                                    humanoid.Health = 0
                                elseif Config.LaunchAuraEnabled then
                                    root.Velocity = Vector3.new(0, 200, 0)
                                elseif Config.TelekinesisAuraEnabled then
                                    root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- Supercharged Anti-Grab & Defense background task
task.spawn(function()
    pcall(function()
        Workspace.DescendantAdded:Connect(function(d)
            if d.Name == "PaintPlayerPart" then
                task.wait(0.05)
                pcall(function() d:Destroy() end)
            end
        end)
    end)

    while true do
        pcall(function()
            local hrp = getRoot(LocalPlayer)
            local hum = getHumanoid(LocalPlayer)

            if Config.AntiGrabEnabled then
                local isHeldVal = LocalPlayer:FindFirstChild("IsHeld")
                if isHeldVal and isHeldVal.Value then
                    pcall(function()
                        local struggleEvent = ReplicatedStorage:FindFirstChild("CharacterEvents") and ReplicatedStorage.CharacterEvents:FindFirstChild("Struggle")
                        if struggleEvent then
                            struggleEvent:FireServer()
                            struggleEvent:FireServer()
                        end
                        local destroyLine = ReplicatedStorage:FindFirstChild("GrabEvents") and ReplicatedStorage.GrabEvents:FindFirstChild("DestroyGrabLine")
                        if destroyLine then
                            destroyLine:FireServer()
                        end
                        if hrp then
                            hrp.Anchored = true
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                else
                    pcall(function()
                        if hrp and hrp.Anchored then
                            hrp.Anchored = false
                        end
                    end)
                end
            end

            if Config.AntiFlingEnabled and hrp then
                if hrp.AssemblyLinearVelocity.Magnitude > 150 then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                if hum then
                    if hum.PlatformStand or hum.Sit then
                        hum.PlatformStand = false
                        hum.Sit = false
                        hum.AutoRotate = true
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
            end

            if Config.AntiRagdollAuto and hum then
                if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum.Sit then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum.Sit = false
                end
            end
        end)
        task.wait(0.02)
    end
end)

-- === COSMETICS & SHADERS TAB ===
Tabs.Cosmetics:AddSection("Phantom Parts & Rainbow")

Tabs.Cosmetics:AddToggle("PhantomHeadlessToggle", {
    Title = "Phantom Headless Mesh",
    Default = false,
    Callback = function(Value)
        pcall(function()
            local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
            if not head then return end
            if Value then
                head.Transparency = 1
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency = 1
                    end
                end
            else
                head.Transparency = 0
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then
                        d.Transparency = 0
                    end
                end
            end
        end)
    end
})

Tabs.Cosmetics:AddToggle("PhantomKorbloxToggle", {
    Title = "Phantom Korblox Leg",
    Default = false,
    Callback = function(Value)
        pcall(function()
            local leg = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Right Leg") or LocalPlayer.Character:FindFirstChild("RightLowerLeg"))
            if not leg then return end
            if Value then
                leg.Transparency = 0.45
                leg.Material = Enum.Material.Neon
                leg.Color = Color3.fromRGB(57, 255, 20)
            else
                leg.Transparency = 0
                leg.Material = Enum.Material.Plastic
                leg.Color = Color3.fromRGB(255, 204, 153)
            end
        end)
    end
})

local rainbowHatState = { part = nil, thread = nil }

Tabs.Cosmetics:AddToggle("RainbowHatToggle", {
    Title = "Rainbow Hat",
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                local char = LocalPlayer.Character
                local head = char and (char:FindFirstChild("Head") or char:FindFirstChildOfClass("BasePart"))
                if not head then return end
                if rainbowHatState.part and rainbowHatState.part.Parent then
                    rainbowHatState.part:Destroy()
                end
                local hat = Instance.new("Part")
                hat.Name = "Gemoroi_RainbowHat"
                hat.Size = Vector3.new(1.6, 0.9, 1.6)
                hat.Material = Enum.Material.Neon
                hat.CanCollide = false
                hat.Massless = true
                hat.Parent = char
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hat
                weld.Part1 = head
                weld.Parent = hat
                hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
                rainbowHatState.part = hat
                if rainbowHatState.thread then task.cancel(rainbowHatState.thread) end
                rainbowHatState.thread = task.spawn(function()
                    local hue = 0
                    while rainbowHatState.part and rainbowHatState.part.Parent do
                        rainbowHatState.part.Color = Color3.fromHSV(hue % 1, 1, 1)
                        hue = hue + 0.01
                        task.wait(0.03)
                    end
                end)
            end)
        else
            if rainbowHatState.thread then
                task.cancel(rainbowHatState.thread)
                rainbowHatState.thread = nil
            end
            if rainbowHatState.part then
                pcall(function() rainbowHatState.part:Destroy() end)
                rainbowHatState.part = nil
            end
        end
    end
})

local rainbowFFState = { highlight = nil, thread = nil }

Tabs.Cosmetics:AddToggle("RainbowForceFieldToggle", {
    Title = "Rainbow ForceField Skin",
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                if not rainbowFFState.highlight then
                    local hl = Instance.new("Highlight")
                    hl.Name = "Gemoroi_RainbowFF"
                    hl.Adornee = char
                    hl.FillTransparency = 0.55
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = CoreGui
                    rainbowFFState.highlight = hl
                end
                if rainbowFFState.thread then task.cancel(rainbowFFState.thread) end
                rainbowFFState.thread = task.spawn(function()
                    local hue = 0
                    while rainbowFFState.highlight do
                        local color = Color3.fromHSV(hue % 1, 1, 1)
                        rainbowFFState.highlight.FillColor = color
                        rainbowFFState.highlight.OutlineColor = color
                        hue = hue + 0.005
                        task.wait(0.03)
                    end
                end)
            end)
        else
            if rainbowFFState.thread then
                task.cancel(rainbowFFState.thread)
                rainbowFFState.thread = nil
            end
            if rainbowFFState.highlight then
                pcall(function() rainbowFFState.highlight:Destroy() end)
                rainbowFFState.highlight = nil
            end
        end
    end
})

Tabs.Cosmetics:AddSection("Gemoroi Lighting Presets")

for _, preset in ipairs({
    { Name = "Cyberpunk City",
      Shader = {CC={Brightness=0.05,Contrast=0.25,Saturation=0.35,TintColor=Color3.fromRGB(120,200,255)},Bloom={Intensity=0.8,Size=40,Threshold=0.9},SunRays=0.15,L={Brightness=1.6,ClockTime=0,FogEnd=450,FogColor=Color3.fromRGB(10,20,40),Ambient=Color3.fromRGB(30,60,120),OutdoorAmbient=Color3.fromRGB(40,80,140)}} },
    { Name = "Midnight Purple",
      Shader = {CC={Brightness=-0.05,Contrast=0.15,Saturation=0.1,TintColor=Color3.fromRGB(160,120,255)},Bloom={Intensity=0.5,Size=32,Threshold=0.8},SunRays=0.05,L={Brightness=0.9,ClockTime=0,FogEnd=600,FogColor=Color3.fromRGB(40,20,70),Ambient=Color3.fromRGB(60,40,100),OutdoorAmbient=Color3.fromRGB(70,50,110)}} },
    { Name = "Dreamy Sunset",
      Shader = {CC={Brightness=0.1,Contrast=0.1,Saturation=0.25,TintColor=Color3.fromRGB(255,180,140)},Bloom={Intensity=0.7,Size=36,Threshold=0.85},SunRays=0.4,L={Brightness=1.4,ClockTime=17.6,FogEnd=800,FogColor=Color3.fromRGB(255,150,100),Ambient=Color3.fromRGB(200,140,120),OutdoorAmbient=Color3.fromRGB(255,170,120)}} },
    { Name = "Rainy Day",
      Shader = {CC={Brightness=-0.1,Contrast=0.05,Saturation=-0.15,TintColor=Color3.fromRGB(180,200,220)},Bloom={Intensity=0.3,Size=24,Threshold=0.9},L={Brightness=1.0,ClockTime=14,FogEnd=250,FogStart=20,FogColor=Color3.fromRGB(150,165,180),Ambient=Color3.fromRGB(120,130,145),OutdoorAmbient=Color3.fromRGB(130,140,155)}} },
    { Name = "Desert Heat",
      Shader = {CC={Brightness=0.15,Contrast=0.2,Saturation=0.15,TintColor=Color3.fromRGB(255,220,160)},Bloom={Intensity=0.6,Size=34,Threshold=0.88},SunRays=0.5,L={Brightness=2.0,ClockTime=13.5,FogEnd=900,FogColor=Color3.fromRGB(230,200,150),Ambient=Color3.fromRGB(220,190,150),OutdoorAmbient=Color3.fromRGB(235,205,160)}} },
}) do
    Tabs.Cosmetics:AddButton({
        Title = "Shader: " .. preset.Name,
        Callback = function()
            ApplyShader(preset.Shader)
            Notify("Shaders", preset.Name .. " applied!", 2)
        end
    })
end

Tabs.Cosmetics:AddSection("Wings & Accessories")

Tabs.Cosmetics:AddToggle("AngelWingsToggle", {
    Title = "Angel Wings",
    Default = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                local char = LocalPlayer.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                if not root then return end
                if char:FindFirstChild("AngelWings") then char.AngelWings:Destroy() end

                local model = Instance.new("Model", char)
                model.Name = "AngelWings"

                local leftWing = Instance.new("Part", model)
                leftWing.Size = Vector3.new(0.5, 3.0, 1.5)
                leftWing.Color = Color3.fromRGB(250, 250, 255)
                leftWing.Material = Enum.Material.Neon
                leftWing.CanCollide = false
                leftWing.CFrame = root.CFrame * CFrame.new(-1.5, 0.5, 0.6)

                local lw = Instance.new("Weld", leftWing)
                lw.Part0 = root
                lw.Part1 = leftWing
                lw.C0 = root.CFrame:ToObjectSpace(leftWing.CFrame)

                local rightWing = Instance.new("Part", model)
                rightWing.Size = Vector3.new(0.5, 3.0, 1.5)
                rightWing.Color = Color3.fromRGB(250, 250, 255)
                rightWing.Material = Enum.Material.Neon
                rightWing.CanCollide = false
                rightWing.CFrame = root.CFrame * CFrame.new(1.5, 0.5, 0.6)

                local rw = Instance.new("Weld", rightWing)
                rw.Part0 = root
                rw.Part1 = rightWing
                rw.C0 = root.CFrame:ToObjectSpace(rightWing.CFrame)
            end)
        else
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("AngelWings") then
                    char.AngelWings:Destroy()
                end
            end)
        end
    end
})

Tabs.Cosmetics:AddSection("Atmosphere & Lighting Shaders")

local function ClearShaders()
    pcall(function()
        for _, e in pairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Sky") or e:IsA("Atmosphere") then
                e:Destroy()
            end
        end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
    end)
end

local function ApplyShader(cfg)
    ClearShaders()
    pcall(function()
        if cfg.CC then
            local cc = Instance.new("ColorCorrectionEffect", Lighting)
            for k, v in pairs(cfg.CC) do cc[k] = v end
        end
        if cfg.Blur then
            local bu = Instance.new("BlurEffect", Lighting)
            bu.Size = cfg.Blur
        end
        if cfg.Bloom then
            local bl = Instance.new("BloomEffect", Lighting)
            for k, v in pairs(cfg.Bloom) do bl[k] = v end
        end
        if cfg.SunRays then
            local sr = Instance.new("SunRaysEffect", Lighting)
            sr.Intensity = cfg.SunRays
        end
        if cfg.L then
            for k, v in pairs(cfg.L) do Lighting[k] = v end
        end
    end)
end

Tabs.Cosmetics:AddButton({
    Title = "Shader: Warm Sunshine",
    Callback = function()
        ApplyShader({CC={Brightness=0.25,Contrast=0.1,Saturation=0.3,TintColor=Color3.fromRGB(255,245,220)},SunRays=0.35,L={Brightness=2.5,FogEnd=2000,Ambient=Color3.fromRGB(255,240,200),OutdoorAmbient=Color3.fromRGB(255,230,180),ClockTime=12}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Warm Sunshine applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Sakura Dream",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.05,Saturation=0.2,TintColor=Color3.fromRGB(255,225,235)},SunRays=0.25,L={Brightness=2.3,FogEnd=1500,Ambient=Color3.fromRGB(255,215,230),OutdoorAmbient=Color3.fromRGB(255,200,220),ClockTime=8}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Sakura Dream applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Clear Sky",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.1,Saturation=0.15,TintColor=Color3.fromRGB(220,235,255)},SunRays=0.3,L={Brightness=2.8,FogEnd=5000,Ambient=Color3.fromRGB(200,220,250),OutdoorAmbient=Color3.fromRGB(180,200,240),ClockTime=11}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Clear Sky applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Mint Fresh",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.08,Saturation=0.1,TintColor=Color3.fromRGB(200,240,220)},SunRays=0.2,L={Brightness=2.4,FogEnd=2000,Ambient=Color3.fromRGB(190,230,210),OutdoorAmbient=Color3.fromRGB(170,210,190),ClockTime=10}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Mint Fresh applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Peach Smooth",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.05,Saturation=0.25,TintColor=Color3.fromRGB(255,220,200)},SunRays=0.3,L={Brightness=2.5,FogEnd=1800,Ambient=Color3.fromRGB(255,210,190),OutdoorAmbient=Color3.fromRGB(255,195,175),ClockTime=16}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Peach Smooth applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Ocean Breeze",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.1,Saturation=0.1,TintColor=Color3.fromRGB(180,215,240)},Blur=0.3,L={Brightness=2.2,FogEnd=1200,Ambient=Color3.fromRGB(170,210,240),OutdoorAmbient=Color3.fromRGB(150,190,230),ClockTime=13}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Ocean Breeze applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Golden Hour",
    Callback = function()
        ApplyShader({CC={Brightness=0.2,Contrast=0.1,Saturation=0.3,TintColor=Color3.fromRGB(255,235,200)},SunRays=0.4,L={Brightness=2.6,FogEnd=2000,Ambient=Color3.fromRGB(255,225,180),OutdoorAmbient=Color3.fromRGB(255,210,160),ClockTime=17}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Golden Hour applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Frost Morning",
    Callback = function()
        ApplyShader({CC={Brightness=0.3,Contrast=0.05,Saturation=-0.2,TintColor=Color3.fromRGB(220,230,255)},Blur=0.5,L={Brightness=3,FogEnd=1000,Ambient=Color3.fromRGB(220,225,250),OutdoorAmbient=Color3.fromRGB(200,210,240),ClockTime=7}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Frost Morning applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Soft Sunset",
    Callback = function()
        ApplyShader({CC={Brightness=0.15,Contrast=0.08,Saturation=0.3,TintColor=Color3.fromRGB(255,210,190)},SunRays=0.5,L={Brightness=2,FogEnd=1500,Ambient=Color3.fromRGB(255,180,140),OutdoorAmbient=Color3.fromRGB(255,160,120),ClockTime=18.5}})
        GemoroiUI:Notify({ Title = "Shaders", Content = "Soft Sunset applied!", Duration = 2 })
    end
})

Tabs.Cosmetics:AddButton({
    Title = "Shader: Reset / Default",
    Callback = function()
        ClearShaders()
        GemoroiUI:Notify({ Title = "Shaders", Content = "Reset to default!", Duration = 2 })
    end
})

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F then
            flingClosestTarget()
        end
    end
end)

-- Anchor Grab background task (Freeze on Drop)
local anchoredObjects = {}
task.spawn(function()
    while true do
        pcall(function()
            if Config.AnchorGrabEnabled then
                for _, toy in ipairs(Workspace:GetDescendants()) do
                    if toy:IsA("Model") and toy:FindFirstChild("HoldPart") then
                        local holdPart = toy.HoldPart
                        local owner = holdPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == "" and not anchoredObjects[toy] then
                            local root = getRoot(LocalPlayer)
                            if root and (holdPart.Position - root.Position).Magnitude < 15 then
                                anchoredObjects[toy] = true
                                holdPart.Anchored = true
                                holdPart.AssemblyLinearVelocity = Vector3.zero
                                holdPart.AssemblyAngularVelocity = Vector3.zero
                                local bp = Instance.new("BodyPosition", holdPart)
                                bp.Position = holdPart.Position
                                bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                                bp.P = 10000
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.2)
    end
end)

-- Amethyst Premium background defense & notification tasks
task.spawn(function()
    print("[AMETHYST] ÐžÐ¶Ð¸Ð´Ð°Ð½Ð¸Ðµ Ð·Ð°Ð³Ñ€ÑƒÐ·ÐºÐ¸ Ð¸Ð³Ñ€Ñ‹...")
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    if not game.Players.LocalPlayer then
        task.wait(.1)
    end
    local lp = game.Players.LocalPlayer
    if lp then
        if not lp.Character then
            lp.CharacterAdded:Wait()
        end
        task.wait(2)
        print("[AMETHYST] ===== ÐÐšÐ¢Ð˜Ð’ÐÐ¦Ð˜Ð¯ Ð’Ð¡Ð•Ð¥ Ð—ÐÐ©Ð˜Ð¢ÐÐ«Ð¥ Ð¤Ð£ÐÐšÐ¦Ð˜Ð™ =====")

        pcall(function()
            local ui = Instance.new("ScreenGui")
            ui.Name = "KickNotifyUI"
            ui.Parent = S.CoreGui

            local notifications = {}
            local notificationTimes = {}
            local retentionTime = 30

            local function canNotify(key)
                if not notificationTimes[key] then return true end
                if tick() - notificationTimes[key] > retentionTime then
                    notificationTimes[key] = nil
                    return true
                end
                return false
            end

            local function cleanupNotifications()
                local dead = {}
                for i, v in ipairs(notifications) do
                    if not v or not v.Parent then table.insert(dead, i) end
                end
                for i = #dead, 1, -1 do table.remove(notifications, dead[i]) end
            end

            local function showKickNotify(ownerName, displayName)
                if not canNotify(ownerName) then return end
                notificationTimes[ownerName] = tick()
                local frame = Instance.new("Frame")
                frame.Name = "KickNotification_" .. ownerName .. "_" .. tick()
                frame.Size = UDim2.new(0, 300, 0, 80)
                frame.Position = UDim2.new(1, -320, 0, 80)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                frame.BackgroundTransparency = .1
                frame.BorderSizePixel = 0
                frame.Parent = ui
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(180, 180, 180)
                stroke.Thickness = 2
                stroke.Transparency = .3

                local title = Instance.new("TextLabel")
                title.Size = UDim2.new(1, -20, 0, 20)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "KICK DETECTED"
                title.TextColor3 = Color3.fromRGB(255, 255, 255)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 16
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Parent = frame

                local victim = Instance.new("TextLabel")
                victim.Size = UDim2.new(1, -20, 0, 24)
                victim.Position = UDim2.new(0, 10, 0, 30)
                victim.BackgroundTransparency = 1
                victim.Text = displayName .. " (" .. ownerName .. ")"
                victim.TextColor3 = Color3.fromRGB(255, 255, 255)
                victim.Font = Enum.Font.GothamSemibold
                victim.TextSize = 14
                victim.TextXAlignment = Enum.TextXAlignment.Left
                victim.Parent = frame

                table.insert(notifications, frame)
                PlayKickSound()

                local tween = game:GetService("TweenService")
                task.delay(4.7, function()
                    if frame and frame.Parent then
                        tween:Create(frame, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
                        task.wait(0.5)
                        frame:Destroy()
                    end
                end)
            end

            S.Workspace.ChildAdded:Connect(function(child)
                if child.Name == "BlackHoleKick" or child.Name == "BlackHole" then
                    child.Name = "BlackHole_Detected_" .. tick()
                    local snapshot = {}
                    for _, p in pairs(S.Players:GetPlayers()) do
                        if p ~= LocalPlayer then snapshot[p.Name] = p.DisplayName end
                    end
                    task.wait(3.25)
                    local present = {}
                    for _, p in pairs(S.Players:GetPlayers()) do present[p.Name] = true end
                    local left = {}
                    for name, display in pairs(snapshot) do
                        if not present[name] then table.insert(left, {name = name, display = display}) end
                    end
                    if #left > 0 then
                        for _, info in ipairs(left) do
                            cleanupNotifications()
                            showKickNotify(info.name, info.display)
                            task.wait(.1)
                        end
                    end
                end
            end)
        end)
    end
end)

-- === PLAYER TAB (Amethyst Integration) ===
Tabs.Player:AddSection("Player")

Tabs.Player:AddToggle("LoopTPToggle", {
    Title = "Loop Teleport",
    Default = false,
    Callback = function(state)
        if state then
            TeleportCfg.loop.enabled = true
            TeleportCfg.loop.loopThread = task.spawn(function()
                while TeleportCfg.loop.enabled do
                    if LocalPlayer.Character then
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and TeleportCfg.loop.target then
                            root.CFrame = TeleportCfg.loop.target
                        end
                        task.wait()
                    end
                end
            end)
            GemoroiUI:Notify({ Title = "Loop TP", Content = "Enabled - Looping to selected location", Duration = 3 })
            PlayEnableSound()
        else
            TeleportCfg.loop.enabled = false
            if TeleportCfg.loop.loopThread then
                task.cancel(TeleportCfg.loop.loopThread)
                TeleportCfg.loop.loopThread = nil
            end
            GemoroiUI:Notify({ Title = "Loop TP", Content = "Disabled", Duration = 2 })
        end
    end
})

local houseNames = {}
for _, house in ipairs(TeleportCfg.houses) do
    table.insert(houseNames, house[1])
end

Tabs.Player:AddDropdown("TeleportLocationDropdown", {
    Title = "Teleport Location",
    Values = houseNames,
    Default = "Spawn",
    Callback = function(selected)
        for _, house in ipairs(TeleportCfg.houses) do
            if house[1] == selected then
                TeleportCfg.loop.target = house[2]
                break
            end
        end
    end
})

Tabs.Player:AddButton({
    Title = "Teleport Once",
    Callback = function()
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and TeleportCfg.loop.target then
                root.CFrame = TeleportCfg.loop.target
                GemoroiUI:Notify({ Title = "Teleport", Content = "Teleported to selected location", Duration = 2 })
                PlayEnableSound()
            end
        end
    end
})

Tabs.Player:AddSection("Speed player")

Tabs.Player:AddSlider("SpeedControlSlider", {
    Title = "Speed Control",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        SpeedCfg.value = value
        if SpeedCfg.enabled then
            local humanoid = GetCharHumanoid()
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
})

Tabs.Player:AddToggle("EnableSpeedToggle", {
    Title = "Enable Speed",
    Default = false,
    Callback = function(state)
        if state then
            EnableSpeed()
            GemoroiUI:Notify({ Title = "Speed", Content = "Enabled - WalkSpeed: " .. SpeedCfg.value, Duration = 2 })
            PlayEnableSound()
        else
            DisableSpeed()
            GemoroiUI:Notify({ Title = "Speed", Content = "Disabled", Duration = 2 })
        end
    end
})


-- === DEFENSE TAB (Amethyst Integration) ===
Tabs.Defense:AddSection("Anti-Function")

Tabs.Defense:AddToggle("AntiGrabAmethystToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(state)
        if state then
            AntiGrabCfg.enabled = true
            AntiGrabCfg.antiGrabEnabled = true
            local antiGrab = { remotes = {}, parts = {}, conns = {} }
            local function getRemote(name)
                if antiGrab.remotes[name] then return antiGrab.remotes[name] end
                for _, desc in ipairs(S.ReplicatedStorage:GetDescendants()) do
                    if desc.Name == name and desc:IsA("RemoteEvent") then
                        antiGrab.remotes[name] = desc
                        return desc
                    end
                end
            end
            local function OnHeartbeat()
                if not antiGrab.parts.IsHeld or not antiGrab.parts.IsHeld.Value then return end
                if not antiGrab.parts.Root or not antiGrab.parts.Humanoid then return end
                antiGrab.parts.Root.Anchored = true
                S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(antiGrab.parts.Root, antiGrab.parts.Root.CFrame)
                antiGrab.parts.Root.Massless = true
                antiGrab.parts.Root.CanCollide = false
                antiGrab.parts.Root.CanQuery = false
                antiGrab.parts.Root.AssemblyLinearVelocity = Vector3.zero
                antiGrab.parts.Root.AssemblyAngularVelocity = Vector3.zero
                local struggle = getRemote("Struggle")
                local ragdoll = getRemote("RagdollRemote")
                if struggle then struggle:FireServer() end
                if ragdoll then ragdoll:FireServer(antiGrab.parts.Root, 0) end
                if antiGrab.parts.originalGrabPosition then
                    antiGrab.parts.Root.CFrame = antiGrab.parts.originalGrabPosition
                end
                antiGrab.parts.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                antiGrab.parts.Humanoid.Sit = false
                antiGrab.parts.Humanoid.PlatformStand = false
            end
            local function OnHeldChanged()
                if not antiGrab.parts.IsHeld then return end
                if antiGrab.parts.IsHeld.Value then
                    antiGrab.parts.grabStartTime = os.clock()
                    if antiGrab.parts.Root then
                        antiGrab.parts.originalGrabPosition = antiGrab.parts.Root.CFrame
                        antiGrab.parts.Root.Anchored = true
                    end
                    if not antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat = S.RunService.Heartbeat:Connect(OnHeartbeat)
                    end
                else
                    if antiGrab.conns.heartbeat then
                        antiGrab.conns.heartbeat:Disconnect()
                        antiGrab.conns.heartbeat = nil
                    end
                    if antiGrab.parts.Root then
                        antiGrab.parts.Root.Anchored = false
                        antiGrab.parts.Root.Massless = false
                        antiGrab.parts.Root.CanCollide = true
                        antiGrab.parts.Root.CanQuery = true
                    end
                end
            end
            local function OnCharacterAdded(character)
                if not character then return end
                antiGrab.parts.Character = character
                antiGrab.parts.Root = character:WaitForChild("HumanoidRootPart")
                antiGrab.parts.Humanoid = character:WaitForChild("Humanoid")
            end
            antiGrab.parts.IsHeld = LocalPlayer:WaitForChild("IsHeld")
            if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end
            antiGrab.conns.charAdded = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
            antiGrab.conns.heldChanged = antiGrab.parts.IsHeld:GetPropertyChangedSignal("Value"):Connect(OnHeldChanged)
            OnHeldChanged()
            GemoroiUI:Notify({ Title = "Anti Grab", Content = "Enabled - Grab protection active", Duration = 2 })
            PlayEnableSound()
        else
            AntiGrabCfg.enabled = false
            AntiGrabCfg.antiGrabEnabled = false
            GemoroiUI:Notify({ Title = "Anti Grab", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddDropdown("AntiKickStickItemDropdown", {
    Title = "Anti Kick (Stick) Item",
    Values = AntiKickStickCfg.items,
    Default = "NinjaShuriken",
    Callback = function(selected)
        AntiKickStickCfg.selectedItem = selected
        GemoroiUI:Notify({ Title = "Anti Kick", Content = "Selected: " .. selected, Duration = 2 })
    end
})

Tabs.Defense:AddToggle("AntiKickStickToggle", {
    Title = "Anti Kick (Stick)",
    Default = false,
    Callback = function(state)
        if state then
            AntiKickStickCfg.enabled = true
            GemoroiUI:Notify({ Title = "Anti Kick", Content = "Enabled with " .. AntiKickStickCfg.selectedItem, Duration = 2 })
            PlayEnableSound()
            AntiKickStickCfg.loopThread = task.spawn(StartAntiKickStickLoop)
        else
            AntiKickStickCfg.enabled = false
            if AntiKickStickCfg.loopThread then
                task.cancel(AntiKickStickCfg.loopThread)
                AntiKickStickCfg.loopThread = nil
            end
            GemoroiUI:Notify({ Title = "Anti Kick", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddSection("Other Defense")

Tabs.Defense:AddToggle("SafePosToggle", {
    Title = "Safe Pos LP",
    Default = false,
    Callback = function(state)
        if state then
            SafePosCfg.enabled = true
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then SafePosCfg.target = root.CFrame end
            end
            if not SafePosCfg.target then
                GemoroiUI:Notify({ Title = "Safe Pos", Content = "Error: Could not save position!", Duration = 2 })
                return
            end
            SafePosCfg.loopThread = task.spawn(function()
                while SafePosCfg.enabled do
                    local char = LocalPlayer.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then root.CFrame = SafePosCfg.target end
                    end
                    task.wait()
                end
            end)
            GemoroiUI:Notify({ Title = "Safe Pos", Content = "Enabled - Position saved", Duration = 2 })
            PlayEnableSound()
        else
            SafePosCfg.enabled = false
            if SafePosCfg.loopThread then
                task.cancel(SafePosCfg.loopThread)
                SafePosCfg.loopThread = nil
            end
            GemoroiUI:Notify({ Title = "Safe Pos", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddToggle("NoclipObjPlayersToggle", {
    Title = "Noclip Obj players",
    Default = false,
    Callback = function(state)
        if state then
            NoclipCfg.enabled = true
            NoclipCfg.parts = {}
            NoclipCfg.connections = {}

            local function IsInputLagItem(name)
                for _, item in ipairs(AntiInputLagCfg.items) do
                    if item == name then
                        return true
                    end
                end
                return false
            end

            local function SetNoclip(model)
                if not model or not model:IsA("Model") then
                    return
                end
                if IsInputLagItem(model.Name) then
                    return
                end
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end

            local function OnCharacter(character)
                if not character then
                    return
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    NoclipCfg.parts[player] = {}
                    if player.Character then
                        OnCharacter(player.Character)
                    end
                    player.CharacterAdded:Connect(function(character)
                        if NoclipCfg.enabled then
                            OnCharacter(character)
                        end
                    end)
                end
            end

            for _, player in ipairs(S.Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            SetNoclip(toy)
                        end
                    end
                end
            end

            NoclipCfg.connections.descendantAdded = S.Workspace.DescendantAdded:Connect(function(desc)
                if not NoclipCfg.enabled then
                    return
                end
                if desc:IsA("Model") and not IsInputLagItem(desc.Name) then
                    local parent = desc.Parent
                    local isOwnFolder = false
                    while parent do
                        if parent.Name == LocalPlayer.Name .. "SpawnedInToys" then
                            isOwnFolder = true
                            break
                        end
                        parent = parent.Parent
                    end
                    if not isOwnFolder then
                        task.wait(.1)
                        SetNoclip(desc)
                    end
                end
            end)

            NoclipCfg.connections.playerAdded = S.Players.PlayerAdded:Connect(function(player)
                if not NoclipCfg.enabled or player == LocalPlayer then
                    return
                end
                NoclipCfg.parts[player] = {}
                player.CharacterAdded:Connect(function(character)
                    if NoclipCfg.enabled then
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            end)

            NoclipCfg.connections.periodicCheck = task.spawn(function()
                while NoclipCfg.enabled do
                    for _, player in ipairs(S.Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") and part.CanCollide then
                                    part.CanCollide = false
                                end
                            end
                            local folder = S.Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
                            if folder then
                                for _, toy in ipairs(folder:GetChildren()) do
                                    if toy:IsA("Model") and not IsInputLagItem(toy.Name) then
                                        for _, part in ipairs(toy:GetDescendants()) do
                                            if part:IsA("BasePart") and part.CanCollide then
                                                part.CanCollide = false
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
            GemoroiUI:Notify({ Title = "Noclip", Content = "Enabled - Noclip through players/items", Duration = 2 })
            PlayEnableSound()
        else
            NoclipCfg.enabled = false
            for _, conn in pairs(NoclipCfg.connections) do
                if conn then
                    if typeof(conn) == "RBXScriptConnection" then
                        conn:Disconnect()
                    else
                        task.cancel(conn)
                    end
                end
            end
            NoclipCfg.connections = {}
            NoclipCfg.parts = {}
            GemoroiUI:Notify({ Title = "Noclip", Content = "Disabled", Duration = 2 })
        end
    end
})

Tabs.Defense:AddButton({
    Title = "Delete Legs",
    Callback = function()
        local lp = LocalPlayer
        local char = lp.Character
        if not char then
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
        if not char or not ragdollRemote then
            return
        end
        if not (char:FindFirstChild("Left Leg")) then
            GemoroiUI:Notify({ Title = "Delete Legs", Content = "Error: Missing body parts", Duration = 3 })
            return
        end
        local torso = char:FindFirstChild("Torso")
        S.Workspace.FallenPartsDestroyHeight = -100
        GemoroiUI:Notify({ Title = "Delete Legs", Content = "Deleting legs...", Duration = 3 })
        PlayEnableSound()
        ragdollRemote:FireServer(root, 2)
        task.wait(0.5)
        char["Right Leg"].CFrame = CFrame.new(0, -10000, 0)
        char["Left Leg"].CFrame = CFrame.new(0, -10000, 0)
        task.wait(.3)
        if torso then
            torso.CFrame = CFrame.new(0, -9970, 0)
        end
        task.wait(0.5)
        if torso then
            local grab = torso.CFrame
            torso.CFrame = grab
        end
        task.wait(0.5)
        S.Workspace.FallenPartsDestroyHeight = S.Workspace.FallenPartsDestroyHeight
        if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
            GemoroiUI:Notify({ Title = "Delete Legs", Content = "Legs successfully deleted!", Duration = 5 })
            PlayEnableSound()
            task.spawn(function()
                while char.Parent do
                    if not char:FindFirstChild("Left Leg") and not char:FindFirstChild("Right Leg") then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            local controls = lp.PlayerGui:FindFirstChild("ControlsGui")
                            local pcFrame = controls and controls:FindFirstChild("PCFrame")
                            local stand = pcFrame and pcFrame:FindFirstChild("Stand")
                            if stand then
                                if stand.Visible == false then
                                    humanoid.HipHeight = 2
                                else
                                    humanoid.HipHeight = 0
                                end
                            end
                        end
                        task.wait()
                    end
                end
            end)
        else
            GemoroiUI:Notify({ Title = "Delete Legs", Content = "Warning: Legs not fully deleted", Duration = 3 })
        end
    end
})


pcall(function()
    print("[AMETHYST] ÐÐºÑ‚Ð¸Ð²Ð°Ñ†Ð¸Ñ Permanent Pallet...")
    PermanentPalletCfg.enabled = true
    local lp = LocalPlayer
    local spawnToyRemote = S.ReplicatedStorage.MenuToys.SpawnToyRemoteFunction
    local destroyToyRemote = S.ReplicatedStorage.MenuToys.DestroyToy
    local setOwnerRemote = S.ReplicatedStorage.GrabEvents.SetNetworkOwner


    local function FindOwnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if not folder then
            return nil
        end
        for _, toy in ipairs(folder:GetChildren()) do
            if toy.Name == "PalletLightBrown" then
                local soundPart = toy:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == lp.Name then
                        return toy
                    else
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                        task.wait(.1)
                        owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return toy
                        end
                    end
                end
            end
        end
        return nil
    end


    local function SpawnPallet()
        local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
        if folder then
            for _, toy in ipairs(folder:GetChildren()) do
                if toy.Name == "PalletLightBrown" then
                    local soundPart = toy:FindFirstChild("SoundPart")
                    if not soundPart or not soundPart:FindFirstChild("PartOwner") or soundPart.PartOwner.Value ~= lp.Name then
                        destroyToyRemote:FireServer(toy)
                        task.wait(.1)
                    end
                end
            end
        end
        local canSpawn = lp:FindFirstChild("CanSpawnToy")
        if canSpawn then
            local start = tick()
            while canSpawn.Value do
                if tick() - start < 5 then
                    task.wait(.1)
                    if not PermanentPalletCfg.enabled then
                        return nil
                    end
                end
                local char = lp.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return nil
                    end
                end
                return nil
            end
            local char = lp.Character
            if not char then
                return nil
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then
                return nil
            end
            spawnToyRemote:InvokeServer("PalletLightBrown", root.CFrame * CFrame.new(0, 30, 20), Vector3.new(0, -90, 0))
            for _ = 1, 20 do
                if not PermanentPalletCfg.enabled then
                    return nil
                end
                local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                local pallet = folder and folder:FindFirstChild("PalletLightBrown")
                if pallet then
                    local soundPart = pallet:FindFirstChild("SoundPart")
                    if soundPart then
                        setOwnerRemote:FireServer(soundPart, soundPart.CFrame)
                        task.wait(.1)
                        local owner = soundPart:FindFirstChild("PartOwner")
                        if owner and owner.Value == lp.Name then
                            return pallet
                        else
                            setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                            task.wait(.1)
                            owner = soundPart:FindFirstChild("PartOwner")
                            if owner and owner.Value == lp.Name then
                                return pallet
                            else
                                task.wait(.1)
                            end
                        end
                    end
                end
                task.wait(.1)
            end
            return nil
        end
    end

    local function HidePallet(pallet)
        if not pallet then
            return false
        end
        local soundPart = pallet:FindFirstChild("SoundPart")
        if not soundPart then
            return false
        end
        for _, part in ipairs(pallet:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CanQuery = false
                part.Massless = true
            end
        end
        soundPart.CFrame = CFrame.new(0, 1000000000, 0)
        return true
    end


    PermanentPalletCfg.loopThread = task.spawn(function()
        while PermanentPalletCfg.enabled do
            local pallet = FindOwnPallet()
            if not pallet then
                pallet = SpawnPallet()
            end
            if pallet then
                PermanentPalletCfg.currentPallet = pallet
                PermanentPalletCfg.isReady = true
                HidePallet(pallet)
                local soundPart = pallet:FindFirstChild("SoundPart")
                if soundPart then
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwnerRemote:FireServer(setOwnerRemote, setOwnerRemote.CFrame)
                    end
                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                end
            else
                PermanentPalletCfg.isReady = false
                PermanentPalletCfg.currentPallet = nil
            end
            task.wait(0.5)
        end
        PermanentPalletCfg.currentPallet = nil
        PermanentPalletCfg.isReady = false
    end)
    print("[AMETHYST] âœ… Permanent Pallet Ð°ÐºÑ‚Ð¸Ð²Ð¸Ñ€Ð¾Ð²Ð°Ð½ Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑÐºÐ¸")
end)


local TargetTab = Window:AddTab({ Title = "Target", Icon = "users" })
local playersInPlotsFolder = nil
pcall(function()
    playersInPlotsFolder = S.Workspace:WaitForChild("PlotItems", 2) and S.Workspace.PlotItems:WaitForChild("PlayersInPlots", 2)
end)


local function IsPlayerInPlot(player)
    if not player or not playersInPlotsFolder then
        return false
    end
    return playersInPlotsFolder:FindFirstChild(player.Name) ~= nil
end


local targetData = {
    loopKick = {},
    ragdollLoopKick = {},
    loopBring = {}
}


local function ClearTargetGroup(groupName)
    if targetData[groupName] then
        for _, obj in pairs(targetData[groupName]) do
            if obj and typeof(obj) == "Instance" then
                pcall(function()
                    obj:Destroy()
                end)
            end
        end
        targetData[groupName] = {}
    end
end


local function TrackInstance(groupName, obj)
    if not targetData[groupName] then
        targetData[groupName] = {}
    end
    table.insert(targetData[groupName], obj)
    return obj
end


task.wait(0.5)
TargetTab:AddSection("Select Player")


local function PlayerLabel(player)
    local display = player.DisplayName
    local name = player.Name
    if display and display ~= "" and display ~= name then
        return display .. " (" .. name .. ")" .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    else
        return name .. (IsPlayerInPlot(player) and " [PLOT]" or "")
    end
end


local function GetPlayerList()
    local items = {}
    local mapping = {}
    for _, player in ipairs(S.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local label = PlayerLabel(player)
            table.insert(items, label)
            mapping[label] = player
        end
    end
    return items, mapping
end


local targetPlayerName = ""
local targetPlayer = nil


local targetDropdown
local function RefreshPlayerDropdown()
    local items, mapping = GetPlayerList()
    if targetDropdown then
        if typeof(targetDropdown.Refresh) == "function" then
            targetDropdown:Refresh(items, true)
        elseif typeof(targetDropdown.SetValues) == "function" then
            targetDropdown:SetValues(items)
        end
        if AmethystFeatures.Selected.currentPlayer and AmethystFeatures.Selected.currentPlayer.Parent then
            if targetDropdown and typeof(targetDropdown.SetValue) == "function" then
                targetDropdown:SetValue(PlayerLabel(AmethystFeatures.Selected.currentPlayer))
            end
        end
    end
end


task.spawn(function()
    while true do
        task.wait(0.5)
        RefreshPlayerDropdown()
    end
end)


targetDropdown = TargetTab:AddDropdown("TargetPlayerDropdown", {
    Title = "Select Target Player",
    Values = {},
    Default = "",
    Callback = function(selected)
        if selected == "" then
            AmethystFeatures.Selected.kickPlayer = nil
            AmethystFeatures.Selected.currentPlayer = nil
            return
        end
        local items, mapping = GetPlayerList()
        local player = mapping[selected]
        if player then
            AmethystFeatures.Selected.kickPlayer = player
            AmethystFeatures.Selected.currentPlayer = player
            GemoroiUI:Notify({ Title = "Target Selected", Content = "Target: " .. PlayerLabel(player), Duration = 2 })
            PlayEnableSound()
        end
    end
})
RefreshPlayerDropdown()


S.Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    RefreshPlayerDropdown()
end)
S.Players.PlayerRemoving:Connect(function(player)
    RefreshPlayerDropdown()
    if AmethystFeatures.Selected.currentPlayer == player then
        AmethystFeatures.Selected.kickPlayer = nil
        AmethystFeatures.Selected.currentPlayer = nil
    if targetDropdown and typeof(targetDropdown.SetValue) == "function" then
        targetDropdown:SetValue("")
    end
        GemoroiUI:Notify({ Title = "Target", Content = "Selected player left the game", Duration = 2 })
    end
end)


if playersInPlotsFolder then
    playersInPlotsFolder.ChildAdded:Connect(RefreshPlayerDropdown)

-- XOCU Integration Logic
local function getXOCURoot(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function applyXOCUForce(target, velocity, name)
    if not target or not target.Character then return end
    local root = getXOCURoot(target)
    if not root then return end
    pcall(function()
        local GrabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
        local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
        local DestroyGrabLine = GrabEvents:FindFirstChild("DestroyGrabLine")
        
        SetNetworkOwner:FireServer(root, root.CFrame)
        if DestroyGrabLine then DestroyGrabLine:FireServer(root) end
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = name or "XOCUForce"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = velocity
        bv.P = 12500
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.1)
    end)
end

local XOCUKickMethods = {
    ["Fling"] = function(target) applyXOCUForce(target, Vector3.new(0, 90000, 0), "XOCUFling") end,
    ["Kill"] = function(target) applyXOCUForce(target, Vector3.new(0, 99999999999999, 0), "XOCUKill") end,
    ["Heaven"] = function(target) 
        local root = getXOCURoot(target)
        if root then root.CFrame = CFrame.new(0, 200, 0) end
        applyXOCUForce(target, Vector3.new(0, 200, 0), "XOCUHeaven")
    end,
    ["Kick"] = function(target)
        local root = getXOCURoot(target)
        if root then root.CFrame = CFrame.new(0, 999999999999, 0) end
        applyXOCUForce(target, Vector3.new(0, 99999999999999, 0), "XOCUKick")
    end,
    ["Ragdoll"] = function(target) applyXOCUForce(target, Vector3.new(0, -20, 0), "XOCURagdoll") end,
    ["Hell"] = function(target)
        pcall(function()
            for _, part in ipairs(target.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
        applyXOCUForce(target, Vector3.new(0, -100000000, 0), "XOCUHell")
    end
}

    playersInPlotsFolder.ChildRemoved:Connect(RefreshPlayerDropdown)
end


local function IsTargetAlive(player)
    return IsPlayerInPlot(player)
end


TargetTab:AddDropdown("KickModeDropdown", {
    Title = "Kick Mode",
    Values = {"Fling", "Kill", "Heaven", "Kick", "Ragdoll", "Hell"},
    Default = "Kick",
    Callback = function(value)
        AmethystFeatures.XOCU.KickMode = value
    end
})

TargetTab:AddButton({
    Title = "Execute Kick",
    Callback = function()
        local target = AmethystFeatures.Selected.kickPlayer
        if target then
            XOCUKickMethods[AmethystFeatures.XOCU.KickMode](target)
            Notify("Kick", "Applied " .. AmethystFeatures.XOCU.KickMode .. " to " .. target.Name)
        else
            Notify("Error", "No target selected!")
        end
    end
})

TargetTab:AddToggle("AntiLagToggle", {
    Title = "XOCU Anti Lag",
    Default = false,
    Callback = function(state)
        AmethystFeatures.XOCU.AntiLag = state
        if state then
            AmethystFeatures.XOCU.LoopThread = task.spawn(function()
                while AmethystFeatures.XOCU.AntiLag do
                    for _, v in ipairs(Workspace:GetChildren()) do
                        if v.Name == "GrabParts" and not v:FindFirstChildOfClass("Humanoid") then
                            v:Destroy()
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if AmethystFeatures.XOCU.LoopThread then
                task.cancel(AmethystFeatures.XOCU.LoopThread)
            end
        end
    end
})


TargetTab:AddSection("Grabs func")

TargetTab:AddToggle("FastKickToggle", {
    Title = "Fast kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                GemoroiUI:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            ClearTargetGroup("ragdollLoopKick")
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    GemoroiUI:Notify({ Title = "Error", Content = "SoundPart not found!", Duration = 3 })
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                local destroyGrabLine = grabEvents:WaitForChild("DestroyGrabLine")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                local isHeld = false
                local heldSince = 0
                local soundPart = pallet.SoundPart
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetRoot or not targetHum or not IsTargetAlive(target) then
                            ClearTargetGroup("ragdollLoopKick")
                            isHeld = false
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.1)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                task.wait()
                                createGrabLine:FireServer(targetRoot)
                                destroyGrabLine:FireServer(targetRoot, Vector3.zero, targetRoot.Position, false)
                                targetHum.PlatformStand = true
                                targetHum.Sit = true
                                if not isHeld then
                                    heldSince = tick()
                                end
                                if tick() - heldSince > .4 then
                                    if targetHum.PlatformStand then
                                        isHeld = true
                                        myRoot.CFrame = myRoot.CFrame
                                        myRoot.Velocity = Vector3.zero
                                        attachHold = TrackInstance("ragdollLoopKick", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "RagdollLoopKickAttHold"
                                        attachTarget = TrackInstance("ragdollLoopKick", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "RagdollLoopKickAttTarget"
                                        alignPos = TrackInstance("ragdollLoopKick", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = math.huge
                                        alignPos.Name = "RagdollLoopKickAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("ragdollLoopKick", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = math.huge
                                        alignOri.Name = "RagdollLoopKickAlignOri"
                                        alignOri.Parent = targetRoot
                                        targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                                    else
                                        heldSince = tick()
                                    end
                                end
                                task.wait()
                            end
                            if targetChar and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if attachHold then
                                    attachHold.Position = Vector3.new()
                                    attachTarget.CFrame = CFrame.new(0, 14.5, 0) * CFrame.Angles(math.rad((0 + 0 * .016) % 360), 0, 0)
                                end
                                if tick() - (isHeld and heldSince or 0) >= 0 then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                isHeld = false
            end)
            GemoroiUI:Notify({ Title = "Ragdoll Loop Kick", Content = "Enabled - Target: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            GemoroiUI:Notify({ Title = "Ragdoll Loop Kick", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("ControlKickToggle", {
    Title = "control kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                GemoroiUI:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("ragdollLoopKick")
            RagdollLoopKickCfg.enabled = true
            RagdollLoopKickCfg.dragging = false
            RagdollLoopKickCfg.savedPos = nil
            RagdollLoopKickCfg.grabStart = 0
            RagdollLoopKickCfg.loopThread = task.spawn(function()
                if not (pallet and pallet:FindFirstChild("SoundPart")) then
                    RagdollLoopKickCfg.enabled = false
                    GemoroiUI:Notify({ Title = "Error", Content = "SoundPart not found!", Duration = 3 })
                    return
                end
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                grabEvents:WaitForChild("CreateGrabLine")
                grabEvents:WaitForChild("DestroyGrabLine")
                local angleCache = {}
                local function getAngle(deg)
                    if not angleCache[deg] then
                        angleCache[deg] = CFrame.Angles(math.rad(deg), 0, 0)
                    end
                    return angleCache[deg]
                end
                while RagdollLoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        if not targetChar or not targetRoot or not targetHum or targetHum.Health <= 0 then
                            task.wait()
                        else
                            local soundPart = pallet:FindFirstChild("SoundPart")
                            if soundPart then
                                soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                if not soundPart:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(soundPart, soundPart.CFrame)
                                end
                                task.wait()
                                soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("ragdollLoopKick")
                return
            end)
            GemoroiUI:Notify({ Title = "Ragdoll Loop Kick", Content = "Enabled - Target: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            RagdollLoopKickCfg.enabled = false
            if RagdollLoopKickCfg.loopThread then
                task.cancel(RagdollLoopKickCfg.loopThread)
                RagdollLoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("ragdollLoopKick")
            GemoroiUI:Notify({ Title = "Ragdoll Loop Kick", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("LoopBringToggle", {
    Title = "loop bring",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                GemoroiUI:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            local pallet = PermanentPalletCfg.currentPallet
            ClearTargetGroup("loopBring")
            LoopKickCfg.enabled = true
            LoopKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local soundPart = pallet:FindFirstChild("SoundPart")
                local attachHold, attachTarget, alignPos, alignOri = nil, nil, nil, nil
                while LoopKickCfg.enabled do
                    local lpChar = LocalPlayer.Character
                    local myRoot = lpChar and lpChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        task.wait()
                    else
                        local targetChar = target.Character
                        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if not targetChar or not targetHum or targetHum.Health <= 0 or not targetRoot then
                            ClearTargetGroup("loopBring")
                            task.wait()
                        else
                            if IsTargetAlive(target) then
                                task.wait(.4)
                            else
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -6, -10)
                                myRoot.Velocity = Vector3.zero
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                targetRoot.Velocity = Vector3.zero
                                targetRoot.AssemblyLinearVelocity = Vector3.zero
                                targetRoot.AssemblyAngularVelocity = Vector3.zero
                                targetRoot.RotVelocity = Vector3.zero
                                local holdSince = tick()
                                if tick() - holdSince > .35 then
                                    if targetRoot.Velocity.Magnitude < 5 then
                                        attachHold = TrackInstance("loopBring", Instance.new("Attachment", myRoot))
                                        attachHold.Name = "LoopBringAttHold"
                                        attachTarget = TrackInstance("loopBring", Instance.new("Attachment", targetRoot))
                                        attachTarget.Name = "LoopBringAttTarget"
                                        alignPos = TrackInstance("loopBring", Instance.new("AlignPosition"))
                                        alignPos.Attachment0 = attachTarget
                                        alignPos.Attachment1 = attachHold
                                        alignPos.MaxForce = math.huge
                                        alignPos.Responsiveness = 1000
                                        alignPos.Name = "LoopBringAlignPos"
                                        alignPos.Parent = targetRoot
                                        alignOri = TrackInstance("loopBring", Instance.new("AlignOrientation"))
                                        alignOri.Attachment0 = attachTarget
                                        alignOri.Attachment1 = attachHold
                                        alignOri.MaxTorque = math.huge
                                        alignOri.Responsiveness = 1000
                                        alignOri.Name = "LoopBringAlignOri"
                                        alignOri.Parent = targetRoot
                                        if soundPart then
                                            soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                            if not soundPart:FindFirstChild("PartOwner") then
                                                setOwner:FireServer(soundPart, soundPart.CFrame)
                                            end
                                            task.wait()
                                            soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                        end
                                        for _, part in pairs(targetRoot:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                part.CustomPhysicalProperties = PhysicalProperties.new(.2, 0, 10)
                                            end
                                        end
                                    end
                                end
                            end
                            if attachHold and targetRoot then
                                setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                if not targetRoot:FindFirstChild("PartOwner") then
                                    setOwner:FireServer(targetRoot, targetRoot.CFrame)
                                end
                                if soundPart then
                                    soundPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                                    if not soundPart:FindFirstChild("PartOwner") then
                                        setOwner:FireServer(soundPart, soundPart.CFrame)
                                    end
                                    task.wait()
                                    soundPart.CFrame = CFrame.new(0, 1000000000, 0)
                                end
                            end
                        end
                    end
                    task.wait()
                end
                ClearTargetGroup("loopBring")
            end)
            GemoroiUI:Notify({ Title = "Loop Kick (Hold + Pallet)", Content = "Holding: " .. target.Name, Duration = 3 })
            PlayEnableSound()
        else
            LoopKickCfg.enabled = false
            if LoopKickCfg.loopThread then
                task.cancel(LoopKickCfg.loopThread)
                LoopKickCfg.loopThread = nil
            end
            ClearTargetGroup("loopBring")
            GemoroiUI:Notify({ Title = "Loop Kick (Hold + Pallet)", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddSection("Figure Poses (Grab)")

TargetTab:AddButton({
    Title = "Dog Pose Quick V1",
    Callback = function() applyCorePose("DogPoseQuickV1") end
})

TargetTab:AddButton({
    Title = "Dog Pose Quick V2",
    Callback = function() applyCorePose("DogPoseQuickV2") end
})

TargetTab:AddButton({
    Title = "Bang (Slow)",
    Callback = function() applyCorePose("BangSlow") end
})

TargetTab:AddButton({
    Title = "Coconut Boobs & Ass",
    Callback = function() attachCoreCoconuts("BoobsAss") end
})

TargetTab:AddButton({
    Title = "Coconut Penis",
    Callback = function() attachCoreCoconuts("Penis") end
})

TargetTab:AddButton({
    Title = "Reset Pose",
    Callback = function() resetCorePose() end
})

TargetTab:AddSection("Target Limb Controls")

TargetTab:AddButton({ Title = "Freeze Limbs", Callback = function() freezeLimbs() end })
TargetTab:AddButton({ Title = "Unfreeze Limbs", Callback = function() unfreezeLimbs() end })
TargetTab:AddButton({ Title = "Remove Arms", Callback = function() removeLimbs("Arms") end })
TargetTab:AddButton({ Title = "Remove Legs", Callback = function() removeLimbs("Legs") end })

TargetTab:AddToggle("MirrorAnimationsToggle", {
    Title = "Mirror My Animations",
    Default = false,
    Callback = function(Value)
        setMirrorAnimations(Value)
    end
})

TargetTab:AddToggle("FaceTowardMeToggle", {
    Title = "Face Toward Me",
    Default = false,
    Callback = function(Value)
        setFaceTowardMe(Value)
    end
})

TargetTab:AddToggle("LockTorsoRotationToggle", {
    Title = "Lock Torso Rotation",
    Default = false,
    Callback = function(Value)
        setLockTorso(Value)
    end
})

TargetTab:AddSection("removed")


TargetTab:AddToggle("RemoveAntiKickToggle", {
    Title = "Remove Anti Kick",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            RemoveAntiKickCfg.enabled = true
            RemoveAntiKickCfg.targetPlayer = AmethystFeatures.Selected.kickPlayer
            GemoroiUI:Notify({ Title = "Remove Anti Kick", Content = "Enabled - Target: " .. RemoveAntiKickCfg.targetPlayer.Name, Duration = 3 })
            PlayEnableSound()
            RemoveAntiKickCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                local setOwner = grabEvents:WaitForChild("SetNetworkOwner")
                local target = RemoveAntiKickCfg.targetPlayer
                local processed = {}


                local function Claim(soundPart)
                    if not soundPart then
                        return false
                    end
                    setOwner:FireServer(soundPart, soundPart.CFrame)
                    task.wait()
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if owner and owner.Value == LocalPlayer.Name then
                        soundPart.CFrame = CFrame.new(0, 1000, 0)
                        return true
                    end
                    return false
                end


                while RemoveAntiKickCfg.enabled and target and target.Parent do
                    local folder = S.Workspace:FindFirstChild(target.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in ipairs(folder:GetChildren()) do
                            for _, itemName in ipairs({ "NinjaKunai", "NinjaShuriken", "AntiKick" }) do
                                if toy.Name == itemName then
                                    local key = toy.Name .. "_" .. tostring(toy:GetDebugId())
                                    if not processed[key] then
                                        if Claim(toy) then
                                            processed[key] = true
                                        end
                                    end
                                end
                            end
                        end
                        for key in pairs(processed) do
                            if string.match(key, "_(%d+)$") then
                                local name = string.match(key, "^(.-)_")
                                local item = folder:FindFirstChild(name)
                                if not item or not item:IsDescendantOf(folder) then
                                    processed[key] = nil
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RemoveAntiKickCfg.enabled = false
                RemoveAntiKickCfg.targetPlayer = nil
            end)
        else
            RemoveAntiKickCfg.enabled = false
            RemoveAntiKickCfg.targetPlayer = nil
            if RemoveAntiKickCfg.loopThread then
                task.cancel(RemoveAntiKickCfg.loopThread)
                RemoveAntiKickCfg.loopThread = nil
            end
            GemoroiUI:Notify({ Title = "Remove Anti Kick", Content = "Disabled", Duration = 2 })
        end
    end
})

Window:SelectTab(1)
GemoroiUI:Notify({
    Title = "FTAP-Gemoroi",
    Content = "Fully Operational Core loaded successfully!",
    Duration = 5
})

TargetTab:AddSection("Blob Functions")

TargetTab:AddToggle("AutoSitBlobTargetToggle", {
    Title = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value and tick() - start < 3 do
                            task.wait()
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            GemoroiUI:Notify({ Title = "Auto Sit Blob", Content = "Enabled - Auto sitting on blob", Duration = 2 })
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            GemoroiUI:Notify({ Title = "Auto Sit Blob", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("BlobKillToggle", {
    Title = "Blob Kill",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select a target player first!", Duration = 3 })
                return
            end
            BlobKillCfg.enabled = true
            BlobKillCfg.selectedPlayers = { AmethystFeatures.Selected.kickPlayer }
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                while BlobKillCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait(0.5)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 or not humanoid.SeatPart then
                            task.wait(0.5)
                        else
                            local blob = humanoid.SeatPart:FindFirstAncestor("CreatureBlobman")
                            local target = BlobKillCfg.selectedPlayers[1]
                            if blob and target and target.Character then
                                local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                                if seatScript then
                                    local grab = seatScript:FindFirstChild("CreatureGrab")
                                    local release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop")
                                    local leftDet = blob:FindFirstChild("LeftDetector")
                                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                                    local rightDet = blob:FindFirstChild("RightDetector")
                                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                                    if grab and release then
                                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                                        if targetRoot then
                                            grab:FireServer(rightDet, targetRoot, rightWeld)
                                            task.wait(.1)
                                            if target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
                                                target.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                            end
                                            release:FireServer(rightWeld)
                                        end
                                    end
                                end
                            end
                            task.wait(1)
                        end
                    end
                end
                BlobKillCfg.currentBlob = nil
            end)
            GemoroiUI:Notify({ Title = "Blob Kill", Content = "Enabled - Target: " .. AmethystFeatures.Selected.kickPlayer.Name, Duration = 3 })
            PlayEnableSound()
        else
            BlobKillCfg.enabled = false
            if BlobKillCfg.loopThread then
                task.cancel(BlobKillCfg.loopThread)
                BlobKillCfg.loopThread = nil
            end
            BlobKillCfg.currentBlob = nil
            BlobKillCfg.selectedPlayers = {}
            GemoroiUI:Notify({ Title = "Blob Kill", Content = "Disabled", Duration = 2 })
        end
    end
})


TargetTab:AddToggle("BlobSimpleTeleportSpamToggle", {
    Title = "Blob - Simple Teleport Spam",
    Default = false,
    Callback = function(state)
        if state then
            if not AmethystFeatures.Selected.kickPlayer then
                GemoroiUI:Notify({ Title = "Error", Content = "Select target!", Duration = 2 })
                return
            end
            local target = AmethystFeatures.Selected.kickPlayer
            TargetTab.SimpleSpamData = {
                active = true
            }
            TargetTab.SimpleSpamData.thread = task.spawn(function()
                while TargetTab.SimpleSpamData and TargetTab.SimpleSpamData.active do
                    if not LocalPlayer.Character then
                        task.wait(.1)
                    else
                        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local targetChar = target and target.Character
                        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                        if root and targetRoot then
                            root.CFrame = targetRoot.CFrame
                            task.wait(.05)
                        end
                    end
                end
            end)
            GemoroiUI:Notify({ Title = "Simple Teleport Spam", Content = "Enabled", Duration = 2 })
        else
            if TargetTab.SimpleSpamData then
                TargetTab.SimpleSpamData.active = false
                if TargetTab.SimpleSpamData.thread then
                    task.cancel(TargetTab.SimpleSpamData.thread)
                end
                TargetTab.SimpleSpamData = nil
            end
            GemoroiUI:Notify({ Title = "Simple Teleport Spam", Content = "Disabled", Duration = 2 })
        end
    end
})


-- local AurasTab = Window:AddTab({ Title = "Auras", Icon = "" })
local AurasTab = Tabs.Auras
AurasTab:AddSection("Ragdoll auras")


AurasTab:AddToggle("RagdollAuraToggle", {
    Title = "Ragdoll Aura",
    Default = false,
    Callback = function(state)
        if state then
            if not PermanentPalletCfg.enabled then
                GemoroiUI:Notify({ Title = "Error", Content = "Enable Permanent Pallet first!", Duration = 3 })
                return
            end
            local pallet = PermanentPalletCfg.currentPallet
            if not pallet or not pallet.Parent then
                GemoroiUI:Notify({ Title = "Error", Content = "Permanent Pallet not found!", Duration = 3 })
                return
            end
            local soundPart = pallet:FindFirstChild("SoundPart")
            if not soundPart then
                GemoroiUI:Notify({ Title = "Error", Content = "Pallet has no SoundPart!", Duration = 3 })
                return
            end
            local owner = soundPart:FindFirstChild("PartOwner")
            if not owner or owner.Value ~= LocalPlayer.Name then
                GemoroiUI:Notify({ Title = "Error", Content = "No ownership on pallet!", Duration = 3 })
                return
            end
            RagdollAuraCfg.enabled = true
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            RagdollAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local char = lp.Character
                if not char then
                    return
                end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if not myRoot then
                    return
                end
                local setOwner = S.ReplicatedStorage.GrabEvents.SetNetworkOwner
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote


                local function EnsureOwnership(soundPart)
                    if not soundPart then
                        return false
                    end
                    if not soundPart.Parent then
                        return false
                    end
                    local owner = soundPart:FindFirstChild("PartOwner")
                    if not owner or owner.Value ~= lp.Name then
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    return true
                end


                local function RagdollTarget(player)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root then
                        return false
                    end
                    if (root.Position - myRoot.Position).Magnitude > 30 then
                        RagdollAuraCfg.ragdolledPlayers[player] = nil
                        return false
                    end
                    if soundPart and soundPart.CFrame then
                        setOwner:FireServer(root, root.CFrame)
                        soundPart.CFrame = root.CFrame * CFrame.new(0, 0, 0.5)
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                        task.wait()
                        soundPart.CFrame = CFrame.new(0, 10000, 0)
                        task.wait()
                        setOwner:FireServer(soundPart, soundPart.CFrame)
                    end
                    RagdollAuraCfg.ragdolledPlayers[player] = os.clock()
                    return true
                end


                while RagdollAuraCfg.enabled do
                    local pChar = lp.Character
                    if pChar then
                        myRoot = pChar:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            if not PermanentPalletCfg.enabled or not PermanentPalletCfg.currentPallet then
                                print("[Ragdoll Aura] Permanent Pallet Ð¾Ñ‚ÐºÐ»ÑŽÑ‡Ð¸Ð»Ð°ÑÑŒ")
                            else
                                if not EnsureOwnership(soundPart) then
                                    print("[Ragdoll Aura] ÐÐµ ÑƒÐ´Ð°Ð»Ð¾ÑÑŒ ÑƒÑÑ‚Ð°Ð½Ð¾Ð²Ð¸Ñ‚ÑŒ ownership Ð½Ð° Ð¿Ð°Ð»Ð»ÐµÑ‚")
                                else
                                    for player, lastTime in pairs(RagdollAuraCfg.ragdolledPlayers) do
                                        if os.clock() - lastTime > 1 then
                                            RagdollAuraCfg.ragdolledPlayers[player] = nil
                                        end
                                    end
                                    local near = {}
                                    for _, player in pairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            if root and (root.Position - myRoot.Position).Magnitude <= 30 then
                                                table.insert(near, player)
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if RagdollAuraCfg.enabled then
                                            RagdollTarget(player)
                                            if i % 3 == 0 then
                                                task.wait()
                                            end
                                        end
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                    task.wait()
                end
                RagdollAuraCfg.ragdolledPlayers = {}
            end)
            task.spawn(function()
                while RagdollAuraCfg.enabled do
                    if RagdollAuraCfg.enabled and not PermanentPalletCfg.enabled then
                        print("[Ragdoll Aura] Permanent Pallet Ð¾Ñ‚ÐºÐ»ÑŽÑ‡Ð¸Ð»Ð°ÑÑŒ, Ð¾Ñ‚ÐºÐ»ÑŽÑ‡Ð°ÐµÐ¼...")
                        if RagdollAuraCfg.loopThread then
                            task.cancel(RagdollAuraCfg.loopThread)
                            RagdollAuraCfg.loopThread = nil
                        end
                        RagdollAuraCfg.enabled = false
                        RagdollAuraCfg.ragdolledPlayers = {}
                        RagdollAuraCfg.isTeleportingPallet = false
                        break
                    else
                        task.wait(1)
                    end
                end
            end)
            GemoroiUI:Notify({ Title = "Ragdoll Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            RagdollAuraCfg.enabled = false
            if RagdollAuraCfg.loopThread then
                task.cancel(RagdollAuraCfg.loopThread)
                RagdollAuraCfg.loopThread = nil
            end
            RagdollAuraCfg.ragdolledPlayers = {}
            RagdollAuraCfg.isTeleportingPallet = false
            GemoroiUI:Notify({ Title = "Ragdoll Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddSection("Blob Auras")


AurasTab:AddToggle("AutoSitBlobAuraToggle", {
    Title = "Auto Sit Blob",
    Default = false,
    Callback = function(state)
        if state then
            AutoSitCfg.enabled = true
            AutoSitCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local spawnToy = S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("SpawnToyRemoteFunction")
                S.ReplicatedStorage:WaitForChild("MenuToys"):WaitForChild("DestroyToy")
                local function FindBlob()
                    local folder = S.Workspace:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function SpawnBlob()
                    local canSpawn = lp:FindFirstChild("CanSpawnToy")
                    if canSpawn then
                        local start = tick()
                        while canSpawn.Value and tick() - start < 3 do
                            task.wait()
                            if not lp:FindFirstChild("CanSpawnToy").Value then
                                return nil
                            end
                        end
                        local char = lp.Character
                        if not char then
                            return nil
                        end
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if not root then
                            return nil
                        end
                        spawnToy:InvokeServer("CreatureBlobman", root.CFrame * CFrame.new(0, 0, 5), Vector3.new(0, 0, 0))
                        task.wait(0.3)
                        for _ = 1, 10 do
                            local blob = FindBlob()
                            if blob then
                                return blob
                            end
                            task.wait()
                        end
                        return nil
                    end
                end
                local function SitOnBlob(blob)
                    if not blob then
                        return false
                    end
                    local char = lp.Character
                    if not char then
                        return false
                    end
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not humanoid then
                        return false
                    end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then
                        return false
                    end
                    local seat = blob:FindFirstChild("VehicleSeat")
                    if not seat then
                        return false
                    end
                    if humanoid.SeatPart == seat then
                        return true
                    end
                    root.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
                    task.wait()
                    seat:Sit(humanoid)
                    task.wait()
                    return humanoid.SeatPart == seat
                end
                while AutoSitCfg.enabled do
                    if not lp.Character then
                        task.wait()
                    end
                    local blob = AutoSitCfg.currentBlob
                    if not blob or not blob.Parent then
                        blob = FindBlob()
                        if not blob then
                            blob = SpawnBlob()
                        end
                        if blob then
                            AutoSitCfg.currentBlob = blob
                            SitOnBlob(blob)
                        end
                    end
                    task.wait()
                end
                AutoSitCfg.currentBlob = nil
            end)
            GemoroiUI:Notify({ Title = "Auto Sit Blob", Content = "Enabled - Auto sitting on blob", Duration = 2 })
            PlayEnableSound()
        else
            AutoSitCfg.enabled = false
            if AutoSitCfg.loopThread then
                task.cancel(AutoSitCfg.loopThread)
                AutoSitCfg.loopThread = nil
            end
            AutoSitCfg.currentBlob = nil
            GemoroiUI:Notify({ Title = "Auto Sit Blob", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("KillAuraBlobToggle", {
    Title = "Kill Aura (Blob)",
    Default = false,
    Callback = function(state)
        if state then
            KillAuraCfg.enabled = true
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            KillAuraCfg.loopThread = task.spawn(function()
                local lp = LocalPlayer
                local ws = S.Workspace
                local function FindBlob()
                    local folder = ws:FindFirstChild(lp.Name .. "SpawnedInToys")
                    if folder then
                        for _, toy in pairs(folder:GetChildren()) do
                            if toy.Name == "CreatureBlobman" then
                                return toy
                            end
                        end
                    end
                    return nil
                end
                local function GetBlobRemotes(blob)
                    if not blob then
                        return nil
                    end
                    local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                    if not seatScript then
                        return nil
                    end
                    local leftDet = blob:FindFirstChild("LeftDetector")
                    local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                    local rightDet = blob:FindFirstChild("RightDetector")
                    local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                    return {
                        grab = seatScript:FindFirstChild("CreatureGrab"),
                        release = seatScript:FindFirstChild("CreatureRelease") or seatScript:FindFirstChild("CreatureDrop"),
                        leftDet = leftDet,
                        leftWeld = leftWeld,
                        rightDet = rightDet,
                        rightWeld = rightWeld
                    }
                end
                local function TryKill(player, blob, useLeft)
                    if not player or player == lp then
                        return false
                    end
                    local pChar = player.Character
                    if not pChar then
                        return false
                    end
                    local root = pChar:FindFirstChild("HumanoidRootPart")
                    local humanoid = pChar:FindFirstChild("Humanoid")
                    if not root or not humanoid or humanoid.Health <= 0 then
                        return false
                    end
                    local myChar = lp.Character
                    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myRoot then
                        return false
                    end
                    if (myRoot.Position - root.Position).Magnitude > 30 then
                        return false
                    end
                    local now = tick()
                    if KillAuraCfg.killCooldown[player] and now - KillAuraCfg.killCooldown[player] < 1 then
                        return false
                    end
                    local remotes = GetBlobRemotes(blob)
                    if not remotes or not remotes.grab or not remotes.release then
                        return false
                    end
                    local det = useLeft and remotes.leftDet or remotes.rightDet
                    local weld = useLeft and remotes.leftWeld or remotes.rightWeld
                    if not det or not weld then
                        return false
                    end
                    pcall(function()
                        if remotes.grab and remotes.grab.FireServer then
                            remotes.grab:FireServer(det, root, weld)
                        end
                        task.wait(.0001)
                        if remotes.release and remotes.release.FireServer then
                            remotes.release:FireServer(weld)
                        end
                    end)
                    task.wait(.0002)
                    pcall(function()
                        if humanoid and humanoid.Health > 0 then
                            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                        end
                    end)
                    KillAuraCfg.killCooldown[player] = now
                    KillAuraCfg.lastKillTime = now
                    return true
                end
                while KillAuraCfg.enabled do
                    local char = lp.Character
                    if not char then
                        task.wait()
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(0)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(ws) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    KillAuraCfg.currentBlob = blob
                                    local near = {}
                                    for _, player in ipairs(S.Players:GetPlayers()) do
                                        if player ~= lp and player.Character then
                                            local root = player.Character:FindFirstChild("HumanoidRootPart")
                                            local human = player.Character:FindFirstChild("Humanoid")
                                            if root and human and human.Health > 0 then
                                                local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
                                                if myRoot and (myRoot.Position - root.Position).Magnitude <= 30 then
                                                    table.insert(near, player)
                                                end
                                            end
                                        end
                                    end
                                    for i, player in ipairs(near) do
                                        if KillAuraCfg.enabled then
                                            if TryKill(player, blob, true) then
                                                if (i + 1) % 3 == 0 then
                                                    task.wait()
                                                end
                                            end
                                        end
                                    end
                                    KillAuraCfg.targetPlayers = near
                                    for player, cooldown in pairs(KillAuraCfg.killCooldown) do
                                        if tick() - cooldown > 1e-05 then
                                            KillAuraCfg.killCooldown[player] = nil
                                        end
                                    end
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                KillAuraCfg.currentBlob = nil
                KillAuraCfg.spawningBlob = false
                KillAuraCfg.killCooldown = {}
                KillAuraCfg.targetPlayers = {}
                KillAuraCfg.lastKillTime = 0
                print("[Kill Aura] Ð¦Ð¸ÐºÐ» Ð¾ÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½")
            end)
            GemoroiUI:Notify({ Title = "Kill Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            KillAuraCfg.enabled = false
            if KillAuraCfg.loopThread then
                task.cancel(KillAuraCfg.loopThread)
                KillAuraCfg.loopThread = nil
            end
            KillAuraCfg.currentBlob = nil
            KillAuraCfg.spawningBlob = false
            KillAuraCfg.killCooldown = {}
            KillAuraCfg.targetPlayers = {}
            KillAuraCfg.lastKillTime = 0
            GemoroiUI:Notify({ Title = "Kill Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("DualLockAuraToggle", {
    Title = "Dual Lock Aura",
    Default = false,
    Callback = function(state)
        if state then
            AdvancedDuallockCfg.enabled = true
            AdvancedDuallockCfg.processedPlayers = {}
            AdvancedDuallockCfg.originalBarrierState = {}
            local function DisableBarriers()
                local plots = S.Workspace:FindFirstChild("Plots")
                if plots then
                    for _, plot in ipairs(plots:GetChildren()) do
                        local barrier = plot:FindFirstChild("Barrier")
                        if barrier then
                            for _, part in ipairs(barrier:GetChildren()) do
                                if part:IsA("BasePart") and part.Name == "PlotBarrier" then
                                    AdvancedDuallockCfg.originalBarrierState[part] = part.CanCollide
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end
            AdvancedDuallockCfg.loopThread = task.spawn(function()
                while AdvancedDuallockCfg.enabled do
                    DisableBarriers()
                    task.wait()
                end
            end)
            GemoroiUI:Notify({ Title = "Dual Lock Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            AdvancedDuallockCfg.enabled = false
            if AdvancedDuallockCfg.loopThread then
                task.cancel(AdvancedDuallockCfg.loopThread)
                AdvancedDuallockCfg.loopThread = nil
            end
            for part, state in pairs(AdvancedDuallockCfg.originalBarrierState) do
                if part and part:IsA("BasePart") then
                    part.CanCollide = state
                end
            end
            AdvancedDuallockCfg.originalBarrierState = {}
            AdvancedDuallockCfg.currentBlob = nil
            AdvancedDuallockCfg.processedPlayers = {}
            GemoroiUI:Notify({ Title = "Dual Lock Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("DestroyKickAuraToggle", {
    Title = "Destroy Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            DestroyKickAuraCfg.enabled = true
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            DestroyKickAuraCfg.lastSpawnTime = 0
            DestroyKickAuraCfg.spawnInterval = 0
            local function BlobOfSeat(humanoid)
                local seat = humanoid.SeatPart
                if seat then
                    return seat:FindFirstAncestor("CreatureBlobman")
                end
                return nil
            end
            local function IsAlive(player)
                if not player or not player.Character then
                    return false
                end
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                    return false
                end
                return humanoid.Health > 0
            end
            local function CleanupProcessed()
                for player in pairs(DestroyKickAuraCfg.processedPlayers) do
                    if not player:IsDescendantOf(S.Players) or not player.Character or not IsAlive(player) then
                        DestroyKickAuraCfg.processedPlayers[player] = nil
                    end
                end
            end
            local function GetNearbyPlayers(range)
                local char = LocalPlayer.Character
                if not char then
                    return {}
                end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then
                    return {}
                end
                local pos = root.Position
                CleanupProcessed()
                local near = {}
                for _, player in ipairs(S.Players:GetPlayers()) do
                    if player ~= LocalPlayer and IsAlive(player) then
                        local pChar = player.Character
                        if pChar then
                            local pRoot = pChar:FindFirstChild("HumanoidRootPart")
                            if pRoot and (pRoot.Position - pos).Magnitude <= range then
                                table.insert(near, player)
                            end
                        end
                    end
                end
                return near
            end
            local function KickPlayer(player)
                local lpChar = LocalPlayer.Character
                if not lpChar then
                    return
                end
                local head = lpChar:WaitForChild("Head", 2)
                local lpRoot = lpChar:WaitForChild("HumanoidRootPart", 2)
                if not head or not lpRoot then
                    return
                end
                local pChar = player.Character
                if not pChar then
                    return
                end
                local pRoot = pChar:WaitForChild("HumanoidRootPart", 2)
                if not pRoot then
                    return
                end
                local grabEvents = S.ReplicatedStorage:FindFirstChild("GrabEvents")
                local createGrabLine = grabEvents and grabEvents:FindFirstChild("CreateGrabLine")
                if createGrabLine then
                    createGrabLine:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.SetNetworkOwner:FireServer(pRoot, pRoot.CFrame)
                    task.wait(.1)
                    pRoot.CFrame = head.CFrame * CFrame.new(0, 12, 0)
                    task.wait(.1)
                    S.ReplicatedStorage.GrabEvents.DestroyGrabLine:FireServer(pRoot)
                    task.wait()
                    S.ReplicatedStorage.GrabEvents.EndGrabEarly:FireServer(pRoot)
                    task.wait()
                end
                local lpHumanoid = lpChar:FindFirstChild("Humanoid")
                if lpHumanoid then
                    local blob = BlobOfSeat(lpHumanoid)
                    if blob then
                        local seatScript = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                        local rightDet = blob:FindFirstChild("RightDetector")
                        local leftDet = blob:FindFirstChild("LeftDetector")
                        if seatScript then
                            local rightWeld = rightDet and rightDet:FindFirstChild("RightWeld")
                            local leftWeld = leftDet and leftDet:FindFirstChild("LeftWeld")
                            local grabRemote = seatScript:FindFirstChild("CreatureGrab")
                            if grabRemote then
                                if rightWeld then
                                    grabRemote:FireServer(rightDet, pChar:WaitForChild("HumanoidRootPart", 2), rightWeld)
                                    task.wait(.1)
                                end
                                if leftWeld then
                                    grabRemote:FireServer(leftDet, pChar:WaitForChild("HumanoidRootPart", 2), leftWeld)
                                    task.wait(.1)
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.processedPlayers[player] = true
            end
            DestroyKickAuraCfg.loopThread = task.spawn(function()
                while DestroyKickAuraCfg.enabled do
                    local char = LocalPlayer.Character
                    if not char then
                        task.wait(.1)
                    else
                        local humanoid = char:FindFirstChild("Humanoid")
                        if not humanoid or humanoid.Health <= 0 then
                            task.wait(.1)
                        else
                            local seatPart = humanoid.SeatPart
                            if not seatPart or not seatPart:IsDescendantOf(S.Workspace) then
                                task.wait(0.5)
                            else
                                local blob = seatPart:FindFirstAncestor("CreatureBlobman")
                                if not blob or not blob.Parent then
                                    task.wait(0.5)
                                else
                                    DestroyKickAuraCfg.currentBlob = blob
                                    local near = GetNearbyPlayers(30)
                                    for _, player in ipairs(near) do
                                        if DestroyKickAuraCfg.enabled then
                                            KickPlayer(player)
                                            if #GetNearbyPlayers(30) > 1 then
                                                task.wait(.1)
                                            end
                                        end
                                    end
                                    CleanupProcessed()
                                    if #near == 0 then
                                        task.wait(.1)
                                    else
                                        task.wait()
                                    end
                                end
                            end
                        end
                    end
                end
                DestroyKickAuraCfg.currentBlob = nil
                DestroyKickAuraCfg.processedPlayers = {}
                DestroyKickAuraCfg.isSpawning = false
                print("[Destroy Kick Aura] Ð¦Ð¸ÐºÐ» Ð¾ÑÑ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½")
            end)
            GemoroiUI:Notify({ Title = "Destroy Kick Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            DestroyKickAuraCfg.enabled = false
            if DestroyKickAuraCfg.loopThread then
                task.cancel(DestroyKickAuraCfg.loopThread)
                DestroyKickAuraCfg.loopThread = nil
            end
            DestroyKickAuraCfg.currentBlob = nil
            DestroyKickAuraCfg.processedPlayers = {}
            DestroyKickAuraCfg.isSpawning = false
            GemoroiUI:Notify({ Title = "Destroy Kick Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddSection("Kick Auras")


AurasTab:AddToggle("KickAuraFixedToggle", {
    Title = "Kick Aura (Fixed)",
    Default = false,
    Callback = function(state)
        if state then
            KickAuraFixedCfg.enabled = true
            KickAuraFixedCfg.fixedPlayers = {}
            KickAuraFixedCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                local ragdollRemote = S.ReplicatedStorage.CharacterEvents.RagdollRemote
                local offsets = {
                    Vector3.new(-4, 15, -4),
                    Vector3.new(4, 15, -4),
                    Vector3.new(-4, 15, 4),
                    Vector3.new(4, 15, 4)
                }
                while KickAuraFixedCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            GemoroiUI:Notify({ Title = "Kick Aura (Fixed)", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            KickAuraFixedCfg.enabled = false
            if KickAuraFixedCfg.loopThread then
                task.cancel(KickAuraFixedCfg.loopThread)
                KickAuraFixedCfg.loopThread = nil
            end
            for _, data in pairs(KickAuraFixedCfg.fixedPlayers) do
                if data.alignPos and data.alignPos.Parent then
                    data.alignPos:Destroy()
                end
                if data.alignOri and data.alignOri.Parent then
                    data.alignOri:Destroy()
                end
            end
            KickAuraFixedCfg.fixedPlayers = {}
            GemoroiUI:Notify({ Title = "Kick Aura (Fixed)", Content = "Disabled", Duration = 2 })
        end
    end
})


AurasTab:AddToggle("JumpKickAuraToggle", {
    Title = "Jump Kick Aura",
    Default = false,
    Callback = function(state)
        if state then
            JumpKickAuraCfg.enabled = true
            JumpKickAuraCfg.processedPlayers = {}
            JumpKickAuraCfg.loopThread = task.spawn(function()
                local grabEvents = S.ReplicatedStorage.GrabEvents
                local setOwner = grabEvents.SetNetworkOwner
                local destroyGrabLine = grabEvents.DestroyGrabLine
                while JumpKickAuraCfg.enabled do
                    if not LocalPlayer.Character then
                        break
                    end
                    task.wait()
                end
            end)
            GemoroiUI:Notify({ Title = "Jump Kick Aura", Content = "Enabled", Duration = 3 })
            PlayEnableSound()
        else
            JumpKickAuraCfg.enabled = false
            if JumpKickAuraCfg.loopThread then
                task.cancel(JumpKickAuraCfg.loopThread)
                JumpKickAuraCfg.loopThread = nil
            end
            JumpKickAuraCfg.processedPlayers = {}
            GemoroiUI:Notify({ Title = "Jump Kick Aura", Content = "Disabled", Duration = 2 })
        end
    end
})


local ServerTab = Window:AddTab({ Title = "Server", Icon = "" })
ServerTab:AddSection("Server Lag")


local lagRiskLabel = nil
local packetSizeLabel = nil


local function UpdateLagLabels()
    if packetSizeLabel then
        packetSizeLabel.Text = "Size: " .. Features.PacketLag.packetSize
        if Features.PacketLag.packetSize > 600000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            if lagRiskLabel then
                lagRiskLabel.Text = "âš ï¸ HIGH LAG WARNING! âš ï¸"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        elseif Features.PacketLag.packetSize > 200000 then
            packetSizeLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            if lagRiskLabel then
                lagRiskLabel.Text = "âš ï¸ Medium lag risk âš ï¸"
                lagRiskLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
            end
        else
            packetSizeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            if lagRiskLabel then
                lagRiskLabel.Text = "Low lag risk"
                lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end
end


local function SpawnLagToy()
    local spawnToy = S.ReplicatedStorage:FindFirstChild("MenuToys") and S.ReplicatedStorage.MenuToys:FindFirstChild("SpawnToyRemoteFunction")
    if spawnToy then
        local pos = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.CFrame or CFrame.new(0, 100, 0)
        spawnToy:InvokeServer("CreatureBlobman", pos * CFrame.new(math.random(-50,50), 50, math.random(-50,50)), Vector3.new(0, 0, 0))
    end
end

local function StopPacketLag()
    if Features.PacketLag.loopThread then
        task.cancel(Features.PacketLag.loopThread)
        Features.PacketLag.loopThread = nil
    end
    Features.PacketLag.enabled = false
    if lagRiskLabel then
        lagRiskLabel.Text = "Stopped"
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    GemoroiUI:Notify({ Title = "Packet Lag", Content = "Disabled", Duration = 2 })
    task.delay(2, function()
        if lagRiskLabel then
            UpdateLagLabels()
        end
    end)
end


local function StartPacketLag()
    Features.PacketLag.enabled = true
    if lagRiskLabel then
        lagRiskLabel.Text = "STARTING..."
        lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
    end
    Features.PacketLag.loopThread = task.spawn(function()
        local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
        local extendRemote = grabEvents:WaitForChild("ExtendGrabLine")
        if not extendRemote then
            warn("[Packet Lag] ExtendGrabLine RemoteEvent not found!")
            StopPacketLag()
            return
        end
        if lagRiskLabel then
            lagRiskLabel.Text = "LAGGING SERVER..."
            lagRiskLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        end
        GemoroiUI:Notify({ Title = "Packet Lag", Content = "Enabled - Spawning lag objects", Duration = 3 })
        PlayEnableSound()
        while Features.PacketLag.enabled do
            SpawnLagToy()
            task.wait(0.05)
        end
    end)
end


local packetSizeSlider = ServerTab:AddSlider("PacketSizeSlider", {
    Title = "Packet Size",
    Min = 100,
    Max = 1000000,
    Default = 50000,
    Rounding = 0,
    Callback = function(value)
        Features.PacketLag.packetSize = value
        UpdateLagLabels()
    end
})

task.spawn(function()
    task.wait(0.5)
    pcall(function()
        lagRiskLabel = Instance.new("TextLabel")
        lagRiskLabel.Size = UDim2.new(1, -20, 0, 20)
        lagRiskLabel.Position = UDim2.new(0, 10, 0, 90)
        lagRiskLabel.BackgroundTransparency = 1
        lagRiskLabel.Text = "Low lag risk"
        lagRiskLabel.Font = Enum.Font.GothamBold
        lagRiskLabel.TextSize = 11
        lagRiskLabel.TextXAlignment = Enum.TextXAlignment.Center
        lagRiskLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
end)


ServerTab:AddToggle("PacketLagToggle", {
    Title = "Packet Lag",
    Default = false,
    Callback = function(state)
        if state then
            StartPacketLag()
        else
            StopPacketLag()
        end
    end
})


ServerTab:AddSection("Line Lag")


ServerTab:AddToggle("LineLagServerLagToggle", {
    Title = "Line Lag (Server Lag)",
    Default = false,
    Callback = function(state)
        if state then
            ServerLagCfg.enabled = true
            task.spawn(function()
                if ServerLagCfg.enabled then
                    local grabEvents = S.ReplicatedStorage:WaitForChild("GrabEvents")
                    local createGrabLine = grabEvents:WaitForChild("CreateGrabLine")
                    if not createGrabLine then
                        warn("[Server Lag] CreateGrabLine RemoteEvent not found!")
                        ServerLagCfg.enabled = false
                        GemoroiUI:Notify({ Title = "Server Lag", Content = "Error: CreateGrabLine not found!", Duration = 3 })
                        return
                    end
                    print("[Server Lag] Started!")
                    ServerLagCfg.loopThread = task.spawn(function()
                        while ServerLagCfg.enabled do
                            local spawnLoc = S.Workspace:FindFirstChild("SpawnLocation")
                            if spawnLoc then
                                for y = 0, 50 do
                                    if not ServerLagCfg.enabled then
                                        break
                                    end
                                    createGrabLine:FireServer(CFrame.new(0, y, 0))
                                    task.wait(.005)
                                end
                            end
                            task.wait(.1)
                        end
                    end)
                    GemoroiUI:Notify({ Title = "Server Lag", Content = "Enabled - Lagging server with lines", Duration = 3 })
                    PlayEnableSound()
                end
            end)
        else
            ServerLagCfg.enabled = false
            if ServerLagCfg.loopThread then
                task.cancel(ServerLagCfg.loopThread)
                ServerLagCfg.loopThread = nil
            end
            GemoroiUI:Notify({ Title = "Server Lag", Content = "Disabled", Duration = 2 })
            print("[Server Lag] Stopped")
        end
    end
})

-- === SERVER TAB: SLOTS FARM ===
ServerTab:AddSection("Slots Farm")

ServerTab:AddToggle("AutoSpinSlotsToggle", {
    Title = "Auto Spin Slots",
    Description = "Auto-spins the slot machine when its timer hits 0:00",
    Default = false,
    Callback = function(Value)
        setAutoSpinSlots(Value)
    end
})

ServerTab:AddButton({
    Title = "Check Slot Time",
    Callback = function()
        checkSlotTime()
    end
})

ServerTab:AddButton({
    Title = "Teleport to Slots",
    Callback = function()
        teleportToSlots()
    end
})

-- === MASS TAB: TROLL & DESYNC ===
Tabs.Mass:AddSection("Troll & Desync")

Tabs.Mass:AddToggle("ChatSpamToggle", {
    Title = "Chat Troll Spammer",
    Default = false,
    Callback = function(Value)
        setChatSpam(Value)
    end
})

Tabs.Mass:AddSlider("ChatSpamDelaySlider", {
    Title = "Spam Delay",
    Default = 1,
    Min = 0.5,
    Max = 10,
    Rounding = 1,
    Suffix = "s",
    Callback = function(Value)
        Config.ChatSpamDelay = Value
    end
})

Tabs.Mass:AddToggle("ShurikenDesyncToggle", {
    Title = "NinjaShuriken Desync / Crash",
    Description = "Spams ownership-abused shurikens at the target",
    Default = false,
    Callback = function(Value)
        setShurikenDesync(Value)
    end
})

-- === SERVER TAB: AUTO RECONNECT ===
ServerTab:AddSection("Connection")

ServerTab:AddToggle("AutoReconnectToggle", {
    Title = "Auto Reconnect",
    Description = "Automatically rejoins after a kick / disconnect",
    Default = false,
    Callback = function(Value)
        setAutoReconnect(Value)
    end
})

ServerTab:AddButton({
    Title = "Server Hop (find a new server)",
    Callback = function()
        pcall(function()
            local servers = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=2&limit=10")
            local data = HttpService:JSONDecode(servers)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end)
    end
})

-- === KEYBINDS TAB: bind ANY registered function ===
local KeybindsTab = Window:AddTab({ Title = "Keybinds", Icon = "keyboard" })

KeybindsTab:AddSection("Bind Any Function to a Key")

registerKeybindAction("Toggle UI", Enum.KeyCode.RightControl, function()
    Window:Toggle()
end)
registerKeybindAction("Toggle Silent Aim", Enum.KeyCode.Q, function()
    Config.SilentAimEnabled = not Config.SilentAimEnabled
    Notify("Keybind", "Silent Aim: " .. tostring(Config.SilentAimEnabled), 2)
end)
registerKeybindAction("Toggle Player ESP", nil, function()
    Config.ESPEnabled = not Config.ESPEnabled
    updateESPHighlights()
    Notify("Keybind", "Player ESP: " .. tostring(Config.ESPEnabled), 2)
end)
registerKeybindAction("Toggle Profile ESP", nil, function()
    setProfileESP(not Config.ProfileESPEnabled)
end)
registerKeybindAction("Toggle Fly", Enum.KeyCode.F, function()
    AmethystFeatures.Fly.Enabled = not AmethystFeatures.Fly.Enabled
    Notify("Keybind", "Fly: " .. tostring(AmethystFeatures.Fly.Enabled), 2)
end)
registerKeybindAction("Toggle Noclip", Enum.KeyCode.N, function()
    Config.NoclipEnabled = not Config.NoclipEnabled
    Notify("Keybind", "Noclip: " .. tostring(Config.NoclipEnabled), 2)
end)
registerKeybindAction("Toggle Speed Boost", nil, function()
    Config.WalkspeedEnabled = not Config.WalkspeedEnabled
    Notify("Keybind", "Speed: " .. tostring(Config.WalkspeedEnabled), 2)
end)
registerKeybindAction("Toggle 3rd Person Fix", Enum.KeyCode.T, function()
    setThirdPersonFix(not Config.ThirdPersonFix)
end)
registerKeybindAction("Toggle Spin Bot", nil, function()
    Notify("Keybind", "Spin Bot is on the Target tab", 2)
end)
registerKeybindAction("Toggle Water Walk", nil, function()
    setWaterWalk(not Config.WaterWalkEnabled)
end)
registerKeybindAction("Toggle X-Ray", Enum.KeyCode.X, function()
    setXRay(not Config.XRayEnabled)
end)
registerKeybindAction("Toggle Fullbright", nil, function()
    pcall(function()
        Lighting.Brightness = 2.5
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Notify("Fullbright", "Applied!", 2)
    end)
end)
registerKeybindAction("Toggle Soap Textures", nil, function()
    setSoapTextures(not Soap.enabled)
end)
registerKeybindAction("Fling Closest Target", Enum.KeyCode.G, function()
    flingClosestTarget()
end)
registerKeybindAction("Teleport to Spawn", nil, function()
    local root = getRoot(LocalPlayer)
    if root then
        root.CFrame = CFrame.new(3, -7, -2)
        Notify("Keybind", "Teleported to Spawn", 2)
    end
end)
registerKeybindAction("Toggle Chat Spam", nil, function()
    setChatSpam(not Config.ChatSpamEnabled)
end)
registerKeybindAction("Toggle Click TP", Enum.KeyCode.C, function()
    setClickTP(not Config.ClickTPEnabled)
end)

for _, actionName in ipairs(KeybindOrder) do
    local action = KeybindRegistry[actionName]
    KeybindsTab:AddKeybind("KB_" .. actionName, {
        Title = actionName,
        Default = action.key,
        Callback = function(newKey)
            bindActionKey(actionName, newKey)
            Notify("Keybinds", actionName .. " bound to " .. (newKey and newKey.Name or "None"), 2)
        end
    })
end

GemoroiUI:Notify({
    Title = "FTAP-Gemoroi v3.6",
    Content = "Lime Dark Neon Edition loaded - all systems operational!",
    Duration = 5
})
