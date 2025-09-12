-- ===================================================================
-- ==== سكربت Auto Farm Mobs للعبة Blox Fruits ====
-- ====      مثال تعليمي مبسط لكيفية العمل      ====
-- ===================================================================

-- متغير لتشغيل وإيقاف الوظيفة
local autoFarmEnabled = false
local currentTarget = nil

-- الحصول على اللاعب والمكونات الأساسية
local player = game:GetService("Players").LocalPlayer

-- ===================================================================
-- ====         إنشاء الواجهة الرسومية (GUI)         ====
-- ===================================================================

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 220, 0, 80)
mainFrame.Position = UDim2.new(0.02, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "Blox Fruits Helper"
titleLabel.BackgroundColor3 = Color3.fromRGB(94, 23, 235)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = mainFrame
toggleButton.Size = UDim2.new(0.9, 0, 0, 35)
toggleButton.Position = UDim2.new(0.05, 0, 0, 40)
toggleButton.Text = "Auto Farm Mobs [OFF]"
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- اللون الأحمر يعني إيقاف
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold

-- ===================================================================
-- ====          الوظائف الأساسية للسكربت          ====
-- ===================================================================

-- وظيفة للبحث عن أقرب وحش
function findClosestMob()
    local closestMob = nil
    local shortestDistance = math.huge
    local playerCharacter = player.Character
    if not playerCharacter then return nil end
    local playerRoot = playerCharacter:FindFirstChild("HumanoidRootPart")
    if not playerRoot then return nil end

    -- مجلد الأعداء في اللعبة
    for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        local mobHumanoid = mob:FindFirstChild("Humanoid")
        local mobRoot = mob:FindFirstChild("HumanoidRootPart")
        if mobHumanoid and mobRoot and mobHumanoid.Health > 0 then
            local distance = (playerRoot.Position - mobRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestMob = mob
            end
        end
    end
    return closestMob
end

-- وظيفة لمهاجمة الهدف
function attackTarget(target)
    local playerCharacter = player.Character
    if not playerCharacter or not target or not target:FindFirstChild("Humanoid") or target.Humanoid.Health <= 0 then
        currentTarget = nil
        return
    end

    local targetRoot = target.HumanoidRootPart
    local playerRoot = playerCharacter.HumanoidRootPart

    -- الانتقال السريع إلى الوحش
    playerRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 5)

    -- تجهيز السلاح أو أسلوب القتال ومهاجمة
    local tool = playerCharacter:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        tool:Activate()
    end
    -- يمكنك إضافة هجمات الفاكهة أو أساليب القتال هنا
end

-- ===================================================================
-- ====          برمجة زر التشغيل والحلقة الرئيسية          ====
-- ===================================================================

-- برمجة زر التبديل (تشغيل/إيقاف)
toggleButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled -- تبديل الحالة
    if autoFarmEnabled then
        toggleButton.Text = "Auto Farm Mobs [ON]"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- اللون الأخضر يعني تشغيل
    else
        toggleButton.Text = "Auto Farm Mobs [OFF]"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- اللون الأحمر يعني إيقاف
        currentTarget = nil
    end
end)

-- الحلقة الرئيسية التي تعمل باستمرار في الخلفية
while task.wait(0.1) do
    if autoFarmEnabled then
        -- إذا لم يكن هناك هدف حالي، أو الهدف الحالي مات، ابحث عن هدف جديد
        if not currentTarget or not currentTarget:IsDescendantOf(game.Workspace) or currentTarget.Humanoid.Health <= 0 then
            currentTarget = findClosestMob()
        end

        -- إذا تم العثور على هدف، قم بمهاجمته
        if currentTarget then
            attackTarget(currentTarget)
        end
    end
end
