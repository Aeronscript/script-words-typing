-- gui.lua - interface FTW Ultra Pro (PC + mobile clavier virtuel)
local PG = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local CORE = _G.CORE
local DICT = _G.DICT

local gui = Instance.new("ScreenGui")
gui.Name = "FTWAutotyper"
gui.ResetOnSpawn = false
gui.Parent = PG

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 380)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(80, 180, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
title.TextColor3 = Color3.fromRGB(120, 220, 255)
title.Text = "FTW Ultra Pro"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 15
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 24)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "En attente..."
status.Font = Enum.Font.Code
status.TextSize = 12
status.Parent = frame

-- Toggle ON/OFF
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, 0, 0, 24)
toggle.Position = UDim2.new(0, 0, 0, 44)
toggle.BackgroundColor3 = Color3.fromRGB(30, 120, 60)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Text = "AUTO: ON"
toggle.Font = Enum.Font.Code
toggle.TextSize = 13
toggle.Parent = frame
toggle.MouseButton1Click:Connect(function()
    CORE.setActive(not CORE.getState().active)
    local now = CORE.getState()
    toggle.Text = now.active and "AUTO: ON" or "AUTO: OFF"
    toggle.BackgroundColor3 = now.active and Color3.fromRGB(30, 120, 60) or Color3.fromRGB(120, 40, 40)
end)

-- Mode AutoFlow
local btnAuto = Instance.new("TextButton")
btnAuto.Size = UDim2.new(0.5, -2, 0, 22)
btnAuto.Position = UDim2.new(0, 0, 0, 68)
btnAuto.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
btnAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAuto.Text = "MODE: AutoFlow"
btnAuto.Font = Enum.Font.Code
btnAuto.TextSize = 12
btnAuto.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
btnAuto.Parent = frame
btnAuto.MouseButton1Click:Connect(function()
    if CORE.getMode() == "AutoFlow" then
        CORE.setMode("HumanGuess")
        btnAuto.Text = "MODE: Human Guess"
        btnAuto.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
    else
        CORE.setMode("AutoFlow")
        btnAuto.Text = "MODE: AutoFlow"
        btnAuto.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
    end
end)

-- Argent Illimite
local btnMoney = Instance.new("TextButton")
btnMoney.Size = UDim2.new(1, 0, 0, 24)
btnMoney.Position = UDim2.new(0, 0, 0, 90)
btnMoney.BackgroundColor3 = Color3.fromRGB(60, 50, 20)

btnMoney.Active = true
btnMoney.AutoButtonColor = true
btnMoney.Text = "ARGENT ILLIMITE: OFF"
btnMoney.Font = Enum.Font.Code
btnMoney.TextSize = 13
btnMoney.Parent = frame
btnMoney.MouseButton1Click:Connect(function()
    local on = CORE.toggleMoney()
    btnMoney.Text = on and "ARGENT ILLIMITE: ON" or "ARGENT ILLIMITE: OFF"
    btnMoney.BackgroundColor3 = on and Color3.fromRGB(120, 100, 30) or Color3.fromRGB(60, 50, 20)
end)

-- Liste de mots cliquables
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, 0, 0, 256)
list.Position = UDim2.new(0, 0, 0, 114)
list.BackgroundColor3 = Color3.fromRGB(8, 12, 20)
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 5
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = list
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function refresh()
    for _, c in ipairs(list:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local st = CORE.getState()
    local words = DICT.getWordsFor(st.letter)
    local y = 0
    local shown = 0
    for _, w in ipairs(words) do
        if shown >= 60 then break end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(22, 32, 48)
        btn.TextColor3 = Color3.fromRGB(170, 225, 255)
        btn.Text = w
        btn.Font = Enum.Font.Code
        btn.TextSize = 12
        btn.Active = true
        btn.AutoButtonColor = true
        btn.Parent = list
        -- PC + mobile: tape le mot choisi (clavier virtuel inclus)
        btn.MouseButton1Click:Connect(function()
            CORE.typeNow(w)
        end)
        y = y + 22
        shown = shown + 1
    end
    list.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- boucle d'update du status + liste
local lastRound = -1
task.spawn(function()
    while true do
        task.wait(0.3)
        local st = CORE.getState()
        status.Text = "R" .. st.round .. " | " .. (st.letter ~= "" and st.letter or "?") .. " | " .. (st.lastWord ~= "" and st.lastWord or "")
        if st.round ~= lastRound then
            lastRound = st.round
            refresh()
        end
    end
end)

print("[FTW] GUI pret")

