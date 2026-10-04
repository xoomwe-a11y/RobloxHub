-- [[ VANTA - Roblox Universal Hub ]] --
-- Luau (Roblox Exploit Compatible)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إعداد الواجهة الرئيسية (UI Hub)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "VANTA - Universal Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- دالة مساعدة لإنشاء الأزرار
local function createButton(name, posY, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = MainFrame
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Position = UDim2.new(0, 25, 0, posY)
	btn.Size = UDim2.new(0, 250, 0, 40)
	btn.Font = Enum.Font.SourceSansBold
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.TextSize = 16
	
	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			btn.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
		callback(active)
	end)
end

-- 1. نظام الـ ESP (كشف اللاعبين)
local espEnabled = false
local espObjects = {}

local function toggleESP(state)
	espEnabled = state
	if not espEnabled then
		for _, box in pairs(espObjects) do
			if box then box:Remove() end
		end
		espObjects = {}
	end
end

RunService.RenderStepped:Connect(function()
	if not espEnabled then return end
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
			
			if not espObjects[player] then
				local box = Drawing.new("Square")
				box.Visible = false
				box.Color = Color3.fromRGB(255, 0, 0)
				box.Thickness = 2
				box.Filled = false
				espObjects[player] = box
			end
			
			local box = espObjects[player]
			if onScreen then
				box.Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
				box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
				box.Visible = true
			else
				box.Visible = false
			end
		elseif espObjects[player] then
			espObjects[player].Visible = false
		end
	end
end)

createButton("Toggle ESP", 55, toggleESP)

-- 2. نظام الـ Aimbot (التصويب التلقائي عند الضغط على الزر الأيمن للفأرة)
local aimbotEnabled = false
createButton("Toggle Aimbot", 105, function(state)
	aimbotEnabled = state
end)

RunService.RenderStepped:Connect(function()
	if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local closestPlayer = nil
		local shortestDistance = math.huge
		
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
				local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
				if onScreen then
					local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
					if magnitude < shortestDistance then
						shortestDistance = magnitude
						closestPlayer = player
					end
				end
			end
		end
		
		if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.Head.Position)
		end
	end
end)

-- 3. نظام الـ Noclip (المرور من الجدران)
local noclipConnection
createButton("Toggle Noclip", 155, function(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			if LocalPlayer.Character then
				for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		if noclipConnection then
			noclipConnection:Disconnect()
		end
	end
end)

-- 4. تعديل السرعة (Speed Boost)
createButton("Toggle Speed (50)", 205, function(state)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
	end
end)

-- 5. القفز العالي (High Jump)
createButton("Toggle Jump (100)", 255, function(state)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = state and 150 or 50
	end
end)
