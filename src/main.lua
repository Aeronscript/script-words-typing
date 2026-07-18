-- main.lua - point d'entree FTW Ultra Pro
-- charge dictionary -> core -> gui
_G.DICT = require(script.Parent.dictionary)
_G.CORE = require(script.Parent.core)
require(script.Parent.gui)

_G.CORE.start()
print("[FTW] Ultra Pro demarre")
