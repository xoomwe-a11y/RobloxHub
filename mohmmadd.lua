--[[\
    Project: Vanta Stable Speed Hack (Anti-Rubberband / Egg Stealing)
    Author: VANTA for WORM
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    SpeedMultiplier = 2.0,
    Enabled = true
}

-- تنظيف الواجهة القديمة
if CoreGui:FindFirstChild("VantaStableSpeedGUI") then
    CoreGui.VantaStableSpeedGUI:Destroy()
end

-- بناء واجهة مستخدم متطورة ونظيفة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaStableSpeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "VANTA // Stable Speed"
Title.TextColor3 = Color3.fromRGB(220, 220, 245)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 1, -55)
Container.Position = UDim2.new(0, 15, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
ToggleBtn.Text = "Status: [ ACTIVE ]"
ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Multiplier: 2.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Container

local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0.48, 0, 0, 38)
BtnPlus.Position = UDim2.new(0.52, 0, 0, 85)
BtnPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
BtnPlus.Text = "Increase (+)"
BtnPlus.TextColor3 = Color3.fromRGB(220, 220, 240)
BtnPlus.TextSize = 13
BtnPlus.Font = Enum.Font.GothamBold
BtnPlus.Parent = Container

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 8)
PlusCorner.Parent = BtnPlus

local BtnMinus = Instance.new("TextButton")
BtnMinus.Size = UDim2.new(0.48, 0, 0, 38)
BtnMinus.Position = UDim2.new(0, 0, 0, 85)
BtnMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
BtnMinus.Text = "Decrease (-)"
BtnMinus.TextColor3 = Color3.fromRGB(220, 220, 240)
BtnMinus.TextSize = 13
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.Parent = Container

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = Instance.new("UICorner") -- fix reference
MinusCorner.CornerRadius = UDim.new(0, 8)
MinusCorner.Parent = BtnMinus

ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    ToggleBtn.Text = "Status: [ " .. (Settings.Enabled and "ACTIVE" or "DISABLED") .. " ]"
    ToggleBtn.TextColor3 = Settings.Enabled and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 100, 100)
end)

BtnPlus.MouseButton1Click:Connect(function()
    if Settings.SpeedMultiplier < 4.0 then
        Settings.SpeedMultiplier = math.clamp(Settings.SpeedMultiplier + 0.5, 1.0, 4.0)
        SpeedLabel.Text = "Speed Multiplier: " .. string.format("%.1f", Settings.SpeedMultiplier) .. "x"
    end
end)

BtnMinus.MouseButton1Click:Connect(function()
    if Settings.SpeedMultiplier > 1.0 then
        Settings.SpeedMultiplier = math.clamp(Settings.SpeedMultiplier - 0.5, 1.0, 4.0)
        SpeedLabel.Text = "Speed Multiplier: " .. string.format("%.1f", Settings.SpeedMultiplier) .. "x"
    end
end)

-- طريقة تعديل الـ WalkSpeed المستقرة (تمنع مشكلة الـ Rubberband تماماً)
RunService.Heartbeat:Connect(function()
    if not Settings.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local standardSpeed = 16
        humanoid.WalkSpeed = standardSpeed * Settings.SpeedMultiplier
    end
end)
