-- Red_z_Hub_UI_Template.lua
-- واجهة حديثة + Template وظائف (آمن، للاستخدام داخل Roblox Studio / لعبتك الخاصة)
-- ضع هذا LocalScript داخل StarterPlayerScripts أو داخل ScreenGui في StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- --------------- Settings (قابلة للتعديل) -----------------
local SETTINGS = {
    WalkSpeedMin = 25,
    WalkSpeedMax = 300,
    DefaultWalkSpeed = 16,
    AttackDistanceMin = 5,
    AttackDistanceMax = 10,
    AttackDelay = 0.1
}

-- --------------- State (حالة أزرار) -----------------------
local state = {
    AutoFarm = false,
    AutoFish = false,
    AutoCollect = false,
    AutoRaid = false,
    AutoEvent = false,
    InfiniteJump = false,
    WalkSpeed = SETTINGS.DefaultWalkSpeed,
    CurrentWorld = "Unknown"
}

-- --------------- Callbacks / Placeholders ------------------
local Callbacks = {}

function Callbacks.OnToggle_AutoFarm(on)
    state.AutoFarm = on
    print("[Callback] AutoFarm =", on)
    -- TODO: call your game's server RemoteEvent here
end

function Callbacks.OnToggle_AutoFish(on)
    state.AutoFish = on
    print("[Callback] AutoFish =", on)
end

function Callbacks.OnToggle_AutoCollect(on)
    state.AutoCollect = on
    print("[Callback] AutoCollect =", on)
end

function Callbacks.OnToggle_AutoRaid(on)
    state.AutoRaid = on
    print("[Callback] AutoRaid =", on)
end

function Callbacks.OnToggle_AutoEvent(on)
    state.AutoEvent = on
    print("[Callback] AutoEvent =", on)
end

function Callbacks.OnToggle_InfiniteJump(on)
    state.InfiniteJump = on
    print("[Callback] InfiniteJump =", on)
end

function Callbacks.OnSet_WalkSpeed(value)
    state.WalkSpeed = value
    print("[Callback] WalkSpeed set to", value)
    local character = player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        pcall(function()
            character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end)
    end
end

function Callbacks.TeleportTo(positionVector3)
    print("[Callback] TeleportTo called:", positionVector3)
    -- IMPORTANT: implement teleport on server-side for safety
end

function Callbacks.RunTask(taskName)
    print("[Callback] RunTask:", taskName)
    -- TODO: implement task execution logic
end

-- --------------- UI Factory Helpers -----------------------
local function new(parent, class, props)
    local obj = Instance.new(class)
    obj.Parent = parent
    if props then
        for k,v in pairs(props) do
            pcall(function() obj[k] = v end)
        end
    end
    return obj
end

-- --------------- Build UI ---------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Redz_Hub_Template"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local main = new(screenGui, "Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0,520,0,520),
    Position = UDim2.new(0.5,-260,0.5,-260),
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BorderSizePixel = 0
})

local title = new(main, "TextLabel", {
    Size = UDim2.new(1,0,0,48),
    Position = UDim2.new(0,0,0,0),
    BackgroundTransparency = 1,
    Text = "Redz-Style Hub (Template)",
    TextColor3 = Color3.fromRGB(240,240,240),
    TextSize = 20,
    Font = Enum.Font.SourceSansBold
})

local miniBtn = new(main, "TextButton", {
    Size = UDim2.new(0,44,0,44),
    Position = UDim2.new(1,-54,0,6),
    Text = "≡",
    TextSize = 20,
    BackgroundColor3 = Color3.fromRGB(60,60,60),
    TextColor3 = Color3.new(1,1,1)
})

local left = new(main, "Frame", {
    Size = UDim2.new(0,160,1,-60),
    Position = UDim2.new(0,10,0,60),
    BackgroundColor3 = Color3.fromRGB(28,28,28),
    BorderSizePixel = 0
})
local leftLayout = new(left, "UIListLayout", {})
leftLayout.Padding = UDim.new(0,8)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder

local content = new(main, "Frame", {
    Size = UDim2.new(1,-190,1,-60),
    Position = UDim2.new(0,180,0,60),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    BorderSizePixel = 0
})
local contentLayout = new(content, "UIListLayout", {})
contentLayout.Padding = UDim.new(0,8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local statusBar = new(main, "Frame", {
    Size = UDim2.new(1,-20,0,40),
    Position = UDim2.new(0,10,1,-46),
    BackgroundColor3 = Color3.fromRGB(18,18,18),
    BorderSizePixel = 0
})
local statusLabel = new(statusBar, "TextLabel", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "Status: Idle | World: Unknown | Speed: "..tostring(state.WalkSpeed),
    TextColor3 = Color3.fromRGB(180,180,180),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- --------------- UI Content Builders ----------------------
local menuButtons = {}

local function clearContent()
    for _,c in pairs(content:GetChildren()) do
        if not c:IsA("UIListLayout") then
            c:Destroy()
        end
    end
end

local function setActiveMenu(btn)
    for _,child in pairs(left:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(45,45,45)
        end
    end
    if btn and btn:IsA("TextButton") then
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    end
end

local function addMenu(name, callback)
    local btn = new(left, "TextButton", {
        Size = UDim2.new(1,0,0,44),
        Text = name,
        BackgroundColor3 = Color3.fromRGB(45,45,45),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 16
    })
    btn.MouseButton1Click:Connect(function()
        setActiveMenu(btn)
        clearContent()
        callback()
    end)
    menuButtons[name] = btn
    return btn
end

local function createToggleRow(parent, label, getter, setter)
    local container = new(parent, "Frame", {
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = Color3.fromRGB(30,30,30)
    })
    local lbl = new(container, "TextLabel", {
        Size = UDim2.new(0.7,0,1,0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Color3.fromRGB(230,230,230),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local toggle = new(container, "TextButton", {
        Size = UDim2.new(0.28,0,0.9,0),
        Position = UDim2.new(0.72,0,0.05,0),
        Text = getter() and "ON" or "OFF",
        BackgroundColor3 = getter() and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90),
        TextColor3 = Color3.fromRGB(255,255,255),
        TextSize = 14
    })
    toggle.MouseButton1Click:Connect(function()
        local new = not getter()
        setter(new)
        toggle.Text = new and "ON" or "OFF"
        toggle.BackgroundColor3 = new and Color3.fromRGB(0,200,0) or Color3.fromRGB(90,90,90)
        statusLabel.Text = "Status: "..( (state.AutoFarm or state.AutoFish or state.AutoCollect) and "Active" or "Idle").." | World: "..tostring(state.CurrentWorld).." | Speed: "..tostring(state.WalkSpeed)
    end)
    return container, toggle
end

-- --------------- Menus Implementation ---------------------
addMenu("Auto", function()
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,28), Text = "Auto Options", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    createToggleRow(content, "AutoFarm (manual hook)", function() return state.AutoFarm end, function(v) Callbacks.OnToggle_AutoFarm(v) end)
    createToggleRow(content, "AutoFish (manual hook)", function() return state.AutoFish end, function(v) Callbacks.OnToggle_AutoFish(v) end)
    createToggleRow(content, "AutoCollect (manual hook)", function() return state.AutoCollect end, function(v) Callbacks.OnToggle_AutoCollect(v) end)
    createToggleRow(content, "AutoRaid (manual hook)", function() return state.AutoRaid end, function(v) Callbacks.OnToggle_AutoRaid(v) end)
    createToggleRow(content, "AutoEvent (manual hook)", function() return state.AutoEvent end, function(v) Callbacks.OnToggle_AutoEvent(v) end)
    createToggleRow(content, "Infinite Jump (local)", function() return state.InfiniteJump end, function(v) Callbacks.OnToggle_InfiniteJump(v) end)
end)

addMenu("Tasks/Items", function()
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,28), Text = "Tasks & Items", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    local function addTaskButton(name)
        local b = new(content, "TextButton", {Size = UDim2.new(1,0,0,36), Text = name, BackgroundColor3 = Color3.fromRGB(60,60,60), TextColor3 = Color3.fromRGB(255,255,255), TextSize = 15})
        b.MouseButton1Click:Connect(function() Callbacks.RunTask(name) end)
    end
    addTaskButton("Quest: Example A")
    addTaskButton("Quest: Example B")
    addTaskButton("Event: Sea Monster (example)")
end)

addMenu("Raids", function()
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,28), Text = "Raids & Bosses", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    local function addRaid(name)
        local b = new(content, "TextButton", {Size = UDim2.new(1,0,0,36), Text = "Start Raid: "..name, BackgroundColor3 = Color3.fromRGB(65,65,65), TextColor3 = Color3.fromRGB(255,255,255), TextSize = 15})
        b.MouseButton1Click:Connect(function() print("Request start raid:", name) end)
    end
    addRaid("Raid Alpha (example)")
    addRaid("Raid Beta (example)")
end)

addMenu("Islands", function()
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,28), Text = "World 3 Islands", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    local function addIsland(name)
        local b = new(content, "TextButton", {Size = UDim2.new(1,0,0,36), Text = "Teleport -> "..name, BackgroundColor3 = Color3.fromRGB(60,60,60), TextColor3 = Color3.fromRGB(255,255,255), TextSize = 15})
        b.MouseButton1Click:Connect(function()
            print("Request teleport to:", name)
        end)
    end
    addIsland("Kitsune")
    addIsland("Volcano")
    addIsland("Mirage")
end)

addMenu("Settings", function()
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,28), Text = "Settings", TextSize = 18, BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(245,245,245)})
    new(content, "TextLabel", {Size = UDim2.new(1,0,0,20), Text = "WalkSpeed ("..SETTINGS.WalkSpeedMin.." - "..SETTINGS.WalkSpeedMax..")", BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200,200,200)})
    local speedBox = new(content, "TextBox", {Size = UDim2.new(1,0,0,36), Text = tostring(state.WalkSpeed), PlaceholderText = "Enter speed"})
    speedBox.FocusLost:Connect(function()
        local v = tonumber(speedBox.Text)
        if v then
            if v < SETTINGS.WalkSpeedMin then v = SETTINGS.WalkSpeedMin end
            if v > SETTINGS.WalkSpeedMax then v = SETTINGS.WalkSpeedMax end
            Callbacks.OnSet_WalkSpeed(v)
            speedBox.Text = tostring(v)
        else
            speedBox.Text = tostring(state.WalkSpeed)
        end
    end)

    new(content, "TextLabel", {Size = UDim2.new(1,0,0,20), Text = "Redeem Code (game-specific)", BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200,200,200)})
    local codeBox = new(content, "TextBox", {Size = UDim2.new(1,0,0,36), PlaceholderText = "Enter code"})
    local redeemBtn = new(content, "TextButton", {Size = UDim2.new(0.4,0,0,36), Position = UDim2.new(0.6,0,0,0), Text = "Redeem", BackgroundColor3 = Color3.fromRGB(80,80,160), TextColor3 = Color3.fromRGB(255,255,255)})
    redeemBtn.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        print("Redeem code requested:", code)
    end)
end)

miniBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if state.InfiniteJump and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

spawn(function()
    while true do
        if state.AutoFarm then
            -- Placeholder: call server-side validated remote
        end
        wait(0.5)
    end
end)

-- select first menu
local firstMenu
for name,btn in pairs(menuButtons) do
    if not firstMenu then firstMenu = btn end
end
if firstMenu then
    firstMenu:CaptureFocus()
    firstMenu.MouseButton1Click:Wait()
end

print("Redz-Style Hub Template loaded (UI-only). Implement game logic server-side.")
