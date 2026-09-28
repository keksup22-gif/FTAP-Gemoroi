local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)

local UI = {}

function UI.CreateWindow()
    local Window = Shared.GemoroiUI:CreateWindow({
        Title = "FTAP - Gemoroi v3.5 (Lime Dark Edition)",
        SubTitle = "by keksup22 - GemoroiUI",
        TabWidth = 170,
        Size = UDim2.fromOffset(640, 520),
        Acrylic = true,
        Theme = "Lime Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    local Tabs = {
        Combat     = Window:AddTab({ Title = "Combat", Icon = "sword" }),
        Player     = Window:AddTab({ Title = "Player", Icon = "user" }),
        Visuals    = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
        Cosmetics  = Window:AddTab({ Title = "Cosmetics & Shaders", Icon = "sparkles" }),
        Target     = Window:AddTab({ Title = "Target", Icon = "crosshair" }),
        Mass       = Window:AddTab({ Title = "Mass / Troll", Icon = "zap" }),
        Protection = Window:AddTab({ Title = "Protection", Icon = "shield-alert" }),
        Defense    = Window:AddTab({ Title = "Defense", Icon = "shield" }),
        Auras      = Window:AddTab({ Title = "Auras", Icon = "flame" }),
        Server     = Window:AddTab({ Title = "Server", Icon = "server" }),
        Teleports  = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
        Misc       = Window:AddTab({ Title = "Misc & Figures", Icon = "box" }),
        Keybinds   = Window:AddTab({ Title = "Keybinds", Icon = "keyboard" }),
        Settings   = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    return Window, Tabs
end

return UI