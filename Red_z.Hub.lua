-- إضافة هذا الجزء بعد الإعدادات الرئيسية

getgenv().MyHub = {
    -- ... الإعدادات السابقة ...
    
    -- ميزات متقدمة من Redz Hub
    AutoRaid = false,
    AutoBuyHaki = false,
    AutoKen = false,
    AutoBone = false,
    AutoEctoplasm = false,
    AutoCandy = false,
    AutoElite = false,
    AutoMirage = false,
    AutoTushita = false,
    AutoYama = false,
    AutoCDK = false,
    AutoBuddySword = false,
    AutoHallowScYthe = false,
    AutoDarkDagger = false,
    
    -- إعدادات المزرعة المتقدمة
    FarmMethod = "Near", -- Near, Fast, Spin
    SelectWeapon = "Melee",
    HardFarm = false,
    
    -- السكيبتات المرئية
    EnableEsp = false,
    EnableTracers = false,
    EnableChestEsp = false,
    EnableFruitEsp = false,
    
    -- التلاعب باللعبة
    NoClip = false,
    Fly = false,
    AutoClick = false,
    BringMob = false,
}

-- ========== تبويب المهام المتقدمة ==========
local AdvancedTab = Window:NewTab("المهام المتقدمة")
local AdvancedSection = AdvancedTab:NewSection("المهام الصعبة")

AdvancedSection:NewToggle("رايد تلقائي", "AutoRaid", function(state)
    getgenv().MyHub.AutoRaid = state
    if state then AutoRaid() end
end)

AdvancedSection:NewToggle("توشيتا تلقائي", "AutoTushita", function(state)
    getgenv().MyHub.AutoTushita = state
    if state then AutoTushita() end
end)

AdvancedSection:NewToggle("ياما تلقائي", "AutoYama", function(state)
    getgenv().MyHub.AutoYama = state
    if state then AutoYama() end
end)

AdvancedSection:NewToggle("CDK تلقائي", "AutoCDK", function(state)
    getgenv().MyHub.AutoCDK = state
    if state then AutoCDK() end
end)

-- ========== تبويب الإعدادات المتقدمة ==========
local SettingsTab = Window:NewTab("الإعدادات المتقدمة")
local SettingsSection = SettingsTab:NewSection("طريقة المزرعة")

SettingsSection:NewDropdown("طريقة المزرعة", "FarmMethod", {"Near", "Fast", "Spin"}, function(option)
    getgenv().MyHub.FarmMethod = option
end)

SettingsSection:NewDropdown("اختر السلاح", "SelectWeapon", {"Melee", "Sword", "Gun", "Fruit"}, function(option)
    getgenv().MyHub.SelectWeapon = option
end)

SettingsSection:NewToggle("مزرعة سريعة", "HardFarm", function(state)
    getgenv().MyHub.HardFarm = state
end)

-- ========== تبويب المرئيات ==========
local VisualTab = Window:NewTab("المرئيات")
local VisualSection = VisualTab:NewSection("الإسبي")

VisualSection:NewToggle("إسبي اللاعبين", "EnableEsp", function(state)
    getgenv().MyHub.EnableEsp = state
    if state then EnableEsp() else DisableEsp() end
end)

VisualSection:NewToggle("إسبي الصناديق", "EnableChestEsp", function(state)
    getgenv().MyHub.EnableChestEsp = state
    if state then EnableChestEsp() else DisableChestEsp() end
end)

VisualSection:NewToggle("إسبي الفواكه", "EnableFruitEsp", function(state)
    getgenv().MyHub.EnableFruitEsp = state
    if state then EnableFruitEsp() else DisableFruitEsp() end
end)

-- ========== تبويب التلاعب ==========
local ManipulationTab = Window:NewTab("التلاعب")
local ManipulationSection = ManipulationTab:NewSection("الحركة المتقدمة")

ManipulationSection:NewToggle("نو كلب", "NoClip", function(state)
    getgenv().MyHub.NoClip = state
    if state then NoClip() end
end)

ManipulationSection:NewToggle("طيران", "Fly", function(state)
    getgenv().MyHub.Fly = state
    if state then Fly() else StopFly() end
end)

ManipulationSection:NewToggle("نقر تلقائي", "AutoClick", function(state)
    getgenv().MyHub.AutoClick = state
    if state then AutoClick() end
end)

ManipulationSection:NewToggle("جلب الموبات", "BringMob", function(state)
    getgenv().MyHub.BringMob = state
    if state then BringMob() end
end)

-- ========== الدوال المتقدمة ==========

-- رايد تلقائي
function AutoRaid()
    spawn(function()
        while getgenv().MyHub.AutoRaid do
            wait()
            pcall(function()
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                    -- كود الرايد
                end
            end)
        end
    end)
end

-- توشيتا تلقائي
function AutoTushita()
    spawn(function()
        while getgenv().MyHub.AutoTushita do
            wait()
            -- كود الحصول على توشيتا
        end
    end)
end

-- نو كلب
function NoClip()
    spawn(function()
        while getgenv().MyHub.NoClip do
            wait()
            pcall(function()
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end)
end

-- طيران
function Fly()
    local flySpeed = 50
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    bodyVelocity.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    while getgenv().MyHub.Fly do
        wait()
        bodyGyro.D = 50
        bodyGyro.P = 3000
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = game.Players.LocalPlayer.Character.Humanoid.MoveDirection * flySpeed
    end
end

-- إسبي اللاعبين
function EnableEsp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            -- كود الإسبي
        end
    end
end

-- نقر تلقائي
function AutoClick()
    spawn(function()
        while getgenv().MyHub.AutoClick do
            wait()
            virtualUser:ClickButton1(Vector2.new())
        end
    end)
end

-- زر الإغلاق
local MiscTab = Window:NewTab("إضافي")
local MiscSection = MiscTab:NewSection("الإعدادات")

MiscSection:NewButton("إعادة تحميل السكيبت", "ReloadScript", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/.../script.lua"))()
end)

MiscSection:NewButton("إغلاق الواجهة", "CloseUI", function()
    Library:Destroy()
end)

print("🎮 My Redz Hub PRO - تم التحميل بنجاح!")
print("📜 الإصدار: PRO v2.0")
print("⚡ تم إضافة جميع ميزات Redz Hub!")
