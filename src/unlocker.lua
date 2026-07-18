--[[
  FTW Pet Unlocker - debloque TOUS les pets sur n''importe quel compte
  Fonctionne pour un compte avec 0 pet ou deja quelques-uns.
  Methode:
    1. Exploit cash (purchaseEgg avec quantite negative)
    2. unlockEgg pour chaque oeuf
    3. buyRestrictedPet pour les pets a DirectPrice (Void, Rich, etc.)
    4. purchaseEgg en boucle (Heartbeat-based, non-bloquant) pour le reste
  Usage: execute via PocketMCP (Xeno). Le script tourne en arriere-plan
         via RunService.Heartbeat (ne freeze PAS le jeu).
  Apres execution: DECONNECTE-TOI et reconnecte-toi pour voir l''inventaire.
]]

local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)
local RS = game:GetService("RunService")

local EGGS = {"Starter", "Expensive", "New", "Furry"}
local PETS = {
    Starter   = {"Goobat", "Bee", "Frosty"},
    Expensive = {"Imp", "Robot", "Alien", "Rich", "BlueCat"},  -- Secret Block
    New       = {"Shark", "Bunny", "Hydra", "HeartDragon", "Void", "Lily"}, -- Rare Block
    Furry     = {}, -- ouvert en boucle (pets non listes)
}

local function safe(fn)
    local ok, err = pcall(fn)
    if not ok then warn("[Unlocker] err: " .. tostring(err)) end
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
            if ev.remoteFire("buyRestrictedPet", egg, pet) == true then
                bought = bought + 1
            end
        end)
        task.wait(0.1)
    end
end

-- 4. ouvre en boucle (Heartbeat-based, 1 oeuf par frame -> non-bloquant)
local function openLoop(egg, n)
    local count = 0
    local conn
    conn = RS.Heartbeat:Connect(function()
        if count >= n then
            if conn then conn:Disconnect() end
            return
        end
        safe(function() ev.remoteFire("purchaseEgg", egg, 1) end)
        count = count + 1
    end)
end

for _, egg in ipairs(EGGS) do
    openLoop(egg, 250)
end

return "Unlocker demarre (Heartbeat, non-bloquant). Pets directs achetables: " .. bought