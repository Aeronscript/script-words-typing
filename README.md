# FTW Script Pack - Finish The Word! (Roblox)

Pack de scripts pour **Finish The Word!** (Roblox). Deux outils inclus :
1. **Autotyper** - tape automatiquement les mots par lettre requise (PC + mobile)
2. **Pet Unlocker** - debloque tous les pets sur n''importe quel compte

Tout passe par le bridge **PocketMCP** (`localhost:16384`) qui relie un executeur Roblox (Xeno, etc.) au serveur de controle.

---

## 1. Autotyper (`autotyper_build.lua` / `src/`)

Tape les mots automatiquement des que la lettre imposée est connue. Inclut une interface cliquable (PC + mobile).

### Fonctionnement reel (verifie dans `src/core.lua`)
- Le jeu fire l''event **`question`** (signature: `question(prompt, duration, strikes)`) au debut de chaque round. C''est le vrai event de round (PAS `updateRound` qui n''existe pas).
- `prompt.RequiredLetter` = la lettre imposée par le jeu ce round.
- Le typing se fait EN MAJUSCULES via le module event :
  - `ev.fire("tryKeystroke", char:upper())` pour taper une lettre
  - `ev.fire("tryKeystroke", -1)` pour effacer
  - `ev.fire("tryAnswer")` pour valider/valider le mot
- Le serveur n''accepte le typing que si `LocalPlayer:GetAttribute("IsTurn")` est `true` (pendant le round).
- Deux modes : `AutoFlow` (enchainement sans pause) et `Human Guess` (vitesse variable + pauses pour eviter le comportement robotique).
- `addMoney()` / `toggleMoney()` : exploit qui credite du cash via `ev.remoteFire("purchaseEgg", "Starter", -100000)` (quantite negative => credit serveur).

### Structure
```
src/
  dictionary.lua   # dictionnaire FR/EN/ES inline (hors-ligne)
  core.lua         # logique events / typing / modes / anti-doublon / argent
  gui.lua          # interface ScreenGui cliquable (PC + mobile), frame draggable
  main.lua         # point d''entree
server/
  wordserve.js     # serveur de mots (Bun, port 16385) - outil externe optionnel
words/
  words_*.lua      # packs FR/EN/ES (source pour wordserve)
build.ps1          # compile src/ -> autotyper_build.lua
autotyper_build.lua # build final (1 fichier, lançable via bridge)
```

### Build
```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

### Lancement (PocketMCP bridge localhost:16384)
Le script compile se lance via `POST /api/execute` avec le body :
```json
{ "code": "<contenu de autotyper_build.lua>", "clientId": "<cli_XXXX>" }
```
Le `clientId` change a chaque reconnexion de l''executeur - recupere-le via `GET /api/clients`.

---

## 2. Pet Unlocker (`src/unlocker.lua`)

Debloque **tous les pets** sur n''importe quel compte (0 pet ou deja quelques-uns). Methode eprouvee :

1. **Exploit cash** : `ev.remoteFire("purchaseEgg", egg, -100000)` credite du cash (quantite negative).
2. **Unlock des oeufs** : `ev.remoteFire("unlockEgg", egg)` pour Starter / Expensive / New / Furry.
3. **buyRestrictedPet** : pour les pets a `DirectPrice` (Void, Rich, etc.) - achete directement.
4. **purchaseEgg en boucle** : pour les pets sans DirectPrice (commons) + Furry - Heartbeat-based, non-bloquant.

### Oeufs et pets (verifies)
| Oeuf (cle serveur) | Display | Pets |
|---|---|---|
| `Starter` | Bloc de depart | Goobat, Bee, Frosty |
| `Expensive` | Secret Block | Imp, Robot, Alien, Rich (sac d''argent), BlueCat |
| `New` | Rare Block | Shark, Bunny, Hydra, HeartDragon, Void (mythique), Lily |
| `Furry` | Furry Block | (ouvert en boucle) |

### Lancement
Execute `src/unlocker.lua` via le bridge PocketMCP (meme methode que l''autotyper).
Le script tourne en arriere-plan via `RunService.Heartbeat` (NE FREEZE PAS le jeu).
**Apres execution : DECONNECTE-TOI et reconnecte-toi au jeu pour voir l''inventaire MAJ.**

### Important
- Les pets sont ajoutes cote serveur (DataStore du jeu). La reconnexion recharge le PlayerData et affiche l''inventaire.
- Si l''oeuf `New` (Rare Block, contient Void) n''est pas debloquable, lance `unlockEgg("New")` d''abord (cout 4000 cash, couvert par l''exploit cash).
- Les pets `Expensive` (Secret Block) ont `Robux=true` => `buyRestrictedPet` les rejecte, ils sont obtenus via `purchaseEgg("Expensive", N)`.

---

## Notes techniques
- Module event : `require(game:GetService("ReplicatedStorage").Services.Communication.event)` - C''EST le bon module (le jeu fait `_G.import("event")`).
- Tous les events passent par UN SEUL RemoteEvent multiplexe (nom logique en arg1).
- `timeChanged` arrive meme en lobby (heartbeat du jeu).
- Roblox ne joint que le bridge localhost:16384 ; le dictionnaire est inline dans le script.

## License
MIT - voir LICENSE