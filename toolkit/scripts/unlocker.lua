local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)
local RS = game:GetService("RunService")

local EGGS = {"Starter", "Expensive", "New", "Furry"}
local PETS = {
  Starter   = {"Goobat", "Bee", "Frosty"},
  Expensive = {"Imp", "Robot", "Alien", "Rich", "BlueCat"},
  New       = {"Shark", "Bunny", "Hydra", "HeartDragon", "Void", "Lily"},
  Furry     = {},
}

local function safe(fn)
  local ok, err = pcall(fn)
  if not ok then warn("[Unlocker] " .. tostring(err)) end
  return ok
end

-- 1. credite du cash (exploit quantite negative)
safe(function() ev.remoteFire("purchaseEgg", "Starter", -100000) end)
safe(function() ev.remoteFire("purchaseEgg", "New", -100000) end)
safe(function() ev.remoteFire("purchaseEgg", "Furry", -100000) end)

-- 2. unlock tous les oeufs
for _, egg in ipairs(EGGS) do
  safe(function() ev.remoteFire("unlockEgg", egg) end)
  task.wait(0.2)
end

-- 3. buyRestrictedPet pour chaque pet connu (DirectPrice)
local bought = 0
for egg, list in pairs(PETS) do
  for _, pet in ipairs(list) do
    safe(function()
      if ev.remoteFire("buyRestrictedPet", egg, pet) == true then bought = bought + 1 end
    end)
    task.wait(0.1)
  end
end

-- 4. Heartbeat loop — 1 purchase par frame
local count = {Starter=0, Expensive=0, New=0, Furry=0}
RS.Heartbeat:Connect(function()
  for _, egg in ipairs(EGGS) do
    if count[egg] < 250 then
      safe(function() ev.remoteFire("purchaseEgg", egg, 1) end)
      count[egg] = count[egg] + 1
    end
  end
end)

warn("[Unlocker] Demarre — Heartbeat, non-bloquant. Pets: " .. bought)
