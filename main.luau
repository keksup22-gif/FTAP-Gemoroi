--[[\
    Project: FTAP-Gemoroi\
    Main Loader with pcall protection loading ftap_core.luau\
]]

local success, err = pcall(function()
    local coreUrl = "https://raw.githubusercontent.com/keksup22-gif/FTAP-Gemoroi/main/ftap_core.luau"
    local coreScript = game:HttpGet(coreUrl)
    if coreScript then
        loadstring(coreScript)()
    else
        error("Failed to fetch ftap_core.luau content.")
    end
end)

if not success then
    warn("[FTAP-Gemoroi Loader] Critical Error: " .. tostring(err))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FTAP-Gemoroi Error",
        Text = "Failed to load core script. Check console.",
        Duration = 10
    })
end
