--================================
--          GOJO HUB V1
--================================

-- Uso: LocalScript no Roblox Studio
-- Para experiências próprias ou autorizadas.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("GojoHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "GojoHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 180)
main.Position = UDim2.new(0.5, -130, 0.5, -90)
main.BackgroundColor3 = Color3.fromRGB(7, 14, 32)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 145, 255)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 48)
title.BackgroundColor3 = Color3.fromRGB(12, 28, 58)
title.Text = "GOJO HUB"
title.TextColor3 = Color3.fromRGB(80, 180, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -28, 0, 46)
toggle.Position = UDim2.fromOffset(14, 70)
toggle.BackgroundColor3 = Color3.fromRGB(22, 43, 76)
toggle.Text = "ESP PLAYERS: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 15
toggle.Font = Enum.Font.GothamBold
toggle.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 9)
buttonCorner.Parent = toggle

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 28)
minimize.Position = UDim2.new(1, -38, 0, 9)
minimize.BackgroundColor3 = Color3.fromRGB(25, 70, 120)
minimize.Text = "-"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Parent = title

local enabled = false
local minimized = false

local function removeESP(character)
    local h = character:FindFirstChild("GojoHighlight")
    if h then h:Destroy() end
end

local function applyESP(target)
    if not enabled or target == player then return end

    local character = target.Character
    if not character then return end

    removeESP(character)

    local h = Instance.new("Highlight")
    h.Name = "GojoHighlight"
    h.Adornee = character
    h.FillColor = Color3.fromRGB(0, 120, 255)
    h.OutlineColor = Color3.fromRGB(100, 200, 255)
    h.FillTransparency = 0.7
    h.DepthMode = Enum.HighlightDepthMode.Occluded
    h.Parent = character
end

local function updateESP()
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player then
            if enabled then
                applyESP(target)
            elseif target.Character then
                removeESP(target.Character)
            end
        end
    end
end

toggle.Activated:Connect(function()
    enabled = not enabled

    toggle.Text = enabled
        and "ESP PLAYERS: ON"
        or "ESP PLAYERS: OFF"

    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(0, 105, 190)
        or Color3.fromRGB(22, 43, 76)

    updateESP()
end)

Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyESP(target)
    end)
end)

for _, target in ipairs(Players:GetPlayers()) do
    if target ~= player then
        target.CharacterAdded:Connect(function()
            task.wait(0.5)
            applyESP(target)
        end)
    end
end

Players.PlayerRemoving:Connect(function(target)
    if target.Character then
        removeESP(target.Character)
    end
end)

minimize.Activated:Connect(function()
    minimized = not minimized
    toggle.Visible = not minimized
    main.Size = minimized
        and UDim2.fromOffset(260, 48)
        or UDim2.fromOffset(260, 180)
    minimize.Text = minimized and "+" or "-"
end)

-- Arrastar a interface pelo título
local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
