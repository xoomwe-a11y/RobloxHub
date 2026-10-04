-- واجهة Steal an Egg Hub المحدثة مع Auto-Farm و Teleport
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("StealAnEggHub") then
    CoreGui.StealAnEggHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
MainFrame.Size = UDim2.new(0, 450, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- شريط العناوين العلوي
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.03, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Steal An Egg Hub | Pro Max"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق الواجهة
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(230, 50, 50)
CloseBtn.Position = UDim2.new(0.9, 0, 0.15, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- حاوية الأزرار القابلة للتمرير
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 2, 0)
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- دالة مساعدة لإنشاء الأزرار بسلاسة
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
        btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    end)
end

-- 1. تفعيل السرعة الآمنة
local speedEnabled = false
createButton("تفعيل السرعة الآمنة (Speed Boost)", function()
    speedEnabled = not speedEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speedEnabled and 28 or 16
    end
end)

-- 2. إظهار أماكن البيض (ESP)
createButton("إظهار أماكن البيض (Egg ESP)", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
            if not obj:FindFirstChild("EggHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "EggHighlight"
                highlight.Adornee = obj
                highlight.FillColor = Color3.fromRGB(0, 255, 128)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = obj
            end
        end
    end
end)

-- 3. التجميع التلقائي للبيض القريب (Auto-Farm Eggs)
local autoFarmActive = false
createButton("التجميع التلقائي للبيض (Auto-Farm)", function()
    autoFarmActive = not autoFarmActive
    task.spawn(function()
        while autoFarmActive do
            task.wait(0.5)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not autoFarmActive then break end
                        if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
                            -- انتقال تدريجي وآمن لمكان البيضة
                            char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. الانتقال السريع لأمان البداية / القاعدة (Teleport to Base)
createButton("الرجوع السريع للقاعدة (Teleport Base)", function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- جرب البحث عن نقطة البداية أو العودة في الماب
            local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("SpawnLocation")
            if base then
                char.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 5, 0)
            else
                -- رفع اللاعب قليلاً كبديل آمن لو لم توجد قاعدة محددة بالاسم
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
            end
        end
    end)
end)

-- 5. إزالة المؤثرات الثقيلة لزيادة الفريمات
createButton("تحسين الأداء وإزالة اللاج (Anti-Lag)", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
    end)
end)

print("تم تحميل ميزات Auto-Farm و Teleport بنجاح!")
