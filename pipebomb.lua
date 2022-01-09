if not syn or not protectgui then
getgenv().protectgui = function()end
end
local Library = loadstring(game:HttpGet('https://lindseyhost.com/UI/LinoriaLib.lua'))()

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
if not Options.TargetPart.Value then return end
local Closest
local DistanceToMouse
for _, Player in next, GetChildren(Players) do
    if Player == LocalPlayer then continue end
    if Toggles.TeamCheck.Value and Player.Team == LocalPlayer.Team then continue end

    local Character = Player.Character

    if not Character then continue end

    local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
    local Humanoid = FindFirstChild(Character, "Humanoid")

    if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

    local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)

    if not OnScreen then continue end

    local Distance = (getMousePosition() - ScreenPosition).Magnitude
    if Distance <= (DistanceToMouse or (Toggles.fov_Enabled.Value and Options.Radius.Value) or 2000) then
        if math.random(1,2) == 2 then
        Closest = Character[Options.TargetPart.Value]
        else
        Closest = Character["Head"]
        end
        DistanceToMouse = Distance
    end
end
return Closest
end


local Window = Library:CreateWindow("🤓 'guys blm!!!' ")

local GeneralTab = Window:AddTab("General")
local AATab = Window:AddTab("Anti Aim")
local MainBOX = GeneralTab:AddLeftTabbox("Main")
local AABOX = AATab:AddLeftTabbox("Anti Aim Config")
do
local AntiAim = AABOX:AddTab("Anti Aim")
AntiAim:AddToggle("aaing", {Text = "Enabled"})
AntiAim:AddToggle("hitbox", {Text = "Small Hitbox"})

AntiAim:AddSlider("angle", {Text = "Down Pitch Perpendicular", Min = 0, Max = -10, Default = 0, Rounding = 0})
AntiAim:AddSlider("angle2", {Text = "Up Pitch Perpendicular", Min = -10, Max = 10, Default = 0, Rounding = 0})
AntiAim:AddToggle("Inverse", {Text = "Inverse (Tanget Fallacy)"})
AntiAim:AddInput("reciprocal", {Text = "Inverse Reciprocal Resolver", Default = "0"})
AntiAim:AddButton("Fake Duck", function()
    while Toggles.aaing do
        local args = {
            [1] = Functions.FakeduckResolve(140000 * math.cos(math.pi / Options.reciprocal) ^ math.deg(Options.reciprocal^math.rad(Options.reciprocal)))
        }
        
        game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
        wait()
    end
end)


local Main = MainBOX:AddTab("Main")
Main:AddToggle("aim_Enabled", {Text = "Enabled"})
Main:AddToggle("TeamCheck", {Text = "Team Check"})
Main:AddDropdown("TargetPart", {Text = "Legit Part", Default = 1, Values = {
    "HumanoidRootPart", "Head"
}})
Main:AddDropdown("Method", {Text = "Silent Aim Method", Default = 1, Values = {
    "Raycast","FindPartOnRay",
    "FindPartOnRayWithWhitelist",
    "FindPartOnRayWithIgnoreList",
    "Mouse.Hit/Target"
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
        "Instance", "Ray", "table", "boolean", "boolean"
    }
},
FindPartOnRayWithWhitelist = {
    ArgCountRequired = 3,
    Args = {
        "Instance", "Ray", "table", "boolean"
    }
},
FindPartOnRay = {
    ArgCountRequired = 2,
    Args = {
        "Instance", "Ray", "Instance", "boolean", "boolean"
    }
},
Raycast = {
    ArgCountRequired = 3,
    Args = {
        "Instance", "Vector3", "Vector3", "RaycastParams"
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
    if Toggles.Inverse then --Inverse Reciprocal, Change later to math.tan or some shit like sine has small sezuire when uses with reciprcialfaskdjl shit so lets keep that at .2 please 
        if math.random(2, 3) == 2 then
            local args = {
                [1] = Options.angle.Value * (math.deg(0.2, 0.6))
            }
            
            game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
        else
            local args = {
                [1] = Options.angle2.Value * Functions.Default(math.deg(0.2, 0.6))
            }
            
            game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
        end
        wait()
    elseif not Toggles.Inverse then
    if math.random(2, 3) == 2 then
        local args = {
            [1] = Options.angle.Value
        }
        
        game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
    else
        local args = {
            [1] = Options.angle2.Value
        }
        
        game:GetService("ReplicatedStorage").Events.ControlTurn:FireServer(unpack(args))
    end
    wait()
    end
end
