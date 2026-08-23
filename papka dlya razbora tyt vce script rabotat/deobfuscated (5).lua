-- By FTAP Reverse
-- t.me/ReverseFTAP

local Env = getfenv();
local O = {};
r = game;
r = game;
v4 = r.GetService(r, "ReplicatedStorage");
r = game;
r24 = r.GetService(r, "Workspace");
v2 = game;
r25 = v2.GetService(v2, "RunService");
v6 = game;
r26 = v6.GetService(v6, "TweenService");
Q = game;
Q.GetService(Q, "UserInputService");
r27 = r.GetService(r, "Players").LocalPlayer;
Q = v4.MenuToys;
r28 = Q.WaitForChild(Q, "SpawnToyRemoteFunction");
m = v4.MenuToys;
r29 = m.WaitForChild(m, "DestroyToy");
v8 = v4.GrabEvents;
r30 = v8.WaitForChild(v8, "CreateGrabLine");
getgenv().SpawningActive = false;
getgenv().CurrentToyName = "";
getgenv().DespawnDelay = 1;
getgenv().TrackingSpeed = 20;
getgenv().ZoneWidth = 44;
getgenv().ZoneColor = Color3.fromRGB(0, 0, 0);
getgenv().SelectedMode = "Flick";
v9 = r24;
r31 = v9.FindFirstChild(v9, "FlingSpawnerBoard");
h = r31;
if h then
    h = r31;
    h.Destroy(h);
end;
r31 = Instance.new("Part");
r31.Name = "FlingSpawnerBoard";
r31.Anchored = true;
r31.CanCollide = false;
r31.Transparency = 1;
r31.Size = Vector3.new(1, 14, 10);
r31.CFrame = CFrame.new(144, 4.5, -30);
r31.Parent = r24;
c = Instance.new("SurfaceGui");
c.Name = "ControlPanelGUI";
c.Face = Enum.NormalId.Right;
c.CanvasSize = Vector2.new(600, 900);
c.Adornee = r31;
c.LightInfluence = 0;
c.Parent = r31;
r32 = Instance.new("Frame");
r32.Size = UDim2.new(1, 0, 1, 0);
r32.BackgroundColor3 = Color3.fromRGB(25, 25, 30);
r32.BackgroundTransparency = .1;
r32.Parent = c;
F = Instance.new("UIStroke");
F.Thickness = 10;
F.Color = Color3.fromRGB(50, 50, 55);
F.Parent = r32;
J = Instance.new("TextLabel");
J.Text = "Training Menu";
J.Size = UDim2.new(1, 0, 0, 80);
J.BackgroundColor3 = Color3.fromRGB(35, 35, 40);
J.TextColor3 = Color3.fromRGB(52, 152, 219);
J.Font = Enum.Font.GothamBold;
J.TextSize = 40;
J.Parent = r32;
local function r35(...)
    v10 = r33;
    if v10 then
        r33.Size = Vector3.new(1, 22, getgenv().ZoneWidth);
        r33.CFrame = CFrame.new(172.5, 2.5, -30);
        v10 = r33;
        if v10.FindFirstChild(v10, "ZoneBox") then
            r33.ZoneBox.SurfaceColor3 = getgenv().ZoneColor;
        end;
    end;
    return; 
end;
local function r36(arg1_2, ...)
    if r33 then
        v10 = r33;
        v10.Destroy(v10);
    end;
    if arg1_2 then
        q = Instance.new("Part");
        q.Name = "SpawnZoneVisual_NoGrab";
        q.Anchored = true;
        q.CanCollide = false;
        q.CanTouch = false;
        q.CanQuery = false;
        q.Transparency = 1;
        q.CastShadow = false;
        q.Size = Vector3.new(1, 22, getgenv().ZoneWidth);
        q.CFrame = CFrame.new(172.5, 2.5, -30);
        q.Parent = r24;
        r = Instance.new("SelectionBox");
        r.Name = "ZoneBox";
        r.Adornee = q;
        r.Color3 = Color3.fromRGB(255, 255, 255);
        r.LineThickness = .06;
        r.Transparency = 0;
        r.SurfaceColor3 = getgenv().ZoneColor;
        r.SurfaceTransparency = 0;
        r.Parent = q;
        r33 = q;
    end;
    return; 
end;
local function r37(...)
    if r34 then
        v10 = r34;
        v10.Destroy(v10);
    else
        v1 = Instance.new("Part");
        v1.Name = "AimTrainingPlatform";
        v1.Anchored = true;
        v1.CanCollide = true;
        v1.Material = Enum.Material.Grass;
        v1.Transparency = 0.5;
        v1.Size = Vector3.new(15, 1, 20);
        v1.CFrame = CFrame.new(152, -3.5, -30);
        v1.Material = Enum.Material.Neon;
        v1.Color = Color3.fromRGB(40, 40, 45);
        v1.Parent = r24;
        r34 = v1;
        q = r27.Character;
        if q then
            r = q.FindFirstChild(q, "HumanoidRootPart");
        end;
        v10 = r34;
        if q then
            q.CFrame = CFrame.new(152, 0, -30) * CFrame.Angles(0, math.rad(-90), 0);
        end;
        return;
    end; 
end;
local function r38(arg1_3, ...)
    r39 = arg1_3;
    getgenv().SpawningActive = true;
    getgenv().CurrentToyName = r39;
    r40 = getgenv().SelectedMode;
    task.spawn(function(...)
        v1 = getgenv().SpawningActive;
        v3 = getgenv().CurrentToyName == r39;
        while not v1 do
            if v3 then
                v1 = Random.new();
                r41 = v1.NextNumber(v1, -7.5, 12.5);
                r = getgenv().ZoneWidth / 2 - 2;
                G = -30;
                r42 = G - r;
                r43 = G + r;
                v10 = r42 > r43;
                if v10 then
                    r42 = r43;
                end;
                r44 = v1.NextNumber(v1, r42, r43);
                r45 = v1.NextInteger(v1, 0, 1) == 0 and -1 or 1;
                r46 = CFrame.new(172, r41, r44) * CFrame.Angles(0, -1.5, -3);
                v3 = r28;
                v3.InvokeServer(v3, unpack({
                    [1] = r39,
                    [2] = r46,
                    [3] = Vector3.new(0, 0, 0)
                }));
                v3 = r24;
                L = v3.WaitForChild(v3, r27.Name .. "SpawnedInToys", 5);
                if L then
                    r47 = L.WaitForChild(L, r39, 3);
                    if r47 then
                        v8 = O[d] > O[v4];
                        v9 = r47;
                        h = v9.FindFirstChild(v9, "SoundPart");
                        v3 = h;
                        if h then
                            v10 = v10;
                            r48 = h;
                            if r48 then
                                tick();
                                r49 = tick();
                                v3 = r25.RenderStepped;
                                r50 = v3.Connect(v3, function(...)
                                    if not r47 or not r47.Parent then
                                        v10 = r50;
                                        v10.Disconnect(v10);
                                        return;
                                    end;
                                    v1 = tick();
                                    r49 = v1;
                                    if r40 == "Tracking" then
                                        r44 = r44 + r45 * getgenv().TrackingSpeed * (v1 - r49);
                                        if r44 > r43 then
                                            r44 = r43 - (r44 - r43);
                                            r45 = -1;
                                        else
                                            if r44 < r42 then
                                                r44 = r42 + r42 - r44;
                                                r45 = 1;
                                            end;
                                            r48.CFrame = CFrame.new(172, r41, r44) * CFrame.Angles(0, -1.5, -3);
                                        end;
                                    else
                                        r48.CFrame = r46;
                                    end;
                                    r48.AssemblyLinearVelocity = Vector3.zero;
                                    r48.AssemblyAngularVelocity = Vector3.zero;
                                    r48.Anchored = true;
                                    return; 
                                end);
                                E = r48;
                                F = {
                                    E.GetChildren(E)
                                };
                                c = E[2];
                                B = E[1];
                                for D, F in pairs(o(F)) do
                                    E = D;
                                    v10 = v10;
                                    if F.IsA(F, "BodyPosition") or F.IsA(F, "AlignPosition") then
                                        F.Destroy(F);
                                    end; 
                                end;
                                v3 = r30;
                                v3.FireServer(v3, r48, CFrame.new());
                                task.wait(getgenv().DespawnDelay);
                                c = r47;
                                v3 = c;
                                if c then
                                    v3 = r47.Parent;
                                end;
                                v10 = v10;
                                if v3 then
                                    v3 = r40;
                                    v3.FireServer(v3, r47);
                                    v3 = r47;
                                    v3.Destroy(v3);
                                end;
                                v3 = r50;
                                if v3 then
                                    v3 = r50;
                                    v3.Disconnect(v3);
                                end;
                                task.wait(.1);
                            end;
                        end;
                    end;
                end;
            end;
            return; 
        end;
        v3 = getgenv().CurrentToyName == r39; 
    end);
    return; 
end;
local function r51(...)
    getgenv().SpawningActive = false;
    return; 
end;
local function Z(arg1_4, arg2_4, arg3_4, arg4_4, ...)
    r52 = arg4_4;
    r53 = Instance.new("TextButton");
    r53.Size = UDim2.new(.9, 0, 0, 50);
    r53.Position = UDim2.new(.05, 0, 0, arg3_4);
    v4 = arg2_4;
    r53.BackgroundColor3 = v4;
    v4 = arg1_4;
    r53.Text = v4;
    r53.TextColor3 = Color3.fromRGB(255, 255, 255);
    r53.Font = Enum.Font.GothamSemibold;
    r53.TextSize = 24;
    r53.Parent = r32;
    Instance.new("UICorner", r53).CornerRadius = UDim.new(0, 10);
    v10 = r53.MouseButton2Click;
    v10.Connect(v10, function(...)
        v10 = r26;
        v3 = v10.Create(v10, r53, TweenInfo.new(.1), {
            ["Size"] = UDim2.new(.85, 0, 0, 45)
        });
        v3.Play(v3);
        task.wait(.1);
        v10 = r26;
        v3 = v10.Create(v10, r53, TweenInfo.new(.1), {
            ["Size"] = UDim2.new(.9, 0, 0, 50)
        });
        v3.Play(v3);
        r52();
        return; 
    end);
    return r53; 
end;
TE = Instance.new("TextLabel");
TE.Text = "Select mode (Right Mouse Click)";
TE.Size = UDim2.new(1, 0, 0, 30);
TE.Position = UDim2.new(0, 0, 0, 90);
TE.BackgroundTransparency = 1;
TE.TextColor3 = Color3.fromRGB(200, 200, 200);
TE.Font = Enum.Font.GothamBold;
TE.TextSize = 18;
TE.Parent = r32;
zE = Instance.new("Frame");
zE.Size = UDim2.new(.9, 0, 0, 50);
zE.Position = UDim2.new(.05, 0, 0, 120);
zE.BackgroundTransparency = 1;
zE.Parent = r32;
r54 = Instance.new("TextButton");
r54.Size = UDim2.new(.48, 0, 1, 0);
r54.BackgroundColor3 = Color3.fromRGB(52, 152, 219);
r54.Text = "\xf0\x9f\x8e\xaf Flick";
r54.TextColor3 = Color3.fromRGB(255, 255, 255);
r54.Font = Enum.Font.GothamBold;
r54.TextSize = 22;
r54.Parent = zE;
Instance.new("UICorner", r54).CornerRadius = UDim.new(0, 8);
r55 = Instance.new("TextButton");
r55.Size = UDim2.new(.48, 0, 1, 0);
r55.Position = UDim2.new(.52, 0, 0, 0);
r55.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
r55.Text = "\xf0\x9f\x92\xa8 Tracking";
r55.TextColor3 = Color3.fromRGB(150, 150, 150);
r55.Font = Enum.Font.GothamBold;
r55.TextSize = 22;
r55.Parent = zE;
Instance.new("UICorner", r55).CornerRadius = UDim.new(0, 8);
local function r56(...)
    if getgenv().SelectedMode == "Flick" then
        r54.BackgroundColor3 = Color3.fromRGB(52, 152, 219);
        r54.TextColor3 = Color3.fromRGB(255, 255, 255);
        r55.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
        r55.TextColor3 = Color3.fromRGB(150, 150, 150);
    else
        r55.BackgroundColor3 = Color3.fromRGB(52, 152, 219);
        r55.TextColor3 = Color3.fromRGB(255, 255, 255);
        r54.BackgroundColor3 = Color3.fromRGB(60, 60, 65);
        r54.TextColor3 = Color3.fromRGB(150, 150, 150);
    end;
    return; 
end;
WE = r54.MouseButton2Click;
WE.Connect(WE, function(...)
    getgenv().SelectedMode = "Flick";
    r56();
    return; 
end);
WE = r55.MouseButton2Click;
WE.Connect(WE, function(...)
    getgenv().SelectedMode = "Tracking";
    r56();
    return; 
end);
Z("\xf0\x9f\x9f\xa2 Easy", Color3.fromRGB(46, 204, 113), 190, function(...)
    r51();
    task.wait(.1);
    r38("BallSnowball");
    return; 
end);
Z("\xf0\x9f\x9f\xa0 Medium", Color3.fromRGB(243, 156, 18), 190 + 60, function(...)
    r51();
    task.wait(.1);
    r38("FactoryLight");
    return; 
end);
Z("\xf0\x9f\x94\xb4 Hard", Color3.fromRGB(231, 76, 60), 190 + 120, function(...)
    r51();
    task.wait(.1);
    r38("FireworkSmokeBomb");
    return; 
end);
KE = 190 + 190;
r57 = Instance.new("TextLabel");
r57.Text = "Lifetime: 1.0s";
r57.Size = UDim2.new(1, 0, 0, 25);
r57.Position = UDim2.new(0, 0, 0, KE);
r57.BackgroundTransparency = 1;
r57.TextColor3 = Color3.fromRGB(200, 200, 200);
r57.Font = Enum.Font.GothamBold;
r57.TextSize = 20;
r57.Parent = r32;
r58 = Instance.new("Frame");
r58.Size = UDim2.new(.9, 0, 0, 14);
r58.Position = UDim2.new(.05, 0, 0, KE + 30);
r58.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
r58.Parent = r32;
Instance.new("UICorner", r58);
r59 = Instance.new("Frame");
r59.Size = UDim2.new(.2, 0, 1, 0);
r59.BackgroundColor3 = Color3.fromRGB(52, 152, 219);
r59.Parent = r58;
Instance.new("UICorner", r59);
pE = Instance.new("TextButton");
pE.Text = "";
pE.BackgroundTransparency = 1;
pE.Size = UDim2.new(1, 0, 1, 0);
pE.Parent = r58;
PE = pE.InputBegan;
PE.Connect(PE, function(arg1_5, ...)
    v1 = arg1_5;
    if v1.UserInputType == Enum.UserInputType.MouseButton2 then
        d = math.clamp((v1.Position.X - r58.AbsolutePosition.X) / r58.AbsoluteSize.X, 0, 1);
        v4 = math.floor((0.5 + 2.5 * d) / .1 + 0.5) * .1;
        r59.Size = UDim2.new(d, 0, 1, 0);
        v6 = math.floor((0.5 + 2.5 * d) / .1 + 0.5) * .1;
        getgenv().DespawnDelay = v6;
        r57.Text = string.format("Lifetime: %.1fs", v4);
    end;
    return; 
end);
r60 = Instance.new("TextLabel");
r60.Text = "Speed: 20 SPS";
r60.Size = UDim2.new(1, 0, 0, 25);
r60.Position = UDim2.new(0, 0, 0, KE + 60);
r60.BackgroundTransparency = 1;
r60.TextColor3 = Color3.fromRGB(241, 196, 15);
r60.Font = Enum.Font.GothamBold;
r60.TextSize = 20;
r60.Parent = r32;
r61 = Instance.new("Frame");
r61.Size = UDim2.new(.9, 0, 0, 14);
r61.Position = UDim2.new(.05, 0, 0, KE + 90);
r61.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
r61.Parent = r32;
Instance.new("UICorner", r61);
r62 = Instance.new("Frame");
r62.Size = UDim2.new(.6, 0, 1, 0);
r62.BackgroundColor3 = Color3.fromRGB(241, 196, 15);
r62.Parent = r61;
Instance.new("UICorner", r62);
nE = Instance.new("TextButton");
nE.Text = "";
nE.BackgroundTransparency = 1;
nE.Size = UDim2.new(1, 0, 1, 0);
nE.Parent = r61;
GE = nE.InputBegan;
GE.Connect(GE, function(arg1_6, ...)
    v1 = arg1_6;
    if v1.UserInputType == Enum.UserInputType.MouseButton2 then
        d = math.clamp((v1.Position.X - r61.AbsolutePosition.X) / r61.AbsoluteSize.X, 0, 1);
        v4 = math.floor(5 + 25 * d);
        r62.Size = UDim2.new(d, 0, 1, 0);
        v6 = math.floor(5 + 25 * d);
        getgenv().TrackingSpeed = v6;
        r60.Text = string.format("Speed: %d SPS", v4);
    end;
    return; 
end);
r63 = Instance.new("TextLabel");
r63.Text = "Zone width: 44";
r63.Size = UDim2.new(1, 0, 0, 25);
r63.Position = UDim2.new(0, 0, 0, KE + 120);
r63.BackgroundTransparency = 1;
r63.TextColor3 = Color3.fromRGB(155, 89, 182);
r63.Font = Enum.Font.GothamBold;
r63.TextSize = 20;
r63.Parent = r32;
r64 = Instance.new("Frame");
r64.Size = UDim2.new(.9, 0, 0, 14);
r64.Position = UDim2.new(.05, 0, 0, KE + 150);
r64.BackgroundColor3 = Color3.fromRGB(40, 40, 45);
r64.Parent = r32;
Instance.new("UICorner", r64);
r65 = Instance.new("Frame");
r65.Size = UDim2.new(1, 0, 1, 0);
r65.BackgroundColor3 = Color3.fromRGB(155, 89, 182);
r65.Parent = r64;
Instance.new("UICorner", r65);
kE = Instance.new("TextButton");
kE.Text = "";
kE.BackgroundTransparency = 1;
kE.Size = UDim2.new(1, 0, 1, 0);
kE.Parent = r64;
vE = kE.InputBegan;
vE.Connect(vE, function(arg1_7, ...)
    v1 = arg1_7;
    if v1.UserInputType == Enum.UserInputType.MouseButton2 then
        d = math.clamp((v1.Position.X - r64.AbsolutePosition.X) / r64.AbsoluteSize.X, 0, 1);
        v4 = math.floor(22 + 22 * d);
        r65.Size = UDim2.new(d, 0, 1, 0);
        v6 = math.floor(22 + 22 * d);
        getgenv().ZoneWidth = v6;
        r63.Text = string.format("Zone width: %d", v4);
        r35();
    end;
    return; 
end);
xE = Instance.new("Frame");
xE.Size = UDim2.new(.9, 0, 0, 40);
xE.Position = UDim2.new(.05, 0, 0, KE + 180);
xE.BackgroundTransparency = 1;
xE.Parent = r32;
sE = Instance.new("UIListLayout");
sE.FillDirection = Enum.FillDirection.Horizontal;
sE.HorizontalAlignment = Enum.HorizontalAlignment.Center;
sE.Padding = UDim.new(0, 15);
sE.Parent = xE;
uE = Color3.fromRGB(52, 152, 219);
aE = Color3.fromRGB(155, 89, 182);
ME = uE[3];
for ME, uE in uE[1], pairs({
    Color3.fromRGB(0, 0, 0),
    Color3.fromRGB(231, 76, 60),
    Color3.fromRGB(46, 204, 113),
    uE,
    aE,
    Color3.fromRGB(241, 196, 15)
}) do
    VE = ME;
    r66 = uE;
    mE = Instance.new("TextButton");
    mE.Text = "";
    mE.Size = UDim2.new(0, 40, 0, 40);
    mE.BackgroundColor3 = r66;
    LE = Instance.new("Frame");
    mE.Parent = LE;
    Instance.new("UICorner", mE).CornerRadius = UDim.new(1, 0);
    aE = mE.MouseButton2Click;
    aE.Connect(aE, function(...)
        getgenv().ZoneColor = r66;
        r35();
        return; 
    end); 
end;
VE = KE + 240;
Z("\xf0\x9f\x91\x81 Toggle zone", Color3.fromRGB(52, 152, 219), VE, function(...)
    if r33 then
        r36(false);
    else
        r36(true);
    end;
    return; 
end);
Z("\xf0\x9f\xa7\x8d Toggle platform", Color3.fromRGB(142, 68, 173), VE + 60, function(...)
    r37();
    return; 
end);
yE = Instance.new("TextLabel");
yE.Text = "\xd0\x92\xd1\x81\xd1\x82\xd0\xb0\xd0\xb2\xd1\x8c\xd1\x82\xd0\xb5 \xd1\x81\xd1\x8e\xd1\x80\xd0\xb8\xd0\xba\xd0\xb5\xd0\xbd \xd0\xbf\xd0\xbe\xd0\xb4 \xd0\xbd\xd0\xbe\xd0\xb3\xd0\xb8 \xd1\x87\xd1\x82\xd0\xbe\xd0\xb1\xd1\x8b \xd0\xbd\xd0\xb5 \xd1\x82\xd0\xb5\xd0\xbb\xd0\xb5\xd0\xbf\xd0\xbe\xd1\x80\xd1\x82\xd0\xb8\xd1\x80\xd0\xbe\xd0\xb2\xd0\xb0\xd0\xbb\xd0\xbe";
yE.Size = UDim2.new(1, 0, 0, 20);
yE.Position = UDim2.new(0, 0, 0, VE + 115);
yE.BackgroundTransparency = 1;
yE.TextColor3 = Color3.fromRGB(150, 150, 150);
yE.Font = Enum.Font.GothamBold;
yE.TextSize = 14;
yE.Parent = r32;
Z("\xe2\x9b\x94 Stop spawn", Color3.fromRGB(127, 140, 141), VE + 140, function(...)
    r51();
    return; 
end);
Z("\xe2\x9d\x8c Delete GUI", Color3.fromRGB(192, 57, 43), VE + 200, function(...)
    r51();
    v10 = r33;
    if v10 then
        v10 = r33;
        v10.Destroy(v10);
    end;
    v10 = r34;
    if v10 then
        v10 = r34;
        v10.Destroy(v10);
    end;
    v10 = r31;
    if v10 then
        v10 = r31;
        v10.Destroy(v10);
    end;
    return; 
end);
r37();
return;
end;
end;
