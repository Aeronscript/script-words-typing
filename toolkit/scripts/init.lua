-- FTW Toolkit v2.0 — Bootloader
-- Charge tous les modules depuis le dépôt
local BASE = "https://ftw-toolkit.ondev.store/scripts"
local modules = {
  autotyper = BASE .. "/autotyper.lua",
  word_menu = BASE .. "/word_menu.lua",
  word_helper = BASE .. "/word_helper.lua",
  daily_spam = BASE .. "/daily_spam.lua",
  unlocker = BASE .. "/unlocker.lua",
}
local HttpService = game:GetService("HttpService")
local msg = Instance.new("Message")
msg.Text = "FTW Toolkit — Chargement..."
msg.Parent = game:GetService("CoreGui")

for name, url in pairs(modules) do
  local ok, err = pcall(function()
    local code = game:HttpGet(url, true)
    local fn, comp = loadstring(code)
    if fn then
      pcall(fn)
      print("FTW: " .. name .. " chargé")
    end
  end)
  if not ok then warn("FTW: " .. name .. " échoué — " .. tostring(err)) end
  task.wait(0.1)
end
msg:Destroy()
print("FTW Toolkit chargé. Utilise le bouton 🔵 (word menu) ou le panneau ATP (autotyper)")
