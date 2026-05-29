local Players = game:GetService("Players")
local player = Players.LocalPlayer
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")

local function destroyExistingUI()
    local playerGui = player:WaitForChild("PlayerGui")
    local existingUI = playerGui:FindFirstChild("LanguageSelectorUI")
    if existingUI then
        existingUI:Destroy()
    end
end

destroyExistingUI()

local UI_TITLE = "Chọn Ngôn Ngữ"
local STROKE_COLOR = Color3.fromRGB(128, 0, 255)

local ENG_SCRIPT = "https://raw.githubusercontent.com/NoirGoodBoi/NoirSrc/refs/heads/main/Script/Universal/Eng.lua"
local VIE_SCRIPT = "https://raw.githubusercontent.com/NoirGoodBoi/NoirSrc/refs/heads/main/Script/Universal/Vie.lua"

local currentNotify = nil
local isExecuting = false

-- ==================== TẠO UI ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LanguageSelectorUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = mainFrame
uiCorner.CornerRadius = UDim.new(0, 12)

local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = mainFrame
uiStroke.Color = STROKE_COLOR
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundTransparency = 1
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -35, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = UI_TITLE
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BackgroundTransparency = 0.2
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -32, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeButton
closeCorner.CornerRadius = UDim.new(0, 6)

local buttonWidth = 100
local buttonHeight = 40
local buttonY = 50

-- Nút ENG
local engButton = Instance.new("TextButton")
engButton.Name = "EngButton"
engButton.Parent = mainFrame
engButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
engButton.BackgroundTransparency = 0.3
engButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
engButton.Position = UDim2.new(0.5, -buttonWidth - 10, 0, buttonY)
engButton.Text = "Eng"
engButton.TextColor3 = Color3.fromRGB(255, 255, 255)
engButton.TextSize = 18
engButton.Font = Enum.Font.GothamBold
local engCorner = Instance.new("UICorner")
engCorner.Parent = engButton
engCorner.CornerRadius = UDim.new(0, 10)

-- Nút VIE (giống hệt ENG, không troll)
local vieButton = Instance.new("TextButton")
vieButton.Name = "VieButton"
vieButton.Parent = mainFrame
vieButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
vieButton.BackgroundTransparency = 0.3
vieButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
vieButton.Position = UDim2.new(0.5, 10, 0, buttonY)
vieButton.Text = "Vie"
vieButton.TextColor3 = Color3.fromRGB(255, 255, 255)
vieButton.TextSize = 18
vieButton.Font = Enum.Font.GothamBold
local vieCorner = Instance.new("UICorner")
vieCorner.Parent = vieButton
vieCorner.CornerRadius = UDim.new(0, 10)

-- ==================== HIỆU ỨNG ====================
local function pulseEffect(button)
    if isExecuting then return end
    local originalSize = button.Size
    local grow = tweenService:Create(button, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 5, originalSize.Y.Scale, originalSize.Y.Offset + 5)})
    local shrink = tweenService:Create(button, TweenInfo.new(0.08), {Size = originalSize})
    grow:Play()
    grow.Completed:Connect(function() shrink:Play() end)
end

local function fadeOutAndDestroy()
    if isExecuting then return end
    isExecuting = true
    
    local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    for _, v in pairs(mainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            tweenService:Create(v, TweenInfo.new(0.25), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        end
    end
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        screenGui:Destroy()
        if currentNotify then currentNotify:Destroy() end
    end)
end

-- Fade In UI
mainFrame.BackgroundTransparency = 1
for _, v in pairs(mainFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        v.TextTransparency = 1
        if v:IsA("TextButton") then
            v.BackgroundTransparency = 0.5
        end
    end
end

task.wait(0.05)
tweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
for _, v in pairs(mainFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        tweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        if v:IsA("TextButton") then
            tweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
        end
    end
end

-- ==================== NOTIFY ====================
local function showNotify(title, message)
    if currentNotify then
        currentNotify:Destroy()
    end
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "NotifyTemp"
    notifyGui.Parent = player:WaitForChild("PlayerGui")
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Parent = notifyGui
    notifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notifyFrame.BackgroundTransparency = 0.1
    notifyFrame.Size = UDim2.new(0, 280, 0, 55)
    notifyFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
    local notifyCorner = Instance.new("UICorner")
    notifyCorner.Parent = notifyFrame
    notifyCorner.CornerRadius = UDim.new(0, 8)
    
    local notifyStroke = Instance.new("UIStroke")
    notifyStroke.Parent = notifyFrame
    notifyStroke.Color = STROKE_COLOR
    notifyStroke.Thickness = 1.5
    notifyStroke.Transparency = 0.5
    
    local titleLabelN = Instance.new("TextLabel")
    titleLabelN.Parent = notifyFrame
    titleLabelN.Size = UDim2.new(1, 0, 0, 22)
    titleLabelN.Position = UDim2.new(0, 10, 0, 5)
    titleLabelN.Text = title
    titleLabelN.TextColor3 = Color3.fromRGB(255, 200, 100)
    titleLabelN.BackgroundTransparency = 1
    titleLabelN.TextXAlignment = Enum.TextXAlignment.Left
    titleLabelN.TextSize = 13
    titleLabelN.Font = Enum.Font.GothamBold
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notifyFrame
    msgLabel.Size = UDim2.new(1, -20, 0, 25)
    msgLabel.Position = UDim2.new(0, 10, 0, 27)
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    msgLabel.BackgroundTransparency = 1
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    
    notifyFrame.Size = UDim2.new(0, 0, 0, 0)
    notifyFrame.Position = UDim2.new(0.5, 0, 0.2, 0)
    notifyFrame.BackgroundTransparency = 1
    
    local popUp = tweenService:Create(notifyFrame, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 55),
        Position = UDim2.new(0.5, -140, 0.2, 0),
        BackgroundTransparency = 0.1
    })
    popUp:Play()
    
    currentNotify = notifyGui
    
    task.wait(2.5)
    if notifyGui and notifyGui.Parent then
        local fadeOut = tweenService:Create(notifyFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            if notifyGui then notifyGui:Destroy() end
            if currentNotify == notifyGui then currentNotify = nil end
        end)
    end
end

-- ==================== NÚT ENG ====================
engButton.MouseButton1Click:Connect(function()
    if isExecuting then return end
    pulseEffect(engButton)
    task.wait(0.12)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(ENG_SCRIPT))()
    end)
    
    if not success then
        showNotify("Lỗi", "Không thể tải script Eng: " .. tostring(err))
        return
    end
    
    fadeOutAndDestroy()
end)

-- ==================== NÚT VIE (GIỐNG HỆT ENG) ====================
vieButton.MouseButton1Click:Connect(function()
    if isExecuting then return end
    pulseEffect(vieButton)
    task.wait(0.12)
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(VIE_SCRIPT))()
    end)
    
    if not success then
        showNotify("Lỗi", "Không thể tải script Vie: " .. tostring(err))
        return
    end
    
    fadeOutAndDestroy()
end)

-- ==================== ĐÓNG UI ====================
closeButton.MouseButton1Click:Connect(function()
    if isExecuting then return end
    fadeOutAndDestroy()
end)
