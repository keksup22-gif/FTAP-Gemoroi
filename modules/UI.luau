local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Fluent = Shared.Fluent

local UI = {}

function UI.CreateWindow()
    local Window = Fluent:CreateWindow({
        Title = "FTAP - Gemoroi v2.5 (Modular)",
        SubTitle = "by keksup22",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

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

    return Window, Tabs
end

return UI