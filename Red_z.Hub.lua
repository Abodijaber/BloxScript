-- Red_z.Hub.lua
-- النسخة الكاملة لكل عالم

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")

local AutoFarm = false
local CurrentWorld = "Starter Island"

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

-- دالة Auto Farm
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

-- واجهة GUI بسيطة
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Red_z_Hub_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,250,0,300)
Frame.Position = UDim2.new(0,50,0,50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0,230,0,40)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = name
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

-- أزرار العوالم
local y = 10
for worldName,_ in pairs(Worlds) do
    createButton(worldName, y, function()
        CurrentWorld = worldName
        print("Selected World:", CurrentWorld)
    end)
    y = y + 50
end

-- زر تشغيل/ايقاف Auto Farm
createButton("Toggle AutoFarm", y, function()
    AutoFarm = not AutoFarm
    print("AutoFarm:", AutoFarm)
    if AutoFarm then
        spawn(function()
            farmMobs(Worlds[CurrentWorld])
        end)
    end
end)

print("Red_z.Hub Script Fully Loaded!")
