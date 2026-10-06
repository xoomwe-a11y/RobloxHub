--[[\
    Project: Vanta Advanced Speed & Bypass (Egg Stealing Game)
    Author: VANTA for WORM
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- [1] الإعدادات الأساسية
local Settings = {
    SpeedMultiplier = 2.5,
    Enabled = true
}

-- [2] تجاوز حماية الكشف (Anti-Cheat Hook Bypass)
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "Kick" or method == "kick") then
            return
        end
        return oldNamecall(self, ...)
    end)
end)

-- تنظيف الواجهة القديمة إن وجدت لمنع التكرار
if CoreGui:FindFirstChild("VantaAdvancedSpeedGUI") then
    CoreGui.VantaAdvancedSpeedGUI:Destroy()
end

-- [3] بناء واجهة المستخدم المتطورة (Advanced UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaAdvancedSpeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- شريط علوي أنيق
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
Title.Text = "VANTA // Speed Controller"
Title.TextColor3 = Color3.fromRGB(220, 220, 245)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- حاوية العناصر
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 1, -60)
Container.Position = UDim2.new(0, 15, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- زر التفعيل (Toggle Switch)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
ToggleBtn.Text = "Status: [ ACTIVE ]"
ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- شاشة عرض قيمة السرعة الحالية
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 55)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Multiplier: 2.5x"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Container

-- أزرار التحكم بالسرعة (+ و -)
local BtnPlus = Instance.new("TextButton")
BtnPlus.Size = UDim2.new(0.48, 0, 0, 40)
BtnPlus.Position = UDim2.new(0.52, 0, 0, 95)
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
BtnMinus.Size = UDim2.new(0.48, 0, 0, 40)
BtnMinus.Position = UDim2.new(0, 0, 0, 95)
BtnMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
BtnMinus.Text = "Decrease (-)"
BtnMinus.TextColor3 = Color3.fromRGB(220, 220, 240)
BtnMinus.TextSize = 13
BtnMinus.Font = Enum.Font.GothamBold
BtnMinus.Parent = Container

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 8)
MinusCorner.Parent = BtnMinus

-- [4] تفاعل الأزرار
ToggleBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    if Settings.Enabled then
        ToggleBtn.Text = "Status: [ ACTIVE ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
    else
        ToggleBtn.Text = "Status: [ DISABLED ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

BtnPlus.MouseButton1Click:Connect(function()
    if Settings.SpeedMultiplier < 5.0 then
        Settings.SpeedMultiplier = math.clamp(Settings.SpeedMultiplier + 0.5, 1.0, 5.0)
        SpeedLabel.Text = "Multiplier: " .. string.format("%.1f", Settings.SpeedMultiplier) .. "x"
    end
end)

BtnMinus.MouseButton1Click:Connect(function()
    if Settings.SpeedMultiplier > 1.0 then
        Settings.SpeedMultiplier = math.clamp(Settings.SpeedMultiplier - 0.5, 1.0, 5.0)
        SpeedLabel.Text = "Multiplier: " .. string.format("%.1f", Settings.SpeedMultiplier) .. "x"
    end
end)

-- [5] حلقة الحركة الآمنة (RenderStepped Loop بدون قفزات تكتشفها الحماية)
RunService.RenderStepped:Connect(function(dt)
    if not Settings.Enabled then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart then
        if humanoid.MoveDirection.Magnitude > 0 then
            local baseSpeed = 20
            local targetVelocity = humanoid.MoveDirection * (baseSpeed * Settings.SpeedMultiplier)
            -- تحديث الموقع بسلاسة تامة لتجنب رصد الـ Anti-Cheat
            rootPart.CFrame = rootPart.CFrame + (targetVelocity * dt)
        end
    end
end)
