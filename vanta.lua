-- [[ VANTA - Roblox Universal Hub (With Speed Slider & UI Toggle) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إزالة الواجهة القديمة إن وجدت لمنع التكرار
if CoreGui:FindFirstChild("VantaHub") then
	CoreGui.VantaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
MainFrame.Size = UDim2.new(0, 300, 0, 440)
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

-- زر إغلاق / إخفاء القائمة (Minimize / Toggle UI)
local ToggleUiBtn = Instance.new("TextButton")
ToggleUiBtn.Parent = MainFrame
ToggleUiBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
ToggleUiBtn.Position = UDim2.new(0, 25, 0, 50)
ToggleUiBtn.Size = UDim2.new(0, 250, 0, 35)
ToggleUiBtn.Font = Enum.Font.SourceSansBold
ToggleUiBtn.Text = "Hide/Show UI (Toggle)"
ToggleUiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUiBtn.TextSize = 15

local uiVisible = true
ToggleUiBtn.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	for _, child in ipairs(MainFrame:GetChildren()) do
		if child ~= Title and child ~= ToggleUiBtn then
			child.Visible = uiVisible
		end
	end
	MainFrame.Size = uiVisible and UDim2.new(0, 300, 0, 440) or UDim2.new(0, 300, 0, 85)
end)

-- دالة مساعدة للأزرار العادية
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

-- دالة إنشاء شريط التحكم في السرعة (Speed Slider Bar)
local currentSpeed = 16
local speedEnabled = false

local function createSlider(name, posY, min, max, callback)
	local container = Instance.new("Frame")
	container.Parent = MainFrame
	container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	container.Position = UDim2.new(0, 25, 0, posY)
	container.Size = UDim2.new(0, 250, 0, 50)
	container.BorderSizePixel = 0
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Font = Enum.Font.SourceSansBold
	label.Text = name .. ": 16"
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.TextSize = 14
	
	local sliderBar = Instance.new("Frame")
	sliderBar.Parent = container
	sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderBar.Position = UDim2.new(0, 10, 0, 30)
	sliderBar.Size = UDim2.new(0, 230, 0, 10)
	sliderBar.BorderSizePixel = 0
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Parent = sliderBar
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 60)
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.BorderSizePixel = 0
	
	local dragging = false
	
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mousePos = UserInputService:GetMouseLocation().X
			local barPos = sliderBar.AbsolutePosition.X
			local barSize = sliderBar.AbsoluteSize.X
			local clamp = math.clamp((mousePos - barPos) / barSize, 0, 1)
			
			sliderFill.Size = UDim2.new(clamp, 0, 1, 0)
			local value = math.floor(min + (max - min) * clamp)
			label.Text = name .. ": " .. value
			callback(value)
		end
	end)
end

-- 1. نظام الـ ESP
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
createButton("Toggle ESP", 95, toggleESP)

-- 2. نظام الـ Aimbot
local aimbotEnabled = false
createButton("Toggle Aimbot", 145, function(state)
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

-- 3. نظام الـ Noclip
local noclipConnection
createButton("Toggle Noclip", 195, function(state)
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

-- 4. زر تفعيل السرعة + بار التحكم (Slider)
createButton("Enable Speed Hack", 245, function(state)
	speedEnabled = state
end)

createSlider("Speed Value", 295, 16, 200, function(val)
	currentSpeed = val
end)

RunService.RenderStepped:Connect(function()
	if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		local hum = LocalPlayer.Character.Humanoid
		if hum.MoveDirection.Magnitude > 0 then
			hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * currentSpeed, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * currentSpeed)
		end
	end
end)

-- 5. القفز العالي
local jumpEnabled = false
createButton("Toggle Jump (150)", 360, function(state)
	jumpEnabled = state
end)

RunService.RenderStepped:Connect(function()
	if jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.JumpPower = 150
		LocalPlayer.Character.Humanoid.UseJumpPower = true
	elseif not jumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		if LocalPlayer.Character.Humanoid.JumpPower == 150 then
			LocalPlayer.Character.Humanoid.JumpPower = 50
		end
	end
end)
