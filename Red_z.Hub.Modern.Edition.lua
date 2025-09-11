-- Red_z.Hub Modern Edition - Final Version
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

local AutoFarm = false
local AutoFish = false
local AutoCollect = false
local InfiniteJump = false
local CurrentWorld = nil
local Language = nil

-- تعريف العوالم
local Worlds = {
    ["World 1"] = {FarmMobs={"Bandit","Pirate"}, CollectItems={"Fruit","Coins"}, Teleports={Vector3.new(0,10,0)}},
    ["World 2"] = {FarmMobs={"Desert Bandit"}, CollectItems={"Desert Fruit"}, Teleports={Vector3.new(1000,10,0)}},
    ["World 3"] = {FarmMobs={"Sky Pirate"}, CollectItems={"Sky Coins"}, Teleports={Vector3.new(2000,50,0)}}
}

-- دالة Teleport
local function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

-- دوال Auto
local function farmMobs(world)
    while AutoFarm do
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if table.find(world.FarmMobs, mob.Name) and mob:FindFirstChild("HumanoidRootPart") then
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
        print("Fishing...") -- أضف كود الصيد الخاص باللعبة
        wait(3)
    end
end

local function collectItems(world)
    while AutoCollect do
        for _, item in pairs(workspace:GetChildren()) do
            if table.find(world.CollectItems,item.Name) and item:IsA("Part") then
                teleportTo(item.Position + Vector3.new(0,3,0))
                wait(0.1)
            end
        end
        wait(1)
    end
end

-- إنشاء واجهة GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Red_z_Hub_Modern"

-- اختيار اللغة
local LangFrame = Instance.new("Frame", ScreenGui)
LangFrame.Size = UDim2.new(0,300,0,150)
LangFrame.Position = UDim2.new(0.5,-150,0.5,-75)
LangFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
LangFrame.BorderSizePixel = 0
LangFrame.Visible = true

local LangTitle = Instance.new("TextLabel", LangFrame)
LangTitle.Size = UDim2.new(1,0,0,50)
LangTitle.Text = "Choose Language / اختر اللغة"
LangTitle.TextColor3 = Color3.new(1,1,1)
LangTitle.TextSize = 18
LangTitle.BackgroundTransparency = 1

local function createLangButton(name,posY,langCode)
    local btn = Instance.new("TextButton", LangFrame)
    btn.Size = UDim2.new(0,200,0,40)
    btn.Position = UDim2.new(0.5,-100,posY,0)
    btn.Text = name
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        Language = langCode
        LangFrame.Visible = false
        WorldFrame.Visible = true
    end)
end

createLangButton("English",60,"EN")
createLangButton("عربي",110,"AR")

-- اختيار العالم
local WorldFrame = Instance.new("Frame", ScreenGui)
WorldFrame.Size = UDim2.new(0,300,0,200)
WorldFrame.Position = UDim2.new(0.5,-150,0.5,-100)
WorldFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
WorldFrame.Visible = false

local WorldTitle = Instance.new("TextLabel", WorldFrame)
WorldTitle.Size = UDim2.new(1,0,0,50)
WorldTitle.Text = (Language=="AR" and "اختر العالم" or "Choose World")
WorldTitle.TextColor3 = Color3.new(1,1,1)
WorldTitle.TextSize = 18
WorldTitle.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", WorldFrame)
listLayout.Padding = UDim.new(0,10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

for worldName,_ in pairs(Worlds) do
    local btn = Instance.new("TextButton", WorldFrame)
    btn.Size = UDim2.new(0,250,0,40)
    btn.Text = worldName
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        CurrentWorld = worldName
        WorldFrame.Visible = false
        MainFrame.Visible = true
    end)
end

-- الواجهة الرئيسية الحديثة
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,400,0,450)
MainFrame.Position = UDim2.new(0.5,-200,0.5,-225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Visible = false

local mainTitle = Instance.new("TextLabel", MainFrame)
mainTitle.Size = UDim2.new(1,0,0,50)
mainTitle.Text = "Red_z Hub - Modern Edition"
mainTitle.TextColor3 = Color3.new(1,1,1)
mainTitle.TextSize = 22
mainTitle.BackgroundTransparency = 1

-- زر Farm Options على اليسار
local FarmFrame = Instance.new("Frame", MainFrame)
FarmFrame.Size = UDim2.new(0,150,1,0)
FarmFrame.Position = UDim2.new(0,0,0,0)
FarmFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local farmListLayout = Instance.new("UIListLayout", FarmFrame)
farmListLayout.Padding = UDim.new(0,10)
farmListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createToggle(container,name,stateVar,callback)
    local toggle = Instance.new("Frame", container)
    toggle.Size = UDim2.new(0,50,0,30)
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
            toggle.BackgroundColor3 = newState and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
            toggle:TweenPosition(UDim2.new(newState and 0.5 or 0,0,0,0),"Out","Quad",0.2,true)
        end
    end)
end

-- إنشاء كل الخيارات في FarmFrame
local farmOptions = {
    {name="AutoFarm", var=function() return AutoFarm end, func=function(val) AutoFarm=val end},
    {name="AutoFish", var=function() return AutoFish end, func=function(val) AutoFish=val end},
    {name="AutoCollect", var=function() return AutoCollect end, func=function(val) AutoCollect=val end},
    {name="InfiniteJump", var=function() return InfiniteJump end, func=function(val) InfiniteJump=val end}
}

for _,opt in ipairs(farmOptions) do
    local btnContainer = Instance.new("Frame", FarmFrame)
    btnContainer.Size = UDim2.new(1,0,0,40)
    createToggle(btnContainer,opt.name,opt.var,opt.func)
end

-- القوائم الخاصة بالعالم الثالث
local SpecialWorldFrame = Instance.new("Frame", MainFrame)
SpecialWorldFrame.Size = UDim2.new(0,250,0,300)
SpecialWorldFrame.Position = UDim2.new(0.5,-125,0,50)
SpecialWorldFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpecialWorldFrame.Visible = false

local specialTitle = Instance.new("TextLabel", SpecialWorldFrame)
specialTitle.Size = UDim2.new(1,0,0,40)
specialTitle.Text = "Special Islands"
specialTitle.TextColor3 = Color3.new(1,1,1)
specialTitle.TextSize = 18
specialTitle.BackgroundTransparency = 1

local specialListLayout = Instance.new("UIListLayout", SpecialWorldFrame)
specialListLayout.Padding = UDim.new(0,5)
specialListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local specialIslands = {"Kitsune Island","Volcano","Mirage Island"}

for _,island in ipairs(specialIslands) do
    local btn = Instance.new("TextButton", SpecialWorldFrame)
    btn.Size = UDim2.new(1,0,0,35)
    btn.Text = island
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        SpecialWorldFrame.Visible = false
        if CurrentWorld == "World 3" then
            if island == "Kitsune Island" then
                teleportTo(Vector3.new(2100,50,300))
            elseif island == "Volcano" then
                teleportTo(Vector3.new(2200,50,500))
            elseif island == "Mirage Island" then
                teleportTo(Vector3.new(2300,50,700))
            end
        end
    end)
end

-- زر لفتح قائمة الجزر
local specialBtn = Instance.new("TextButton", MainFrame)
specialBtn.Size = UDim2.new(0,120,0,35)
specialBtn.Position = UDim2.new(0.5,-60,1,-50)
specialBtn.Text = "Islands"
specialBtn.TextSize = 16
specialBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
specialBtn.TextColor3 = Color3.new(1,1,1)
specialBtn.MouseButton1Click:Connect(function()
    SpecialWorldFrame.Visible = not SpecialWorldFrame.Visible
end)

-- زر لإخفاء/إظهار MainFrame
local hideBtn = Instance.new("TextButton", ScreenGui)
hideBtn.Size = UDim2.new(0,50,0,50)
hideBtn.Position = UDim2.new(0,10,0,10)
hideBtn.Text = "≡"
hideBtn.TextSize = 24
hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Infinite Jump
UIS.InputBegan:Connect(function(input)
    if InfiniteJump and input.UserInputType==Enum.UserInputType.Keyboard then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("Red_z.Hub Modern Edition - Final Loaded!")
