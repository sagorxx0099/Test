local Players=game:GetService("Players")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui",30)
if not PlayerGui then warn("[AT] PlayerGui missing");return end
local Config,Network,Replication
local replica
local replicaFetched=false
local grouped={}
local C={
BG=Color3.fromRGB(18,18,24),Panel=Color3.fromRGB(26,26,34),
Panel2=Color3.fromRGB(34,34,44),Row=Color3.fromRGB(30,30,38),
RowHov=Color3.fromRGB(40,40,52),Accent=Color3.fromRGB(154,108,255),
Accent2=Color3.fromRGB(120,78,220),Stroke=Color3.fromRGB(52,52,68),
Text=Color3.fromRGB(238,238,245),SubText=Color3.fromRGB(140,140,158),
Good=Color3.fromRGB(94,240,138),Bad=Color3.fromRGB(255,94,94),
Warn=Color3.fromRGB(255,190,60),
}
local RARITY_COLORS={
Basic=Color3.fromRGB(180,180,180),Uncommon=Color3.fromRGB(85,235,120),
Rare=Color3.fromRGB(80,170,255),Epic=Color3.fromRGB(175,90,255),
Legendary=Color3.fromRGB(255,175,30),Mythic=Color3.fromRGB(255,85,85),
Godly=Color3.fromRGB(120,175,255),Exclusive=Color3.fromRGB(175,110,255),
}
local RARITY_ORDER={Basic=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythic=6,Godly=7,Exclusive=8}
local function new(cls,props,parent)
local i=Instance.new(cls)
for k,v in pairs(props or{})do i[k]=v end
if parent then i.Parent=parent end
return i
end
local function corner(p,r)return new("UICorner",{CornerRadius=UDim.new(0,r or 8)},p)end
local function stroke(p,c,t,tr)return new("UIStroke",
{Color=c or C.Stroke,Thickness=t or 1,Transparency=tr or 0,
ApplyStrokeMode=Enum.ApplyStrokeMode.Border},p)end
local function padding(p,x,y)return new("UIPadding",
{PaddingLeft=UDim.new(0,x),PaddingRight=UDim.new(0,x),
PaddingTop=UDim.new(0,y),PaddingBottom=UDim.new(0,y)},p)end
local old=PlayerGui:FindFirstChild("AutoTradeGUI")
if old then old:Destroy()end
local gui=new("ScreenGui",{
Name="AutoTradeGUI",ResetOnSpawn=false,IgnoreGuiInset=true,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=2000,Enabled=true,
},PlayerGui)
local toggleBtn=new("TextButton",{
Name="Toggle",Size=UDim2.fromOffset(52,52),
Position=UDim2.new(1,-68,0.5,-26),
BackgroundColor3=C.Accent2,BorderSizePixel=0,AutoButtonColor=false,
Text="AT",Font=Enum.Font.GothamBold,TextSize=15,TextColor3=C.Text,Visible=false,
},gui)
corner(toggleBtn,26)
stroke(toggleBtn,C.Accent,2,0)
new("UIGradient",{Color=ColorSequence.new(C.Accent,C.Accent2),Rotation=135},toggleBtn)
local toggleScale=new("UIScale",{Scale=1},toggleBtn)
task.spawn(function()
while gui and gui.Parent do
if toggleBtn.Visible then
TweenService:Create(toggleScale,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Scale=1.08}):Play()
task.wait(1.2)
TweenService:Create(toggleScale,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Scale=1.0}):Play()
task.wait(1.2)
else
task.wait(0.5)
end
end
end)
local toggleDragging,toggleStart,toggleOrigin
toggleBtn.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1
or input.UserInputType==Enum.UserInputType.Touch then
toggleDragging=true
toggleStart=input.Position
toggleOrigin=toggleBtn.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then toggleDragging=false end
end)
end
end)
local BASE_W,BASE_H=420,440
local main=new("Frame",{
Name="Main",Size=UDim2.fromOffset(BASE_W,BASE_H),
Position=UDim2.new(0.5,0,0.5,0),AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=C.BG,BorderSizePixel=0,Visible=true,ClipsDescendants=true,
},gui)
corner(main,14);stroke(main,C.Stroke,1.5,0)
local mainScale=new("UIScale",{Scale=1},main)
local function updateScale()
local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
if not vp or vp.X<1 then return end
local s=math.min((vp.X*0.92)/BASE_W,(vp.Y*0.86)/BASE_H,1.20)
s=math.max(s,0.68)
TweenService:Create(mainScale,TweenInfo.new(0.2),{Scale=s}):Play()
end
updateScale()
if workspace.CurrentCamera then
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end
local header=new("Frame",{
Size=UDim2.new(1,0,0,44),BackgroundColor3=C.Panel,BorderSizePixel=0,Active=true,
},main)
new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Stroke,BorderSizePixel=0},header)
local accentPill=new("Frame",{
Size=UDim2.fromOffset(4,18),Position=UDim2.new(0,12,0.5,-9),
BackgroundColor3=C.Accent,BorderSizePixel=0,
},header)
corner(accentPill,2)
new("UIGradient",{Color=ColorSequence.new(C.Accent,C.Accent2),Rotation=90},accentPill)
new("TextLabel",{
Position=UDim2.fromOffset(24,0),Size=UDim2.new(1,-100,1,0),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="AUTO-TRADE",
TextSize=14,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},header)
new("TextLabel",{
Position=UDim2.fromOffset(126,0),Size=UDim2.new(1,-200,1,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="· "..LocalPlayer.Name,
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},header)
local dragBtn=new("TextButton",{
Size=UDim2.new(1,-52,1,0),BackgroundTransparency=1,Text="",ZIndex=5,
},header)
local closeBtn=new("TextButton",{
Size=UDim2.fromOffset(30,30),Position=UDim2.new(1,-38,0.5,-15),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Text="✕",Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.SubText,ZIndex=6,
},header)
corner(closeBtn,7);stroke(closeBtn,C.Stroke,1,0.3)
closeBtn.MouseEnter:Connect(function()
TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Bad,TextColor3=C.Text}):Play()
end)
closeBtn.MouseLeave:Connect(function()
TweenService:Create(closeBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Panel2,TextColor3=C.SubText}):Play()
end)
local tabBar=new("Frame",{
Position=UDim2.fromOffset(0,44),Size=UDim2.new(1,0,0,34),
BackgroundColor3=C.Panel,BorderSizePixel=0,
},main)
new("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.Stroke,BorderSizePixel=0},tabBar)
local tabHolder=new("Frame",{
Size=UDim2.new(1,-16,1,0),Position=UDim2.fromOffset(8,0),BackgroundTransparency=1,
},tabBar)
new("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),
VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,
},tabHolder)
local content=new("Frame",{
Position=UDim2.fromOffset(0,78),Size=UDim2.new(1,0,1,-78),BackgroundTransparency=1,
},main)
local statePage=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1},content)
local statusBar=new("Frame",{
Position=UDim2.fromOffset(12,10),Size=UDim2.new(1,-24,0,24),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},statePage)
corner(statusBar,6);stroke(statusBar,C.Stroke,1,0.4)
local statusDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(10,9),
BackgroundColor3=C.Warn,BorderSizePixel=0,
},statusBar)
corner(statusDot,3)
local statusLbl=new("TextLabel",{
Position=UDim2.fromOffset(22,0),Size=UDim2.new(1,-28,1,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Initializing…",
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},statusBar)
local function setStatus(msg,color)
statusLbl.Text=msg
statusDot.BackgroundColor3=color or C.Warn
end
local summary=new("Frame",{
Position=UDim2.fromOffset(12,42),Size=UDim2.new(1,-24,0,52),
BackgroundColor3=C.Panel,BorderSizePixel=0,
},statePage)
corner(summary,10);stroke(summary,C.Stroke,1,0.4)
local unitsLbl=new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(0.45,-14,0.6,0),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="0 Units",
TextSize=17,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},summary)
local uniqueLbl=new("TextLabel",{
Position=UDim2.new(0,14,0.6,0),Size=UDim2.new(0.45,-14,0.4,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="0 unique",
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},summary)
local refreshBtn=new("TextButton",{
Size=UDim2.fromOffset(64,26),Position=UDim2.new(1,-176,0.5,-13),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamSemibold,Text="↻ Refresh",TextSize=11,TextColor3=C.SubText,
},summary)
corner(refreshBtn,7);stroke(refreshBtn,C.Stroke,1,0.3)
refreshBtn.MouseEnter:Connect(function()
TweenService:Create(refreshBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent2,TextColor3=C.Text}):Play()
end)
refreshBtn.MouseLeave:Connect(function()
TweenService:Create(refreshBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Panel2,TextColor3=C.SubText}):Play()
end)
local searchBox=new("TextBox",{
Position=UDim2.new(1,-104,0.5,-13),Size=UDim2.fromOffset(96,26),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
Font=Enum.Font.Gotham,PlaceholderText="Search…",
PlaceholderColor3=C.SubText,Text="",
TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,
},summary)
corner(searchBox,7);stroke(searchBox,C.Stroke,1,0.3);padding(searchBox,8,0)
local listBg=new("Frame",{
Position=UDim2.fromOffset(12,102),Size=UDim2.new(1,-24,1,-114),
BackgroundColor3=C.Panel,BorderSizePixel=0,ClipsDescendants=true,
},statePage)
corner(listBg,10);stroke(listBg,C.Stroke,1,0.4)
local scroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(5,5),Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},listBg)
new("UIListLayout",{
Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical,
},scroll)
local emptyState=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},listBg)
local emptyIcon=new("Frame",{
Size=UDim2.fromOffset(48,48),Position=UDim2.new(0.5,-24,0.5,-50),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},emptyState)
corner(emptyIcon,24);stroke(emptyIcon,C.Stroke,1,0.3)
new("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="?",TextSize=22,TextColor3=C.SubText},emptyIcon)
local emptyTitle=new("TextLabel",{
Position=UDim2.new(0,0,0.5,10),Size=UDim2.new(1,0,0,18),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="No units",
TextSize=13,TextColor3=C.Text,
},emptyState)
local emptySub=new("TextLabel",{
Position=UDim2.new(0,0,0.5,28),Size=UDim2.new(1,0,0,16),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="",
TextSize=11,TextColor3=C.SubText,
},emptyState)
local ATValues={
defaults={
Basic=1,Uncommon=5,Rare=10,Epic=20,
Legendary=30,Mythic=50,Godly=1000,Exclusive=100,
},
overrides={},
filters={
Basic=true,Uncommon=true,Rare=true,Epic=true,
Legendary=true,Mythic=true,Godly=true,Exclusive=true,
},
allEnabled=true,
}
_G.AutoTradeValues=ATValues
local RARITY_LIST={"Basic","Uncommon","Rare","Epic","Legendary","Mythic","Godly","Exclusive"}
local function getUnitValue(name,rarity)
if ATValues.overrides[name]~=nil then
return ATValues.overrides[name]
end
return ATValues.defaults[rarity]or 1
end
_G.AutoTradeGetValue=getUnitValue
local function makeSlider(parent,opts)
local w=opts.width or 100
local trackH=4
local container=new("Frame",{Size=UDim2.fromOffset(w,opts.height or 22),BackgroundTransparency=1},parent)
local track=new("Frame",{
Size=UDim2.new(1,-6,0,trackH),Position=UDim2.new(0,3,0.5,-trackH/2),
BackgroundColor3=C.BG,BorderSizePixel=0,
},container)
corner(track,trackH/2);stroke(track,C.Stroke,1,0.5)
local fill=new("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=opts.accent or C.Accent,BorderSizePixel=0},track)
corner(fill,trackH/2)
local knob=new("Frame",{
Size=UDim2.fromOffset(10,10),AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0,0,0.5,0),BackgroundColor3=C.Text,BorderSizePixel=0,
},track)
corner(knob,5);stroke(knob,opts.accent or C.Accent,1.5,0)
local function paint(frac)
fill.Size=UDim2.new(frac,0,1,0)
knob.Position=UDim2.new(frac,0,0.5,0)
end
local function setValue(v)
v=math.clamp(math.floor(v),opts.min,opts.max)
local range=opts.max-opts.min
paint(range>0 and(v-opts.min)/range or 0)
if opts.onChange then opts.onChange(v)end
end
local dragging=false
local function calcFromX(x)
local tw=track.AbsoluteSize.X
if tw<=0 then return end
local rel=math.clamp((x-track.AbsolutePosition.X)/tw,0,1)
setValue(opts.min+(opts.max-opts.min)*rel)
end
track.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dragging=true;calcFromX(i.Position.X)
end
end)
knob.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dragging=true
end
end)
UserInputService.InputChanged:Connect(function(i)
if dragging and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
calcFromX(i.Position.X)
end
end)
UserInputService.InputEnded:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dragging=false
end
end)
setValue(opts.value)
return{frame=container,setValue=setValue}
end
local valuePage=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},content)
local renderValueUnits
local pendingRerender=nil
local function scheduleRerender()
if pendingRerender then pcall(task.cancel,pendingRerender);pendingRerender=nil end
pendingRerender=task.delay(0.12,function()
pendingRerender=nil
local focus=UserInputService:GetFocusedTextBox()
if focus and focus:IsDescendantOf(valuePage)then return end
if renderValueUnits then renderValueUnits()end
end)
end
local vStatusBar=new("Frame",{
Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,22),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},valuePage)
corner(vStatusBar,6);stroke(vStatusBar,C.Stroke,1,0.4)
local vStatusLbl=new("TextLabel",{
Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-16,1,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="Loading…",
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},vStatusBar)
local vFilterBar=new("Frame",{
Position=UDim2.fromOffset(12,36),Size=UDim2.new(1,-24,0,32),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},valuePage)
corner(vFilterBar,8);stroke(vFilterBar,C.Stroke,1,0.4)
local vFilterScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(6,4),Size=UDim2.new(1,-12,1,-8),
BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
ScrollingDirection=Enum.ScrollingDirection.X,
},vFilterBar)
new("UIListLayout",{
FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),
VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,
},vFilterScroll)
local filterBtns={}
local function updateFilterBtns()
for _,r in ipairs(RARITY_LIST)do
local b=filterBtns[r];if not b then continue end
local rc=RARITY_COLORS[r]or C.SubText
local on=ATValues.filters[r]
b.Text=(on and"✅ "or"· ")..r
b.TextColor3=on and rc or C.SubText
b.UIStroke.Color=on and rc or C.Stroke
b.UIStroke.Transparency=on and 0 or 0.55
end
local all=filterBtns["All"]
if all then
all.Text=(ATValues.allEnabled and"✅ "or"· ").."All Rarities"
all.UIStroke.Color=ATValues.allEnabled and C.Accent or C.Stroke
all.UIStroke.Transparency=ATValues.allEnabled and 0 or 0.55
all.TextColor3=ATValues.allEnabled and C.Text or C.SubText
end
end
local function makeFilterBtn(rarity)
local rc=RARITY_COLORS[rarity]or C.Accent
local isAll=(rarity=="All")
local btn=new("TextButton",{
Size=UDim2.fromOffset(isAll and 104 or 78,24),
BackgroundColor3=C.Panel,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamSemibold,Text="",TextSize=10,
TextColor3=isAll and C.Text or rc,
},vFilterScroll)
corner(btn,6);stroke(btn,isAll and C.Accent or rc,1,0)
btn.Activated:Connect(function()
if isAll then
local nowOn=not ATValues.allEnabled
ATValues.allEnabled=nowOn
for _,r in ipairs(RARITY_LIST)do ATValues.filters[r]=nowOn end
else
ATValues.filters[rarity]=not ATValues.filters[rarity]
local allOn=true
for _,r in ipairs(RARITY_LIST)do
if not ATValues.filters[r]then allOn=false end
end
ATValues.allEnabled=allOn
end
updateFilterBtns()
if renderValueUnits then renderValueUnits()end
end)
filterBtns[rarity]=btn
return btn
end
makeFilterBtn("All")
for _,r in ipairs(RARITY_LIST)do makeFilterBtn(r)end
updateFilterBtns()
local vDefaultsBg=new("Frame",{
Position=UDim2.fromOffset(12,76),Size=UDim2.new(1,-24,0,26),
BackgroundColor3=C.Panel,BorderSizePixel=0,ClipsDescendants=true,
},valuePage)
corner(vDefaultsBg,8);stroke(vDefaultsBg,C.Stroke,1,0.4)
local vDefaultsHeader=new("TextButton",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,AutoButtonColor=false,Text="",ZIndex=2,
},vDefaultsBg)
new("TextLabel",{
Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-32,1,0),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,
Text="Rarity Default Values",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,
},vDefaultsHeader)
local vDefaultsArrow=new("TextLabel",{
Position=UDim2.new(1,-22,0,0),Size=UDim2.fromOffset(18,26),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="▼",
TextSize=10,TextColor3=C.SubText,ZIndex=2,
},vDefaultsHeader)
local vDefaultsGrid=new("Frame",{
Position=UDim2.fromOffset(0,26),Size=UDim2.new(1,0,0,112),
BackgroundTransparency=1,Visible=false,
},vDefaultsBg)
local vMainBg=new("Frame",{
Position=UDim2.fromOffset(12,110),Size=UDim2.new(1,-24,1,-122),
BackgroundColor3=C.Panel,BorderSizePixel=0,ClipsDescendants=true,
},valuePage)
corner(vMainBg,10);stroke(vMainBg,C.Stroke,1,0.4)
local vMainScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(5,5),Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},vMainBg)
new("UIListLayout",{
Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical,
},vMainScroll)
local RARITY_SLIDER_RANGE={
Basic={0,50},Uncommon={0,100},Rare={0,200},Epic={0,500},
Legendary={0,1000},Mythic={0,1000},Godly={0,5000},Exclusive={0,1000},
}
for i,rarity in ipairs(RARITY_LIST)do
local rc=RARITY_COLORS[rarity]or C.SubText
local col=(i-1)%2
local row=math.floor((i-1)/2)
local cell=new("Frame",{
Size=UDim2.new(0.5,-3,0,26),
Position=UDim2.fromOffset(col*195+4,row*27+4),
BackgroundTransparency=1,
},vDefaultsGrid)
local dot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,10),
BackgroundColor3=rc,BorderSizePixel=0,
},cell)
corner(dot,3)
new("TextLabel",{
Position=UDim2.fromOffset(10,0),Size=UDim2.fromOffset(55,26),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=rarity,TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},cell)
local range=RARITY_SLIDER_RANGE[rarity]or{0,1000}
local valueLbl
local slider=makeSlider(cell,{
width=85,min=range[1],max=range[2],
value=ATValues.defaults[rarity]or 1,accent=rc,height=22,
onChange=function(v)
ATValues.defaults[rarity]=v
if valueLbl then valueLbl.Text=tostring(v)end
scheduleRerender()
end,
})
slider.frame.Position=UDim2.fromOffset(67,0)
local valueBox=new("TextBox",{
Position=UDim2.fromOffset(154,2),Size=UDim2.fromOffset(36,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(ATValues.defaults[rarity]or 1),
TextSize=11,TextColor3=rc,TextXAlignment=Enum.TextXAlignment.Center,
ClearTextOnFocus=false,
},cell)
corner(valueBox,4);stroke(valueBox,rc,1,0.4)
valueLbl=valueBox
valueBox.FocusLost:Connect(function()
local n=tonumber(valueBox.Text)
if not n then valueBox.Text=tostring(ATValues.defaults[rarity]or 1);return end
n=math.max(0,math.floor(n))
ATValues.defaults[rarity]=n
slider.setValue(n)
valueBox.Text=tostring(n)
end)
end
local vDefaultsExpanded=false
local function layoutValueUnits()
local yOff=110+(vDefaultsExpanded and 112 or 0)
vMainBg.Position=UDim2.fromOffset(12,yOff)
vMainBg.Size=UDim2.new(1,-24,1,-(yOff+12))
end
local function setDefaultsExpanded(on)
vDefaultsExpanded=on
vDefaultsArrow.Text=on and"▲"or"▼"
vDefaultsGrid.Visible=on
TweenService:Create(vDefaultsBg,TweenInfo.new(0.2),{
Size=UDim2.new(1,-24,0,on and 138 or 26),
}):Play()
task.delay(0.2,layoutValueUnits)
end
vDefaultsHeader.Activated:Connect(function()setDefaultsExpanded(not vDefaultsExpanded)end)
local function makeSectionHeader(parent,text,order)
local h=new("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,LayoutOrder=order},parent)
new("TextLabel",{
Position=UDim2.fromOffset(2,0),Size=UDim2.new(1,-4,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text=text,TextSize=11,TextColor3=C.Accent,
TextXAlignment=Enum.TextXAlignment.Left,
},h)
new("Frame",{
Position=UDim2.fromOffset(0,17),Size=UDim2.new(1,0,0,1),
BackgroundColor3=C.Stroke,BorderSizePixel=0,BackgroundTransparency=0.5,
},h)
return h
end
local function makeSpacer(parent,order)
return new("Frame",{Size=UDim2.new(1,0,0,8),BackgroundTransparency=1,LayoutOrder=order},parent)
end
local function makeEmptyNotice(parent,text,order)
return new("TextLabel",{
Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text=text,TextSize=11,TextColor3=C.SubText,
LayoutOrder=order,TextXAlignment=Enum.TextXAlignment.Center,
},parent)
end
local function buildAllUnits()
if not(Config and Config.Towers)then return{}end
local countMap,eqMap={},{}
for _,e in ipairs(grouped)do
countMap[e.Name]=e.Count
if e.Equipped then eqMap[e.Name]=true end
end
local all={}
for name,cfg in pairs(Config.Towers)do
if cfg.Rarity then
table.insert(all,{
Name=name,Rarity=cfg.Rarity or"Basic",Icon=cfg.Icon,
Count=countMap[name]or 0,Equipped=eqMap[name]or false,
})
end
end
table.sort(all,function(a,b)
local ra=RARITY_ORDER[a.Rarity]or 0
local rb=RARITY_ORDER[b.Rarity]or 0
if ra~=rb then return ra>rb end
return a.Name<b.Name
end)
return all
end
local function makeValueRow(entry,order)
local rc=RARITY_COLORS[entry.Rarity]or C.SubText
local currentVal=getUnitValue(entry.Name,entry.Rarity)
local isOverridden=ATValues.overrides[entry.Name]~=nil
local owned=(entry.Count or 0)>0
local row=new("Frame",{
Size=UDim2.new(1,0,0,40),BackgroundColor3=C.Row,BorderSizePixel=0,LayoutOrder=order,
},vMainScroll)
corner(row,7)
local bar=new("Frame",{
Size=UDim2.fromOffset(3,22),Position=UDim2.new(0,5,0.5,-11),
BackgroundColor3=rc,BorderSizePixel=0,
},row)
corner(bar,1.5)
local iconF=new("Frame",{
Size=UDim2.fromOffset(24,24),Position=UDim2.new(0,11,0.5,-12),
BackgroundColor3=C.BG,BorderSizePixel=0,
},row)
corner(iconF,4);stroke(iconF,rc,1,0.5)
if entry.Icon then
new("ImageLabel",{
Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundTransparency=1,Image=entry.Icon,ScaleType=Enum.ScaleType.Fit,
},iconF)
end
if entry.Equipped then
local dot=new("Frame",{
Size=UDim2.fromOffset(7,7),Position=UDim2.fromOffset(28,6),
BackgroundColor3=C.Accent,BorderSizePixel=0,ZIndex=5,
},row)
corner(dot,3.5);stroke(dot,C.BG,1.5,0)
end
new("TextLabel",{
Position=UDim2.fromOffset(42,0),Size=UDim2.new(1,-262,1,0),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=entry.Name,TextSize=12,TextColor3=owned and C.Text or C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},row)
local pill=new("Frame",{
Size=UDim2.fromOffset(64,16),Position=UDim2.new(1,-218,0.5,-8),
BackgroundColor3=rc,BackgroundTransparency=0.82,BorderSizePixel=0,
},row)
corner(pill,8);stroke(pill,rc,1,0.35)
new("TextLabel",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text=entry.Rarity,TextSize=9,TextColor3=rc,
},pill)
local countText=owned and("×"..entry.Count)or"—"
local countColor=owned and(entry.Count>1 and C.Good or C.SubText)or C.Stroke
new("TextLabel",{
Size=UDim2.fromOffset(28,16),Position=UDim2.new(1,-148,0.5,-8),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,
Text=countText,TextSize=10,TextColor3=countColor,
},row)
local sMinus=new("TextButton",{
Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-114,0.5,-10),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="−",TextSize=13,TextColor3=C.Text,
},row)
corner(sMinus,4);stroke(sMinus,C.Stroke,1,0.5)
local valueBox=new("TextBox",{
Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-90,0.5,-10),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(currentVal),
TextSize=11,TextColor3=isOverridden and C.Accent or C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},row)
corner(valueBox,4);stroke(valueBox,isOverridden and C.Accent or C.Stroke,1,0.5)
local sPlus=new("TextButton",{
Size=UDim2.fromOffset(20,20),Position=UDim2.new(1,-48,0.5,-10),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="+",TextSize=13,TextColor3=C.Text,
},row)
corner(sPlus,4);stroke(sPlus,C.Stroke,1,0.5)
local resetBtn=new("TextButton",{
Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-24,0.5,-9),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="↻",TextSize=11,TextColor3=C.Warn,
Visible=isOverridden,
},row)
corner(resetBtn,4);stroke(resetBtn,C.Warn,1,0.5)
local function paint(nv,overridden)
valueBox.Text=tostring(nv)
valueBox.TextColor3=overridden and C.Accent or C.Text
valueBox.UIStroke.Color=overridden and C.Accent or C.Stroke
resetBtn.Visible=overridden
end
local function setOverride(nv)
nv=math.max(1,math.floor(nv))
ATValues.overrides[entry.Name]=nv
paint(nv,true)
scheduleRerender()
end
sMinus.Activated:Connect(function()setOverride((tonumber(valueBox.Text)or currentVal)-1)end)
sPlus.Activated:Connect(function()setOverride((tonumber(valueBox.Text)or currentVal)+1)end)
valueBox.FocusLost:Connect(function()
local n=tonumber(valueBox.Text)
if not n then paint(currentVal,isOverridden);return end
setOverride(n)
end)
resetBtn.Activated:Connect(function()
ATValues.overrides[entry.Name]=nil
paint(getUnitValue(entry.Name,entry.Rarity),false)
scheduleRerender()
end)
row.MouseEnter:Connect(function()
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.RowHov}):Play()
end)
row.MouseLeave:Connect(function()
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.Row}):Play()
end)
end
renderValueUnits=function()
for _,c in ipairs(vMainScroll:GetChildren())do
if c:IsA("Frame")or c:IsA("TextLabel")then c:Destroy()end
end
local order=0
order=order+1
makeSectionHeader(vMainScroll,"MY INVENTORY",order)
local invShown=0
for _,e in ipairs(grouped)do
if not(ATValues.allEnabled or ATValues.filters[e.Rarity])then continue end
order=order+1;invShown=invShown+1
makeValueRow(e,order)
end
if invShown==0 then
order=order+1
local msg="No owned units match current filters"
if not replicaFetched then msg="Loading inventory…"
elseif#grouped==0 then msg="You don't own any units yet"end
makeEmptyNotice(vMainScroll,msg,order)
end
order=order+1
makeSpacer(vMainScroll,order)
local allUnits=buildAllUnits()
order=order+1
makeSectionHeader(vMainScroll,"ALL UNITS (GAME-WIDE)",order)
local allShown=0
for _,e in ipairs(allUnits)do
if not(ATValues.allEnabled or ATValues.filters[e.Rarity])then continue end
order=order+1;allShown=allShown+1
makeValueRow(e,order)
end
if allShown==0 then
order=order+1
makeEmptyNotice(vMainScroll,"No units match current filters",order)
end
local totalOwned,uniqueOwned=0,0
for _,e in ipairs(grouped)do
totalOwned=totalOwned+e.Count
uniqueOwned=uniqueOwned+1
end
vStatusLbl.Text=("Owned: %d unit%s · %d unique | Game: %d units")
:format(totalOwned,totalOwned==1 and""or"s",uniqueOwned,#allUnits)
end
print("[AT] ✓ Value Adjusting page ready")
local ATFinding={offers={},wanted={},bulkRules={}}
_G.AutoTradeFinding=ATFinding
local renderOfferItems
local renderWantItems
local renderBulkRules
local renderFindingUnits
local findingPage=new("Frame",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false,
},content)
local fStatusBar=new("Frame",{
Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,22),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},findingPage)
corner(fStatusBar,6);stroke(fStatusBar,C.Stroke,1,0.4)
local fStatusLbl=new("TextLabel",{
Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-16,1,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
Text="Offers: 0 • Wanted: 0 • Bulk: 0",
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},fStatusBar)
local fTabBar=new("Frame",{
Position=UDim2.fromOffset(12,36),Size=UDim2.new(1,-24,0,26),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},findingPage)
corner(fTabBar,6);stroke(fTabBar,C.Stroke,1,0.4)
local fTabUnits=new("TextButton",{
Size=UDim2.new(0.5,-3,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundColor3=C.Accent2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Units",TextSize=11,TextColor3=C.Text,
},fTabBar)
corner(fTabUnits,4)
local fTabBulk=new("TextButton",{
Size=UDim2.new(0.5,-3,1,-4),Position=UDim2.new(0.5,1,0,2),
BackgroundColor3=C.Panel,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Bulk Rules (0)",TextSize=11,TextColor3=C.SubText,
},fTabBar)
corner(fTabBulk,4)
local unitsView=new("Frame",{
Position=UDim2.fromOffset(0,66),Size=UDim2.new(1,0,1,-66),
BackgroundTransparency=1,Visible=true,
},findingPage)
local bulkView=new("Frame",{
Position=UDim2.fromOffset(0,66),Size=UDim2.new(1,0,1,-66),
BackgroundTransparency=1,Visible=false,
},findingPage)
local function setFindingTab(tab)
if tab=="units"then
unitsView.Visible=true
bulkView.Visible=false
fTabUnits.BackgroundColor3=C.Accent2
fTabUnits.TextColor3=C.Text
fTabBulk.BackgroundColor3=C.Panel
fTabBulk.TextColor3=C.SubText
else
unitsView.Visible=false
bulkView.Visible=true
fTabUnits.BackgroundColor3=C.Panel
fTabUnits.TextColor3=C.SubText
fTabBulk.BackgroundColor3=C.Accent2
fTabBulk.TextColor3=C.Text
end
end
fTabUnits.Activated:Connect(function()setFindingTab("units")end)
fTabBulk.Activated:Connect(function()setFindingTab("bulk")end)
local function makeListHeader(parent,title,clearFn,ypos)
local h=new("Frame",{
Position=UDim2.fromOffset(12,ypos),Size=UDim2.new(1,-24,0,18),
BackgroundTransparency=1,
},parent)
new("TextLabel",{
Size=UDim2.new(1,-190,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text=title,TextSize=11,TextColor3=C.Accent,
TextXAlignment=Enum.TextXAlignment.Left,
},h)
new("TextLabel",{
Position=UDim2.new(1,-186,0,0),Size=UDim2.fromOffset(128,18),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
Text="tap row = on/off · qty · 💎",TextSize=8,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Right,
},h)
local cb=new("TextButton",{
Size=UDim2.fromOffset(52,18),Position=UDim2.new(1,-52,0,0),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamSemibold,Text="Clear",TextSize=10,TextColor3=C.SubText,
},h)
corner(cb,4);stroke(cb,C.Stroke,1,0.5)
cb.MouseEnter:Connect(function()
TweenService:Create(cb,TweenInfo.new(0.1),{BackgroundColor3=C.Bad,TextColor3=C.Text}):Play()
end)
cb.MouseLeave:Connect(function()
TweenService:Create(cb,TweenInfo.new(0.1),{BackgroundColor3=C.Panel2,TextColor3=C.SubText}):Play()
end)
cb.Activated:Connect(clearFn)
return h
end
local function clearOffers()
for k in pairs(ATFinding.offers)do ATFinding.offers[k]=nil end
if renderFindingUnits then renderFindingUnits()end
end
local function clearWanted()
for k in pairs(ATFinding.wanted)do ATFinding.wanted[k]=nil end
if renderFindingUnits then renderFindingUnits()end
end
makeListHeader(unitsView,"MY OFFER LIST (what I give)",clearOffers,0)
local fOfferBg=new("Frame",{
Position=UDim2.fromOffset(12,20),Size=UDim2.new(1,-24,0,140),
BackgroundColor3=C.Panel,BorderSizePixel=0,ClipsDescendants=true,
},unitsView)
corner(fOfferBg,10);stroke(fOfferBg,C.Stroke,1,0.4)
local fOfferScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(5,5),Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},fOfferBg)
new("UIListLayout",{
Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical,
},fOfferScroll)
makeListHeader(unitsView,"WANTED UNITS LIST (what they give)",clearWanted,168)
local fWantedBg=new("Frame",{
Position=UDim2.fromOffset(12,188),Size=UDim2.new(1,-24,1,-200),
BackgroundColor3=C.Panel,BorderSizePixel=0,ClipsDescendants=true,
},unitsView)
corner(fWantedBg,10);stroke(fWantedBg,C.Stroke,1,0.4)
local fWantedScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(5,5),Size=UDim2.new(1,-10,1,-10),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},fWantedBg)
new("UIListLayout",{
Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical,
},fWantedScroll)
local function makeFindingRow(scrollFrame,entry,kind,order)
local rc=RARITY_COLORS[entry.Rarity]or C.SubText
local store=(kind=="offers")and ATFinding.offers or ATFinding.wanted
local selected=store[entry.Name]~=nil
local startQty=selected and store[entry.Name].qty or 1
local startGems=selected and store[entry.Name].gems or 0
local row=new("Frame",{
Size=UDim2.new(1,0,0,34),
BackgroundColor3=selected and C.Accent2:Lerp(C.Row,0.7)or C.Row,
BorderSizePixel=0,LayoutOrder=order,
},scrollFrame)
corner(row,6)
local rStroke=stroke(row,selected and C.Accent or C.Stroke,1,selected and 0 or 0.5)
local toggleBtn=new("TextButton",{
Size=UDim2.new(1,-150,1,0),BackgroundTransparency=1,Text="",ZIndex=2,
},row)
local bar=new("Frame",{
Size=UDim2.fromOffset(3,18),Position=UDim2.new(0,4,0.5,-9),
BackgroundColor3=rc,BorderSizePixel=0,
},toggleBtn)
corner(bar,1.5)
local iconF=new("Frame",{
Size=UDim2.fromOffset(20,20),Position=UDim2.new(0,10,0.5,-10),
BackgroundColor3=C.BG,BorderSizePixel=0,
},toggleBtn)
corner(iconF,4);stroke(iconF,rc,1,0.5)
if entry.Icon then
new("ImageLabel",{
Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundTransparency=1,Image=entry.Icon,ScaleType=Enum.ScaleType.Fit,
},iconF)
end
new("TextLabel",{
Position=UDim2.fromOffset(36,0),Size=UDim2.new(1,-98,1,0),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=entry.Name,TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},toggleBtn)
local pill=new("Frame",{
Size=UDim2.fromOffset(54,13),Position=UDim2.new(1,-54,0.5,-6.5),
BackgroundColor3=rc,BackgroundTransparency=0.82,BorderSizePixel=0,
},toggleBtn)
corner(pill,7);stroke(pill,rc,1,0.35)
new("TextLabel",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text=entry.Rarity,TextSize=8,TextColor3=rc,
},pill)
local qtyMinus=new("TextButton",{
Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-142,0.5,-9),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="−",TextSize=12,TextColor3=C.Text,ZIndex=3,
},row)
corner(qtyMinus,4);stroke(qtyMinus,C.Stroke,1,0.5)
local qtyBox=new("TextBox",{
Size=UDim2.fromOffset(22,18),Position=UDim2.new(1,-122,0.5,-9),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(startQty),
TextSize=10,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Center,
ClearTextOnFocus=false,ZIndex=3,
},row)
corner(qtyBox,3);stroke(qtyBox,C.Stroke,1,0.5)
local qtyPlus=new("TextButton",{
Size=UDim2.fromOffset(18,18),Position=UDim2.new(1,-100,0.5,-9),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="+",TextSize=12,TextColor3=C.Text,ZIndex=3,
},row)
corner(qtyPlus,4);stroke(qtyPlus,C.Stroke,1,0.5)
local gemBox=new("TextBox",{
Size=UDim2.fromOffset(34,18),Position=UDim2.new(1,-58,0.5,-9),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(startGems),
PlaceholderText="💎",PlaceholderColor3=C.SubText,
TextSize=9,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Center,
ClearTextOnFocus=false,ZIndex=3,
},row)
corner(gemBox,4);stroke(gemBox,C.Stroke,1,0.5)
local checkBg=new("Frame",{
Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-20,0.5,-7),
BackgroundColor3=selected and C.Accent or C.Panel2,BorderSizePixel=0,ZIndex=3,
},row)
corner(checkBg,3)
local checkStroke=stroke(checkBg,selected and C.Accent or C.Stroke,1,selected and 0 or 0.4)
local checkMark=new("TextLabel",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="✓",TextSize=10,TextColor3=C.BG,
Visible=selected,ZIndex=4,
},checkBg)
local function paint()
local s=store[entry.Name]~=nil
rStroke.Color=s and C.Accent or C.Stroke
rStroke.Transparency=s and 0 or 0.5
row.BackgroundColor3=s and C.Accent2:Lerp(C.Row,0.7)or C.Row
checkBg.BackgroundColor3=s and C.Accent or C.Panel2
checkStroke.Color=s and C.Accent or C.Stroke
checkStroke.Transparency=s and 0 or 0.4
checkMark.Visible=s and true or false
local ctl=s and C.Text or C.SubText
qtyBox.TextColor3=ctl;gemBox.TextColor3=ctl
qtyMinus.TextColor3=ctl;qtyPlus.TextColor3=ctl
qtyBox.UIStroke.Transparency=s and 0.2 or 0.6
gemBox.UIStroke.Transparency=s and 0.2 or 0.6
end
local function ensureSel()
if not store[entry.Name]then
store[entry.Name]={
qty=math.max(1,math.floor(tonumber(qtyBox.Text)or 1)),
gems=math.max(0,math.floor(tonumber(gemBox.Text)or 0)),
}
paint()
updateFindingStatus()
end
return store[entry.Name]
end
toggleBtn.Activated:Connect(function()
if store[entry.Name]then
store[entry.Name]=nil
else
store[entry.Name]={qty=1,gems=0}
end
qtyBox.Text=store[entry.Name]and tostring(store[entry.Name].qty)or"1"
gemBox.Text=store[entry.Name]and tostring(store[entry.Name].gems)or"0"
paint()
updateFindingStatus()
end)
qtyMinus.Activated:Connect(function()
local e=ensureSel()
e.qty=math.max(1,e.qty-1)
qtyBox.Text=tostring(e.qty)
updateFindingStatus()
end)
qtyPlus.Activated:Connect(function()
local e=ensureSel()
e.qty=math.min(999,e.qty+1)
qtyBox.Text=tostring(e.qty)
updateFindingStatus()
end)
qtyBox.FocusLost:Connect(function()
local n=tonumber(qtyBox.Text)
if not n then qtyBox.Text=tostring(store[entry.Name]and store[entry.Name].qty or 1);return end
local e=ensureSel()
e.qty=math.clamp(math.floor(n),1,999)
qtyBox.Text=tostring(e.qty)
updateFindingStatus()
end)
gemBox.FocusLost:Connect(function()
local n=tonumber(gemBox.Text)
if not n then gemBox.Text=tostring(store[entry.Name]and store[entry.Name].gems or 0);return end
local e=ensureSel()
e.gems=math.max(0,math.floor(n))
gemBox.Text=tostring(e.gems)
updateFindingStatus()
end)
row.MouseEnter:Connect(function()
if store[entry.Name]==nil then
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.RowHov}):Play()
end
end)
row.MouseLeave:Connect(function()
if store[entry.Name]==nil then
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.Row}):Play()
end
end)
end
local bulkScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(12,0),
Size=UDim2.new(1,-24,1,-68),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},bulkView)
new("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},bulkScroll)
local addRuleBtn=new("TextButton",{
Position=UDim2.new(0,12,1,-56),
Size=UDim2.new(1,-24,0,44),
BackgroundColor3=C.Accent2,
BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="+ ADD BULK RULE",TextSize=13,TextColor3=C.Text,
},bulkView)
corner(addRuleBtn,10);stroke(addRuleBtn,C.Accent,1.5,0)
addRuleBtn.MouseEnter:Connect(function()
TweenService:Create(addRuleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent}):Play()
end)
addRuleBtn.MouseLeave:Connect(function()
TweenService:Create(addRuleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent2}):Play()
end)
local bulkModal=new("Frame",{
Name="BulkModal",
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
Visible=false,
ZIndex=5000,
},gui)
local bulkCatcher=new("TextButton",{
Size=UDim2.fromScale(1,1),
BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.6,
BorderSizePixel=0,
Text="",AutoButtonColor=false,
ZIndex=5000,
},bulkModal)
local bulkPanel=new("TextButton",{
Size=UDim2.fromOffset(400,560),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundColor3=C.BG,
BorderSizePixel=0,
Text="",AutoButtonColor=false,
ZIndex=5001,
},bulkModal)
corner(bulkPanel,14);stroke(bulkPanel,C.Accent,1.5,0)
local bulkScale=new("UIScale",{Scale=1},bulkPanel)
local function updateBulkScale()
local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
if not vp then return end
local s=math.min(vp.X*0.9/400,vp.Y*0.9/560,1)
s=math.max(s,0.55)
bulkScale.Scale=s
end
updateBulkScale()
if workspace.CurrentCamera then
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateBulkScale)
end
local function closeBulkModal()
bulkModal.Visible=false
end
bulkCatcher.Activated:Connect(closeBulkModal)
local bHeader=new("Frame",{
Size=UDim2.new(1,0,0,44),BackgroundColor3=C.Panel,BorderSizePixel=0,ZIndex=5002,
},bulkPanel)
corner(bHeader,14)
new("Frame",{
Position=UDim2.new(0,0,1,-14),Size=UDim2.new(1,0,0,14),
BackgroundColor3=C.Panel,BorderSizePixel=0,ZIndex=5002,
},bHeader)
new("TextLabel",{
Position=UDim2.fromOffset(16,0),Size=UDim2.new(1,-56,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="ADD BULK RULE",
TextSize=13,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5002,
},bHeader)
local bClose=new("TextButton",{
Size=UDim2.fromOffset(28,28),Position=UDim2.new(1,-36,0.5,-14),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="✕",TextSize=12,TextColor3=C.SubText,ZIndex=5002,
},bHeader)
corner(bClose,6)
bClose.MouseEnter:Connect(function()
TweenService:Create(bClose,TweenInfo.new(0.1),{BackgroundColor3=C.Bad,TextColor3=C.Text}):Play()
end)
bClose.MouseLeave:Connect(function()
TweenService:Create(bClose,TweenInfo.new(0.1),{BackgroundColor3=C.Panel2,TextColor3=C.SubText}):Play()
end)
bClose.Activated:Connect(closeBulkModal)
local bContent=new("Frame",{
Position=UDim2.fromOffset(0,44),Size=UDim2.new(1,0,1,-44),
BackgroundTransparency=1,ZIndex=5002,
},bulkPanel)
local bulkState={
offerType="unit",offerValue=nil,offerQty=1,offerGems=0,
wantType="rarity",wantValue=nil,wantQty=10,wantGems=0,
}
local previewLbl=new("TextLabel",{
Position=UDim2.fromOffset(16,348),Size=UDim2.new(1,-32,0,44),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
Font=Enum.Font.Gotham,Text="",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
TextWrapped=true,ZIndex=5002,
},bContent)
corner(previewLbl,6);stroke(previewLbl,C.Stroke,1,0.5)
padding(previewLbl,8,4)
local function sidePreviewText(t,v,q,g)
local s=(t=="unit"and v or("Any "..v)).." ×"..q
if(g or 0)>0 then s=s.."  +"..g.."💎"end
return s
end
local function updatePreview()
local offTxt="Nothing selected"
if bulkState.offerValue then
offTxt=sidePreviewText(bulkState.offerType,bulkState.offerValue,bulkState.offerQty,bulkState.offerGems)
end
local wantTxt="Nothing selected"
if bulkState.wantValue then
wantTxt=sidePreviewText(bulkState.wantType,bulkState.wantValue,bulkState.wantQty,bulkState.wantGems)
end
previewLbl.Text="PREVIEW:\nOffer  "..offTxt.."\nWant   "..wantTxt
end
local function makeTypeToggle(parent,initial,onChange)
local container=new("Frame",{
Size=UDim2.fromOffset(140,22),BackgroundColor3=C.Panel2,BorderSizePixel=0,ZIndex=5002,
},parent)
corner(container,6)
local unitBtn=new("TextButton",{
Size=UDim2.new(0.5,-2,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundColor3=C.Accent2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Unit",TextSize=10,TextColor3=C.Text,ZIndex=5003,
},container)
corner(unitBtn,4)
local rarityBtn=new("TextButton",{
Size=UDim2.new(0.5,-2,1,-4),Position=UDim2.new(0.5,0,0,2),
BackgroundColor3=C.Panel,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Rarity",TextSize=10,TextColor3=C.SubText,ZIndex=5003,
},container)
corner(rarityBtn,4)
local value=initial
local function setValue(v,silent)
value=v
if v=="unit"then
unitBtn.BackgroundColor3=C.Accent2;unitBtn.TextColor3=C.Text
rarityBtn.BackgroundColor3=C.Panel;rarityBtn.TextColor3=C.SubText
else
unitBtn.BackgroundColor3=C.Panel;unitBtn.TextColor3=C.SubText
rarityBtn.BackgroundColor3=C.Accent2;rarityBtn.TextColor3=C.Text
end
if onChange and not silent then onChange(v)end
end
unitBtn.Activated:Connect(function()setValue("unit")end)
rarityBtn.Activated:Connect(function()setValue("rarity")end)
return{
frame=container,
getValue=function()return value end,
setValue=function(v)setValue(v,true)end,
}
end
local function makeQtyStepper(parent,initial,onChange)
local container=new("Frame",{
Size=UDim2.fromOffset(120,24),BackgroundColor3=C.Panel2,BorderSizePixel=0,ZIndex=5002,
},parent)
corner(container,6)
local minusBtn=new("TextButton",{
Size=UDim2.fromOffset(26,24),Position=UDim2.fromOffset(0,0),
BackgroundColor3=C.Panel,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="−",TextSize=15,TextColor3=C.Text,ZIndex=5003,
},container)
corner(minusBtn,5)
local qtyBox=new("TextBox",{
Position=UDim2.fromOffset(26,0),Size=UDim2.fromOffset(68,24),BackgroundTransparency=1,
BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(initial),TextSize=12,
TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,ZIndex=5003,
},container)
local plusBtn=new("TextButton",{
Position=UDim2.fromOffset(94,0),Size=UDim2.fromOffset(26,24),
BackgroundColor3=C.Panel,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="+",TextSize=15,TextColor3=C.Text,ZIndex=5003,
},container)
corner(plusBtn,5)
local value=initial
local function setValue(v,silent)
v=math.max(1,math.floor(v))
value=v
qtyBox.Text=tostring(v)
if onChange and not silent then onChange(v)end
end
minusBtn.Activated:Connect(function()setValue(value-1)end)
plusBtn.Activated:Connect(function()setValue(value+1)end)
qtyBox.FocusLost:Connect(function()
local n=tonumber(qtyBox.Text)
if n then setValue(n)else qtyBox.Text=tostring(value)end
end)
return{
frame=container,
getValue=function()return value end,
setValue=function(v)setValue(v,true)end,
}
end
local function makeGemsBox(parent,ypos,onChange)
new("TextLabel",{
Position=UDim2.fromOffset(188,ypos),Size=UDim2.fromOffset(46,24),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text="Gems:",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5003,
},parent)
local box=new("TextBox",{
Position=UDim2.fromOffset(236,ypos),Size=UDim2.fromOffset(70,24),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="0",TextSize=12,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,ZIndex=5003,
PlaceholderText="💎",PlaceholderColor3=C.SubText,
},parent)
corner(box,5);stroke(box,C.Stroke,1,0.5)
box.FocusLost:Connect(function()
local n=tonumber(box.Text)
if not n then box.Text="0";if onChange then onChange(0)end;return end
n=math.max(0,math.floor(n))
box.Text=tostring(n)
if onChange then onChange(n)end
end)
return box
end
local function makeItemScroll(parent,height)
return new("ScrollingFrame",{
Size=UDim2.new(1,0,0,height or 78),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
ScrollBarThickness=3,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.4,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.X,
ScrollingDirection=Enum.ScrollingDirection.X,
ZIndex=5002,
},parent)
end
local function populateUnitItems(scroll,units,selected,onSelect)
for _,c in ipairs(scroll:GetChildren())do
if c:IsA("TextButton")then c:Destroy()end
end
if#units==0 then
new("TextLabel",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="No units available",
TextSize=11,TextColor3=C.SubText,ZIndex=5003,
},scroll)
return
end
local cardW,cardH,gap=72,74,6
for i,entry in ipairs(units)do
local rc=RARITY_COLORS[entry.Rarity]or C.SubText
local sel=(entry.Name==selected)
local card=new("TextButton",{
Size=UDim2.fromOffset(cardW,cardH),
Position=UDim2.fromOffset(6+(i-1)*(cardW+gap),2),
BackgroundColor3=sel and C.Accent2 or C.Row,
BorderSizePixel=0,AutoButtonColor=false,Text="",
ZIndex=5003,
},scroll)
corner(card,8)
stroke(card,sel and C.Accent or rc,sel and 2 or 1,sel and 0 or 0.5)
if entry.Icon then
new("ImageLabel",{
Size=UDim2.fromOffset(42,42),Position=UDim2.new(0.5,0,0,4),
AnchorPoint=Vector2.new(0.5,0),BackgroundTransparency=1,
Image=entry.Icon,ScaleType=Enum.ScaleType.Fit,ZIndex=5003,
},card)
end
new("TextLabel",{
Size=UDim2.new(1,-4,0,22),Position=UDim2.new(0,2,1,-24),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
Text=entry.Name,TextSize=8,TextColor3=C.Text,
TextTruncate=Enum.TextTruncate.AtEnd,TextWrapped=true,
TextXAlignment=Enum.TextXAlignment.Center,ZIndex=5003,
},card)
card.Activated:Connect(function()onSelect(entry.Name)end)
end
end
local function populateRarityItems(scroll,selected,onSelect)
for _,c in ipairs(scroll:GetChildren())do
if c:IsA("TextButton")or c:IsA("TextLabel")then c:Destroy()end
end
local cardW,cardH,gap=84,44,6
for i,r in ipairs(RARITY_LIST)do
local rc=RARITY_COLORS[r]or C.SubText
local sel=(r==selected)
local card=new("TextButton",{
Size=UDim2.fromOffset(cardW,cardH),
Position=UDim2.fromOffset(6+(i-1)*(cardW+gap),(78-cardH)/2),
BackgroundColor3=sel and rc or C.Row,
BorderSizePixel=0,AutoButtonColor=false,Text="",
ZIndex=5003,
},scroll)
corner(card,8)
stroke(card,rc,sel and 2 or 1,sel and 0 or 0.5)
new("TextLabel",{
Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text=r,TextSize=11,
TextColor3=sel and C.BG or rc,ZIndex=5003,
},card)
card.Activated:Connect(function()onSelect(r)end)
end
end
new("TextLabel",{
Position=UDim2.fromOffset(16,8),Size=UDim2.new(1,-32,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="MY OFFER",TextSize=11,TextColor3=C.Accent,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5002,
},bContent)
local bOfferToggle=makeTypeToggle(bContent,"unit",function(v)
bulkState.offerType=v
bulkState.offerValue=nil
if renderOfferItems then renderOfferItems()end
updatePreview()
end)
bOfferToggle.frame.Position=UDim2.fromOffset(16,26)
local bOfferScroll=makeItemScroll(bContent,78)
bOfferScroll.Position=UDim2.fromOffset(16,54)
new("TextLabel",{
Position=UDim2.fromOffset(16,140),Size=UDim2.fromOffset(36,24),BackgroundTransparency=1,
Font=Enum.Font.GothamSemibold,Text="Qty:",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5002,
},bContent)
local bOfferQty=makeQtyStepper(bContent,1,function(v)
bulkState.offerQty=v
updatePreview()
end)
bOfferQty.frame.Position=UDim2.fromOffset(56,140)
local bOfferGemsBox=makeGemsBox(bContent,140,function(v)
bulkState.offerGems=v
updatePreview()
end)
new("TextLabel",{
Position=UDim2.fromOffset(16,174),Size=UDim2.new(1,-32,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="I WANT",TextSize=11,TextColor3=C.Accent,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5002,
},bContent)
local bWantToggle=makeTypeToggle(bContent,"rarity",function(v)
bulkState.wantType=v
bulkState.wantValue=nil
if renderWantItems then renderWantItems()end
updatePreview()
end)
bWantToggle.frame.Position=UDim2.fromOffset(16,192)
local bWantScroll=makeItemScroll(bContent,78)
bWantScroll.Position=UDim2.fromOffset(16,220)
new("TextLabel",{
Position=UDim2.fromOffset(16,306),Size=UDim2.fromOffset(36,24),BackgroundTransparency=1,
Font=Enum.Font.GothamSemibold,Text="Qty:",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5002,
},bContent)
local bWantQty=makeQtyStepper(bContent,10,function(v)
bulkState.wantQty=v
updatePreview()
end)
bWantQty.frame.Position=UDim2.fromOffset(56,306)
local bWantGemsBox=makeGemsBox(bContent,306,function(v)
bulkState.wantGems=v
updatePreview()
end)
local bCancel=new("TextButton",{
Position=UDim2.new(0.5,-110,1,-52),Size=UDim2.fromOffset(100,40),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Cancel",TextSize=12,TextColor3=C.Text,ZIndex=5003,
},bContent)
corner(bCancel,8);stroke(bCancel,C.Stroke,1,0.5)
bCancel.MouseEnter:Connect(function()
TweenService:Create(bCancel,TweenInfo.new(0.1),{BackgroundColor3=C.RowHov}):Play()
end)
bCancel.MouseLeave:Connect(function()
TweenService:Create(bCancel,TweenInfo.new(0.1),{BackgroundColor3=C.Panel2}):Play()
end)
bCancel.Activated:Connect(closeBulkModal)
local bSave=new("TextButton",{
Position=UDim2.new(0.5,10,1,-52),Size=UDim2.fromOffset(100,40),
BackgroundColor3=C.Good,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="Save Rule",TextSize=12,TextColor3=C.BG,ZIndex=5003,
},bContent)
corner(bSave,8);stroke(bSave,C.Good,1,0)
bSave.MouseEnter:Connect(function()
TweenService:Create(bSave,TweenInfo.new(0.1),{BackgroundColor3=C.Good:Lerp(Color3.new(1,1,1),0.15)}):Play()
end)
bSave.MouseLeave:Connect(function()
TweenService:Create(bSave,TweenInfo.new(0.1),{BackgroundColor3=C.Good}):Play()
end)
function renderOfferItems()
if bulkState.offerType=="unit"then
populateUnitItems(bOfferScroll,grouped,bulkState.offerValue,function(name)
bulkState.offerValue=name
renderOfferItems()
updatePreview()
end)
else
populateRarityItems(bOfferScroll,bulkState.offerValue,function(r)
bulkState.offerValue=r
renderOfferItems()
updatePreview()
end)
end
end
function renderWantItems()
if bulkState.wantType=="unit"then
populateUnitItems(bWantScroll,buildAllUnits(),bulkState.wantValue,function(name)
bulkState.wantValue=name
renderWantItems()
updatePreview()
end)
else
populateRarityItems(bWantScroll,bulkState.wantValue,function(r)
bulkState.wantValue=r
renderWantItems()
updatePreview()
end)
end
end
local function openBulkModal()
bulkState.offerType="unit"
bulkState.offerValue=nil
bulkState.offerQty=1
bulkState.offerGems=0
bulkState.wantType="rarity"
bulkState.wantValue=nil
bulkState.wantQty=10
bulkState.wantGems=0
bOfferToggle.setValue("unit")
bWantToggle.setValue("rarity")
bOfferQty.setValue(1)
bWantQty.setValue(10)
bOfferGemsBox.Text="0"
bWantGemsBox.Text="0"
renderOfferItems()
renderWantItems()
updatePreview()
bulkModal.Visible=true
end
bSave.Activated:Connect(function()
if not bulkState.offerValue then
local oldText=bSave.Text
bSave.Text="Pick offer!"
bSave.BackgroundColor3=C.Bad
task.delay(1.2,function()
if bSave and bSave.Parent then
bSave.Text=oldText
bSave.BackgroundColor3=C.Good
end
end)
return
end
if not bulkState.wantValue then
local oldText=bSave.Text
bSave.Text="Pick want!"
bSave.BackgroundColor3=C.Bad
task.delay(1.2,function()
if bSave and bSave.Parent then
bSave.Text=oldText
bSave.BackgroundColor3=C.Good
end
end)
return
end
local offerGems=math.max(0,math.floor(tonumber(bOfferGemsBox.Text)or 0))
local wantGems=math.max(0,math.floor(tonumber(bWantGemsBox.Text)or 0))
bulkState.offerGems=offerGems
bulkState.wantGems=wantGems
table.insert(ATFinding.bulkRules,{
offer={
type=bulkState.offerType,
value=bulkState.offerValue,
qty=bulkState.offerQty,
gems=offerGems,
},
want={
type=bulkState.wantType,
value=bulkState.wantValue,
qty=bulkState.wantQty,
gems=wantGems,
},
})
print("[AT] Bulk rule added — total: "..#ATFinding.bulkRules)
closeBulkModal()
updateFindingStatus()
if renderBulkRules then renderBulkRules()end
end)
local function describeSide(side)
if side.type=="unit"then
local unitEntry
for _,e in ipairs(buildAllUnits())do
if e.Name==side.value then unitEntry=e;break end
end
return{
kind="unit",
name=side.value,
rarity=unitEntry and unitEntry.Rarity or"Basic",
icon=unitEntry and unitEntry.Icon or nil,
qty=side.qty,
gems=side.gems or 0,
}
else
return{
kind="rarity",
rarity=side.value,
qty=side.qty,
gems=side.gems or 0,
}
end
end
function renderBulkRules()
for _,c in ipairs(bulkScroll:GetChildren())do
if c:IsA("Frame")or c:IsA("TextLabel")or c:IsA("TextButton")then c:Destroy()end
end
if#ATFinding.bulkRules==0 then
local empty=new("Frame",{
Size=UDim2.new(1,0,0,150),BackgroundColor3=C.Row,BorderSizePixel=0,LayoutOrder=1,
},bulkScroll)
corner(empty,8)
new("TextLabel",{
Position=UDim2.new(0,0,0.22,0),Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="No bulk rules yet",
TextSize=13,TextColor3=C.Text,
},empty)
new("TextLabel",{
Position=UDim2.new(0,0,0.22,22),Size=UDim2.new(1,0,0,80),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="Tap + ADD BULK RULE below to trade your specific units for any N\nunits of a chosen rarity (or vice versa), with optional gems on either side.\n\nExample: My Titan Speakerman ×1 → Any Epic ×10 +10💎",
TextSize=10,TextColor3=C.SubText,TextWrapped=true,
},empty)
return
end
for i,rule in ipairs(ATFinding.bulkRules)do
local row=new("Frame",{
Size=UDim2.new(1,0,0,58),BackgroundColor3=C.Row,BorderSizePixel=0,LayoutOrder=i,
},bulkScroll)
corner(row,8);stroke(row,C.Stroke,1,0.4)
local off=describeSide(rule.offer)
local offerColor=RARITY_COLORS[off.rarity]or C.SubText
local offerX=8
if off.kind=="unit"and off.icon then
local iconF=new("Frame",{
Size=UDim2.fromOffset(32,32),Position=UDim2.fromOffset(offerX,13),
BackgroundColor3=C.BG,BorderSizePixel=0,
},row)
corner(iconF,4);stroke(iconF,offerColor,1,0.5)
new("ImageLabel",{
Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundTransparency=1,Image=off.icon,ScaleType=Enum.ScaleType.Fit,
},iconF)
offerX=offerX+40
end
local offerText=(off.kind=="unit"and off.name or("Any "..off.rarity)).." ×"..off.qty
if(off.gems or 0)>0 then offerText=offerText.." +"..off.gems.."💎"end
new("TextLabel",{
Position=UDim2.fromOffset(offerX,6),Size=UDim2.new(0.45,-offerX,0,22),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=offerText,
TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},row)
new("TextLabel",{
Position=UDim2.fromOffset(offerX,30),Size=UDim2.new(0.45,-offerX,0,16),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
Text="My Offer",
TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},row)
new("TextLabel",{
Position=UDim2.fromOffset(200,0),Size=UDim2.fromOffset(28,58),
BackgroundTransparency=1,Font=Enum.Font.GothamBold,
Text="→",TextSize=16,TextColor3=C.Accent,
},row)
local want=describeSide(rule.want)
local wantColor=RARITY_COLORS[want.rarity]or C.SubText
local wantX=236
local wantText=(want.kind=="unit"and want.name or("Any "..want.rarity)).." ×"..want.qty
if(want.gems or 0)>0 then wantText=wantText.." +"..want.gems.."💎"end
new("TextLabel",{
Position=UDim2.fromOffset(wantX,6),Size=UDim2.new(1,-wantX-40,0,22),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=wantText,
TextSize=11,TextColor3=wantColor,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},row)
new("TextLabel",{
Position=UDim2.fromOffset(wantX,30),Size=UDim2.new(1,-wantX-40,0,16),
BackgroundTransparency=1,Font=Enum.Font.Gotham,
Text="I Want",
TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},row)
local delBtn=new("TextButton",{
Size=UDim2.fromOffset(24,24),Position=UDim2.new(1,-32,0.5,-12),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="✕",TextSize=11,TextColor3=C.SubText,
},row)
corner(delBtn,4);stroke(delBtn,C.Stroke,1,0.5)
delBtn.MouseEnter:Connect(function()
TweenService:Create(delBtn,TweenInfo.new(0.1),{BackgroundColor3=C.Bad,TextColor3=C.Text}):Play()
end)
delBtn.MouseLeave:Connect(function()
TweenService:Create(delBtn,TweenInfo.new(0.1),{BackgroundColor3=C.Panel2,TextColor3=C.SubText}):Play()
end)
delBtn.Activated:Connect(function()
table.remove(ATFinding.bulkRules,i)
updateFindingStatus()
renderBulkRules()
end)
end
end
addRuleBtn.Activated:Connect(openBulkModal)
function updateFindingStatus()
local o,w=0,0
for _ in pairs(ATFinding.offers)do o=o+1 end
for _ in pairs(ATFinding.wanted)do w=w+1 end
fStatusLbl.Text=("Offers: %d • Wanted: %d • Bulk: %d"):format(o,w,#ATFinding.bulkRules)
fTabBulk.Text=("Bulk Rules (%d)"):format(#ATFinding.bulkRules)
end
function renderFindingUnits()
for _,c in ipairs(fOfferScroll:GetChildren())do
if c:IsA("Frame")or c:IsA("TextLabel")or c:IsA("TextButton")then c:Destroy()end
end
for _,c in ipairs(fWantedScroll:GetChildren())do
if c:IsA("Frame")or c:IsA("TextLabel")or c:IsA("TextButton")then c:Destroy()end
end
local order=0
local offerCount=0
for _,e in ipairs(grouped)do
order=order+1;offerCount=offerCount+1
makeFindingRow(fOfferScroll,e,"offers",order)
end
if offerCount==0 then
local msg="You don't own any units yet"
if not replicaFetched then msg="Loading inventory…"end
makeEmptyNotice(fOfferScroll,msg,1)
end
local allUnits=buildAllUnits()
order=0
for _,e in ipairs(allUnits)do
order=order+1
makeFindingRow(fWantedScroll,e,"wanted",order)
end
if#allUnits==0 then
makeEmptyNotice(fWantedScroll,"No units available in game",1)
end
updateFindingStatus()
if renderBulkRules then renderBulkRules()end
end
updateFindingStatus()
renderBulkRules()
print("[AT] ✓ Finding page ready (Units + Bulk Rules, with gems)")
local ATTrades={
autoSend={
enabled=false,delay=10,loopToken=0,lastSentAt={},
lastTargetName=nil,currentCyclePos=0,currentCycleTotal=0,
},
autoAccept={
enabled=false,delayTime=0.2,pollingRate=0.03,lastClickTime=0,
totalAccepted=0,lastTargetName=nil,
},
tradeAuto={
acceptEnabled=false,acceptDelay=0.2,
declineEnabled=false,declineDelay=0.2,
waitTime=10,
session={active=false,startedAt=0,declined=false,
lastAcceptSig=nil,lastAcceptAt=0,lastDeclineAt=0},
},
}
_G.AutoTradeTrades=ATTrades
local tradesPage=new("Frame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false},content)
local tStatusBar=new("Frame",{
Position=UDim2.fromOffset(12,8),Size=UDim2.new(1,-24,0,24),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
},tradesPage)
corner(tStatusBar,6);stroke(tStatusBar,C.Stroke,1,0.4)
local tStatusDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(10,9),
BackgroundColor3=C.SubText,BorderSizePixel=0,
},tStatusBar)
corner(tStatusDot,3)
local tStatusLbl=new("TextLabel",{
Position=UDim2.fromOffset(22,0),Size=UDim2.new(1,-28,1,0),
BackgroundTransparency=1,Font=Enum.Font.Gotham,Text="● Ready — both features off",
TextSize=11,TextColor3=C.SubText,TextXAlignment=Enum.TextXAlignment.Left,
},tStatusBar)
local tScroll=new("ScrollingFrame",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,1,-50),
BackgroundTransparency=1,BorderSizePixel=0,
ScrollBarThickness=4,ScrollBarImageColor3=C.Accent,ScrollBarImageTransparency=0.5,
CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,
ScrollingDirection=Enum.ScrollingDirection.Y,
},tradesPage)
new("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,FillDirection=Enum.FillDirection.Vertical},tScroll)
local sendCard=new("Frame",{
Size=UDim2.new(1,-6,0,320),BackgroundColor3=C.Panel,BorderSizePixel=0,LayoutOrder=1,
},tScroll)
corner(sendCard,10);stroke(sendCard,C.Stroke,1,0.4)
local sendTitleHolder=new("Frame",{
Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,18),BackgroundTransparency=1,
},sendCard)
local sendTitleDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,6),
BackgroundColor3=C.Accent,BorderSizePixel=0,
},sendTitleHolder)
corner(sendTitleDot,3)
new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="AUTO SEND TRADE REQUEST",
TextSize=12,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},sendTitleHolder)
new("TextLabel",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,0,58),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="WHAT IT DOES:\nAutomatically sends a trade request to every other player in this server, one at a time. Continues looping until you turn it off. Use the delay below to control how long the script waits between each request. A longer delay is safer.",
TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
},sendCard)
local sendWarn=new("Frame",{
Position=UDim2.fromOffset(12,102),Size=UDim2.new(1,-24,0,34),
BackgroundColor3=C.Warn,BackgroundTransparency=0.88,BorderSizePixel=0,
},sendCard)
corner(sendWarn,6);stroke(sendWarn,C.Warn,1,0.4)
new("TextLabel",{
Position=UDim2.fromOffset(8,2),Size=UDim2.new(1,-16,1,-4),BackgroundTransparency=1,
Font=Enum.Font.GothamSemibold,
Text="⚠ This does NOT filter by what units other players own. You'll receive trade popups back — you must accept or decline them yourself.",
TextSize=10,TextColor3=C.Warn,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true,
},sendWarn)
new("TextLabel",{
Position=UDim2.fromOffset(12,148),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="DELAY BETWEEN REQUESTS",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},sendCard)
local delayBox
local delaySlider=makeSlider(sendCard,{
width=210,min=2,max=60,value=ATTrades.autoSend.delay,accent=C.Accent,height=22,
onChange=function(v)
ATTrades.autoSend.delay=v
if delayBox then delayBox.Text=tostring(v)end
end,
})
delaySlider.frame.Position=UDim2.fromOffset(12,168)
delayBox=new("TextBox",{
Position=UDim2.fromOffset(232,168),Size=UDim2.fromOffset(48,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text=tostring(ATTrades.autoSend.delay),
TextSize=11,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},sendCard)
corner(delayBox,4);stroke(delayBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(284,168),Size=UDim2.fromOffset(30,22),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="sec",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},sendCard)
delayBox.FocusLost:Connect(function()
local n=tonumber(delayBox.Text)
if not n then delayBox.Text=tostring(ATTrades.autoSend.delay);return end
n=math.clamp(math.floor(n),2,60)
delayBox.Text=tostring(n)
delaySlider.setValue(n)
end)
local sendStateLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,200),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="● DISABLED",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},sendCard)
local sendToggleBtn=new("TextButton",{
Position=UDim2.fromOffset(12,222),Size=UDim2.new(1,-24,0,42),
BackgroundColor3=C.Accent2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="▶ START AUTO SEND",TextSize=13,TextColor3=C.Text,
},sendCard)
corner(sendToggleBtn,10);stroke(sendToggleBtn,C.Accent,1.5,0)
local sendProgressLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,270),Size=UDim2.new(1,-24,0,14),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},sendCard)
local acceptCard=new("Frame",{
Size=UDim2.new(1,-6,0,290),BackgroundColor3=C.Panel,BorderSizePixel=0,LayoutOrder=2,
},tScroll)
corner(acceptCard,10);stroke(acceptCard,C.Stroke,1,0.4)
local accTitleHolder=new("Frame",{
Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,18),BackgroundTransparency=1,
},acceptCard)
local accTitleDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,6),
BackgroundColor3=C.Good,BorderSizePixel=0,
},accTitleHolder)
corner(accTitleDot,3)
new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="AUTO ACCEPT REQUEST (POPUP)",
TextSize=12,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},accTitleHolder)
new("TextLabel",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,0,52),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="WHAT IT DOES:\nWatches the incoming trade REQUEST popup (the yes/no window that appears when someone sends you a trade) and instantly clicks 'Yes' for you. The trade window itself still opens — items are confirmed by the requirement matcher below.",
TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
},acceptCard)
local accWarn=new("Frame",{
Position=UDim2.fromOffset(12,96),Size=UDim2.new(1,-24,0,34),
BackgroundColor3=C.Warn,BackgroundTransparency=0.88,BorderSizePixel=0,
},acceptCard)
corner(accWarn,6);stroke(accWarn,C.Warn,1,0.4)
new("TextLabel",{
Position=UDim2.fromOffset(8,2),Size=UDim2.new(1,-16,1,-4),BackgroundTransparency=1,
Font=Enum.Font.GothamSemibold,
Text="⚠ Any player who sends a trade request while this is ON gets the request auto-accepted. Also auto-clicks OK on generic info popups.",
TextSize=10,TextColor3=C.Warn,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true,
},accWarn)
new("TextLabel",{
Position=UDim2.fromOffset(12,136),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="CLICK DELAY (seconds)",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard)
local accDelayBox=new("TextBox",{
Position=UDim2.fromOffset(180,134),Size=UDim2.fromOffset(60,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="0.2",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},acceptCard)
corner(accDelayBox,4);stroke(accDelayBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(244,136),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="min 0.05 · max 5.0",TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard)
new("TextLabel",{
Position=UDim2.fromOffset(12,164),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="POLLING RATE (seconds)",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard)
local accPollBox=new("TextBox",{
Position=UDim2.fromOffset(180,162),Size=UDim2.fromOffset(60,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="0.03",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},acceptCard)
corner(accPollBox,4);stroke(accPollBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(244,164),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="min 0.01 · max 1.0",TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard)
local accStateLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,194),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="● DISABLED",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},acceptCard)
local accToggleBtn=new("TextButton",{
Position=UDim2.fromOffset(12,214),Size=UDim2.new(1,-24,0,42),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="▶ ENABLE REQUEST ACCEPT",TextSize=13,TextColor3=C.Text,
},acceptCard)
corner(accToggleBtn,10);stroke(accToggleBtn,C.Stroke,1.5,0)
local accInfoLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,262),Size=UDim2.new(1,-24,0,14),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},acceptCard)
local function isInTrade()
local ok,visible=pcall(function()return PlayerGui.Main.Main.Trade.Visible end)
return ok and visible
end
local function isPopupActive()
local ok,visible=pcall(function()return PlayerGui.Main.NotificationFrame.Visible end)
return ok and visible
end
local function updateTradesUI()
local as=ATTrades.autoSend
if as.enabled then
sendToggleBtn.Text="■ STOP AUTO SEND"
sendToggleBtn.BackgroundColor3=C.Bad
sendToggleBtn.UIStroke.Color=C.Bad
sendStateLbl.Text="● RUNNING"
sendStateLbl.TextColor3=C.Good
else
sendToggleBtn.Text="▶ START AUTO SEND"
sendToggleBtn.BackgroundColor3=C.Accent2
sendToggleBtn.UIStroke.Color=C.Accent
sendStateLbl.Text="● DISABLED"
sendStateLbl.TextColor3=C.SubText
sendProgressLbl.Text=""
if ATTrades.autoAccept and ATTrades.autoAccept.enabled then
tStatusDot.BackgroundColor3=C.Good
tStatusLbl.Text="● Idle — request-accept ON, auto-send OFF"
tStatusLbl.TextColor3=C.Good
else
tStatusDot.BackgroundColor3=C.SubText
tStatusLbl.Text="● Ready — features off"
tStatusLbl.TextColor3=C.SubText
end
end
end
local function stopAutoSend()
ATTrades.autoSend.enabled=false
ATTrades.autoSend.loopToken=ATTrades.autoSend.loopToken+1
updateTradesUI()
end
local function startAutoSend()
if ATTrades.autoSend.enabled then return end
if not Network then tStatusLbl.Text="● ERROR: Network missing";return end
local tradeRemote=Network.Get and Network.Get("TradeSendRequest")
if not tradeRemote then tStatusLbl.Text="● ERROR: Trade system not ready";return end
ATTrades.autoSend.enabled=true
ATTrades.autoSend.loopToken=ATTrades.autoSend.loopToken+1
local myToken=ATTrades.autoSend.loopToken
updateTradesUI()
task.spawn(function()
local function waitOrCancel(seconds)
local start=os.clock()
while(os.clock()-start)<seconds do
if not ATTrades.autoSend.enabled or ATTrades.autoSend.loopToken~=myToken or not LocalPlayer.Parent then
return false
end
task.wait(0.1)
end
return true
end
while ATTrades.autoSend.enabled and ATTrades.autoSend.loopToken==myToken do
if not LocalPlayer.Parent then return end
local others={}
for _,p in ipairs(Players:GetPlayers())do
if p~=LocalPlayer then table.insert(others,p)end
end
ATTrades.autoSend.currentCycleTotal=#others
ATTrades.autoSend.currentCyclePos=0
if#others==0 then
tStatusDot.BackgroundColor3=C.Warn
tStatusLbl.Text="● WAITING — no other players in server"
sendProgressLbl.Text="Looking for players…"
if not waitOrCancel(ATTrades.autoSend.delay)then return end
else
for i,target in ipairs(others)do
if not ATTrades.autoSend.enabled or ATTrades.autoSend.loopToken~=myToken then return end
if not target.Parent then continue end
ATTrades.autoSend.currentCyclePos=i
if isInTrade()or isPopupActive()then
tStatusDot.BackgroundColor3=C.Warn
tStatusLbl.Text="● PAUSED — dealing with a trade"
sendProgressLbl.Text="Cycle "..i.."/"..#others.." paused"
if not waitOrCancel(1.5)then return end
continue
end
local now=os.clock()
local cooldown=math.max(5,ATTrades.autoSend.delay)
local last=ATTrades.autoSend.lastSentAt[target.Name]or 0
if(now-last)<cooldown then continue end
local ok,err=pcall(function()tradeRemote:FireServer(target)end)
if ok then
ATTrades.autoSend.lastSentAt[target.Name]=os.clock()
ATTrades.autoSend.lastTargetName=target.Name
tStatusDot.BackgroundColor3=C.Good
tStatusLbl.Text=("● RUNNING — sent to %s (%d/%d)"):format(
target.DisplayName or target.Name,i,#others)
sendProgressLbl.Text=("Last: %s @ %s"):format(target.Name,os.date("%H:%M:%S"))
else
tStatusLbl.Text=("● ERROR — failed on %s"):format(target.Name)
warn(("[AT] FireServer failed: %s"):format(tostring(err)))
end
if not waitOrCancel(ATTrades.autoSend.delay)then return end
end
if ATTrades.autoSend.enabled and ATTrades.autoSend.loopToken==myToken then
tStatusDot.BackgroundColor3=C.Warn
tStatusLbl.Text="● WAITING — cycle complete, restarting soon"
if not waitOrCancel(1)then return end
end
end
end
end)
end
sendToggleBtn.Activated:Connect(function()
if ATTrades.autoSend.enabled then stopAutoSend()else startAutoSend()end
end)
sendToggleBtn.MouseEnter:Connect(function()
if not ATTrades.autoSend.enabled then
TweenService:Create(sendToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent}):Play()
else
TweenService:Create(sendToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Bad:Lerp(Color3.new(1,1,1),0.15)}):Play()
end
end)
sendToggleBtn.MouseLeave:Connect(function()
if not ATTrades.autoSend.enabled then
TweenService:Create(sendToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent2}):Play()
else
TweenService:Create(sendToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Bad}):Play()
end
end)
local function flashButton(obj)
if not obj then return end
local oldColor=obj.BackgroundColor3
obj.BackgroundColor3=Color3.fromRGB(0,255,0)
task.delay(0.3,function()
if obj and obj.Parent then obj.BackgroundColor3=oldColor end
end)
end
local function getTradeAcceptRemote()
local ml=ReplicatedStorage:FindFirstChild("ModuleLoader")
if not ml then return nil end
local sh=ml:FindFirstChild("Shared")
if not sh then return nil end
local net=sh:FindFirstChild("Network")
if not net then return nil end
local rf=net:FindFirstChild("RemoteFunction")
if not rf then return nil end
return rf:FindFirstChild("TradeAcceptRequest")
end
local function getNotification()
local m=PlayerGui:FindFirstChild("Main")
if not m then return nil end
local nf=m:FindFirstChild("NotificationFrame")
if not nf then return nil end
return nf:FindFirstChild("BigNotification")
end
local function clickButton(obj)
if not obj then return end
flashButton(obj)
pcall(function()
if getconnections then
for _,c in pairs(getconnections(obj.Activated))do
if c.Enabled then task.spawn(function()c:Fire()end)end
end
end
end)
pcall(function()if firesignal then firesignal(obj.Activated)end end)
pcall(function()obj:Activate()end)
local lbl=obj:FindFirstChild("TextLabel")
if lbl then
pcall(function()
if firesignal then
local input=Instance.new("InputObject")
input.UserInputType=Enum.UserInputType.MouseButton1
input.UserInputState=Enum.UserInputState.Begin
firesignal(lbl.InputBegan,input)
input.UserInputState=Enum.UserInputState.End
firesignal(lbl.InputEnded,input)
end
end)
end
end
local updateAcceptUI
local function tryClickAll()
local aa=ATTrades.autoAccept
local notif=getNotification()
if not(notif and notif.Parent and notif.Visible~=false)then return false end
if os.clock()-aa.lastClickTime<aa.delayTime then return false end
local btns=notif:FindFirstChild("Buttons")
if not btns then return false end
local yesBtn=btns:FindFirstChild("YesButton")
local okBtn=btns:FindFirstChild("OkButton")
local msgLabel=notif:FindFirstChild("NotificationMessage")
local isTrade=msgLabel and string.find(msgLabel.Text,"sent you a trade request!",1,true)
if isTrade and yesBtn and yesBtn.Visible then
aa.lastClickTime=os.clock()
aa.totalAccepted=aa.totalAccepted+1
local name=string.match(msgLabel.Text,"^(.-) sent you a trade request!")
aa.lastTargetName=name
clickButton(yesBtn)
local sender=name and Players:FindFirstChild(name)
local TradeAccept=getTradeAcceptRemote()
if sender and TradeAccept then
task.spawn(function()
pcall(function()TradeAccept:InvokeServer(sender)end)
end)
end
if updateAcceptUI then updateAcceptUI()end
return true
elseif okBtn and okBtn.Visible then
aa.lastClickTime=os.clock()
clickButton(okBtn)
return true
end
return false
end
updateAcceptUI=function()
local aa=ATTrades.autoAccept
if aa.enabled then
accToggleBtn.Text="■ DISABLE REQUEST ACCEPT"
accToggleBtn.BackgroundColor3=C.Good
accToggleBtn.UIStroke.Color=C.Good
local info
if aa.lastTargetName then
info=("● ENABLED — %d accepted (last: %s)"):format(aa.totalAccepted,aa.lastTargetName)
else
info=("● ENABLED — %d accepted"):format(aa.totalAccepted)
end
accStateLbl.Text=info
accStateLbl.TextColor3=C.Good
else
accToggleBtn.Text="▶ ENABLE REQUEST ACCEPT"
accToggleBtn.BackgroundColor3=C.Panel2
accToggleBtn.UIStroke.Color=C.Stroke
if aa.totalAccepted>0 then
accStateLbl.Text=("● DISABLED — %d accepted so far"):format(aa.totalAccepted)
else
accStateLbl.Text="● DISABLED"
end
accStateLbl.TextColor3=C.SubText
end
accInfoLbl.Text=("delay %ss · poll %ss"):format(aa.delayTime,aa.pollingRate)
if not ATTrades.autoSend.enabled then
if aa.enabled then
tStatusDot.BackgroundColor3=C.Good
tStatusLbl.Text="● Idle — request-accept ON, auto-send OFF"
tStatusLbl.TextColor3=C.Good
else
tStatusDot.BackgroundColor3=C.SubText
tStatusLbl.Text="● Ready — features off"
tStatusLbl.TextColor3=C.SubText
end
end
end
accDelayBox.FocusLost:Connect(function()
local n=tonumber(accDelayBox.Text)
if not n then accDelayBox.Text=tostring(ATTrades.autoAccept.delayTime);return end
n=math.clamp(n,0.05,5.0)
n=math.floor(n*100)/100
ATTrades.autoAccept.delayTime=n
accDelayBox.Text=tostring(n)
updateAcceptUI()
end)
accPollBox.FocusLost:Connect(function()
local n=tonumber(accPollBox.Text)
if not n then accPollBox.Text=tostring(ATTrades.autoAccept.pollingRate);return end
n=math.clamp(n,0.01,1.0)
n=math.floor(n*100)/100
ATTrades.autoAccept.pollingRate=n
accPollBox.Text=tostring(n)
updateAcceptUI()
end)
accToggleBtn.Activated:Connect(function()
ATTrades.autoAccept.enabled=not ATTrades.autoAccept.enabled
updateAcceptUI()
end)
accToggleBtn.MouseEnter:Connect(function()
if ATTrades.autoAccept.enabled then
TweenService:Create(accToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Good:Lerp(Color3.new(1,1,1),0.15)}):Play()
else
TweenService:Create(accToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.RowHov}):Play()
end
end)
accToggleBtn.MouseLeave:Connect(function()
if ATTrades.autoAccept.enabled then
TweenService:Create(accToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Good}):Play()
else
TweenService:Create(accToggleBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Panel2}):Play()
end
end)
task.spawn(function()
while true do
local aa=ATTrades.autoAccept
if aa.enabled then
tryClickAll()
task.wait(aa.pollingRate)
else
task.wait(0.15)
end
end
end)
updateTradesUI()
updateAcceptUI()
print("[AT] ✓ Trading page ready (send + request accept)")
local function getTradeFrame()
local m1=PlayerGui:FindFirstChild("Main")
if not m1 then return nil end
local m2=m1:FindFirstChild("Main")
if not m2 then return nil end
local trade=m2:FindFirstChild("Trade")
if not trade or not trade.Visible then return nil end
return trade:FindFirstChild("TradeFrame")
end
local function getTradeMenu()
local f=getTradeFrame()
return f and f:FindFirstChild("TradeMenu")
end
local function getTradeActions()
local f=getTradeFrame()
return f and f:FindFirstChild("TradeActions")
end
local function unitRarityOf(name)
if Config and Config.Towers and Config.Towers[name]and Config.Towers[name].Rarity then
return Config.Towers[name].Rarity
end
if shared and shared.Modules and shared.Modules.Config and shared.Modules.Config.Towers then
local cfg=shared.Modules.Config.Towers[name]
if cfg and cfg.Rarity then return cfg.Rarity end
end
return"Basic"
end
local function readGemAmount(gemFolder,isYourSide)
if not gemFolder then return 0 end
if isYourSide then
local editable=gemFolder:FindFirstChild("EditableAmount")
if editable then
local gemAmount=editable:FindFirstChild("GemAmount")
if gemAmount then
local box=gemAmount:FindFirstChildOfClass("TextBox")
if box then return tonumber(box.Text)or 0 end
end
end
else
local gemAmountFrame=gemFolder:FindFirstChild("GemAmount")
if gemAmountFrame then
local lbl=gemAmountFrame:FindFirstChild("GemAmount")
or gemAmountFrame:FindFirstChildOfClass("TextLabel")
if lbl then return tonumber(lbl.Text)or 0 end
end
end
for _,desc in ipairs(gemFolder:GetDescendants())do
if desc:IsA("TextBox")or desc:IsA("TextLabel")then
local n=tonumber(desc.Text)
if n then return n end
end
end
return 0
end
local function getTradeUnitsFromMenu(menu)
local function processItems(itemsFolder)
local itemDict,uniqueOrder={},{}
if itemsFolder then
for _,item in ipairs(itemsFolder:GetChildren())do
if item:IsA("Frame")and item:FindFirstChild("TroopsFrame")then
local troopsFrame=item.TroopsFrame
local name=item:GetAttribute("OriginalName")
or(troopsFrame:FindFirstChild("Price")and troopsFrame.Price.Text)
or"Unknown"
local image=(troopsFrame:FindFirstChild("TroopIcon")
and troopsFrame.TroopIcon.Image)or""
if not itemDict[name]then
itemDict[name]={count=0,image=image}
table.insert(uniqueOrder,name)
end
itemDict[name].count=itemDict[name].count+1
end
end
end
local displayItems={}
for _,baseName in ipairs(uniqueOrder)do
local data=itemDict[baseName]
table.insert(displayItems,{
name=baseName,count=data.count,image=data.image,
rarity=unitRarityOf(baseName),
})
end
return displayItems
end
local yourFolder=menu:FindFirstChild("YourItemsOffer")
local theirFolder=menu:FindFirstChild("PlayerItemsOffer")
return processItems(yourFolder and yourFolder:FindFirstChild("Items")),
processItems(theirFolder and theirFolder:FindFirstChild("Items"))
end
local function getTradeSnapshot(menu)
menu=menu or getTradeMenu()
if not menu then return nil end
local yourUnits,theirUnits=getTradeUnitsFromMenu(menu)
local yourGems=readGemAmount(menu:FindFirstChild("YourGems"),true)
local theirGems=readGemAmount(menu:FindFirstChild("PlayerGems"),false)
return{
yourUnits=yourUnits,theirUnits=theirUnits,
yourGems=yourGems,theirGems=theirGems,
}
end
local function unitCountIn(units,name)
for _,u in ipairs(units)do
if u.name==name then return u.count end
end
return 0
end
local function rarityCountIn(units,rarity)
local n=0
for _,u in ipairs(units)do
if u.rarity==rarity then n=n+u.count end
end
return n
end
local function mySideMatchesOffers(snap)
local totalGems=0
local any=false
for name,req in pairs(ATFinding.offers)do
any=true
totalGems=totalGems+(req.gems or 0)
local have=unitCountIn(snap.yourUnits,name)
if have~=req.qty then
return false,("your side: %s ×%d expected, %d added"):format(name,req.qty,have)
end
end
if any then
for _,u in ipairs(snap.yourUnits)do
if not ATFinding.offers[u.name]then
return false,"your side: unexpected unit "..u.name
end
end
if snap.yourGems>totalGems then
return false,("your side: gems exceed your offer (%d > %d)"):format(snap.yourGems,totalGems)
end
end
return true,""
end
local function ruleMatches(snap,rule)
local offer,want=rule.offer,rule.want
local myTotal=0
for _,u in ipairs(snap.yourUnits)do
myTotal=myTotal+u.count
if offer.type=="unit"then
if u.name~=offer.value then return false end
else
if u.rarity~=offer.value then return false end
end
end
if offer.type=="unit"then
if unitCountIn(snap.yourUnits,offer.value)~=offer.qty then return false end
else
if myTotal~=offer.qty then return false end
end
if snap.yourGems>(offer.gems or 0)then return false end
if want.type=="unit"then
if unitCountIn(snap.theirUnits,want.value)<want.qty then return false end
else
if rarityCountIn(snap.theirUnits,want.value)<want.qty then return false end
end
if snap.theirGems<(want.gems or 0)then return false end
return true
end
local function evaluateTrade(snap)
local hasOffers=next(ATFinding.offers)~=nil
local hasWanted=next(ATFinding.wanted)~=nil
local hasRules=#ATFinding.bulkRules>0
if not(hasOffers or hasWanted or hasRules)then
return true,"no requirements configured — accepting any offer"
end
if hasRules then
local anyRule=false
for _,rule in ipairs(ATFinding.bulkRules)do
if ruleMatches(snap,rule)then anyRule=true;break end
end
if not anyRule then return false,"no bulk rule matches this trade"end
end
if hasOffers then
local ok,reason=mySideMatchesOffers(snap)
if not ok then return false,reason end
end
if hasWanted then
local wantGems=0
for name,req in pairs(ATFinding.wanted)do
wantGems=wantGems+(req.gems or 0)
local c=unitCountIn(snap.theirUnits,name)
if c<req.qty then
return false,("missing %s ×%d (they added %d)"):format(name,req.qty,c)
end
end
if snap.theirGems<wantGems then
return false,("missing gems: need %d, they added %d"):format(wantGems,snap.theirGems)
end
end
return true,"all requirements matched"
end
local function tradeSignature(snap)
local parts={tostring(snap.yourGems),tostring(snap.theirGems)}
for _,u in ipairs(snap.yourUnits)do table.insert(parts,"Y"..u.name.."="..u.count)end
for _,u in ipairs(snap.theirUnits)do table.insert(parts,"T"..u.name.."="..u.count)end
return table.concat(parts,",")
end
local acceptCard2=new("Frame",{
Size=UDim2.new(1,-6,0,240),BackgroundColor3=C.Panel,BorderSizePixel=0,LayoutOrder=3,
},tScroll)
corner(acceptCard2,10);stroke(acceptCard2,C.Stroke,1,0.4)
local taAccTitleHolder=new("Frame",{
Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,18),BackgroundTransparency=1,
},acceptCard2)
local taAccTitleDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,6),
BackgroundColor3=C.Good,BorderSizePixel=0,
},taAccTitleHolder)
corner(taAccTitleDot,3)
new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="AUTO ACCEPT TRADE (REQUIREMENT MATCHED)",
TextSize=12,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},taAccTitleHolder)
new("TextLabel",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,0,58),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="WHAT IT DOES:\nClicks Accept / Confirm inside the open trade window ONLY when the other player's units, quantities, rarities and gems satisfy your FINDING and Bulk requirements — and your side stays within your Offer list. The offer is re-verified instantly before every click.",
TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
},acceptCard2)
new("TextLabel",{
Position=UDim2.fromOffset(12,104),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="CLICK DELAY (seconds)",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard2)
local taAcceptDelayBox=new("TextBox",{
Position=UDim2.fromOffset(180,102),Size=UDim2.fromOffset(60,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="0.2",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},acceptCard2)
corner(taAcceptDelayBox,4);stroke(taAcceptDelayBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(246,104),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="min 0.05 · max 5.0",TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},acceptCard2)
local taAcceptStateLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,130),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="● DISABLED",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},acceptCard2)
local taAcceptBtn=new("TextButton",{
Position=UDim2.fromOffset(12,152),Size=UDim2.new(1,-24,0,42),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="▶ ENABLE AUTO ACCEPT",TextSize=13,TextColor3=C.Text,
},acceptCard2)
corner(taAcceptBtn,10);stroke(taAcceptBtn,C.Stroke,1.5,0)
new("TextLabel",{
Position=UDim2.fromOffset(12,200),Size=UDim2.new(1,-24,0,14),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="Accept and Decline can never fire in the same trade.",
TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},acceptCard2)
local declineCard=new("Frame",{
Size=UDim2.new(1,-6,0,220),BackgroundColor3=C.Panel,BorderSizePixel=0,LayoutOrder=4,
},tScroll)
corner(declineCard,10);stroke(declineCard,C.Stroke,1,0.4)
local decTitleHolder=new("Frame",{
Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,18),BackgroundTransparency=1,
},declineCard)
local decTitleDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,6),
BackgroundColor3=C.Bad,BorderSizePixel=0,
},decTitleHolder)
corner(decTitleDot,3)
new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="AUTO DECLINE TRADE",
TextSize=12,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},decTitleHolder)
new("TextLabel",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,0,52),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="WHAT IT DOES:\nDeclines the trade when the offer does not match your requirements AND the requirement-wait timer below has expired. It never fires while the other player may still be adding units or gems, and never during an accept action.",
TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
},declineCard)
new("TextLabel",{
Position=UDim2.fromOffset(12,98),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="CLICK DELAY (seconds)",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},declineCard)
local taDeclineDelayBox=new("TextBox",{
Position=UDim2.fromOffset(180,96),Size=UDim2.fromOffset(60,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="0.2",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},declineCard)
corner(taDeclineDelayBox,4);stroke(taDeclineDelayBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(246,98),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="min 0.05 · max 5.0",TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},declineCard)
local taDeclineStateLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,124),Size=UDim2.new(1,-24,0,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="● DISABLED",TextSize=11,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},declineCard)
local taDeclineBtn=new("TextButton",{
Position=UDim2.fromOffset(12,146),Size=UDim2.new(1,-24,0,42),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamBold,Text="▶ ENABLE AUTO DECLINE",TextSize=13,TextColor3=C.Text,
},declineCard)
corner(taDeclineBtn,10);stroke(taDeclineBtn,C.Stroke,1.5,0)
new("TextLabel",{
Position=UDim2.fromOffset(12,194),Size=UDim2.new(1,-24,0,14),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="The latest offer is re-checked immediately before declining.",
TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},declineCard)
local timerCard=new("Frame",{
Size=UDim2.new(1,-6,0,160),BackgroundColor3=C.Panel,BorderSizePixel=0,LayoutOrder=5,
},tScroll)
corner(timerCard,10);stroke(timerCard,C.Stroke,1,0.4)
local timTitleHolder=new("Frame",{
Position=UDim2.fromOffset(12,12),Size=UDim2.new(1,-24,0,18),BackgroundTransparency=1,
},timerCard)
local timTitleDot=new("Frame",{
Size=UDim2.fromOffset(6,6),Position=UDim2.fromOffset(0,6),
BackgroundColor3=C.Warn,BorderSizePixel=0,
},timTitleHolder)
corner(timTitleDot,3)
new("TextLabel",{
Position=UDim2.fromOffset(14,0),Size=UDim2.new(1,-14,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="REQUIREMENT WAIT TIMER",
TextSize=12,TextColor3=C.Text,TextXAlignment=Enum.TextXAlignment.Left,
},timTitleHolder)
new("TextLabel",{
Position=UDim2.fromOffset(12,38),Size=UDim2.new(1,-24,0,44),BackgroundTransparency=1,
Font=Enum.Font.Gotham,
Text="How long to wait for the other player to add the required units/gems before Auto Decline may fire. Resets every new trade. While waiting, the offer is checked continuously and Auto Accept fires on a match.",
TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextWrapped=true,
},timerCard)
new("TextLabel",{
Position=UDim2.fromOffset(12,90),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.GothamBold,Text="WAIT TIME (seconds)",TextSize=10,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,
},timerCard)
local taWaitBox=new("TextBox",{
Position=UDim2.fromOffset(180,88),Size=UDim2.fromOffset(60,22),
BackgroundColor3=C.BG,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="10",TextSize=11,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,
},timerCard)
corner(taWaitBox,4);stroke(taWaitBox,C.Stroke,1,0.5)
new("TextLabel",{
Position=UDim2.fromOffset(246,90),Size=UDim2.fromOffset(160,16),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="min 1 · max 300",TextSize=9,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,
},timerCard)
local taLiveLbl=new("TextLabel",{
Position=UDim2.fromOffset(12,116),Size=UDim2.new(1,-24,0,32),BackgroundTransparency=1,
Font=Enum.Font.Gotham,Text="",TextSize=10,TextColor3=C.SubText,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
TextWrapped=true,TextTruncate=Enum.TextTruncate.AtEnd,
},timerCard)
local fullStateBtn=new("TextButton",{
Size=UDim2.new(1,-6,0,44),BackgroundColor3=C.Accent2,BorderSizePixel=0,
AutoButtonColor=false,LayoutOrder=99,
Font=Enum.Font.GothamBold,Text="▣ FULL STATE — OPEN INSPECTOR",TextSize=13,TextColor3=C.Text,
},tScroll)
corner(fullStateBtn,10);stroke(fullStateBtn,C.Accent,1.5,0)
local function updateTradeAutoUI()
local ta=ATTrades.tradeAuto
if ta.acceptEnabled then
taAcceptBtn.Text="■ DISABLE AUTO ACCEPT"
taAcceptBtn.BackgroundColor3=C.Good
taAcceptBtn.UIStroke.Color=C.Good
taAcceptStateLbl.Text="● ENABLED — verifying offers before every click"
taAcceptStateLbl.TextColor3=C.Good
else
taAcceptBtn.Text="▶ ENABLE AUTO ACCEPT"
taAcceptBtn.BackgroundColor3=C.Panel2
taAcceptBtn.UIStroke.Color=C.Stroke
taAcceptStateLbl.Text="● DISABLED"
taAcceptStateLbl.TextColor3=C.SubText
end
if ta.declineEnabled then
taDeclineBtn.Text="■ DISABLE AUTO DECLINE"
taDeclineBtn.BackgroundColor3=C.Bad
taDeclineBtn.UIStroke.Color=C.Bad
taDeclineStateLbl.Text="● ENABLED — fires only after the wait timer"
taDeclineStateLbl.TextColor3=C.Warn
else
taDeclineBtn.Text="▶ ENABLE AUTO DECLINE"
taDeclineBtn.BackgroundColor3=C.Panel2
taDeclineBtn.UIStroke.Color=C.Stroke
taDeclineStateLbl.Text="● DISABLED"
taDeclineStateLbl.TextColor3=C.SubText
end
end
taAcceptDelayBox.FocusLost:Connect(function()
local n=tonumber(taAcceptDelayBox.Text)
if not n then taAcceptDelayBox.Text=tostring(ATTrades.tradeAuto.acceptDelay);return end
n=math.clamp(n,0.05,5.0)
n=math.floor(n*100)/100
ATTrades.tradeAuto.acceptDelay=n
taAcceptDelayBox.Text=tostring(n)
end)
taDeclineDelayBox.FocusLost:Connect(function()
local n=tonumber(taDeclineDelayBox.Text)
if not n then taDeclineDelayBox.Text=tostring(ATTrades.tradeAuto.declineDelay);return end
n=math.clamp(n,0.05,5.0)
n=math.floor(n*100)/100
ATTrades.tradeAuto.declineDelay=n
taDeclineDelayBox.Text=tostring(n)
end)
taWaitBox.FocusLost:Connect(function()
local n=tonumber(taWaitBox.Text)
if not n then taWaitBox.Text=tostring(ATTrades.tradeAuto.waitTime);return end
n=math.clamp(math.floor(n),1,300)
ATTrades.tradeAuto.waitTime=n
taWaitBox.Text=tostring(n)
end)
taAcceptBtn.Activated:Connect(function()
ATTrades.tradeAuto.acceptEnabled=not ATTrades.tradeAuto.acceptEnabled
updateTradeAutoUI()
end)
taDeclineBtn.Activated:Connect(function()
ATTrades.tradeAuto.declineEnabled=not ATTrades.tradeAuto.declineEnabled
updateTradeAutoUI()
end)
taAcceptBtn.MouseEnter:Connect(function()
if not ATTrades.tradeAuto.acceptEnabled then
TweenService:Create(taAcceptBtn,TweenInfo.new(0.12),{BackgroundColor3=C.RowHov}):Play()
end
end)
taAcceptBtn.MouseLeave:Connect(function()
if not ATTrades.tradeAuto.acceptEnabled then
TweenService:Create(taAcceptBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Panel2}):Play()
end
end)
taDeclineBtn.MouseEnter:Connect(function()
if not ATTrades.tradeAuto.declineEnabled then
TweenService:Create(taDeclineBtn,TweenInfo.new(0.12),{BackgroundColor3=C.RowHov}):Play()
end
end)
taDeclineBtn.MouseLeave:Connect(function()
if not ATTrades.tradeAuto.declineEnabled then
TweenService:Create(taDeclineBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Panel2}):Play()
end
end)
local taStatusLastAt=0
task.spawn(function()
while true do
local ta=ATTrades.tradeAuto
local menu=getTradeMenu()
if menu then
local s=ta.session
if not s.active then
s.active=true
s.startedAt=os.clock()
s.declined=false
s.lastAcceptSig=nil
s.lastAcceptAt=0
s.lastDeclineAt=0
end
local snap=getTradeSnapshot(menu)
local matched,reason=evaluateTrade(snap)
local elapsed=os.clock()-s.startedAt
local actions=getTradeActions()
local now=os.clock()
if matched and ta.acceptEnabled and not s.declined and actions then
local acceptBtn=actions:FindFirstChild("Accept")
if acceptBtn and acceptBtn.Visible then
local lbl=acceptBtn:FindFirstChild("TextLabel")
local text=(lbl and lbl.Text)or""
if text=="Accept"or text=="Confirm"then
local sig=text.."|"..tradeSignature(snap)
if sig~=s.lastAcceptSig and(now-s.lastAcceptAt)>=ta.acceptDelay then
local snap2=getTradeSnapshot()
local matched2=snap2 and(evaluateTrade(snap2))
if matched2 and acceptBtn and acceptBtn.Parent and acceptBtn.Visible then
s.lastAcceptSig=sig
s.lastAcceptAt=os.clock()
clickButton(acceptBtn)
end
end
end
end
elseif(not matched)and ta.declineEnabled and(not s.declined)
and(not s.lastAcceptSig)and elapsed>=ta.waitTime and actions then
if(now-s.lastDeclineAt)>=ta.declineDelay then
local snap2=getTradeSnapshot()
local matched2=snap2 and(evaluateTrade(snap2))
if(not matched2)and(os.clock()-s.startedAt)>=ta.waitTime then
local declineBtn=actions:FindFirstChild("Decline")
if declineBtn and declineBtn.Visible then
s.declined=true
s.lastDeclineAt=os.clock()
clickButton(declineBtn)
end
end
end
end
if(now-taStatusLastAt)>0.25 then
taStatusLastAt=now
if matched then
taLiveLbl.Text=("Trade open %.1fs — ✓ REQUIREMENTS MATCHED%s"):format(
elapsed,
ta.acceptEnabled and" — auto-accept armed"or" (enable Auto Accept to click)")
taLiveLbl.TextColor3=C.Good
else
local remain=math.max(0,ta.waitTime-elapsed)
taLiveLbl.Text=("Trade open %.1fs — ✗ %s | decline in %ds (%s)"):format(
elapsed,reason,math.ceil(remain),
ta.declineEnabled and"armed"or"off")
taLiveLbl.TextColor3=C.Warn
end
end
else
if ta.session.active then ta.session.active=false end
if taLiveLbl.Text~=""then taLiveLbl.Text=""end
end
task.wait(0.03)
end
end)
updateTradeAutoUI()
print("[AT] ✓ Requirement matcher ready (auto accept/decline + wait timer)")
local RarityColors={
["Basic"]=Color3.fromRGB(180,180,180),
["Uncommon"]=Color3.fromRGB(85,255,127),
["Rare"]=Color3.fromRGB(85,170,255),
["Epic"]=Color3.fromRGB(170,85,255),
["Legendary"]=Color3.fromRGB(255,170,0),
["Mythic"]=Color3.fromRGB(255,85,85),
["Godly"]=Color3.fromRGB(0,150,255),
["Exclusive"]=Color3.fromRGB(155,83,255)
}
local function getUnitRarity(unitName)
if shared and shared.Modules and shared.Modules.Config and shared.Modules.Config.Towers then
local config=shared.Modules.Config.Towers[unitName]
if config and config.Rarity then
return config.Rarity
end
end
if Config and Config.Towers and Config.Towers[unitName]and Config.Towers[unitName].Rarity then
return Config.Towers[unitName].Rarity
end
return"Basic"
end
local oldFs=PlayerGui:FindFirstChild("FullStateInspector")
if oldFs then oldFs:Destroy()end
local fsScreenGui=new("ScreenGui",{
Name="FullStateInspector",ResetOnSpawn=false,
ZIndexBehavior=Enum.ZIndexBehavior.Sibling,IgnoreGuiInset=true,
DisplayOrder=2001,Visible=false,
},PlayerGui)
local fsMain=new("Frame",{
Size=UDim2.fromOffset(220,160),
Position=UDim2.new(0.5,-110,0.3,0),
BackgroundColor3=Color3.fromRGB(15,15,18),
BorderSizePixel=0,Active=true,
},fsScreenGui)
corner(fsMain,6)
local fsStroke=stroke(fsMain,Color3.fromRGB(50,50,60),1,0)
local fsTitle=new("TextLabel",{
Size=UDim2.new(1,-20,0,18),BackgroundTransparency=1,
Text="FULL STATE",TextColor3=Color3.fromRGB(200,200,210),
Font=Enum.Font.GothamBold,TextSize=9,
},fsMain)
local fsClose=new("TextButton",{
Size=UDim2.fromOffset(14,14),Position=UDim2.new(1,-16,0,2),
BackgroundTransparency=1,Text="✕",TextColor3=Color3.fromRGB(150,150,160),
Font=Enum.Font.GothamBold,TextSize=8,
},fsMain)
fsClose.Activated:Connect(function()
fsScreenGui.Visible=false
updateFullStateBtn()
end)
local fsStatus=new("TextLabel",{
Size=UDim2.new(1,-12,0,12),Position=UDim2.new(0,6,1,-14),
BackgroundTransparency=1,Text="Waiting...",
TextColor3=Color3.fromRGB(120,120,130),
Font=Enum.Font.Gotham,TextSize=8,TextXAlignment=Enum.TextXAlignment.Left,
},fsMain)
local fsLeftFrame=new("Frame",{
Size=UDim2.new(0.5,-4,1,-34),Position=UDim2.new(0,2,0,20),
BackgroundTransparency=1,
},fsMain)
local fsLeftTitle=new("TextLabel",{
Size=UDim2.new(1,0,0,14),BackgroundColor3=Color3.fromRGB(30,30,35),
BorderSizePixel=0,Text="YOU | 💎 0",
TextColor3=Color3.fromRGB(90,200,255),
Font=Enum.Font.GothamBold,TextSize=8,
},fsLeftFrame)
corner(fsLeftTitle,3)
local fsLeftScroll=new("ScrollingFrame",{
Size=UDim2.new(1,0,1,-16),Position=UDim2.new(0,0,0,16),
BackgroundColor3=Color3.fromRGB(20,20,24),BorderSizePixel=0,
ScrollBarThickness=2,ScrollBarImageColor3=Color3.fromRGB(80,80,90),
AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),
},fsLeftFrame)
corner(fsLeftScroll,3)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},fsLeftScroll)
padding(fsLeftScroll,2,2)
local fsRightFrame=new("Frame",{
Size=UDim2.new(0.5,-4,1,-34),Position=UDim2.new(0.5,2,0,20),
BackgroundTransparency=1,
},fsMain)
local fsRightTitle=new("TextLabel",{
Size=UDim2.new(1,0,0,14),BackgroundColor3=Color3.fromRGB(30,30,35),
BorderSizePixel=0,Text="THEM | 💎 0",
TextColor3=Color3.fromRGB(255,90,90),
Font=Enum.Font.GothamBold,TextSize=8,
},fsRightFrame)
corner(fsRightTitle,3)
local fsRightScroll=new("ScrollingFrame",{
Size=UDim2.new(1,0,1,-16),Position=UDim2.new(0,0,0,16),
BackgroundColor3=Color3.fromRGB(20,20,24),BorderSizePixel=0,
ScrollBarThickness=2,ScrollBarImageColor3=Color3.fromRGB(80,80,90),
AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(0,0,0,0),
},fsRightFrame)
corner(fsRightScroll,3)
new("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},fsRightScroll)
padding(fsRightScroll,2,2)
do
local dragging,dragStart,startPos
fsMain.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=true;dragStart=input.Position;startPos=fsMain.Position
end
end)
fsMain.InputChanged:Connect(function(input)
if dragging and(input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch)then
local delta=input.Position-dragStart
fsMain.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
end)
fsMain.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=false
end
end)
end
local function fsGetTradeMenu()
local m1=PlayerGui:FindFirstChild("Main")
if not m1 then return nil end
local m2=m1:FindFirstChild("Main")
if not m2 then return nil end
local trade=m2:FindFirstChild("Trade")
if not trade or not trade.Visible then return nil end
local frame=trade:FindFirstChild("TradeFrame")
if not frame then return nil end
return frame:FindFirstChild("TradeMenu")
end
local function fsGetGemAmount(gemFolder)
if not gemFolder then return"0"end
if gemFolder.Name=="YourGems"then
local editable=gemFolder:FindFirstChild("EditableAmount")
if editable then
local gemAmount=editable:FindFirstChild("GemAmount")
if gemAmount then
local box=gemAmount:FindFirstChildOfClass("TextBox")
if box then return box.Text end
end
end
elseif gemFolder.Name=="PlayerGems"then
local gemAmountFrame=gemFolder:FindFirstChild("GemAmount")
if gemAmountFrame then
local lbl=gemAmountFrame:FindFirstChild("GemAmount")or gemAmountFrame:FindFirstChildOfClass("TextLabel")
if lbl then return lbl.Text end
end
end
for _,desc in ipairs(gemFolder:GetDescendants())do
if desc:IsA("TextBox")or desc:IsA("TextLabel")then
if tonumber(desc.Text)~=nil or desc.Text==""then
return desc.Text==""and"0"or desc.Text
end
end
end
return"0"
end
local function fsUpdateList(itemsFolder,scrollFrame)
local itemDict={}
local uniqueOrder={}
if itemsFolder then
for _,item in ipairs(itemsFolder:GetChildren())do
if item:IsA("Frame")and item:FindFirstChild("TroopsFrame")then
local troopsFrame=item.TroopsFrame
local name=item:GetAttribute("OriginalName")
or(troopsFrame:FindFirstChild("Price")and troopsFrame.Price.Text)
or"Unknown"
local image=troopsFrame:FindFirstChild("TroopIcon")and troopsFrame.TroopIcon.Image or""
if not itemDict[name]then
itemDict[name]={count=0,image=image}
table.insert(uniqueOrder,name)
end
itemDict[name].count=itemDict[name].count+1
end
end
end
local displayItems={}
for _,baseName in ipairs(uniqueOrder)do
local data=itemDict[baseName]
local rarity=getUnitRarity(baseName)
table.insert(displayItems,{
name=baseName,
count=data.count,
image=data.image,
rarity=rarity,
color=RarityColors[rarity]or RarityColors["Basic"]
})
end
local frames={}
for _,child in ipairs(scrollFrame:GetChildren())do
if child:IsA("Frame")then table.insert(frames,child)end
end
local needsUpdate=(#frames~=#displayItems)
if not needsUpdate then
for i,frame in ipairs(frames)do
if frame:GetAttribute("ItemName")~=(displayItems[i].name..displayItems[i].count..displayItems[i].rarity)then
needsUpdate=true;break
end
end
end
if needsUpdate then
for _,frame in ipairs(frames)do frame:Destroy()end
for i,data in ipairs(displayItems)do
local itemFrame=new("Frame",{
Size=UDim2.new(1,0,0,20),
BackgroundColor3=Color3.fromRGB(30,30,36),
BorderSizePixel=0,LayoutOrder=i,
},scrollFrame)
itemFrame:SetAttribute("ItemName",data.name..data.count..data.rarity)
corner(itemFrame,3)
local gradient=new("UIGradient",{
Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,data.color),
ColorSequenceKeypoint.new(0.3,Color3.fromRGB(30,30,36)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(30,30,36))
}),
},itemFrame)
local itemStroke=stroke(itemFrame,data.color,1,0.6)
local img=new("ImageLabel",{
Size=UDim2.fromOffset(14,14),Position=UDim2.new(0,2,0.5,-7),
BackgroundTransparency=1,
Image=data.image~=""and data.image or"rbxassetid://0",
ScaleType=Enum.ScaleType.Fit,
},itemFrame)
local displayString=data.name
if data.count>1 then
displayString=displayString.." x"..data.count
end
new("TextLabel",{
Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,18,0,0),
BackgroundTransparency=1,
TextColor3=Color3.fromRGB(240,240,240),
Font=Enum.Font.GothamMedium,TextSize=8,
TextXAlignment=Enum.TextXAlignment.Left,
TextTruncate=Enum.TextTruncate.AtEnd,
RichText=true,
Text=string.format("%s <font color='#%02X%02X%02X'>[%s]</font>",
displayString,
data.color.R*255,data.color.G*255,data.color.B*255,
data.rarity),
},itemFrame)
end
end
end
local function fsUpdateTradeUI()
local tradeMenu=fsGetTradeMenu()
if not tradeMenu then
fsStatus.Text="Waiting..."
fsStatus.TextColor3=Color3.fromRGB(120,120,130)
fsLeftTitle.Text="YOU | 💎 0"
fsRightTitle.Text="THEM | 💎 0"
for _,child in ipairs(fsLeftScroll:GetChildren())do if child:IsA("Frame")then child:Destroy()end end
for _,child in ipairs(fsRightScroll:GetChildren())do if child:IsA("Frame")then child:Destroy()end end
return
end
fsStatus.Text="Trade Open"
fsStatus.TextColor3=Color3.fromRGB(90,220,130)
local yourGems=fsGetGemAmount(tradeMenu:FindFirstChild("YourGems"))
local theirGems=fsGetGemAmount(tradeMenu:FindFirstChild("PlayerGems"))
fsLeftTitle.Text="YOU | 💎 "..yourGems
fsRightTitle.Text="THEM | 💎 "..theirGems
local yourItems=tradeMenu:FindFirstChild("YourItemsOffer")and tradeMenu.YourItemsOffer:FindFirstChild("Items")
local theirItems=tradeMenu:FindFirstChild("PlayerItemsOffer")and tradeMenu.PlayerItemsOffer:FindFirstChild("Items")
fsUpdateList(yourItems,fsLeftScroll)
fsUpdateList(theirItems,fsRightScroll)
end
task.spawn(function()
while gui and gui.Parent do
if fsScreenGui.Visible and fsScreenGui.Parent then
pcall(fsUpdateTradeUI)
end
task.wait(0.2)
end
end)
function updateFullStateBtn()
if fsScreenGui.Visible then
fullStateBtn.Text="▣ FULL STATE — CLOSE INSPECTOR"
fullStateBtn.BackgroundColor3=C.Bad
fullStateBtn.UIStroke.Color=C.Bad
else
fullStateBtn.Text="▣ FULL STATE — OPEN INSPECTOR"
fullStateBtn.BackgroundColor3=C.Accent2
fullStateBtn.UIStroke.Color=C.Accent
end
end
fullStateBtn.Activated:Connect(function()
fsScreenGui.Visible=not fsScreenGui.Visible
updateFullStateBtn()
end)
fullStateBtn.MouseEnter:Connect(function()
if not fsScreenGui.Visible then
TweenService:Create(fullStateBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent}):Play()
end
end)
fullStateBtn.MouseLeave:Connect(function()
if not fsScreenGui.Visible then
TweenService:Create(fullStateBtn,TweenInfo.new(0.12),{BackgroundColor3=C.Accent2}):Play()
end
end)
print("[AT] ✓ Full State inspector integrated")
local tabs,activeTab={},nil
local function createTab(id,label,locked)
local btn=new("TextButton",{
Name=id,Size=UDim2.fromOffset(76,26),
BackgroundColor3=C.Panel2,BorderSizePixel=0,AutoButtonColor=false,
Font=Enum.Font.GothamSemibold,Text=label,TextSize=11,
TextColor3=locked and C.SubText or C.Text,
},tabHolder)
corner(btn,6);stroke(btn,locked and C.Stroke or C.Accent,1,locked and 0.4 or 0.2)
local ind=new("Frame",{
Size=UDim2.new(1,-14,0,2),Position=UDim2.new(0,7,1,-3),
BackgroundColor3=C.Accent,BorderSizePixel=0,Visible=false,
},btn)
corner(ind,2)
if not locked then
btn.MouseEnter:Connect(function()
if activeTab~=id then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.RowHov}):Play()end
end)
btn.MouseLeave:Connect(function()
if activeTab~=id then TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=C.Panel2}):Play()end
end)
btn.Activated:Connect(function()
if activeTab==id then return end
activeTab=id
for tid,t in pairs(tabs)do
if t.locked then continue end
local a=(tid==id)
TweenService:Create(t.btn,TweenInfo.new(0.15),{BackgroundColor3=a and C.Accent2 or C.Panel2}):Play()
t.btn.UIStroke.Color=a and C.Accent or C.Stroke
t.btn.UIStroke.Transparency=a and 0 or 0.4
t.ind.Visible=a
end
statePage.Visible=(id=="State")
valuePage.Visible=(id=="Values")
findingPage.Visible=(id=="Finding")
tradesPage.Visible=(id=="Trades")
if id=="Finding"and renderFindingUnits then renderFindingUnits()end
end)
end
tabs[id]={btn=btn,ind=ind,locked=locked}
end
createTab("State","State")
createTab("Values","Values")
createTab("Finding","Finding")
createTab("Trades","Trades")
createTab("Settings","Settings",true)
activeTab="State"
for tid,t in pairs(tabs)do
if t.locked then continue end
local a=(tid=="State")
t.btn.BackgroundColor3=a and C.Accent2 or C.Panel2
t.btn.UIStroke.Color=a and C.Accent or C.Stroke
t.btn.UIStroke.Transparency=a and 0 or 0.4
t.ind.Visible=a
end
statePage.Visible=true
valuePage.Visible=false
findingPage.Visible=false
tradesPage.Visible=false
local mainDragging,mainStart,mainOrigin
dragBtn.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
mainDragging=true;mainStart=input.Position;mainOrigin=main.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then mainDragging=false end
end)
end
end)
UserInputService.InputChanged:Connect(function(input)
if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
if mainDragging then
local d=input.Position-mainStart
main.Position=UDim2.new(mainOrigin.X.Scale,mainOrigin.X.Offset+d.X,mainOrigin.Y.Scale,mainOrigin.Y.Offset+d.Y)
end
if toggleDragging then
local d=input.Position-toggleStart
toggleBtn.Position=UDim2.new(toggleOrigin.X.Scale,toggleOrigin.X.Offset+d.X,toggleOrigin.Y.Scale,toggleOrigin.Y.Offset+d.Y)
end
end)
toggleBtn.Activated:Connect(function()
toggleBtn.Visible=false
main.Visible=true
end)
closeBtn.Activated:Connect(function()
main.Visible=false
toggleBtn.Visible=true
toggleScale.Scale=1
end)
local ML=ReplicatedStorage:FindFirstChild("ModuleLoader")
local function grabModule(name)
if shared and shared.Modules and shared.Modules[name]then return shared.Modules[name]end
return nil
end
Config,Network=grabModule("Config"),grabModule("Network")
Replication=grabModule("Replication")
if not ML then
setStatus("⚠ ModuleLoader missing",C.Bad)
else
if not Config then pcall(function()Config=require(ML:WaitForChild("Configs",5):WaitForChild("Config",5))end)end
if not Network then pcall(function()Network=require(ML:WaitForChild("Shared",5):WaitForChild("Network",5))end)end
if not Replication then
local ok=pcall(function()
Replication=require(ML:WaitForChild("Client",5):WaitForChild("Replication",5))
if Replication and Replication.Start then Replication.Start()end
end)
if not ok then warn("[AT] Replication require+Start failed")end
end
end
if not(Config and Replication)then
setStatus("⚠ Modules failed to load",C.Bad)
else
setStatus("Modules OK · waiting for replica…",C.Warn)
end
task.spawn(function()
if not Replication then setStatus("⚠ Replication unavailable",C.Bad);return end
local attempts=0
while attempts<60 do
attempts+=1
if Replication.GetCurrentReplica then
local ok,r=pcall(Replication.GetCurrentReplica)
if ok and r and r:IsActive()then
replica=r;replicaFetched=true
setStatus("Replica OK · loading inventory…",C.Warn)
return
end
end
if attempts%4==0 then setStatus("Waiting for replica… ("..attempts..")",C.Warn)end
task.wait(0.5)
end
setStatus("⚠ Replica timeout — data unavailable",C.Bad)
end)
local function buildGrouped()
local list,map={},{}
if not(replica and replica.Data and replica.Data.Towers)then return list,"no replica"end
if not Config then return list,"no config"end
local towersCount=0
for _,t in pairs(replica.Data.Towers)do
towersCount+=1
local name=t.Name
if not name then continue end
local cfg=Config.Towers[name]
if not cfg then continue end
local e=map[name]
if not e then
e={Name=name,Rarity=cfg.Rarity or"Basic",Icon=cfg.Icon,Count=0,Equipped=false}
map[name]=e
end
e.Count+=1
if type(t.Equipped)=="number"and t.Equipped>=1 then e.Equipped=true end
end
if towersCount==0 then return list,"replica.Towers empty"end
for _,e in pairs(map)do table.insert(list,e)end
table.sort(list,function(a,b)
local ra,rb=RARITY_ORDER[a.Rarity]or 0,RARITY_ORDER[b.Rarity]or 0
if ra~=rb then return ra>rb end
return a.Name<b.Name
end)
return list,"ok"
end
local function makeRow(entry,i)
local rc=RARITY_COLORS[entry.Rarity]or RARITY_COLORS.Basic
local row=new("Frame",{
Size=UDim2.new(1,0,0,44),BackgroundColor3=C.Row,BorderSizePixel=0,LayoutOrder=i,
},scroll)
corner(row,8)
local bar=new("Frame",{
Size=UDim2.fromOffset(4,28),Position=UDim2.new(0,6,0.5,-14),
BackgroundColor3=rc,BorderSizePixel=0,
},row)
corner(bar,2)
new("UIGradient",{Color=ColorSequence.new(rc,rc:Lerp(Color3.new(0,0,0),0.5)),Rotation=90},bar)
local iconF=new("Frame",{
Size=UDim2.fromOffset(30,30),Position=UDim2.new(0,17,0.5,-15),
BackgroundColor3=C.BG,BorderSizePixel=0,
},row)
corner(iconF,6);stroke(iconF,rc,1,0.4)
if entry.Icon then
new("ImageLabel",{Size=UDim2.new(1,-4,1,-4),Position=UDim2.fromOffset(2,2),
BackgroundTransparency=1,Image=entry.Icon,ScaleType=Enum.ScaleType.Fit},iconF)
end
new("TextLabel",{
Position=UDim2.fromOffset(56,5),Size=UDim2.new(1,-200,0.55,0),
BackgroundTransparency=1,Font=Enum.Font.GothamSemibold,
Text=entry.Name,TextSize=13,TextColor3=C.Text,
TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,
},row)
if entry.Equipped then
local eq=new("TextLabel",{
Position=UDim2.fromOffset(56,24),Size=UDim2.fromOffset(22,12),
BackgroundColor3=C.Accent2,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="EQ",TextSize=8,TextColor3=C.Text,
},row)
corner(eq,3)
end
local pill=new("Frame",{
Size=UDim2.fromOffset(76,16),Position=UDim2.new(1,-90,0.5,-8),
BackgroundColor3=rc,BackgroundTransparency=0.8,BorderSizePixel=0,
},row)
corner(pill,8);stroke(pill,rc,1,0.35)
new("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
Font=Enum.Font.GothamSemibold,Text=entry.Rarity,TextSize=10,TextColor3=rc},pill)
local count=new("TextLabel",{
Size=UDim2.fromOffset(38,20),Position=UDim2.new(1,-42,0.5,-10),
BackgroundColor3=C.Panel2,BorderSizePixel=0,
Font=Enum.Font.GothamBold,Text="×"..entry.Count,TextSize=11,
TextColor3=entry.Count>1 and C.Good or C.SubText,
},row)
corner(count,6);stroke(count,C.Stroke,1,0.4)
row.MouseEnter:Connect(function()
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.RowHov}):Play()
end)
row.MouseLeave:Connect(function()
TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.Row}):Play()
end)
end
local function render()
for _,c in ipairs(scroll:GetChildren())do
if c:IsA("Frame")then c:Destroy()end
end
local q=string.lower(searchBox.Text or"")
local total,unique,shown=0,0,0
for _,e in ipairs(grouped)do
total+=e.Count
unique+=1
if q~=""and not string.find(string.lower(e.Name),q,1,true)then continue end
shown+=1
makeRow(e,shown)
end
unitsLbl.Text=total.." Unit"..(total==1 and""or"s")
uniqueLbl.Text=unique.." unique"
emptyState.Visible=(shown==0)
end
local function refresh()
local list,reason=buildGrouped()
grouped=list
if#grouped>0 then
setStatus("✓ Loaded "..(#grouped).." unique",C.Good)
else
if reason=="no replica"then
setStatus("⚠ Replica not ready yet — tap Refresh",C.Warn)
emptyTitle.Text="Waiting for data"
emptySub.Text="Replica hasn't loaded"
elseif reason=="replica.Towers empty"then
setStatus("✓ Replica OK · 0 towers",C.Good)
emptyTitle.Text="No units yet"
emptySub.Text="Summon a tower to see it here"
elseif reason=="no config"then
setStatus("⚠ Config not loaded",C.Bad)
else
setStatus("⚠ No units found",C.Warn)
end
end
render()
renderValueUnits()
if renderFindingUnits then renderFindingUnits()end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(render)
refreshBtn.Activated:Connect(refresh)
task.spawn(function()
while not replica do task.wait(0.5)end
pcall(function()replica:OnSet({"Towers"},refresh)end)
refresh()
end)
task.spawn(function()
for i=1,8 do
task.wait(1.2)
if#grouped==0 and replicaFetched then refresh()end
end
end)
print("[AT] ✓ Ready v6. Tabs: State · Values · Finding · Trades · Settings")
