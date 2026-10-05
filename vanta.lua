-- Anti-AFK, Stealth Speed Bypass & Auto Egg Steal
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
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 240, 0, 220)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Egg Hunt | Anti-Rubberband"
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
SpeedSlider.Text = "45" -- سرعة موصى بها لتفادي الـ Rubberband في الليل
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
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Bypass Active\nRecommended Night Speed: 35-50"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.SourceSans

-- Variables
local SpeedEnabled = false
local AutoFarmEnabled = false
local TargetSpeed = 45

-- Anti-Rubberband Velocity Movement Bypass
RunService.PreRender:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        
        if moveDir.Magnitude > 0 then
            -- تعديل السرعة مع إضافة خفض خفيف جداً متذبذب لمنع كشف الـ Teleport في الليل
            local jitter = (math.random(-5, 5) / 10)
            local currentVel = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(
                moveDir.X * (TargetSpeed + jitter),
                currentVel.Y,
                moveDir.Z * (TargetSpeed + jitter)
            )
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
        TargetSpeed = math.clamp(val, 16, 70)
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
        task.wait(0.6)
        if AutoFarmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetEgg = GetClosestEgg()
            if targetEgg then
                StatusLabel.Text = "Status: Stealing Egg..."
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetEgg.CFrame + Vector3.new(0, 2, 0)
                
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
        AutoFarmToggle.Text = "Auto Steal: ON"
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        AutoFarmToggle.Text = "Auto Steal: OFF"
        AutoFarmToggle.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)
