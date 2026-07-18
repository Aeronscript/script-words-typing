# FTW Autotyper Ultra Pro

Autotyper pour **Finish The Word!** (Roblox) — tape automatiquement les mots par lettre requise, avec interface cliquable PC + mobile.

## Fonctionnalités
- Activation auto dès qu'un round commence (`updateRound`)
- Détection instantanée de la lettre imposée par le jeu
- Modes :
  - **AutoFlow** : enchaîne les mots sans interruption
  - **Human Guess** : imite un vrai joueur (vitesse variable, pauses simulées, mots courts/courants)
- **Argent Illimité** : toggle qui crédite instantanément (répétable)
- Toggle ON/OFF instantané
- Anti-doublon strict dans un round (réapparition seulement à un autre round)
- Variation constante pour éviter le comportement robotique
- Liste de mots cliquable (clavier virtuel intégré PC + mobile)

## Structure
```
src/
  dictionary.lua  # dictionnaire FR/EN/ES inline (hors-ligne, depuis Roblox)
  core.lua        # logique events / typing / modes / anti-doublon
  gui.lua         # interface ScreenGui cliquable (PC + mobile)
  main.lua        # point d'entree
server/
  wordserve.js    # serveur de mots (Bun, port 16385) - bonus outil externe
words/
  words_*.lua     # packs FR/EN/ES (source pour wordserve)
build.ps1         # compile src/ -> autotyper_build.lua
autotyper_build.lua  # build final (1 fichier, lançable via bridge)
```

## Build
```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

## Lancement (via PocketMCP bridge localhost:16384)
Le script compilé `autotyper_build.lua` se lance via `POST /api/execute` (body `{"code":"...","clientId":"..."}`).

## Notes
- Roblox ne joint que le bridge `localhost:16384` ; le dictionnaire est donc inline dans le script (pas de dépendance serveur au runtime jeu).
- `server/wordserve.js` sert les mots pour des outils externes (non requis pour le jeu).

## License
MIT — voir LICENSE
