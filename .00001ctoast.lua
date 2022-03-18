pcall(function()City.rebuildUI()end)
local p2,p3,p4,p5=0,0,0,0
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
local giAutoGetColor,giGetColor=function()
	local br,bg,bb=0,0,0
	if type(giAutoGetColor)=="function" then br,bg,bb=giAutoGetColor() end
	return br,bg,bb
end,
function()
	local cr,cg,cb=255,255,255
	if type(giGetColor)=="function" then cr,cg,cb=giGetColor() end
	return cr,cg,cb
end
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
local addToast2=function(tbl)
	local c=GUI.get("toasts")
	if type(c)=="table" then
		c:setChildIndex(c:getParent():countChildren()+1)
		return c:addCanvas {
			h=0,
			onInit=function(self)
				self:setX(self:getParent():getWidth())
				self:setTouchThrough(true)
			end,
			onUpdate=function(self)
				local tbl=findToast(tbl.id)
				if not tbl then self:delete() end
			end,
			onDraw=function(self,x,y,w,h)
				local s=0.7
				local y0=0
				local ttt=(Runtime.getTime()-tbl.tt)/1000
				--local uis=TheoTown.SETTINGS.uiSize+0
				--local x,y=(GUI.getRoot():getWidth()-p2-p4)+(50*(((0+uis)/2)*1.6)),p3-1
				local xx=x
				pcall(function() xx=self:getParent():getWidth() end)
				xx=tonumber(xx) or x
				local text=tostring(tbl.text or "")
				local tw,th=Drawing.getTextSize(text,Font.BIG)
				local title=tostring(tbl.title or "")
				local tw2=Drawing.getTextSize(title,Font.BIG)
				tw,th,tw2=tw*s,th*s,tw2*s
				Drawing.setColor(giGetColor())
				local hh=30
				local ii,iii=1,1
				if ttt>=4.7 then iii=1-((ttt-4.7)/0.3)
				else ii=math.min(1,ttt/0.3) end
				do local ii=ii if ttt>0.3 then ii=1 end hh=(30*ii) end
				self:setHeight(hh)
				h=self:getHeight()
				--i=math.min(1,ttt)
				--i=ttt
				local tw3=math.max(tw,tw2)
				local ww=0
				pcall(function() ww=self:getParent():getWidth()-p2-p4-10 end)
				ww=tonumber(ww) or 0
				tw=math.min(ww,tw3)
				local ss=math.min(1,(ww/tw3))
				pcall(function() self:setWidth((tw+10)) end)
				w=self:getWidth()
				pcall(function() self:setX(xx-((w+p4)*iii)) end)
				--y=p3-(31*(1-ii))+hh-30
				--y=math.max(p3,y+hh-30)
				Drawing.setClipping(x,y,w,h)
				Drawing.setAlpha(0.7)
				Drawing.drawRect(x,y,w,h)
				--pcall(function() Drawing.drawNinePatch(Draft.getDraft("$00000gi"):getFrame(1),x,y,w,h) end)
				Drawing.setAlpha(0.5)
				Drawing.setColor(giAutoGetColor())
				drawOutline(x,y,w,h)
				--pcall(function() Drawing.drawNinePatch(Draft.getDraft("$00000gi"):getFrame(10),x,y,w,h) end)
				Drawing.setAlpha(1)
				Drawing.setScale(s,s)
				Drawing.setColor(128,128,128)
				Drawing.drawText(title,x+((tw+10)/2)-(tw/2),y,Font.BIG)
				Drawing.setScale(s*ss,s*ss)
				Drawing.setColor(giAutoGetColor())
				th=th*ss
				Drawing.drawText(text,x+((tw+10)/2)-(tw/2),y+20-(th/2),Font.BIG)
				Drawing.setScale(1,1)
				Drawing.resetClipping()
			end
		}
	end
end
local addToast=function(title,...)
	local texts={}
	for i,v in ipairs(table.pack(...)) do texts[i]=tostring(v or "") end
	local tbl={h=30,title=tostring(title or ""),text=table.concat(texts,"\n"),tt=Runtime.getTime(),att=Runtime.getTime()}
	tbl.id=Runtime.getUuid()
	local e=pcall(function()
		local l=#toasts
		local tt=Runtime.getTime()
		pcall(function() tt=toasts[l].att end)
		local ttt=Runtime.getTime()-tt
		if ttt<300 then
			if #toasts>=1 then
				toasts[l].text=toasts[l].text.."\n" ..table.concat(texts,"\n")
				toasts[l].tt=Runtime.getTime()-300
				toasts[l].att=Runtime.getTime()
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
	Debug.toast(Runtime.getStageName())
end
function script:lateInit() Debug.toast=toast end
function script:enterStage(s)
	pcall(function() GUI.get("toasts"):delete() end)
	local tt=Runtime.getTime()
	GUI.getRoot():addCanvas {
		id="toasts",
		onUpdate=function(self)
			self:setSize(GUI.getRoot():getSize())
			self:setSize(self:getWidth(),self:getHeight())
			self:setPosition(-p2,-p3)
			local ttt=(Runtime.getTime()-tt)/1000
			if ttt>=5 then self:setChildIndex(self:getParent():countChildren()+1) tt=Runtime.getTime() end
			local h=0
			for i=1,self:countChildren() do
				local c=self:getChild(self:countChildren()-i+1)
				h=h+c:getHeight()+1
				c:setY(h-c:getHeight()-1)
			end
		end,
		onInit=function(self)
			for _,tbl in pairs(toasts) do addToast2(tbl) end
		end,
	}:setTouchThrough(true)
	Debug.toast=toast
	--Debug.toast(s)
end
local fps,ofps,tt=0,0,Runtime.getTime()
local function mdd()
	pcall(function() for _,v in pairs(Draft.getDrafts()) do pcall(function()
		
	end) end end)
end
mdd()
function script:overlay()
	pcall(function() while #toasts>30 do table.remove(toasts) end end)
	pcall(function() for i,v in ipairs(toasts) do
		if (Runtime.getTime()-v.tt>5000) or (tostring(v.text or "")=="") then table.remove(toasts,tonumber(i)) end
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
	fps=fps+1
	local ttt=Runtime.getTime()-tt
	if ttt>1000 then tt,ofps,fps=Runtime.getTime(),fps,0 end
	--Drawing.drawText("FPS: "..ofps,0,0,Font.BIG)
	mdd()
	pcall(function()
		--for k,v in pairs(City) do
			--if type(v)=="function" then City[k]=function() end end
			--if type(v)=="table" then City[k]={} end
		--end
	end)
	--Drawing.drawNinePatch(NinePatch.BUTTON,90,90,30,60*ttt)
	--if type(e)=="function" then e() end
end
