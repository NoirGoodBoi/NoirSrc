local Players = game:GetService("Players")
local player = Players.LocalPlayer
local tweenService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")
local userInputService = game:GetService("UserInputService")

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

local soundIds = {
    [1] = "rbxassetid://107720695419642",
    [2] = "rbxassetid://77173593343278",
    [3] = "rbxassetid://132094412976967",
    [4] = "rbxassetid://96249515221890",
    [5] = "rbxassetid://79681712962630",
    [6] = "rbxassetid://79062704024401",
    [7] = "rbxassetid://96632187935759",
    [8] = "rbxassetid://99272167491420",
    [9] = "rbxassetid://138882491317521",
    [10] = "rbxassetid://84840351603473",
    [11] = "rbxassetid://78816611240993",
    [12] = "rbxassetid://139771888058836",
}

local currentSound = nil
local currentNotify = nil
local vieClickCount = 0
local defaultViePos = nil
local isExecuting = false
local hasExecutedScript = false

local function playSound(soundId)
    if currentSound and currentSound.Playing then
        currentSound:Stop()
        currentSound:Destroy()
    end
    
    if not soundId or soundId == "rbxassetid://YOUR_SOUND_ID_1" and soundId ~= nil then
        if string.find(soundId, "YOUR_SOUND_ID") then
            return
        end
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 1
    sound.Parent = soundService
    sound:Play()
    currentSound = sound
    
    sound.Ended:Connect(function()
        if currentSound == sound then
            currentSound = nil
        end
        sound:Destroy()
    end)
end

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
mainFrame.Active = true
mainFrame.Draggable = false

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

local vieButton = Instance.new("TextButton")
vieButton.Name = "VieButton"
vieButton.Parent = screenGui
vieButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
vieButton.BackgroundTransparency = 0.3
vieButton.Size = UDim2.new(0, buttonWidth, 0, buttonHeight)
vieButton.Text = "Vie"
vieButton.TextColor3 = Color3.fromRGB(255, 255, 255)
vieButton.TextSize = 18
vieButton.Font = Enum.Font.GothamBold
local vieCorner = Instance.new("UICorner")
vieCorner.Parent = vieButton
vieCorner.CornerRadius = UDim.new(0, 10)

-- Cập nhật vị trí ban đầu
task.wait(0.1)
local mainPos = mainFrame.AbsolutePosition
vieButton.Position = UDim2.new(0, mainPos.X + 135, 0, mainPos.Y + 50)
defaultViePos = vieButton.Position

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
    
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
        currentSound = nil
    end
    
    local fadeOut = tweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
    for _, v in pairs(mainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            tweenService:Create(v, TweenInfo.new(0.25), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
        end
    end
    tweenService:Create(vieButton, TweenInfo.new(0.25), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        if screenGui then screenGui:Destroy() end
        if currentNotify then currentNotify:Destroy() end
    end)
end

mainFrame.BackgroundTransparency = 1
vieButton.BackgroundTransparency = 0.5
vieButton.TextTransparency = 1
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
tweenService:Create(vieButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.3, TextTransparency = 0}):Play()
for _, v in pairs(mainFrame:GetDescendants()) do
    if v:IsA("TextLabel") or v:IsA("TextButton") then
        tweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        if v:IsA("TextButton") then
            tweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
        end
    end
end

local function getRandomPositionNearMainUI()
    local mainPos = mainFrame.AbsolutePosition
    local mainSize = mainFrame.AbsoluteSize
    
    local centerX = mainPos.X + mainSize.X / 2
    local centerY = mainPos.Y + mainSize.Y / 2
    
    local angle = math.random() * math.pi * 2
    local radius = math.random(50, 300)
    local newX = centerX + math.cos(angle) * radius
    local newY = centerY + math.sin(angle) * radius
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    newX = math.clamp(newX, 50, viewportSize.X - 100)
    newY = math.clamp(newY, 50, viewportSize.Y - 100)
    
    return UDim2.new(0, newX, 0, newY)
end

local function showNotify(title, message, soundId, isWarning)
    if currentSound and currentSound.Playing then
        currentSound:Stop()
        currentSound:Destroy()
        currentSound = nil
    end
    
    if currentNotify then
        currentNotify:Destroy()
    end
    
    -- Phát âm thanh (bỏ qua nếu là placeholder)
    if soundId and not string.find(soundId, "YOUR_SOUND_ID") then
        playSound(soundId)
    end
    
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "NotifyTemp"
    notifyGui.Parent = player:WaitForChild("PlayerGui")
    
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Parent = notifyGui
    notifyFrame.BackgroundColor3 = isWarning and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(20, 20, 30)
    notifyFrame.BackgroundTransparency = 0.1
    notifyFrame.Size = UDim2.new(0, 280, 0, 55)
    notifyFrame.Position = UDim2.new(0.5, -140, 0.2, 0)
    local notifyCorner = Instance.new("UICorner")
    notifyCorner.Parent = notifyFrame
    notifyCorner.CornerRadius = UDim.new(0, 8)
    
    local notifyStroke = Instance.new("UIStroke")
    notifyStroke.Parent = notifyFrame
    notifyStroke.Color = isWarning and Color3.fromRGB(255, 100, 100) or STROKE_COLOR
    notifyStroke.Thickness = 1.5
    notifyStroke.Transparency = 0.5
    
    local titleLabelN = Instance.new("TextLabel")
    titleLabelN.Parent = notifyFrame
    titleLabelN.Size = UDim2.new(1, 0, 0, 22)
    titleLabelN.Position = UDim2.new(0, 10, 0, 5)
    titleLabelN.Text = title
    titleLabelN.TextColor3 = isWarning and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(255, 200, 100)
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

local trollData = {
    {msg = "Bro thật sự chọn tiếng việt à? 🤔"},
    {msg = "Thật à bro 🧐"},
    {msg = "Sao bro không chọn bản eng 😕"},
    {msg = "Nghe lời tôi đi 😊"},
    {msg = "Bro cố chấp vậy 😤"},
    {msg = "Chọn bản eng có phải xong rồi không 🙄"},
    {msg = "Bỏ cuộc đi 🤓"},
    {msg = "M có thôi ngay đi không 😒"},
    {msg = "Dừng lại đi 🤯"},
    {msg = "Đừng bấm nữa 😒"},
}

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

vieButton.MouseButton1Click:Connect(function()
    if isExecuting then return end
    pulseEffect(vieButton)
    
    vieClickCount = vieClickCount + 1
    
    if vieClickCount <= #trollData then
        local newPos = getRandomPositionNearMainUI()
        tweenService:Create(vieButton, TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Position = newPos
        }):Play()
        
        local data = trollData[vieClickCount]
        showNotify("hệ thống", data.msg, soundIds[vieClickCount])
    
    elseif vieClickCount == 11 and not hasExecutedScript then
        tweenService:Create(vieButton, TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
            Position = defaultViePos
        }):Play()
        
        showNotify("hệ thống", "Thôi được rồi, t không trêu m nữa 😑", soundIds[11])
        task.wait(0.8)
        
        hasExecutedScript = true
        
        local success, err = pcall(function()
            loadstring(game:HttpGet(VIE_SCRIPT))()
        end)
        
        if not success then
            showNotify("Lỗi", "Không thể tải script Vie: " .. tostring(err))
            return
        end
        fadeOutAndDestroy()
    
    elseif vieClickCount >= 12 and hasExecutedScript then
        showNotify("hệ thống", "Đã bảo là ko trêu nữa mà 😤", soundIds[12], true)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if isExecuting then return end
    fadeOutAndDestroy()
end)
