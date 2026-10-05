-- Anti-AFK + Server Hopper to Solo Server
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local SoloBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.Size = UDim2.new(0, 220, 0, 170)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "Anti-AFK & Solo Server"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold

-- Anti-AFK Toggle Button
ToggleBtn.Parent = Frame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleBtn.Text = "Anti-AFK: ON"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold

-- Join Solo Server Button
SoloBtn.Parent = Frame
SoloBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
SoloBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
SoloBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SoloBtn.Text = "Join Solo Server"
SoloBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SoloBtn.TextSize = 14
SoloBtn.Font = Enum.Font.SourceSansBold

StatusLabel.Parent = Frame
StatusLabel.Position = UDim2.new(0, 0, 0.83, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SourceSans

local Enabled = true

ToggleBtn.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    if Enabled then
        ToggleBtn.Text = "Anti-AFK: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        StatusLabel.Text = "Status: Anti-AFK Active"
    else
        ToggleBtn.Text = "Anti-AFK: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        StatusLabel.Text = "Status: Anti-AFK Disabled"
    end
end)

-- Solo Server Finder Logic
local function JoinSoloServer()
    StatusLabel.Text = "Searching for solo server..."
    SoloBtn.Text = "Searching..."
    
    local placeId = game.PlaceId
    local currentJobId = game.JobId
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if not req then
        StatusLabel.Text = "Error: Executor unsupported"
        SoloBtn.Text = "Join Solo Server"
        return
    end

    local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    local success, response = pcall(function()
        return req({Url = url, Method = "GET"})
    end)

    if success and response and response.Body then
        local data = HttpService:JSONDecode(response.Body)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId then
                    if server.playing == 1 or server.playing == 0 then
                        StatusLabel.Text = "Teleporting..."
                        TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                        return
                    end
                end
            end
            
            -- If no 1-player server is found immediately, pick the smallest available server
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= currentJobId then
                    StatusLabel.Text = "Teleporting to low player server..."
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    return
                end
            end
        end
    end
    
    StatusLabel.Text = "Failed to find server"
    SoloBtn.Text = "Join Solo Server"
end

SoloBtn.MouseButton1Click:Connect(function()
    JoinSoloServer()
end)

-- Anti-AFK Loop
task.spawn(function()
    while true do
        task.wait(60)
        if Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Jump = true
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Enabled then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end)
