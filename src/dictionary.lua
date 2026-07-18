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

return {
  getWordsFor = getWordsFor,
  count = function()
    local n = 0
    for _, v in pairs(FALLBACK) do n = n + #v end
    return n
  end,
}
