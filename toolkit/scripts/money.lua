local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local PG = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Supprime l'ancien GUI si présent
for _, n in ipairs({"FTWAutotyper","AutoTyperPro","FTWUltra"}) do
  pcall(function() if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end end)
  pcall(function() if PG:FindFirstChild(n) then PG[n]:Destroy() end end)
end

local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)
if not ev then warn("❌ Module event introuvable"); return end

-- ⚠️ Plafond public : 1 million max (le créateur a son propre solde)
local CAP = 1000000
local per = 50000
local n = math.ceil(CAP / per)
task.spawn(function()
  for i = 1, n do
    pcall(function() ev.remoteFire("purchaseEgg", "Starter", -per) end)
    if i % 1000 == 0 then task.wait(0) end
  end
end)
print("💰 Crédit plafonné à " .. CAP .. " (public)")
