-- FTAP Reverse
-- https://t.me/ReverseFTAP

local genv = getgenv()
local fenv = getfenv()
local _ = game:GetService('Players').LocalPlayer

game:GetService('TweenService')
game:GetService('Lighting')
game:GetService('CoreGui')
game:GetService('TextChatService')
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

local _20 = loadstring(game:HttpGet('https://raw.githubusercontent.com/katnaa-debug/SolarisUI/refs/heads/main/Library1.lua'))()

fenv.SetToggleState = function(_21, _21_2) end
fenv.GetToggleState = function(_22, _22_2, _22_3, _22_4)
    return false
end

local _ = _20.Items
local _ = _20.Flags
local _call28 = _20:CreateWindow({
    Transparency = 0.25,
    Title = '\u{2020} | Duck Hub | \u{2020}',
    ConfigFolder = 'XOCU_Config',
    AutoSave = true,
    ShowWatermark = {
        Enabled = true,
        Title = false,
        User = true,
        FPS = true,
        Ping = true,
        Duration = false,
    },
    Theme = 'Void',
    ToggleKey = Enum.KeyCode.Tab,
})
local _call30 = _call28:CreateTab('Defense', true, '7461510456')
local _call32 = _call28:CreateTab('Target', true, '107058246184363')
local _call34 = _call28:CreateTab('Grab', true, '85607241723723')
local _call36 = _call28:CreateTab('Player', true, '124871982298256')
local _call38 = _call28:CreateTab('Misc', true, '114167292947807')
local _call40 = _call28:CreateTab('Keybinds', true, '4814130203')

_call28:CreateTab('Visuals', true, '7733955511')
game:GetService('ReplicatedStorage')
game:GetService('StarterGui')

local _call50 = game:GetService('ReplicatedStorage')

game:GetService('RunService')

local _call54 = game:GetService('UserInputService')
local _LocalPlayer55 = game:GetService('Players').LocalPlayer
local _ = workspace.CurrentCamera
local _call58 = _call50:WaitForChild('CharacterEvents', 10)

_LocalPlayer55:WaitForChild('IsHeld', 10)
_call58:WaitForChild('Struggle')

fenv.notify = function(_63, _63_2, _63_3, _63_4, _63_5)
    _20:Notify({
        Duration = _63_3,
        Title = _63,
        Content = _63_2,
    })
end
fenv.deleteAllPaintParts = function(_66, _66_2, _66_3)
    for _69, _69_2 in ipairs(workspace:GetDescendants())do
        _69_2:IsA('BasePart')

        local _ = _69_2.Name
    end
end

local _call74 = _call30:CreateBlock({
    Name = 'Defense Main',
    Side = 'Left',
})
local _call76 = _call30:CreateBlock({
    Name = 'Extra Defense',
    Side = 'Right',
})

_call74:CreateToggle({
    Flag = 'AntiGrab',
    Callback = function(_79, _79_2)
        local _Character80 = _LocalPlayer55.Character
        local _call82 = _Character80:WaitForChild('HumanoidRootPart', 5)
        local _call84 = _Character80:WaitForChild('Humanoid', 5)
        local _call86 = _Character80:WaitForChild('Head', 5)

        for _89, _89_2 in pairs(_Character80:GetChildren())do
            _89_2:IsA('BasePart')
            _89_2:FindFirstChild('BallSocketConstraint')

            local _ = _89_2.Name
            local _BallSocketConstraint95 = _89_2.BallSocketConstraint

            _BallSocketConstraint95.Enabled = false

            _89_2:FindFirstChild('RagdollLimbPart')

            local _WeldConstraint99 = _89_2.RagdollLimbPart.WeldConstraint

            _WeldConstraint99.Enabled = false
        end

        _call86.ChildAdded:Connect(function(_103, _103_2)
            local _ = _103.Name
        end)
        _call84:WaitForChild('Ragdolled', 5).Changed:Connect(function()
            local _ = _call84.Ragdolled.Value

            for _115, _115_2 in pairs(_Character80:GetChildren())do
                _115_2:IsA('BasePart')
                _115_2:FindFirstChild('BallSocketConstraint')

                local _ = _115_2.Name
                local _BallSocketConstraint121 = _115_2.BallSocketConstraint

                _BallSocketConstraint121.Enabled = false

                _115_2:FindFirstChild('RagdollLimbPart')

                local _WeldConstraint125 = _115_2.RagdollLimbPart.WeldConstraint

                _WeldConstraint125.Enabled = false
            end
        end)
        _call82:WaitForChild('WeldHRP', 5).Changed:Connect(function()
            local _ = _call82.WeldHRP.Enabled
            local _ = _call84.Sit

            _call84.Sit = false
            _call84.AutoRotate = true
            _call84.HipHeight = 1

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

            task.wait()

            _call86.CFrame = (_call82.CFrame + Vector3.new(0, 1.35, 0))

            local _ = _call82.WeldHRP.Enabled

        end)
        _LocalPlayer55.CharacterAdded:Connect(function(_236, _236_2)
            local _call238 = _236:WaitForChild('HumanoidRootPart', 5)
            local _call240 = _236:WaitForChild('Humanoid', 5)

            for _245, _245_2 in pairs(_236:GetChildren())do
                _245_2:IsA('BasePart')
                _245_2:FindFirstChild('BallSocketConstraint')

                local _ = _245_2.Name
                local _BallSocketConstraint251 = _245_2.BallSocketConstraint

                _BallSocketConstraint251.Enabled = false

                _245_2:FindFirstChild('RagdollLimbPart')

                local _WeldConstraint255 = _245_2.RagdollLimbPart.WeldConstraint

                _WeldConstraint255.Enabled = false
            end

            _236:WaitForChild('Head', 5).ChildAdded:Connect(function(_259, _259_2)
                local _ = _259.Name
            end)
            _call240:WaitForChild('Ragdolled', 5).Changed:Connect(function()
                local _ = _call240.Ragdolled.Value

            end)
            _call238:WaitForChild('WeldHRP', 5).Changed:Connect(function() end)
        end)
    end,
    Name = 'Anti Grab [BEST (use solo)]',
    Default = false,
})

local _call279 = game:GetService('ReplicatedStorage')

game:GetService('RunService')

local _LocalPlayer282 = game:GetService('Players').LocalPlayer
local _call284 = _LocalPlayer282:WaitForChild('IsHeld', 10)

_call279:WaitForChild('CharacterEvents', 10):WaitForChild('Struggle', 10)
_call284.Changed:Connect(function(_292, _292_2, _292_3, _292_4) end)

local _ = _call284.Value

_call74:CreateToggle({
    Flag = 'Anti Grab V2 (Full Defense)',
    Callback = function(_296, _296_2) end,
    Name = 'Anti Grab V2 (anti perm die)',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'SelfDefenceThrow',
    Callback = function(_299) end,
    Name = 'Self Defence Throw',
    Default = false,
})
_LocalPlayer282.CharacterAdded:Connect(function(_303, _303_2) end)
_call74:CreateToggle({
    Flag = 'AntiBananaSit',
    Callback = function(_306, _306_2, _306_3, _306_4) end,
    Name = 'Anti Banana [SIT]',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'AntiRagdoll',
    Callback = function(_309, _309_2) end,
    Name = 'Anti Ragdoll (On Blob)',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'LoopRagdoll',
    Callback = function(_312) end,
    Name = 'anti snowball',
    Default = false,
})

fenv.antiblob = false
fenv.antiblobConnection = nil
fenv.truePosPart = nil

_call74:CreateToggle({
    Flag = 'Auto Reset',
    Callback = function(_315, _315_2, _315_3) end,
    Name = 'Auto Kick Reset',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Auto Leave',
    Callback = function(_318, _318_2, _318_3, _318_4, _318_5) end,
    Name = 'Auto Leave ',
    Default = false,
})
_call74:CreateDropdown({
    Items = {
        [1] = '1',
        [2] = '2',
        [3] = '3',
        [4] = '4',
        [5] = '5',
        [6] = '6',
    },
    Name = 'Auto Leave Warns',
    Flag = 'AutoLeaveWarnsDropdown',
    Callback = function(_321, _321_2, _321_3, _321_4) end,
    Default = '3',
})
_call74:CreateToggle({
    Flag = 'Anti Void',
    Callback = function(_324, _324_2, _324_3, _324_4, _324_5, _324_6) end,
    Name = 'Anti Void',
    Default = false,
})

fenv.antiblob = false

_call74:CreateToggle({
    Flag = 'AntiBlobKick',
    Callback = function(_327, _327_2, _327_3, _327_4, _327_5, _327_6) end,
    Name = 'Anti Blob',
    Default = false,
})
game:GetService('RunService')

local _call333 = game:GetService('ReplicatedStorage')
local _ = game:GetService('Players').LocalPlayer

_call74:CreateToggle({
    Flag = 'Anti-Blobman Aura',
    Callback = function(_337, _337_2, _337_3, _337_4, _337_5, _337_6) end,
    Name = 'Anti-Blobman Aura',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Anti Explosion',
    Callback = function(_340, _340_2, _340_3, _340_4, _340_5) end,
    Name = 'Anti Explosion',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Anti Burn',
    Callback = function(_343, _343_2, _343_3) end,
    Name = 'Anti Burn',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Anti Sticky',
    Callback = function(_346, _346_2, _346_3) end,
    Name = 'Anti Sticky',
    Default = false,
})

local _call348 = _call333:FindFirstChild('GrabEvents')
local _call350 = _call348:FindFirstChild('CreateGrabLine')
local _call352 = _call348:FindFirstChild('ExtendGrabLine')

_call350:Clone()
_call352:Clone()

local _ = game:GetService('Players').LocalPlayer

game:GetService('RunService')

local _ = _G.cons

_G.cons = {}

_call74:CreateToggle({
    Flag = 'Anti Loop Kill',
    Callback = function(_364, _364_2, _364_3, _364_4) end,
    Name = 'Anti Loop Kill',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Anti Lag',
    Callback = function(_367, _367_2, _367_3) end,
    Name = 'Anti Lag',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'AutoPCLDBreakSmart',
    Callback = function(_370, _370_2) end,
    Name = 'Auto PCLD Break',
    Default = false,
})
_call74:CreateToggle({
    Flag = 'Auto Delete Legs',
    Callback = function(_373, _373_2, _373_3) end,
    Name = 'Auto Delete Legs',
    Default = false,
})
_call76:CreateToggle({
    Flag = 'Anti Paint',
    Callback = function(_376, _376_2, _376_3, _376_4, _376_5, _376_6) end,
    Name = 'Anti Paint',
    Default = false,
})
_call76:CreateToggle({
    Flag = 'PlatformTPToggle',
    Callback = function(_379, _379_2, _379_3) end,
    Name = 'Enable Platform TP',
    Default = false,
})
_call76:CreateKeybind({
    Flag = 'PlatformTPKey',
    Callback = function(_382, _382_2, _382_3) end,
    Name = 'Platform TP Execute',
    Default = 'X',
})
_call76:CreateKeybind({
    Flag = 'GucciBinderKey',
    Callback = function(_385, _385_2, _385_3, _385_4, _385_5) end,
    Name = 'Gucci Binder',
    Default = 'J',
})

local _call389 = game:GetService('ReplicatedStorage')

game:GetService('RunService')
game:GetService('Workspace')

local _ = game:GetService('Players').LocalPlayer

_call389:WaitForChild('CharacterEvents', 5):FindFirstChild('RagdollRemote')

local _call400 = _call389:WaitForChild('MenuToys', 5)

_call400:WaitForChild('SpawnToyRemoteFunction', 5)
_call400:FindFirstChild('DestroyToy')
_call76:CreateToggle({
    Flag = 'Anti Gucci (Blobman)',
    Callback = function(_407, _407_2, _407_3) end,
    Name = 'Anti Gucci (Blobman)',
    Default = false,
})
_call76:CreateToggle({
    Flag = 'Gucci(Invisible)',
    Callback = function(_410, _410_2, _410_3) end,
    Name = 'Gucci(Invisible)',
    Default = false,
})
_call76:CreateToggle({
    Flag = 'AutoGucci',
    Callback = function(_413, _413_2, _413_3, _413_4, _413_5) end,
    Name = 'auto Gucci(Invisible)',
    Default = false,
})
_call76:CreateToggle({
    Flag = 'Anti Gucci (Train)',
    Callback = function(_416, _416_2, _416_3) end,
    Name = 'Anti Gucci (Train)',
    Default = false,
})
_call76:CreateButton({
    Flag = 'Delete Legs',
    Name = 'Delete Legs',
    Callback = function(_419) end,
})
_call76:CreateDropdown({
    Items = {
        [1] = 'Banana',
        [2] = 'Banjo',
        [3] = 'Bongos',
        [4] = 'Bread',
        [5] = 'BrownMug',
        [6] = 'Burger',
        [7] = 'Cake',
        [8] = 'Coconut',
        [9] = 'Donut',
        [10] = 'Egg',
        [11] = 'Fries',
        [12] = 'Hotdog',
        [13] = 'Lyre',
        [14] = 'Mayo',
        [15] = 'MeatStick',
        [16] = 'Mic',
        [17] = 'Mushroom',
        [18] = 'Ocarina',
        [19] = 'Pepperoni',
        [20] = 'Piano',
        [21] = 'Pizza',
        [22] = 'Poop',
        [23] = 'Sax',
        [24] = 'Snare',
        [25] = 'SparklePoop',
        [26] = 'Trumpet',
        [27] = 'Ukulele',
        [28] = 'Violin',
        [29] = 'Vuvuzela',
        [30] = 'WhiteMug',
    },
    Name = 'Select Input Lag Toy',
    Flag = 'InputLagToyDropdown',
    Callback = function(_422, _422_2, _422_3) end,
    Default = 'Burger',
})
_call76:CreateToggle({
    Flag = 'InstantInputLag',
    Callback = function(_425, _425_2, _425_3, _425_4, _425_5, _425_6) end,
    Name = 'Anti-Input',
    Default = false,
})
game:GetService('ReplicatedStorage')
game:GetService('RunService')
_call76:CreateDropdown({
    Items = {
        [1] = 'Big Book',
        [2] = 'Bubble Blower',
        [3] = 'Clock Alarm',
        [4] = 'Desk Lamp',
        [5] = 'Fan',
        [6] = 'Helicopter',
        [7] = 'Japanese Lantern',
        [8] = 'Small Book',
        [9] = 'Small Table',
        [10] = 'Spooky Candle',
        [11] = 'Spooky Candle 3',
        [12] = 'Spooky Candle 5',
        [13] = 'Spray Can',
    },
    Name = 'Anti Kick Item',
    Flag = 'Input Lag Item',
    Callback = function(_435, _435_2, _435_3, _435_4) end,
    Default = 'Clock Alarm',
})
_call76:CreateToggle({
    Flag = 'AntiKickItemFlag',
    Callback = function(_438, _438_2, _438_3, _438_4) end,
    Name = 'Anti Kick [ITEM]',
    Default = false,
})
game:GetService('Players').LocalPlayer.CharacterAdded:Connect(function(_442, _442_2) end)

local _ = CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966)
local _ = CFrame.new(0.9, -1.5, -0.3) * CFrame.Angles(-0.1, 0, 4.834562028024293)
local _ = CFrame.new(0.4, 0, 0.7) * CFrame.Angles(0, 1.5707963267948966, 1.5707963267948966)
local _ = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
local _ = CFrame.new(0, 0, 0) * CFrame.Angles(90, 0, 0)

_call76:CreateDropdown({
    Items = {
        [1] = 'Cleaver',
        [2] = 'Digging Fork Rusty',
        [3] = 'Kunai',
        [4] = 'Pickaxe',
        [5] = 'Shuriken',
    },
    Name = 'Anti Kick Item',
    Flag = 'Input Lag Item',
    Callback = function(_470, _470_2) end,
    Default = 'Ninja Shuriken',
})

_G.ShurikenAntiKick = false

_call76:CreateToggle({
    Flag = 'ShurikenAntiKick',
    Callback = function(_473, _473_2, _473_3, _473_4, _473_5, _473_6) end,
    Name = 'Anti Kick',
    Default = false,
})
_LocalPlayer55.CharacterAdded:Connect(function(_477, _477_2) end)
_call76:CreateToggle({
    Flag = 'Loop TP',
    Callback = function(_480, _480_2, _480_3, _480_4, _480_5) end,
    Name = 'Loop TP',
    Default = false,
})

local _call482 = game:GetService('Players')
local _LocalPlayer483 = _call482.LocalPlayer
local _call485 = _call32:CreateBlock({
    Name = 'Target Interaction',
    Side = 'Left',
})
local _call487 = _call32:CreateBlock({
    Name = 'Blobman Kick',
    Side = 'Right',
})
local _call489 = _call32:CreateBlock({
    Name = 'Telekinesis',
    Side = 'Right',
})

game:GetService('Players')
game:GetService('ReplicatedStorage'):WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')

local _ = workspace.CurrentCamera

game:GetService('Players').LocalPlayer.CharacterAdded:Connect(function(_505, _505_2, _505_3, _505_4, _505_5, _505_6) end)
_call489:CreateToggle({
    Flag = 'Telekinesis Aura',
    Callback = function(_508, _508_2, _508_3, _508_4, _508_5, _508_6) end,
    Name = 'Telekinesis Aura',
    Default = false,
})
game:GetService('ReplicatedStorage'):WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')
game:GetService('ReplicatedStorage'):WaitForChild('GrabEvents'):WaitForChild('DestroyGrabLine')
_call489:CreateToggle({
    Flag = 'Death Aura',
    Callback = function(_523, _523_2, _523_3) end,
    Name = 'Death Aura',
    Default = false,
})
game:GetService('Workspace')
game:GetService('Debris')

local _ = game:GetService('Players').LocalPlayer

game:GetService('ReplicatedStorage'):WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')

_G.FlingAura = false
_G.FlingStrength = 400
_G.FlingTarget = 1

local _call538 = OverlapParams.new()

_call538.FilterType = Enum.RaycastFilterType.Exclude

_call489:CreateToggle({
    Flag = 'flingaura_toggle',
    Callback = function(_543) end,
    Name = 'Fling Aura',
    Default = false,
})
_call489:CreateSlider({
    Min = 400,
    Name = 'Strength',
    Default = 400,
    Flag = 'flingstrengthvalue_toggle',
    Max = 10000,
    Callback = function(_546, _546_2) end,
    Rounding = 0,
})
_call489:CreateDropdown({
    Items = {
        [1] = 'Players',
        [2] = 'Objects',
        [3] = 'Players and Objects',
    },
    Name = 'Target',
    Flag = 'flingtarget_dropdown',
    Callback = function(_549, _549_2) end,
    Default = 'Players',
})

fenv.WhiteList = true

for _552, _552_2 in ipairs(_call482:GetPlayers())do
    local _ = _552_2 == _LocalPlayer483
end

local _call555 = _call485:CreateDropdown({
    Callback = function(_556, _556_2, _556_3, _556_4) end,
    Name = 'Select target',
    List = {},
})

game:GetService('UserInputService')
game:GetService('Players').LocalPlayer:GetMouse()
_call485:CreateToggle({
    Flag = 'MouseSelectTargetToggle',
    Callback = function(_566, _566_2, _566_3, _566_4, _566_5, _566_6) end,
    Name = 'Mouse Select Target (F)',
    Default = false,
})
_call482.PlayerAdded:Connect(function(_570, _570_2, _570_3, _570_4) end)
_call482.PlayerRemoving:Connect(function(_574, _574_2, _574_3, _574_4) end)

for _577, _577_2 in ipairs(_call482:GetPlayers())do
    local _ = _577_2 == _LocalPlayer483
end

_call555:Refresh({}, false)
_call482.PlayerAdded:Connect(function(_584, _584_2, _584_3, _584_4) end)
_call482.PlayerRemoving:Connect(function(_588, _588_2, _588_3, _588_4) end)
_LocalPlayer483.CharacterRemoving:Connect(function(_592, _592_2, _592_3, _592_4) end)
_call485:CreateInput({
    Placeholder = 'Enter height (e.g. 50)',
    Name = 'Custom Kick Height',
    Numeric = true,
    Flag = 'Custom Kick Height',
    Finished = true,
    Callback = function(_595, _595_2, _595_3, _595_4) end,
    Default = '25',
})
_call487:CreateToggle({
    Flag = 'Auto Sit Blobman',
    Callback = function(_598, _598_2, _598_3, _598_4, _598_5, _598_6) end,
    Name = 'Auto Sit Blobman',
    Default = false,
})
_call487:CreateToggle({
    Flag = 'AnchorBlobmanFlag',
    Callback = function(_601, _601_2, _601_3, _601_4) end,
    Name = 'Anchor Blobman',
    Default = false,
})
_call487:CreateToggle({
    Flag = 'grab + blob',
    Callback = function(_604, _604_2, _604_3, _604_4) end,
    Name = 'Blob Kick Spin',
    Default = false,
})
_call487:CreateToggle({
    Flag = 'spam blob loop',
    Callback = function(_607, _607_2) end,
    Name = 'Blob Spam Grab',
    Default = false,
})
_call487:CreateToggle({
    Flag = 'Kill Blob [Fast]',
    Callback = function(_610, _610_2, _610_3) end,
    Name = 'Kill Blob',
    Default = false,
})
_call487:CreateButton({
    Name = 'Kick All [Blob]',
    Callback = function(_613, _613_2, _613_3) end,
})
_call485:CreateToggle({
    Flag = 'Ragdoll Target',
    Callback = function(_616, _616_2) end,
    Name = 'Pallet Ragdoll',
    Default = false,
})
Vector3.new(6, -18.5, 0)
_call485:CreateToggle({
    Flag = 'FlingGrab',
    Callback = function(_621, _621_2, _621_3, _621_4) end,
    Name = 'loop kill',
    Default = false,
})

local _call625 = game:GetService('ReplicatedStorage')

game:GetService('RunService')
game:GetService('Debris')
game:GetService('Players').LocalPlayer.Character:FindFirstChild('HumanoidRootPart')

local _call635 = _call625:FindFirstChild('GrabEvents')
local _call637 = _call625:FindFirstChild('MenuToys')

_call625:FindFirstChild('HoldEvents')
_call635:FindFirstChild('SetNetworkOwner')
_call635:FindFirstChild('DestroyGrabLine')
_call637:FindFirstChild('DestroyToy')
_call637:FindFirstChild('SpawnToyRemoteFunction')
_call485:CreateToggle({
    Flag = 'LoopBananaRagdoll',
    Callback = function(_650, _650_2) end,
    Name = 'Loop Banana Ragdoll',
    Default = false,
})

local _call652 = game:GetService('ReplicatedStorage')

game:GetService('RunService')
game:GetService('Workspace')
_call652:WaitForChild('GrabEvents'):WaitForChild('DestroyGrabLine')
_call652:WaitForChild('GrabEvents'):WaitForChild('SetNetworkOwner')
_call652:WaitForChild('MenuToys'):WaitForChild('DestroyToy')
_call652:WaitForChild('MenuToys'):WaitForChild('SpawnToyRemoteFunction')

local _ = game:GetService('Players').LocalPlayer

CFrame.new(0, 15, 0)
_call485:CreateToggle({
    Flag = 'SpamGrabKick',
    Callback = function(_680, _680_2, _680_3, _680_4) end,
    Name = 'Spam Grab Kick',
    Default = false,
})
_call485:CreateToggle({
    Flag = 'Ragdoll Snowball',
    Callback = function(_683) end,
    Name = 'Ragdoll Snowball',
    Default = false,
})
_call485:CreateToggle({
    Flag = 'Fling',
    Callback = function(_686, _686_2, _686_3, _686_4) end,
    Name = 'Fling',
    Default = false,
})
game:GetService('UserInputService').InputBegan:Connect(function(_692, _692_2, _692_3, _692_4, _692_5, _692_6, _692_7) end)
_call54.InputBegan:Connect(function(_696, _696_2, _696_3) end)
game:GetService('RunService').Heartbeat:Connect(function() end)
_call485:CreateToggle({
    Flag = 'Destroy Gucci (sit)',
    Callback = function(_705, _705_2, _705_3, _705_4, _705_5) end,
    Name = 'Destroy Gucci (sit)',
    Default = false,
})
_call485:CreateToggle({
    Flag = 'Remove Anti Input Lag',
    Callback = function(_708, _708_2, _708_3) end,
    Name = 'Remove Anti Input Lag',
    Default = false,
})

local _call710 = _call34:CreateBlock({
    Name = 'Grab Customization',
    Side = 'Left',
})

_G.strength = 750

_call710:CreateSlider({
    Min = 1,
    Name = 'Power',
    Max = 20000,
    Flag = 'Power',
    Default = 750,
    Callback = function(_713) end,
    Rounding = 0,
})
_call710:CreateToggle({
    Flag = 'Strength',
    Callback = function(_716, _716_2, _716_3) end,
    Name = 'Strength',
    Default = false,
})
workspace.ChildAdded:Connect(function(_720, _720_2, _720_3, _720_4, _720_5, _720_6) end)
_call710:CreateToggle({
    Flag = 'Kill Grab',
    Callback = function(_723, _723_2, _723_3) end,
    Name = 'Kill Grab',
    Default = false,
})

local _call725 = _call36:CreateBlock({
    Name = 'View & Movement',
    Side = 'Left',
})
local _call727 = _call36:CreateBlock({
    Name = 'ESP',
    Side = 'Right',
})
local _call729 = _call36:CreateBlock({
    Name = 'Performance',
    Side = 'Right',
})

_call725:CreateToggle({
    Flag = '3rd Person View',
    Callback = function(_732, _732_2, _732_3) end,
    Name = '3rd Person View',
    Default = false,
})
_call725:CreateToggle({
    Flag = 'Spin Character',
    Callback = function(_735, _735_2) end,
    Name = 'Spin Character',
    Default = false,
})
_call725:CreateSlider({
    Min = 1,
    Name = 'Spin Speed',
    Max = 50,
    Flag = 'Spin Speed',
    Default = 5,
    Callback = function(_738, _738_2, _738_3) end,
    Rounding = 0,
})
_call725:CreateInput({
    Placeholder = 'e.g. 16',
    Name = 'Walk Speed',
    Flag = 'Walk Speed',
    Numeric = true,
    Callback = function(_741, _741_2, _741_3) end,
    Default = '16',
})
_call725:CreateToggle({
    Flag = 'Enable Speed (CFrame)',
    Callback = function(_744) end,
    Name = 'Enable Speed (CFrame)',
    Default = false,
})
_call725:CreateToggle({
    Flag = 'Water Walk',
    Callback = function(_747, _747_2) end,
    Name = 'Water Walk',
    Default = false,
})
_call54.JumpRequest:Connect(function(_751, _751_2, _751_3) end)

fenv.AddBoxESP = function(_752, _752_2) end
fenv.RemoveAllBoxes = function(_753) end
fenv.Scan = function(_754) end

workspace.DescendantAdded:Connect(function(_758, _758_2) end)
_call727:CreateToggle({
    Flag = 'PCLD View',
    Callback = function(_761, _761_2, _761_3, _761_4, _761_5, _761_6) end,
    Name = 'PCLD View',
    Default = false,
})
_call727:CreateToggle({
    Flag = 'Nickname Esp',
    Callback = function(_764, _764_2, _764_3, _764_4, _764_5, _764_6) end,
    Name = 'Nickname Esp',
    Default = false,
})
_call729:CreateButton({
    Flag = 'boost fps',
    Name = 'boost fps',
    Callback = function() end,
})
_call729:CreateButton({
    Flag = 'delete boost fps',
    Name = 'delete boost fps',
    Callback = function(_770, _770_2, _770_3, _770_4) end,
})

local _call772 = _call38:CreateBlock({
    Name = 'Packet Detector',
    Side = 'Left',
})
local _ = game:GetService('Players').LocalPlayer

game:GetService('ReplicatedStorage')
game:GetService('RunService')

local _call781 = _call38:CreateBlock({
    Name = 'Packet Detector',
    Side = 'Left',
})

_call781:CreateToggle({
    Flag = 'GrabRemoteDetector',
    Callback = function(_784) end,
    Name = 'Detect packets',
    Default = false,
})
_call772:CreateButton({
    Name = 'Disable Plot Barriers',
    Callback = function(_787, _787_2) end,
})
_call772:CreateToggle({
    Flag = 'Dreamy Night Shader',
    Callback = function(_790) end,
    Name = 'Dreamy Night Shader',
    Default = false,
})

local _call792 = RaycastParams.new()

_call792.FilterType = Enum.RaycastFilterType.Exclude

task.spawn(function(_797, _797_2, _797_3) end)
_call50:FindFirstChild('GamepassEvents')
_call50.GamepassEvents:FindFirstChild('FurtherReachBoughtNotifier')
_call50.GamepassEvents.FurtherReachBoughtNotifier.OnClientEvent:Connect(function(_808) end)
_call772:CreateToggle({
    Flag = 'Ignore House Barriers',
    Callback = function(_811, _811_2) end,
    Name = 'Ignore House Barriers',
    Default = false,
})

_G.MonsterLagEnabled = false

_call772:CreateToggle({
    Flag = 'MonsterLagToggle',
    Callback = function(_814) end,
    Name = 'Monster Lag',
    Default = false,
})
_call772:CreateSlider({
    Min = 10,
    Name = 'Packet Amount',
    Max = 5000,
    Flag = 'PacketSpamAmount',
    Default = 900,
    Callback = function(_817, _817_2, _817_3) end,
    Rounding = 0,
})
_call772:CreateToggle({
    Flag = 'PacketLagActive',
    Callback = function(_820, _820_2) end,
    Name = 'Enable Packet Lag',
    Default = false,
})
_call772:CreateToggle({
    Flag = 'Trigger Bot',
    Callback = function(_823, _823_2, _823_3, _823_4, _823_5) end,
    Name = 'Trigger Bot',
    Default = false,
})
_call772:CreateSlider({
    Min = 1,
    Max = 120,
    Name = 'FOV',
    Suffix = '\u{412}\u{b0}',
    Flag = 'FOV',
    Default = 90,
    Callback = function(_826, _826_2, _826_3, _826_4, _826_5, _826_6) end,
    Rounding = 0,
})
_call482.PlayerAdded:Connect(function(_830, _830_2, _830_3, _830_4, _830_5) end)
game:GetService('Players')
game:GetService('SoundService')

local _ = game:GetService('Players').LocalPlayer

fenv.playKickSound = function(_840, _840_2, _840_3) end
fenv.notifyKick = function(_841, _841_2, _841_3, _841_4, _841_5, _841_6, _841_7) end
fenv.getClosestPlayer = function(_842, _842_2) end

game:GetService('Workspace').ChildAdded:Connect(function(_846, _846_2) end)

local _call848 = _call38:CreateBlock({
    Name = 'Troll',
    Side = 'Left',
})

game:GetService('Players')

local _ = Enum.KeyCode.Q

fenv.startJerkOff = function(_855, _855_2) end
fenv.stopJerkOff = function(_856, _856_2, _856_3, _856_4, _856_5) end

_call848:CreateToggle({
    Flag = 'CoconutOrbit',
    Callback = function(_859, _859_2, _859_3, _859_4, _859_5, _859_6) end,
    Name = 'Coconut Penis',
    Default = false,
})
_call848:CreateToggle({
    Flag = 'Jerk Off',
    Callback = function(_862, _862_2) end,
    Name = 'Jerk Off',
    Default = false,
})
_call848:CreateDropdown({
    Items = {
        [1] = 'Q',
        [2] = 'E',
        [3] = 'R',
        [4] = 'T',
    },
    Name = 'Toggle Key',
    Flag = 'Toggle Key',
    Callback = function(_865) end,
    Default = 'Q',
})
game:GetService('UserInputService').InputBegan:Connect(function(_869, _869_2, _869_3, _869_4, _869_5) end)
_call489:CreateDropdown({
    Items = {
        [1] = '10',
        [2] = '12',
        [3] = '14',
        [4] = '16',
        [5] = '18',
        [6] = '20',
    },
    Name = 'Anti Kick Aura Radius',
    Flag = 'Anti Kick Aura Radius',
    Callback = function(_872, _872_2, _872_3, _872_4) end,
    Default = '15',
})
_call489:CreateToggle({
    Flag = 'Remove Anti Kick Aura',
    Callback = function(_875, _875_2, _875_3, _875_4, _875_5, _875_6) end,
    Name = 'Remove Anti Kick Aura',
    Default = false,
})

local _call877 = _call38:CreateBlock({
    Name = 'Build',
    Side = 'Right',
})

_call877:CreateToggle({
    Flag = 'Heart',
    Callback = function(_880, _880_2, _880_3, _880_4, _880_5) end,
    Name = 'Heart',
    Default = false,
})

local _call882 = _call40:CreateBlock({
    Name = 'Keybinds',
    Side = 'Left',
})

game:GetService('Players').LocalPlayer:GetMouse()
_call882:CreateKeybind({
    Flag = 'TPKeybind',
    Callback = function(_890) end,
    Name = 'Teleport to Mouse',
    Default = 'X',
})
game:GetService('RunService')
game:GetService('ReplicatedStorage')

local _ = game:GetService('Players').LocalPlayer

game:GetService('RunService')
game:GetService('ReplicatedStorage')

local _ = game:GetService('Players').LocalPlayer

_call882:CreateKeybind({
    Flag = 'DogPoseKey',
    Callback = function(_907, _907_2, _907_3, _907_4) end,
    Name = 'Dog Pose Quick V1',
    Default = 'T',
})
_call882:CreateKeybind({
    Flag = 'DogPoseKey',
    Callback = function(_910, _910_2, _910_3) end,
    Name = 'Dog Pose Quick V2',
    Default = 'T',
})

local _call912 = _call34:CreateBlock({
    Name = 'Figure Grab Main',
    Side = 'Left',
})
local _call914 = _call34:CreateBlock({
    Name = 'Figure Poses',
    Side = 'Right',
})
local _call916 = _call34:CreateBlock({
    Name = 'Limb Offsets',
    Side = 'Right',
})
local _917 = genv.FigureGrabModule

genv.FigureGrabModule = _917

local _ = genv.FigureGrabModule

_917.Players = game:GetService('Players')
_917.RunService = game:GetService('RunService')
_917.ReplicatedStorage = game:GetService('ReplicatedStorage')
_917.UserInputService = game:GetService('UserInputService')
_917.LocalPlayer = _917.Players.LocalPlayer
_917.Mouse = _917.LocalPlayer:GetMouse()
_917.GrabEvents = _917.ReplicatedStorage:WaitForChild('GrabEvents')
_917.SetNetworkOwner = _917.GrabEvents:WaitForChild('SetNetworkOwner')
_917.MenuToys = _917.ReplicatedStorage:WaitForChild('MenuToys')
_917.ToySpawn = _917.MenuToys:WaitForChild('SpawnToyRemoteFunction')
_917.DestroyToy = _917.MenuToys:WaitForChild('DestroyToy')
_917.State = {
    SeveralEnabled = false,
    FigureGrabEnabled = false,
    AutoRagdollEnabled = false,
    SeveralTargets = {},
    AutoRagdollToggle = false,
    VectorZero = Vector3.new(0, 0, 0),
    AnimationCopyEnabled = false,
}
_917.Configuration = {
    LineDistance = 0,
    RightArmRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    RightLegPosition = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    LeftArmPosition = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    RightLegRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    RightArmPosition = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    LeftArmRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    HeadRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    HoldRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    HoldPosition = {
        Y = 0,
        X = 0,
        Z = -5,
    },
    HeadPosition = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    LeftLegPosition = {
        Y = 0,
        X = 0,
        Z = 0,
    },
    LeftLegRotation = {
        Y = 0,
        X = 0,
        Z = 0,
    },
}
_917.Presets = {
    Pose2 = {
        RightArmRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        RightLegPosition = {
            Y = -1,
            X = -1,
            Z = -0.5,
        },
        LeftArmPosition = {
            Y = 1,
            X = -1,
            Z = -0.5,
        },
        RightLegRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        RightArmPosition = {
            Y = 1,
            X = 1,
            Z = -0.5,
        },
        LeftArmRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        HeadRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 272,
            Z = 0,
        },
        HoldPosition = {
            Y = -1.5,
            X = 0,
            Z = -12.5,
        },
        HeadPosition = {
            Y = 1,
            X = 0,
            Z = 1,
        },
        LeftLegPosition = {
            Y = -1,
            X = 1,
            Z = -0.5,
        },
        LeftLegRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
    },
    JojoStand = {
        RightArmRotation = {
            Y = 149,
            X = 65,
            Z = 6,
        },
        RightLegPosition = {
            Y = -2,
            X = 0.5,
            Z = 0,
        },
        LeftArmPosition = {
            Y = 0,
            X = 1.5,
            Z = 0,
        },
        RightLegRotation = {
            Y = 360,
            X = 345,
            Z = 10,
        },
        RightArmPosition = {
            Y = 0.5,
            X = -1.5,
            Z = -0.5,
        },
        LeftArmRotation = {
            Y = 62,
            X = 15,
            Z = 41,
        },
        HeadRotation = {
            Y = 344,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 349,
            X = 8,
            Z = 0,
        },
        HoldPosition = {
            Y = 0.5,
            X = -4.5,
            Z = -1.5,
        },
        HeadPosition = {
            Y = 1.5,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = -2,
            X = -0.5,
            Z = 0,
        },
        LeftLegRotation = {
            Y = 0,
            X = 349,
            Z = 360,
        },
    },
    Pose7 = {
        RightArmRotation = {
            Y = 0,
            X = 270,
            Z = 45,
        },
        RightLegPosition = {
            Y = -1.5,
            X = 1,
            Z = 0,
        },
        LeftArmPosition = {
            Y = 0,
            X = -1.5,
            Z = 0,
        },
        RightLegRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        RightArmPosition = {
            Y = 0,
            X = 1.5,
            Z = 0,
        },
        LeftArmRotation = {
            Y = 0,
            X = 270,
            Z = 315,
        },
        HeadRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
        HoldPosition = {
            Y = -2,
            X = 0,
            Z = -10,
        },
        HeadPosition = {
            Y = 1.5,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = -1.5,
            X = -1,
            Z = 0,
        },
        LeftLegRotation = {
            Y = 0,
            X = 90,
            Z = 0,
        },
    },
    Pose5 = {
        RightArmRotation = {
            Y = 0,
            X = 180,
            Z = 0,
        },
        RightLegPosition = {
            Y = -2,
            X = 0,
            Z = 0.5,
        },
        LeftArmPosition = {
            Y = 0.5,
            X = -1,
            Z = 0,
        },
        RightLegRotation = {
            Y = 0,
            X = 45,
            Z = 0,
        },
        RightArmPosition = {
            Y = 0.5,
            X = 1,
            Z = 0,
        },
        LeftArmRotation = {
            Y = 0,
            X = 180,
            Z = 0,
        },
        HeadRotation = {
            Y = 0,
            X = 270,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 270,
            Z = 0,
        },
        HoldPosition = {
            Y = -3,
            X = 0,
            Z = -6,
        },
        HeadPosition = {
            Y = 1.5,
            X = 0,
            Z = -0.5,
        },
        LeftLegPosition = {
            Y = -3,
            X = 0,
            Z = 0,
        },
        LeftLegRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
    },
    Pose1 = {
        RightArmRotation = {
            Y = 0,
            X = 270,
            Z = 0,
        },
        RightLegPosition = {
            Y = -1.5,
            X = -0.5,
            Z = 0.5,
        },
        LeftArmPosition = {
            Y = 1,
            X = -1.5,
            Z = -1,
        },
        RightLegRotation = {
            Y = 0,
            X = 283,
            Z = 0,
        },
        RightArmPosition = {
            Y = 0.5,
            X = 1.5,
            Z = 1,
        },
        LeftArmRotation = {
            Y = 0,
            X = 283,
            Z = 0,
        },
        HeadRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 90,
            Z = 108,
        },
        HoldPosition = {
            Y = 0,
            X = 0,
            Z = -7.5,
        },
        HeadPosition = {
            Y = 1.5,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = -1.5,
            X = 0.5,
            Z = 0.5,
        },
        LeftLegRotation = {
            Y = 0,
            X = 312,
            Z = 0,
        },
    },
    Pose6 = {
        RightArmRotation = {
            Y = 112,
            X = 64,
            Z = 0,
        },
        RightLegPosition = {
            Y = -2,
            X = 0.5,
            Z = 0,
        },
        LeftArmPosition = {
            Y = 0.5,
            X = 2,
            Z = 0,
        },
        RightLegRotation = {
            Y = 360,
            X = 345,
            Z = 10,
        },
        RightArmPosition = {
            Y = 0,
            X = -2,
            Z = 0,
        },
        LeftArmRotation = {
            Y = 43,
            X = 0,
            Z = 121,
        },
        HeadRotation = {
            Y = 344,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 39,
            X = 345,
            Z = 0,
        },
        HoldPosition = {
            Y = 0.5,
            X = 5.5,
            Z = -1.5,
        },
        HeadPosition = {
            Y = 1.5,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = -2,
            X = -0.5,
            Z = 0,
        },
        LeftLegRotation = {
            Y = 0,
            X = 349,
            Z = 360,
        },
    },
    Pose3 = {
        RightArmRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        RightLegPosition = {
            Y = 5,
            X = -0.5,
            Z = 1.5,
        },
        LeftArmPosition = {
            Y = 7.5,
            X = 1,
            Z = 1.5,
        },
        RightLegRotation = {
            Y = 0,
            X = 0,
            Z = 90,
        },
        RightArmPosition = {
            Y = 6,
            X = 1,
            Z = 1.5,
        },
        LeftArmRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HeadRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldPosition = {
            Y = -5.5,
            X = 0,
            Z = -4,
        },
        HeadPosition = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = 5,
            X = 0.5,
            Z = 1.5,
        },
        LeftLegRotation = {
            Y = 0,
            X = 0,
            Z = 92,
        },
    },
    Pose4 = {
        RightArmRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        RightLegPosition = {
            Y = 0,
            X = 1.5,
            Z = 0,
        },
        LeftArmPosition = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        RightLegRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        RightArmPosition = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        LeftArmRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HeadRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        HoldPosition = {
            Y = -8.5,
            X = 1.5,
            Z = -1.5,
        },
        HeadPosition = {
            Y = 9,
            X = 0,
            Z = 0,
        },
        LeftLegPosition = {
            Y = 0,
            X = 0,
            Z = 0,
        },
        LeftLegRotation = {
            Y = 0,
            X = 0,
            Z = 0,
        },
    },
}
_917.GetCharacter = function(_949, _949_2, _949_3, _949_4, _949_5) end
_917.CopyAnimationsFromLimbs = function(_950, _950_2, _950_3, _950_4, _950_5) end
_917.ToggleAutoRagdoll = function(_951, _951_2, _951_3, _951_4, _951_5) end
_917.ToggleFigureGrab = function(_952, _952_2) end
_917.ResetPose = function(_953) end
_917.ApplyPreset = function(_954, _954_2, _954_3, _954_4) end
_917.UpdateConfig = function(_955, _955_2, _955_3, _955_4) end

_call912:CreateKeybind({
    Flag = 'FG_ToggleKeybind',
    Callback = function() end,
    Name = 'Toggle Figure Grab (Aim at target)',
    Default = 'V',
})
_call912:CreateToggle({
    Flag = 'FG_AutoRagdollToggle',
    Callback = function(_961, _961_2, _961_3) end,
    Name = 'Auto Ragdoll Target',
    Default = false,
})
_call912:CreateToggle({
    Flag = 'FG_AnimCopyToggle',
    Callback = function(_964) end,
    Name = 'Copy My Animations to Target',
    Default = false,
})
_call914:CreateButton({
    Name = 'Reset Pose',
    Callback = function(_967, _967_2, _967_3, _967_4) end,
})
_call914:CreateButton({
    Name = 'Pose 1 Jesus',
    Callback = function(_970, _970_2, _970_3, _970_4, _970_5) end,
})
_call914:CreateButton({
    Name = 'Pose 2 Dog',
    Callback = function(_973, _973_2, _973_3, _973_4, _973_5) end,
})
_call914:CreateButton({
    Name = 'Pose 3 L',
    Callback = function(_976, _976_2, _976_3) end,
})
_call914:CreateButton({
    Name = 'Pose 4 Head Hold',
    Callback = function(_979, _979_2, _979_3) end,
})
_call914:CreateButton({
    Name = 'Pose 5 Handstand',
    Callback = function(_982) end,
})
_call914:CreateButton({
    Name = 'Pose 6 Stand 1',
    Callback = function() end,
})
_call914:CreateButton({
    Name = 'Pose 7 T-Pose',
    Callback = function(_988, _988_2, _988_3, _988_4) end,
})
_call914:CreateButton({
    Name = 'Pose 8 Stand 2',
    Callback = function() end,
})
_call916:CreateSlider({
    Min = -50,
    Name = 'Hold (Torso) Pos X',
    Default = 0,
    Flag = 'FG_HoldPosX',
    Max = 50,
    Callback = function(_994) end,
    Rounding = 1,
})
-- нам дальше не интересен этот файл слишком скид 
