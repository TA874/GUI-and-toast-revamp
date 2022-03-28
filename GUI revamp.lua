pcall(function()City.rebuildUI()end)
local p2,p3,p4,p5=0,0,0,0
local function setX(v,x)v:setPosition(x,v:getY())end
local function setY(v,y)v:setPosition(v:getX(),y)end
local function getAbsPosition(v)return v:getAbsoluteX(),v:getAbsoluteY() end
local function setWidth(v,w)v:setSize(w,v:getHeight())end
local function setHeight(v,h)v:setSize(v:getWidth(),h)end
local function getSize(v)return v:getWidth(),v:getHeight() end
local function getClientSize(v,h)return v:getClientWidth(),v:getClientHeight() end
local function addX(v,x)setX(v,v:getX()+x)end
local function addY(v,y)setY(v,v:getY()+y)end
local function addWidth(v,w)setWidth(v,v:getWidth()+w)end
local function addHeight(v,h)setHeight(v,v:getHeight()+h)end
local gi,revampToast
local settings
local textures
function script:init()
	settings=Util.optStorage(TheoTown.getStorage(),script:getDraft():getId())
	settings.r=settings.r or 255
	settings.g=settings.g or 255
	settings.b=settings.b or 255
	settings.alpha=settings.alpha or 1
	settings.colorWarmth=settings.colorWarmth or 0
	settings.showFPSCounter=settings.showFPSCounter and true or false
end
local giAddToast=function(...) if type(giAddToast)=="function" then return giAddToast(...) else return Debug.toast(select(2,...)) end end
isToastRevampEnabled=function() return revampToast end
giIsEnabled=function() return gi end
giGetColor=function() if giIsEnabled() then return settings.r,settings.g,settings.b,settings.alpha,settings.colorWarmth else return 255,255,255,1,1 end end
local dialogs={}
function table.getKey(tbl,v)
	local k,v2=nil,nil
	for kk,v3 in pairs(tbl) do if v3==v then k,v2=kk,v3 break end end
	return k,v2
end
function table.find(tbl,v)
	local i,v2=nil,nil
	for ii,v3 in ipairs(tbl) do if v3==v then i,v2=ii,v3 break end end
	return i,v2
end
function table.reverse(tbl) if type(tbl)=="table" then
	local tbl2={}
	for i,v in ipairs(tbl) do table.insert(tbl2,1,v) end
	for k,v in pairs(tbl) do if type(tonumber(k))=="nil" then tbl2[k]=v end end
	setmetatable(tbl2,getmetatable(tbl))
	return tbl2
end return nil end
function table.copy(...) local tbl,a=... if type(tbl)=="table" then
	local tbl2={}
	for k,v in pairs(tbl) do
		tbl2[k]=v
		if type(a)=="function" then tbl2[k]=a(v) end
	end
	setmetatable(tbl2,getmetatable(tbl))
	return tbl2
elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(tbl))
else error("bad argument #1 table expected, got no value") end end
function string.get(self,i)
	local s=self
	i=tonumber(i) or 1
	if i<=0 then i=#s-(-i-1) end
	local v=self:sub(1,i)
	v=""
	s=s:sub(1,i)
	s=s:reverse()
	s=s:sub(1,-i)
	if s=="" and self~="" then s=nil end
	return s
end
local function autoGetColor() if gi then
	local cr,cg,cb=giGetColor()
	local i=(cr+cg+cb)/3
	if i<128 then return 255,255,255 else return 0,0,0 end
else return 0,0,0 end end
giAutoGetColor=autoGetColor
local function drawOutline(x,y,w,h,s)
	s=tonumber(s) or 1
	local sx2,sy2=Drawing.getScale()
	w,h,sx,sy=w*sx2,h*sy2,s*sx2,s*sy2
	sx,sy=math.min(sx,w*0.5),math.min(sy,h*0.5)
	Drawing.drawLine(x+sx,y+(sy/2),x+(w-sx),y+(sy*0.5),sy)
	Drawing.drawLine(x+(w-(sx*0.5)),y+h-sy,x+(w-(sx*0.5)),y+sy,sx)
	Drawing.drawLine(x+(sx*0.5),y+sy,x+(sx*0.5),y+(h-sy),sx)
	Drawing.drawLine(x+w-sx,y+(h-(sy*0.5)),x+sx,y+(h-(sy*0.5)),sy)
	sx,sy=math.min(s,w*0.5),math.min(s,h*0.5)
	Drawing.drawRect(x,y,sx,sy)
	Drawing.drawRect(x,y+h-(sy*sy2),sx,sy)
	Drawing.drawRect(x+w-(sx*sx2),y,sx,sy)
	Drawing.drawRect(x+w-(sx*sx2),y+h-(sy*sy2),sx,sy)
end
local function openSettings()
	local d=GUI.createDialog {title="Preferences",h=280}
	d.content:addCanvas {
		w=120,
		h=120,
		onDraw=function(self,x,y,w,h)
			local cr,cg,cb=giGetColor()
			Drawing.setColor(255-((settings.g/2)+(settings.b/2)),255-((settings.r/2)+(settings.b/2)),255-((settings.r/2)+(settings.g/2)))
			Drawing.drawRect(x,y,w,h)
			Drawing.reset()
		end
	}
	d.content:addLayout {
		x=125,vertical=true,
		onInit=function(self)
			local l
			self:addLabel {text="R",h=10}
			local function draw(self,x,y,w,h,...)
				local r,g,b,a=(...)()
				local rr,gg,bb,aa=select(2,...)()
				local iii=10
				local i=0
				while i<w-1 do
					local ii=i/(w-iii)
					ii=1-ii
					Drawing.setColor((r*ii)+(rr*(1-ii)),
						(g*ii)+(gg*(1-ii)),
						(b*ii)+(bb*(1-ii)))
					Drawing.setAlpha((a*ii)+(aa*(1-ii)))
					local ww=math.min(iii,w-i)
					Drawing.drawRect(x+i,y,ww,h)
					i=i+iii
				end
			end
			self:addCanvas {
				h=30,
				onDraw=function(self,x,y,w,h)
					draw(self,x,y,w,h,
						function() return 0,settings.g,settings.b,1 end,
						function() return 255,settings.g,settings.b,1 end)
					Drawing.setColor(autoGetColor())
					drawOutline(x,y,w,h)
					Drawing.setColor(255,255,255)
				end
			}
			:addSlider {
				maxValue=255,
				getValue=function() return settings.r end,
				setValue=function(r) settings.r=r if l then settings.g=r settings.b=r end end,
				getText=function() return math.floor(settings.r) end,
			}
			self:addLabel {text="G",h=10}
			self:addCanvas {
				h=30,
				onDraw=function(self,x,y,w,h)
					draw(self,x,y,w,h,
						function() return settings.r,0,settings.b,1 end,
						function() return settings.r,255,settings.b,1 end)
					Drawing.setColor(autoGetColor())
					drawOutline(x,y,w,h)
					Drawing.setColor(255,255,255)
				end
			}
			:addSlider {
				h=30,
				maxValue=255,
				getValue=function() return settings.g end,
				setValue=function(g) settings.g=g if l then settings.r=g settings.b=g end end,
				getText=function() return math.floor(settings.g) end,
			}
			self:addLabel {text="B",h=10}
			self:addCanvas {
				h=30,
				onDraw=function(self,x,y,w,h)
					draw(self,x,y,w,h,
						function() return settings.r,settings.g,0,1 end,
						function() return settings.r,settings.g,255,1 end)
					Drawing.setColor(autoGetColor())
					drawOutline(x,y,w,h)
					Drawing.setColor(255,255,255)
				end
			}
			:addSlider {
				h=30,
				maxValue=255,
				getValue=function() return settings.b end,
				setValue=function(b) settings.b=b if l then settings.r=b settings.g=b end end,
				getText=function() return math.floor(settings.b) end,
			}
			self:addButton {
				w=30,h=30,
				icon=Icon.LOCKED,
				isPressed=function() return l end,
				onClick=function() l=not l end,
			}
			if true then
				self:addLabel {text="Alpha",h=10}
				self:addCanvas {
					h=30,
					onDraw=function(self,x,y,w,h)
						local br,bg,bb=autoGetColor()
						draw(self,x,y,w,h,
							function() return br,bg,bb,0 end,
							function() return br,bg,bb,0.4 end)
						Drawing.setColor(autoGetColor())
						drawOutline(x,y,w,h)
						Drawing.setColor(255,255,255)
					end
				}
				:addSlider {
					h=30,
					minValue=0.1,
					getValue=function() return settings.alpha end,
					setValue=function(a) settings.alpha=a end,
					getText=function() return math.floor((settings.alpha*100)+0.5).."%" end,
				}
			end
			self:addLabel {text="Color warmth",h=10}
			self:addCanvas {
				h=30,
				onDraw=function(self,x,y,w,h)
					draw(self,x,y,w,h,
						function() return 255,255,0,0 end,
						function() return 255,255,0,0.3 end)
					Drawing.setColor(autoGetColor())
					drawOutline(x,y,w,h)
					Drawing.setColor(255,255,255)
				end
			}
			:addSlider {
				h=30,
				maxValue=0.3,
				getValue=function() return settings.colorWarmth end,
				setValue=function(a) settings.colorWarmth=a end,
				getText=function() return math.floor(((settings.colorWarmth or 0)*100)+0.5).."%" end,
			}
		end
	}
	return d
end
local function openGUIExample()
	local function showObjectsDialog()
		local dialog=GUI.createDialog{
			icon=Icon.REGION_SPLIT,
			title='Objects',
			height=215
		}
		local layout=dialog.content:addLayout{
			vertical=true
		}
		local function addLine(label, height)
			local line=layout:addLayout{height=height}
			line:addLabel{text=label, w=60}
			return line:addLayout{x=62}
		end
		local sliderValue,buttonValue=0.5,'B'
		addLine('Icons:', 26)
		:addIcon{icon=Icon.OK, w=26}
		:getParent():addIcon{icon=Icon.CANCEL, w=26}
		:getParent():addIcon{icon=Icon.CITY, w=26}
		:getParent():getParent():getLastPart():addCanvas{
			x=-100,
			y=10,
			h=10,
			onDraw=function(self,x,y,w,h)
				Drawing.setColor(0, 80, 100)
				Drawing.drawNinePatch(NinePatch.PROGRESS_BAR,x,y,w,h)
				local progress=Runtime.getTime()/1000%1
				if progress*w>=10 then Drawing.drawNinePatch(NinePatch.PROGRESS_BAR_FILLED, x, y, progress * w, h) end
				Drawing.reset()
			end
		}
		local e
		addLine('Buttons:', 26):addButton{
			icon=Icon.OK,
			text='Test',
			frameDefault=NinePatch.BLUE_BUTTON,
			framePressed=NinePatch.BLUE_BUTTON_PRESSED,
			onInit=function(self) e=self self:setWidth(self:getParent():getClientWidth()/2-1) end,
			onClick=function(self) Debug.toast('cya') end
		}
		:getParent():addButton{
			icon=Icon.CANCEL,
			text='Golden',
			onInit=function(self) self:setWidth(self:getParent():getClientWidth()/2-2) end,
			golden=true,
			onClick=function(self) Debug.toast('woah') end
		}
		--e=e:getParent():getParent()
		--e:setParent(layout)
		local line=addLine('Button selection:', 26)
		local widthPerButton=line:getClientWidth()/3-1
		for _,text in pairs{"A","B","C"} do line:addButton{
			width=widthPerButton,
			text=text,
			onClick=function()buttonValue=text end,
			isPressed=function()return buttonValue==text end
		} end
		addLine('Slider:', 26):addSlider{
			minValue=0,
			maxValue=1,
			setValue=function(v) sliderValue=v end,
			getValue=function() return sliderValue end
		}
		addLine('Text field:', 26):addTextField{
			text='Hello World ',
			w=-40
		}
		:getParent():addButton{
			w=38,
			text='Show',
			onClick=function(self) Debug.toast('Input is: '..self:getParent():getChild(1):getText()) end
		}
		addLine('Text frame:', 40):addTextFrame{
			text=[[This is a long text
	that can even span over multiple lines 
	This will scroll
	if it
	is long enough.]]
		}
		--dialog.content=dialog.content:setParent(GUI.getRoot())
	end
	local function showResourcesDialog()
		local function createIconPreview(parent, frame) end
		local dialog=GUI.createDialog{
			icon=Icon.DECORATION,
			title='Resources',
			width=240,
			height=300
		}
		local listBox=dialog.content:addListBox{}
		local function addItems(source, keys, sourceName, height, drawer)
			for _,key in pairs(keys) do
				local item=source[key]
				local entry=listBox:addCanvas{h=height}
				local name=sourceName..'.'..key
				entry:addCanvas{
					w=height,
					onDraw=function(self,x,y,w,h) if type(drawer)=="function" then drawer(item,x,y,w,h) end end
				}
				entry:addLabel{
					text=name,
					x=height+5,
					w=-30
				}:setFont(Font.SMALL)
				entry:addButton{
					icon=Icon.COPY,
					x=-30,
					w=26,
					onClick=function()
						Runtime.setClipboard(name)
						Debug.toast('Put '..name..' into clipboard')
					end
				}
			end
		end
		addItems(Icon, Icon.keys, 'Icon', 26, function(item,x,y,w,h) Drawing.drawImage(item,x,y) end)
		addItems(NinePatch, NinePatch.keys, 'NinePatch', 26, function(item,x,y,w,h) Drawing.drawNinePatch(item,x,y,w,h) end)
		addItems(Font, Font.keys, 'Font', 26, function(item,x,y,w,h)
			Drawing.setColor(0, 0, 0)
			Drawing.drawText('Abc',x+w/2,y+h/2,item,0.5, 0.5)
			Drawing.reset()
		end)
		addItems(Keys,Keys.keys,'Keys',26)
	end
	GUI.createDialog {
		icon=script:getDraft():getPreviewFrame(),
		title='GUI example',
		text='From here you have access to various examples.\n\rhttps://youtu.be/dQw4w9WgXcQ,',
		width=250,
		height=120,
		onInit=function(self) end,
		actions={
			{
				id='$menuparent',
				icon=Icon.HAMBURGER,
				text='Menu',
				--hotkeys={Keys.VOLUME_UP},
				onClick=function(self)
					local actions={
						{icon=Icon.OK,text='A',onClick=function() Debug.toast('yo') end},
						{icon=Icon.CANCEL,text='B',enabled=false},
						{icon=Icon.OK,text='C',hotkeys={Keys.CONTROL_LEFT,Keys.SHIFT_LEFT,Keys.VOLUME_UP},onClick=function() Debug.toast('ye') end},
						{icon=Icon.OK,text='D'},{icon=Icon.OK,text='E'},
						{},
						{icon=Icon.CLOSE,text='Close',hotkeys={Keys.ESCAPE},onClick=self.close}
					}
					actions[4].actions=actions
					actions[5].actions=actions
					GUI.createMenu{source=GUI.get('$menuparent'),actions=actions}
				end,
				autoClose=false
			},
			{
				icon=Icon.REGION_SPLIT,
				text='Objects',
				onClick=showObjectsDialog,
				autoClose=false
			},
			{
				icon=Icon.DECORATION,
				text='Resources',
				onClick=showResourcesDialog,
				autoClose=false
			}
		}
	}
end
function script:settings()
	local tbl={}
	local tbl2={0,1}
	local tbl3={"","GUI example"}
	if TheoTown.SETTINGS.experimentalFeatures then
		tbl[#tbl+1]={
			name="Revamp GUI",
			value=gi and true or false,
			onChange=function(v) gi=v end
		}
		tbl[#tbl+1]={
			name="Revamp toasts",
			value=revampToast and true or false,
			onChange=function(v) revampToast=v end
		}
		if gi then table.insert(tbl2,2) table.insert(tbl3,"Preferences") end
	end
	tbl[#tbl+1]={
		name="",
		value=0,
		values=tbl2,
		valueNames=tbl3,
		onChange=function(v)
			if v==2 then openSettings2=true
			elseif v==1 then openGUIExample2=true end
		end
	}
	tbl[#tbl+1]={
		name="Show FPS counter",
		value=settings.showFPSCounter,
		onChange=function(v) settings.showFPSCounter=v end
	}
	return tbl
end
local clipping={}
local setClipping=function(x,y,w,h)
	clipping.x=x clipping.y=y clipping.w=w clipping.h=h
	setClipping2(x,y,w,h)
end
local resetClipping=function()
	local p=GUI.getRoot()
	local x,y,w,h=p:getAbsoluteX(),p:getAbsoluteY(),p:getWidth(),p:getHeight()
	clipping.x=x clipping.y=y clipping.w=w clipping.h=h
	resetClipping2()
end
playClickSound=function()
	local e=Draft.getDraft("$click00")
	if type(e)=="table" then return TheoTown.playSound(e) end
end
local getClipping=function() return clipping.x,clipping.y,clipping.w,clipping.h end
local addCanvas2
local addCanvas
local addPanel
local addButton
local addIcon
local addLabel
local addTextFrame
local addTextField2
local addTextField
local addSlider
local addLayout
local addListBox
local createMenu
local createDialog
local createRenaneDialog
local createSelectDraftDialog
local drawNinePatch
addCanvas=function(...)
	local self,tbl=...
	if type(self)=="table" and type(tbl)=="table" then
		tbl.id=(tbl.id)
		if type(tbl.id)=="nil" then tbl.id=tostring(math.random(1,99999999999)) end
		local p,p2=self,self
		local type0=""
		pcall(function() type0=p.type or "" end)
		pcall(function() while p:getParent() do
			p=p:getParent()
			type0=p.type or ""
			if type0=="listbox" then break end
		end end)
		local cx,cy,fx,fy
		local tbl2=table.copy(tbl)
		enabled=tbl.enabled or type(tbl.enabled)~="boolean" or type(tbl.enabled)=="nil"
		tbl2.onInit=function(self,...)
			self.onInit=tbl2.onInit
			self.onDraw=tbl2.onDraw
			self.onUpdate=tbl2.onUpdate
			self.onClick=tbl2.onClick
			self.alpha=tbl.alpha
			self.alpha2=1
			--ga=function() return 1 end
			self:setEnabled(enabled)
			if type(tbl.hotkeys)=="table" then for _,v in pairs(tbl.hotkeys) do if type(v)=="number" then self:addHotkey(v) end end end
			function self:click(...) if self:isEnabled() and type(tbl.onClick)=="function" then tbl.onClick(self,...) end end
			--function self:draw()
			local e,e2,e3,e4=true,nil,true,nil
			if type(tbl.onInit)=="function" then e,e2=pcall(function(...) tbl.onInit(...) end,self,...) end
			if type(tbl.onUpdate)=="function" then e3,e4=pcall(function(...) tbl.onUpdate(...) end,self,...) end
			assert(e,e2)
			assert(e3,e4)
		end
		do local iii=0 tbl2.onUpdate=function(self,...)
			if self:getTouchPoint() then cx,cy=self:getTouchPoint() iii=iii+1 if iii==1 then fx,fy=self:getTouchPoint() end else iii=0 end
			pcall(function()
				local a=self:getParent().alpha
				if type(a)=="function" then a=a() end
				a=tonumber(a) or 1
				local a2=tonumber(self:getParent().alpha2) or 1
				self.alpha2=math.max(0,math.min(1,a2*a))
			end)
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(self,...) end
		end end
		tbl2.onDraw=function(self,...) local e2,e3=true pcall(function(...)
			local setAlpha2=Drawing.setAlpha
			local getAlpha2=Drawing.getAlpha
			local a=Drawing.getAlpha()
			setAlpha2(a*self:getAlpha())
			Drawing.setAlpha=function(aa)
				a=aa
				return setAlpha2(a*self:getAlpha())
			end
			Drawing.getAlpha=function(aa) return a end
			local e if type0=="listbox" then e=pcall(function() Drawing.setClipping(p:getAbsoluteX()+2,p:getAbsoluteY()+2,p:getWidth()-4,p:getHeight()-4) end) end
			if type(tbl.onDraw)=="function" then e2,e3=pcall(function(...) tbl.onDraw(...) end,self,...) end
			Drawing.setAlpha=setAlpha2
			Drawing.getAlpha=getAlpha2
			Drawing.setAlpha(a)
			--if self:getTouchPoint() then
			do
				--local r,g,b=Drawing.getColor()
				--local a=Drawing.getAlpha()
				--Drawing.setColor(0,170,255)
				--Drawing.setAlpha(0.5)
				--Drawing.setAlpha(1)
				--drawOutline(...)
				--Drawing.setColor(r,g,b)
				--Drawing.setAlpha(a)
			end
			if e then Drawing.resetClipping() end
		end,...) assert(e2,e3) end
		--if (type0~="listbox") or tbl2.f then
		--else tbl2.onDraw,tbl2.onUpdate=nil,nil end
		tbl2.onClick=function(self,...) if (type0~="listbox") or ((type0=="listbox") and (cx==fx and cy==fy)) then self:click(cx,cy,select(3,...)) end end
		--local tbl={}
		local tbl=addCanvas2(self,tbl2)
		--tbl:delete()
		--tbl:setSize(30,30)
		--GUI.getRoot().orig=tbl.orig
		return tbl
		--return addCanvas2(self,tbl2)
	elseif select("#",...)>=2 then error("bad argument #2 table expected, got "..type(tbl))
	elseif select("#",...)==1 and type(self)=="table" then error("bad argument #2 table expected, got no value")
	elseif select("#",...)==1 then error("bad argument #1 table expected, got "..type(self))
	else error("bad argument #1 table expected, got no value") end
end
addPanel=function(...)
	local self,tbl=...
	if type(self)=="table" and type(tbl)=="table" then
		local tbl2=table.copy(tbl)
		tbl2.onDraw=function(self,x,y,w,h,...) if type(tbl.onDraw)=="f".."unction" then tbl.onDraw(self,x,y,w,h,...) else
			local p2,p3,p4,p5=self:getPadding()
			x,y,w,h=x-p2,y-p3,w+p2+p4,h+p3+p5
			Drawing.setColor(giGetColor())
			--Drawing.drawRect(x,y,w,h)
			Drawing.setAlpha(0.7)
			--Drawing.drawNinePatch(script:getDraft():getFrame(1),x,y,w,h)
			Drawing.drawRect(x,y,w,h)
			Drawing.setAlpha(0.5)
			Drawing.setColor(autoGetColor())
			--Drawing.drawNinePatch(script:getDraft():getFrame(10),x,y,w,h)
			drawOutline(x,y,w,h)
			Drawing.resetClipping()
			Drawing.reset()
			x,y,w,h=x+p2,y+p3,w-p2-p4,h-p3-p5
		end end
		return self:addCanvas(tbl2)
	elseif select("#",...)>=2 then error("bad argument #2 table expected, got "..type(tbl))
	elseif select("#",...)==1 and type(self)=="table" then error("bad argument #2 table expected, got no value")
	elseif select("#",...)==1 then error("bad argument #1 table expected, got "..type(self))
	else error("bad argument #1 table expected, got no value") end
end
addButton=function(self,tbl)
	local icon,text=tbl.icon,tbl.text
	local icon2,text2
	local function isPressed() if type(tbl.isPressed)=="function" then return tbl.isPressed() end end
	local s=2
	local ax,ay,font=0.5,0.5
	local tt=Runtime.getTime()-200
	local tt2=Runtime.getTime()-200
	local tt3=Runtime.getTime()-200
	local ii,ii2=0
	local ii3=0
	return self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		alpha=tbl.alpha,
		enabled=tbl.enabled,
		hotkeys=tbl.hotkeys,
		onInit=function(self,...)
			--if type(tbl.x)=="number" then if tbl.x<0 then setX(self,parent:getWidth()-tbl.x) else setX(self,tbl.x) end end
			icon2=self:addIcon {
				icon=function() return icon end,
				onUpdate=function(self)
					if self:getParent():isEnabled() then self:setAlpha(1) else self:setAlpha(0.5) end
					setWidth(self,self:getParent():getWidth()-(s*2))
					setHeight(self,(self:getParent():getHeight()-(s*2)))
					setX(self,s+(self:getWidth()*0.5)-((self:getParent():getWidth()-(s*2))*0.5))
					setY(self,s+(self:getHeight()*0.5)-((self:getParent():getHeight()-(s*2))*0.5))
					self:setAlignment(ax,ay)
					if tostring(text or type(text)=="nil" and ""):trim():len()>=1 then
						setWidth(self,math.min(30-(s*2),self:getWidth()))
						setX(self,math.min(15,(self:getParent():getWidth()-4)*0.5)-(self:getWidth()*0.5))
					end
				end
			}
			text2=self:addLabel {
				text=function() return text end,
				font=function() return font end,
				onUpdate=function(self)
					if self:getParent():isEnabled() then self:setAlpha(1) else self:setAlpha(0.5) end
					--{
					--[[self:setColor(autoGetColor())
					if self:getParent():isEnabled() and self:getParent():isTouchPointInFocus() then
						local r,g,b=self:getColor()
						self:setColor(255-r,255-g,255-b)
					--end]] --}
					setWidth(self,self:getParent():getWidth()-(s*2))
					setY(self,s+((self:getParent():getHeight()-(s*2))/2)-(self:getHeight()/2))
					setX(self,s)
					self:setAlignment(ax,ay)
					if (tonumber(icon) or 0)>=1 then
						setX(self,30+s)
						setWidth(self,self:getParent():getWidth()-self:getX())
						self:setAlignment(0.0,ay)
					end
				end
			}
			local parent=self:getParent()
			local w=tbl.width or tbl.w or 0
			do
				local icon=icon if type(icon)=="function" then icon=icon() end icon=tonumber(icon) or 0
				local iw=Drawing.getImageSize(icon)
				setWidth(self,math.max(w,math.min(iw,30)))
			end
			local c=function()
				local iw,tw=0,0
				local icon,text=icon,text
				if type(icon)=="function" then icon=icon() end
				if type(text)=="function" then text=text()  end
				icon,text=tonumber(icon) or 0,tostring(text or "")
				iw=Drawing.getImageSize(icon) tw=Drawing.getTextSize(text)
				if tw>0 then setWidth(self,math.max(self:getWidth(),tw+5)) end
				if iw>0 and tw>0 then setWidth(self,math.max(self:getWidth(),math.min(30,self:getHeight(),iw)+tw+15)) end
			end c()
			function self:setIcon(v) icon=v c() end
			function self:setText(v) text=v c() end
			function self:getIcon() if type(icon)=="function"then return icon()else return tonumber(icon) or 0 end end
			function self:getText() if type(text)=="function"then return text()else return text or "" end end
			function self:getAlignment() return ax,ay end
			function self:setAlignment(...) ax,ay=... end
			function self:getFont() return font end
			function self:setFont(v) font=v end
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(self,...)
			icon2:setVisible(icon2:getIcon()>=1)
			text2:setVisible(text2:getText():trim():len()>=1)
			setWidth(self,math.max(self:getWidth(),self:getHeight()))
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(self,...) end
		end,
		onClick=function(self,...) if not isPressed() then playClickSound() end if type(tbl.onClick)=="function" then tbl.onClick(self,...) end end,
		onDraw=function(self,x,y,w,h)
			local r,g,b=Drawing.getColor()
			local a=Drawing.getAlpha()
			local cr,cg,cb=giGetColor()
			local br,bg,bb=autoGetColor()
			Drawing.setColor(cr,cg,cb)
			Drawing.setAlpha(a*0.7)
			--Drawing.drawNinePatch(script:getDraft():getFrame(1),x,y,w,h)
			Drawing.drawRect(x,y,w,h)
			Drawing.setAlpha(a*0.3)
			if self:isEnabled() then Drawing.setAlpha(0.5) end
			Drawing.setColor(br,bg,bb)
			do
				local aa=0.5
				if not self:isEnabled() then aa=0.3 end
				local ttt2=(Runtime.getTime()-tt2)/200
				if (self:getTouchPoint() or self:isMouseOver()) and self:isEnabled() then ii2=1 else ii2=0 end
				if ii2==1 then tt2=Runtime.getTime() end
				if not TheoTown.SETTINGS.uiAnimations then ttt2=1 end
				if ii2==1 then Drawing.setAlpha(a) else Drawing.setAlpha(a*(aa+(0.5*(1-math.min(1,ttt2))))) end
				local ss=1
				do
					if isPressed() and ii3==0 then ii3=1 tt3=Runtime.getTime() end
					if (not isPressed()) and ii3==1 then ii3=0 tt3=Runtime.getTime() end
					local ttt3=(Runtime.getTime()-tt3)/200
					ttt3=math.min(1,ttt3)
					if isPressed() then ttt3=1-ttt3 end
					s,ss=2+(2*(1-ttt3)),1+(2*(1-ttt3))
				end
				drawOutline(x,y,w,h,ss)
			end
			local ttt=(Runtime.getTime()-tt)/200
			if self:isTouchPointInFocus() and self:isEnabled() then ii=1 else ii=0 end
			if ii==1 then tt=Runtime.getTime() end
			if not TheoTown.SETTINGS.uiAnimations then ttt=1 end
			if ii==1 then Drawing.setAlpha(a*0.3) else Drawing.setAlpha(a*(0.3*(1-ttt))) end
			--Drawing.drawNinePatch(script:getDraft():getFrame(1),x,y,w,h)
			Drawing.drawRect(x,y,w,h)
			Drawing.setColor(r,g,b)
			Drawing.setAlpha(a)
		end
	}
end
addIcon=function(self,tbl)
	local icon=tbl.icon
	local ax,ay=0.5,0.5
	return self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self:setTouchThrough(true)
			function self:getIcon(a) if a then return icon else
				local icon=icon if type(icon)=="function" then pcall(function() icon=icon() end) end
				return tonumber(icon) or 0
			end end
			function self:setIcon(v) icon=v end
			function self:getAlignment(x,y) return ax,ay end
			function self:setAlignment(x,y) ax,ay=x,y end
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(...)if type(tbl.onUpdate)=="function" then tbl.onUpdate(...) end end,
		onDraw=function(self,x,y,w,h)
			local icon=icon if type(icon)=="function" then icon=icon() end
			icon=tonumber(icon) or 0
			if icon>=1 then
				local iw,ih=Drawing.getImageSize(icon)
				local hx,hy=Drawing.getImageHandle(icon)
				local sx,sy=Drawing.getScale()
				local s=math.min(1,w/iw,h/ih) Drawing.setScale(sx*s,sy*y)
				Drawing.drawImage(icon,x+(hx*(sx*s))+(w*ax)-((iw*(sx*s))*ax),y+(hy*(sx*s))+(h*ay)-((ih*(sx*s))*ay))
				Drawing.setScale(sx,sy)
			end
		end
	}
end
addLabel=function(self,tbl)
	local text=tbl.text
	local ax,ay=0,0.5
	local r,g,b
	local font=tbl.font or Font.DEFAULT
	return self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self:setTouchThrough(true)
			function self:getText(a) if a then return text else
				local text=text if type(text)=="function" then pcall(function() text=text() end) end
				return tostring(text or type(text)=="nil" and "")
			end end
			function self:setText(v) text=v end
			function self:getColor() if (type(r)=="number") and (type(g)=="number") and (type(b)=="number") then return r,g,b else return autoGetColor() end end
			function self:setColor(...) r,g,b=... end
			function self:getAlignment() return ax,ay end
			function self:setAlignment(...) ax,ay=... end
			function self:getFont() return font end
			function self:setFont(v) font=v end
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(...)if type(tbl.onUpdate)=="function" then tbl.onUpdate(...) end end,
		onDraw=function(self,x,y,w,h)
			local font=font if type(font)=="function" then font=font() end
			local text=text if type(text)=="function" then text=text() end
			text=tostring(text or type(text)=="nil" and "")
			if text:len()>=1 then
				local r,g,b=Drawing.getColor()
				local sx,sy=Drawing.getScale()
				Drawing.setColor(self:getColor())
				local tw,th=Drawing.getTextSize(text,font)
				local s=math.min(1,w/tw) Drawing.setScale(s,s)
				Drawing.drawText(text,x+(w*ax)-((tw*s)*ax),y+(h*ay)-((th*s)*ay),font)
				Drawing.setColor(r,g,b)
				Drawing.setScale(sx,sy)
			end
		end
	}
end
addTextFrame=function(self,tbl)
	local text=tbl.text
 	local gth=12
	local yy,sy,h=0,0,gth
	return self:addCanvas {
		id=tbl.id,
		w=tbl.width or tbl.w,
		height=tbl.height or tbl.h,
		x=tbl.x,
		y=tbl.y,
		hotkeys=tbl.hotkeys,
		onClick=function(...) if type(tbl.onClick)=="function" then tbl.onClick(...) end end,
		onInit=function(self,...)
			function self:getText()
				local text=text if type(text)=="function" then text=text() end
				return tostring(text or type(text)=="nil" and "")
			end
			function self:setText(s) text=s end
			function self:getTextHeight() return h end
			self:addCanvas {
				onInit=function(self) function self:getText() return self:getParent():getText() end end,
				onUpdate=function(self)
					self:setChildIndex(1)
					self:setSize(self:getParent():getSize())
					addWidth(self,-5)
					self:setPosition(0,0)
				end,
				onDraw=function(self,x,y,w,hh)
					x,y,w,hh=x+1,y+1,w-2,hh-2
					--Drawing.setClipping(x,y,w,hh)
					local text=self:getText()
					local tbl,tbl2={},{}
					local t,t2="",""
					if text:trim():len()>=1 then
						for v in text:rep(1):gmatch(".") do
							--v=tbl[i-1]
							local tw=Drawing.getTextSize(t)
							local tw2=Drawing.getTextSize(v)
							local tw3=Drawing.getTextSize("-")
							if (tw>=w-tw2-tw3) then t=t.."-" end
							tw=Drawing.getTextSize(t)
							if (v=="\n") or (tw>=w-tw2-tw3) then table.insert(tbl2,t) t="" end
							if v~="\n" then t=t..v end
							t2=t
							--v=tbl[i]
						end
						table.insert(tbl2,t2)
						h=gth*#tbl2
						Drawing.setColor(autoGetColor())
						for i,v in ipairs(tbl2)do
							local y2=y+yy+(gth*(i-1))
							if y2>=y-gth and y2<y+hh then Drawing.drawText(v,x,y2) end
						end
					end
					Drawing.resetClipping()
					Drawing.reset()
				end
			}:setTouchThrough(true)
			self:addCanvas {
				onInit=function(self)
					self:addCanvas {
						onUpdate=function(self)
							self:setSize(math.min(self:getParent():getWidth(),10),self:getParent():getHeight())
							self:setPosition(self:getParent():getWidth()-self:getWidth(),0)
						end,
						onInit=function(self)
							local yy2
							self:addCanvas {
								onUpdate=function(self)
									local hh2=h-self:getParent():getHeight()+4
									local hh=math.max(10,self:getParent():getHeight()*math.min(1,self:getParent():getHeight()/h))
									self:setSize(self:getParent():getWidth(),hh)
									local i=(-yy)/(h-self:getParent():getHeight()+4)
									--i=1
									self:setTouchThrough(h<=self:getParent():getHeight())
									if self:getTouchPoint() and h>self:getParent():getHeight() then
										local _,y,_,fy=self:getTouchPoint()
										local ay=self:getParent():getAbsoluteY()
										if (not yy2) then yy2=self:getAbsoluteY() end
										local ph=self:getParent():getHeight()-self:getHeight()-2
										setY(self,(y-ay)-(fy-yy2))
										--setY(self,math.max(0))
										if self:getY()<0 then setY(self,0) end
										if self:getY()>ph+1 then setY(self,ph+1) end
										local i=self:getY()/ph
										i=math.max(0,math.min(1,i))
										yy=2+((-hh2)*i)
									else yy2=nil self:setPosition(0,(self:getParent():getHeight()-self:getHeight())*i) end
								end,
								onDraw=function(self,x,y,w,hh)
									if h>self:getParent():getHeight() then
										Drawing.setColor(255,255,255)
										Drawing.drawRect(x+(w/2),y,w/2,hh)
										Drawing.setColor(0,0,0)
										drawOutline(x+(w/2),y,w/2,hh)
										Drawing.setColor(255,255,255)
										Drawing.setAlpha(1)
									end
								end
							}
							self:addCanvas {onUpdate=function(self)
									self:setSize(0,0)
									self:setPosition(self:getParent():getWidth()-self:getWidth(),0)
									local hh=self:getParent():getHeight()
									local hh2=h-hh
									--if self:getTouchPoint() then yy=yy+(hh2/30) end
									if self:getTouchPoint() then yy=yy+5 end
								end}
							self:addCanvas {onUpdate=function(self)
									self:setSize(0,0)
									self:setPosition(self:getParent():getWidth()-self:getWidth(),
										self:getParent():getHeight()-self:getHeight())
									local hh=self:getParent():getHeight()
									local hh2=h-hh
									--if self:getTouchPoint() then yy=yy-(hh2/30) end
									if self:getTouchPoint() then yy=yy-5 end
								end}
						end,
					}:setTouchThrough(true)
				end,
				onUpdate=function(self)
					self:setSize(getSize(self:getParent()))
					if self:getTouchPoint() then sy=select(6,self:getTouchPoint()) else sy=sy*0.85 end
					yy=yy+sy
					if yy<0-h+self:getHeight()-2 then sy,yy=0,0-h+self:getHeight()-2 end
					if yy>2 then sy,yy=0,2 end
				end
			}:setTouchThrough(true)
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(self,...)
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(self,...) end
		end,
	}
end
addTextField=function(self,tbl)
	local text,ptext=tbl.text
	local ax,ay=0,0.5
	local font=Font.DEFAULT
	local tfe={}
	local tf tf=self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self:setPadding(2,0,2,0)
			function self:getText()
				local text=text
				if type(text)=="function" then text=text() end
				return tostring(text or type(text)=="nil" and "")
			end
			ptext=self:getText()
			function self:setText(v) text=v pcall(function() tfe:getChild(1):setText(self:getText()) end) end
			function self:getAlignment(x,y) return ax,ay end
			function self:setAlignment(x,y) ax,ay=x,y end
			function self:getFont(v) return font end
			function self:setFont(v) font=v end
			local e,e2=pcall(function(...) if type(tbl.onInit)=="function" then tbl.onInit(...) end end,self,...)
			tfe=GUI.getRoot():addCanvas {}
			tfe:delete()
			assert(e,e2)
		end,
		onUpdate=function(self,...)
			if self:getTouchPoint() and (type(GUI.getParent(tfe))=="nil") then
				pcall(function() GUI.get("textfieldEditor"):delete() end)
				tfe=GUI.getRoot():addCanvas {
					id="textfieldEditor",
					onInit=function(self)
						self:setTouchThrough(true)
						self:setPosition(-p2,-p3)
						local tbl2=table.copy(tbl)
						tbl2.x,tbl2.y,tbl2.w=nil,nil,nil
						tbl2.h,tbl2.width,tbl2.height,tbl2.id=nil,nil,nil,nil
						tbl2.text=tostring(text or type(text)=="nil" and "")
						tbl2.onInit=function(self)
							self:setSize(tf:getWidth(),tf:getHeight())
							self:setPosition(tf:getAbsoluteX(),tf:getAbsoluteY())
							--Runtime.postpone(function() self:setActive(false) end,2000)
						end
						tbl2.onUpdate=function(self)
							self:setSize(tf:getSize())
							self:setPosition(tf:getAbsoluteX(),tf:getAbsoluteY())
							text=self:getText()
						end
						addTextField2(self,tbl2)
						function self:addCanvas() end
					end,
					onUpdate=function(self)
						if self:getTouchPoint() then self:delete() end
						self:setSize(GUI.getRoot():getSize())
						self:setPosition(-p2,-p3)
					end,
					onClick=function(self) self:delete() end
				}
			end
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(self,...) end
		end,
		onDraw=function(self,x,y,w,h,...)
			local p2,p3,p4,p5=self:getPadding()
			x,y,w,h=x-p2,y-p3,w+p2+p4,h+p3+p5
			Drawing.setColor(255,255,255)
			Drawing.drawRect(x,y,w,h)
			Drawing.setColor(autoGetColor())
			--if (Drawing.getAbsoluteColor()/3)==255 then Drawing.setColor(200,200,200) end
			local i=1 if type(GUI.getParent(tfe))=="nil" then i=0 end
			do
				local x,y,w,h=x-i,y-i,w+(i*2),h+(i*2)
				Drawing.setAlpha(0.5) drawOutline(x,y,w,h)
				Drawing.reset()
			end
			x,y,w,h=x+p2,y+p3,w-p2-p4,h-p3-p5
			Drawing.setClipping(x,y,w,h)
			local text=tostring(text or type(text)=="nil" and "")
			Drawing.setColor(0,0,0)
			local tw,th=Drawing.getTextSize(text,font)
			local s=math.min(1,w/tw) Drawing.setScale(s,s)
			Drawing.drawText(text,x+(w*ax)-((tw*s)*ax),y+(h*ay)-((th*s)*ay),font)
			Drawing.resetClipping()
			Drawing.reset()
		end
	}
	return tf
end
addSlider=function(self,tbl)
	local v,bt,pb=0
	local setValue
	local function getFunctionValue(v) if type(v)=="function" then return v() else return v end end
	return self:addCanvas {
		id=tbl.id,
		width=tbl.width,
		w=tbl.w,
		height=tbl.height,
		h=tbl.h,
		x=tbl.x or 0,
		y=tbl.y or 0,
		enabled=tbl.enabled,
		--enabled=false,
		onInit=function(self,...)
			self.minValue=tbl.minValue
			self.maxValue=tbl.maxValue
			self.getValue0=tbl.getValue
			self.getText0=tbl.getText
			self.setValue0=tbl.setValue
			setValue=function() if type(tbl.setValue)=="f".."unction" then
				local minValue,maxValue=self:getMinValue(),self:getMaxValue()
				local ii=bt:getX()/(self:getWidth()-bt:getWidth())
				local v3=minValue+((maxValue-minValue)*ii)
				local v4=math.max(minValue,math.min(maxValue,v3))
				tbl.setValue(v4) v=v4
			end end
			function self:getValue()
				local minValue,maxValue=self:getMinValue(),self:getMaxValue()
				local value=tonumber(self.value) or 0
				return value*maxValue
			end
			function self:setValue(value)
				value=tonumber(getFunctionValue(value)) or 0
				--local minValue,maxValue=self:getMinValue(),self:getMaxValue()
				--self.value=(value-minValue)/(maxValue-minValue)
				if type(tbl.setValue)=="function" then tbl.setValue(value) end
			end
			function self:getMinValue()
				local v=0
				pcall(function() v=getFunctionValue(self.minValue) end)
				return tonumber(v) or 0
			end
			function self:getMaxValue()
				local v=1
				pcall(function() v=getFunctionValue(self.maxValue) end)
				return tonumber(v) or 1
			end
			function self:setMinValue(...) self.minValue=... end
			function self:setMaxValue(...) self.maxValue=... end
			local i,xx,fx2=0,0
			bt=self:addButton{
				w=30,
				text="000",
				onClick=function(_,x) if x==fx2 then
					local minValue,maxValue=function() return self:getMinValue() end,function() return self:getMaxValue() end
					local v2=0
					if type(tbl.getValue)=="function" then pcall(function() v2=tbl.getValue() end) end
					v2=tonumber(v2) or 0
					GUI.createRenameDialog {
						title="Set value",
						value=v2,
						okIcon=Icon.SAVE,
						okText="Save",
						w=200,
						h=100,
						onOk=function(vv) self:setValue(tostring(vv):trim()) end,
						onInit=function(self) self.input:setY(0) end,
						filter=function(vv) return tonumber(vv:trim()) end
					}
				end end,
				onUpdate=function(self)
					local minValue,maxValue=self:getParent():getMinValue(),self:getParent():getMaxValue()
					self:setEnabled(self:getParent():isEnabled())
					local v2=0
					if type(tbl.getValue)=="function" then pcall(function() v2=tbl.getValue() end) end
					v2=tonumber(v2) or 0
					self.value=(v2-minValue)/(maxValue-minValue)
					self:setPosition((self:getParent():getWidth()-self:getWidth())*self.value,self:getY())
					local ov=self.value
					if self:getTouchPoint()or self:getParent():getTouchPoint()then
						local x,fx
						if self:getTouchPoint()then
							x,_,fx=self:getTouchPoint() fx2=fx
						elseif self:getParent():getTouchPoint()then
							x,_,fx=self:getParent():getTouchPoint()
						end
						i=i+1
						if i==1 then
							xx=self:getAbsoluteX()
						else
							--_,_,_,_,speedX=self:getTouchPoint()
							--self:setPosition((x-self:getParent():getAbsoluteX())-(self:getWidth()/2),self:getY())
							if self:getTouchPoint()then
								self:setPosition((x-self:getParent():getAbsoluteX())-(fx-xx),self:getY())
							elseif self:getParent():getTouchPoint()then
								self:setPosition((x-self:getParent():getAbsoluteX())-(self:getWidth()/2),self:getY())
							end
							setValue()
							--self:setPosition(self:getX()+speedX,self:getY())
						end
					else
						i=0
						xx=0
					end
					if type(tbl.getText)=="function" then pcall(function() self:setText(tostring(tbl.getText(minValue+(ov*(maxValue-minValue))))) end) else self:setText(math.floor(ov*100)..'%') end
					local tw=Drawing.getTextSize(self:getText())
					setWidth(self,math.max(30,tw+3))
					if self:getX()<0 then
						self:setPosition(0,self:getY())
					elseif self:getX()>self:getParent():getWidth()-self:getWidth()then
						self:setPosition(self:getParent():getWidth()-self:getWidth(),self:getY())
					end
				end
			}
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onDraw=function(self,x,y,w,h)
			local w2,x2=0,0
			if type(bt)=="table" then w2=bt:getWidth() end
			if type(bt)=="table" then x2=bt:getX() end
			Drawing.setColor(autoGetColor())
			x=x+(w2/2)
			Drawing.drawRect(x,y+(h/2)-2,w*(x2/(w)),4)
			w=w-w2
			drawOutline(x,y+(h/2)-2,w,4)
			Drawing.resetClipping()
			Drawing.reset()
		end,
		onClick=function(self,x,y)
			setX(bt,(x-self:getAbsoluteX())-(bt:getWidth()/2))
			setValue()
		end
	}
end
addLayout=function(self,tbl)
	local p2,p3,p4,p5=0,0,0,0
	return self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self:setTouchThrough(true)
			local fp=self:addCanvas {
				onUpdate=function(self)
					setWidth(self,self:getParent():getClientWidth())
					setHeight(self,self:getParent():getClientHeight())
					local w,h=0,0
					for i=1,self:countChildren() do
						local c=self:getChild(i)
						w=w+c:getWidth()
						h=h+c:getHeight()
						if tbl.vertical then setY(c,h-c:getHeight()) else setX(c,w-c:getWidth()) end
						w,h=w+1,h+1
					end
				end
			}
			local cp=self:addCanvas {
				onUpdate=function(self)
					local w,h=0,0
					for i=1,self:countChildren() do
						local c=self:getChild(i)
						w=w+c:getWidth()
						h=h+c:getHeight()
						if tbl.vertical then setY(c,h-c:getHeight()) else setX(c,w-c:getWidth()) end
						w,h=w+1,h+1
					end
					local p=self:getParent()
					if tbl.vertical then setHeight(self,h) else setWidth(self,w) end
					if tbl.vertical then setY(self,(p:getHeight()/2)-(self:getHeight()/2)) else setX(self,(p:getWidth()/2)-(self:getWidth()/2)) end
				end
			}
			local lp=self:addCanvas {
				onUpdate=function(self)
					setWidth(self,self:getParent():getClientWidth())
					setHeight(self,self:getParent():getClientHeight())
					local w,h=0,0
					for i=1,self:countChildren() do
						local c=self:getChild(self:countChildren()-i+1)
						w=w+c:getWidth()
						h=h+c:getHeight()
						if tbl.vertical then setY(c,self:getParent():getClientHeight()-h) else setX(c,self:getParent():getClientWidth()-w) end
						w,h=w+1,h+1
					end
				end
			}
			fp:setTouchThrough(true)
			cp:setTouchThrough(true)
			lp:setTouchThrough(true)
			function self:getFirstPart() return fp end
			function self:getCenterPart() return cp end
			function self:getLastPart() return lp end
			--function self:setPadding(...) p2,p3,p4,p5=... end
			--function self:getPadding() return p2,p3,p4,p5 end
			function self:addCanvas(tbl) return fp:addCanvas(tbl) end
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(self,...)
			p2,p3,p4,p5=self:getPadding()
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(self,...) end 
		end,
	}
end
addListBox=function(self,tbl)
	local yy,sy,h=2,0,0
	local content
	return self:addCanvas {
		id=tbl.id,
		x=tbl.x,y=tbl.y,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self.type="listbox"
			local c,cm=pcall(function()
				local parent=self
				content=self:addCanvas {
					onUpdate=function(self)
						self:setSize(getSize(self:getParent()))
						h=0 for i=1,self:countChildren() do
							local c=self:getChild(i)
							h=h+c:getHeight()
							setY(c,yy+h-c:getHeight())
							c:setVisible(c:getY()>0-c:getHeight() and c:getY()<self:getHeight())
						end
					end,
					onDraw=function(self,x,y,w,h)
						Drawing.setColor(autoGetColor())
						Drawing.setAlpha(0.5)
						drawOutline(x,y,w,h,2)
						Drawing.setAlpha(1)
						Drawing.setClipping(x+1,y+1,w-2,h-2)
						Drawing.setColor(giGetColor())
						Drawing.drawRect(x,y,w,h)
						for i=1,self:countChildren() do
							local c=self:getChild(i)
							local ii=function(c) return c:getChildIndex() end
							Drawing.setColor(giGetColor())
							if c:getAbsY()>=y-c:getHeight() and c:getAbsY()<y+h then 
								Drawing.drawRect(x,c:getAbsY(),w,c:getHeight())
								--if c:getChildIndex()%2==1 then
								if c:getChildIndex()<self:countChildren()-1 then
									Drawing.setAlpha(0.3)
									Drawing.setColor(autoGetColor())
									--Drawing.drawRect(c:getAbsX(),c:getAbsY()-0.5,c:getWidth(),1)
									Drawing.drawRect(x,c:getAbsY()+c:getHeight()-0.5,w,1)
								end
								if c:getTouchPoint() or c:isMouseOver() then
									Drawing.setAlpha(0.1)
									if c:getTouchPoint() then Drawing.setAlpha(0.2) end
									Drawing.setColor(autoGetColor())
									Drawing.drawRect(x,c:getAbsY()+0.5,w,c:getHeight()-1)
								end
							end
						end
						Drawing.setAlpha(1)
						Drawing.setColor(255,255,255)
						Drawing.resetClipping()
					end
				}
				content:setTouchThrough(true)
				self:addCanvas {
					onInit=function(self)
						self:addCanvas {
							onUpdate=function(self)
								self:setSize(math.min(self:getParent():getWidth(),10),self:getParent():getHeight())
								self:setPosition(self:getParent():getWidth()-self:getWidth(),0)
							end,
							onInit=function(self)
								local yy2
								self:addCanvas {
									f=true,
									onUpdate=function(self)
										local hh2=h-self:getParent():getHeight()+4
										local hh=math.max(10,self:getParent():getHeight()*math.min(1,self:getParent():getHeight()/h))
										self:setSize(self:getParent():getWidth(),hh)
										local i=(-yy)/(h-self:getParent():getHeight()+4)
										--i=1
										self:setTouchThrough(h<=self:getParent():getHeight())
										if self:getTouchPoint() and h>self:getParent():getHeight() then
											local _,y,_,fy=self:getTouchPoint()
											local ay=self:getParent():getAbsoluteY()
											if (not yy2) then yy2=self:getAbsoluteY() end
											local ph=self:getParent():getHeight()-self:getHeight()-2
											setY(self,(y-ay)-(fy-yy2))
											--setY(self,math.max(0))
											if self:getY()<0 then setY(self,0) end
											if self:getY()>ph+1 then setY(self,ph+1) end
											local i=self:getY()/ph
											i=math.max(0,math.min(1,i))
											yy=2+((-hh2)*i)
										else yy2=nil self:setPosition(0,(self:getParent():getHeight()-self:getHeight())*i) end
									end,
									onDraw=function(self,x,y,w,hh)
										if h>self:getParent():getHeight() then
											Drawing.setColor(255,255,255)
											Drawing.drawRect(x+(w/2),y,w/2,hh)
											Drawing.setColor(0,0,0)
											drawOutline(x+(w/2),y,w/2,hh)
											Drawing.setColor(255,255,255)
											Drawing.setAlpha(1)
										end
									end
								}
								self:addCanvas {onUpdate=function(self)
									self:setSize(0,0)
									self:setPosition(self:getParent():getWidth()-self:getWidth(),0)
									local hh=self:getParent():getHeight()
									local hh2=h-hh
									--if self:getTouchPoint() then yy=yy+(hh2/30) end
									if self:getTouchPoint() then yy=yy+5 end
								end}
								self:addCanvas {onUpdate=function(self)
									self:setSize(0,0)
									self:setPosition(self:getParent():getWidth()-self:getWidth(),
										self:getParent():getHeight()-self:getHeight())
									local hh=self:getParent():getHeight()
									local hh2=h-hh
									--if self:getTouchPoint() then yy=yy-(hh2/30) end
									if self:getTouchPoint() then yy=yy-5 end
								end}
							end,
						}:setTouchThrough(true)
					end,
					onUpdate=function(self)
						self:setSize(getSize(self:getParent()))
						if self:getTouchPoint() then sy=select(6,self:getTouchPoint()) else sy=sy*0.85 end
						yy=yy+sy
						if yy<0-h+self:getHeight()-2 then sy,yy=0,0-h+self:getHeight()-2 end
						if yy>2 then sy,yy=0,2 end
					end
				}:setTouchThrough(true)
				function self:getChild(i) return content:getChild(i) end
				function self:countChildren() return content:countChildren() end
				function self:addCanvas(tbl) local c=content:addCanvas(tbl) function c:getParent() return parent end return c end
			end)
			self:addCanvas {
				onUpdate=function(self)
					self:setSize(getSize(self:getParent()))
					self:setPosition(0,0)
				end,
				onDraw=function(...) if type(tbl.onDraw)=="function" then tbl.onDraw(...) end end,
			}:setTouchThrough(true)
			Runtime.postpone(function() assert(c,cm) end)
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
			self:getChild(1):delete()
		end,
		onUpdate=function(...) if type(tbl.onUpdate)=="function" then tbl.onUpdate(...) end end,
		onClick=function(...) if type(tbl.onClick)=="function" then tbl.onClick(...) end end,
	}
end
createMenu=function(tbl)
	local actions={}
	if type(tbl.actions)=="table" then actions=tbl.actions end
	local source=tbl.source
	GUI.getRoot():addCanvas {
		onInit=function(self)
			self:addHotkey(Keys.ESCAPE)
			local p=self:getParent()
			self:setSize(GUI.getRoot():getSize())
			self:setPosition(-p2,-p3)
			local loadMenuItems loadMenuItems=function(source,actions,ho) local pnl2="" return self:addPanel {
				w=(tbl.width or tbl.w or 120)+4,
				onInit=function(self)
					self:setPosition(tonumber(tbl.x) or self:getX(),tonumber(tbl.y) or self:getY())
					for _,v in pairs(actions) do
						local pnl="menuPanel"..math.random(100000,999999)
						local enabled=true
						if type(v.enabled)~="nil" then enabled=v.enabled end
						local tbl4
						local tbl2={
							h=15,
							hotkeys=v.hotkeys,
							onClick=function(self) if enabled and type(v.actions)~="table" then
								playClickSound()
								local e,e2=pcall(function() if type(v.onClick)=="function" then v.onClick() end end)
								Runtime.postpone(function() assert(e,e2) end)
								self:getParent():getParent():delete()
							end end,
							onUpdate=function(self)
								local parent=self:getParent()
								local parent2=parent:getParent()
								if (self:getTouchPoint() or self:isMouseOver()) then
									if GUI.get(pnl2) and (pnl~=pnl2) then
										while parent2:countChildren()>parent:getChildIndex()+1 do
											parent2:getChild(parent2:countChildren()):delete()
										end
									end
									if type(v.actions)=="table" and not GUI.get(pnl) then
										local pnl3=loadMenuItems(self,v.actions,true)
										pnl3:setId(pnl) pnl2=pnl
									end
								end
							end,
							onDraw=function(self,x,y,w,h)
								--local hotkeys=table.copy(hotkeys)
								local hotkeys=table.reverse(self:getHotkeys())
								--local hotkeys={0,1,2}
								local hotkeyTexts={}
								Drawing.setColor(autoGetColor())
								local a=1
								if not enabled then a=0.4 end
								Drawing.setAlpha(a)
								if type(v.actions)=="table" then if GUI.get(pnl) then
									Drawing.setAlpha(a*0.1)
									Drawing.drawRect(x,y,w,h)
									Drawing.setAlpha(a)
								end end
								if self:getTouchPoint() or self:isMouseOver() then
									Drawing.setAlpha(a*0.2)
									if self:isTouchPointInFocus() and enabled then Drawing.setAlpha(a*0.3) end
									Drawing.drawRect(x,y,w,h)
									Drawing.setAlpha(a)
								end
								local icon=tonumber(v.icon) or 0
								local text=tostring(v.text or "")
								local iw,ih=Drawing.getImageSize(icon)
								local s=math.min(1,math.min(20,w)/iw,h/ih)
								Drawing.setScale(s,s)
								Drawing.setColor(255,255,255)
								Drawing.drawImage(icon,x+math.min(10,w/2)-((iw*s)/2),y+(h/2)-((ih*s)/2))
								Drawing.setColor(autoGetColor())
								Drawing.setScale(1,1)
								local tw,th=Drawing.getTextSize(text)
								Drawing.drawText(text,x+20,y+(h/2)-(th/2))
								if type(v.actions)=="table" then
									local w2=math.min(10,w)
									local h2=math.min(10,h)
									local x=x+w-w2
									local y=y+(h/2)-(h2/2)
									Drawing.setAlpha(a*0.7)
									Drawing.drawTriangle(x+(w2*0.2),y+(h2*0.2),x+w2-(w2*0.2),y+(h2*0.5),x+(w2*0.2),y+h2-(h2*0.2))
									Drawing.setAlpha(a)
								end
								for i,v in ipairs(hotkeys) do
									--if v==Keys.ESCAPE then v="Esc" end
									local k=table.getKey(Keys,v)
									if k=="CONTROL_LEFT" or k=="CONTROL_RIGHT" then k="ctrl" end
									if k=="SHIFT_LEFT" or k=="SHIFT_RIGHT" then k="shift" end
									if k=="ESCAPE" then k="esc" end
									k=tostring(k):lower()
									k=k:gsub(k:sub(1,1),k:sub(1,1):upper(),1)
									--local e="" pcall(function() e=hotkeysTexts[i-1] end) e=tostring(e or "")
									--if e~="Ctrl" then hotkeyTexts[i]=k end
									hotkeyTexts[i]=k
								end
								text=table.concat(hotkeyTexts,"+")
								Drawing.setAlpha(a*0.5)
								local tw,th=Drawing.getTextSize(text)
								Drawing.drawText(text,x+w-tw,y+(h/2)-(th/2))
								Drawing.setAlpha(1)
								Drawing.reset()
							end,
						}
						local tbl3={
							h=1,
							onInit=function(self) self:setTouchThrough(true) end,
							onDraw=function(self,x,y,w,h)
								Drawing.setColor(autoGetColor())
								Drawing.setAlpha(0.5)
								Drawing.drawRect(x,y,w,h)
								Drawing.reset()
							end
						}
						if next(v) then tbl4=tbl2 else tbl4=tbl3 end
						self:addCanvas(tbl4)
					end
					local h=0
					for i=1,self:countChildren() do
						local c=self:getChild(i)
						h=h+c:getHeight()
						setY(c,2+(h-c:getHeight()))
						setX(c,2)
						addWidth(c,-4)
					end
					setHeight(self,(tbl.height or tbl.height or h)+4)
					if type(source)=="table" then pcall(function()
						self:setPosition(source:getAbsX(),source:getAbsY()+source:getHeight())
						if ho then self:setPo(self:getX()+source:getW(),self:getY()-source:getH()) end
						if self:getY()>self:getParent():getH()-p5-self:getH() then self:setY(source:getAbsY()-self:getH()) end
						if ho then if self:getX()>self:getParent():getW()-p4-self:getW() then self:setPo(source:getAbsX()-self:getW(),self:getY()+source:getHeight()) end end
					end) end
					if self:getX()>self:getParent():getWidth()-p4-self:getWidth() then self:setX(self:getX()-self:getWidth()) end
					if self:getY()>self:getParent():getHeight()-p5-self:getHeight() then self:setY(self:getY()-self:getHeight()) end
				end,
				onUpdate=function(self)
					self:setX(math.max(p2,math.min(self:getParent():getW()-p4-self:getW(),self:getX())))
					self:setY(math.max(p3,math.min(self:getParent():getH()-p5-self:getH(),self:getY())))
				end
			} end
			loadMenuItems(source,actions)
		end,
		onClick=function(self) playClickSound() self:delete() end
	}
end
createDialog=function(tbl)
	local tbl3=table.copy(tbl)
	tbl3.onInit=function(self,...)
		local tbl2=self
		local tbl4=table.copy(self)
		local parent=tbl2.content:getParent():getParent()
		local op=tbl2.content:getParent()
		local parent2=parent:addPanel {
			w=op:getWidth(),h=op:getHeight(),
			x=op:getX(),y=op:getY(),
			onInit=function(self)
				self:setPadding(3,3,3,3)
				self:addCanvas {
					h=30,
					onDraw=function(self,x,y,w,h)
						
					end
				}
				tbl2.icon=self:addIcon {
					w=30,h=30,
					icon=tbl.icon,
					onUpdate=function(self) self:setWidth(0) if self:getIcon()>=1 then self:setWidth(30) end end,
				}
				tbl2.title=self:addLabel {
					h=30,
					font=Font.BIG,
					text=tbl.title,
					onInit=function(self) self:setAlignment(0.5,0.5) end,
					onUpdate=function(self) pcall(function() self:setX(tbl2.icon:getWidth()) self:setWidth(self:getParent():getClientWidth()-tbl2.closeButton:getWidth()-self:getX()) end) end
				}
				tbl2.closeButton=self:addCanvas {
					h=30,w=30,x=-30,
					onDraw=function(self,x,y,w,h)
						if self:getTouchPoint() or self:isMouseOver() then
							Drawing.setColor(255,255/2,255/2)
							if self:isTouchPointInFocus() then Drawing.setColor(255,0,0) end
						end
						local iw,ih=Drawing.getImageSize(Icon.CLOSE_BUTTON)
						Drawing.drawImage(Icon.CLOSE_BUTTON,x+(w/2)-(iw/2),y+(h/2)-(ih/2))
						Drawing.reset()
					end,
					onInit=function(self) function self:click(...)
						--local e,e2=pcall(function() if type(tbl.onClose)=="function" then tbl.onClose(tbl2) end end)
						--Runtime.postpone(function() assert(e,e2) end)
						playClickSound()
						self:getParent():getParent():delete()
					end end,
					onClick=function(self,...) self:click(...) end
				}
				tbl2.text=self:addTextFrame {
					h=-30,y=30,
					text=tbl.text
				}
				tbl2.content=self:addCanvas {y=30}
				tbl2.content:setTouchThrough(true)
				if type(tbl.actions)~="nil" then addHeight(tbl2.content,-30) end
				tbl2.controls=self:addLayout {
					h=30,y=-30,
					onInit=function(self) local actions=tbl.actions if type(tbl.actions)=="table" then
						local function addButton(v)
							local autoClose=v.autoClose or type(v.autoClose)~="boolean" or type(v.autoClose)=="nil"
							return self:getLastPart():addButton {
								w=v.width or v.w or 1,
								h=v.height or v.h,
								icon=v.icon,
								id=v.id,
								text=v.text,
								hotkeys=v.hotkeys,
								onInit=function(_,...) if type(v.onInit)=="function"then v.onInit(tbl2,...); end; end,
								onUpdate=function(_,...)
									self:setPosition(self:getX(),self:getY())
									if type(v.onUpdate)=="function"then v.onUpdate(tbl2,...); end;
								end,
								onClick=function(_,...)
									local e,e2=pcall(function(...) if type(v.onClick)=="function"then v.onClick(...) end end,tbl2,...)
									Runtime.postpone(function() if not e then error(e2,3) end end)
									if autoClose then tbl2.close() end
								end,
								enabled=v.enabled,
							}
						end
						if #actions>=1 then
							for _,v in ipairs(actions) do addButton(v) end
						elseif next(actions) then addButton(actions) end
					end end
				}
				self:addCanvas {
					w=0,h=0,
					onInit=function(self) self:addHotkey(Keys.ESCAPE) self:setX(self:getParent():getWidth()) end,
					onClick=function(self) self:getParent():getParent():delete() end
				}:setTouchThrough(true)
				--pcall(function() tbl2.icon:matchXYWH(tbl4.icon) end)
				--pcall(function() tbl2.title:matchXYWH(tbl4.title) end)
				--pcall(function() tbl2.text:matchXYWH(tbl4.text) end)
				--pcall(function() tbl2.content:matchXYWH(tbl4.content) end)
				--pcall(function() tbl2.controls:matchXYWH(tbl4.controls) end)
			end,
		}
		op:delete()
		local e,e2=pcall(function(...) if type(tbl.onInit)=="function" then tbl.onInit(tbl2,...) end end,...)
		local y=parent2:getY()
		local y2=parent:getHeight()-y
		setY(parent2,parent:getHeight())
		parent2:setAlpha(0)
		Runtime.postpone(function()
			local tt=Runtime.getTime()
			local e e=function()
				local ttt=math.min(1,(Runtime.getTime()-tt)/300)
				if not TheoTown.SETTINGS.uiAnimations then ttt=1 end
				setY(parent2,parent:getHeight()-(y2*ttt))
				parent2:setAlpha(ttt)
				if ttt<1 then Runtime.postpone(function() e() end) end
			end
			e()
		end)
		assert(e,e2)
	end
	local tbl2
	tbl2=GUI.createDialog2 (tbl3)
	pcall(function() local c=GUI.get("toasts") if type(c)=="table" then c:setChildIndex(c:getParent():countChildren()+1) end end)
	return tbl2
end
createRenameDialog=function(tbl)
	local value=""
	if type(tbl.value)~="nil" then value=tbl.value or "" end
	local okButton
	return GUI.createDialog {
		icon=tbl.icon,
		title=tbl.title,
		text=tbl.text,
		w=tbl.width or tbl.w,
		h=tbl.height or tbl.h,
		onInit=function(self,...)
			self.controls:getLastPart():addButton {
				icon=tbl.okIcon or Icon.OK,
				text=tbl.okText or "Rename",
				onUpdate=function(self) if type(tbl.filter)=="function" then self:setEnabled(tbl.filter(value)) end end,
				onClick=function(self)
					local e,e2=true,""
					if type(tbl.onOk)=="function" then e,e2=pcall(function() tbl.onOk(value) end) end
					Runtime.postpone(function() assert(e,e2) end)
					self:getParent():getParent():getParent():getParent():delete()
				end
			}
			self.input=self.content:addTextField {y=15,h=30,text=value,onUpdate=function(self) value=self:getText() end}
			if type(tbl.onInit)=="function" then tbl.onInit(self,...) end
		end,
		onUpdate=function(...)
			if type(tbl.onUpdate)=="function" then tbl.onUpdate(...) end
		end,
		actions={
			{
				icon=tbl.cancelIcon or Icon.CANCEL,
				text=tbl.cancelText or "Cancel",
				onClick=function() if type(tbl.onCancel)=="function" then tbl.onCancel() end end
			},
		},
		pause=tbl.pause,
		onClose=function(...)
			if type(tbl.onClose)=="function" then tbl.onClose(...) end
		end,
	}
end
createSelectDraftDialog=function(tbl)
	local d=tbl.drafts
	if type(d)~="table" then d={} end
	local s={}
	if type(tbl.selection)=="table" then for i,v in pairs(tbl.selection) do s[i]=v:getId() end end
	local minS=tbl.minSelection or 0
	local maxS=math.max(1,tbl.maxSelection or 3)
	GUI.createDialog {
		w=250,h=300,
		onClose=function()
			local s2={}
			for i,v in ipairs(s) do s2[i]=Draft.getDraft(v) end
			tbl.onSelect(Array(s2))
		end
	}
	.content:addListBox {
		onInit=function(self)
			for _,v in pairs(d) do
				self:addCanvas {
					h=30,
					onDraw=function(self,x,y,w,h)
						pcall(function() City.createDraftDrawer(v).draw(x,y,math.min(30,h),h) end)
						local t=v:getTitle()
						local tw,th=Drawing.getTextSize(t)
						Drawing.setColor(autoGetColor())
						Drawing.drawText(t,x+math.min(30,h),y+(h/2)-(th/2))
						Drawing.setColor(255,255,255)
					end,
					onInit=function(self)
						self:addButton {
							h=30,w=30,icon=Icon.PLUS,
							onUpdate=function(self)
								setX(self,self:getParent():getWidth()-self:getWidth()-5)
								local i=table.find(s,v:getId())
								if i then self:setText(i) self:setIcon(0)
								else self:setText("") self:setIcon(Icon.PLUS) end
								setWidth(self,30)
							end,
							onClick=function()
								local i=table.find(s,v:getId())
								if i then if #s>minS then table.remove(s,i) end
								else table.insert(s,v:getId()) while #s>maxS do table.remove(s,1) end end
							end
						}
					end
				}
			end
		end
	}
end
resetDrawing=function()
	reset2()
	Drawing.setColor(255,255,255)
	Drawing.setAlpha(1)
end
drawNinePatch=function(...)
	local f,x,y,w,h,c=...
	pcall(function() if type(f)=="string" then f=tonumber(f) or f end end)
	if --{
		(type(f)=="number" or type(f)=="string" or type(f)=="table") and
		type(x)=="number" and
		type(y)=="number" and
		type(w)=="number" and
		type(h)=="number" --}
	then
		pcall(function()
			local draft
			if type(f)=="string" then draft=Draft.getDraft(f)
			elseif type(f)=="table" then draft=f end
			if type(draft)=="table" then f=Draft.getFrame(draft,1) end
		end)
		f=tonumber(f) or 2
		local topLeft,topCenter,topRight=f,f+1,f+2
		local left,center,right=f+3,f+4,f+5
		local bottomLeft,bottomCenter,bottomRight=f+6,f+7,f+8
		local iw,ih=--{
			function(f) return Drawing.getImageSize(f) end,
			function(f) return select(2,Drawing.getImageSize(f)) end--}
		do
			Drawing.drawImageRect(topLeft,x,y,math.min(iw(topLeft),w/2,h/2),math.min(ih(topLeft),h/2,w/2))
			Drawing.drawImageRect(topCenter,x+math.min(iw(topLeft),w/2,h/2),y,math.max(w-math.min(iw(topLeft),w/2,h/2)-math.min(iw(topRight),w/2,h/2),0),math.min(ih(topCenter),h/2,w/2))
			Drawing.drawImageRect(topRight,x+w-math.min(iw(topRight),w/2,h/2),y,math.min(iw(topRight),h/2,w/2),math.min(ih(topRight),h/2,w/2))
			Drawing.drawImageRect(left,x,y+math.min(ih(topLeft),h/2,w/2),math.min(iw(left),w/2,h/2),math.max(h-math.min(ih(topLeft),h/2,w/2)-math.min(ih(bottomLeft),h/2,w/2),0))
			if not c then Drawing.drawImageRect(center,x+math.min(iw(left),w/2,h/2),y+math.min(ih(topCenter),h/2,w/2),math.max(w-math.min(iw(left),w/2,w/2)-math.min(iw(right),w/2,h/2),0),math.max(h-math.min(ih(topCenter),h/2,w/2)-math.min(ih(bottomCenter),h/2,w/2),0)) end
			Drawing.drawImageRect(right,x+w-math.min(iw(right),w/2,h/2),y+math.min(ih(topRight),h/2,w/2),math.min(iw(right),w/2,h/2),math.max(h-math.min(ih(topRight),h/2,w/2)-math.min(ih(bottomRight),h/2,w/2),0))
			Drawing.drawImageRect(bottomLeft,x,y+h-math.min(ih(bottomLeft),h/2,w/2),math.min(iw(bottomLeft),w/2,h/2),math.min(ih(bottomLeft),h/2,w/2))
			Drawing.drawImageRect(bottomCenter,x+math.min(iw(bottomLeft),w/2,h/2),y+h-math.min(ih(bottomCenter),h/2,w/2),math.max(w-math.min(iw(bottomLeft),w/2,h/2)-math.min(iw(bottomRight),w/2,h/2),0),math.min(ih(bottomCenter),h/2))
			Drawing.drawImageRect(bottomRight,x+w-math.min(iw(bottomRight),w/2,h/2),y+h-math.min(ih(bottomRight),h/2,w/2),math.min(iw(bottomRight),w/2,h/2),math.min(ih(bottomRight),h/2,w/2))
		end
	--{
		elseif select("#",...)>=5 then error("bad argument #5 number expected, got "..type(h))
		elseif select("#",...)==4 and type(w)=="number" then error("bad argument #5 number expected, got no value")
		elseif select("#",...)==4 then error("bad argument #4 number expected, got "..type(w))
		elseif select("#",...)==3 and type(y)=="number" then error("bad argument #4 number expected, got no value")
		elseif select("#",...)==3 then error("bad argument #3 number expected, got "..type(y))
		elseif select("#",...)==2 and type(x)=="number" then error("bad argument #3 number expected, got no value")
		elseif select("#",...)==2 then error("bad argument #2 number expected, got "..type(x))
		elseif select("#",...)==1 and (type(f)=="number" or type(f)=="string" or type(f)=="table") then error("bad argument #2 number expected, got no value")
		elseif select("#",...)==1 then error("bad argument #1 table or string or number expected, got "..type(f)) --}
	else error("bad argument #1 table or string or number expected, got no value") end
end
function script:buildCityGUI(s) script:enterStage(s) end
function script:enterStage(s)
	if (type(GUI.createDialog2)~="function") then GUI.createDialog2=GUI.createDialog end
	if type(addCanvas2)~="function" then addCanvas2=GUI.addCanvas end
	if type(addTextField2)~="function" then addTextField2=GUI.addTextField end
	if type(setClipping2)~="function" then setClipping2=Drawing.setClipping end
	if type(reset2)~="function" then reset2=Drawing.reset end
	if type(resetClipping2)~="function" then resetClipping2=Drawing.resetClipping end
	resetClipping()
	Drawing.setClipping=setClipping
	Drawing.getClipping=getClipping
	Drawing.resetClipping=resetClipping
	Drawing.reset=resetDrawing
	Drawing.getAbsoluteColor=function() local r,g,b=Drawing.getColor() return r+g+b end
	Drawing.drawNinePatch=drawNinePatch
	Drawing.drawTextOutline=function(text,x,y,font,w,...)
		w=tonumber(w) or 1
		w=w*0.2
		local r,g,b=Drawing.getColor()
		Drawing.setColor(255-r,255-g,255-b)
		local sx,sy=Drawing.getScale()
		--local ss=0.45
		local ss=1
		local i=1
		while i<=w+1 do
			local tww=0
			for v in text:gmatch(".") do
				local s=sx*i,sx*i
				local tw,th=Drawing.getTextSize(v,font)
				tw=tw*sx,th*sx
				Drawing.setScale(sx*s,sy*s)
				local sx2,sy2=Drawing.getScale()
				Drawing.drawText(v,x+tww+(tw*0.5)-((tw*sx2)*0.5),y+(th*0.5)-((th*sy2)*0.5),font,...)
				tww=tww+tw
			end
			i=i+0.01
		end
		Drawing.setColor(r,g,b)
		Drawing.setScale(sx,sy)
		Drawing.drawText(text,x,y,font,...)
	end
	GUI.getSize=function(self) return GUI.getWidth(self),GUI.getHeight(self) end
	GUI.getClientSize=function(self) return GUI.getClientWidth(self),GUI.getClientHeight(self) end
	GUI.getAbsPosition=function(self) return GUI.getAbsoluteX(self),GUI.getAbsoluteY(self) end
	GUI.getAbsX=function(self) return GUI.getAbsoluteX(self) end
	GUI.getAbsY=function(self) return GUI.getAbsoluteY(self) end
	GUI.getPosition=function(self) return GUI.getX(self),GUI.getY(self) end
	GUI.getPo=GUI.getPosition
	GUI.setPo=function(self,...) return self:setPosition(...) end
	GUI.setX=function(self,x) return self:setPo(x,self:getY()) end
	GUI.setY=function(self,y) return self:setPo(self:getX(),y) end
	GUI.setWidth=function(self,w) return self:setSize(w,self:getHeight()) end
	GUI.getW=function(self) return self:getWidth() end
	GUI.getCW=function(self) return self:getClientWidth() end
	GUI.setHeight=function(self,h) return self:setSize(self:getWidth(),h) end
	GUI.getH=function(self) return self:getHeight() end
	GUI.getCH=function(self) return self:getClientHeight() end
	GUI.setXYWH=function(self,x,y,w,h) return self:setPosition(x,y),self:setSize(w,h) end
	GUI.matchXYWH=function(self,d) return self:setPosition(d:getPosition()),self:setSize(d:getSize()) end
	GUI.getAlpha=function(...)
		local self=...
		if type(self)=="table" then
			local a=self.alpha
			if type(a)=="function" then a=a() end
			a=tonumber(a) or 1
			local a2=tonumber(self.alpha2) or 1
			return math.max(0,math.min(1,a*a2*settings.alpha))
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	GUI.setAlpha=function(...)
		local self,a=...
		if type(self)=="table" then self.alpha=tonumber(a) or 1
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	GUI.setParent=function(...)
		local self,p=...
		if type(self)=="table" then
			if type(p)~="table" then p=GUI.getRoot() end
			local clone clone=function(pp,p)
				local c=p:addCanvas {
					id=GUI.getId(pp),
					onInit=pp.onInit,
					onDraw=pp.onDraw,
					onUpdate=pp.onUpdate,
					onClick=pp.onClick,
					alpha=pp.alpha,
					minValue=pp.minValue,
					maxValue=pp.maxValue,
					getValue=pp.getValue0,
					getText=pp.getText0,
					setValue=pp.setValuep,
				}
				c:setSize(pp:getW(),pp:getH())
				c:setPosition(pp:getX(),pp:getY())
				c.orig2=pp.orig
				pcall(function() c:setIcon(pp:getIcon()) end)
				pcall(function() c:setText(pp:getText()) end)
				pcall(function() c:setAlignment(pp:getAlignment()) end)
				pcall(function()
					local tbl=pp:getObjects()
					local tbl2=c:getObjects()
					local i=1
					while i<#tbl do
						local v=tbl[i]
						local v2
						pcall(function() v2=table.find(tbl2,v):getId()==v:getId() end)
						if v2 then table.remove(tbl,i) end
						i=i+1
					end
					for _,v in pairs(tbl) do pcall(function()
						local e=true
						if e then clone(v,c) end
					end) end
				end)
				--c.orig=pp.orig
				--pp:delete()
				return c
			end
			local c=clone(self,p)
			self:delete()
			return c
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	GUI.getHotkeys=function(...)
		local self=...
		if type(self)=="table" then
			local hotkeys={}
			for _,hotkey in pairs(Keys) do
				if self:removeHotkey(hotkey) then
					self:addHotkey(hotkey)
					table.insert(hotkeys,hotkey)
				end
			end
			return hotkeys
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	GUI.getObjects=function(...)
		local self=...
		if type(self)=="table" then
			local tbl={}
			if self:countChildren()>=1 then for i=1,self:countChildren() do table.insert(tbl,self:getChild(i)) end end
			return tbl
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	GUI.getAbsObjects=function(...)
		local self=...
		if type(self)=="table" then
			local tbl={}
			local getObjects2 getObjects2=function(p)
				if p:countChildren()>=1 then for i=1,p:countChildren() do
					local c=p:getChild(i)
					table.insert(tbl,c)
					getObjects2(c)
				end end
			end
			getObjects2(self)
			return tbl
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	--Debug.toast(Runtime.toJson(GUI.getRoot():getObjects()))
	--GUI.setAlpha=function(self,a) self.alpha=0.3 end
	GUI.isTouchPointInFocus=function(...)
		local self=...
		if type(self)=="table" then
			local x,y,w,h=GUI.getAbsX(self),GUI.getAbsY(self),GUI.getW(self),GUI.getH(self)
			if GUI.getTouchPoint(self) then
				local xx,yy=GUI.getTouchPoint(self)
				return xx>=x and xx<x+w and yy>=y and yy<y+h
			end
		elseif select("#",...)>=1 then error("bad argument #1 table expected, got "..type(self))
		else error("bad argument #1 table expected, got no value") end
	end
	if gi then
		GUI.addCanvas=addCanvas
		GUI.addPanel=addPanel
		GUI.addButton=addButton
		GUI.addIcon=addIcon
		GUI.addLabel=addLabel
		GUI.addTextFrame=addTextFrame
		GUI.addTextField=addTextField
		GUI.addSlider=addSlider
		GUI.addLayout=addLayout
		GUI.addListBox=addListBox
		GUI.createMenu=createMenu
		GUI.createDialog=createDialog
		GUI.createRenameDialog=createRenameDialog
		GUI.createSelectDraftDialog=createSelectDraftDialog
	end
	if s=="PluginErrorStage" then GUI.getRoot():getChild(1):getChild(3):addButton {
		w=30,h=30,
		text="Restart",
		onClick=function() TheoTown.execute("restart",function() end) end
	} end
	if openSettings2 then openSettings2=nil Runtime.postpone(function() openSettings() end,100) end
	if openGUIExample2 then openGUIExample2=nil Runtime.postpone(function() openGUIExample() end,100) end
end
function script:overlay()
	if type(settings.alpha)=="number" then settings.alpha=math.max(0,math.min(1,settings.alpha)) else settings.alpha=1 end
	pcall(function() GUI.getRoot():setAlpha(settings.alpha) end)
	pcall(function() p2,p3,p4,p5=GUI.getRoot():getPadding() end)
	Drawing.setColor(255,255,0)
	Drawing.setAlpha(settings.colorWarmth or 0)
	Drawing.drawRect(0,0,1000,1000)
	Drawing.reset()
	--table.copy()
end
