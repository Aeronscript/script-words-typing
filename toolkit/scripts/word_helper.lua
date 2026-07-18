-- Word Helper GUI v3 — FTW Toolkit
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local me = Players.LocalPlayer
local BASE = "http://121.208.52.153:16384"

local C = { bg = Color3.fromRGB(13,15,21), panel = Color3.fromRGB(21,24,33), surface = Color3.fromRGB(30,34,46), txt = Color3.fromRGB(236,239,247), muted = Color3.fromRGB(150,160,185), danger = Color3.fromRGB(235,78,78), fr = Color3.fromRGB(120,175,255), en = Color3.fromRGB(110,212,158), accentA = Color3.fromRGB(99,140,255), accentB = Color3.fromRGB(150,95,255), amberA = Color3.fromRGB(245,160,80), amberB = Color3.fromRGB(245,120,70) }

local function corner(inst,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=inst; return c end
local function stroke(inst,color,thick) local s=Instance.new("UIStroke"); s.Color=color; s.Thickness=thick or 1; s.Parent=inst; return s end
local function gradient(inst,c1,c2,rot) local g=Instance.new("UIGradient"); g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}); g.Rotation=rot or 90; g.Parent=inst; return g end
local function copy(t) pcall(function() if setclipboard then setclipboard(t) elseif toClipboard then toClipboard(t) elseif syn and syn.writeclipboard then syn.writeclipboard(t) end end) end

local lang = "FR"; local searching = false
local CG = game:GetService("CoreGui")
if CG:FindFirstChild("WordHelperGui") then CG.WordHelperGui:Destroy() end

local gui = Instance.new("ScreenGui"); gui.Name="WordHelperGui"; gui.ResetOnSpawn=false; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.DisplayOrder=9999; gui.IgnoreGuiInset=true; gui.Parent=CG

local toggle = Instance.new("TextButton"); toggle.Size=UDim2.new(0,50,0,50); toggle.Position=UDim2.new(0,12,0.5,-25); toggle.Text=""; toggle.AutoButtonColor=false; toggle.Active=true; toggle.ZIndex=100; corner(toggle,14); stroke(toggle,Color3.fromRGB(180,200,255),2); gradient(toggle,C.accentA,C.accentB,45); toggle.Parent=gui

local panel = Instance.new("Frame"); panel.Size=UDim2.new(0.5,0,0.62,0); panel.AnchorPoint=Vector2.new(0,0); panel.Position=UDim2.new(0,68,0,10); panel.BackgroundColor3=C.panel; panel.Visible=false; panel.ZIndex=100; corner(panel,16); stroke(panel,Color3.fromRGB(60,66,86),1); panel.Parent=gui
Instance.new("UISizeConstraint",panel).MinSize=Vector2.new(220,320); Instance.new("UISizeConstraint",panel).MaxSize=Vector2.new(350,580)

local titleBar = Instance.new("Frame"); titleBar.Size=UDim2.new(1,0,0,36); titleBar.BackgroundColor3=C.surface; titleBar.ZIndex=101; corner(titleBar,16); gradient(titleBar,C.accentA,C.accentB,90); titleBar.Parent=panel
local title = Instance.new("TextLabel"); title.Size=UDim2.new(1,-44,1,0); title.Position=UDim2.new(0,12,0,0); title.BackgroundTransparency=1; title.TextColor3=Color3.fromRGB(255,255,255); title.Text="Word Helper"; title.Font=Enum.Font.GothamBold; title.TextSize=16; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=102; title.Parent=titleBar
local closeBtn = Instance.new("TextButton"); closeBtn.Size=UDim2.new(0,30,0,30); closeBtn.Position=UDim2.new(1,-34,0.5,-15); closeBtn.BackgroundColor3=C.danger; closeBtn.TextColor3=Color3.fromRGB(255,255,255); closeBtn.Text="✕"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=18; closeBtn.AutoButtonColor=false; closeBtn.ZIndex=104; corner(closeBtn,8); stroke(closeBtn,Color3.fromRGB(255,160,160),1); closeBtn.Parent=titleBar

local sf = Instance.new("ScrollingFrame"); sf.Size=UDim2.new(1,-12,1,-138); sf.Position=UDim2.new(0,6,0,132); sf.BackgroundTransparency=1; sf.BorderSizePixel=0; sf.ScrollingDirection=Enum.ScrollingDirection.Y; sf.CanvasSize=UDim2.new(0,0,0,400); sf.ZIndex=101; sf.Parent=panel

local qBox = Instance.new("TextBox"); qBox.Size=UDim2.new(1,-20,0,32); qBox.Position=UDim2.new(0,10,0,44); qBox.BackgroundColor3=C.surface; qBox.TextColor3=C.txt; qBox.PlaceholderText="lettre ou debut (ex: e / eco)"; qBox.Text=""; qBox.ClearTextOnFocus=false; qBox.Font=Enum.Font.Gotham; qBox.TextSize=14; corner(qBox,10); stroke(qBox,C.accentA,1); qBox.Parent=panel

local langBtns = {}
for i,l in ipairs({{"FR",0,C.fr},{"EN",0.34,C.en},{"ES",0.67,C.accentB}}) do
  local b=Instance.new("TextButton"); b.Size=UDim2.new(0.3,-10,0,28); b.Position=UDim2.new(l[2],10,0,82); b.BackgroundColor3=C.surface; b.TextColor3=C.txt; b.Text=l[1]; b.Font=Enum.Font.GothamBold; b.TextSize=13; b.AutoButtonColor=false; corner(b,8); b.Parent=panel; langBtns[l[1]]=b
end
local function refreshLang() for k,b in pairs(langBtns) do if k==lang then b.BackgroundColor3=(k=="FR"and C.fr)or(k=="EN"and C.en)or C.accentB;b.TextColor3=Color3.fromRGB(255,255,255)else b.BackgroundColor3=C.surface;b.TextColor3=C.muted end end end
refreshLang()

local searchBtn = Instance.new("TextButton"); searchBtn.Size=UDim2.new(1,-20,0,28); searchBtn.Position=UDim2.new(0,10,0,116); searchBtn.AutoButtonColor=false; corner(searchBtn,10); gradient(searchBtn,C.amberA,C.amberB,90); searchBtn.TextColor3=Color3.fromRGB(255,255,255); searchBtn.Text="CHERCHER"; searchBtn.Font=Enum.Font.GothamBold; searchBtn.TextSize=14; searchBtn.Parent=panel

local topBar = Instance.new("TextButton"); topBar.Size=UDim2.new(1,-20,0,26); topBar.Position=UDim2.new(0,10,0,150); topBar.BackgroundColor3=C.bg; topBar.TextColor3=C.accentA; topBar.Text="1er: -"; topBar.Font=Enum.Font.GothamBold; topBar.TextSize=13; topBar.AutoButtonColor=false; corner(topBar,8); stroke(topBar,C.accentA,1); topBar.Parent=panel
local status = Instance.new("TextLabel"); status.Size=UDim2.new(1,-20,0,18); status.Position=UDim2.new(0,10,0,152); status.BackgroundTransparency=1; status.TextColor3=C.muted; status.Text="Tape une lettre"; status.Font=Enum.Font.Gotham; status.TextSize=11; status.TextXAlignment=Enum.TextXAlignment.Left; status.Parent=panel

local listFrame = Instance.new("Frame"); listFrame.Size=UDim2.new(1,-4,1,-4); listFrame.Position=UDim2.new(0,2,0,2); listFrame.BackgroundTransparency=1; listFrame.BorderSizePixel=0; listFrame.ZIndex=101; listFrame.Parent=sf
local grid = Instance.new("UIGridLayout",listFrame); grid.CellSize=UDim2.new(0,104,0,28); grid.CellPadding=UDim2.new(0,4,0,4); grid.FillDirection=Enum.FillDirection.Horizontal; grid.HorizontalAlignment=Enum.HorizontalAlignment.Center; grid.SortOrder=Enum.SortOrder.LayoutOrder

local function clearList() for _,c in pairs(listFrame:GetChildren()) do if c:IsA("GuiObject")and c~=grid then c:Destroy() end end end

local function addWord(text,kind)
  local bg=(kind=="FR")and Color3.fromRGB(34,54,96)or Color3.fromRGB(26,60,46)
  local fg=(kind=="FR")and C.fr or C.en
  local b=Instance.new("TextButton"); b.Size=UDim2.new(0,104,0,28); b.BackgroundColor3=bg; b.TextColor3=fg; b.Text=text; b.Font=Enum.Font.Gotham; b.TextSize=13; b.AutoButtonColor=false; b.ZIndex=102; corner(b,14); stroke(b,fg,1); b.Parent=listFrame
  b.MouseButton1Click:Connect(function() copy(text); b.BackgroundColor3=fg; b.TextColor3=Color3.fromRGB(255,255,255); task.wait(0.15); b.BackgroundColor3=bg; b.TextColor3=fg; setStatus(text) end)
end

local function setStatus(msg) status.Text=msg end

local function doSearch()
  if searching then return end; searching=true
  local q=qBox.Text; setStatus("Recherche...")
  local ok,body=pcall(function() return game:HttpGet(BASE.."/api/words?q="..HttpService:UrlEncode(q).."&limit=200",true) end)
  if not ok then setStatus("Erreur reseau"); searching=false; return end
  local ok2,data=pcall(function() return HttpService:JSONDecode(body) end)
  if not ok2 or not data or not data.ok then setStatus("Reponse invalide"); searching=false; return end
  clearList()
  local words={}
  if lang=="FR" or lang=="ES" or lang=="2" then
    for _,w in ipairs(data.fr) do table.insert(words,{w,"FR"}) end
  end
  if lang=="EN" or lang=="2" then
    for _,w in ipairs(data.en) do table.insert(words,{w,"EN"}) end
  end
  if lang=="ES" or lang=="2" then
    for _,w in ipairs(data.es) do table.insert(words,{w,"ES"}) end
  end
  local first=words[1]and words[1][1]
  if first then topBar.Text="1er: "..first.."  (copie auto)"; copy(first) else topBar.Text="1er: -" end
  for i,w in ipairs(words) do if i<=200 then addWord(w[1],w[2]) end end
  local rows=math.ceil(#words/2); sf.CanvasSize=UDim2.new(0,0,0,math.max(200,rows*32+20))
  setStatus(#words.." mot(s) '"..(q==""and"*"or q).."' ("..lang..")"); searching=false
end

topBar.MouseButton1Click:Connect(function() local t=topBar.Text:match("^1er: (.+)  %("); if t and t~="-" then copy(t); setStatus("Copie: "..t) end end)

local UIS=game:GetService("UserInputService"); local dragging=false; local dragMoved=0; local dragStartPos; local toggleStart
toggle.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=true;dragMoved=0;dragStartPos=Vector2.new(inp.Position.X,inp.Position.Y);toggleStart=toggle.Position end end)
UIS.InputChanged:Connect(function(inp) if not dragging then return end; if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then local pos=Vector2.new(inp.Position.X,inp.Position.Y); local delta=pos-dragStartPos; dragMoved=dragMoved+math.abs(delta.X)+math.abs(delta.Y); local sz=(workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize)or Vector2.new(800,600); local nx=math.clamp(toggleStart.X.Offset+delta.X,0,sz.X-50); local ny=math.clamp(toggleStart.Y.Offset+delta.Y,0,sz.Y-50); toggle.Position=UDim2.new(0,nx,0,ny) end end)
toggle.InputEnded:Connect(function(inp) if dragging and(inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) then dragging=false; if dragMoved<12 then panel.Visible=not panel.Visible; if panel.Visible then doSearch() end end end end)

for k,b in pairs(langBtns) do b.MouseButton1Click:Connect(function() lang=k; refreshLang(); doSearch() end) end
searchBtn.MouseButton1Click:Connect(doSearch)
closeBtn.MouseButton1Click:Connect(function() panel.Visible=false end)
qBox:GetPropertyChangedSignal("Text"):Connect(function() task.wait(0.35); if panel.Visible then doSearch() end end)

print("Word Helper GUI installe")
