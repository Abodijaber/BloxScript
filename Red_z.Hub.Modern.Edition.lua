-- Red_z.Hub.Modern.Edition.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- المتغيرات
local AutoFarm = false
local AutoFish = false
local AutoCollect = false
local InfiniteJump = false
local CurrentWorld = nil

-- تعريف العوالم
local Worlds = {
    ["World 1"] = {FarmMobs={"Bandit","Pirate"}, CollectItems={"Fruit","Coins"}, Raids={}, Teleports={Vector3.new(0,10,0)}},
    ["World 2"] = {FarmMobs={"Desert Bandit"}, CollectItems={"Desert Fruit"}, Raids={"Shark","Ship"}, Teleports={Vector3.new(1000,10,0)}, Islands={"Kitsune","Volcano"}},
    ["World 3"] = {FarmMobs={"Sky Pirate"}, CollectItems={"Sky Coins"}, Raids={"Mirage"}, Teleports={Vector3.new(2000,50,0)}, Islands={"Mirage"}}
}

-- دالة Teleport
local function teleportTo(pos)
    hrp.CFrame = CFrame.new(pos)
end

-- Auto Functions
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
        -- ضع كود الصيد هنا
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

-- إنشاء GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Red_z_Hub_Modern"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0,450,0,500)
MainFrame.Position = UDim2.new(0.5,-225,0.5,-250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Visible = true
MainFrame.ClipsDescendants = true

local mainTitle = Instance.new("TextLabel", MainFrame)
mainTitle.Size = UDim2.new(1,0,0,50)
mainTitle.Text = "Red_z Hub - Modern Edition"
mainTitle.TextColor3 = Color3.new(1,1,1)
mainTitle.TextSize = 22
mainTitle.BackgroundTransparency = 1

-- زر إخفاء/إظهار القائمة
local HideBtn = Instance.new("TextButton", MainFrame)
HideBtn.Size = UDim2.new(0,50,0,30)
HideBtn.Position = UDim2.new(1,-60,0,10)
HideBtn.Text = "X"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- القوائم الجانبية
local SideFrame = Instance.new("Frame", MainFrame)
SideFrame.Size = UDim2.new(0,150,1,0)
SideFrame.Position = UDim2.new(0,0,0,0)
SideFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)

local SideLayout = Instance.new("UIListLayout", SideFrame)
SideLayout.Padding = UDim.new(0,10)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- دالة إنشاء زر رئيسي للقائمة
local function createMenuButton(name, callback)
    local btn = Instance.new("TextButton", SideFrame)
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(callback)
end

-- القوائم الرئيسية
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1,-160,1,0)
ContentFrame.Position = UDim2.new(0,150,0,0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function clearContent()
    for _,c in pairs(ContentFrame:GetChildren()) do
        if not c:IsA("UIListLayout") then
            c:Destroy()
        end
    end
end

local Layout = Instance.new("UIListLayout", ContentFrame)
Layout.Padding = UDim.new(0,10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- زر قائمة AutoFarm
createMenuButton("AutoFarm",function()
    clearContent()
    local toggles = {
        {name="AutoFarm",var=function() return AutoFarm end,func=function(val) AutoFarm=val if val and CurrentWorld then spawn(function() farmMobs(Worlds[CurrentWorld]) end) end end},
        {name="AutoFish",var=function() return AutoFish end,func=function(val) AutoFish=val if val then spawn(fish) end end},
        {name="AutoCollect",var=function() return AutoCollect end,func=function(val) AutoCollect=val if val and CurrentWorld then spawn(function() collectItems(Worlds[CurrentWorld]) end) end end},
        {name="InfiniteJump",var=function() return InfiniteJump end,func=function(val) InfiniteJump=val end}
    }
    for _,opt in ipairs(toggles) do
        local container = Instance.new("Frame", ContentFrame)
        container.Size = UDim2.new(1,0,0,30)
        container.BackgroundColor3 = Color3.fromRGB(50,50,50)
        local lbl = Instance.new("TextLabel", container)
        lbl.Size = UDim2.new(0.7,0,1,0)
        lbl.Text = opt.name
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextSize = 16

        local toggleBtn = Instance.new("TextButton", container)
        toggleBtn.Size = UDim2.new(0.3,0,1,0)
        toggleBtn.Position = UDim2.new(0.7,0,0,0)
        toggleBtn.Text = opt.var() and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = opt.var() and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
        toggleBtn.TextColor3 = Color3.new(1,1,1)
        toggleBtn.MouseButton1Click:Connect(function()
            local newState = not opt.var()
            opt.func(newState)
            toggleBtn.Text = newState and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(0,255,0) or Color3.fromRGB(100,100,100)
        end)
    end
end)

-- يمكنك إضافة القوائم الأخرى بنفس الطريقة مثل Settings, Raids, Islands…
-- إعدادات السرعة:
createMenuButton("Settings",function()
    clearContent()
    local speedLabel = Instance.new("TextLabel", ContentFrame)
    speedLabel.Size = UDim2.new(1,0,0,30)
    speedLabel.Text = "Speed"
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.TextSize = 16

    local SpeedSlider = Instance.new("TextBox", ContentFrame)
    SpeedSlider.Size = UDim2.new(1,0,0,30)
    SpeedSlider.PlaceholderText = "25-300"
    SpeedSlider.Text = "100"
    SpeedSlider.TextColor3 = Color3.new(1,1,1)
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    SpeedSlider.FocusLost:Connect(function()
        local val = tonumber(SpeedSlider.Text)
        if val then
            if val < 25 then val = 25 end
            if val > 300 then val = 300 end
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)
end)

-- تفعيل القفز اللانهائي
UIS.InputBegan:Connect(function(input)
    if InfiniteJump and input.UserInputType==Enum.UserInputType.Keyboard then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- تحديد العالم الحالي تلقائياً عند الدخول
local function detectWorld()
    for worldName,_ in pairs(Worlds) do
        if workspace:FindFirstChild(worldName) then
            CurrentWorld = worldName
            break
        end
    end
end

spawn(detectWorld)

print("Red_z.Hub Modern Edition Loaded!")
