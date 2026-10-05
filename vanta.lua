-- Egg Hunt Auto-Farm & Speed Hack (Bypass Protection)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local SpeedToggle = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextBox")
local AutoFarmToggle = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 230, 0, 210)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Egg Hunt | Speed & Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold

-- Speed Toggle Button
SpeedToggle.Parent = Frame
SpeedToggle.Position = UDim2.new(0.08, 0, 0.2, 0)
SpeedToggle.Size = UDim2.new(0.55, 0, 0.2, 0)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
SpeedToggle.Text = "Speed: OFF"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextSize = 13
SpeedToggle.Font = Enum.Font.SourceSansBold

-- Speed Value Input
SpeedSlider.Parent = Frame
SpeedSlider.Position = UDim2.new(0.68, 0, 0.2, 0)
SpeedSlider.Size = UDim2.new(0.24, 0, 0.2, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedSlider.Text = "32"
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.TextSize = 13
SpeedSlider.Font = Enum.Font.SourceSansBold

-- Auto Farm Button
AutoFarmToggle.Parent = Frame
AutoFarmToggle.Position = UDim2.new(0.08, 0, 0.45, 0)
AutoFarmToggle.Size = UDim2.new(0.84, 0, 0.2, 0)
AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
AutoFarmToggle.Text = "Auto Steal Eggs: OFF"
AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmToggle.TextSize = 13
AutoFarmToggle.Font = Enum.Font.SourceSansBold

StatusLabel.Parent = Frame
StatusLabel.Position = UDim2.new(0, 0, 0.78, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 35)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle\nAnti-AFK: Enabled"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.SourceSans

-- Variables
local SpeedEnabled = false
local AutoFarmEnabled = false
local TargetSpeed = 32

-- Safe Speed System (CFrame Vector Movement - Anti-Kick)
RunService.Heartbeat:Connect(function(delta)
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character.HumanoidRootPart
        
        if humanoid.MoveDirection.Magnitude > 0 then
            -- تحريك الشخصية عن طريق الإحداثيات لمنع كشف تعديل WalkSpeed المباشر
            hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (TargetSpeed - 16) * delta)
        end
    end
end)

-- Speed Toggle Action
SpeedToggle.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        SpeedToggle.Text = "Speed: ON"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        SpeedToggle.Text = "Speed: OFF"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

SpeedSlider.FocusLost:Connect(function()
    local val = tonumber(SpeedSlider.Text)
    if val then
        TargetSpeed = math.clamp(val, 16, 80) -- السرعة الآمنة بين 16 و 80
        SpeedSlider.Text = tostring(TargetSpeed)
    else
        SpeedSlider.Text = tostring(TargetSpeed)
    end
end)

-- Auto Steal Egg Function
local function GetClosestEgg()
    local closest = nil
    local shortestDistance = math.huge
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return nil end

    for _, v in ipairs(workspace:GetDescendants()) do
        -- البحث عن البيض في الماب (عبر الأسماء الشائعة أو الكائنات التي تحتوي على كلمة Egg)
        if v:IsA("BasePart") and (v.Name:lower():find("egg") or (v.Parent and v.Parent.Name:lower():find("egg"))) then
            local dist = (hrp.Position - v.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closest = v
            end
        end
    end
    return closest
end

-- Auto Farm Loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if AutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetEgg = GetClosestEgg()
            if targetEgg then
                StatusLabel.Text = "Status: Stealing Egg..."
                -- الانتقال السلس للبيضة لمنع الطرد
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetEgg.CFrame + Vector3.new(0, 2, 0)
                
                -- التفاعل المباشر إذا كان هناك Prompt
                for _, prompt in ipairs(targetEgg:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        fireproximityprompt(prompt)
                    end
                end
            else
                StatusLabel.Text = "Status: Searching for eggs..."
            end
        end
    end
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    if AutoFarmEnabled then
        AutoFarmToggle.Text = "Auto Steal Eggs: ON"
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        AutoFarmToggle.Text = "Auto Steal Eggs: OFF"
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        StatusLabel.Text = "Status: Idle\nAnti-AFK: Enabled"
    end
end)

-- Anti-AFK Background Protection
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)
