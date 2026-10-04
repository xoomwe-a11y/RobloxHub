-- [[ Vanta Hub : Steal an Egg Direct Script ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إشعار تأكيد التشغيل
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Vanta Hub",
    Text = "تم حقن السكربت بنجاح في ماب Steal an Egg!",
    Duration = 4
})

-- 1. كسر السرعة وتثبيتها بشكل إجباري (Speed Force)
local speedEnabled = true
local targetSpeed = 28 -- سرعة قوية وآمنة

RunService.Heartbeat:Connect(function()
    if speedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = targetSpeed
            end
        end)
    end
end)

-- 2. إظهار أماكن البيض ببحث شامل ودقيق (ESP)
pcall(function()
    local count = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("egg") or name:find("collect")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
            local target = obj:IsA("Model") and obj.PrimaryPart or obj
            if target and not target:FindFirstChild("VantaESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "VantaESP"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(0, 255, 100)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Parent = obj
                count = count + 1
            end
        end
    end
    print("[Vanta Hub] تم تفعيل رادار البيض، عدد العناصر المحددة: " .. count)
end)
