# AGENT HANDOFF - FTW Script Pack (Finish The Word!)

Ce fichier detaille tout pour qu'un autre agent (ou toi-meme plus tard) puisse
reprendre le projet sans re-decortiquer le jeu. Lis-le ENTIEREMENT avant de modifier.

---

## 1. CONTEXTE GENERAL

Jeu : Finish The Word! (Roblox)
Executeur utilise : Xeno (ou autre) bridge vers PocketMCP sur localhost:16384
Compte test principal : Clikerboy3 (userId 9498574931)

PocketMCP est un serveur Node/Bun qui recoit du Lua via POST /api/execute et
l'injecte dans le jeu Roblox via l'executeur connecte (Xeno). Le clientId
identifie la session executeur et CHANGE a chaque reconnexion.

### Endpoints PocketMCP (admin token: Bearer adm_XXXXXXXXXXXX  -- REMPLACE PAR TON TOKEN ADMIN POCKETMCP)
- GET /api/clients -> liste des clients connectes (recupere cli_XXXX)
- POST /api/execute body {"code":"<lua>","clientId":"<cli_XXXX>"} -> execute du Lua
- POST /api/decompile body {"path":"<instancePath>"} -> decompile un ModuleScript
  (ATTENTION : ce endpoint est FLAKY, renvoie souvent 400 ou source vide)
- GET /api/heartbeat -> check serveur vivant

Token GitHub push : ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  -- REMPLACE PAR TON TOKEN GITHUB
Repo : Aeronscript/script-words-typing

---

## 2. ARCHITECTURE DU JEU (ce qu'on a decouvert)

### Module event (LE bon)
local rs = game:GetService("ReplicatedStorage")
local ev = require(rs.Services.Communication.event)

- ev.fire(name, ...) : envoie un event au CLIENT du jeu (cote client seulement)
- ev.remoteFire(name, ...) : envoie un event au SERVEUR (remote)
- ev.remoteConnect(name, fn) : s'abonne a un event serveur->client

Le jeu multiplexe TOUT via un seul RemoteEvent :
ReplicatedStorage.Services.Communication.event.RemoteEvent

### Events du jeu (REELS, verifies)
- question (serveur->client) : question(prompt, duration, strikes) -> LE vrai event de round. prompt.RequiredLetter = lettre imposee
- round (serveur->client) : alias de question, meme handler
- newRound (serveur->client) : autre alias
- correct (serveur->client) : (word) mot valide
- strike (serveur->client) : (n) erreur
- timeChanged (serveur->client) : (timestamp) heartbeat, arrive meme en lobby
- tryKeystroke (client->?) : (char OR -1) taper une lettre (string) ou effacer (-1). DOIT etre en MAJUSCULES
- tryAnswer (client->?) : valider le mot tape
- purchaseEgg (client->serveur) : (eggKey, quantity) ouvrir un oeuf. quantity negative => CREDITE du cash (exploit)
- unlockEgg (client->serveur) : (eggKey) debloquer un oeuf (coute UnlockCost en cash)
- buyRestrictedPet (client->serveur) : (eggKey, petName) acheter un pet directement si DirectPrice existe. Reject silencieusement les oeufs Robux=true

### Oeufs et pets (REELS, dans eggCollection.init)
- Starter (Bloc de depart) : Currency Cash, UnlockCost 100. Pets: Goobat 0.045, Bee 0.01, Frosty 0.005
- Expensive (Secret Block) : Currency SpecialKey, UnlockCost 100, Robux=true. Pets: Imp 0.5, Robot 0.32, Alien 0.13, Rich 0.045 (sac d'argent), BlueCat 0.005
- New (Rare Block) : Currency Cash, UnlockCost 4000. Pets: Shark 0.5, Bunny 0.31, Hydra 0.13, HeartDragon 0.045, Void 0.01 (mythique), Lily 0.005
- Furry (Furry Block) : Currency Cash, UnlockCost 8000. Pets non listes cote client (ouverts en boucle)

Le pet Void (mythique) a DirectPrice = 20999 (cash). Le pet Rich (sac d'argent, legendaire) est dans Expensive (Secret Block).

### Zone des oeufs 3D dans le jeu
workspace.Meta.Eggs contient : Starter, Expensive, Furry (chacun avec un
ProximityPrompt dans Root). Pas d'oeuf "Secret" separe - c'est Expensive
dont le display est "Secret Block".

---

## 3. PIEGES CONNUES (ne les redecouvre pas a tes depens)

1. MAJUSCULES OBLIGATOIRES pour tryKeystroke. Minuscules => le serveur reject.
2. IsTurn : le serveur accepte le typing seulement si LocalPlayer:GetAttribute("IsTurn") est true (pendant le round).
3. updateRound N'EXISTE PAS - c'est question le vrai event.
4. Flag OpeningEgg cote serveur : apres un purchaseEgg, le serveur garde OpeningEgg=true
   jusqu'a ce que l'ouverture se termine proprement. Si le client ne declenche pas
   l'overlay GUI (interaction physique avec l'oeuf 3D), le flag peut rester bloque et
   TOUS les remotes suivants ne repondent plus (timeout total).
   => Si les remotes ne repondent plus : DECONNECTE-TOI et reconnecte-toi.
5. Le serveur n'envoie AUCUN event au client apres purchaseEgg (verifie via hook
   OnClientEvent : seul timeChanged arrive). Le pet est ajoute cote serveur (DataStore)
   mais l'overlay ne s'affiche jamais cote client. Les pets sont donc invisibles
   jusqu'a RECONNEXION (le PlayerData se recharge).
6. buyRestrictedPet rejecte les oeufs Robux=true (donc Expensive/Secret Block).
   Pour ces pets, utiliser purchaseEgg("Expensive", N) en boucle.
7. Le dossier ReplicatedStorage.Data est INACCESSIBLE cote client (timeout sur
   FindFirstChild/require). On ne peut PAS lire l'inventaire cote client.
8. getloadedmodules() FREEZE le jeu - ne jamais appeler.
9. getconnections() fonctionne (utilise pour hooker ProximityPrompt.Triggered).
10. PocketMCP /api/analyze, /api/find-gamepass, /api/remotes, /api/instances ne
    marchent QU'avec le client natif PocketMCP. Avec le bridge Xeno, ces endpoints
    retournent "Unknown command type". Utiliser /api/execute (Lua) a la place.

---

## 4. SCRIPTS DU REPO

### autotyper_build.lua + src/ (autotyper)
- Tape les mots automatiquement par lettre requise.
- Event de round : question (handler onQuestion).
- Typing : ev.fire("tryKeystroke", c:upper()) puis ev.fire("tryAnswer").
- Interface GUI cliquable (PC + mobile), frame draggable, bouton MODE toggle.
- Build via build.ps1 (compile src/*.lua en un seul fichier).

### src/unlocker.lua (pet unlocker)
Debloque tous les pets. Deja teste et fonctionnel sur le compte Clikerboy3
(tous les pets obtenus, confirmes apres reconnexion).
- Exploit cash : purchaseEgg(egg, -100000)
- unlockEgg pour chaque oeuf
- buyRestrictedPet pour les pets a DirectPrice (Void, Rich, etc.)
- purchaseEgg en boucle (Heartbeat-based, non-bloquant) pour le reste
- NE PAS modifier la boucle pour faire plus de 250 oeufs/type sans verifier que le
  serveur ne rate pas (voir piege #4).

---

## 5. COMMENT TESTER / REPRENDRE

1. Lance PocketMCP (bun index.min.js dans C:\Users\AMINE\pocketmcp\).
2. Connecte Xeno au jeu (Finish The Word!) -> bridge localhost:16384.
3. Recupere le clientId : GET /api/clients.
4. Execute un script via POST /api/execute avec {"code": "...", "clientId": "cli_XXXX"}.
5. Si les remotes timeout => le serveur est bloque (piege #4) => reconnecte-toi.

### Tester l'unlocker sur un AUTRE compte
- Switch de compte Roblox dans le jeu (compte avec 0 pet ou peu).
- Recupere le NOUVEAU clientId (GET /api/clients).
- Lance src/unlocker.lua sur ce clientId.
- Reconnecte-toi et verifie l'inventaire.

### Verifier les pets
On ne peut PAS lire l'inventaire cote client (piege #7). La seule facon de confirmer
: RECONNEXION + regarder visuellement dans le jeu.

---

## 6. ETAT ACTUEL (date de cette note)
- Autotyper : fonctionnel, build a jour sur GitHub.
- Unlocker : fonctionnel sur Clikerboy3 (tous pets obtenus). Teste sur un 2eme compte
  pas encore fait (bloque par serveur coince, resolu par reconnexion).
- Cash : illimite via exploit (non depense pour le defi pets).
- Pets Secret (Void + Rich) : OBTENUS sur Clikerboy3 (confirme apres reconnexion).

## 7. AMELIORATIONS POSSIBLES (si un agent reprend)
- Lire l'inventaire cote serveur pour confirmer sans reconnexion (hook DataStore?).
- Forcer l'affichage de l'overlay d'oeuf cote client (trouver qui appelle
  eggOpeningOverlay et le fire avec un PetId factice - purement visuel).
- Etendre la liste des pets Furry (actuellement ouverts en boucle, noms inconnus cote
  client car Data inaccessible).
- Gerer le rate-limit si le serveur en a un sur purchaseEgg en boucle.
