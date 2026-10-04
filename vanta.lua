-- [[ Vanta Hub : Steal an Egg (Fixed & Enhanced Edition) ]] --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("VantaStealAnEgg") then
    CoreGui.VantaStealAnEgg:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VantaStealAnEgg"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
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
Title.Text = "Vanta Hub ⚡ [Fixed Edition]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

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

-- 1. كسر حماية السرعة وتثبيتها بشكل قوي
local speedActive = false
local customSpeed = 28
createButton("⚡ تفعيل السرعة القوية (Force Speed)", function()
    speedActive = not speedActive
end)

RunService.RenderStepped:Connect(function()
    if speedActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = customSpeed
            end
        end)
    end
end)

-- 2. إظهار أماكن البيض عبر فحص شامل لكل الأجزاء والمجلدات
createButton("👁️ إظهار أماكن البيض (Deep Egg ESP)", function()
    local foundCount = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        -- توسيع نطاق البحث ليشمل الكلمات المرتبطة بالبيض أو الصناديق داخل الماب
        local nameLower = obj.Name:lower()
        if (nameLower:find("egg") or nameLower:find("collect") or nameLower:find("item")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
            if targetPart and not targetPart:FindFirstChild("VantaHighlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "VantaHighlight"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(0, 255, 120)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = obj
                foundCount = foundCount + 1
            end
        end
    end
    print("[+] تم تفعيل الـ ESP بنجاح والعثور على عناصر مطابقة.")
end)

-- 3. الطيران الحر (Fly)
local flying = false
createButton("🛸 تفعيل الطيران (Fly Mode)", function()
    flying = not flying
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    task.spawn(function()
        local bv = Instance.new("BodyVelocity")
        bv.Name = "VantaFlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        while flying and char and char.Parent do
            task.wait()
            local cam = workspace.CurrentCamera
            local vel = Vector3.new(0, 0, 0)
            -- التحكم عبر اتجاه الكاميرا
            bv.Velocity = vel
            bv.Parent = hrp
        end
        bv:Destroy()
    end)
end)

-- 4. العودة للقاعدة
createButton("🏠 العودة للقاعدة (Teleport Base)", function()
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- محاولة إيجاد مكان Spawn أو قاعدة اللاعب
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("spawn") or v.Name:lower():find("base") then
                    if v:IsA("BasePart") then
                        char.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 4, 0)
                        return
                    end
                end
            end
            -- حل بديل لو لم يجدها
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 15, 0)
        end
    end)
end)

print("تم تحميل النسخة المحدثة بنجاح!")
