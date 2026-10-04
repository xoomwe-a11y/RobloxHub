-- [[ Vanta Hub : Pure & Clean Speed Controller ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف أي واجهة قديمة لمنع أي تكرار أو تعليق
if CoreGui:FindFirstChild("VantaCleanGui") then
    CoreGui.VantaCleanGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaCleanGui"
ScreenGui.Parent = CoreGui

-- نافذة رئيسية بسيطة جداً وغير مرصودة
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.5, -120, 0.5, -75)
Frame.Size = UDim2.new(0, 240, 0, 150)
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

-- عنوان النافذة
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Vanta Hub [Pure]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

-- زر تفعيل وإيقاف السرعة
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = Frame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "السرعة: [ متوقف ❌ ]"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.TextSize = 13

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ToggleBtn

-- زر زيادة السرعة
local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = Frame
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 70)
PlusBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
PlusBtn.Size = UDim2.new(0.38, 0, 0, 35)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "سرعة + (35)"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 12

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = PlusBtn

-- زر إيقاف/تخفيف السرعة للوضع الطبيعي
local ResetBtn = Instance.new("TextButton")
ResetBtn.Parent = Frame
ResetBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
ResetBtn.Position = UDim2.new(0.52, 0, 0.68, 0)
ResetBtn.Size = UDim2.new(0.38, 0, 0, 35)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Text = "عادي (16)"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 12

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 6)
ResetCorner.Parent = ResetBtn

-- المتغيرات الأساسية
local speedActive = false
local currentSpeed = 35

ToggleBtn.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    if speedActive then
        ToggleBtn.Text = "السرعة: [ شغال 🔥 ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleBtn.Text = "السرعة: [ متوقف ❌ ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

PlusBtn.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 10
    PlusBtn.Text = "سرعة + (" .. currentSpeed .. ")"
end)

ResetBtn.MouseButton1Click:Connect(function()
    currentSpeed = 16
    PlusBtn.Text = "سرعة + (16)"
end)

-- اللوب الإجباري لتثبيت السرعة بدقة عالية
RunService.Heartbeat:Connect(function()
    if speedActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = currentSpeed
            end
        end)
    end
end)
