-- [[ Vanta Hub : Automated Egg Stealer & Collector ]] --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function getNearestEgg()
    local nearest = nil
    local shortestDist = math.huge
    local char = LocalPlayer.Character
    
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrpPos = char.HumanoidRootPart.Position
        for _, obj in pairs(workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("egg") or name:find("collect")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local targetPart = obj:IsA("Model") and obj.PrimaryPart or obj
                if targetPart then
                    local dist = (targetPart.Position - hrpPos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        nearest = targetPart
                    end
                end
            end
        end
    end
    return nearest
end

-- دالة النقل التدريجي الآمن (تتجنب كشف السيرفر وترجع البيضة)
local function safeTweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = 80 -- سرعة متوازنة لتجنب رسالة Delivery failed
        local duration = distance / speed
        
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- تشغيل حلقة التجميع التلقائي
task.spawn(function()
    while true do
        pcall(function()
            local egg = getNearestEgg()
            if egg then
                -- الانتقال لمكان البيضة بسلاسة
                safeTweenTo(egg.CFrame + Vector3.new(0, 3, 0))
                
                -- محاكاة التفاعل أو إرسال طلب التجميع لو وجد Remote مرتبط
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") and (v.Name:lower():find("egg") or v.Name:lower():find("collect")) then
                        v:FireServer()
                    end
                end
            end
        end)
        task.wait(1)
    end
end)

print("تم تفعيل نظام سرقة البيض التلقائي!")
