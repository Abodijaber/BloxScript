-- Red_z.Hub Modern Edition - Full Final
-- وضع: جاهز للصق في ملف Red_z.Hub.Modern.Edition.lua
-- تحذير: استخدم على مسؤوليتك. قد يخالف شروط اللعبة.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ======= القيم والتحكم =======
local state = {
    AutoFarm = false,
    AutoFish = false,
    AutoCollect = false,
    InfiniteJump = false,
    AutoRaid = false,
    AutoEvent = false,
    WalkSpeed = 16,
    CurrentWorld = nil,
    Language = "EN", -- not used for full translation but kept
}

-- تعريف العوالم: عدل الأسماء/الإحداثيات بحسب لعبتك
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
        Raids = {"SharkRaid","ShipRaid"}, -- أمثلة
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
    for _, mob in pairs(workspace:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildWhichIsA and mob:IsA then
            -- try to match by name (adjust depending on game's structure)
        end
    end
    -- Prefer using workspace.Enemies if exists:
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

-- ======= عمليات Auto (تفعيل يدوي عبر الأزرار) =======
local function autoFarmLoop()
    while state.AutoFarm do
        if not state.CurrentWorld then
            wait(1)
        else
            local world = Worlds[state.CurrentWorld]
            if world then
                local mob = findNearestMob(world.FarmMobs)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    safeTeleport(mob.HumanoidRootPart.Position + Vector3.new(0,3,0))
                    wait(0.2)
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and tool.Activate then
                        pcall(function() tool:Activate() end)
                    end
                end
            end
            wait(0.8)
        end
    end
end

local function autoFishLoop()
    while state.AutoFish do
        -- ملاحظة: تحتاج إضافة منطق النقر على البقعة والمراقبة حسب لعبتك
        -- مثال تجريبي: تكرار وانتظار
        print("[AutoFish] attempt")
        wait(3)
    end
end

local function autoCollectLoop()
    while state.AutoCollect do
        if state.CurrentWorld then
            local world = Worlds[state.CurrentWorld]
            if world and world.CollectItems then
                for _, it in pairs(workspace:GetChildren()) do
                    if it:IsA("Part") or it:IsA("Model") then
                        for _, name in ipairs(world.CollectItems) do
                            if tostring(it.Name):lower():find(name:lower()) then
                                if it:IsA("BasePart") then
                                    safeTeleport(it.Position + Vector3.new(0,3,0))
                                elseif it:FindFirstChild("PrimaryPart") then
                                    safeTeleport(it.PrimaryPart.Position + Vector3.new(0,3,0))
                                end
                                wait(0.15)
                            end
                        end
                    end
                end
            end
        end
        wait(1)
    end
end

local function autoRaidLoop()
    while state.AutoRaid do
        -- اضافة منطق الرايد حسب لعبتك
        print("[AutoRaid] loop running (needs game-specific logic)")
        wait(2)
    end
end

local function autoEventLoop()
    while state.AutoEvent do
        -- منطق الايفنتات هنا
        print("[AutoEvent] loop running (needs game-specific logic)")
        wait(2)
    end
end

-- ======= كشف العالم تلقائياً =======
local function detectWorld()
    -- حاول استنتاج العالم عبر وجود مجلد في workspace أو عبر موقع HumanoidRootPart
    -- هذا مثال مبسط: لو فيه مجلد باسم World 2 ... إلخ
    for name,_ in pairs(Worlds) do
        if workspace:FindFirstChild(name) then
            state.CurrentWorld = name
            return
        end
    end
    -- fallback: حسب X,Z موقع HRP
    local pos = hrp.Position
    if pos.X > 1800 then
        state.CurrentWorld = "World 3"
    elseif pos.X > 800 then
        state.CurrentWorld = "World 2"
    else
        state.CurrentWorld = "World 1"
    end
end

-- أول كشف عند البدء
spawn(function()
    wait(1)
    pcall(detectWorld)
end)

-- ======= UI helper factories =======
local function makeText(parent, props)
    local t = Instance.new("TextLabel")
    t.Parent = parent
    for k,v in pairs(props or {}) do
        t[k] = v
    end
    return t
end

local function makeButton(parent, props)
    local b = Instance.new("TextButton")
    b.Parent = parent
    for k,v in pairs(props or {}) do
        b[k] = v
    end
    return b
end

local function makeFrame(parent, props)
    local f = Instance.new("Frame")
    f.Parent = parent
    for k,v in pairs(props or {}) do
        f[k] = v
    end
    return f
end

-- ======= بناء الواجهة =======
local screen = Instance.new("ScreenGui")
screen.Name = "Redz_Modern_UI"
screen.Parent = CoreGui
screen.ResetOnSpawn = false

local main = makeFrame(screen, {
    Name = "MainFrame",
    Size = UDim2.new(0,520,0,520),
    Position = UDim2.new(0.5,-260,0.5,-260),
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BorderSizePixel = 0,
    Visible = true,
})

-- Title area
local title = makeText(main, {
    Size = UDim2.new(1,0,0,50),
    Position = UDim2.new(0,0,0,0),
    BackgroundTransparency = 1,
    Text = "Redz-Style Hub (Modern)",
    TextColor3 = Color3.fromRGB(240,240,240),
    TextSize = 20,
    Font = Enum.Font.SourceSansBold,
})

-- Hide/Show small button (similar to image style)
local hideBtn = makeButton(main, {
    Size = UDim2.new(0,44,0,44),
    Position = UDim2.new(1,-54,0,6),
    Text = "≡",
    TextSize = 20,
    BackgroundColor3 = Color3.fromRGB(60,60,60),
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = true,
})

-- Left menu (main categories)
local left = makeFrame(main, {
    Size = UDim2.new(0,160,1,-60),
    Position = UDim2.new(0,10,0,60),
    BackgroundColor3 = Color3.fromRGB(28,28,28),
    BorderSizePixel = 0,
})
local leftLayout = Instance.new("UIListLayout", left)
leftLayout.Padding = UDim.new(0,8)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content area
local content = makeFrame(main, {
    Size = UDim2.new(1,-190,1,-60),
    Position = UDim2.new(0,180,0,60),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    BorderSizePixel = 0,
})
local contentLayout = Instance.new("UIListLayout", content)
contentLayout.Padding = UDim.new(0,8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Bottom status bar
local statusBar = makeFrame(main, {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0,10,1,-46),
    BackgroundColor3 = Color3.fromRGB(18,18,18),
    BorderSizePixel = 0,
})

local statusLabel = makeText(statusBar, {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "Status: Idle | World: ...",
    TextColor3 = Color3.fromRGB(180,180,180),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ======= وظائف عرض المحتوى (قوائم فرعية) =======
local function clearContent()
    for _,c in pairs(content:GetChildren()) do
        if not c:IsA("UIListLayout") then
            c:Destroy()
        end
    end
end

local function updateStatus()
    statusLabel.Text = string.format("Status: %s | World: %s | Speed: %d", 
        (state.AutoFarm or state.AutoFish or state.AutoCollect or state.AutoRaid or state.AutoEvent) and "Active" or "Idle",
        tostring(state.CurrentWorld or "Unknown"),
        state.WalkSpeed
    )
end

-- Toggle button creator (label + small toggle button)
local function createToggleRow(parent, labelText, getter, setter)
    local row = makeFrame(parent, {
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
    })
    local lbl = makeText(row, {
        Size = UDim2.new(0.7,0,1,0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = Color3.fromRGB(230,230,230),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local btn = makeButton(row, {
        Size = UDim2.new(0.28,0,0.9,0),
        Position = UDim2.new(0.72,0,0.05,0),
        Text = getter() and "ON" or "OFF",
        BackgroundColor3 = getter() and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90),
        TextColor3 = Color3.fromRGB(1,1,1),
        TextSize = 14,
    })
    btn.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        btn.Text = new and "ON" or "OFF"
        btn.BackgroundColor3 = new and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90)
        updateStatus()
    end)
    return row, btn
end

-- ======= إنشاء أزرار الفئات الرئيسية (Left menu) =======
local menus = {}

local function addMenu(name, callback)
    local btn = makeButton(left, {
        Size = UDim2.new(1,0,0,44),
        Text = name,
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 16
    })
    btn.MouseButton1Click:Connect(function()
        -- تغيير لون
        for _,child in ipairs(left:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(45,45,45)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        -- load menu
        clearContent()
        callback()
    end)
    menus[name] = btn
    return btn
end

-- ======= Menu: AutoFarm (contains many toggles) =======
addMenu("Auto", function()
    makeText(content, {Size=UDim2.new(1,0,0,30), Text="Auto Options", TextSize=18, BackgroundTransparency=1, TextColor3=Color3.fromRGB(245,245,245)})
    createToggleRow(content, "AutoFarm (mobs)", function() return state.AutoFarm end, function(v) 
        state.AutoFarm = v
        if v then spawn(autoFarmLoop) end
    end)
    createToggleRow(content, "AutoFish", function() return state.AutoFish end, function(v)
        state.AutoFish = v
        if v then spawn(autoFishLoop) end
    end)
    createToggleRow(content, "AutoCollect (items)", function() return state.AutoCollect end, function(v)
        state.AutoCollect = v
        if v then spawn(autoCollectLoop) end
    end)
    createToggleRow(content, "AutoRaid (where avail.)", function() return state.AutoRaid end, function(v)
        state.AutoRaid = v
        if v then spawn(autoRaidLoop) end
    end)
    createToggleRow(content, "AutoEvent (world events)", function() return state.AutoEvent end, function(v)
        state.AutoEvent = v
        if v then spawn(autoEventLoop) end
    end)
    createToggleRow(content, "Infinite Jump", function() return state.InfiniteJump end, function(v)
        state.InfiniteJump = v
    end)
end)

-- ======= Menu: Quests / Items (per-world tasks) =======
addMenu("Tasks/Items", function()
    makeText(content, {Size=UDim2.new(1,0,0,30), Text="Tasks & Item Options", TextSize=18, BackgroundTransparency=1, TextColor3=Color3.fromRGB(245,245,245)})
    -- Example tasks per world. You must implement logic for each task.
    local w = state.CurrentWorld or "World 1"
    makeText(content, {Size=UDim2.new(1,0,0,20), Text="Detected world: "..tostring(w), BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    -- Task buttons (manual)
    local function addTaskButton(name, func)
        local b = makeButton(content, {
            Size = UDim2.new(1,0,0,34),
            Text = name,
            BackgroundColor3 = Color3.fromRGB(60,60,60),
            TextSize = 15,
            TextColor3 = Color3.fromRGB(255,255,255)
        })
        b.MouseButton1Click:Connect(func)
    end

    if w == "World 1" then
        addTaskButton("Do World1 Quest A (example)", function()
            -- ضع هنا الكود الخاص بمهمة العالم الأول
            print("Run World1 Quest A (needs implementation)")
        end)
        addTaskButton("Do World1 Quest B (example)", function()
            print("Run World1 Quest B (needs implementation)")
        end)
    elseif w == "World 2" then
        addTaskButton("Start Desert Quest", function()
            print("Start Desert Quest (needs implementation)")
        end)
        addTaskButton("Start Shark Event (farm sea mobs)", function()
            print("Start Shark Event routine (needs implementation)")
        end)
    elseif w == "World 3" then
        addTaskButton("Start Sky Quest", function()
            print("Start Sky Quest (needs implementation)")
        end)
        addTaskButton("Start Mirage Event", function()
            print("Start Mirage Event (needs implementation)")
        end)
    else
        makeText(content, {Size=UDim2.new(1,0,0,30), Text="No world-specific tasks available", BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    end
end)

-- ======= Menu: Raids / Bosses =======
addMenu("Raids", function()
    makeText(content, {Size=UDim2.new(1,0,0,30), Text="Raids & Bosses", TextSize=18, BackgroundTransparency=1, TextColor3=Color3.fromRGB(245,245,245)})
    local w = state.CurrentWorld or "World 1"
    if Worlds[w] and Worlds[w].Raids and #Worlds[w].Raids > 0 then
        for _,raidName in ipairs(Worlds[w].Raids) do
            local b = makeButton(content, {
                Size = UDim2.new(1,0,0,36),
                Text = "Start Raid: "..raidName,
                BackgroundColor3 = Color3.fromRGB(65,65,65),
                TextColor3 = Color3.fromRGB(255,255,255),
                TextSize = 15
            })
            b.MouseButton1Click:Connect(function()
                -- ضع هنا منطق بدء الرايد/التعامل معه
                print("Start raid:", raidName, "(implement raid logic)")
            end)
        end
    else
        makeText(content, {Size=UDim2.new(1,0,0,30), Text="No raids for this world", BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    end
end)

-- ======= Menu: Islands (World 3 special) =======
addMenu("Islands", function()
    makeText(content, {Size=UDim2.new(1,0,0,30), Text="World 3 Islands", TextSize=18, BackgroundTransparency=1, TextColor3=Color3.fromRGB(245,245,245)})
    local w = state.CurrentWorld or "World 3"
    if Worlds[w] and Worlds[w].Islands then
        for islandName, pos in pairs(Worlds[w].Islands) do
            local b = makeButton(content, {
                Size = UDim2.new(1,0,0,36),
                Text = "Teleport -> "..tostring(islandName),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                TextColor3 = Color3.fromRGB(255,255,255),
                TextSize = 15
            })
            b.MouseButton1Click:Connect(function()
                safeTeleport(pos)
            end)
        end
    else
        makeText(content, {Size=UDim2.new(1,0,0,30), Text="No special islands here", BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    end
end)

-- ======= Menu: Settings (speed slider, redeem codes) =======
addMenu("Settings", function()
    makeText(content, {Size = UDim2.new(1,0,0,30), Text = "Settings", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    -- Speed control (Textbox - numeric)
    makeText(content, {Size=UDim2.new(1,0,0,24), Text="WalkSpeed (25 - 300)", BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    local speedBox = Instance.new("TextBox", content)
    speedBox.Size = UDim2.new(1,0,0,36)
    speedBox.Text = tostring(state.WalkSpeed)
    speedBox.PlaceholderText = "Enter speed (25-300)"
    speedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
    speedBox.TextColor3 = Color3.fromRGB(255,255,255)
    speedBox.TextSize = 16
    speedBox.ClearTextOnFocus = false
    speedBox.FocusLost:Connect(function(enter)
        local v = tonumber(speedBox.Text)
        if v then
            if v < 25 then v = 25 end
            if v > 300 then v = 300 end
            state.WalkSpeed = v
            if char and char:FindFirstChildOfClass("Humanoid") then
                pcall(function() char:FindFirstChildOfClass("Humanoid").WalkSpeed = v end)
            end
            speedBox.Text = tostring(v)
            updateStatus()
        end
    end)

    -- Redeem codes input
    makeText(content, {Size=UDim2.new(1,0,0,24), Text="Redeem Code (game-specific)", BackgroundTransparency=1, TextColor3=Color3.fromRGB(200,200,200)})
    local codeBox = Instance.new("TextBox", content)
    codeBox.Size = UDim2.new(1,0,0,36)
    codeBox.PlaceholderText = "Enter code and press Redeem"
    codeBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
    codeBox.TextColor3 = Color3.fromRGB(255,255,255)
    codeBox.TextSize = 16

    local redeemBtn = makeButton(content, {
        Size = UDim2.new(0.4,0,0,34),
        Position = UDim2.new(0.6,0,0,0),
        Text = "Redeem",
        BackgroundColor3 = Color3.fromRGB(80,80,160),
        TextColor3 = Color3.fromRGB(255,255,255)
    })
    redeemBtn.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        if code and #code > 0 then
            -- ضع هنا منطق ارسال الكود للسيرفر (game-specific)
            print("Attempt redeem code:", code, "(implement server request)")
        end
    end)
end)

-- ======= زر اخفاء/اظهار الواجهة الرئيسي الصغير =======
hideBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ======= تحديث واجهة الحالة كل ثانيتين =======
spawn(function()
    while true do
        updateStatus()
        wait(1)
    end
end)

-- ======= تنفيذ كشف العالم دوري (لو تغيرت المناطق) =======
spawn(function()
    while true do
        pcall(detectWorld)
        wait(3)
    end
end)

-- ======= ضمان تشغيل/ايقاف الحلقات بشكل صحيح عند تغيير الحالة =======
-- (already triggered عند الضغط على الأزرار في القوائم)

-- ======= الملاحظات النهائية =======
print("Redz-Style Hub loaded. Use menus to toggle features. Some features require game-specific implementation (quests, raids, events, fishing).")
