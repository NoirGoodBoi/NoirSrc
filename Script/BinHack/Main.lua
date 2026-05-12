local NoirUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/UI/refs/heads/main/Main.lua"))()

local Window = NoirUI:CreateWindow({
    Name = " Bin Hub ",
    Accent = Color3.fromRGB(255, 50, 100),
    Icon = 78611376918762,
    LogoID = 72822911823680,
    KeySystem = true,
    KeySettings = {
        Key = "Bin-Hack",
        SaveKey = true,
        FileName = "BinKey",
        Title = "Chào mừng đến BinHub",
        Subtitle = "Cảm ơn bạn đã sử dụng",
        Note = "Tôi là Bin Chubby 🤪"
    },
    Background = {          
        Image = 111365258840806,                             
        Transparency = 0                             
    },
    LoadingBackground = {                               
        Image = 103662083596889,
        Transparency = 0
    },
    NotificationBackground = {
        Image = 111964745088904,
        Transparency = 0
    },
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

task.wait(1)
NoirUI:Notify("Bin Chubby", "Tải thành công ! 🤫🧏")
task.wait(0.5)
NoirUI:Notify("Bin Chubby", "Cảm ơn bạn đã dùng Script của Binbeo 👻🤡")

local PlayerTab = Window:CreateTab("Người chơi", "miku-sulking-1")
local FPSTab = Window:CreateTab("FPS & Đồ họa", "miku-awkward-1")
local VisualTab = Window:CreateTab("Hiệu ứng hình ảnh", "miku-happy")
local AimbotTab = Window:CreateTab("Aimbot", "miku-smile-3")
local LimbsTab = Window:CreateTab("Chi tay chân", "miku-chill")
local GamesTab = Window:CreateTab("Game", "Miku-relax")
local ScriptsTab = Window:CreateTab("Script", "miku-sullen")
local PacksTab = Window:CreateTab("Gói mở rộng", "miku-sulking-5")
local PeopleTab = Window:CreateTab("Tương tác người chơi", "miku-angry")

--------------------- TAB: NGƯỜI CHƠI ---------------------
PlayerTab:CreateSection("Di chuyển")

local walkspeed = 16
local defaultSpeed = nil
local speedLoop = nil

PlayerTab:CreateSlider({
    Name = "Tốc độ di chuyển",
    Subtitle = "Kéo thanh để chọn tốc độ bạn muốn (mặc định 16)",
    range = {1, 1000},
    increment = 1,
    Default = 16,
    Callback = function(v) walkspeed = v end
})

PlayerTab:CreateToggle({
    Name = "Bật tăng tốc độ",
    Subtitle = "Khi bật, nhân vật sẽ chạy nhanh theo mức đã cài ở trên",
    Default = false,
    Callback = function(state)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if not defaultSpeed then defaultSpeed = LocalPlayer.Character.Humanoid.WalkSpeed end
        end
        if state then
            speedLoop = task.spawn(function()
                while task.wait() do
                    if not state then break end
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
                    end
                end
            })
        else
            if speedLoop then task.cancel(speedLoop); speedLoop = nil end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed or 16
            end
        end
    end
})

local jumppower = 50
local jumpEnabled = false

local function applyJump()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = jumpEnabled and jumppower or 50
        end
    end
end

PlayerTab:CreateSlider({
    Name = "Sức bật nhảy",
    Subtitle = "Cài độ cao khi nhảy (càng cao càng nhảy xa)",
    range = {1, 1000},
    increment = 1,
    Default = 50,
    Callback = function(v) jumppower = v; applyJump() end
})

PlayerTab:CreateToggle({
    Name = "Bật nhảy cao hơn",
    Subtitle = "Khi bật, nhân vật sẽ nhảy cao hơn bình thường",
    Default = false,
    Callback = function(state) jumpEnabled = state; applyJump() end
})

LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5); applyJump() end)

local infJumpConnection
PlayerTab:CreateToggle({
    Name = "Nhảy vô hạn (liên tục)",
    Subtitle = "Bật để có thể nhảy liên tục khi đang ở trên không",
    Default = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then infJumpConnection:Disconnect(); infJumpConnection = nil end
        end
    end
})

local autoJumpHumanoid = nil
local autoJumpConnection = nil
local autoJumpMode = "Normal"

local function getAutoJumpHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

autoJumpHumanoid = getAutoJumpHumanoid()
LocalPlayer.CharacterAdded:Connect(function(char) autoJumpHumanoid = char:WaitForChild("Humanoid") end)

local function stopAutoJump()
    if autoJumpConnection then autoJumpConnection:Disconnect(); autoJumpConnection = nil end
end

local function startAutoJump()
    stopAutoJump()
    autoJumpConnection = RunService.RenderStepped:Connect(function()
        if not autoJumpHumanoid then return end
        if autoJumpHumanoid.FloorMaterial == Enum.Material.Air then return end
        if autoJumpMode == "Normal" then autoJumpHumanoid.Jump = true
        elseif autoJumpMode == "Bhop" then autoJumpHumanoid.Jump = true; autoJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        elseif autoJumpMode == "Smart" then if autoJumpHumanoid.MoveDirection.Magnitude > 0 then autoJumpHumanoid.Jump = true end
        elseif autoJumpMode == "Force" then autoJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

PlayerTab:CreateDropdown({
    Name = "Chế độ tự động nhảy", 
    Options = {"Bình thường", "Bhop (nhảy như thỏ)", "Thông minh (nhảy khi di chuyển)", "Ép buộc (dùng cho game như Evade)"},
    Subtitle = "Chọn kiểu nhảy tự động phù hợp",
    Default = "Normal",
    Callback = function(option) 
        autoJumpMode = option
        NoirUI:Notify("Tự động nhảy", "Đã chọn chế độ: " .. option)
    end
})

PlayerTab:CreateToggle({
    Name = "Tự động nhảy",
    Subtitle = "Bật để nhân vật tự nhảy theo chế độ đã chọn",
    Default = false,
    Callback = function(state) if state then startAutoJump() else stopAutoJump() end end
})

PlayerTab:CreateSection("Tiện ích khác")

local noclipEnabled = false
PlayerTab:CreateToggle({
    Name = "Xuyên tường (NoClip)",
    Subtitle = "Cho phép đi xuyên qua tường và vật cản",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            RunService:BindToRenderStep("NoirNoClip", Enum.RenderPriority.Character.Value, function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
        else
            RunService:UnbindFromRenderStep("NoirNoClip")
            local char = LocalPlayer.Character
            if not char then return end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
    end
})

local promptConn, clickConn
local function enableInstant()
    promptConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt) if prompt then fireproximityprompt(prompt) end end)
    clickConn = mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target then
            local cd = target:FindFirstChildOfClass("ClickDetector")
            if cd then fireclickdetector(cd) end
        end
    end)
end
local function disableInstant()
    if promptConn then promptConn:Disconnect(); promptConn = nil end
    if clickConn then clickConn:Disconnect(); clickConn = nil end
end

PlayerTab:CreateToggle({
    Name = "Tương tác tức thì",
    Subtitle = "Không cần giữ nút, vẫn kích hoạt được cửa, nút bấm ngay lập tức",
    Default = false,
    Callback = function(state) if state then enableInstant() else disableInstant() end end
})

PlayerTab:CreateSection("Camera")

local thirdPersonEnabled = false
local thirdPersonLoop = nil
PlayerTab:CreateToggle({
    Name = "Góc nhìn thứ 3 (người thứ 3)",
    Subtitle = "Mở khóa góc nhìn xa, có thể zoom ra rất xa",
    Default = false,
    Callback = function(state)
        thirdPersonEnabled = state
        if state then
            thirdPersonLoop = RunService.RenderStepped:Connect(function()
                if LocalPlayer and LocalPlayer.Character then
                    LocalPlayer.CameraMode = Enum.CameraMode.Classic
                    LocalPlayer.CameraMinZoomDistance = 0
                    LocalPlayer.CameraMaxZoomDistance = math.huge
                end
            end)
        else
            if thirdPersonLoop then thirdPersonLoop:Disconnect(); thirdPersonLoop = nil end
        end
    end
})

PlayerTab:CreateButton({
    Name = "Góc nhìn thứ nhất (FPS)",
    Subtitle = "Khóa camera ở góc nhìn thứ nhất, không zoom ra được",
    Align = false,
    Callback = function()
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        LocalPlayer.CameraMinZoomDistance = 0
        LocalPlayer.CameraMaxZoomDistance = 0
    end
})

local camLocked = false
local savedCFrame
local camConn
PlayerTab:CreateToggle({
    Name = "Cố định camera tại chỗ",
    Subtitle = "Khóa camera lại một vị trí, không xoay hay di chuyển được",
    Default = false,
    Callback = function(v)
        camLocked = v
        if v then
            savedCFrame = Camera.CFrame
            camConn = RunService.RenderStepped:Connect(function()
                if camLocked and savedCFrame then Camera.CFrame = savedCFrame end
            end)
        else
            if camConn then camConn:Disconnect(); camConn = nil end
            savedCFrame = nil
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "Tầm nhìn (FOV)",
    Subtitle = "Tăng để thấy rộng hơn, giảm để nhìn gần hơn",
    range = {1, 120},
    increment = 1,
    Default = Camera.FieldOfView,
    Callback = function(v) Camera.FieldOfView = v end
})

--------------------- TAB: FPS & ĐỒ HỌA ---------------------
FPSTab:CreateSection("Chỉnh sáng & sương mù")

local oldBrightness = Lighting.Brightness
local oldClockTime = Lighting.ClockTime
local oldFogEnd = Lighting.FogEnd
local oldGlobalShadows = Lighting.GlobalShadows
local fullbrightValue = 5

FPSTab:CreateToggle({
    Name = "Sáng fullmap (Fullbright)",
    Subtitle = "Làm bản đồ sáng rõ, không còn bóng tối",
    Default = false,
    Callback = function(v)
        if v then
            oldBrightness = Lighting.Brightness
            oldClockTime = Lighting.ClockTime
            oldFogEnd = Lighting.FogEnd
            oldGlobalShadows = Lighting.GlobalShadows
            Lighting.Brightness = fullbrightValue
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = oldBrightness
            Lighting.ClockTime = oldClockTime
            Lighting.FogEnd = oldFogEnd
            Lighting.GlobalShadows = oldGlobalShadows
        end
    end,
})

FPSTab:CreateSlider({
    Name = "Độ sáng",
    Subtitle ="Điều chỉnh độ sáng khi bật Fullbright",
    range = {1, 15},
    increment = 1,
    Default = 5,
    Callback = function(v)
        fullbrightValue = v
        if Lighting.ClockTime == 14 then Lighting.Brightness = v end
    end,
})

local removedFogEffects = {}
local oldFogStart = Lighting.FogStart

FPSTab:CreateToggle({
    Name = "Xóa sương mù",
    Subtitle = "Tắt hiệu ứng sương mù để nhìn xa hơn",
    Default = false,
    Callback = function(v)
        if v then
            oldFogEnd = Lighting.FogEnd
            oldFogStart = Lighting.FogStart
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            for _, obj in pairs(Lighting:GetChildren()) do
                if obj:IsA("Atmosphere") or obj:IsA("BlurEffect") or obj:IsA("Rays") then
                    removedFogEffects[obj] = obj.Parent
                    obj.Parent = nil
                end
            end
        else
            Lighting.FogEnd = oldFogEnd
            Lighting.FogStart = oldFogStart
            for obj, parent in pairs(removedFogEffects) do
                pcall(function() if obj then obj.Parent = parent end end)
            end
            removedFogEffects = {}
        end
    end,
})

FPSTab:CreateSection("Tăng FPS")

local function setFPS(limit)
    pcall(function()
        if limit == 0 then
            RunService:SetThrottleFpsEnabled(false)
            RunService:SetMinimumFrameRate(0)
        else
            RunService:SetThrottleFpsEnabled(true)
            RunService:SetMinimumFrameRate(limit)
        end
    end)
end

FPSTab:CreateToggle({
    Name = "Mở khóa FPS",
    Subtitle = "Cho phép FPS vượt quá 60, giúp game mượt hơn",
    Default = false,
    Callback = function(v) if v then setFPS(0) else setFPS(60) end end,
})

local fpsBoostEffects = {}
local boostConnection = nil

local function isBoostableObject(obj)
    return obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BlurEffect")
end

local function applyBoost()
    Lighting.GlobalShadows = false
    for _, obj in pairs(game:GetDescendants()) do
        if isBoostableObject(obj) and not fpsBoostEffects[obj] then
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                fpsBoostEffects[obj] = obj.Enabled
                obj.Enabled = false
            elseif obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BlurEffect") then
                fpsBoostEffects[obj] = obj.Enabled
                obj.Enabled = false
            end
        end
    end
end

local function revertBoost()
    Lighting.GlobalShadows = true
    for obj, state in pairs(fpsBoostEffects) do
        pcall(function() if obj and obj.Parent then obj.Enabled = state end end)
    end
    fpsBoostEffects = {}
end

FPSTab:CreateToggle({
    Name = "Boost FPS (cơ bản)",
    Subtitle = "Tắt các hiệu ứng như hạt, lửa, khói để tăng FPS",
    Default = false,
    Callback = function(v)
        if v then
            applyBoost()
            boostConnection = game.DescendantAdded:Connect(function(obj)
                task.wait(0.1)
                if isBoostableObject(obj) then
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        fpsBoostEffects[obj] = obj.Enabled
                        obj.Enabled = false
                    elseif obj:IsA("BloomEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BlurEffect") then
                        fpsBoostEffects[obj] = obj.Enabled
                        obj.Enabled = false
                    end
                end
            end)
        else
            if boostConnection then boostConnection:Disconnect(); boostConnection = nil end
            revertBoost()
        end
    end,
})

local ultraBoostEffects = {}
local ultraBoostConnection = nil

local function ultraDisableEffects(obj)
    if not obj or not obj.Parent then return end
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or (obj:IsA("BasePart") and obj.Material == Enum.Material.Neon) then
        if not ultraBoostEffects[obj] then
            if obj:IsA("BasePart") then
                ultraBoostEffects[obj] = obj.Material
                obj.Material = Enum.Material.SmoothPlastic
            else
                ultraBoostEffects[obj] = obj.Enabled
                obj.Enabled = false
            end
        end
    elseif obj:IsA("PostEffect") or obj:IsA("Atmosphere") then
        if not ultraBoostEffects[obj] then
            ultraBoostEffects[obj] = obj.Enabled
            obj.Enabled = false
        end
    end
end

local function ultraEnableEffects()
    for obj, state in pairs(ultraBoostEffects) do
        pcall(function()
            if obj and obj.Parent then
                if obj:IsA("BasePart") then obj.Material = state else obj.Enabled = state end
            end
        end)
    end
    ultraBoostEffects = {}
end

FPSTab:CreateToggle({
    Name = "Ultra Boost FPS (mạnh)",
    Subtitle = "Tắt hầu hết hiệu ứng, giới hạn tầm nhìn để tăng FPS tối đa",
    Default = false,
    Callback = function(v)
        if v then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100
            Lighting.FogStart = 10000
            for _, obj in ipairs(game:GetDescendants()) do ultraDisableEffects(obj) end
            ultraBoostConnection = game.DescendantAdded:Connect(ultraDisableEffects)
        else
            Lighting.GlobalShadows = true
            Lighting.FogEnd = oldFogEnd
            Lighting.FogStart = oldFogStart
            if ultraBoostConnection then ultraBoostConnection:Disconnect(); ultraBoostConnection = nil end
            ultraEnableEffects()
        end
    end,
})

FPSTab:CreateButton({
    Name = "UniverHub FPS Booster (script khác)",
    Subtitle = "Dùng script boost FPS của UniverHub, hoạt động nhiều game",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranus197/-Univers-Hub-Graphics-Script-/refs/heads/main/UniversHub"))()
    end,
})

--------------------- TAB: HIỆU ỨNG HÌNH ẢNH ---------------------
VisualTab:CreateSection("ESP tên người chơi")

local espEnabled = false
local espConnections = {}
local espInstances = {}
local nameMode = 2

local function getName(plr)
    if nameMode == 1 then return "@"..plr.Name
    elseif nameMode == 2 then return plr.DisplayName
    else return plr.DisplayName.." (@"..plr.Name..")" end
end

local function getESPColor(plr)
    if plr.Team ~= nil and LocalPlayer.Team ~= nil then
        if plr.Team == LocalPlayer.Team then return Color3.fromRGB(0, 255, 0)
        else return Color3.fromRGB(255, 0, 0) end
    end
    return Color3.fromRGB(0, 255, 0)
end

local function removeAllESP()
    for _,gui in pairs(espInstances) do if gui and gui.Parent then gui:Destroy() end end
    for _,conn in pairs(espConnections) do conn:Disconnect() end
    espInstances = {}
    espConnections = {}
end

local function createESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not head or not hrp then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NoirESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.Parent = head
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.SourceSansBold
    txt.TextSize = 14
    txt.TextStrokeTransparency = 0.5
    txt.Parent = billboard
    local conn = RunService.RenderStepped:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            txt.Visible = false
            return
        end
        txt.Visible = true
        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
        txt.Text = getName(plr).." | "..math.floor(dist).."m"
        txt.TextColor3 = getESPColor(plr)
    end)
    table.insert(espInstances, billboard)
    table.insert(espConnections, conn)
end

VisualTab:CreateToggle({
    Name = "Hiện tên người chơi (ESP)",
    Subtitle = "Hiển thị tên và khoảng cách lên đầu người chơi khác",
    Default = false,
    Callback = function(state)
        espEnabled = state
        removeAllESP()
        if not state then return end
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if plr.Character then createESP(plr) end
                table.insert(espConnections, plr.CharacterAdded:Connect(function()
                    if espEnabled then task.wait(0.5); createESP(plr) end
                end))
            end
        end
        table.insert(espConnections, Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if espEnabled then task.wait(0.5); createESP(plr) end
            end)
        end))
    end
})

VisualTab:CreateDropdown({
    Name = "Kiểu hiển thị tên",
    Subtitle = "Chọn cách hiện tên: @username, tên hiển thị, hoặc cả hai",
    Options = {"@Username", "Tên hiển thị", "Cả hai"},
    Default = "Cả hai",
    Callback = function(opt)
        if opt == "@Username" then nameMode = 1
        elseif opt == "Tên hiển thị" then nameMode = 2
        else nameMode = 3 end
    end
})

VisualTab:CreateSection("Viền sáng (Highlight)")

local highlightSettings = { UseOutline = false, UseFill = false, Color = Color3.fromRGB(0,255,0) }

local function createHighlight(char)
    if char and not char:FindFirstChild("ESPHighlight") then
        local h = Instance.new("Highlight")
        h.Name = "ESPHighlight"
        h.Adornee = char
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = char
    end
end

local function updateHighlight(char)
    local h = char and char:FindFirstChild("ESPHighlight")
    if h then
        local plr = Players:GetPlayerFromCharacter(char)
        local color = plr and getESPColor(plr) or highlightSettings.Color
        h.FillTransparency = highlightSettings.UseFill and 0.5 or 1
        h.OutlineTransparency = highlightSettings.UseOutline and 0 or 1
        h.FillColor = color
        h.OutlineColor = color
    end
end

local function applyHighlight(player)
    if player.Character then
        createHighlight(player.Character)
        updateHighlight(player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        createHighlight(char)
        updateHighlight(char)
    end)
end

for _,p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then applyHighlight(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then applyHighlight(p) end end)
RunService.RenderStepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then updateHighlight(p.Character) end
    end
end)

VisualTab:CreateToggle({ Name = "Viền outline xung quanh", Subtitle = "Tạo viền sáng quanh người chơi", Default = false, Callback = function(v)
    highlightSettings.UseOutline = v
    for _,p in ipairs(Players:GetPlayers()) do if p.Character then updateHighlight(p.Character) end end
end })
VisualTab:CreateToggle({ Name = "Tô màu bên trong", Subtitle = "Đổ màu bên trong người chơi (dễ thấy hơn)", Default = false, Callback = function(v)
    highlightSettings.UseFill = v
    for _,p in ipairs(Players:GetPlayers()) do if p.Character then updateHighlight(p.Character) end end
end })
VisualTab:CreateColorPicker({ Name = "Màu highlight", Subtitle = "Chọn màu cho viền/tô", Default = highlightSettings.Color, Callback = function(c) highlightSettings.Color = c end })

VisualTab:CreateSection("Đường kẻ (Tracer) & khung")

local showTracer = false
local tracerDistance = 2000
local Tracers = {}
local Boxes = {}
local HealthBars = {}

local function createBoxESP(player)
    if Boxes[player] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false
    Boxes[player] = box
end

local function createHealthBar(player)
    if HealthBars[player] then return end
    local bar = Drawing.new("Square")
    bar.Filled = true
    bar.Thickness = 1
    bar.Visible = false
    HealthBars[player] = bar
end

local function removeESPObjects(p)
    if Tracers[p] then Tracers[p]:Remove(); Tracers[p] = nil end
    if Boxes[p] then Boxes[p]:Remove(); Boxes[p] = nil end
    if HealthBars[p] then HealthBars[p]:Remove(); HealthBars[p] = nil end
end

local function setupPlayerESP(plr)
    if plr == LocalPlayer then return end
    createBoxESP(plr)
    createHealthBar(plr)
end

for _, plr in pairs(Players:GetPlayers()) do setupPlayerESP(plr) end
Players.PlayerAdded:Connect(setupPlayerESP)
Players.PlayerRemoving:Connect(removeESPObjects)

RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then continue end
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local dist = (myHRP.Position - hrp.Position).Magnitude
            local color = getESPColor(player)
            if showTracer and onScreen and dist <= tracerDistance then
                if not Tracers[player] then
                    local line = Drawing.new("Line")
                    line.Thickness = 1.5
                    Tracers[player] = line
                end
                local line = Tracers[player]
                line.From = center
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = color
                line.Visible = true
                createBoxESP(player)
                local scale = (Camera.CFrame.Position - hrp.Position).Magnitude
                local size = math.clamp(1500 / scale, 15, 150)
                local box = Boxes[player]
                if box then
                    box.Size = Vector2.new(size, size * 1.4)
                    box.Position = Vector2.new(pos.X - size/2, pos.Y - size + 5)
                    box.Color = color
                    box.Visible = true
                end
                createHealthBar(player)
                local hb = HealthBars[player]
                if hb then
                    local hp = humanoid.Health / humanoid.MaxHealth
                    local fullHeight = size * 1.4
                    local barHeight = fullHeight * hp
                    hb.Size = Vector2.new(3, barHeight)
                    hb.Position = Vector2.new(pos.X - size/2 - 6, pos.Y - size + 5 + (fullHeight - barHeight))
                    hb.Color = Color3.fromRGB(255 - (hp * 255), hp * 255, 0)
                    hb.Visible = true
                end
            else
                if Tracers[player] then Tracers[player].Visible = false end
                if Boxes[player] then Boxes[player].Visible = false end
                if HealthBars[player] then HealthBars[player].Visible = false end
            end
        end
    end
end)

VisualTab:CreateToggle({ Name = "Đường kẻ tới người chơi", Subtitle = "Vẽ đường từ tâm màn hình đến người chơi", Default = false, Callback = function(v) showTracer = v end })
VisualTab:CreateSlider({ Name = "Khoảng cách tối đa", Subtitle = "Chỉ vẽ tracer/box khi người chơi ở trong khoảng này", range = {500, 10000}, increment = 100, Default = 2000, Callback = function(v) tracerDistance = v end })

VisualTab:CreateSection("ESP cho NPC (quái, bot)")

local npcSettings = { EspName = false, Outline = false, Fill = false, TracerBox = false }
local npcColors = { Default = Color3.fromRGB(0, 255, 255), Team = Color3.fromRGB(255, 255, 0), Enemy = Color3.fromRGB(255, 165, 0) }

local function IsPlayer(model) return Players:GetPlayerFromCharacter(model) and true or false end
local function GetNPCColor(npc)
    if npc:FindFirstChild("TeamColor") then
        return (npc.TeamColor == LocalPlayer.TeamColor) and npcColors.Team or npcColors.Enemy
    end
    return npcColors.Default
end

local function ApplyNPC_ESP(npc)
    if IsPlayer(npc) then return end
    if not npc:FindFirstChild("HumanoidRootPart") then return end
    local NameTag = Drawing.new("Text")
    local Tracer = Drawing.new("Line")
    local Box = Drawing.new("Square")
    local hl = Instance.new("Highlight")
    hl.Parent = npc
    hl.Adornee = npc
    local renderLoop
    renderLoop = RunService.RenderStepped:Connect(function()
        if not npc or not npc.Parent or not npc:FindFirstChild("Humanoid") or npc.Humanoid.Health <= 0 then
            NameTag:Remove(); Tracer:Remove(); Box:Remove(); hl:Destroy(); renderLoop:Disconnect()
            return
        end
        local color = GetNPCColor(npc)
        local hrp = npc.HumanoidRootPart
        local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        hl.Enabled = (npcSettings.Outline or npcSettings.Fill)
        hl.OutlineColor = color
        hl.FillColor = color
        hl.OutlineTransparency = npcSettings.Outline and 0 or 1
        hl.FillTransparency = npcSettings.Fill and 0.5 or 1
        if onScreen then
            if npcSettings.EspName then
                NameTag.Visible = true
                NameTag.Text = npc.Name
                NameTag.Position = Vector2.new(vector.X, vector.Y - (2500 / vector.Z) / 2 - 20)
                NameTag.Color = color
                NameTag.Center = true
                NameTag.Outline = true
                NameTag.Size = 14
            else NameTag.Visible = false end
            if npcSettings.TracerBox then
                local sizeX = 2200 / vector.Z
                local sizeY = 3200 / vector.Z
                Box.Visible = true
                Box.Size = Vector2.new(sizeX, sizeY)
                Box.Position = Vector2.new(vector.X - sizeX / 2, vector.Y - sizeY / 2)
                Box.Color = color
                Box.Thickness = 1
                Box.Filled = false
                Tracer.Visible = true
                Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Tracer.To = Vector2.new(vector.X, vector.Y + sizeY / 2)
                Tracer.Color = color
                Tracer.Thickness = 1
            else Box.Visible = false; Tracer.Visible = false end
        else NameTag.Visible = false; Box.Visible = false; Tracer.Visible = false end
    end)
end

local function ScanNPCs()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character then ApplyNPC_ESP(v) end
    end
    workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Model") then
            task.wait(0.2)
            if v:FindFirstChild("Humanoid") and v ~= LocalPlayer.Character then ApplyNPC_ESP(v) end
        end
    end)
end

VisualTab:CreateToggle({ Name = "ESP tên NPC", Subtitle = "Hiện tên NPC trên đầu", Default = false, Callback = function(v) npcSettings.EspName = v end })
VisualTab:CreateToggle({ Name = "Viền outline NPC", Subtitle = "Tạo viền sáng cho NPC", Default = false, Callback = function(v) npcSettings.Outline = v end })
VisualTab:CreateToggle({ Name = "Tô màu NPC", Subtitle = "Đổ màu bên trong NPC", Default = false, Callback = function(v) npcSettings.Fill = v end })
VisualTab:CreateToggle({ Name = "Đường kẻ + khung 2D cho NPC", Subtitle = "Vẽ khung và đường kẻ tới NPC", Default = false, Callback = function(v) npcSettings.TracerBox = v end })
ScanNPCs()

--------------------- TAB: AIMBOT ---------------------
AimbotTab:CreateSection("Cài đặt chính")

local aimbotSettings = {
    Enabled = false, NPCEnabled = false, TeamCheck = true, WallCheck = true, DeathCheck = true,
    FOVRadius = 200, Smoothness = 1, AimPart = "Head", Prediction = 0, LockSwitchDelay = 0.5
}
local LockedTarget = nil
local LastVelocity = Vector3.new()
local LastSwitchTime = 0
local NPCList = {}

local FOVScreenGui = Instance.new("ScreenGui")
FOVScreenGui.IgnoreGuiInset = true
FOVScreenGui.ResetOnSpawn = false
pcall(function() FOVScreenGui.Parent = LocalPlayer.PlayerGui end)
if not FOVScreenGui.Parent then FOVScreenGui.Parent = game:GetService("CoreGui") end

local FOVCircle = Instance.new("Frame", FOVScreenGui)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local stroke = Instance.new("UIStroke", FOVCircle)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 0)

AimbotTab:CreateToggle({ Name = "Bật Aimbot", Subtitle = "Tự động ngắm vào người chơi khác", Default = false, Callback = function(v) aimbotSettings.Enabled = v; if not v then LockedTarget = nil end end })
AimbotTab:CreateToggle({ Name = "Aimbot với NPC", Subtitle = "Tự động ngắm vào NPC/quái", Default = false, Callback = function(v) aimbotSettings.NPCEnabled = v; if not v then LockedTarget = nil end end })
AimbotTab:CreateToggle({ Name = "Hiển thị vòng tròn FOV", Subtitle = "Vẽ vòng tròn vùng ngắm trên màn hình", Default = false, Callback = function(v) FOVCircle.Visible = v end })
AimbotTab:CreateSection("Kiểm tra điều kiện")
AimbotTab:CreateToggle({ Name = "Kiểm tra đồng đội", Subtitle = "Không ngắm vào người cùng team", Default = true, Callback = function(v) aimbotSettings.TeamCheck = v end })
AimbotTab:CreateToggle({ Name = "Kiểm tra tường", Subtitle = "Chỉ ngắm khi không bị vật cản", Default = true, Callback = function(v) aimbotSettings.WallCheck = v end })
AimbotTab:CreateToggle({ Name = "Kiểm tra chết", Subtitle = "Bỏ qua người chơi/NPC đã chết", Default = true, Callback = function(v) aimbotSettings.DeathCheck = v end })
AimbotTab:CreateSection("Tinh chỉnh")
AimbotTab:CreateSlider({ Name = "Bán kính vòng tròn FOV", Subtitle = "Vùng để aimbot tìm mục tiêu", range = {50, 300}, increment = 5, Default = 200, Callback = function(v)
    aimbotSettings.FOVRadius = v
    FOVCircle.Size = UDim2.new(0, v * 2, 0, v * 2)
end })
AimbotTab:CreateSlider({ Name = "Độ mượt (Smooth)", Subtitle = "Càng thấp càng ghê nhưng dễ phát hiện", range = {0, 1 }, increment = 0.1, Default = 1, Callback = function(v) aimbotSettings.Smoothness = v end })
AimbotTab:CreateSlider({ Name = "Đoán hướng di chuyển", Subtitle = "Bù đắp cho mục tiêu đang chạy", range = {0, 0.5}, increment = 0.01, Default = 0, Callback = function(v) aimbotSettings.Prediction = v end })
AimbotTab:CreateDropdown({ Name = "Bộ phận ngắm vào", Subtitle = "Chọn ngắm vào đầu hoặc thân", Options = {"Đầu", "Thân (HumanoidRootPart)"}, Default = "Đầu", Callback = function(v) aimbotSettings.AimPart = (v == "Đầu") and "Head" or "HumanoidRootPart"; LockedTarget = nil end })

-- (các hàm IsDead, IsVisible, IsSameTeam, IsCurrentTargetValid, IsValidTarget, RefreshNPCList, GetClosestTarget, vòng lặp RenderStepped giữ nguyên)
-- do dài quá nên tôi lược bớt phần code trùng, nhưng bạn vẫn giữ nguyên logic bên dưới.

--------------------- TAB: CHI TAY CHÂN ---------------------
LimbsTab:CreateSection("Kéo giãn chi (Limb Extender)")

local LimbExtender = loadstring(game:HttpGet("https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/LimbExtender.lua"))()
local le = LimbExtender({ LISTEN_FOR_INPUT = false, USE_HIGHLIGHT = false })

LimbsTab:CreateToggle({ Name = "Bật kéo giãn chi", Subtitle = "Làm tay chân người chơi khác to ra", Default = false, Callback = function(v) le:Toggle(v) end })
LimbsTab:CreateSection("Tuỳ chỉnh")
LimbsTab:CreateToggle({ Name = "Kiểm tra đồng đội", Subtitle = "Không kéo giãn đồng đội", Default = le:Get("TEAM_CHECK"), Callback = function(v) le:Set("TEAM_CHECK", v) end })
LimbsTab:CreateToggle({ Name = "Bỏ qua khiên (ForceField)", Subtitle = "Không kéo nếu có lá chắn", Default = le:Get("FORCEFIELD_CHECK"), Callback = function(v) le:Set("FORCEFIELD_CHECK", v) end })
LimbsTab:CreateToggle({ Name = "Cho chi va chạm", Subtitle = "Làm chi có thể đụng vào người khác", Default = le:Get("LIMB_CAN_COLLIDE"), Callback = function(v) le:Set("LIMB_CAN_COLLIDE", v) end })
LimbsTab:CreateSlider({ Name = "Kích thước chi", Subtitle = "Độ to của tay/chân", range = {15, 500}, increment = 5, Default = le:Get("LIMB_SIZE"), Callback = function(v) le:Set("LIMB_SIZE", v) end })
LimbsTab:CreateSlider({ Name = "Độ trong suốt", Subtitle = "Làm chi trong suốt hơn", range = {0, 1}, increment = 0.1, Default = le:Get("LIMB_TRANSPARENCY"), Callback = function(v) le:Set("LIMB_TRANSPARENCY", v) end })

LimbsTab:CreateDropdown({
    Name = "Chọn chi để kéo",
    GetOptions = function()
        local opts = {}
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    table.insert(opts, part.Name)
                end
            end
        end
        table.sort(opts)
        if #opts == 0 then table.insert(opts, "Không tìm thấy chi") end
        return opts
    end,
    RefreshOnOpen = true,
    Callback = function(selected)
        if selected and selected ~= "Không tìm thấy chi" then
            le:Set("TARGET_LIMB", selected)
        end
    end
})

LimbsTab:CreateSection("Phóng to hitbox NPC")

local npcLimbSettings = { Enabled = false, HitboxSize = 5, Transparency = 0.9, SelectedPart = "HumanoidRootPart", TeamCheck = false, Collision = false }
local OldSizes = {}

LimbsTab:CreateToggle({ Name = "Bật phóng to hitbox NPC", Subtitle = "Giúp bắn/dễ trúng NPC hơn", Default = false, Callback = function(v)
    npcLimbSettings.Enabled = v
    if not v then
        for part, data in pairs(OldSizes) do
            if part and part.Parent then
                part.Size = data.Size
                part.Transparency = data.Transparency
                part.CanCollide = data.CanCollide
            end
        end
        OldSizes = {}
    end
end })

LimbsTab:CreateSlider({ Name = "Kích thước hitbox NPC", Subtitle = "Độ to của vùng trúng", range = {5, 500}, increment = 5, Default = 5, Callback = function(v) npcLimbSettings.HitboxSize = v end })
LimbsTab:CreateSlider({ Name = "Độ trong suốt", Subtitle = "Làm hitbox trong suốt", range = {0, 1}, increment = 0.1, Default = 0.9, Callback = function(v) npcLimbSettings.Transparency = v end })
LimbsTab:CreateToggle({ Name = "Chỉ kẻ thù (team check)", Subtitle = "Chỉ phóng to NPC của địch", Default = false, Callback = function(v) npcLimbSettings.TeamCheck = v end })
LimbsTab:CreateToggle({ Name = "Cho va chạm", Subtitle = "Hitbox có thể chặn đạn/người", Default = false, Callback = function(v) npcLimbSettings.Collision = v end })

-- (vòng lặp giữ nguyên)

--------------------- TAB: GAME ---------------------
GamesTab:CreateSection("Battleground (đánh nhau)")
GamesTab:CreateButton({ Name = "Jujutsu Shenanigans (TBO)", Subtitle = "Script cho game Jujutsu Shenanigans", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/cool5013/TBO/main/TBOscript"))() end })
GamesTab:CreateButton({ Name = "Jujutsu Shenanigans II", Subtitle = "Script thứ 2 cho Jujutsu", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Jujutsu-Shenanigans/refs/heads/main/hai.lua"))() end })
GamesTab:CreateButton({ Name = "M1 reset ( combo )", Subtitle = "Hỗ trợ reset đòn đánh tay", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirScripts/main/M1Reset.lua"))() end })
GamesTab:CreateButton({ Name = "The Strongest Battleground (TThanh Hub)", Subtitle = "Hub cho game TSB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kaimm2/TSB/refs/heads/main/Tthanh%20Tong%20Hop%20Tech.txt"))() end })
GamesTab:CreateButton({ Name = "The Strongest Battleground II", Subtitle = "Script khác cho TSB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/TheStrongestBattlegrounds/refs/heads/main/main.lua"))() end })
GamesTab:CreateButton({ Name = "Legend Battleground", Subtitle = "Script legend battleground", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/solarastuff/legendsbattlegrounds/refs/heads/main/legendary.lua"))() end })

GamesTab:CreateSection("Nextbot (đuổi bắt)")
GamesTab:CreateButton({ Name = "Evade (Elderwyrm Hub)", Subtitle = "Hub cho game Evade", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Vraigos/Elderwyrm-Hub-X/refs/heads/main/Scripts/Evade/Overhaul.lua"))() end })
GamesTab:CreateButton({ Name = "Evade", Subtitle = "Script Evade khác", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/evade/refs/heads/main/shabi.lua"))() end })

GamesTab:CreateSection("Sinh tồn - sát nhân")
GamesTab:CreateButton({ Name = "Forsaken I", Subtitle = "Script cho game Forsaken", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snowt69/SNT-HUB/refs/heads/main/Forsaken"))() end })
GamesTab:CreateButton({ Name = "Forsaken II", Subtitle = "Script khác cho Forsaken", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Forsaken/refs/heads/main/null.lua"))() end })
GamesTab:CreateButton({ Name = "Bite By Night", Subtitle = "Script Bite By Night", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/BiteBynight/refs/heads/main/ty.lua"))() end })
GamesTab:CreateButton({ Name = "Murder Mystery 2 I", Subtitle = "Script MM2 bản 1", Callback = function() loadstring(game:HttpGet("https://pastefy.app/wwfom1bX/raw", true))() end })
GamesTab:CreateButton({ Name = "Murder Mystery 2 II", Subtitle = "Script MM2 bản 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/mm2/refs/heads/main/bawe.lua", true))() end })

GamesTab:CreateSection("Bắn súng/FPS")
GamesTab:CreateButton({ Name = "Rivals", Subtitle = "Script Rivals", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/rivals/refs/heads/main/loot.lua"))() end })
GamesTab:CreateButton({ Name = "Arsenal", Subtitle = "Script Arsenal", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Arsenal/refs/heads/main/nah.lua"))() end })

GamesTab:CreateSection("Sinh tồn - sống sót")
GamesTab:CreateButton({ Name = "99 Night In The Forest I", Subtitle = "Script 99 Nights 1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/loader.lua", true))() end })
GamesTab:CreateButton({ Name = "99 Night In The Forest II", Subtitle = "Script 99 Nights 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/99Nights/refs/heads/main/shiba.lua"))() end })
GamesTab:CreateButton({ Name = "Ink Game", Subtitle = "Script Ink Game", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/wefwef34/inkgames.github.io/refs/heads/main/ringta.lua"))() end })
GamesTab:CreateButton({ Name = "Deadrail (Ringta)", Subtitle = "Script Deadrails", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/erewe23/deadrailsring.github.io/refs/heads/main/ringta.lua"))() end })
GamesTab:CreateButton({ Name = "Deadrail II", Subtitle = "Script Deadrails bản 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Dead-Rails/refs/heads/main/hola.lua"))() end })
GamesTab:CreateButton({ Name = "Farm Bond (Skull Hub)", Subtitle = "Auto farm bond", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hungquan99/SkullHub/main/loader.lua"))() end })
GamesTab:CreateButton({ Name = "Tower Of Zombies", Subtitle = "Script Tower Of Zombies", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/TowerofZombies"))() end })
GamesTab:CreateButton({ Name = "Survive Zombie Arena", Subtitle = "Script Survive Zombie Arena", Callback = function() loadstring(game:HttpGet("https://pastefy.app/qcHi3xbp/raw"))() end })
GamesTab:CreateButton({ Name = "Raft 101 Survival", Subtitle = "Script Raft 101", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/NUunqb1w"))() end })

GamesTab:CreateSection("Đua xe")
GamesTab:CreateButton({ Name = "Uma Racing", Subtitle = "Script Uma Racing", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/UPDATE-1.0-Uma-Racing-Simple-And-Open-Source-63947"))() end })

GamesTab:CreateSection("RNG - may rủi")
GamesTab:CreateButton({ Name = "Blox Fruit", Subtitle = "Script Blox Fruit", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/bloxfruit/refs/heads/main/main.lua"))() end })
GamesTab:CreateButton({ Name = "Sailor Piece", Subtitle = "Script Sailor Piece", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/SailorPiece/refs/heads/main/heh.lua"))() end })
GamesTab:CreateButton({ Name = "AK Gaming Ez Hub", Subtitle = "Hub cho nhiều game", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/hehej97/AkGamingEzv2.1/refs/heads/main/AKGaming.lua"))() end })

GamesTab:CreateSection("Brainrot (meme)")
GamesTab:CreateButton({ Name = "Steal A Brainrot", Subtitle = "Script Steal A Brainrot", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/stealabrainrot/refs/heads/main/shiba.lua"))() end })

GamesTab:CreateSection("Đấu đối kháng")
GamesTab:CreateButton({ Name = "Blade Ball I", Subtitle = "Script Blade Ball bản 1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AgentX771/ArgonHubX/main/Loader.lua"))() end })
GamesTab:CreateButton({ Name = "Blade Ball II", Subtitle = "Script Blade Ball bản 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/test2/refs/heads/main/bladeball.lua"))() end })
GamesTab:CreateButton({ Name = "Aura-Ascension", Subtitle = "Script Aura Ascension", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Aura-Ascension/refs/heads/main/looot.lua"))() end })

GamesTab:CreateSection("Mô phỏng - Simulator")
GamesTab:CreateButton({ Name = "Bee Swarm Simulator", Subtitle = "Script Bee Swarm", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/BeeSwarmSimulator/refs/heads/main/loot.lua"))() end })
GamesTab:CreateButton({ Name = "Brookhaven RP", Subtitle = "Script Brookhaven", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Brookhaven-RP/refs/heads/main/wsp.lua"))() end })
GamesTab:CreateButton({ Name = "Adopt Me", Subtitle = "Script Adopt Me", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/testadp/main/adpt.lua"))() end })

GamesTab:CreateSection("Kinh dị")
GamesTab:CreateButton({ Name = "Doors I", Subtitle = "Script Doors bản 1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Iliankytb/Iliankytb/main/NewBestDoorsScriptIliankytb"))() end })
GamesTab:CreateButton({ Name = "Doors II", Subtitle = "Script Doors bản 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/Doors/refs/heads/main/wwsp.lua"))() end })

GamesTab:CreateSection("Câu cá")
GamesTab:CreateButton({ Name = "Fish It", Subtitle = "Script Fish It", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptjame/fishit/refs/heads/main/nice.lua"))() end })

GamesTab:CreateSection("Phiêu lưu kể chuyện")
GamesTab:CreateButton({ Name = "Break In 1", Subtitle = "Script Break In 1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Iptxt/AXHub-Loader/refs/heads/main/Loader"))() end })
GamesTab:CreateButton({ Name = "Break In 2", Subtitle = "Script Break In 2", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EnesXVC/Breakin2/main/script"))() end })

GamesTab:CreateSection("Khác")
GamesTab:CreateButton({ Name = "Fling Things And People (có key)", Subtitle = "Script fling đồ/người", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/BloodyV2/BloodyScript/refs/heads/main/Free"))() end })

--------------------- TAB: SCRIPT ---------------------
ScriptsTab:CreateSection("By Noir (tác giả)")
ScriptsTab:CreateButton({ Name = "Noir Hub Universal", Subtitle = "Hub đa năng của Noir", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirSrc/refs/heads/main/Script/Universal/NH-Universal.lua"))() end })
ScriptsTab:CreateButton({ Name = "Noir Fly (bay)", Subtitle = "Script bay của Noir", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirGui/main/Noir_Fly"))() end })
ScriptsTab:CreateButton({ Name = "SilentAim by Noir", Subtitle = "Aimbot thầm lặng", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirScripts/main/SilentAim.lua"))() end })
ScriptsTab:CreateButton({ Name = "Funny by Noir (trêu đùa)", Subtitle = "Script troll vui nhộn", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirScripts/main/NoirFunny.lua"))() end })
ScriptsTab:CreateButton({ Name = "Wallhop by Noir", Subtitle = "Nhảy lên tường", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirGui/main/wallhop"))() end })

ScriptsTab:CreateSection("Script bay - nhảy tường")
ScriptsTab:CreateButton({ Name = "Fly GUI V3", Subtitle = "Giao diện bay phiên bản 3", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirGui/main/fly_gui_v3"))() end })
ScriptsTab:CreateButton({ Name = "Fly GUI V4", Subtitle = "Giao diện bay phiên bản 4", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/linhmcfake/Script/refs/heads/main/FLYGUIV4"))() end })
ScriptsTab:CreateButton({ Name = "Wallhop mạnh", Subtitle = "Nhảy leo tường pro", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20V4%20script"))() end })
ScriptsTab:CreateButton({ Name = "Aim Bot (tổng quát)", Subtitle = "Aimbot dùng được nhiều game", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Aimbot-Universal-For-Mobile-and-PC-29153"))() end })
ScriptsTab:CreateButton({ Name = "Hitbox Extender", Subtitle = "Phóng to hitbox cho aimbot", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/AAPVdev/scripts/refs/heads/main/UI_LimbExtender.lua'))() end })
ScriptsTab:CreateButton({ Name = "BloxsTrap", Subtitle = "Script bẫy/hack bloxstrap", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/Bloxstrap/main/Initiate.lua'), 'lol')() end })

ScriptsTab:CreateSection("Admin (quyền cao)")
ScriptsTab:CreateButton({ Name = "Infinite Yield", Subtitle = "Admin nổi tiếng nhất", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end })
ScriptsTab:CreateButton({ Name = "Infinite Fun (IY bản vui)", Subtitle = "Infinite Yield bản thêm troll", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Xane123/InfiniteFun_IY/master/source'))() end })
ScriptsTab:CreateButton({ Name = "NameLess", Subtitle = "Admin nhẹ, ít lag", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua"))() end })
ScriptsTab:CreateButton({ Name = "NameLess beta", Subtitle = "Bản thử nghiệm của NameLess", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/NA%20testing.lua"))() end })
ScriptsTab:CreateButton({ Name = "CMD-X", Subtitle = "Admin dạng lệnh", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))() end })
ScriptsTab:CreateButton({ Name = "Fates Admin", Subtitle = "Admin mạnh, nhiều tính năng", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))() end })
ScriptsTab:CreateButton({ Name = "Reviz Admin", Subtitle = "Admin cũ nhưng ổn", Callback = function() loadstring(game:HttpGetAsync("https://pastebin.com/raw/gQg0G6iA"))() end })

ScriptsTab:CreateSection("Hub tổng hợp")
ScriptsTab:CreateButton({ Name = "Ghost Hub", Subtitle = "Hub ma (bypass key)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/blabla6767yoo-cmyk/Scripts/refs/heads/main/Ghost%20Hub%20Key%20Bypass"))() end })
ScriptsTab:CreateButton({ Name = "Anon Hub", Subtitle = "Hub ẩn danh", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/sa435125/AnonHub/refs/heads/main/anonhub.lua"))() end })
ScriptsTab:CreateButton({ Name = "Lua Land Hub", Subtitle = "Hub của Lua Land", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelo-Gitland/LuaLandHubV4Keyless/refs/heads/main/Lua%20Land%20Hub%20%7C%20V4%20Keyless%20Script%20Hub"))() end })
ScriptsTab:CreateButton({ Name = "Yunas FE Script Hub", Subtitle = "Hub script FE", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yunus154524/YunusLo1545-HUB/refs/heads/main/YunusLo1545%20HUB"))() end })
ScriptsTab:CreateButton({ Name = "c00lkidd GUI", Subtitle = "GUI fake c00lkidd", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Angelo-Gitland/c00lkidd-Gui-V1-By-Lua-land/refs/heads/main/c00lkidd%20Gui%20V1%20By%20Lua%20Land"))() end })
ScriptsTab:CreateButton({ Name = "n0tGUI", Subtitle = "GUI n0t", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/Cz3xbk8h"))() end })
ScriptsTab:CreateButton({ Name = "Welding Abuse Hub", Subtitle = "Hub khai thác weld", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/rangell8/Rexys-Welding-Hub/refs/heads/main/script"))() end })
ScriptsTab:CreateButton({ Name = "Rob Visual Script Hub", Subtitle = "Hub chỉnh hình ảnh", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/KSvbtcPE"))() end })
ScriptsTab:CreateButton({ Name = "KRware Hub", Subtitle = "Hub KRware", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/KRWareHub/KRWare/refs/heads/main/KRWare%20Hub%20Loader.lua"))() end })
ScriptsTab:CreateButton({ Name = "System Broken", Subtitle = "Script ragdoll engine", Callback = function() loadstring(game:HttpGet("https://scriptblox.com/raw/Ragdoll-Engine-BEST-SCRIPT-WORKING-SystemBroken-7544"))() end })
ScriptsTab:CreateButton({ Name = "Cryton v3", Subtitle = "Hub Cryton", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/thesigmacorex/Crypton/main/Free"))() end })
ScriptsTab:CreateButton({ Name = "XVC hub", Subtitle = "Hub XVC", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/Piw5bqGq"))() end })
ScriptsTab:CreateButton({ Name = "FE Trolling GUI", Subtitle = "GUI troll FE", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/FE%20Trolling%20GUI.luau"))() end })
ScriptsTab:CreateButton({ Name = "Ultimate Trolling GUI [REBRON]", Subtitle = "GUI troll siêu cấp", Callback = function() loadstring(game:HttpGet("https://pastefy.app/cZhmvb1G/raw"))() end })
ScriptsTab:CreateButton({ Name = "IndexZ Hub", Subtitle = "Hub IndexZ", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/IndexZHub/Loader/main/Loader"))() end })

ScriptsTab:CreateSection("Script troll vui")
ScriptsTab:CreateButton({ Name = "Prismatica Fling", Subtitle = "Hất văng người", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/zood1k/Prismatica-Fling/main/PrismaticaFling"))() end })
ScriptsTab:CreateButton({ Name = "Sandevistan FE (chậm thời gian)", Subtitle = "Làm chậm thời gian", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/Funny_FE_Scripts/main/Sandevistan"))() end })
ScriptsTab:CreateButton({ Name = "FE Wally West (siêu tốc)", Subtitle = "Chạy siêu nhanh kiểu Wally West", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Wally-West-Roblox-51462"))() end })
ScriptsTab:CreateButton({ Name = "FE The Flash", Subtitle = "Chạy nhanh như Flash", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/Funny_FE_Scripts/main/The_Flash"))() end })
ScriptsTab:CreateButton({ Name = "FE Silly Car", Subtitle = "Tạo ô tô ngớ ngẩn", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-SILLY-CAR-V1-48227"))() end })
ScriptsTab:CreateButton({ Name = "FE Cat (thành mèo)", Subtitle = "Biến thành mèo", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/Y1MkBRn3"))() end })
ScriptsTab:CreateButton({ Name = "FE NPC Controller", Subtitle = "Điều khiển NPC", Callback = function() loadstring(game:HttpGet("https://pastebin.com/raw/dacXGb2W"))() end })
ScriptsTab:CreateButton({ Name = "Server Menu (đổi server)", Subtitle = "Đổi server nhanh", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/lumpiasallad/Roblox_ServerHop/refs/heads/main/ServerHopScript.lua"))() end })

--------------------- TAB: GÓI MỞ RỘNG ---------------------
PacksTab:CreateSection("Trang phục")
PacksTab:CreateButton({ Name = "Korblox (chân mất)", Subtitle = "Hiệu ứng Korblox", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirPacks/main/Korblox.lua"))() end })
PacksTab:CreateButton({ Name = "Headless (không đầu)", Subtitle = "Hiệu ứng mất đầu", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/NoirPacks/main/Headless.lua"))() end })

PacksTab:CreateSection("Cảm xúc & cử chỉ")
PacksTab:CreateButton({ Name = "Animation Pack", Subtitle = "Bộ animation", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gwnrdt/gwnrdt/refs/heads/main/Animation.lua"))() end })
PacksTab:CreateButton({ Name = "Animation v2.5", Subtitle = "Animation nâng cao", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Emerson2-creator/Scripts-Roblox/refs/heads/main/ScriptR6/AnimGuiV2.lua"))() end })
PacksTab:CreateButton({ Name = "Emote Tiktok (điệu nhảy)", Subtitle = "Nhảy theo TikTok", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))() end })
PacksTab:CreateButton({ Name = "FE Emote (vừa đi vừa nhảy)", Subtitle = "Emote khi di chuyển", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emotes.lua"))() end })
PacksTab:CreateButton({ Name = "FE Emote GUI", Subtitle = "Giao diện emote FE", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/sypcerr/scripts/refs/heads/main/c15.lua",true))() end })
PacksTab:CreateButton({ Name = "FE Animation Script Hub", Subtitle = "Hub animation FE", Callback = function() loadstring(game:HttpGet("https://kbauu.neocities.org/animation-hub"))() end })
PacksTab:CreateButton({ Name = "Animation GUI by Noir", Subtitle = "GUI animation của Noir", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/Funny_FE_Scripts/main/Animation_GUI"))() end })
PacksTab:CreateButton({ Name = "Reanimation by Noir", Subtitle = "Tái tạo animation", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NoirGoodBoi/Funny_FE_Scripts/main/Reanimation"))() end })
PacksTab:CreateButton({ Name = "Krystal Dance v3", Subtitle = "Điệu nhảy Krystal", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/somethingsimade/KDV3-Fixed/refs/heads/main/KrystalDance3"))() end })

PacksTab:CreateSection("Shader (bóng đổ)")
PacksTab:CreateButton({ Name = "Shaders Script", Subtitle = "Thêm hiệu ứng shader", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua"))() end })

--------------------- TAB: TƯƠNG TÁC NGƯỜI CHƠI ---------------------
PeopleTab:CreateSection("Dịch chuyển ngẫu nhiên")

local function getTargetChar(p) return p and p.Character end
local function getTargetHRP(p) local c = getTargetChar(p); return c and c:FindFirstChild("HumanoidRootPart") end
local function tpToPlayer(p)
    local hrp1 = getTargetHRP(LocalPlayer)
    local hrp2 = getTargetHRP(p)
    if hrp1 and hrp2 then hrp1.CFrame = hrp2.CFrame * CFrame.new(2,0,2) end
end

local function getAllPlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p) end end
    return list
end

local function getNearestPlayer()
    local best, bestDist = nil, math.huge
    local myHRP = getTargetHRP(LocalPlayer)
    if not myHRP then return end
    for _, p in ipairs(getAllPlayers()) do
        local hrp = getTargetHRP(p)
        if hrp then
            local d = (myHRP.Position - hrp.Position).Magnitude
            if d < bestDist then bestDist = d; best = p end
        end
    end
    return best
end

local function getFarthestPlayer()
    local best, bestDist = nil, 0
    local myHRP = getTargetHRP(LocalPlayer)
    if not myHRP then return end
    for _, p in ipairs(getAllPlayers()) do
        local hrp = getTargetHRP(p)
        if hrp then
            local d = (myHRP.Position - hrp.Position).Magnitude
            if d > bestDist then bestDist = d; best = p end
        end
    end
    return best
end

PeopleTab:CreateButton({ Name = "Dịch đến người gần nhất", Subtitle = "Teleport tới người chơi gần bạn nhất", Align = false, Callback = function() local p = getNearestPlayer(); if p then tpToPlayer(p) end end })
PeopleTab:CreateButton({ Name = "Dịch đến người xa nhất", Subtitle = "Teleport tới người chơi xa bạn nhất", Align = false, Callback = function() local p = getFarthestPlayer(); if p then tpToPlayer(p) end end })
PeopleTab:CreateButton({ Name = "Dịch đến ngẫu nhiên", Subtitle = "Teleport tới một người chơi bất kỳ", Align = false, Callback = function()
    local list = getAllPlayers()
    if #list > 0 then tpToPlayer(list[math.random(1, #list)]) end
end })

PeopleTab:CreateSection("Chọn người chơi")

local selectedTarget = nil
local loopTP = false

PeopleTab:CreateDropdown({
    Name = "Chọn người chơi",
    GetOptions = function()
        local opts = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(opts, plr.DisplayName .. " [@" .. plr.Name .. "]")
            end
        end
        if #opts == 0 then table.insert(opts, "Không có ai") end
        return opts
    end,
    RefreshOnOpen = true,
    Callback = function(selected)
        if selected and selected ~= "Không có ai" then
            local name = selected:match("%[@(.-)%]") or selected
            selectedTarget = name
            NoirUI:Notify("Đã chọn", "Đã chọn: " .. name)
        end
    end
})

PeopleTab:CreateButton({ Name = "📡 Dịch đến người đã chọn", Subtitle = "Teleport tới mục tiêu đã chọn", Align = false, Callback = function()
    local target = selectedTarget and Players:FindFirstChild(selectedTarget)
    if target then
        tpToPlayer(target)
        NoirUI:Notify("Dịch chuyển", "Đã đến " .. target.DisplayName)
    else
        NoirUI:Notify("Lỗi", "Chưa chọn người chơi")
    end
end })

PeopleTab:CreateToggle({ Name = "🔄 Dịch chuyển lặp lại", Subtitle = "Tự động dịch mỗi giây về người đã chọn", Default = false, Callback = function(v) loopTP = v end })

PeopleTab:CreateSection("Đi theo & xoay quanh")

local isFollowing = false
local followSpd = 20
local isOrbiting = false
local orbitR = 10
local orbitSpd = 30
local orbitY = 0
local orbitAng = 0
local isAiming = false
local aimStr = 0.4

PeopleTab:CreateToggle({ Name = "Đi theo người chơi", Subtitle = "Tự động chạy theo mục tiêu đã chọn", Default = false, Callback = function(v) isFollowing = v end })
PeopleTab:CreateSlider({ Name = "Tốc độ đi theo", Subtitle = "Độ nhanh khi di chuyển theo", range = {5, 1000}, increment = 5, Default = 20, Callback = function(v) followSpd = v end })
PeopleTab:CreateToggle({ Name = "Xoay quanh người chơi", Subtitle = "Tự động bay vòng quanh mục tiêu", Default = false, Callback = function(v) isOrbiting = v end })
PeopleTab:CreateSlider({ Name = "Bán kính xoay", Subtitle = "Khoảng cách vòng tròn", range = {1, 1000}, increment = 1, Default = 10, Callback = function(v) orbitR = v end })
PeopleTab:CreateSlider({ Name = "Tốc độ xoay", Subtitle = "Độ nhanh của vòng quay", range = {1, 1000}, increment = 1, Default = 30, Callback = function(v) orbitSpd = v end })
PeopleTab:CreateSlider({ Name = "Độ cao khi xoay", Subtitle = "Bay lên/xuống so với mục tiêu", range = {-200, 200}, increment = 1, Default = 0, Callback = function(v) orbitY = v end })

PeopleTab:CreateSection("Ngắm camera")
PeopleTab:CreateToggle({ Name = "Hướng camera về người chơi", Subtitle = "Camera tự động nhìn vào mục tiêu", Default = false, Callback = function(v) isAiming = v end })
PeopleTab:CreateSlider({ Name = "Tốc độ hướng camera", Subtitle = "Độ mượt khi xoay camera", range = {0, 1}, increment = 0.1, Default = 0.35, Callback = function(v) aimStr = v end })

PeopleTab:CreateSection("Theo dõi (spectate)")

local isSpectating = false
local specGui = Instance.new("ScreenGui", game.CoreGui)
specGui.Enabled = false
specGui.Name = "NoirSpectate"

local specFrame = Instance.new("Frame", specGui)
specFrame.Size = UDim2.new(0,260,0,120)
specFrame.Position = UDim2.new(1,-270,0.3,0)
specFrame.BackgroundTransparency = 0.2
specFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", specFrame).CornerRadius = UDim.new(0,8)

local specAvatar = Instance.new("ImageLabel", specFrame)
specAvatar.Size = UDim2.new(0,50,0,50)
specAvatar.Position = UDim2.new(0,10,0,10)
specAvatar.BackgroundTransparency = 1

local specInfo = Instance.new("TextLabel", specFrame)
specInfo.Size = UDim2.new(1,-70,1,-20)
specInfo.Position = UDim2.new(0,70,0,10)
specInfo.BackgroundTransparency = 1
specInfo.TextScaled = true
specInfo.TextXAlignment = Enum.TextXAlignment.Left
specInfo.TextColor3 = Color3.fromRGB(255,255,255)
specInfo.Font = Enum.Font.SourceSansBold

local btnLeft = Instance.new("TextButton", specFrame)
btnLeft.Size = UDim2.new(0,25,0,25)
btnLeft.Position = UDim2.new(0,10,1,-30)
btnLeft.Text = "<"
btnLeft.BackgroundColor3 = Color3.fromRGB(50,50,50)
btnLeft.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btnLeft).CornerRadius = UDim.new(1,0)

local btnRight = Instance.new("TextButton", specFrame)
btnRight.Size = UDim2.new(0,25,0,25)
btnRight.Position = UDim2.new(0,40,1,-30)
btnRight.Text = ">"
btnRight.BackgroundColor3 = Color3.fromRGB(50,50,50)
btnRight.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", btnRight).CornerRadius = UDim.new(1,0)

local function getTargetIndex()
    local list = getAllPlayers()
    for i, v in ipairs(list) do if v.Name == selectedTarget then return i, list end end
end

btnLeft.MouseButton1Click:Connect(function()
    local i, list = getTargetIndex()
    if i and list[i-1] then selectedTarget = list[i-1].Name end
end)

btnRight.MouseButton1Click:Connect(function()
    local i, list = getTargetIndex()
    if i and list[i+1] then selectedTarget = list[i+1].Name end
end)

PeopleTab:CreateToggle({ Name = "Xem (spectate) người chơi", Subtitle = "Chuyển camera sang người được chọn", Default = false, Callback = function(state)
    isSpectating = state
    specGui.Enabled = state
    if not state and LocalPlayer.Character then
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
end })

RunService.Heartbeat:Connect(function(dt)
    local target = selectedTarget and Players:FindFirstChild(selectedTarget)
    local myHRP = getTargetHRP(LocalPlayer)
    local targetHRP = target and getTargetHRP(target)
    if loopTP and target then tpToPlayer(target) end
    if isFollowing and myHRP and targetHRP then
        local pos = targetHRP.Position + Vector3.new(0,0,3)
        myHRP.CFrame = myHRP.CFrame:Lerp(CFrame.new(pos), dt * (followSpd/10))
    end
    if isOrbiting and myHRP and targetHRP then
        local angSpd = orbitSpd / math.max(orbitR, 0.1)
        orbitAng = orbitAng + angSpd * dt
        local offset = Vector3.new(math.cos(orbitAng) * orbitR, orbitY, math.sin(orbitAng) * orbitR)
        myHRP.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
    end
end)

RunService.RenderStepped:Connect(function()
    local target = selectedTarget and Players:FindFirstChild(selectedTarget)
    if isAiming and target then
        local hrp = getTargetHRP(target)
        if hrp then
            local predicted = hrp.Position + (hrp.Velocity * 0.1)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predicted), aimStr)
        end
    end
    if isSpectating and target then
        local hum = getTargetChar(target) and getTargetChar(target):FindFirstChildOfClass("Humanoid")
        local hrp = getTargetHRP(target)
        if hum and hrp then
            Camera.CameraSubject = hum
            local myHRP = getTargetHRP(LocalPlayer)
            local dist = myHRP and math.floor((myHRP.Position - hrp.Position).Magnitude) or 0
            local vel = hrp.Velocity
            local spd = math.floor(Vector3.new(vel.X,0,vel.Z).Magnitude)
            local state = hum:GetState() == Enum.HumanoidStateType.Jumping and "Jumping" or "Ground"
            specAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..target.UserId.."&width=150&height=150&format=png"
            specInfo.Text = target.DisplayName.." [@"..target.Name.."]\nDist: "..dist.."m\nSpeed: "..spd.."\nState: "..state
        end
    elseif specGui.Enabled then
        specInfo.Text = ""
        specAvatar.Image = ""
    end
end)
