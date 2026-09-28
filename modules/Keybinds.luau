local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Keybinds = {}

Keybinds.Bindings = {}

function Keybinds.Bind(actionName, keyCode, callback)
    if Keybinds.Bindings[actionName] then
        Keybinds.Unbind(actionName)
    end
    
    local conn = Shared.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == keyCode then
            pcall(callback)
        end
    end)
    
    Keybinds.Bindings[actionName] = { keyCode = keyCode, callback = callback, connection = conn }
end

function Keybinds.Unbind(actionName)
    local item = Keybinds.Bindings[actionName]
    if item then
        if item.connection then
            pcall(function() item.connection:Disconnect() end)
        end
        Keybinds.Bindings[actionName] = nil
    end
end

function Keybinds.GetKeybind(actionName)
    return Keybinds.Bindings[actionName]
end

function Keybinds.SetupDefaults(tabs, modules)
    -- Reserved for default user bindings
end

return Keybinds
