local Shared = require(script.Parent.Shared)
local Protection = {}

Protection.Config = {
    AntiGrabEnabled = false,
    AntiFlingEnabled = false,
    AntiRagdollAuto = false,
    AntiKickEnabled = false,
    AntiExplosionEnabled = false,
    AntiBurnEnabled = false,
    AntiPaintEnabled = false,
    AntiStickyEnabled = false,
    AntiVoidEnabled = false,
    AntiBlobEnabled = false,
    AutoReset = false,
    AutoLeave = false,
    AntiBanana = false,
    CounterAttacks = {
        enabled = false,
        mode = "Fling"
    }
}

Protection.CounterModes = {
    "Fling", "Kill", "Send to Heaven", "Kick", "Ragdoll", "Hell", "China", "GrabLine"
}

return Protection