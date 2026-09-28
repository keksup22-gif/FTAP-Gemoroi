local Shared = (getgenv and getgenv().FTAP_Shared) or require(script.Parent.Shared)
local Keybinds = {}

-- Bindings: actionName -> { keyCode, callback, connection }
Keybinds.Bindings = {}
-- Registered actions: actionName -> { fn = function() ... end, key = default KeyCode }
Keybinds.Actions = {}
Keybinds.Order = {}

function Keybinds.Register(actionName, defaultKey, fn)
    Keybinds.Actions[actionName] = { fn = fn, key = defaultKey }
    table.insert(Keybinds.Order, actionName)
    if defaultKey then
        Keybinds.Bind(actionName, defaultKey)
    end
    return Keybinds.Actions[actionName]
end

function Keybinds.Bind(actionName, keyCode)
    if Keybinds.Bindings[actionName] then
        Keybinds.Unbind(actionName)
    end
    local action = Keybinds.Actions[actionName]
    if not action then
        return
    end
    if not keyCode then
        return
    end
    local conn = Shared.UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == keyCode then
            pcall(action.fn)
        end
    end)
    Keybinds.Bindings[actionName] = { keyCode = keyCode, callback = action.fn, connection = conn }
    action.key = keyCode
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

function Keybinds.GetKey(actionName)
    local item = Keybinds.Bindings[actionName]
    return item and item.keyCode or nil
end

function Keybinds.UnbindAll()
    for actionName in pairs(Keybinds.Bindings) do
        Keybinds.Unbind(actionName)
    end
end

return Keybinds
