-- Blox Fruits Auto Farm Script
-- استعمل على مسؤوليتك

repeat wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- دالة للانتقال
local function tpTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

-- تليفيل على Bandits
while true do
    pcall(function()
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob.Name == "Bandit" and mob:FindFirstChild("HumanoidRootPart") then
                tpTo(mob.HumanoidRootPart.Position + Vector3.new(0,3,0))
                wait(0.3)
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
    end)
    wait(1)
end
