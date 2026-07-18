-- FTW Ultra Pro - build auto (2026-07-18)
-- Genere par build.ps1

-- ===== dictionary.lua =====
-- dictionary.lua - dictionnaire FTW Ultra Pro
-- Fallback inline (FR/EN/ES) - fonctionne hors-ligne depuis Roblox
-- Le serveur local (server/wordserve.js:16385) est un bonus pour outils externes

local FALLBACK = {
  a = {"arc","art","air","ami","ane","avion","arbre","abricot","animal","argent","amour","ange","auto","aube","avril","abricotier","agile","aimer","aller","ananas","ant","apple","ant","arm","area","army","atlas","angel","amber","animal","apple"},
  b = {"bois","bateau","balle","bon","beau","bleu","bruit","bras","bouton","bague","banane","bibliotheque","bizarre","boulanger","blanc","ball","bank","bat","bear","beach","bird","book","box","bread","brown","brother","brush","bus"},
  c = {"chat","chien","cheval","ciel","carre","cafe","chaise","carte","cerise","cible","calculateur","camion","chanson","chocolat","cle","cat","car","cap","city","club","code","coin","cold","cook","cool","corn","cow","crab","cry"},
  d = {"date","dieu","dos","drapeau","difficile","diamant","doigt","dragon","douche","duc","dog","door","dot","dove","down","drag","draw","dream","dress","drink","drop","drum","duck","duke","dust"},
  e = {"eau","elephant","ecole","etoile","etage","epee","ecran","enfant","encre","ennemi","egg","ear","earth","east","edge","eel","egg","eight","elbow","elf","empty","end","energy","engine","enjoy"},
  f = {"feu","fleur","fromage","fort","fille","frere","fruit","fare","farm","fast","fat","fear","feather","feed","feel","fern","field","fight","final","fire","fish","flag","flat","flood","floor","flower","fly","food","foot","forest","fork","free","frog"},
  g = {"gare","glace","gant","gateau","gorille","grande","guerre","guitar","game","gap","garden","gate","gift","girl","give","glad","glass","go","goal","goat","gold","good","grass","green","ground","grow","guard","guide","gun"},
  h = {"haut","herbe","hiver","hotel","habit","haricot","happy","hat","head","heal","heart","heavy","heel","hello","help","hen","herb","hero","hide","high","hill","history","hole","home","hope","horse","hot","hour","house","human","hunter"},
  i = {"idee","ile","image","iguane","immeuble","important","ice","idea","idle","igloo","ill","image","iron","island","item","ivory"},
  j = {"jardin","jour","jambe","jeu","joie","joli","journal","jacket","jam","jar","jaw","jazz","jean","jelly","jewel","job","join","joke","journey","joy","judge","juice","jump","jungle","just"},
  k = {"kaki","koala","karate","key","kick","kind","king","kiss","kite","kitchen","knee","knife","knight","knock","know"},
  l = {"lait","lumiere","lune","livre","lampe","lemon","lion","list","lake","lamb","lamp","land","large","last","late","laugh","leaf","learn","leather","left","leg","lemon","level","light","line","lion","list","little","live","lock","long","look","lose","love","low","lucky"},
  m = {"maison","main","mer","montagne","membre","mode","miel","monde","maire","map","mad","magic","man","many","mark","market","mask","mass","mat","match","meat","meet","melt","menu","metal","middle","milk","mind","minute","mirror","miss","mix","model","money","monkey","month","moon","more","morning","mother","mountain","mouse","mouth","move","much","music","must"},
  n = {"nom","nuage","nuit","nid","noix","noir","name","narrow","nation","native","nature","near","neck","need","nest","net","never","new","news","next","nice","night","no","node","noise","north","nose","note","nothing","notice","now","number"},
  o = {"ocean","oiseau","orange","outil","ouvrir","objet","oeil","oak","obey","object","ocean","offer","office","oil","old","on","once","one","open","orange","order","other","our","out","outside","oval","oven","over","owl","owner"},
  p = {"pain","pomme","porte","pluie","poisson","papier","parapluie","pays","pere","place","pain","pair","pale","palm","pan","panda","paper","park","part","party","pass","past","path","peace","pear","pen","pencil","people","pepper","period","person","phone","photo","piano","pick","picture","pie","pig","pill","pilot","pin","pink","pipe","pizza","place","plan","plant","plate","play","please","plug","plus","pocket","point","poison","pole","police","pond","pool","poor","pop","port","position","pot","potato","power","press","price","prince","prison","prize","problem","profit","project","promise","protect","proud","prove","public","pull","pump","puppy","pure","push","put"},
  q = {"quantite","question","quatre","qualite","queen","question","quick","quiet","quilt","quit","quite","quote"},
  r = {"robe","riviere","route","rat","rose","roue","rayon","radio","rain","ram","rat","rate","read","real","red","rice","rich","ride","right","ring","rise","river","road","rock","roll","roof","room","root","rope","rose","round","row","rub","rule","run","rush"},
  s = {"soleil","sable","sel","soeur","souris","sac","sang","savon","serpent","sentier","star","sun","sad","safe","said","sail","salt","same","sand","save","say","scale","school","score","sea","seal","seat","seed","seek","seem","sell","send","sense","sent","serve","set","seven","shade","shadow","shake","shape","share","sharp","she","sheep","sheet","shelf","shell","shine","ship","shirt","shock","shoe","shop","short","shoulder","shout","show","shut","sick","side","sign","silk","sing","sink","sister","sit","six","size","skin","sky","sleep","slip","slow","small","smile","smoke","snake","snow","so","soap","sock","soft","soil","soldier","some","son","song","soon","sorry","sort","sound","soup","south","space","speak","speed","spell","spend","spoon","sport","spot","spring","square","stage","stand","star","start","state","station","stay","steam","step","stick","still","stone","stop","store","storm","story","street","strong","student","study","sub","such","sugar","summer","sun","sure","swim"},
  t = {"table","temps","terre","tete","tigre","tissue","train","trou","tree","tiger","ten","tall","tap","tape","target","task","taste","tax","tea","teach","team","tear","tell","ten","tent","term","test","text","than","thank","that","the","them","then","there","these","they","thin","thing","think","third","this","those","though","thousand","thread","three","throw","thumb","ticket","tide","tie","tiger","time","tin","tiny","tip","tire","title","to","today","toe","together","tomorrow","tone","tongue","tonight","too","tool","tooth","top","topic","torn","tower","town","toy","trace","track","trade","traffic","train","travel","tree","trip","trouble","truck","true","trust","try","tube","tune","turn","twin","type"},
  u = {"uniforme","usage","utiliser","umbrella","uncle","under","understand","unit","until","up","upon","use","usual"},
  v = {"vetement","ville","vent","verre","voiture","voice","vase","vegetable","very","vest","victory","video","view","village","violin","visit","voice","vote"},
  w = {"water","wall","want","war","warm","wash","watch","water","wave","way","weak","wear","weather","web","week","weight","welcome","well","west","wet","what","wheel","when","where","which","while","white","who","whole","why","wide","wife","wild","will","win","wind","window","wine","wing","winter","wire","wise","wish","with","wolf","woman","wonder","wood","word","work","world","worm","worry","worth","would","write","wrong"},
  x = {"xylophone","xenon","xray","xmas","xerox"},
  y = {"yaourt","yeux","yard","year","yellow","yes","yesterday","yet","you","young","your","youth"},
  z = {"zoo","zombie","zero","zebre","zone","zip","zone","zoo"},
}

local function getWordsFor(letter)
  letter = (letter or ""):lower()
  return FALLBACK[letter] or {}
end

_G.DICT = {
  getWordsFor = getWordsFor,
  count = function()
    local n = 0
    for _, v in pairs(FALLBACK) do n = n + #v end
    return n
  end,
}


-- ===== core.lua =====
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
        ev.fire("tryKeystroke", c:upper())
    end
end

local function typeWord(word)
    local mode = state.mode
    if mode == "AutoFlow" then
        -- copie directe: on efface puis on envoie tout d'un coup (instant)
        for _ = 1, 40 do ev.fire("tryKeystroke", -1) end
        for i = 1, #word do
            ev.fire("tryKeystroke", word:sub(i, i):upper())
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

_G.CORE = {
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


-- ===== gui.lua =====
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



-- ===== main (inline) =====
_G.CORE.start()
print("[FTW] Ultra Pro demarre")

