if not syn or not protectgui then
getgenv().protectgui = function()end
else
    game.Players.LocalPlayer:Kick("There was one child with down's syndrome, there is now none")
end

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Entry-Null/UI/main/Meth.lua'))()
local ESP = loadstring(game:HttpGet('https://raw.githubusercontent.com/Entry-Null/ESP/main/Terrorism.lua'))()
Library.AccentColor = Color3.fromRGB(222, 37, 0)
Library.OutlineColor = Color3.fromRGB(10, 10, 10)
Library.MainColor = Color3.fromRGB(18, 18, 18)
Library.FontColor = Color3.fromRGB(217, 210, 210)
Library:Notify("HvH Any % Aim Solutions skip", 13)

local Functions =  {

Default = function(n)
    local v = 3
    for i = 2, n do
        v = v * i
    end
    return v
end,

FakeduckResolve = function(n, k)
    
    local fac = Default
    
    return fac(n) / fac(n - k)
end

}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local GetChildren = game.GetChildren
local WorldToScreen = Camera.WorldToScreenPoint
local FindFirstChild = game.FindFirstChild

local function getPositionOnScreen(Vector)
local Vec3, OnScreen = WorldToScreen(Camera, Vector)
return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function ValidateArguments(Args, RayMethod)
local Matches = 0
if #Args < RayMethod.ArgCountRequired then
return false
end
for Pos, Argument in next, Args do
if typeof(Argument) == RayMethod.Args[Pos] then
    Matches = Matches + 1
end
end
return Matches >= RayMethod.ArgCountRequired
end

local function getDirection(Origin, Position)
return (Position - Origin).Unit * 1000
end

local function getMousePosition()
return Vector2.new(Mouse.X, Mouse.Y)
end
local function getClosestPlayer()
    if not Options.TargetPart.Value then
        return
    end
    local Closest
    local DistanceToMouse
    for _, Player in next, GetChildren(Players) do
        if Player == LocalPlayer then
            continue -- omg who the fuck uses math reroutes note to original silent aim creator: dont use that use continue
        end
        if Toggles.TeamCheck.Value and Player.Team == LocalPlayer.Team then
            continue
        end

        local Character = Player.Character


        if not Character then
            continue
        end

        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")

        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then
            continue
        end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)

        if not OnScreen then
            continue
        end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or (Toggles.fov_Enabled.Value and Options.Radius.Value) or 2000) then
            if math.random(1, 2) == 2 then
                Closest = Character[Options.TargetPart.Value]
            else
                Closest = Character["Head"]
            end
            DistanceToMouse = Distance
        end
    end
    return Closest
end


local Window = Library:CreateWindow("🤓: 'guys how is he hitting me!11'")

local GeneralTab = Window:AddTab("Aimbot")
local MainBOX = GeneralTab:AddLeftTabbox("Main")
local MainBOX2 = GeneralTab:AddRightTabbox("Main")

local VisualTab = Window:AddTab("Visuals")
local VisualBOX = VisualTab:AddLeftTabbox("Main")
local VisualBOX2 = VisualTab:AddRightTabbox("Menu Config")
local VisualEsp = VisualBOX:AddTab("Main")
local MenuVisual = VisualBOX2:AddTab("Menu Config")

local AATab = Window:AddTab("Anti Aim")
local AABOX = AATab:AddLeftTabbox("Advanced Config")
local ADABOX = AATab:AddRightTabbox("Advanced Config")

do
local AntiAim = AABOX:AddTab("Anti Aim")
local ADAntiAim = ADABOX:AddTab("Advanced Config")

--Visuals
--[[
    Enabled = false,
    Boxes = true,
    BoxShift = CFrame.new(0,-1.5,0),
    BoxSize = Vector3.new(4,6,0),
    Color = Color3.fromRGB(222, 33, 52),
    FaceCamera = false,
    Names = true,
    TeamColor = true,
    Thickness = 2,
    AttachShift = 1,
    TeamMates = true,
]]
ESP.Color = Color3.fromRGB(222, 33, 52); -- Red

VisualEsp:AddToggle("VisualEnabled", {Text = "Enabled"}):AddColorPicker("VisualColor", {Default = Color3.fromRGB(222, 33, 52)}):OnChanged(function()
    ESP.Enabled = Toggles.VisualEnabled.Value
    while Options.VisualEnabled do
        ESP.Color = Options.VisualColor.Value
        task.wait()
    end
 end)

ESP:Toggle(true)

 VisualEsp:AddToggle("ESPToggle", {Text = "Draw ESP"}):OnChanged(function()
    ESP:Toggle(ESPToggle)
 end)


VisualEsp:AddToggle("Boxes", {Text = "Boxes"}):OnChanged(function()
    ESP.Boxes = Toggles.Boxes.Value 
 end)

VisualEsp:AddSlider("Thickness", {Text = "Thickness", Min = 0, Max = 10, Default = 1, Rounding = 1}):OnChanged(function()
    ESP.Thickness = Options.Thickness.Value
end)

 VisualEsp:AddToggle("Names", {Text = "Show Names"}):OnChanged(function()
    ESP.Names = Toggles.Names.Value 
 end)

 VisualEsp:AddToggle("FaceCamera", {Text = "Face Camera"}):OnChanged(function()
    ESP.FaceCamera = Toggles.FaceCamera.Value 
 end)

 VisualEsp:AddToggle("ShowTeam", {Text = "Show Team"}):OnChanged(function()
    ESP.TeamMates = Toggles.ShowTeam.Value 
 end)

 VisualEsp:AddToggle("TeamHue", {Text = "Team Color"}):OnChanged(function()
    ESP.TeamColor = Toggles.TeamHue.Value 
 end)

 MenuVisual:AddToggle("watermarkShown", {Text = "Draw Watermark"}):OnChanged(function()
    Library.Watermark.Visible = watermarkShown
 end)

 
--End visuals[[
--]]




AntiAim:AddToggle("aaing", {Text = "Enabled"})

AntiAim:AddToggle("hitbox", {Text = "Small Hitbox"})

AntiAim:AddSlider("angle", {Text = "Down Pitch Perpendicular", Min = 0, Max = -15 , Default = 0, Rounding = 0})
AntiAim:AddSlider("angle2", {Text = "Up Pitch Perpendicular", Min = -15, Max = 15, Default = 0, Rounding = 0})
ADAntiAim:AddToggle("Inverse", {Text = "Inverse (Tanget Fallacy)"})
ADAntiAim:AddInput("reciprocal", {Text = "Inverse Reciprocal Resolver", Default = "0"})
ADAntiAim:AddToggle("FalseDuck", {Text = "False Duck"})

local Main = MainBOX:AddTab("Main")

local MainChecks = MainBOX2:AddTab("Checks")

Main:AddToggle("aim_Enabled", {Text = "Enabled"})
MainChecks:AddToggle("TeamCheck", {Text = "Team Check"})
MainChecks:AddToggle("friendCheck", {Text = "Friend Check"})
MainChecks:AddToggle("groupCheck", {Text = "Group Check"})
MainChecks:AddInput("groupID", {Text = "Group Check ID", Default = "Group ID"})

MainChecks:AddInput("teamCheckID", {Text = "Whitelist Team", Default = "Team name"})


Main:AddDropdown("TargetPart", {Text = "Legit Part", Default = 1, Values = {
"HumanoidRootPart", "Head"
}})
Main:AddDropdown("Method", {Text = "Silent Aim Method", Default = 4, Values = {
"Raycast","FindPartOnRay",
"FindPartOnRayWithWhitelist",
"FindPartOnRayWithIgnoreList",
"Mouse.Hit/Target",
"Pixel",
"Criminality"
}})
end
local FieldOfViewBOX = GeneralTab:AddLeftTabbox("Field Of View")
do
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 180
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.fromRGB(54, 57, 241)

local Main = FieldOfViewBOX:AddTab("Field Of View")
Main:AddToggle("fov_Enabled", {Text = "Enabled"})
Main:AddSlider("Radius", {Text = "Radius", Min = 0, Max = 360, Default = 180, Rounding = 0}):OnChanged(function()
fov_circle.Radius = Options.Radius.Value
end)

Main:AddToggle("Filled", {Text = "Filled"}):OnChanged(function()
fov_circle.Filled = Toggles.Filled.Value
end)

Main:AddSlider("Transparency", {Text = "Transparency", Min = 0, Max = 1, Default = 0.4, Rounding = 2}):OnChanged(function()
    fov_circle.Transparency = Options.Transparency.Value
end)

Main:AddToggle("Visible", {Text = "Visible"}):AddColorPicker("Color", {Default = Color3.fromRGB(54, 57, 241)}):OnChanged(function()
fov_circle.Visible = Toggles.Visible.Value
while Toggles.Visible.Value do
    fov_circle.Visible = Toggles.Visible.Value
    fov_circle.Color = Options.Color.Value
    fov_circle.Position = getMousePosition() + Vector2.new(0, 36)
    task.wait()
end
end)
end


local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = {
        ArgCountRequired = 3,
        Args = {
            "Instance",
            "Ray",
            "table",
            "boolean",
            "boolean"
        }
    },
    FindPartOnRayWithWhitelist = {
        ArgCountRequired = 3,
        Args = {
            "Instance",
            "Ray",
            "table",
            "boolean"
        }
    },
    FindPartOnRay = {
        ArgCountRequired = 2,
        Args = {
            "Instance",
            "Ray",
            "Instance",
            "boolean",
            "boolean"
        }
    },
    Raycast = {
        ArgCountRequired = 3,
        Args = {
            "Instance",
            "Vector3",
            "Vector3",
            "RaycastParams"
        }
    },
    Pixel = {
        ArgCountRequired = 3,
        Args = {
            "Instance",
            "Ray",
            "table",
            "boolean",
            "boolean"
        }
    },
    Criminality = {
        ArgCountRequired = 3,
        Args = {
            "Instance",
            "Ray",
            "table",
            "boolean"
        }
    }
}



local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(...)
local Method = getnamecallmethod()
local Arguments = {...}
local self = Arguments[1]

if Toggles.aim_Enabled.Value and self == workspace then
if Method == "FindPartOnRayWithIgnoreList" and Options.Method.Value == Method then
    if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
        local A_Ray = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = A_Ray.Origin
            local Direction = getDirection(Origin, HitPart.Position)
            Arguments[2] = Ray.new(Origin, Direction)

            return oldNamecall(unpack(Arguments))
        end
    end
elseif Method == "FindPartOnRayWithWhitelist" and Options.Method.Value == Method then
    if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
        local A_Ray = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = A_Ray.Origin
            local Direction = getDirection(Origin, HitPart.Position)
            Arguments[2] = Ray.new(Origin, Direction)

            return oldNamecall(unpack(Arguments))
        end
    end
elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and Options.Method.Value:lower() == Method:lower() then
    if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRay) then
        local A_Ray = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = A_Ray.Origin
            local Direction = getDirection(Origin, HitPart.Position)
            Arguments[2] = Ray.new(Origin, Direction)

            return oldNamecall(unpack(Arguments))
        end
    end
elseif Method == "Raycast" and Options.Method.Value == Method then
    if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
        local A_Origin = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            Arguments[3] = getDirection(A_Origin, HitPart.Position)

            return oldNamecall(unpack(Arguments))
        end
    end
elseif Method == "Pixel" and Options.Method.Value == Method then  
    if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
        local A_Ray = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = A_Ray.Origin
            local Direction = getDirection(Origin, HitPart.Position)
            Arguments[2] = Ray.new(Origin, Direction)

            return oldNamecall(unpack(Arguments))
        end
    end
elseif Method == "Criminality" and Options.Method.Value == Method then  
    if ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
        local A_Ray = Arguments[2]

        local HitPart = getClosestPlayer()
        if HitPart then
            local Origin = A_Ray.Origin
            local Direction = getDirection(Origin, HitPart.Position)
            Arguments[2] = Ray.new(Origin, Direction)

            return oldNamecall(unpack(Arguments))
        end
    end
end
end
return oldNamecall(...)
end)


local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", function(self, Index)
if self == Mouse and (Index == "Hit" or Index == "Target") then 
if Toggles.aim_Enabled.Value == true and Options.Method.Value == "Mouse.Hit/Target" and getClosestPlayer() then
    local HitPart = getClosestPlayer()

    return ((Index == "Hit" and HitPart.CFrame) or (Index == "Target" and HitPart))
end
end

return oldIndex(self, Index)
end)

local Players = game:GetService("Players")

local function onCharacterAdded(character)
if Toggles.hitbox then
    if game.Players.LocalPlayer.Character:FindFirstChild("FakeHead") then
    game.Players.LocalPlayer.Character["FakeHead"]:Destroy()
    end
    for i, v in pairs(game.Players.LocalPlayer.Character) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end
end

local function onPlayerAdded(player)
player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)
while Toggles.aaing do
    if Toggles.FalseDuck == false then
        local args = {
            [1] = Options.angle.Value * (math.deg(0.2, 0.6))
        }

        game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
        wait()
    else
        local args = {
            [1] = math.huge,
        }

        game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
        wait()
    end
    wait()
end
wait()
wait()
