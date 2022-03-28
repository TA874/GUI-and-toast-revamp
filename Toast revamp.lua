pcall(function()City.rebuildUI()end)
local p2,p3,p4,p5=0,0,0,0
local giDraft
function script:lateInit() giDraft=Draft.getDraft("$00000gi") end
local function drawOutline(x,y,w,h,s)
	if type(s)~="number" then s=1 end
	Drawing.drawRect(x+s,y,w-(s*2),s)
	Drawing.drawRect(x+s,y+h-s,w-(s*2),s)
	Drawing.drawRect(x,y+s,s,h-(s*2))
	Drawing.drawRect(x+w-s,y+s,s,h-(s*2))
	Drawing.drawRect(x,y,s,s)
	Drawing.drawRect(x,y+h-s,s,s)
	Drawing.drawRect(x+w-s,y,s,s)
	Drawing.drawRect(x+w-s,y+h-s,s,s)
end
local giAutoGetColor,giGetColor,isToastRevampEnabled=function()
	local br,bg,bb=0,0,0
	if type(giAutoGetColor)=="function" then br,bg,bb=giAutoGetColor() end
	return br,bg,bb
end,
function()
	local cr,cg,cb=255,255,255
	if type(giGetColor)=="function" then cr,cg,cb=giGetColor() end
	return cr,cg,cb
end,
function() if type(isToastRevampEnabled)=="function" then return isToastRevampEnabled() end end
if type(toasts)~="table" then toasts={} end
if type(setClipboard2)~="function" then setClipboard2=Runtime.setClipboard end
function table.copy(tbl) if type(tbl)=="table" then
	local tbl2={}
	for k,v in pairs(tbl) do tbl2[k]=v end
	setmetatable(tbl2,getmetatable(tbl))
	return tbl2
end return nil end
table.find=function(tbl,v)
	local i,v2=nil,nil
	for ii,v3 in ipairs(tbl) do
		if tostring(v3)==tostring(v) then i,v2=ii,v3 break end
	end
	return i,v2
end
local function findToast(id)
	local tbl,i=nil,nil
	for ii,v in ipairs(toasts) do
		if v["id"]==id then tbl=v i=ii break end
	end
	return tbl,i
end
local addToast2 addToast2=function(tbl)
	local c=GUI.get("toasts")
	if type(c)=="table" then
		local gth,thh=12,0
		local ww=function() return 0 end
		local dismissButton
		local cc=c:addCanvas {
			h=0,
			onInit=function(self)
				self:setX(self:getParent():getWidth())
				self:setTouchThrough(true)
				local c=self:getParent()
				c:setChildIndex(c:getParent():countChildren()+1)
				dismissButton=self:addCanvas {
					w=0,
					onInit=function(self)
						local s=0.7
						local text="Dismiss"
						local tw,th=Drawing.getTextSize(text,Font.BIG)
						self:setSize(tw*s+5,15)
						ww=function() return self:getWidth() end
					end,
					onUpdate=function(self)
						self:setPo(self:getParent():getW()-self:getW(),0)
					end,
					onDraw=function(self,x,y,w,h)
						local ttt=(Runtime.getTime()-tbl.tt)/1000
						local time=(tonumber(tbl.time) or 1000)/1000
						local startTime=(tonumber(tbl.startTime) or 1000)/1000
						local endTime=(tonumber(tbl.endTime) or 1000)/1000
						if not TheoTown.SETTINGS.uiAnimations then startTime,endTime=0,0 end
						self:setTouchThrough(ttt<startTime and ttt>=startTime+time)
						local s=0.7
						local text="Dismiss"
						local tw,th=Drawing.getTextSize(text,Font.BIG)
						self:setSize(tw*s+5,15)
						w,h=self:getSize()
						Drawing.setColor(giAutoGetColor())
						if (ttt>=startTime and ttt<startTime+time) and (self:getTouchPoint() or self:isMouseOver()) then
							Drawing.setAlpha(0.2)
							if self:getTouchPoint() then Drawing.setAlpha(0.3) end
							Drawing.drawRect(x,y+1,w-1,h-1)
							Drawing.setAlpha(1)
						end
						Drawing.setAlpha(0.5)
						Drawing.setScale(s,s)
						if ttt>=startTime and ttt<startTime+time then Drawing.drawText(text,x+(w*0.5)-((tw*s)*0.5),y+(h*0.5)-((th*s)*0.5),Font.BIG) end
						Drawing.setScale(1,1)
						Drawing.setAlpha(1)
						Drawing.setColor(255,255,255)
					end,
					onClick=function()
						local ttt=Runtime.getTime()-tbl.tt
						local startTime=tonumber(tbl.startTime) or 1000
						local endTime=tonumber(tbl.endTime) or 1000
						if not TheoTown.SETTINGS.uiAnimations then startTime,endTime=0,0 end
						if ttt>=startTime and ttt<startTime+tbl.time then tbl.tt=Runtime.getTime()-(startTime+tbl.time) end
					end
				}
			end,
			onUpdate=function(self)
				local tbl=findToast(tbl.id)
				if not tbl then self:delete() end
			end,
			onDraw=function(self,x,y,w,h)
				self:setWidth(0)
				local s=0.7
				local y0=0
				local ttt=(Runtime.getTime()-tbl.tt)/1000
				local startTime=(tonumber(tbl.startTime) or 1000)/1000
				local endTime=(tonumber(tbl.endTime) or 1000)/1000
				if not TheoTown.SETTINGS.uiAnimations then startTime,endTime=0,0 end
				local time=(tonumber(tbl.time) or 1000)/1000
				local hh=15+thh
				local ii,iii=1,1
				if ttt>=startTime+time then iii=1-((ttt-(startTime+time))/startTime) else ii=math.min(1,ttt/startTime) end
				if ttt>=startTime+endTime+time then ii=1-math.min(1,(ttt-(startTime+endTime+time))/endTime) end
				if not TheoTown.SETTINGS.uiAnimations then ii,iii=1,1 end
				do local ii=ii if ttt>=startTime and ttt<(startTime+endTime+time) then ii=1 end hh=(hh*ii) end
				self:setHeight(hh)
				h=self:getHeight()
				Drawing.setClipping(x,y,w,h)
				Drawing.setAlpha(0.7)
				Drawing.setColor(giGetColor())
				Drawing.drawRect(x,y,w,h)
				--pcall(function() Drawing.drawNinePatch(Draft.getDraft("$00000gi"):getFrame(1),x,y,w,h) end)
				Drawing.setAlpha(0.5)
				Drawing.setColor(giAutoGetColor())
				drawOutline(x,y,w,h)
				--pcall(function() Drawing.drawNinePatch(Draft.getDraft("$00000gi"):getFrame(10),x,y,w,h) end)
				local xx=x
				pcall(function() xx=self:getParent():getWidth() end)
				xx=tonumber(xx) or x
				local title=tostring(tbl.title or "")
				Drawing.setAlpha(1)
				Drawing.setScale(s,s)
				Drawing.setColor(giAutoGetColor())
				Drawing.setAlpha(0.5)
				local tw=Drawing.getTextSize(title,Font.BIG)
				self:setWidth(math.max(self:getWidth(),tw+10+ww()))
				w=self:getWidth()
				Drawing.drawText(title,x+5,y,Font.BIG)
				Drawing.setAlpha(1)
				local function drawText(text,x,y)
					local text=tostring(text or "")
					local tw,th=Drawing.getTextSize(text,Font.BIG)
					local tw2=Drawing.getTextSize(title,Font.BIG)
					tw,th,tw2=tw*s,th*s,tw2*s
					Drawing.setColor(giGetColor())
					--i=math.min(1,ttt)
					--i=ttt
					local tw3=math.max(tw,tw2)
					local ww=0
					pcall(function() ww=self:getParent():getWidth()-p2-p4-10 end)
					ww=tonumber(ww) or 0
					tw=math.min(ww,tw3)
					local ss=math.min(1,(ww/tw3))
					pcall(function() self:setWidth(math.max(self:getWidth(),(tw+10))) end)
					w=self:getWidth()
					pcall(function() self:setX(xx-((w+p4)*iii)) end)
					Drawing.setScale(s*ss,s*ss)
					Drawing.setColor(giAutoGetColor())
					th=th*ss
					Drawing.drawText(text,x+((tw+10)/2)-(tw/2),y-(th/2),Font.BIG)
					Drawing.setScale(1,1)
				end
				local texts=tbl.text:split("\n")
				while #texts>70 do table.remove(texts) end
				thh=gth*#texts
				for i,text in ipairs(texts) do drawText(text,x,y+6+(gth*i)) end
				Drawing.resetClipping()
			end
		}
	end
end
local addToast=function(title,...)
	local texts={}
	for i,v in ipairs{...} do texts[i]=tostring(v or type(v)=="nil" and "") end
	local tbl={h=30,startTime=300,endTime=300,time=8000,title=tostring(title or ""),text=table.concat(texts,"\n"),tt=Runtime.getTime(),att=Runtime.getTime()}
	tbl.id=Runtime.getUuid()
	local e=pcall(function()
		local l=#toasts
		local tt=Runtime.getTime()
		pcall(function() tt=toasts[l].att end)
		local ttt=Runtime.getTime()-tt
		if ttt<300 then
			if #toasts>=1 then
				if toasts[l].title==tbl.title then
					toasts[l].text=table.concat(texts,"\n").."\n" ..toasts[l].text
					if Runtime.getTime()-toasts[l].tt>300 then toasts[l].tt=Runtime.getTime()-300 end
					toasts[l].att=Runtime.getTime()
				else table.insert(toasts,tbl) end
			else table.insert(toasts,tbl) end
		else table.insert(toasts,tbl) end
	end)
	if not e then table.insert(toasts,tbl) end
	pcall(function() addToast2(tbl) end)
	return table.concat(texts," ")
end
giAddToast=function(...) return addToast(...) end
local setClipboard=function(...)
	local texts={}
	for i,v in ipairs(table.pack(...)) do texts[i]=tostring(v or "") end
	setClipboard2(table.concat(texts," "))
	texts=nil
	return addToast("Copied to clipboard",...)
end
Runtime.setClipboard=setClipboard
local toast=function(...) addToast("Toast",...) end
function script:buildCityGUI()
	--Debug.toast(Runtime.getStageName())
end
local function mdd()
	pcall(function() for _,v in pairs(Draft.getDrafts()) do pcall(function()
	end) end end)
	--Debug.toast(pcall(function() return tostring(Draft.getDraft("$prison00").orig.upgrades) end))
end
function script:enterStage(s)
	pcall(function() GUI.get("toasts"):delete() end)
	local tt=Runtime.getTime()
	if type(toast0)~="function" then toast0=Debug.toast end
	if isToastRevampEnabled() then
		GUI.getRoot():addCanvas {
			id="toasts",
			onUpdate=function(self)
				self:setSize(GUI.getRoot():getSize())
				self:setPosition(-p2,-p3)
				local c=GUI.get("roottoolbar")
				if c then if c:isVisible() and c:getChild(1) then self:setY(self:getY()+c:getChild(1):getHeight()) end end
				self:setSize(self:getWidth(),self:getHeight()-self:getY())
				local ttt=(Runtime.getTime()-tt)/1000
				if ttt>=5 then self:setChildIndex(self:getParent():countChildren()+1) tt=Runtime.getTime() end
				local h=0
				for i=1,self:countChildren() do
					local c=self:getChild(self:countChildren()-i+1)
					h=h+c:getHeight()+1
					c:setY(p3+(h-c:getHeight()-1))
				end
			end,
			onInit=function(self)
				for _,tbl in pairs(toasts) do addToast2(tbl) end
				Runtime.postpone(function() self:setChildIndex(self:getParent():countChildren()+1) end)
			end,
		}:setTouchThrough(true)
		Debug.toast=toast
	else Debug.toast=toast0 end
	--Debug.toast(s)
end
mdd()
local function generateId()
	local s=("abdeof"):rep(2).."eeaad"
	--local s="qwertyuiopasdfghjklzxcvbnm"
	s=s.."0123456789"
	local tbl,tbl2={},{}
	for v in s:gmatch(".") do
		tbl[#tbl+1]=v
	end
	for _=1,8 do
		local v,i=tbl[math.random(1,#tbl)],math.random(0,1)
		if i==1 then v=v:upper() end
		tbl2[#tbl2+1]=v
	end
	tbl2[#tbl2+1]="-"
	for _=1,4 do
		local v,i=tbl[math.random(1,#tbl)],math.random(0,1)
		if i==1 then v=v:upper() end
		tbl2[#tbl2+1]=v
	end
	tbl2[#tbl2+1]="-"
	for _=1,4 do
		local v,i=tbl[math.random(1,#tbl)],math.random(0,1)
		if i==1 then v=v:upper() end
		tbl2[#tbl2+1]=v
	end
	tbl2[#tbl2+1]="-"
	for _=1,4 do
		local v,i=tbl[math.random(1,#tbl)],math.random(0,1)
		if i==1 then v=v:upper() end
		tbl2[#tbl2+1]=v
	end
	tbl2[#tbl2+1]="-"
	for _=1,10 do
		local v,i=tbl[math.random(1,#tbl)],math.random(0,1)
		if i==1 then v=v:upper() end
		tbl2[#tbl2+1]=v
	end
	return table.concat(tbl2)
end
local tt,ott=Runtime.getTime()
local fps,f=0
function script:overlay()
	pcall(function() while #toasts>30 do table.remove(toasts) end end)
	pcall(function() for i,v in ipairs(toasts) do
		local time=tonumber(v.time) or 1000
		local startTime=tonumber(v.startTime) or 1000
		local endTime=tonumber(v.endTime) or 1000
		if not TheoTown.SETTINGS.uiAnimations then startTime,endTime=0,0 end
		local ii=startTime+endTime+endTime
		if (Runtime.getTime()-v.tt>ii+time) then table.remove(toasts,tonumber(i)) end
	end end)
	pcall(function() p2,p3,p4,p5=GUI.getRoot():getPadding() end)
	local ttt=(Runtime.getTime()%20000)/20000
	local tttt=ttt
	if ttt>0.5 then ttt=1-ttt end
	local function np()
		local i=0
		for _ in pairs(NinePatch) do i=i+1 end
		local ii=0
		for k in pairs(NinePatch) do
			ii=ii+1
			if ii==2 then return NinePatch[k] end
		end
	end
	if Util.optStorage(TheoTown.getStorage(),giDraft:getId()).showFPSCounter then
		ott=Runtime.getTime()
		fps=0
		local i=ott-tt
		fps=math.floor(1000/i)
		tt=Runtime.getTime()
		Drawing.setColor(255,255,255)
		local text="FPS: "..fps
		local tw,th=Drawing.getTextSize(text)
		Drawing.setColor(0,0,0) Drawing.setAlpha(0.7)
		local x,y=p2+5,p3+5
		Drawing.drawRect(x,y,tw,th)
		Drawing.setColor(255,255,255) Drawing.setAlpha(1)
		Drawing.drawTextOutline(text,x,y)
	end
	pcall(function()
		--for k,v in pairs(City) do
			--if type(v)=="function" then City[k]=function() end end
			--if type(v)=="table" then City[k]={} end
		--end
	end)
	--Drawing.drawNinePatch(NinePatch.BUTTON,90,90,30,60*ttt)
	--if type(e)=="function" then e() end
	--error(Runtime.getUuid())
	--Debug.toast(Runtime.getUuid())
	--Debug.toast(generateId())
	--Debug.toast(".")
	f()
end
local tbl={}
local s={{1,""}}
local s2="0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
for v in s2:gmatch(".") do table.insert(tbl,v) end
local i=1
f=function()
	local ss ss=function(i) if i<=#s then
		local vv=s[i]
		local v=tbl[vv[1]]
		vv[2]=v
		vv[1]=vv[1]+1
		if vv[1]>#tbl then
			vv[1]=1
			if i>=#s then table.insert(s,{1,""}) end
			ss(i+1)
		end
	end end 
	ss(1)
	local s3=""
	for i,vv in ipairs(s) do
		s3=vv[2]..s3
	end
	--Drawing.drawText(s3,100,100)
end
