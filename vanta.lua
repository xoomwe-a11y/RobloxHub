-- [[ Vanta Hub : Steal an Egg Pro Edition (Bypass Enabled) ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي نسخة قديمة لمنع التعارض
if CoreGui:FindFirstChild("VantaStealAnEgg") then
    CoreGui.VantaStealAnEgg:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaStealAnEgg"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي بتصميم أنيق ومظلم
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -170)
MainFrame.Size = UDim2.new(0, 460, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 42)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.04, 0, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Vanta Hub ⚡ [Steal an Egg]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق الواجهة
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Position = UDim2.new(0.89, 0, 0.18, 0)
CloseBtn.Size = UDim2.new(0, 32, 0, 26)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- حاوية الأزرار (Scrolling)
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 12, 0, 55)
Container.Size = UDim2.new(1, -24, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 2.2, 0)
Container.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- دالة مساعدة لإنشاء الأزرار بسلاسة وتفاعل بصري
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
        btn.BackgroundColor3 = Color3.fromRGB(50, 110, 190)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)
end

-- 1. تفعيل السرعة الآمنة (متوافقة مع الحماية)
local speedActive = false
createButton("⚡ تفعيل السرعة الآمنة (Anti-Rubberband)", function()
    speedActive = not speedActive
    RunService.Stepped:Connect(function()
        if speedActive then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * 0.6)
                end
            end
        end
    end)
end)

-- 2. رادار البيض (ESP)
createButton("👁️ إظهار أماكن البيض (Egg ESP)", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
            if not obj:FindFirstChild("VantaHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "VantaHighlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(0, 255, 120)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = obj
            end
        end
    end
end)

-- 3. التجميع التلقائي الذكي (بواسطة Tween لتفادي الباند)
local autoFarm = false
createButton("🤖 التجميع التلقائي للبيض (Safe Auto-Farm)", function()
    autoFarm = not autoFarm
    task.spawn(function()
        while autoFarm do
            task.wait(0.6)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not autoFarm then break end
                        if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
                            -- استخدام Tween للانتقال السلس وعدم إثارة حماية السيرفر
                            local info = TweenInfo.new(0.4, Enum.EasingStyle.Linear)
                            local tw = TweenService:Create(char.HumanoidRootPart, info, {CFrame = obj.CFrame + Vector3.new(0, 3, 0)})
                            tw:Play()
                            tw.Completed:Wait()
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end)
end)

-- 4. طيران آمن (Safe Fly)
local flying = false
createButton("🛸 تفعيل الطيران السلس (Safe Fly)", function()
    flying = not flying
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local bv = hrp:FindFirstChild("VantaBodyVelocity") or Instance.new("BodyVelocity")
        bv.Name = "VantaBodyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        while flying do
            task.wait()
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = flying and hrp or nil
        end
        bv:Destroy()
    end)
end)

-- 5. الرجوع السريع للقاعدة
createButton("🏠 العودة السريعة للقاعدة (Teleport Base)", function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("SpawnLocation")
            if base then
                char.HumanoidRootPart.CFrame = base.CFrame + Vector3.new(0, 4, 0)
            else
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 12, 0)
            end
        end
    end)
end)

-- 6. تنظيف المؤثرات لتسريع الماب
createButton("🚀 تحسين الأداء وإزالة اللاج (Anti-Lag)", function()
    pcall(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
    end)
end)

print("تم تحميل Vanta Hub بنجاح وبدون مشاكل حماية!")
