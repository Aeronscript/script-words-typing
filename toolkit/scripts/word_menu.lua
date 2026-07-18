-- Word Menu FR/EN/ES — FTW Toolkit
local SERVER = "http://121.208.52.153:16384"
local g = game:GetService("CoreGui"); if g:FindFirstChild("FTW") then g.FTW:Destroy() end
local Http = game:GetService("HttpService"); local UIS = game:GetService("UserInputService"); local P = game:GetService("Players")

local sg = Instance.new("ScreenGui"); sg.Name="FTW"; sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.Parent=g
local tog = Instance.new("ImageButton"); tog.Size=UDim2.new(0,32,0,32); tog.Position=UDim2.new(0,4,0,60); tog.BackgroundColor3=Color3.fromRGB(18,22,28); tog.Image="rbxassetid://6031094678"; tog.ImageColor3=Color3.fromRGB(100,108,118); tog.Parent=sg
Instance.new("UICorner",tog).CornerRadius=UDim.new(0,8); Instance.new("UIStroke",tog).Thickness=1; tog.UIStroke.Color=Color3.fromRGB(33,38,45)

local f = Instance.new("Frame"); f.Size=UDim2.new(0,280,0,360); f.Position=UDim2.new(0,40,0,56); f.BackgroundColor3=Color3.fromRGB(10,12,16); f.BorderSizePixel=0; f.ClipsDescendants=true; f.Visible=false; f.Parent=sg
Instance.new("UICorner",f).CornerRadius=UDim.new(0,12); Instance.new("UIStroke",f).Thickness=1; f.UIStroke.Color=Color3.fromRGB(33,38,45)

local dh; f.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then dh=i end end)
UIS.InputEnded:Connect(function(i) if i==dh then dh=nil end end)
UIS.InputChanged:Connect(function(i) if i==dh then local p=f.Position; f.Position=UDim2.new(0,math.clamp(p.X.Offset+i.Delta.X,0,400),0,math.clamp(p.Y.Offset+i.Delta.Y,0,500)) end end)

local title = Instance.new("TextLabel"); title.Size=UDim2.new(1,-20,0,32); title.Position=UDim2.new(0,10,0,0); title.BackgroundTransparency=1
title.Text="FTW Word Helper"; title.TextColor3=Color3.fromRGB(74,222,128); title.TextSize=14; title.Font=Enum.Font.GothamBold; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=f

local sb = Instance.new("TextBox"); sb.Size=UDim2.new(1,-20,0,32); sb.Position=UDim2.new(0,10,0,36); sb.BackgroundColor3=Color3.fromRGB(18,22,28); sb.BorderSizePixel=0
sb.PlaceholderText="Cherche un mot... (ex: hel)"; sb.PlaceholderColor3=Color3.fromRGB(80,85,95); sb.Text=""; sb.TextColor3=Color3.fromRGB(210,210,215); sb.TextSize=13; sb.Font=Enum.Font.Gotham; sb.ClearTextOnFocus=false; sb.Parent=f
Instance.new("UICorner",sb).CornerRadius=UDim.new(0,8)

local langSel = Instance.new("Frame"); langSel.Size=UDim2.new(1,-20,0,28); langSel.Position=UDim2.new(0,10,0,74); langSel.BackgroundTransparency=1; langSel.Parent=f
local langBtns={}; local currentLang="all"; local langMap={}
local function setLang(l) currentLang=l; for _,b in ipairs(langBtns) do local lb=langMap[b]; b.BackgroundColor3=(lb==l) and Color3.fromRGB(74,222,128) or Color3.fromRGB(18,22,28); b.TextColor3=(lb==l) and Color3.fromRGB(8,10,14) or Color3.fromRGB(140,145,155) end end
for i,v in ipairs({{"Tous","all"},{"FR","fr"},{"EN","en"},{"ES","es"}}) do
  local b=Instance.new("TextButton"); b.Size=UDim2.new(0,84,0,26); b.Position=UDim2.new(0,(i-1)*90,0,1); b.BackgroundColor3=Color3.fromRGB(18,22,28); b.BorderSizePixel=0; b.Text=v[1]; b.TextColor3=Color3.fromRGB(140,145,155); b.TextSize=12; b.Font=Enum.Font.GothamBold; b.AutoButtonColor=false; b.Parent=langSel
  Instance.new("UICorner",b).CornerRadius=UDim.new(0,6); langMap[b]=v[2]
  b.MouseButton1Click:Connect(function() setLang(langMap[b]); search() end)
  langBtns[#langBtns+1]=b
end
setLang("all")

local st = Instance.new("TextLabel"); st.Size=UDim2.new(1,-20,0,18); st.Position=UDim2.new(0,10,0,106); st.BackgroundTransparency=1; st.Text=""; st.TextColor3=Color3.fromRGB(100,108,118); st.TextSize=10; st.Font=Enum.Font.Gotham; st.Parent=f
local lf = Instance.new("Frame"); lf.Size=UDim2.new(1,-20,1,-136); lf.Position=UDim2.new(0,10,0,126); lf.BackgroundColor3=Color3.fromRGB(16,19,24); lf.BorderSizePixel=0; lf.ClipsDescendants=true; lf.Parent=f
Instance.new("UICorner",lf).CornerRadius=UDim.new(0,8)

local sc = Instance.new("ScrollingFrame"); sc.Size=UDim2.new(1,0,1,0); sc.BackgroundTransparency=1; sc.BorderSizePixel=0; sc.ScrollBarThickness=2; sc.ScrollBarImageColor3=Color3.fromRGB(60,65,75); sc.CanvasSize=UDim2.new(0,0,0,0); sc.AutomaticCanvasSize=Enum.AutomaticSize.Y; sc.Parent=lf
local ll = Instance.new("UIListLayout",sc); ll.Padding=UDim.new(0,1)
local visible = false
tog.MouseButton1Click:Connect(function() visible=not visible; f.Visible=visible; tog.ImageColor3=visible and Color3.fromRGB(74,222,128) or Color3.fromRGB(100,108,118) end)

local searchId = 0
function search()
  local q = sb.Text:lower():gsub("[^a-z]","")
  if #q==0 then for _,c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end; st.Text=""; return end
  local myId=tick(); searchId=myId; st.Text="Recherche..."
  task.wait(0.2); if searchId~=myId then return end
  local ok,body=pcall(game.HttpGet,game,SERVER.."/api/words?q="..q.."&limit=200")
  if not ok then st.Text="Err serveur"; return end
  if searchId~=myId then return end
  local ok2,r=pcall(Http.JSONDecode,Http,body)
  if not ok2 then st.Text="Err réponse"; return end
  if searchId~=myId then return end
  for _,c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
  if searchId~=myId then return end
  local all={}
  if (currentLang=="fr" or currentLang=="all") and r.fr then for _,w in ipairs(r.fr) do all[#all+1]={w,"FR"} end end
  if (currentLang=="en" or currentLang=="all") and r.en then for _,w in ipairs(r.en) do all[#all+1]={w,"EN"} end end
  if (currentLang=="es" or currentLang=="all") and r.es then for _,w in ipairs(r.es) do all[#all+1]={w,"ES"} end end
  if #all==0 then st.Text="Aucun mot"; return end
  for _,item in ipairs(all) do
    local b=Instance.new("TextButton"); b.Size=UDim2.new(1,-6,0,28); b.BackgroundColor3=Color3.fromRGB(10,13,18); b.BorderSizePixel=0
    local txt=Instance.new("TextLabel"); txt.Size=UDim2.new(1,-30,1,0); txt.Position=UDim2.new(0,8,0,0); txt.BackgroundTransparency=1; txt.Text=item[1]; txt.TextColor3=Color3.fromRGB(200,205,210); txt.TextSize=13; txt.Font=Enum.Font.Gotham; txt.TextXAlignment=Enum.TextXAlignment.Left; txt.Parent=b
    local badge=Instance.new("TextLabel"); badge.Size=UDim2.new(0,20,1,0); badge.Position=UDim2.new(1,-24,0,0); badge.BackgroundTransparency=1; badge.Text=item[2]; badge.TextColor3=Color3.fromRGB(80,90,100); badge.TextSize=9; badge.Font=Enum.Font.GothamBold; badge.Parent=b
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5); b.Parent=sc
    local w=item[1]
    b.MouseButton1Click:Connect(function() st.Text="➜ "..w.." ("..item[2]..")" end)
  end
  st.Text=#all.." mot(s)"
end
sb.FocusLost:Connect(function() search() end)
sb:GetPropertyChangedSignal("Text"):Connect(function() if #sb.Text>0 then search() end end)
st.Text="🔵 pour ouvrir"
