-- By FTAP Reverse
-- t.me/ReverseFTAP

local Env = getfenv();
local J = {};
N = game;
m = N.GetService(N, "CoreGui");
N = m.FindFirstChild(m, "CUCUMBER_HUB");
if N then
    N = m.CUCUMBER_HUB;
    N.Destroy(N);
end;
r24 = Instance.new("ScreenGui");
r24.Name = "CUCUMBER_HUB";
r24.ResetOnSpawn = false;
r24.DisplayOrder = 999999;
r24.ZIndexBehavior = Enum.ZIndexBehavior.Global;
r24.Parent = m;
r25 = Instance.new("Frame");
r25.Size = UDim2.new(0, 380, 0, 240);
r25.Position = UDim2.new(0.5, -190, 0.5, -120);
r25.BackgroundColor3 = Color3.fromRGB(8, 18, 12);
r25.BorderSizePixel = 0;
r25.Parent = r24;
Instance.new("UICorner", r25).CornerRadius = UDim.new(0, 12);
v6 = Instance.new("Frame");
v6.Size = UDim2.new(1, 0, 0, 40);
v6.BackgroundColor3 = Color3.fromRGB(12, 30, 20);
v6.BorderSizePixel = 0;
v6.Parent = r25;
Instance.new("UICorner", v6).CornerRadius = UDim.new(0, 12);
D = Instance.new("TextLabel");
D.Size = UDim2.new(1, 0, 1, 0);
D.BackgroundTransparency = 1;
D.Text = "\xf0\x9f\xa5\x92 CUCUMBER HUB";
D.TextColor3 = Color3.fromRGB(230, 230, 230);
D.Font = Enum.Font.GothamBold;
D.TextSize = 18;
D.Parent = v6;
r26 = Instance.new("Frame");
r26.BackgroundTransparency = 1;
r26.Position = UDim2.new(0, 10, 0, 50);
r26.Size = UDim2.new(1, -20, 1, -60);
r26.Parent = r25;
q = Instance.new("UIListLayout");
q.Padding = UDim.new(0, 8);
q.Parent = r26;
M = game;
r27 = false;
v8 = v6.InputBegan;
v8.Connect(v8, function(arg1_2, ...)
    v1 = arg1_2;
    if v1.UserInputType == Enum.UserInputType.MouseButton1 then
        r27 = true;
        r28 = v1.Position;
        r29 = r25.Position;
    end;
    return; 
end);
v8 = v6.InputEnded;
v8.Connect(v8, function(arg1_3, ...)
    if arg1_3.UserInputType == Enum.UserInputType.MouseButton1 then
        r27 = false;
    end;
    return; 
end);
v8 = M.GetService(M, "UserInputService").InputChanged;
v8.Connect(v8, function(arg1_4, ...)
    v1 = arg1_4;
    if r27 and v1.UserInputType == Enum.UserInputType.MouseMovement then
        G = v1.Position - r28;
        r25.Position = UDim2.new(r29.X.Scale, r29.X.Offset + G.X, r29.Y.Scale, r29.Y.Offset + G.Y);
    end;
    return; 
end);
CreateGame = function(arg1_5, arg2_5, arg3_5, ...)
    G = arg2_5;
    r30 = arg3_5;
    o = Instance.new("TextButton");
    o.Size = UDim2.new(1, 0, 0, 55);
    o.Text = "";
    o.BackgroundColor3 = Color3.fromRGB(18, 55, 38);
    o.BorderSizePixel = 0;
    o.Parent = r26;
    Instance.new("UICorner", o).CornerRadius = UDim.new(0, 10);
    m = Instance.new("TextLabel");
    m.BackgroundTransparency = 1;
    m.Size = UDim2.new(1, -10, 1, 0);
    m.Position = UDim2.new(0, 10, 0, 0);
    m.TextXAlignment = Enum.TextXAlignment.Left;
    v3 = arg1_5;
    m.Text = v3;
    m.TextColor3 = Color3.fromRGB(230, 230, 230);
    m.Font = Enum.Font.GothamBold;
    m.TextSize = 16;
    m.Parent = o;
    v5 = o.MouseButton1Click;
    v5.Connect(v5, function(...)
        v5 = r24;
        v5.Destroy(v5);
        r30();
        return; 
    end);
    return; 
end;
CreateGame("\xf0\x9f\xa5\x92 CUCUMBER HUB\xf0\x9f\xa5\x92", 0, function(...)
    v1 = game;
    loadstring(v1.HttpGet(v1, "https://raw.githubusercontent.com/delivery-2347/script-hub/refs/heads/main/%F0%9F%A5%92%20CUCUMBER%20HUB%20%F0%9F%A5%92"))();
    return; 
end);
CreateGame("\xf0\x9f\xa5\x92 CUCUMBER_ftap HUB \xf0\x9f\xa5\x92", 0, function(...)
    v1 = game;
    loadstring(v1.HttpGet(v1, "https://raw.githubusercontent.com/delivery-2347/script-hub/refs/heads/main/%F0%9F%A5%92%20CUCUMBER_ftap%20HUB%20%F0%9F%A5%92"))();
    return; 
end);
CreateGame("\xf0\x9f\xa5\x92 Cucumber_BEBFT Hub \xf0\x9f\xa5\x92", 0, function(...)
    v1 = game;
    loadstring(v1.HttpGet(v1, "https://raw.githubusercontent.com/delivery-2347/script-hub/refs/heads/main/%F0%9F%A5%92Cucumber_BEBFT%20Hub%F0%9F%A5%92"))();
    return; 
end);
return;
end;
end;
