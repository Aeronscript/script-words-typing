local rs = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PG = player:WaitForChild("PlayerGui")

for _, n in ipairs({"FTWAutotyper","AutoTyperPro","FTWUltra"}) do
  pcall(function()
    if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end
    if PG:FindFirstChild(n) then PG[n]:Destroy() end
  end)
end
if not table.find then table.find = function(t,v) for i,x in ipairs(t) do if x==v then return i end end; return nil end end

local GH = "https://ftw-toolkit.ondev.store/words"
local POCKET = "http://121.208.52.153:16384"
local ev = nil; local hasEvents = false

local function initEvents()
  local ok, mod = pcall(function() return require(rs.Services.Communication.event) end)
  if ok and mod then ev = mod; hasEvents = true; return true end
  return false
end

local wordCache = {}
local function fetchWordList(letter, lang)
  local key = lang..":"..letter
  if wordCache[key] then return wordCache[key] end
  local ghUrl = GH.."/"..lang.."/"..letter:lower()..".txt"
  local ok, raw = pcall(function() return game:HttpGet(ghUrl, true) end)
  if ok and raw and #raw > 0 then
    local list = {}
    for w in raw:gmatch("[^\r\n]+") do
      if #w > 1 then table.insert(list, w:lower()) end
    end
    if #list > 0 then wordCache[key] = list; return list end
  end
  local pkUrl = POCKET.."/api/words?q="..letter.."&limit=999&lang="..lang
  ok, raw = pcall(function() return game:HttpGet(pkUrl, true) end)
  if ok and raw then
    local ok2, d = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and d and d.ok then local list = d[lang] or {}; wordCache[key] = list; return list end
  end
  return {}
end

local usedWords = {}
local currentLang = "fr"
local function fetchWord(letter)
  local list = fetchWordList(letter, currentLang)
  local avail = {}
  for _, w in ipairs(list) do if not usedWords[w] then table.insert(avail, w) end end
  if #avail == 0 then avail = list; usedWords = {} end
  if #avail > 0 then local w = avail[math.random(#avail)]; usedWords[w] = true; return w end
  return nil
end

local function fetchWordsByLang(letter, lang)
  local list = fetchWordList(letter, lang)
  if #list > 80 then
    local sorted = {}; for _, v in ipairs(list) do table.insert(sorted, v) end
    table.sort(sorted, function(a,b) return #a < #b end)
    local out = {}; for i=1,math.min(80,#sorted) do out[i] = sorted[i] end; return out
  end
  return list
end

-- === GUI ===
local screen = Instance.new("ScreenGui")
screen.Name = "FTWUltra"; screen.ResetOnSpawn = false; screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screen.DisplayOrder = 9999; screen.Parent = CoreGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 340, 0, 520); f.Position = UDim2.new(0, 10, 0, 60)
f.BackgroundColor3 = Color3.fromRGB(8, 11, 18); f.BorderSizePixel = 0; f.Active = true; f.ClipsDescendants = true; f.Parent = screen
Instance.new("UICorner",f).CornerRadius = UDim.new(0, 16)
local stk = Instance.new("UIStroke",f); stk.Color = Color3.fromRGB(24, 30, 48); stk.Thickness = 1

do local d,s,p; f.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then d=true;s=i.Position;p=f.Position end end)
f.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.Touch then f.Position=UDim2.new(0,p.X.Offset+(i.Position-s).X,0,p.Y.Offset+(i.Position-s).Y) end end)
f.InputEnded:Connect(function() d=false end) end

-- === Header ===
local hdr = Instance.new("Frame"); hdr.Size = UDim2.new(1,0,0,32); hdr.BackgroundColor3 = Color3.fromRGB(14, 18, 30); hdr.Parent = f
Instance.new("UICorner",hdr).CornerRadius = UDim.new(0,16); Instance.new("UIStroke",hdr).Color = Color3.fromRGB(24, 30, 48)
local logo = Instance.new("TextLabel"); logo.Size = UDim2.new(1,-60,1,0); logo.Position = UDim2.new(0,12,0,0)
logo.BackgroundTransparency = 1; logo.TextColor3 = Color3.fromRGB(74, 222, 128)
logo.Text = "FTW Ultra Pro"; logo.Font = Enum.Font.GothamBold; logo.TextSize = 14; logo.TextXAlignment = Enum.TextXAlignment.Left; logo.Parent = hdr

-- === Status ===
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-24,0,16); status.Position = UDim2.new(0,12,0,36)
status.BackgroundTransparency = 1; status.TextColor3 = Color3.fromRGB(140, 150, 175); status.Text = "Initialisation..."
status.Font = Enum.Font.Gotham; status.TextSize = 10; status.TextXAlignment = Enum.TextXAlignment.Left; status.Parent = f
local function setStatus(t) status.Text = t end

-- === Tabs ===
local tabBg = Instance.new("Frame"); tabBg.Size = UDim2.new(1,-16,0,30); tabBg.Position = UDim2.new(0,8,0,54); tabBg.BackgroundTransparency = 1; tabBg.Parent = f

local tabBtns = {}; local currentTab = "Auto"
local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1,-16,0,420); tabContent.Position = UDim2.new(0,8,0,86)
tabContent.BackgroundColor3 = Color3.fromRGB(10, 14, 24); tabContent.BorderSizePixel = 0; tabContent.ClipsDescendants = true; tabContent.Parent = f
Instance.new("UICorner",tabContent).CornerRadius = UDim.new(0,10)

local function switchTab(name)
  currentTab = name
  for _, c in ipairs(tabContent:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
  for _, btn in ipairs(tabBtns) do
    btn.BackgroundColor3 = btn.Name == name and Color3.fromRGB(24, 34, 56) or Color3.fromRGB(14, 20, 34)
    btn.TextColor3 = btn.Name == name and Color3.fromRGB(220, 230, 255) or Color3.fromRGB(100, 110, 140)
  end
  local c = tabContent:FindFirstChild(name)
  if c then c.Visible = true end
end

local tabNames = {"Auto","Pets","Daily"}
local tabIcons = {"▶","🐾","⭐"}
local tabColors = {Color3.fromRGB(26, 70, 140), Color3.fromRGB(140, 40, 100), Color3.fromRGB(140, 100, 20)}
for i, name in ipairs(tabNames) do
  local btn = Instance.new("TextButton")
  btn.Name = name; btn.Size = UDim2.new(0.31,-4,1,0); btn.Position = UDim2.new((i-1)*(0.33+0.015),0,0,0)
  btn.BackgroundColor3 = Color3.fromRGB(14, 20, 34); btn.TextColor3 = Color3.fromRGB(100, 110, 140)
  btn.Text = tabIcons[i].." "..name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
  btn.AutoButtonColor = false; btn.Parent = tabBg
  Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)
  btn.MouseButton1Click:Connect(function() switchTab(name) end)
  table.insert(tabBtns, btn)
end

-- ============================================================
-- TAB: AUTO
-- ============================================================
local autoFrame = Instance.new("Frame"); autoFrame.Name = "Auto"; autoFrame.Size = UDim2.new(1,0,1,0); autoFrame.BackgroundTransparency = 1; autoFrame.Parent = tabContent; autoFrame.Visible = false

local state = {active = true, round = 0, letter = "", mode = "AutoFlow", moneyHack = false}

-- Toggle
local togBg = Instance.new("Frame"); togBg.Size = UDim2.new(0,36,0,18); togBg.Position = UDim2.new(1,-44,0,8)
togBg.BackgroundColor3 = Color3.fromRGB(60,180,100); togBg.BorderSizePixel = 0; togBg.Parent = autoFrame
Instance.new("UICorner",togBg).CornerRadius = UDim.new(0,9)
local knb = Instance.new("Frame"); knb.Size = UDim2.new(0,14,0,14); knb.Position = UDim2.new(0,20,0,2)
knb.BackgroundColor3 = Color3.fromRGB(255,255,255); knb.BorderSizePixel = 0; knb.Parent = togBg
Instance.new("UICorner",knb).CornerRadius = UDim.new(0,7)
local togBtn = Instance.new("TextButton"); togBtn.Size = UDim2.new(1,0,1,0); togBtn.BackgroundTransparency = 1; togBtn.Text = ""; togBtn.Parent = togBg

local function setActive(on)
  state.active = on
  togBg.BackgroundColor3 = on and Color3.fromRGB(60,180,100) or Color3.fromRGB(180,60,60)
  knb:TweenPosition(UDim2.new(0, on and 20 or 2, 0, 2), "Out","Quad",0.12,true)
  if on then usedWords = {}; setStatus("Actif") end
end
togBtn.MouseButton1Click:Connect(function() setActive(not state.active) end)

-- Controls row
local ctrlBg = Instance.new("Frame"); ctrlBg.Size = UDim2.new(1,-16,0,24); ctrlBg.Position = UDim2.new(0,8,0,30); ctrlBg.BackgroundTransparency = 1; ctrlBg.Parent = autoFrame

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.24,-3,1,0); modeBtn.Position = UDim2.new(0,0,0,0)
modeBtn.BackgroundColor3 = Color3.fromRGB(26, 70, 140); modeBtn.TextColor3 = Color3.fromRGB(255,255,255)
modeBtn.Text = "Flow"; modeBtn.Font = Enum.Font.GothamBold; modeBtn.TextSize = 10; modeBtn.AutoButtonColor = false; modeBtn.Parent = ctrlBg
Instance.new("UICorner",modeBtn).CornerRadius = UDim.new(0,6)

local moneyBtn = Instance.new("TextButton")
moneyBtn.Size = UDim2.new(0.24,-3,1,0); moneyBtn.Position = UDim2.new(0.26,0,0,0)
moneyBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 20); moneyBtn.TextColor3 = Color3.fromRGB(255,220,100)
moneyBtn.Text = "💰"; moneyBtn.Font = Enum.Font.GothamBold; moneyBtn.TextSize = 10; moneyBtn.AutoButtonColor = false; moneyBtn.Parent = ctrlBg
Instance.new("UICorner",moneyBtn).CornerRadius = UDim.new(0,6)

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0.24,-3,1,0); langBtn.Position = UDim2.new(0.51,0,0,0)
langBtn.BackgroundColor3 = Color3.fromRGB(26, 50, 90); langBtn.TextColor3 = Color3.fromRGB(180,200,255)
langBtn.Text = "FR"; langBtn.Font = Enum.Font.GothamBold; langBtn.TextSize = 10; langBtn.AutoButtonColor = false; langBtn.Parent = ctrlBg
Instance.new("UICorner",langBtn).CornerRadius = UDim.new(0,6)

-- Word list
local listBg = Instance.new("Frame"); listBg.Size = UDim2.new(1,0,0,310); listBg.Position = UDim2.new(0,0,0,58); listBg.BackgroundTransparency = 1; listBg.ClipsDescendants = true; listBg.Parent = autoFrame
local sc = Instance.new("ScrollingFrame"); sc.Size = UDim2.new(1,0,1,0); sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
sc.ScrollBarThickness = 3; sc.ScrollBarImageColor3 = Color3.fromRGB(40, 48, 68); sc.CanvasSize = UDim2.new(0,0,0,0); sc.AutomaticCanvasSize = Enum.AutomaticSize.Y; sc.Parent = listBg
local layout = Instance.new("UIListLayout",sc); layout.Padding = UDim.new(0,2)

local function clearList() for _,c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end end

local function refreshWordList(letter)
  clearList()
  if #letter == 0 then return end
  local words = fetchWordsByLang(letter, currentLang)
  for _, w in ipairs(words) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-6,0,24); b.BackgroundColor3 = Color3.fromRGB(14, 20, 34); b.BorderSizePixel = 0
    b.TextColor3 = Color3.fromRGB(170, 180, 200); b.Text = w:upper(); b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false; b.Parent = sc
    Instance.new("UIPadding",b).PaddingLeft = UDim.new(0,8)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    local langTag = Instance.new("TextLabel"); langTag.Size = UDim2.new(0,20,1,0); langTag.Position = UDim2.new(1,-24,0,0)
    langTag.BackgroundTransparency = 1; langTag.Text = currentLang:upper(); langTag.Font = Enum.Font.GothamBold; langTag.TextSize = 9; langTag.TextColor3 = Color3.fromRGB(60, 70, 90); langTag.Parent = b
    b.MouseButton1Click:Connect(function()
      if hasEvents then
        for _=1,40 do ev.fire("tryKeystroke", -1) end
        for i=1,#w do ev.fire("tryKeystroke", w:sub(i,i):upper()) end
        task.wait(0.05); ev.fire("tryAnswer")
        setStatus("👆 "..w)
      end
    end)
  end
  setStatus("📖 "..#words.." mots "..currentLang:upper().." pour "..letter:upper())
end

-- === Round handler ===
local function onRound(data)
  local letter = ""
  if type(data)=="table" then letter = data.RequiredLetter or data.Letter or data.letter or "" end
  if #letter==0 then return end
  state.round = state.round+1; state.letter = letter; usedWords = {}
  setStatus("🟢 R"..state.round..": "..letter:upper())
  if state.active then
    local w = fetchWord(letter:lower())
    if w then
      state.lastWord = w
      if hasEvents then
        if state.mode == "AutoFlow" then
          for _=1,40 do ev.fire("tryKeystroke", -1) end
          for i=1,#w do ev.fire("tryKeystroke", w:sub(i,i):upper()) end
          task.wait(0.05); ev.fire("tryAnswer")
        else
          task.wait(0.3+math.random()*0.5)
          for i=1,#w do ev.fire("tryKeystroke", w:sub(i,i):upper()); task.wait(0.08+math.random()*0.12) end
          task.wait(0.1+math.random()*0.15); ev.fire("tryAnswer")
        end
      end
      setStatus("✓ "..w)
    else setStatus("❌ Pas de mot pour "..letter:upper()) end
  end
end

-- === Auto tab button handlers ===
modeBtn.MouseButton1Click:Connect(function()
  state.mode = state.mode == "AutoFlow" and "HumanGuess" or "AutoFlow"
  modeBtn.Text = state.mode == "AutoFlow" and "Flow" or "Guess"
  modeBtn.BackgroundColor3 = state.mode == "AutoFlow" and Color3.fromRGB(26,70,140) or Color3.fromRGB(140,80,24)
end)

local function addMoney()
  if not hasEvents then return false end
  return pcall(function() ev.remoteFire("purchaseEgg", "Starter", -100000) end)
end
moneyBtn.MouseButton1Click:Connect(function()
  if not hasEvents then setStatus("❌ Events pas dispo"); return end
  state.moneyHack = not state.moneyHack
  moneyBtn.BackgroundColor3 = state.moneyHack and Color3.fromRGB(120,100,30) or Color3.fromRGB(80,60,20)
  if state.moneyHack then
    task.spawn(function()
      while state.moneyHack do addMoney(); task.wait(1) end
    end)
  end
  setStatus(state.moneyHack and "💰 Money ON" or "💰 Money OFF")
end)

local langs = {"fr","en","es"}; local li = 1
langBtn.MouseButton1Click:Connect(function()
  li = li % 3 + 1; currentLang = langs[li]
  langBtn.Text = currentLang:upper()
  langBtn.BackgroundColor3 = currentLang=="fr" and Color3.fromRGB(26,50,90) or currentLang=="en" and Color3.fromRGB(26,80,50) or Color3.fromRGB(80,50,26)
  if state.letter ~= "" then refreshWordList(state.letter) end
end)

-- ============================================================
-- TAB: PETS
-- ============================================================
local petsFrame = Instance.new("Frame"); petsFrame.Name = "Pets"; petsFrame.Size = UDim2.new(1,0,1,0); petsFrame.BackgroundTransparency = 1; petsFrame.Parent = tabContent; petsFrame.Visible = false

local petsTitle = Instance.new("TextLabel"); petsTitle.Size = UDim2.new(1,-24,0,20); petsTitle.Position = UDim2.new(0,12,0,8)
petsTitle.BackgroundTransparency = 1; petsTitle.TextColor3 = Color3.fromRGB(200, 210, 240)
petsTitle.Text = "🐾 Pet Unlocker"; petsTitle.Font = Enum.Font.GothamBold; petsTitle.TextSize = 13; petsTitle.TextXAlignment = Enum.TextXAlignment.Left; petsTitle.Parent = petsFrame

local petsStatus = Instance.new("TextLabel"); petsStatus.Size = UDim2.new(1,-24,0,14); petsStatus.Position = UDim2.new(0,12,0,30)
petsStatus.BackgroundTransparency = 1; petsStatus.TextColor3 = Color3.fromRGB(140, 150, 175)
petsStatus.Text = "Prêt"; petsStatus.Font = Enum.Font.Gotham; petsStatus.TextSize = 10; petsStatus.TextXAlignment = Enum.TextXAlignment.Left; petsStatus.Parent = petsFrame

local unlockBtn = Instance.new("TextButton")
unlockBtn.Size = UDim2.new(0.6,0,0,40); unlockBtn.Position = UDim2.new(0.2,0,0,52)
unlockBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 100); unlockBtn.TextColor3 = Color3.fromRGB(255,255,255)
unlockBtn.Text = "🔓 UNLOCK ALL PETS"; unlockBtn.Font = Enum.Font.GothamBold; unlockBtn.TextSize = 12; unlockBtn.AutoButtonColor = false; unlockBtn.Parent = petsFrame
Instance.new("UICorner",unlockBtn).CornerRadius = UDim.new(0,10)
local stk2 = Instance.new("UIStroke",unlockBtn); stk2.Color = Color3.fromRGB(200, 80, 160); stk2.Thickness = 1

local petsLog = Instance.new("ScrollingFrame"); petsLog.Size = UDim2.new(1,-16,0,280); petsLog.Position = UDim2.new(0,8,0,100)
petsLog.BackgroundColor3 = Color3.fromRGB(6, 10, 18); petsLog.BorderSizePixel = 0; petsLog.Parent = petsFrame
Instance.new("UICorner",petsLog).CornerRadius = UDim.new(0,8)
petsLog.ScrollBarThickness = 3; petsLog.ScrollBarImageColor3 = Color3.fromRGB(40, 48, 68)
petsLog.CanvasSize = UDim2.new(0,0,0,0); petsLog.AutomaticCanvasSize = Enum.AutomaticSize.Y
local petsLogLayout = Instance.new("UIListLayout",petsLog); petsLogLayout.Padding = UDim.new(0,2)

local function logPets(msg, color)
  local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,-12,0,16); l.BackgroundTransparency = 1
  l.TextColor3 = color or Color3.fromRGB(160, 170, 200); l.Text = msg; l.Font = Enum.Font.Gotham; l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = petsLog
  Instance.new("UIPadding",l).PaddingLeft = UDim.new(0,8)
end

local EGGS = {"Starter","Expensive","New","Furry"}
local PETS_MAP = {
  Starter   = {"Goobat","Bee","Frosty"},
  Expensive = {"Imp","Robot","Alien","Rich","BlueCat"},
  New       = {"Shark","Bunny","Hydra","HeartDragon","Void","Lily"},
  Furry     = {},
}

unlockBtn.MouseButton1Click:Connect(function()
  if not hasEvents then petsStatus.Text = "❌ Events pas dispo"; return end
  unlockBtn.Text = "⏳ En cours..."; unlockBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 70); unlockBtn.Active = false
  for _, c in ipairs(petsLog:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end

  task.spawn(function()
    local function safe(fn)
      local ok, err = pcall(fn)
      if not ok then logPets("⚠ "..tostring(err), Color3.fromRGB(255,100,100)) end
      return ok
    end

    logPets("💰 Credit cash...", Color3.fromRGB(255,220,100))
    safe(function() ev.remoteFire("purchaseEgg", "Starter", -100000) end)
    safe(function() ev.remoteFire("purchaseEgg", "New", -100000) end)
    safe(function() ev.remoteFire("purchaseEgg", "Furry", -100000) end)

    for _, egg in ipairs(EGGS) do
      logPets("🔓 Unlock "..egg.."...", Color3.fromRGB(100,200,255))
      safe(function() ev.remoteFire("unlockEgg", egg) end)
      task.wait(0.2)
    end

    local bought = 0
    for egg, list in pairs(PETS_MAP) do
      for _, pet in ipairs(list) do
        safe(function()
          if ev.remoteFire("buyRestrictedPet", egg, pet) == true then
            bought = bought + 1; logPets("✅ "..pet, Color3.fromRGB(100,255,100))
          end
        end)
        task.wait(0.1)
      end
    end

    logPets("🔄 Heartbeat loop: purchaseEgg x250 chaque...", Color3.fromRGB(200,180,100))
    local count = {Starter=0, Expensive=0, New=0, Furry=0}
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function()
      for _, egg in ipairs(EGGS) do
        if count[egg] < 250 then
          safe(function() ev.remoteFire("purchaseEgg", egg, 1) end)
          count[egg] = count[egg] + 1
        end
      end
      local done = true
      for _, egg in ipairs(EGGS) do if count[egg] < 250 then done = false end end
      if done and conn then
        conn:Disconnect()
        logPets("✅ Unlock terminé ! Relance le jeu.", Color3.fromRGB(74,222,128))
        petsStatus.Text = "✅ Terminé"
        unlockBtn.Text = "🔓 UNLOCK ALL PETS"; unlockBtn.BackgroundColor3 = Color3.fromRGB(140,40,100); unlockBtn.Active = true
      end
    end)
    petsStatus.Text = "🔄 Heartbeat en cours..."
  end)
end)

-- ============================================================
-- TAB: DAILY
-- ============================================================
local dailyFrame = Instance.new("Frame"); dailyFrame.Name = "Daily"; dailyFrame.Size = UDim2.new(1,0,1,0); dailyFrame.BackgroundTransparency = 1; dailyFrame.Parent = tabContent; dailyFrame.Visible = false

local dailyTitle = Instance.new("TextLabel"); dailyTitle.Size = UDim2.new(1,-24,0,20); dailyTitle.Position = UDim2.new(0,12,0,8)
dailyTitle.BackgroundTransparency = 1; dailyTitle.TextColor3 = Color3.fromRGB(200,210,240)
dailyTitle.Text = "⭐ Daily Reward Spam"; dailyTitle.Font = Enum.Font.GothamBold; dailyTitle.TextSize = 13; dailyTitle.TextXAlignment = Enum.TextXAlignment.Left; dailyTitle.Parent = dailyFrame

local dailyStatus = Instance.new("TextLabel"); dailyStatus.Size = UDim2.new(1,-24,0,14); dailyStatus.Position = UDim2.new(0,12,0,30)
dailyStatus.BackgroundTransparency = 1; dailyStatus.TextColor3 = Color3.fromRGB(140,150,175)
dailyStatus.Text = "Prêt"; dailyStatus.Font = Enum.Font.Gotham; dailyStatus.TextSize = 10; dailyStatus.TextXAlignment = Enum.TextXAlignment.Left; dailyStatus.Parent = dailyFrame

local dailyBtn = Instance.new("TextButton")
dailyBtn.Size = UDim2.new(0.6,0,0,40); dailyBtn.Position = UDim2.new(0.2,0,0,52)
dailyBtn.BackgroundColor3 = Color3.fromRGB(140, 100, 20); dailyBtn.TextColor3 = Color3.fromRGB(255,255,255)
dailyBtn.Text = "⭐ START DAILY SPAM"; dailyBtn.Font = Enum.Font.GothamBold; dailyBtn.TextSize = 12; dailyBtn.AutoButtonColor = false; dailyBtn.Parent = dailyFrame
Instance.new("UICorner",dailyBtn).CornerRadius = UDim.new(0,10)
local stk3 = Instance.new("UIStroke",dailyBtn); stk3.Color = Color3.fromRGB(200, 160, 60); stk3.Thickness = 1

local dailyLog = Instance.new("ScrollingFrame"); dailyLog.Size = UDim2.new(1,-16,0,300); dailyLog.Position = UDim2.new(0,8,0,100)
dailyLog.BackgroundColor3 = Color3.fromRGB(6,10,18); dailyLog.BorderSizePixel = 0; dailyLog.Parent = dailyFrame
Instance.new("UICorner",dailyLog).CornerRadius = UDim.new(0,8)
dailyLog.ScrollBarThickness = 3; dailyLog.ScrollBarImageColor3 = Color3.fromRGB(40,48,68)
dailyLog.CanvasSize = UDim2.new(0,0,0,0); dailyLog.AutomaticCanvasSize = Enum.AutomaticSize.Y
local dailyLogLayout = Instance.new("UIListLayout",dailyLog); dailyLogLayout.Padding = UDim.new(0,2)

local function logDaily(msg, color)
  local l = Instance.new("TextLabel"); l.Size = UDim2.new(1,-12,0,16); l.BackgroundTransparency = 1
  l.TextColor3 = color or Color3.fromRGB(160,170,200); l.Text = msg; l.Font = Enum.Font.Gotham; l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = dailyLog
  Instance.new("UIPadding",l).PaddingLeft = UDim.new(0,8)
end

local dailyRunning = false
dailyBtn.MouseButton1Click:Connect(function()
  if not hasEvents then dailyStatus.Text = "❌ Events pas dispo"; return end
  if dailyRunning then dailyRunning = false; dailyBtn.Text = "⭐ START DAILY SPAM"; dailyStatus.Text = "Stoppé"; return end
  dailyRunning = true; dailyBtn.Text = "⏹ STOP"
  for _, c in ipairs(dailyLog:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end

  task.spawn(function()
    local count = 0
    while dailyRunning do
      local ok = pcall(function() ev.remoteFire("claimDailyReward") end)
      if ok then count = count + 1; logDaily("✅ Claim #"..count, Color3.fromRGB(100,255,100))
      else logDaily("❌ Échec claim", Color3.fromRGB(255,100,100)) end
      dailyStatus.Text = "⭐ Claim x"..count
      task.wait(0.5)
    end
  end)
end)

-- ============================================================
-- INIT
-- ============================================================
task.spawn(function()
  initEvents()
  if hasEvents then
    pcall(function()
      ev.remoteConnect("question", onRound)
      ev.remoteConnect("updateRound", onRound)
      ev.remoteConnect("round", onRound)
      ev.remoteConnect("newRound", onRound)
      ev.remoteConnect("nextRound", onRound)
      ev.remoteConnect("correct", function(w) setStatus("✅ "..tostring(w)) end)
      ev.remoteConnect("strike", function() setStatus("❌ Strike") end)
    end)
    setStatus("✅ Events OK — attente round...")
  end
  if not hasEvents then
    setStatus("⚠ Events fail — scan UI")
    for _,v in ipairs(PG:GetDescendants()) do
      if v:IsA("TextBox") then
        v:GetPropertyChangedSignal("Text"):Connect(function()
          local t = v.Text
          if #t==1 and t:match("%a") then onRound({RequiredLetter = t}) end
        end)
      end
    end
  end
  task.spawn(function()
    local lastLetter = ""
    while true do
      task.wait(0.5)
      if state.letter ~= lastLetter and state.letter ~= "" then
        lastLetter = state.letter; refreshWordList(state.letter)
      end
    end
  end)
end)

switchTab("Auto")
setActive(true)
print("FTW Ultra Pro loaded — menu 3 onglets (Auto/Pets/Daily)")
