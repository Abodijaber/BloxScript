-- Red_z.Hub Modern Edition - Full Ultimate
-- ملف: Red_z.Hub.Modern.Edition.lua
-- تحذير: الاستخدام على مسؤوليتك، قد يخالف شروط اللعبة.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ======= الحالة والقيم =======
local state = {
    AutoFarm = false,
    AutoFish = false,
    AutoCollect = false,
    AutoRaid = false,
    AutoEvent = false,
    InfiniteJump = false,
    WalkSpeed = 16,
    CurrentWorld = nil,
    Language = "EN",
    AttackDistance = {5,10},
    AttackDelay = 0.1
}

-- ======= تعريف العوالم =======
local Worlds = {
    ["World 1"] = {
        FarmMobs = {"Bandit","Pirate"},
        CollectItems = {"Fruit","Coins"},
        Raids = {},
        Teleports = {["Spawn"] = Vector3.new(0,10,0)}
    },
    ["World 2"] = {
        FarmMobs = {"Desert Bandit"},
        CollectItems = {"Desert Fruit"},
        Raids = {"SharkRaid","ShipRaid"},
        Teleports = {["Desert"] = Vector3.new(1000,10,0)}
    },
    ["World 3"] = {
        FarmMobs = {"Sky Pirate"},
        CollectItems = {"Sky Coins"},
        Raids = {"MirageRaid"},
        Teleports = {["Sky"] = Vector3.new(2000,50,0)},
        Islands = {
            Kitsune = Vector3.new(2100,50,100),
            Volcano = Vector3.new(2200,50,200),
            Mirage = Vector3.new(2300,50,300)
        }
    }
}

-- ======= دوال مساعدة =======
local function safeTeleport(pos)
    if not pos then return end
    pcall(function() hrp.CFrame = CFrame.new(pos) end)
end

local function findNearestMob(names)
    local nearest = nil
    local nd = math.huge
    if workspace:FindFirstChild("Enemies") then
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") then
                for _, name in ipairs(names) do
                    if mob.Name:lower():find(name:lower()) then
                        local d = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if d < nd then
                            nd = d
                            nearest = mob
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function attackMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    local distance = math.random(state.AttackDistance[1], state.AttackDistance[2])
    local dir = (mob.HumanoidRootPart.Position - hrp.Position).Unit
    local attackPos = mob.HumanoidRootPart.Position - dir*distance
    safeTeleport(attackPos)
    wait(0.05)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.Activate then
        tool:Activate()
    end
end

-- ======= حلقات Auto =======
local function autoFarmLoop()
    while state.AutoFarm do
        if state.CurrentWorld then
            local world = Worlds[state.CurrentWorld]
            local mob = findNearestMob(world.FarmMobs)
            if mob then
                attackMob(mob)
                wait(state.AttackDelay)
            end
        end
        wait(0.1)
    end
end

local function autoFishLoop()
    while state.AutoFish do
        print("[AutoFish] running...")
        wait(3)
    end
end

local function autoCollectLoop()
    while state.AutoCollect do
        if state.CurrentWorld then
            local world = Worlds[state.CurrentWorld]
            for _, item in pairs(workspace:GetChildren()) do
                if (item:IsA("Part") or item:IsA("Model")) then
                    for _, name in ipairs(world.CollectItems) do
                        if tostring(item.Name):lower():find(name:lower()) then
                            if item:IsA("BasePart") then
                                safeTeleport(item.Position + Vector3.new(0,3,0))
                            elseif item:FindFirstChild("PrimaryPart") then
                                safeTeleport(item.PrimaryPart.Position + Vector3.new(0,3,0))
                            end
                            wait(0.1)
                        end
                    end
                end
            end
        end
        wait(0.5)
    end
end

local function autoRaidLoop()
    while state.AutoRaid do
        print("[AutoRaid] running (game logic required)")
        wait(2)
    end
end

local function autoEventLoop()
    while state.AutoEvent do
        print("[AutoEvent] running (game logic required)")
        wait(2)
    end
end

-- ======= كشف العالم تلقائي =======
local function detectWorld()
    for name,_ in pairs(Worlds) do
        if workspace:FindFirstChild(name) then
            state.CurrentWorld = name
            return
        end
    end
    local pos = hrp.Position
    if pos.X > 1800 then
        state.CurrentWorld = "World 3"
    elseif pos.X > 800 then
        state.CurrentWorld = "World 2"
    else
        state.CurrentWorld = "World 1"
    end
end

spawn(function()
    wait(1)
    pcall(detectWorld)
end)

-- ======= إنشاء واجهة =======
local function make(parent, class, props)
    local obj = Instance.new(class)
    obj.Parent = parent
    for k,v in pairs(props) do obj[k]=v end
    return obj
end

local screen = make(CoreGui,"ScreenGui",{Name="Redz_Modern_UI",ResetOnSpawn=false})
local main = make(screen,"Frame",{Size=UDim2.new(0,520,0,520),Position=UDim2.new(0.5,-260,0.5,-260),BackgroundColor3=Color3.fromRGB(20,20,20),BorderSizePixel=0})

local title = make(main,"TextLabel",{Size=UDim2.new(1,0,0,50),BackgroundTransparency=1,Text="Redz-Style Hub (Modern)",TextColor3=Color3.fromRGB(240,240,240),TextSize=20,Font=Enum.Font.SourceSansBold})

local hideBtn = make(main,"TextButton",{Size=UDim2.new(0,44,0,44),Position=UDim2.new(1,-54,0,6),Text="≡",TextSize=20,BackgroundColor3=Color3.fromRGB(60,60,60),TextColor3=Color3.fromRGB(255,255,255)})

local left = make(main,"Frame",{Size=UDim2.new(0,160,1,-60),Position=UDim2.new(0,10,0,60),BackgroundColor3=Color3.fromRGB(28,28,28),BorderSizePixel=0})
local leftLayout = Instance.new("UIListLayout", left)
leftLayout.Padding = UDim.new(0,8)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

local content = make(main,"Frame",{Size=UDim2.new(1,-190,1,-60),Position=UDim2.new(0,180,0,60),BackgroundColor3=Color3.fromRGB(22,22,22),BorderSizePixel=0})
local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0,8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local statusBar = make(main,"Frame",{Size=UDim2.new(1,-20,0,40),Position=UDim2.new(0,10,1,-46),BackgroundColor3=Color3.fromRGB(18,18,18),BorderSizePixel=0})
local statusLabel = make(statusBar,"TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="Status: Idle",TextColor3=Color3.fromRGB(180,180,180),TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})

-- ======= دوال مساعدة للواجهة =======
local function clearContent()
    for _,c in pairs(content:GetChildren()) do if not c:IsA("UIListLayout") then c:Destroy() end end
end
local function updateStatus()
    statusLabel.Text = string.format("Status: %s | World: %s | Speed: %d",
        (state.AutoFarm or state.AutoFish or state.AutoCollect or state.AutoRaid or state.AutoEvent) and "Active" or "Idle",
        tostring(state.CurrentWorld or "Unknown"),
        state.WalkSpeed
    )
end

local function createToggleRow(parent,labelText,getter,setter)
    local row = make(parent,"Frame",{Size=UDim2.new(1,0,0,36),BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0})
    local lbl = make(row,"TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=labelText,TextColor3=Color3.fromRGB(230,230,230),TextSize=16,TextXAlignment=Enum.TextXAlignment.Left})
    local btn = make(row,"TextButton",{Size=UDim2.new(0.28,0,0.9,0),Position=UDim2.new(0.72,0,0.05,0),Text=getter() and "ON" or "OFF",BackgroundColor3=getter() and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90),TextColor3=Color3.fromRGB(1,1,1),TextSize=14})
    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.Text = new and "ON" or "OFF"
        btn.BackgroundColor3 = new and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90)
        updateStatus()
    end)
end

-- ======= قوائم اليسار =======
local menus = {}
local function addMenu(name,callback)
    local btn = make(left,"TextButton",{Size=UDim2.new(1,0,0,44),Text=name,BackgroundColor3=Color3.fromRGB(45,45,45),TextColor3=Color3.fromRGB(255,255,255),TextSize=16})
    btn.MouseButton1Click:Connect(function()
        for _,child in ipairs(left:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3=Color3.fromRGB(45,45,45) end end
        btn.BackgroundColor3=Color3.fromRGB(70,70,70)
        clearContent()
        callback()
    end)
    menus[name]=btn
    return btn
end

-- ======= Menu: Auto =======
addMenu("Auto",function()
    make(content,"TextLabel",{Size=UDim2.new(1,0,0,30),Text="Auto Options",TextSize=18,BackgroundTransparency=1,TextColor3=Color3.fromRGB(245,245,245)})
    createToggleRow(content,"AutoFarm (mobs)",function() return state.AutoFarm end,function(v) state.AutoFarm=v; if v then spawn(autoFarmLoop) end end)
    createToggleRow(content,"AutoFish",function() return state.AutoFish end,function(v) state.AutoFish=v; if v then spawn(autoFishLoop) end end)
    createToggleRow(content,"AutoCollect (items)",function() return state.AutoCollect end,function(v) state.AutoCollect=v; if v then spawn(autoCollectLoop) end end)
    createToggleRow(content,"AutoRaid",function() return state.AutoRaid end,function(v) state.AutoRaid=v; if v then spawn(autoRaidLoop) end end)
    createToggleRow(content,"AutoEvent",function() return state.AutoEvent end,function(v) state.AutoEvent=v; if v then spawn(autoEventLoop) end end)
    createToggleRow(content,"Infinite Jump",function() return state.InfiniteJump end,function(v) state.InfiniteJump=v end)
end)

-- ======= باقي القوائم مشابهة (Tasks, Raids, Islands, Settings) =======
-- يمكنك تكرار نفس الأسلوب الذي وضعت للأوتو لبقية القوائم
-- مع وضع أزرار لكل مهمة، رايد، جزيرة، وكود السرعة

-- ======= زر اخفاء الواجهة =======
hideBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ======= تحديث الحالة تلقائياً =======
spawn(function()
    while true do
        updateStatus()
        wait(1)
    end
end)

spawn(function()
    while true do
        pcall(detectWorld)
        wait(3)
    end
end)

-- ======= Infinite Jump =======
UIS.InputBegan:Connect(function(input)
    if state.InfiniteJump and input.UserInputType==Enum.UserInputType.Keyboard then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("Red_z.Hub Modern Edition Loaded. Use menus to toggle features. Some features require game-specific implementation (quests, raids, events, fishing).")
