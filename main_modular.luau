-- FTAP-Gemoroi Loader
-- Modularized Version

local baseUrl = "https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/modules/"

local function loadModule(name)
    local success, result = pcall(function()
        local folder = (typeof(script) == "Instance" and script:FindFirstChild("modules")) 
            or (typeof(script) == "Instance" and script.Parent and script.Parent:FindFirstChild("modules")) 
            or game:GetService("ReplicatedStorage"):FindFirstChild("modules")
        if folder and folder:FindFirstChild(name) then
            return require(folder[name])
        end
    end)
    if success and result then
        return result
    end
    local code = game:HttpGet(baseUrl .. name .. ".luau")
    return loadstring(code)()
end

local Shared = loadModule("Shared")
if getgenv then getgenv().FTAP_Shared = Shared end

local Defense = loadModule("Defense")
local Player = loadModule("Player")
local Visuals = loadModule("Visuals")
local Cosmetics = loadModule("Cosmetics")
local Teleports = loadModule("Teleports")

local success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/Fluent.luau"))()
end)

if not success then
    warn("Failed to load Fluent UI")
    return
end

Shared.Fluent = Fluent

local Window = Fluent:CreateWindow({
    Title = "FTAP - Gemoroi (Modular)",
    SubTitle = "Refactored Modular Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Defense = Window:AddTab({ Title = "Defense", Icon = "shield" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Cosmetics = Window:AddTab({ Title = "Cosmetics", Icon = "sparkles" }),
}

-- Setup Defense Tab
Tabs.Defense:AddToggle("AntiGrabToggle", {
    Title = "Anti Grab",
    Default = false,
    Callback = function(Value)
        Defense.AntiGrab.enabled = Value
        if Value then Defense.StartAntiGrab() else Defense.StopAntiGrab() end
    end
})

Tabs.Defense:AddToggle("AntiKickStickToggle", {
    Title = "Anti-Kick Stick (Automatic)",
    Default = false,
    Callback = function(Value)
        Defense.AntiKickStick.enabled = Value
        if Value then Defense.StartAntiKickStick() else Defense.StopAntiKickStick() end
    end
})

Tabs.Defense:AddDropdown("KickStickItemDropdown", {
    Title = "Anti-Kick Item",
    Values = Defense.AntiKickStick.items,
    Default = Defense.AntiKickStick.selectedItem,
    Callback = function(Value)
        Defense.AntiKickStick.selectedItem = Value
    end
})

Tabs.Defense:AddToggle("AntiInputLagToggle", {
    Title = "Anti Input Lag (Auto Clear Lag Items)",
    Default = false,
    Callback = function(Value)
        Defense.AntiInputLag.enabled = Value
        if Value then Defense.StartAntiInputLag() else Defense.StopAntiInputLag() end
    end
})

Tabs.Defense:AddToggle("AntiVoidToggle", {
    Title = "Anti Void",
    Default = false,
    Callback = function(Value)
        Defense.AntiVoid.enabled = Value
        if Value then Defense.StartAntiVoid() else Defense.StopAntiVoid() end
    end
})

Tabs.Defense:AddToggle("AntiExplodeToggle", {
    Title = "Anti Explode",
    Default = false,
    Callback = function(Value)
        Defense.AntiExplode.enabled = Value
        if Value then Defense.StartAntiExplode() else Defense.StopAntiExplode() end
    end
})

Tabs.Defense:AddToggle("AntiPaintToggle", {
    Title = "Anti Paint",
    Default = false,
    Callback = function(Value)
        Defense.AntiPaint.enabled = Value
        if Value then Defense.StartAntiPaint() else Defense.StopAntiPaint() end
    end
})

Tabs.Defense:AddToggle("AntiStickyToggle", {
    Title = "Anti Sticky",
    Default = false,
    Callback = function(Value)
        Defense.AntiSticky.enabled = Value
        if Value then Defense.StartAntiSticky() else Defense.StopAntiSticky() end
    end
})

-- Setup Player Tab
Tabs.Player:AddToggle("SpeedToggle", {
    Title = "WalkSpeed Loop",
    Default = false,
    Callback = function(Value)
        if Value then Player.EnableSpeed() else Player.DisableSpeed() end
    end
})

Tabs.Player:AddSlider("SpeedSlider", {
    Title = "WalkSpeed Value",
    Default = 16,
    Min = 16,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        Player.Speed.value = Value
    end
})

Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Noclip (Players & Items)",
    Default = false,
    Callback = function(Value)
        Player.ToggleNoclip(Value)
    end
})

Tabs.Player:AddButton({
    Title = "Delete Legs",
    Callback = function()
        Player.DeleteLegs()
    end
})

-- Setup Visuals Tab
Tabs.Visuals:AddToggle("ESPToggle", {
    Title = "Player ESP",
    Default = false,
    Callback = function(Value)
        Visuals.Config.ESPEnabled = Value
        Visuals.UpdateESPHighlights()
    end
})

Tabs.Visuals:AddToggle("ModelHighlightToggle", {
    Title = "Model Highlights",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelHighlights(Value)
    end
})

Tabs.Visuals:AddToggle("ModelBillboardToggle", {
    Title = "Model Billboards",
    Default = false,
    Callback = function(Value)
        Visuals.UpdateModelBillboards(Value)
    end
})

-- Setup Teleports Tab
for _, house in ipairs(Teleports.Houses) do
    Tabs.Teleports:AddButton({
        Title = "Teleport to " .. house[1],
        Callback = function()
            Teleports.TeleportTo(house[2])
            Shared.Notify("Teleport", "Teleported to " .. house[1], 2)
        end
    })
end

-- Setup Cosmetics Tab
Tabs.Cosmetics:AddToggle("AngelWingsToggle", {
    Title = "Angel Wings",
    Default = false,
    Callback = function(Value)
        Cosmetics.ToggleAngelWings(Value)
    end
})

Shared.Notify("FTAP Gemoroi", "Modular Script Loaded Successfully!", 4)

