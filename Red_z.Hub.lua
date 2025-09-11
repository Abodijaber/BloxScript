-- Red_z.Hub.lua
-- نسخة تجريبية لكل عالم، استعمل على مسؤوليتك

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local AutoFarm = false

-- تعريف العوالم والوظائف لكل عالم
local Worlds = {
    ["Starter Island"] = {
        Teleports = {Vector3.new(0,10,0)},
        FarmMobs = {"Bandit","Pirate"},
        CollectItems = {"Fruit","Coins"}
    },
    ["Desert Island"] = {
        Teleports = {Vector3.new(1000,10,0)},
        FarmMobs = {"Desert Bandit"},
        CollectItems = {"Desert Fruit"}
    },
    ["Sky Island"] = {
        Teleports = {Vector3.new(2000,50,0)},
        FarmMobs = {"Sky Pirate"},
        CollectItems = {"Sky Coins"}
    }
}

-- دالة التليبورط
local function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

-- دالة Auto Farm للوحوش
local function farmMobs(world)
    while AutoFarm do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if table.find(world.FarmMobs,mob.Name) and mob:FindFirstChild("HumanoidRootPart") then
                local mobPos = mob.HumanoidRootPart.Position
                teleportTo(mobPos + Vector3.new(0,3,0))
                wait(0.2)
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
        wait(1)
    end
end

-- مثال على تشغيل Auto Farm للعالم الأول
AutoFarm = true
spawn(function()
    farmMobs(Worlds["Starter Island"])
end)

print("Red_z.Hub Script Running!")
