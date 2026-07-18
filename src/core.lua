-- core.lua - logique de l'autotyper FTW Ultra Pro
-- depend de _G.DICT (dictionary.lua)

local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)

local DICT = _G.DICT

local usedWords = {}          -- mots deja utilises ce round
local state = {
    active = true,
    mode = "AutoFlow",        -- "HumanGuess" | "AutoFlow"
    round = 0,
    letter = "",
    lastWord = "",
    moneyHack = false,        -- Argent Illimite toggle
}

-- ===== Typing avec variation naturelle =====
local function typeChar(c)
    if c == "\n" then
        ev.fire("tryAnswer")
    elseif c == "\b" then
        ev.fire("tryKeystroke", -1)
    else
        ev.fire("tryKeystroke", c:lower())
    end
end

local function typeWord(word)
    local mode = state.mode
    if mode == "AutoFlow" then
        -- copie directe: on efface puis on envoie tout d'un coup (instant)
        for _ = 1, 40 do ev.fire("tryKeystroke", -1) end
        for i = 1, #word do
            ev.fire("tryKeystroke", word:sub(i, i):lower())
        end
        task.wait(0.05)
        ev.fire("tryAnswer")
        return
    end
    -- Human Guess: typing lettre par lettre avec delai naturel
    task.wait(0.4 + math.random() * 0.9)
    for i = 1, #word do
        typeChar(word:sub(i, i))
        local base = 140 + math.random(0, 160)
        if i == 1 then
            task.wait((100 + math.random(0, 120)) / 1000)
        elseif i == #word then
            task.wait((120 + math.random(0, 140)) / 1000)
        else
            if math.random() < 0.12 then
                task.wait((base + 120 + math.random(0, 250)) / 1000)
            elseif math.random() < 0.2 then
                task.wait((60 + math.random(0, 80)) / 1000)
            else
                task.wait(base / 1000)
            end
        end
    end
    task.wait(mode == "HumanGuess" and (80 + math.random(0, 150)) / 1000 or 0.06)
    typeChar("\n")
end

-- ===== Selection de mot (anti-doublon) =====
local function pickWord(letter)
    local list = DICT.getWordsFor(letter)
    if #list == 0 then return letter .. "eau" end
    local avail = {}
    for _, w in ipairs(list) do
        if not usedWords[w] then table.insert(avail, w) end
    end
    if #avail == 0 then
        -- tous les mots du round utilises -> reset doublons pour ce round
        usedWords = {}
        return list[math.random(#list)]
    end
    -- Human Guess: privilegie mots courts/courants (2-7 lettres)
    if state.mode == "HumanGuess" then
        local short = {}
        for _, w in ipairs(avail) do
            if #w <= 7 then table.insert(short, w) end
        end
        if #short > 0 then return short[math.random(#short)] end
    end
    return avail[math.random(#avail)]
end

-- ===== Argent Illimite (bouton toggle) =====
-- Utilise l'exploit purchaseEgg deja connu (quantite negative -> cash +)
local function addMoney()
    pcall(function()
        ev.remoteFire("purchaseEgg", "Starter", -100000)
    end)
end

-- ===== Round handler =====
local function onRound(data, pos, player, timer)
    data = data or {}
    state.round = state.round + 1
    usedWords = {}
    local letter = data.RequiredLetter or data.Letter or data.letter or ""
    state.letter = letter
    if state.active and letter ~= "" then
        local word = pickWord(letter)
        usedWords[word] = true
        state.lastWord = word
        print("[FTW] R" .. state.round .. " [" .. state.mode .. "] " .. letter .. " -> " .. word)
        task.spawn(function() typeWord(word) end)
    end
end

local function onQuestion(prompt, dur, strikes)
    state.round = state.round + 1
    usedWords = {}   -- reset doublons par round
    local letter = ""
    if type(prompt) == "table" then
        letter = prompt.RequiredLetter or prompt.Letter or prompt.letter or ""
    end
    state.letter = letter
    if state.active and letter ~= "" then
        local word = pickWord(letter)
        usedWords[word] = true
        state.lastWord = word
        print("[FTW] R" .. state.round .. " [" .. state.mode .. "] " .. letter .. " -> " .. word)
        task.spawn(function() typeWord(word) end)
    end
end

local function start()
    ev.remoteConnect("question", onQuestion)
    ev.remoteConnect("updateRound", onRound)
    ev.remoteConnect("round", onQuestion)
    ev.remoteConnect("newRound", onQuestion)
    ev.remoteConnect("correct", function(w) print("[FTW] CORRECT: " .. tostring(w)) end)
    ev.remoteConnect("strike", function(s) print("[FTW] STRIKE " .. tostring(s)) end)
    print("[FTW] core demarre")
end

return {
    start = start,
    setActive = function(v) state.active = v end,
    setMode = function(m) state.mode = m end,
    getMode = function() return state.mode end,
    getState = function() return state end,
    toggleMoney = function()
        state.moneyHack = not state.moneyHack
        if state.moneyHack then
            task.spawn(function()
                while state.moneyHack do
                    addMoney()
                    task.wait(1)
                end
            end)
        end
        return state.moneyHack
    end,
    addMoneyNow = addMoney,
    typeNow = function(word)
        for _ = 1, 40 do typeChar("\b") end
        task.spawn(function() typeWord(word:lower()) end)
    end,
}
