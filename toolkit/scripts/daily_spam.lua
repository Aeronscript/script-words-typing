-- Daily Reward Spammer · FTW Toolkit v2
-- Trouve l'event daily reward et le spam pour des millions
-- Usage: ouvre le GUI, clique "START", regarde les $
local Players = game:GetService("Players")
local RepS = game:GetService("ReplicatedStorage")
local me = Players.LocalPlayer

local CG = game:GetService("CoreGui")
if CG:FindFirstChild("FTWDaily") then CG.FTWDaily:Destroy() end

local sg = Instance.new("ScreenGui"); sg.Name="FTWDaily"; sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=CG

local f = Instance.new("Frame"); f.Size=UDim2.new(0,300,0,180); f.Position=UDim2.new(0.5,-150,0.5,-90); f.BackgroundColor3=Color3.fromRGB(10,12,16); f.BorderSizePixel=0
Instance.new("UICorner",f).CornerRadius=UDim.new(0,16); Instance.new("UIStroke",f).Color=Color3.fromRGB(30,36,52); f.Parent=sg

local t = Instance.new("TextLabel"); t.Size=UDim2.new(1,-20,0,36); t.Position=UDim2.new(0,10,0,8); t.BackgroundTransparency=1
t.Text="💰 Daily Reward Spammer"; t.TextColor3=Color3.fromRGB(251,191,36); t.Font=Enum.Font.GothamBold; t.TextSize=15; t.Parent=f

local status = Instance.new("TextLabel"); status.Size=UDim2.new(1,-20,0,20); status.Position=UDim2.new(0,10,0,46)
status.BackgroundTransparency=1; status.TextColor3=Color3.fromRGB(150,160,175); status.Text="Trouve l'event daily..."; status.Font=Enum.Font.Gotham; status.TextSize=11; status.Parent=f

local eventNameBox = Instance.new("TextBox"); eventNameBox.Size=UDim2.new(1,-20,0,30); eventNameBox.Position=UDim2.new(0,10,0,72)
eventNameBox.BackgroundColor3=Color3.fromRGB(18,22,28); eventNameBox.BorderSizePixel=0; eventNameBox.TextColor3=Color3.fromRGB(200,210,220)
eventNameBox.PlaceholderText="Event daily (ex: DailyReward)"; eventNameBox.PlaceholderColor3=Color3.fromRGB(80,85,95)
eventNameBox.Text=""; eventNameBox.Font=Enum.Font.Gotham; eventNameBox.TextSize=13; eventNameBox.ClearTextOnFocus=false; eventNameBox.Parent=f
Instance.new("UICorner",eventNameBox).CornerRadius=UDim.new(0,8)

local count = Instance.new("TextLabel"); count.Size=UDim2.new(1,-20,0,20); count.Position=UDim2.new(0,10,0,108)
count.BackgroundTransparency=1; count.TextColor3=Color3.fromRGB(74,222,128); count.Text="0 claims"; count.Font=Enum.Font.GothamBold; count.TextSize=13; count.Parent=f

local btn = Instance.new("TextButton"); btn.Size=UDim2.new(1,-20,0,34); btn.Position=UDim2.new(0,10,0,134); btn.BackgroundColor3=Color3.fromRGB(74,222,128); btn.TextColor3=Color3.fromRGB(8,10,14); btn.Text="▶ START"; btn.Font=Enum.Font.GothamBold; btn.TextSize=14; btn.AutoButtonColor=false; btn.Parent=f
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)

local active = false; local claimCount = 0; local spamConn = nil

local function findCustomEvent(name)
  local ev = RepS:FindFirstChild("CustomEvent")
  if ev and ev:IsA("RemoteEvent") then return ev end
  for _,v in ipairs(RepS:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find(name:lower()) then return v end
  end
  return nil
end

local function findCommunication()
  local svc = RepS:FindFirstChild("Services")
  if svc then
    local comm = svc:FindFirstChild("Communication")
    if comm then return comm end
    for _,v in ipairs(svc:GetDescendants()) do
      if v.Name:lower():find("communic") then return v end
    end
  end
  for _,v in ipairs(RepS:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:lower():find("communic") then
      return v
    end
  end
  return nil
end

local function spam()
  if not active then return end
  local evName = eventNameBox.Text
  if #evName == 0 then status.Text="Entre un nom d'event"; active=false; btn.Text="▶ START"; return end

  -- Method 1: CustomEvent (RemoteEvent)
  local ce = RepS:FindFirstChild("CustomEvent")
  if ce and ce:IsA("RemoteEvent") then
    pcall(function() ce:FireServer("ClaimDailyReward") end)
    pcall(function() ce:FireServer("DailyReward") end)
    pcall(function() ce:FireServer("daily_reward") end)
    pcall(function() ce:FireServer(evName) end)
  end

  -- Method 2: Communication module (remoteFire)
  local comm = findCommunication()
  if comm then
    local env = pcall(function() return require(comm) end)
    if env and type(env) == "table" then
      local fire = env.remoteFire or env.fire or env.fireNetwork or env.fastFire
      if fire and type(fire) == "function" then
        pcall(fire, evName)
        pcall(fire, evName, me)
        pcall(fire, "ClaimDailyReward")
        pcall(fire, "DailyReward")
      end
    end
  end

  -- Method 3: any RemoteEvent that looks like daily
  for _,v in ipairs(RepS:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:lower():find("daily") or v.Name:lower():find("reward") or v.Name:lower():find("claim")) then
      pcall(function() v:FireServer() end)
      pcall(function() v:FireServer(me) end)
    end
  end

  claimCount = claimCount + 1
  count.Text = claimCount .. " claims"
  status.Text = "Spam " .. evName .. " (#" .. claimCount .. ")"
end

btn.MouseButton1Click:Connect(function()
  active = not active
  btn.Text = active and "⏹ STOP" or "▶ START"
  btn.BackgroundColor3 = active and Color3.fromRGB(235,78,78) or Color3.fromRGB(74,222,128)
  status.Text = active and "Spamming..." or "Stoppé"

  if active then
    spamConn = game:GetService("RunService").Heartbeat:Connect(function()
      task.wait(0.3)
      spam()
    end)
  else
    if spamConn then spamConn:Disconnect(); spamConn = nil end
  end
end)

-- Auto-detect: scan for likely events
task.spawn(function()
  task.wait(1)
  -- Check for any likely daily reward events
  for _,v in ipairs(RepS:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:lower():find("daily") or v.Name:lower():find("reward") or v.Name:lower():find("claim")) then
      eventNameBox.Text = v.Name
      status.Text = "Trouvé: " .. v.Name
      break
    end
  end
end)

print("Daily Reward Spammer loaded — clique START pour commencer")
