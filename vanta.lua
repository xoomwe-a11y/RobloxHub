-- [[ VANTA - Roblox Universal Hub (Anti-Cheat Bypass Speed) ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("VantaHub") then
	CoreGui.VantaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- إطار بتصميم عصري
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
MainFrame.Size = UDim2.new(0, 280, 0, 450)
MainFrame.Active = true
MainFrame.Draggable = true

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(45, 45, 55)
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = MainFrame

-- شريط العنوان العلوي
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ VANTA HUB ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

-- زر إخفاء وإظهار القائمة
local ToggleUiBtn = Instance.new("TextButton")
ToggleUiBtn.Parent = MainFrame
ToggleUiBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleUiBtn.Position = UDim2.new(0, 15, 0, 55)
ToggleUiBtn.Size = UDim2.new(0, 250, 0, 35)
ToggleUiBtn.Font = Enum.Font.GothamBold
ToggleUiBtn.Text = "Hide / Show UI"
ToggleUiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUiBtn.TextSize = 14

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(0, 8)
UICornerToggle.Parent = ToggleUiBtn

local uiVisible = true
ToggleUiBtn.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	for _, child in ipairs(MainFrame:GetChildren()) do
		if child ~= Title and child ~= ToggleUiBtn and child ~= UICornerMain and child ~= UIStrokeMain then
			child.Visible = uiVisible
		end
	end
	MainFrame.Size = uiVisible and UDim2.new(0, 280, 0, 450) or UDim2.new(0, 280, 0, 100)
end)

local function createButton(name, posY, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = MainFrame
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	btn.Position = UDim2.new(0, 15, 0, posY)
	btn.Size = UDim2.new(0, 250, 0, 38)
	btn.Font = Enum.Font.GothamBold
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(210, 210, 210)
	btn.TextSize = 14
	
	local UICornerBtn = Instance.new("UICorner")
	UICornerBtn.CornerRadius = UDim.new(0, 8)
	UICornerBtn.Parent = btn
	
	local active = false
	btn.MouseButton1Click:Connect(function()
		active = not active
		if active then
			btn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
			btn.TextColor3 = Color3.fromRGB(210, 210, 210)
		end
		callback(active)
	end)
end

-- بار التحكم بالسرعة
local currentSpeed = 50
local speedEnabled = false

local function createSlider(name, posY, min, max, callback)
	local container = Instance.new("Frame")
	container.Parent = MainFrame
	container.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	container.Position = UDim2.new(0, 15, 0, posY)
	container.Size = UDim2.new(0, 250, 0, 50)
	container.BorderSizePixel = 0
	
	local UICornerContainer = Instance.new("UICorner")
	UICornerContainer.CornerRadius = UDim.new(0, 8)
	UICornerContainer.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 10, 0, 5)
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Font = Enum.Font.GothamBold
	label.Text = name .. ": 50"
	label.TextColor3 = Color3.fromRGB(210, 210, 210)
	label.TextSize = 13
	
	local sliderBar = Instance.new("Frame")
	sliderBar.Parent = container
	sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	sliderBar.Position = UDim2.new(0, 10, 0, 32)
	sliderBar.Size = UDim2.new(0, 230, 0, 8)
	sliderBar.BorderSizePixel = 0
	
	local UICornerBar = Instance.new("UICorner")
	UICornerBar.CornerRadius = UDim.new(0, 4)
	UICornerBar.Parent = sliderBar
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Parent = sliderBar
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.BorderSizePixel = 0
	
	local UICornerFill = Instance.new("UICorner")
	UICornerFill.CornerRadius = UDim.new(0, 4)
	UICornerFill.Parent = sliderFill
	
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

-- 1. ESP
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
				box.Color = Color3.fromRGB(255, 50, 50)
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
createButton("Toggle ESP", 100, toggleESP)

-- 2. Aimbot
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

-- 3. Noclip
local noclipConnection
createButton("Toggle Noclip", 190, function(state)
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

-- 4. Speed Hack الآمن (طريقة CFrame لتجنب الإرجاع)
createButton("Enable Speed Hack", 235, function(state)
	speedEnabled = state
end)

createSlider("Speed Value", 285, 16, 2500, function(val)
	currentSpeed = val
end)

RunService.Heartbeat:Connect(function(dt)
	if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		local hum = LocalPlayer.Character.Humanoid
		if hum.MoveDirection.Magnitude > 0 then
			-- استخدام CFrame لمنع نظام الحماية من كشف السرعة وإرجاعك
			hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (currentSpeed * dt))
		end
	end
end)

-- 5. Jump
local jumpEnabled = false
createButton("Toggle Jump (150)", 355, function(state)
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
