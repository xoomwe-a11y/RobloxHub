-- [[ Vanta Hub : Steal an Egg with Speed Slider ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("VantaSpeedHub") then
    CoreGui.VantaSpeedHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaSpeedHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي الصغير والمريح
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 210)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Vanta Speed Controller"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
CloseBtn.Size = UDim2.new(0, 25, 0, 21)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 11

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- متغيرات السرعة
local speedEnabled = false
local currentSpeed = 25

-- زر تشغيل/إيقاف السرعة
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "حالة السرعة: متوقف (OFF)"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.TextSize = 13

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        ToggleBtn.Text = "حالة السرعة: شغال (ON)"
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleBtn.Text = "حالة السرعة: متوقف (OFF)"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- عرض قيمة السرعة الحالية
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.05, 0, 0.44, 0)
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 25)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.Text = "السرعة الحالية: 25"
SpeedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedLabel.TextSize = 12

-- شريط (بار) التحكم بالسرعة
local SliderBg = Instance.new("Frame")
SliderBg.Parent = MainFrame
SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SliderBg.Position = UDim2.new(0.05, 0, 0.58, 0)
SliderBg.Size = UDim2.new(0.9, 0, 0, 12)

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SliderBg

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SliderBg
SliderFill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
SliderFill.Size = UDim2.new(25/150, 0, 1, 0) -- البداية على سرعة 25 من أصل 150

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 6)
FillCorner.Parent = SliderFill

-- زر زيادة السرعة (+5) وزيادة النطاق
local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = MainFrame
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 70)
PlusBtn.Position = UDim2.new(0.52, 0, 0.73, 0)
PlusBtn.Size = UDim2.new(0.43, 0, 0, 32)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "زيادة السرعة (+)"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 12

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = PlusBtn

PlusBtn.MouseButton1Click:Connect(function()
    if currentSpeed < 150 then
        currentSpeed = currentSpeed + 5
        SpeedLabel.Text = "السرعة الحالية: " .. currentSpeed
        SliderFill.Size = UDim2.new(currentSpeed/150, 0, 1, 0)
    end
end)

-- زر إنقاص السرعة (-5)
local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = MainFrame
MinusBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
MinusBtn.Position = UDim2.new(0.05, 0, 0.73, 0)
MinusBtn.Size = UDim2.new(0.43, 0, 0, 32)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Text = "تقليل السرعة (-)"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 12

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 6)
MinusCorner.Parent = MinusBtn

MinusBtn.MouseButton1Click:Connect(function()
    if currentSpeed > 16 then
        currentSpeed = currentSpeed - 5
        SpeedLabel.Text = "السرعة الحالية: " .. currentSpeed
        SliderFill.Size = UDim2.new(currentSpeed/150, 0, 1, 0)
    end
end)

-- تطبيق السرعة بشكل إجباري لتتجاوز حماية الماب
RunService.Heartbeat:Connect(function()
    if speedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = currentSpeed
            end
        end)
    end
end)

print("تم تفعيل بار التحكم بالسرعة بنجاح!")
