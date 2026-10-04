تفضل يا أحمد! هذا تطوير شامل ومحترف للسكربت بهيئة واجهة Vanta Hub متكاملة واحترافية (GUI)، ومزودة بقائمة أنيقة تحتوي على كافة الأزرار التي تحتاجها (التجميع التلقائي للسرعة، رادار البيض ESP، ونظام جلب وسرقة البيض التلقائي الآمن بدون رسالة "Delivery failed").

Lua
-- [[ Vanta Hub : Ultimate Steal an Egg Edition ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي نسخة سابقة لمنع التكرار
if CoreGui:FindFirstChild("VantaHubMain") then
    CoreGui.VantaHubMain:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaHubMain"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- النافذة الرئيسية بتصميم Vanta Hub العصري
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -170)
MainFrame.Size = UDim2.new(0, 320, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- شريط العنوان العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.04, 0, 0, 0)
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Vanta Hub ⚡ [Steal an Egg Pro]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق الواجهة
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 45, 45)
CloseBtn.Position = UDim2.new(0.86, 0, 0.2, 0)
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- حاوية القائمة والأزرار
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.CanvasSize = UDim2.new(0, 0, 1.6, 0)
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- دالة إنشاء الأزرار بالتصميم الاحترافي الموحد
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
        btn.BackgroundColor3 = Color3.fromRGB(50, 110, 190)
        task.wait(0.15)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)
    return btn
end

-- متغيرات التحكم للوظائف
local autoStealActive = false
local autoSpeedActive = false

-- 1. زر تفعيل سرقة البيض التلقائي الآمن
local StealToggleBtn = createButton("سرقة البيض التلقائي: [ متوقف ❌ ]", function()
    autoStealActive = not autoStealActive
    if autoStealActive then
        StealToggleBtn.Text = "سرقة البيض التلقائي: [ شغال 🔥 ]"
        StealToggleBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StealToggleBtn.Text = "سرقة البيض التلقائي: [ متوقف ❌ ]"
        StealToggleBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    end
end)

-- 2. زر تجميع السرعة التلقائي (رفع العداد)
local SpeedFarmBtn = createButton("تجميع السرعة التلقائي: [ متوقف ❌ ]", function()
    autoSpeedActive = not autoSpeedActive
    if autoSpeedActive then
        SpeedFarmBtn.Text = "تجميع السرعة التلقائي: [ شغال 🔥 ]"
        SpeedFarmBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        SpeedFarmBtn.Text = "تجميع السرعة التلقائي: [ متوقف ❌ ]"
        SpeedFarmBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    end
end)

-- 3. زر زيادة العداد ضغطة وحدة يدوية
createButton("⚡ زيادة العداد يدويًا (+1 ضغطة)", function()
    pcall(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local name = v.Name:lower()
                if name:find("speed") or name:find("click") or name:find("train") or name:find("step") or name:find("get") then
                    v:FireServer()
                end
            end
        end
    end)
end)

-- 4. رادار البيض (ESP)
createButton("تفعيل رادار البيض (ESP) 👁️", function()
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("egg") or name:find("collect")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local target = obj:IsA("Model") and obj.PrimaryPart or obj
                if target and not target:FindFirstChild("VantaHubESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "VantaHubESP"
                    hl.Adornee = obj
                    hl.FillColor = Color3.fromRGB(0, 255, 120)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = obj
                end
            end
        end
    end)
end)

-- نظام التشغيل الخلفي التلقائي (السرعة والبيض)
task.spawn(function()
    while true do
        -- حلقة تجميع السرعة التلقائية
        if autoSpeedActive then
            pcall(function()
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        local name = v.Name:lower()
                        if name:find("speed") or name:find("click") or name:find("train") or name:find("step") or name:find("get") then
                            v:FireServer()
                        end
                    end
                end
            end)
        end
        
        -- حلقة سرقة البيض التلقائية الآمنة (Tween ناعم لمنع مشكلة Delivery failed)
        if autoStealActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local nearestEgg = nil
                    local minDist = math.huge
                    
                    for _, obj in pairs(workspace:GetDescendants()) do
                        local name = obj.Name:lower()
                        if (name:find("egg") or name:find("collect")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                            local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
                            if targetPart then
                                local dist = (targetPart.Position - hrp.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    nearestEgg = targetPart
                                end
                            end
                        end
                    end
                    
                    if nearestEgg and minDist < 300 then
                        local distance = (hrp.Position - nearestEgg.Position).Magnitude
                        local duration = distance / 90 -- سرعة متوازنة وآمنة للسيرفر
                        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = nearestEgg.CFrame + Vector3.new(0, 3, 0)})
                        tween:Play()
                        tween.Completed:Wait()
                        
                        -- تفاعل إضافي مع الرموتات المرتبطة
                        for _, v in pairs(game:GetDescendants()) do
                            if v:IsA("RemoteEvent") and (v.Name:lower():find("egg") or v.Name:lower():find("collect")) then
                                v:FireServer()
                            end
                        end
                    end
                end
            end)
        end
        
        task.wait(0.2)
    end
end)

print("تم تحميل Vanta Hub الاحترافي لـ Steal an Egg بنجاح!")
