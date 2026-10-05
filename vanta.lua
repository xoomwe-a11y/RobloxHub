-- Anti-AFK Script with Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Anti-AFK | Egg Hunt",
    SubTitle = "by VANTA",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 300),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "shield" })
}

local VirtualUser = game:GetService("VirtualUser")
local AntiAFKEnabled = true

-- Anti-AFK Connection
local IdledConnection
IdledConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

local Toggle = Tabs.Main:AddToggle("AntiAFKToggle", {
    Title = "Enable Anti-AFK",
    Default = true,
    Callback = function(Value)
        AntiAFKEnabled = Value
        if Value then
            Fluent:Notify({
                Title = "Anti-AFK",
                Content = "Status: Activated",
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Anti-AFK",
                Content = "Status: Deactivated",
                Duration = 3
            })
        end
    end
})

Window:SelectTab(1)

Fluent:Notify({
    Title = "Script Loaded",
    Content = "Press Left Control to hide/show UI",
    Duration = 5
})
