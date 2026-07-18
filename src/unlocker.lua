--[[
  FTW Pet Unlocker - debloque TOUS les pets sur n'importe quel compte
  Fonctionne pour un compte avec 0 pet ou deja quelques-uns.
  Methode:
    1. Exploit cash (purchaseEgg avec quantite negative)
    2. unlockEgg pour chaque oeuf
    3. buyRestrictedPet pour les pets a DirectPrice (Void, Rich, etc.)
    4. purchaseEgg en boucle pour les pets sans DirectPrice + Furry
  Usage: execute via PocketMCP (Xeno). Le script tourne en arriere-plan.
  Apres execution: DECONNECTE-TOI et reconnecte-toi pour voir l'inventaire.
]]

local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)

-- compatibilite task / wait
local spawnFn = (typeof(task) == "table" and task.spawn) or spawn
local waitFn = (typeof(task) == "table" and task.wait) or wait

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
    waitFn(0.2)
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
        waitFn(0.1)
    end
end

-- 4. ouvre en boucle pour les pets sans DirectPrice + Furry
local function openLoop(egg, n)
    for i = 1, n do
        safe(function() ev.remoteFire("purchaseEgg", egg, 1) end)
        if i % 20 == 0 then waitFn(0.3) end
    end
end

-- lance en arriere-plan pour ne pas freeze le jeu
spawnFn(function()
    for _, egg in ipairs(EGGS) do
        openLoop(egg, 250)
    end
    print("[Unlocker] Termine! Tous les pets sont dans ton compte. Reconnecte-toi pour les voir.")
end)

return "Unlocker demarre en arriere-plan. Pets directs achetables: " .. bought