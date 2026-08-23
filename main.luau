--[[\
    Project: FTAP-Gemoroi\
    Main Loader with Fluent UI & pcall protection\
]]

local success, err = pcall(function()
    local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/config.luau"))() or {}
    
    local Fluent = loadstring(game:HttpGet("https://github.com/dawidsulfide/fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawidsulfide/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawidsulfide/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "FTAP - Gemoroi v1.0",
        SubTitle = "by keksup22",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.RightControl
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "home" }),
        Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    local Options = Fluent.Options

    Tabs.Main:AddParagraph({
        Title = "Welcome",
        Content = "FTAP-Gemoroi script successfully loaded and protected with pcall."
    })

    Tabs.Main:AddToggle("AimbotToggle", {
        Title = "Enable Aimbot",
        Default = false,
        Callback = function(Value)
            print("Aimbot:", Value)
        end
    })

    Tabs.Visuals:AddToggle("ESPToggle", {
        Title = "Enable ESP",
        Default = false,
        Callback = function(Value)
            print("ESP:", Value)
        end
    })

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("FTAPGemoroi")
    SaveManager:SetFolder("FTAPGemoroi/configs")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Fluent:Notify({
        Title = "FTAP-Gemoroi",
        Content = "Script loaded successfully!",
        Duration = 5
    })

    SaveManager:LoadAutoloadConfig()
end)

if not success then
    warn("[FTAP-Gemoroi] Failed to load UI: " .. tostring(err))
end
