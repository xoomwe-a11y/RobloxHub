-- [[ Vanta Hub : Steal an Egg (High Speed Bypass Edition) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- إزالة أي نسخة قديمة لتجنب التكرار
if PlayerGui:FindFirstChild("VantaSecureHub") then
    PlayerGui.VantaSecureHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaSecureHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي للواجهة
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -110)
MainFrame.Size = UDim2.new(0, 280, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 38)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Vanta Hub ⚡ [High Speed]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق الواجهة
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 45, 45)
CloseBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
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

-- متغيرات السرعة العالية
local speedEnabled = false
local currentSpeed = 30 -- تبدأ من سرعة 30 وتصعد براحتك

-- زر تشغيل/إيقاف السرعة العالية
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ToggleBtn.Position = UDim2.new(0.07, 0, 0.23, 0)
ToggleBtn.Size = UDim2.new(0.86, 0, 0, 36)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "السرعة العالية: [ متوقف ❌ ]"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.TextSize = 12

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        ToggleBtn.Text = "السرعة العالية: [ شغال 🔥 ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ToggleBtn.Text = "السرعة العالية: [ متوقف ❌ ]"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- زر زيادة السرعة (+10)
local PlusBtn = Instance.new("TextButton")
PlusBtn.Parent = MainFrame
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 70)
PlusBtn.Position = UDim2.new(0.07, 0, 0.48, 0)
PlusBtn.Size = UDim2.new(0.41, 0, 0, 34)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Text = "سرعة + (+10)"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.TextSize = 11

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = PlusBtn

PlusBtn.MouseButton1Click:Connect(function()
    if currentSpeed < 150 then
        currentSpeed = currentSpeed + 10
        PlusBtn.Text = "السرعة: " .. currentSpeed
    end
end)

-- زر تقليل السرعة (-10)
local MinusBtn = Instance.new("TextButton")
MinusBtn.Parent = MainFrame
MinusBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
MinusBtn.Position = UDim2.new(0.52, 0, 0.48, 0)
MinusBtn.Size = UDim2.new(0.41, 0, 0, 34)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Text = "سرعة - (-10)"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.TextSize = 11

local MinusCorner = Instance.new("UICorner")
MinusCorner.CornerRadius = UDim.new(0, 6)
MinusCorner.Parent = MinusBtn

MinusBtn.MouseButton1Click:Connect(function()
    if currentSpeed > 20 then
        currentSpeed = currentSpeed - 10
        PlusBtn.Text = "السرعة: " .. currentSpeed
    end
end)

-- زر رادار البيض (ESP)
local EspBtn = Instance.new("TextButton")
EspBtn.Parent = MainFrame
EspBtn.BackgroundColor3 = Color3.fromRGB(45, 90, 150)
EspBtn.Position = UDim2.new(0.07, 0, 0.72, 0)
EspBtn.Size = UDim2.new(0.86, 0, 0, 36)
EspBtn.Font = Enum.Font.GothamBold
EspBtn.Text = "تفعيل رادار البيض (ESP) 👁️"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.TextSize = 12

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 6)
EspCorner.Parent = EspBtn

EspBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local count = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("egg") or name:find("collect")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local target = obj:IsA("Model") and obj.PrimaryPart or obj
                if target and not target:FindFirstChild("VantaSafeESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VantaSafeESP"
                    hl.Adornee = obj
                    hl.FillColor = Color3.fromRGB(0, 255, 120)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = obj
                    count = count + 1
                end
            end
        end
        EspBtn.Text = "تم رصد وتحديد: " .. count .. " بيضة!"
    end)
end)

-- محرك السرعة العالية عبر الفيزياء
RunService.RenderStepped:Connect(function()
    if speedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    local currentVel = char.HumanoidRootPart.AssemblyLinearVelocity
                    char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(
                        char.Humanoid.MoveDirection.X * currentSpeed,
                        currentVel.Y,
                        char.Humanoid.MoveDirection.Z * currentSpeed
                    )
                end
            end
        end)
    end
end)

print("تم تفعيل Vanta Hub بنجاح وبسرعات عالية آمنة!")
