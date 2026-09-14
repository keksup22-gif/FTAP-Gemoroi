local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Keybinds = {}

Keybinds.Bindings = {}

function Keybinds.Bind(actionName, keyCode, callback)
    if Keybinds.Bindings[actionName] then
        Keybinds.Unbind(actionName)
    end
    
    local action = Instance.new("BindableEvent")
    action.Name = actionName
    
    Shared.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == keyCode then
            callback()
        end
    end)
    
    Keybinds.Bindings[actionName] = { keyCode = keyCode, callback = callback }
end

function Keybinds.Unbind(actionName)
    Keybinds.Bindings[actionName] = nil
end

function Keybinds.GetKeybind(actionName)
    return Keybinds.Bindings[actionName]
end

-- Default keybinds
function Keybinds.SetupDefaults(tabs, modules)
    -- These will be set up in the main loader
end

return Keybinds