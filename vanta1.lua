-- Anti-AFK Stealth Bypass (Restructured)
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- State Management
local AntiAFKState = {
    Enabled = true,
    Interval = 120 -- Interval in seconds for background input simulation
}

-- UI Theme Constants
local THEME = {
    Background = Color3.fromRGB(20, 20, 25),
    Header = Color3.fromRGB(30, 30, 38),
    Active = Color3.fromRGB(46, 204, 113),
    Disabled = Color3.fromRGB(231, 76, 60),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(180, 180, 180)
}

-- Helper Component Builder
local function CreateElement(className, properties)
    local instance = Instance.new(className)
    for prop, val in pairs(properties) do
        instance[prop] = val
    end
    return instance
end

-- Interface Initialization
local ScreenGui = CreateElement("ScreenGui", {
    Name = "AntiAFK_Refactored",
    ResetOnSpawn = false,
    Parent = PlayerGui
})

local MainFrame = CreateElement("Frame", {
    Name = "MainContainer",
    Size = UDim2.new(0, 220, 0, 130),
    Position = UDim2.new(0.05, 0, 0.4, 0),
    BackgroundColor3 = THEME.Background,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = ScreenGui
})

CreateElement("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MainFrame })

local TitleLabel = CreateElement("TextLabel", {
    Name = "HeaderTitle",
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = THEME.Header,
    Text = "Anti-AFK System",
    TextColor3 = THEME.TextPrimary,
    TextSize = 14,
    Font = Enum.Font.SourceSansBold,
    Parent = MainFrame
})

CreateElement("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TitleLabel })

local ToggleButton = CreateElement("TextButton", {
    Name = "ToggleAction",
    Size = UDim2.new(0.8, 0, 0.32, 0),
    Position = UDim2.new(0.1, 0, 0.38, 0),
    BackgroundColor3 = THEME.Active,
    Text = "Anti-AFK: ON",
    TextColor3 = THEME.TextPrimary,
    TextSize = 14,
    Font = Enum.Font.SourceSansBold,
    Parent = MainFrame
})

CreateElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ToggleButton })

local StatusLabel = CreateElement("TextLabel", {
    Name = "StatusDisplay",
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0.75, 0),
    BackgroundTransparency = 1,
    Text = "Status: Active",
    TextColor3 = THEME.TextMuted,
    TextSize = 12,
    Font = Enum.Font.SourceSans,
    Parent = MainFrame
})

-- UI Controller
local function UpdateUIState()
    if AntiAFKState.Enabled then
        ToggleButton.Text = "Anti-AFK: ON"
        ToggleButton.BackgroundColor3 = THEME.Active
        StatusLabel.Text = "Status: Active"
        StatusLabel.TextColor3 = THEME.TextMuted
    else
        ToggleButton.Text = "Anti-AFK: OFF"
        ToggleButton.BackgroundColor3 = THEME.Disabled
        StatusLabel.Text = "Status: Disabled"
        StatusLabel.TextColor3 = THEME.Disabled
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    AntiAFKState.Enabled = not AntiAFKState.Enabled
    UpdateUIState()
end)

-- Anti-AFK Engine (Stealth Key/Mouse Events without Humanoid Manipulation)
local function TriggerStealthInput()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Catch Roblox's Idled Signal
LocalPlayer.Idled:Connect(function()
    if AntiAFKState.Enabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

-- Interval Loop Routine
task.spawn(function()
    while true do
        task.wait(AntiAFKState.Interval)
        if AntiAFKState.Enabled then
            TriggerStealthInput()
        end
    end
end)
