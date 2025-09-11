-- Blox Fruits Mini Hub
-- نسخة تجريبية، استعمل على مسؤوليتك

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Toggle Auto Farm
local AutoFarm = true

function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

function farmBandits()
    while AutoFarm do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob.Name == "Bandit" and mob:FindFirstChild("HumanoidRootPart") then
                teleportTo(mob.HumanoidRootPart.Position + Vector3.new(0,3,0))
                wait(0.2)
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
        wait(1)
    end
end

-- تشغيل Auto Farm في Thread جديد
spawn(farmBandits)

-- Teleports (مثال)
local Teleports = {
    ["Starter Island"] = Vector3.new(0,10,0),
    ["Desert Island"] = Vector3.new(1000,10,0)
}

-- مثال على استخدام Teleport
teleportTo(Teleports["Starter Island"])
print("Mini Hub Script Running!")
