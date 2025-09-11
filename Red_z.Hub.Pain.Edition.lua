-- Red_z.Hub Pain Edition
-- النسخة النهائية مع أزرار On/Off متحركة

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local AutoFarm = false
local AutoFish = false
local InfiniteJump = false
local CurrentWorld = "World 1"
local Language = "EN"

-- تعريف العوالم
local Worlds = {
    ["World 1"] = {FarmMobs={"Bandit","Pirate"}, CollectItems={"Fruit","Coins"}, Teleports={Vector3.new(0,10,0)}},
    ["World 2"] = {FarmMobs={"Desert Bandit"}, CollectItems={"Desert Fruit"}, Teleports={Vector3.new(1000,10,0)}},
    ["World 3"] = {FarmMobs={"Sky Pirate"}, CollectItems={"Sky Coins"}, Teleports={Vector3.new(2000,50,0)}}
}

-- دوال التليبورط والوظائف
local function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

local function farmMobs(world)
    while AutoFarm do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if table.find(world.FarmMobs,mob.Name) and mob:FindFirstChild("HumanoidRootPart") then
                teleportTo(mob.HumanoidRootPart.Position + Vector3.new(0,3,0))
                wait(0.2)
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
        wait(1)
    end
end

local function fish()
    while AutoFish do
        print("Fishing...") -- هنا تضيف كود الصيد حسب لعبتك
        wait(3)
    end
end

-- إنشاء واجهة GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Red_z_Hub_GUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0,350,0,450)
Frame.Position = UDim2.new(0,50,0,50)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Visible = false
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22
Title.Text = "Red_z.Hub - Pain Edition"

-- زر اللغة
local LanguageButton = Instance.new("TextButton", Frame)
LanguageButton.Size = UDim2.new(0,120,0,30)
LanguageButton.Position = UDim2.new(0,10,0,60)
LanguageButton.Text = Language
LanguageButton.MouseButton1Click:Connect(function()
    if Language == "EN" then
        Language = "AR"
        LanguageButton.Text = "AR"
        Title.Text = "Red_z.Hub - إصدار Pain"
    else
        Language = "EN"
        LanguageButton.Text = "EN"
        Title.Text = "Red_z.Hub - Pain Edition"
    end
end)

-- دالة إنشاء زر On/Off متحرك
local function createToggle(name, posY, stateVar, callback)
    local container = Instance.new("Frame", Frame)
    container.Size = UDim2.new(0,120,0,30)
    container.Position = UDim2.new(0,10,posY,0)
    container.BackgroundColor3 = Color3.fromRGB(50,50,50)
    
    local toggle = Instance.new("Frame", container)
    toggle.Size = UDim2.new(0,50,1,0)
    toggle.Position = UDim2.new(0,0,0,0)
    toggle.BackgroundColor3 = stateVar() and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
    
    local lbl = Instance.new("TextLabel", container)
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Text = name
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextSize = 16
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local newState = not stateVar()
            callback(newState)
            if newState then
                toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
                toggle:TweenPosition(UDim2.new(0.5,0,0,0),"Out","Quad",0.2,true)
            else
                toggle.BackgroundColor3 = Color3.fromRGB(100,100,100)
                toggle:TweenPosition(UDim2.new(0,0,0,0),"Out","Quad",0.2,true)
            end
        end
    end)
end

-- إنشاء أزرار Toggle لكل خيار
createToggle("AutoFarm",0,function() return AutoFarm end,function(val) 
    AutoFarm = val
    if AutoFarm then spawn(function() farmMobs(Worlds[CurrentWorld]) end) end
end)

createToggle("AutoFish",40,function() return AutoFish end,function(val)
    AutoFish = val
    if AutoFish then spawn(function() fish() end) end
end)

createToggle("InfiniteJump",80,function() return InfiniteJump end,function(val)
    InfiniteJump = val
end)

-- تشغيل Infinite Jump
UIS.InputBegan:Connect(function(input)
    if InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- زر اختيار العالم
local y = 130
for worldName,_ in pairs(Worlds) do
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0,120,0,30)
    btn.Position = UDim2.new(0,10,y,0) -- تم التصحيح هنا
    btn.Text = worldName
    btn.MouseButton1Click:Connect(function()
        CurrentWorld = worldName
        print("Selected World:",CurrentWorld)
    end)
    y = y + 40
end

-- زر R_z لتفعيل/إخفاء الواجهة
local RzButton = Instance.new("ImageButton", ScreenGui)
RzButton.Size = UDim2.new(0,50,0,50)
RzButton.Position = UDim2.new(0,10,0,10)
RzButton.Image = "rbxassetid://10893992706" -- ضع هنا صورة شعار R_z
RzButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

print("Red_z.Hub Pain Edition Loaded!")
