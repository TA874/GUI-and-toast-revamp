function drawOutline(x,y,w,h)
	Drawing.drawRect(x,y,w,1)
	Drawing.drawRect(x,y+h-1,w,1)
	Drawing.drawRect(x,y,1,h)
	Drawing.drawRect(x+w-1,y,1,h)
end
local createDialog,addButton,addPanel,addIcon,addCheckBox
local addLabel,addTextFrame,addSlider,addTextField
local addListBox,addLayout,createRenameDialog,createSelectDraftDialog
local darkUIMode=function()
	local b
	pcall(function()
		if TheoTown.darkUIMode then
			b=TheoTown.darkUIMode()
		end
	end)
	return b
end
table.find=function(self,e,p)
	p=p or 1
	p=math.min(p,#self)
	local i
	local ii=false
	for i2=p,#self do
		local ee
		pcall(function()
			ee=self[i2]==e
		end)
		if ee then
			i=i2
			ii=true
			break
		end
	end
	return i,ii
end
function script:buildCityGUI()
	pcall(function()
		Debug.toast(type(TheoTown.SETTINGS.animations))
	end)
	script:enterStage()
end
function script:enterStage()
	--for k in pairs(GUI)do
		--if type(GUI[k])=="function" and k~="addGadget" then
			--GUI[k]=function()end
		--end
	--end
	local paddingLeft,paddingTop,paddingRight,paddingBottom
	pcall(function()
		paddingLeft,paddingTop,paddingRight,paddingBottom=GUI.getRoot():getPadding()
	end)
	addButton=function(self,tbl)
		local text=tbl.text or""
		local icon=tbl.icon or 0
		return self:addCanvas{
			w=10,
			h=10,
			onInit=function(self,...)
				self.type="button"
				pcall(function()
					if tbl.id then
						self:setId(tbl.id)
					end
					self:setPosition(tbl.x or 0,tbl.y or 0)
				end)
				function self:click(...)
					TheoTown.playSound(Draft.getDraft("$click_sound00"),1.3)
					tbl.onClick(self,...)
				end
				function self:getText()
					return text
				end
				function self:setText(s)
					text=s
				end
				function self:getIcon()
					return icon
				end
				function self:setIcon(s)
					icon=s
				end
				self:setSize(10,10)
				pcall(function()
					local iw,ih=Drawing.getImageSize(icon)
					self:setSize(math.max(self:getWidth(),iw),math.max(self:getHeight(),ih))
					self:setSize(math.min(self:getWidth(),ih),math.min(self:getHeight(),iw))
				end)
				pcall(function()
					local text=tostring(text)
					local tw=Drawing.getTextSize(text)
					if text:len()>0 then
						--tw=tw or 0
						self:setSize(self:getWidth()+tw+10,self:getHeight())
					end
				end)
				pcall(function()
					pcall(function()
						if self:getX()<0 then
							self:setPosition((0+self:getParent():getWidth())+self:getX(),self:getY())
						end
					end)
					pcall(function()
						if self:getY()<0 then
							self:setPosition(self:getX(),(0+self:getParent():getHeight())+self:getY())
						end
					end)
				end)
				pcall(function()
					self:setSize(math.max(self:getWidth(),tbl.width or tbl.w or(self:getParent():getClientWidth()-self:getX())),tbl.height or tbl.h or(self:getParent():getClientHeight()-self:getY()))
				end)
				pcall(function()
					local enabled=true
					if tbl.enabled then
						enabled=tbl.enabled
					end
					self:setEnabled(enabled)
				end)
				if tbl.onInit then
					tbl.onInit(self,...)
				end
			end,
			onUpdate=function(...)
				local t2=table.pack(...)
				if tbl.onUpdate then
					pcall(function()
						tbl.onUpdate(table.unpack(t2))
					end)
				end
			end,
			onClick=function(self,...)
				self:click(...)
			end,
			onDraw=function(self,x,y,w,h)
				do
					pcall(function()
						local parent,ir=self:getParent()
						pcall(function()
							ir=parent==GUI.getRoot()
						end)
						while parent.type~="listBox" and not ir do
							parent=parent:getParent()
						end
						if parent.type=="listBox" then
							Drawing.setClipping(parent:getAbsoluteX()+1,parent:getAbsoluteY()+1,parent:getWidth()-2,parent:getHeight()-2)
						end
					end)
				end
				if tbl.clipping then
					Drawing.setClipping(tbl.clipping())
				end
				local text=text
				local isPressed=tbl.isPressed
				if type(isPressed)=="function" then
					pcall(function()
						isPressed=isPressed()
					end)
				end
				if type(text)=="function" then
					pcall(function()
						text=text()
					end)
				end
				text=tostring(text)
				local dc,dc2=0,225
				if darkUIMode()then
					dc=255
					dc2=30
				end
				local tw,th=0,0
				pcall(function()
					tw,th=Drawing.getTextSize(text)
				end)
				pcall(function()
					if tbl.golden then
						Drawing.setColor(dc,dc,dc)
					else
						Drawing.setColor(dc2,dc2,dc2)
					end
				end)
				do
					local r,g,b=Drawing.getColor()
					local a=Drawing.getAlpha()
					if tbl.color then
						local rr,gg,bb,aa=tbl.color()
						Drawing.setColor(rr or r,gg or g,bb or b)
						Drawing.setAlpha(aa or a)
					end
				end
				if not self:isEnabled()then
					Drawing.setAlpha(Drawing.getAlpha()/2)
				end
				Drawing.drawRect(x,y,w,h)
				pcall(function()
					if tbl.golden then
						Drawing.setColor(dc2,dc2,dc2)
					else
						Drawing.setColor(dc,dc,dc)
					end
				end)
				Drawing.setAlpha(1)
				if (self:getTouchPoint()or self:isMouseOver()or isPressed)and self:isEnabled()then
					if self:getTouchPoint()then
						Drawing.setAlpha(0.3)
					elseif isPressed then
						Drawing.setAlpha(0.25)
					elseif self:isMouseOver()then
						Drawing.setAlpha(0.2)
					end
					Drawing.drawRect(x,y,w,h)
				end
				Drawing.reset()
				do
					local iw,ih=Drawing.getImageSize(icon)
					local hx,hy=Drawing.getImageHandle(icon)
					local xx=x+(w/2)-(iw/2)
					if text:len()>1 then
						xx=x+(30/2)-(iw/2)
					end
					if not self:isEnabled()then
						Drawing.setAlpha(Drawing.getAlpha()/2)
					end
					Drawing.drawImage(icon,xx+hx,(y+(h/2)-(ih/2))+hy)
				end
				Drawing.reset()
				do
					local xx=x+(w/2)-(tw/2)
					if icon>0 then
						xx=x+30
					end
					pcall(function()
						if tbl.golden then
							Drawing.setColor(dc2+30,dc2+30,dc2+30)
						else
							Drawing.setColor(dc,dc,dc)
						end
					end)
					local r,g,b=Drawing.getColor()
					local a=Drawing.getAlpha()
					if tbl.textColor then
						local rr,gg,bb,aa=tbl.textColor()
						Drawing.setColor(rr or r,gg or g,bb or b)
						Drawing.setAlpha(aa or a)
					end
					if not self:isEnabled()then
						Drawing.setAlpha(Drawing.getAlpha()/2)
					end
					Drawing.drawText(text,xx,y+(h/2)-(th/2))
					Drawing.setColor(r,g,b)
				end
				Drawing.setColor(dc,dc,dc)
				Drawing.setAlpha(1)
				if tbl.outlineColor then
					local r,g,b,a=tbl.outlineColor()
					Drawing.setColor(r or dc,g or dc,b or dc)
					Drawing.setAlpha(a or 1)
				end
				if not self:isEnabled()then
					Drawing.setAlpha(Drawing.getAlpha()/2)
				end
				drawOutline(x,y,w,h)
				Drawing.resetClipping()
				Drawing.reset()
			end
		}
	end
	GUI.addButton=addButton
	addLabel=function(self,tbl)
		local text=tbl.text or""
		local r,g,b
		local alignX,alignY=0,0.5
		local font=tbl.font or Font.DEFAULT
		local rgb=function()
			if darkUIMode()then
				return 255,256,255
			else
				return 0,0,0
			end
		end
		return self:addCanvas{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onInit=function(self,...)
				pcall(function()
					self.type="label"
					if tbl.id then
						self:setId(tbl.id)
					end
					function self:getText()
						return text
					end
					function self:setText(s)
						text=s
					end
					function self:setFont(s)
						font=s
					end
					function self:getFont()
						return font
					end
					function self:setColor(rr,gg,bb)
						r,g,b=rr,gg,bb
					end
					function self:setAlignment(a1,a2)
						alignX,alignY=a1 or 0,a2 or 0
					end
					function self:getAlignment()
						return alignX,alignY
					end
					self:setTouchThrough(true)
					pcall(function()
						self:setPosition(tbl.x or 0,tbl.y or 0)
					end)
					pcall(function()
						self:setSize(tbl.width or tbl.w or(self:getParent():getClientWidth()-self:getX()),tbl.height or tbl.h or(self:getParent():getClientHeight()-self:getY()))
					end)
				end)
				if tbl.onInit then
					tbl.onInit(self,...)
				end
			end,
			onDraw=function(self,x,y,w,h)
				do
					pcall(function()
						local parent,isRoot=self:getParent()
						pcall(function()
							isRoot=parent==GUI.getRoot()
						end)
						while parent.type~="listBox" and not isRoot do
							parent=parent:getParent()
						end
						if parent.type=="listBox" then
							Drawing.setClipping(parent:getAbsoluteX()+1,parent:getAbsoluteY()+1,parent:getWidth()-2,parent:getHeight()-2)
						end
					end)
				end
				local text=tostring(text)
				Drawing.setColor(rgb())
				pcall(function()
					Drawing.setColor(r,g,b)
				end)
				local tw,th=Drawing.getTextSize(text,font)
				Drawing.drawText(text,x+(w*alignX)-(tw*alignX),y+(h*alignY)-(th*alignY),font)
				Drawing.resetClipping()
			end,
			onUpdate=function(...)
				if tbl.onUpdate then
					tbl.onUpdate(...)
				end
			end
		}
	end
	GUI.addLabel=addLabel
	addPanel=function(self,tbl)
		pcall(function()
			if not tbl.onDraw then
				tbl.onDraw=function(self,...)
					do
						pcall(function()
							local parent,isRoot=self:getParent()
							pcall(function()
								isRoot=parent==GUI.getRoot()
							end)
							while parent.type~="listBox"and not isRoot do
								parent=parent:getParent()
							end
							if p.type=="listBox"then
								Drawing.setClipping(parent:getAbsoluteX()+1,parent:getAbsoluteY()+1,parent:getWidth()-2,parent:getHeight()-2)
							end
						end)
					end
					if darkUIMode()then
						Drawing.setColor(0,0,0)
					else
						Drawing.setColor(255,255,255)
					end
					Drawing.drawRect(...)
					if darkUIMode()then
						Drawing.setColor(255,255,255)
					else
						Drawing.setColor(0,0,0)
					end
					drawOutline(...)
					Drawing.resetClipping()
					Drawing.reset()
				end
			end
		end)
		pcall(function()
			local onInit
			if tbl.onInit then
				onInit=tbl.onInit
			end
			tbl.onInit=function(self,...)
				self.type="panel"
				if onInit then
					onInit(self,...)
				end
			end
		end)
		return self:addCanvas (tbl)
	end
	GUI.addPanel=addPanel
	addTextFrame=function(self,tbl)
		local text=tbl.text or""
		local gth=10
		local y,speedY,th=0,0,gth
		return self:addPanel{
			w=tbl.w,
			width=tbl.width,
			h=tbl.h,
			height=tbl.height,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onInit=function(self,...)
				self.type="textFrame"
				if tbl.id then
					self:setId(tbl.id)
				end
				function self:getText()
					return text
				end
				function self:setText(s)
					text=s or""
				end
				self:addPanel{
					onUpdate=function(self)
						self:setChildIndex(self:getChildIndex()+2)
						if th>self:getParent():getClientHeight()then
							self:setSize(5,self:getParent():getClientHeight()*(self:getParent():getHeight()/th))
						else
							self:setSize(5,self:getParent():getClientHeight())
						end
						self:setSize(self:getWidth(),math.max(15,self:getHeight()))
						--self:setSize(10,self:getParent():getHeight()*0.2)
						local i=(self:getParent():getHeight()-self:getHeight())*(y/(th-self:getParent():getHeight()))
						self:setPosition(self:getParent():getClientWidth()-self:getWidth(),
						i-(i*2))
					end,
					onDraw=function(self,x,y,w,h)
						if th>self:getParent():getHeight()then
							local c=self:getParent()
							Drawing.setClipping(c:getAbsoluteX(),c:getAbsoluteY(),
							c:getWidth(),c:getHeight())
							x=x-2
							y=y+2
							h=h-2
							if darkUIMode()then
								Drawing.setColor(0,0,0)
							else
								Drawing.setColor(255,255,255)
							end
							Drawing.drawRect(x-1,y-1,w+2,h+2)
							if darkUIMode()then
								Drawing.setColor(255,255,255)
							else
								Drawing.setColor(0,0,0)
							end
							drawOutline(x,y,w,h)
							Drawing.resetClipping()
							Drawing.reset()
						end
					end
				}
				if tbl.onInit then
					tbl.onInit(self,...)
				end
			end,
			onUpdate=function(self,...)
				if self:getTouchPoint()then
					_,_,_,_,_,speedY=self:getTouchPoint()
				else
					if speedY>0 then
						speedY=speedY/1.1
					end
					if speedY<0 then
						speedY=tonumber('-'..(math.abs(speedY)/1.1))
					end
				end
				if th>self:getClientHeight()then
					y=y+speedY
					if y<0-(th-self:getHeight())then
						y=0-(th-self:getHeight())
						speedY=0
					elseif y>0 then
						y=0
						speedY=0
					end
				end
			end,
			onDraw=function(self,x,yy,w,h)
				Drawing.setClipping(x,yy,w-5,h)
				local tw=0
				th=gth
				local tbl={}
				for v in text:gmatch(".")do
					tbl[#tbl+1]=v
				end
				if darkUIMode()then
					Drawing.setColor(255,255,255)
				else
					Drawing.setColor(0,0,0)
				end
				pcall(function()
					for k,v in pairs(tbl)do
						local tw2=Drawing.getTextSize(v)
						if tbl[k-1]=="\n"or(tw+(tw2*2)>w-5 and(tbl[k-1]==" "or tbl[k-1]=="."or tbl[k-1]==","))then
							tw=0
							th=th+gth
						end
						tw=tw+tw2
						Drawing.drawText(v,x+(tw-tw2),(yy+y)+(th-gth))
					end
				end)
				Drawing.resetClipping()
				Drawing.reset()
			end
		}
	end
	GUI.addTextFrame=addTextFrame
	addListBox=function(self,tbl)
		local x2,y2=tbl.x2 or 0.5,tbl.y2 or 0.5
		local x3,y3=tbl.x3 or 0,tbl.y3 or 0
		local x,y=x2+x3,y2+y3
		local speedX,speedY=tbl.speedX or 0,tbl.speedY or 0
		local vertical,scroll,filter,spacing=true,true,function()return true end,0
		if tbl.vertical then
			vertical=tbl.vertical
		end
		if tbl.scroll then
			scroll=tbl.scroll
		end
		if tbl.spacing then
			spacing=tbl.spacing
		end
		local w,h,scrollPad,scrollBar=0,0
		return self:addCanvas{
			w=tbl.w,
			width=tbl.width,
			h=tbl.h,
			height=tbl.height,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onInit=function(self,...)
				self.type="listBox"
				pcall(function()
					if tbl.id then
						self:setId(tbl.id)
					end
					function self:getItemX()
						return x
					end
					function self:getItemY()
						return y
					end
					function self:setItemX(x2)
						local x3=x
						x=x2
						return x3
					end
					function self:setItemY(y2)
						local y3=y
						y=y2
						return y3
					end
					function self:getSpeedX()
						return speedX
					end
					function self:getSpeedY()
						return speedY
					end
					function self:setSpeedX(sx2)
						local sx3=speedX
						speedX=sx2
						return sx3
					end
					function self:setSpeedY(sy2)
						local sy3=speedY
						speedY=sy2
						return sy3
					end
					function self:forEach(a)
						pcall(function()
							local i=1
							while self:getChild(i)do
								if a(self:getChild(i))then
									i=i+1
								else
									break
								end
							end
						end)
					end
					function self:clear()
						while self:getChild(1)do
							self:getChild(1):delete()
						end
					end
					if scroll then
						scrollPad=self:addCanvas{
							onUpdate=function(self)
								self:setTouchThrough(true)
							end,
							onInit=function(self)
								self:setTouchThrough(true)
								scrollBar=self:addPanel{
									onUpdate=function(self)
										local parent=self:getParent():getParent()
										self:setChildIndex(self:getChildIndex()+2)
										if vertical then
											self:setWidth(15)
											local h2=parent:getClientHeight()
											if h>parent:getClientHeight()then
												h2=h2*(parent:getHeight()/h)
											end
											self:setHeight(math.max(15,h2))
											local i=(parent:getClientHeight()-self:getHeight())*(y/(h-parent:getClientHeight()))
											self:setPosition(parent:getClientWidth()-self:getWidth(),
												i-(i*2))
										else
											self:setHeight(15)
											local w2=parent:getClientWidth()
											if w>parent:getClientWidth()then
												w2=w2*(parent:getClientWidth()/h)
											end
											self:setWidth(math.max(15,w2))
											local i=(parent:getClientWidth()-self:getClientWidth())*(x/(w-parent:getClientWidth()))
											self:setPosition(i-(i*2),
												parent:getClientHeight()-self:getHeight())
										end
									end,
									onDraw=function(self,x,y,w,h)
										local c=self:getParent()
										Drawing.setClipping(c:getAbsoluteX()+1,c:getAbsoluteY()+1,
											c:getWidth()-2,c:getHeight()-2)
										if vertical then
											y=y+2
											h=h-2
											w=5
											x=(x+10)-2
										else
											x=x+2
											w=w-2
											h=5
											y=(y+10)-2
										end
										if darkUIMode()then
											Drawing.setColor(0,0,0)
										else
											Drawing.setColor(255,255,255)
										end
										Drawing.drawRect(x-1,y-1,w+2,h+2)
										if darkUIMode()then
											Drawing.setColor(255,255,255)
										else
											Drawing.setColor(0,0,0)
										end
										drawOutline(x,y,w,h)
										Drawing.resetClipping()
										Drawing.reset()
									end
								}
							end
						}
						self.scrollPad=scrollPad
					end
					--scrollPad[#scrollPad]:setTouchThrough(true)
				end)
				if tbl.onInit then
					local t2=table.pack(...)
					pcall(function()
						tbl.onInit(self,table.unpack(t2))
					end)
				end
			end,
			onUpdate=function(self,...)
				local tt=table.pack(...)
				pcall(function()
					if scroll then
						if scrollPad:getTouchPoint()then
							_,_,_,_,speedX,speedY=scrollPad:getTouchPoint()
						elseif scrollBar:getTouchPoint()then
							_,_,_,_,speedX,speedY=scrollBar:getTouchPoint()
							if vertical then
								speedY=speedY*(h/self:getHeight())
								speedY=speedY-(speedY*2)
							else
								speedX=speedX*(w/self:getWidth())
								speedX=speedX-(speedX*2)
							end
						end
					end
					pcall(function()
						if not scroll then
							speedX,speedY=0,0
						end
						if vertical then
							y=y+speedY
						else
							x=x+speedX
						end
						if not (scrollPad:getTouchPoint()or scrollBar:getTouchPoint())then
							if speedX>0 then
								speedX=speedX/1.1
							end
							if speedX<0 then
								speedX=tonumber('-'..(math.abs(speedX)/1.1))
							end
							if speedY>0 then
								speedY=speedY/1.1
							end
							if speedY<0 then
								speedY=tonumber('-'..(math.abs(speedY)/1.1))
							end
						end
						w,h=0,0
						self:forEach(function(c)
							local isb
							pcall(function()
								isb=c==scrollPad or c==scrollBar
							end)
							if not isb then
								pcall(function()
									--c:setTouchThrough(true)
									if vertical then
										h=h+(c:getHeight()+spacing)
										c:setPosition(c:getX(),(0+y)+(h-c:getHeight()-spacing))
										c:setVisible(c:getAbsoluteY()>self:getAbsoluteY()-c:getHeight()and c:getAbsoluteY()<self:getAbsoluteY()+(self:getHeight()-c:getHeight())+c:getHeight())
									else
										w=w+(c:getWidth()+spacing)
										c:setPosition((0+x)+(w-c:getWidth()-spacing),c:getY())
										c:setVisible(c:getAbsoluteX()>self:getAbsoluteX()-c:getWidth()and c:getAbsoluteX()<self:getAbsoluteX()+(self:getWidth()-c:getWidth())+c:getWidth())
									end
									c:setVisible(c:isVisible()and(c:getWidth()>0 and c:getHeight()>0))
								end)
							else
								if c:getChildIndex()+1<self:countChildren()then
									c:setChildIndex(c:getChildIndex()+2)
								end
							end
							return true
						end)
						pcall(function()
							scrollPad:setSize(scrollPad:getParent():getSize())
							scrollPad:setPosition(0,0)
							scrollPad:setChildIndex(self:countChildren()+1)
						end)
						if (w<=self:getWidth()or h<=self:getHeight())then
							if w<=self:getWidth()-x2 then
								x=x2
							end
							if h<=self:getHeight()-y2 then
								y=y2
							end
						end
						pcall(function()
							if scroll and not (scrollPad:getTouchPoint()or scrollBar:getTouchPoint())then
								if vertical then
									if y>0+y2 or(h>self:getHeight()-y2 and y<(0+y2)-(h-1)+self:getHeight()-y2)then
										speedY=0
									end
									if h>self:getHeight()-y2 then
										if y<((0+y2)-(h-1)+self:getHeight()-y2)-220 then
											y=y+120
										elseif y<((0+y2)-(h-1)+self:getHeight()-y2)-160 then
											y=y+80
										elseif y<((0+y2)-(h-1)+self:getHeight()-y2)-110 then
											y=y+50
										elseif y<((0+y2)-(h-1)+self:getHeight()-y2)-70 then
											y=y+30
										elseif y<((0+y2)-(h-1)+self:getHeight()-y2)-30 then
											y=y+15
										elseif y<((0+y2)-(h-1)+self:getHeight()-y2)-10 then
											y=y+5
										elseif y<(0+y2)-(h-1)+self:getHeight()-y2 then
											y=y+1
										end
									end
									if y>220+y2 then
										y=y-120
									elseif y>160+y2 then
										y=y-80
									elseif y>110+y2 then
										y=y-50
									elseif y>70+y2 then
										y=y-30
									elseif y>30+y2 then
										y=y-15
									elseif y>10+y2 then
										y=y-5
									elseif y>0+y2 then
										y=y-1
									end
								else
									if x>0+x2 or(w>self:getWidth()-x2 and x<(0+x2)-(w-1)+self:getWidth()-x2)then
										speedX=0
									end
									if w>self:getWidth()-x2 then
										if x<((0+x2)-(w-1)+self:getWidth()-x2)-220 then
											x=x+120
										elseif x<((0+x2)-(w-1)+self:getWidth()-x2)-160 then
											x=x+80
										elseif x<((0+x2)-(w-1)+self:getWidth()-x2)-110 then
											x=x+50
										elseif x<((0+x2)-(w-1)+self:getWidth()-x2)-70 then
											x=x+30
										elseif x<((0+x2)-(w-1)+self:getWidth())-x2-30 then
											x=x+15
										elseif x<((0+x2)-(w-1)+self:getWidth()-x2)-10 then
											x=x+5
										elseif x<(0+x2)-(w-1)+self:getWidth()-x2 then
											x=x+1
										end
									end
									if x>220+x2 then
										x=x-120
									elseif x>160+x2 then
										x=x-80
									elseif x>110+x2 then
										x=x-50
									elseif x>70+x2 then
										x=x-30
									elseif x>30+x2 then
										x=x-15
									elseif x>10+x2 then
										x=x-5
									elseif x>0+x2 then
										x=x-1
									end
								end
							end
						end)
					end)
					if tbl.onUpdate then
						pcall(function()
							tbl.onUpdate(self,table.unpack(tt))
						end)
					end
				end)
				--self:delete()
			end,
			onDraw=function(self,...)
				if not tbl.onDraw then
					if darkUIMode()then
						Drawing.setColor(30,30,30)
					else
						Drawing.setColor(255,255,255)
					end
					local r,g,b=Drawing.getColor()
					local a=Drawing.getAlpha()
					if tbl.color then
						local rr,gg,bb,aa=tbl.color()
						Drawing.setColor(rr or r,gg or g,bb or b)
						Drawing.setAlpha(aa or a)
					end
					Drawing.drawRect(...)
					Drawing.setClipping(...)
					pcall(function()
						self:forEach(function(c)
							if (c:getChildIndex() % 2)==1 then
								if darkUIMode()then
									Drawing.setColor(50,50,50)
								else
									Drawing.setColor(235,235,235)
								end
								Drawing.drawRect(c:getAbsoluteX(),c:getAbsoluteY(),c:getWidth(),c:getHeight())
							end
							return true
						end)
					end)
					Drawing.resetClipping()
					Drawing.reset()
					if darkUIMode()then
						Drawing.setColor(255,255,255)
					else
						Drawing.setColor(0,0,0)
					end
					drawOutline(...)
					Drawing.reset()
				else
					tbl.onDraw(self,...)
				end
			end,
			onClick=function(...)
				if tbl.onClick then
					tbl.onClick(...)
				end
			end
		}
	end
	GUI.addListBox=addListBox
	addLayout=function(self,tbl)
		return self:addCanvas{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onInit=function(self,...)
				self.type="layout"
				self:setTouchThrough(true)
				local vertical
				if tbl.vertical then
					vertical=tbl.vertical
				end
				if tbl.id then
					self:setId(tbl.id)
				end
				local fp=self:addCanvas{
					w=self:getWidth(),
					h=self:getHeight(),
					x=0,
					y=0,
					onInit=function(self)
						self.type="firstPartOfLayout"
						self:setTouchThrough(true)
					end,
					onUpdate=function(self)
						self:setPosition(0,0)
						self:setSize(self:getParent():getClientSize())
						pcall(function()
							local w,h,i=0,0,1
							while self:getChild(i)do
								local c=self:getChild(i)
								pcall(function()
									pcall(function()
										c:setTouchThrough(self:getParent():getParent().type=="listBox")
									end)
									if vertical then
										h=h+(c:getHeight()+1)
										c:setPosition(c:getX(),0+(h-c:getHeight()-1))
										c:setVisible(c:getAbsoluteY()>=self:getAbsoluteY()-c:getHeight()and c:getAbsoluteY()<=self:getAbsoluteY()+(self:getHeight()-c:getHeight())+c:getHeight())
									else
										w=w+(c:getWidth()+1)
										c:setPosition(0+(w-c:getWidth()-1),c:getY())
										c:setVisible(c:getAbsoluteX()>=self:getAbsoluteX()-c:getWidth()and c:getAbsoluteX()<=self:getAbsoluteX()+(self:getWidth()-c:getWidth())+c:getWidth())
									end
									c:setVisible(c:isVisible()and(c:getWidth()>0 and c:getHeight()>0))
								end)
								i=i+1
							end
						end)
					end
				}
				function self:getFirstPart()
					return fp
				end
				local cp=self:addCanvas{
					w=self:getWidth(),
					h=self:getHeight(),
					x=0,
					y=0,
					onInit=function(self)
						self.type="centerPartOfLayout"
						self:setTouchThrough(true)
					end,
					onUpdate=function(self)
						self:setPosition(0,0)
						self:setSize(self:getParent():getClientSize())
						local w,h=0,0
						pcall(function()
							w,h=0,0
							local i=1
							while self:getChild(i)do
								local c=self:getChild(i)
								pcall(function()
									pcall(function()
										c:setTouchThrough(self:getParent():getParent().type=="listBox")
									end)
									if vertical then
										h=h+(c:getHeight()+1)
										c:setPosition(c:getX(),0+(h-c:getHeight()-1))
										c:setVisible(c:getAbsoluteY()>=self:getAbsoluteY()-c:getHeight()and c:getAbsoluteY()<=self:getAbsoluteY()+(self:getHeight()-c:getHeight())+c:getHeight())
									else
										w=w+(c:getWidth()+1)
										c:setPosition(0+(w-c:getWidth()-1),c:getY())
										c:setVisible(c:getAbsoluteX()>=self:getAbsoluteX()-c:getWidth()and c:getAbsoluteX()<=self:getAbsoluteX()+(self:getWidth()-c:getWidth())+c:getWidth())
									end
									c:setVisible(c:isVisible()and(c:getWidth()>0 and c:getHeight()>0))
								end)
								i=i+1
							end
						end)
						if vertical then
							self:setY((self:getParent():getClientHeight()/2)-(h/2))
						else
							self:setX((self:getParent():getClientWidth()/2)-(w/2))
						end
					end
				}
				function self:getCenterPart()
					return cp
				end
				local lp=self:addCanvas{
					w=self:getWidth(),
					h=self:getHeight(),
					x=0,
					y=0,
					onInit=function(self)
						self.type="lastPartOfLayout"
						self:setTouchThrough(true)
					end,
					onUpdate=function(self)
						self:setPosition(0,0)
						self:setSize(self:getParent():getClientSize())
						pcall(function()
							local w,h,i=0,0,self:countChildren()
							while self:getChild(i)do
								local c=self:getChild(i)
								pcall(function()
									pcall(function()
										c:setTouchThrough(self:getParent():getParent().type=="listBox")
									end)
									if vertical then
										h=h+(c:getHeight()+1)
										c:setPosition(c:getX(),(0+self:getHeight())-h)
										c:setVisible(c:getAbsoluteY()>=self:getAbsoluteY()-c:getHeight()and c:getAbsoluteY()<=self:getAbsoluteY()+(self:getHeight()-c:getHeight())+c:getHeight())
									else
										w=w+(c:getWidth()+1)
										c:setPosition((0+self:getWidth())-w,c:getY())
										c:setVisible(c:getAbsoluteX()>=self:getAbsoluteX()-c:getWidth()and c:getAbsoluteX()<=self:getAbsoluteX()+(self:getWidth()-c:getWidth())+c:getWidth())
									end
									c:setVisible(c:isVisible()and(c:getWidth()>0 and c:getHeight()>0))
								end)
								i=i-1
							end
						end)
					end
				}
				function self:getLastPart()
					return lp
				end
				function self:addLayout(tbl)
					return self:getFirstPart():addLayout(tbl)
				end
				function self:addLabel(tbl)
					return self:getFirstPart():addLabel(tbl)
				end
				function self:addButton(tbl)
					return self:getFirstPart():addButton(tbl)
				end
				function self:addTextFrame(tbl)
					return self:getFirstPart():addTextFrame(tbl)
				end
				function self:addTextField(tbl)
					return self:getFirstPart():addTextField(tbl)
				end
				function self:addIcon(tbl)
					return self:getFirstPart():addIcon(tbl)
				end
				function self:addCanvas(tbl)
					return self:getFirstPart():addCanvas(tbl)
				end
				function self:addPanel(tbl)
					return self:getFirstPart():addPanel(tbl)
				end
				function self:addSlider(tbl)
					return self:getFirstPart():addSlider(tbl)
				end
				function self:addGadget(tbl)
					return self:getFirstPart():addGadget(tbl)
				end
				if tbl.onInit then
					tbl.onInit(self,...)
				end
			end,
			onUpdate=function(...)
				if tbl.onUpdate then
					tbl.onUpdate(...)
				end
			end
		}
	end
	GUI.addLayout=addLayout
	addSlider=function(self,tbl)
		local minValue=tbl.minValue or 0
		local maxValue=tbl.maxValue or 1
		local v,bt,pb=0
		return self:addPanel{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onInit=function(self)
				self.type="slider"
				local i,xx=0,0
				bt=self:addButton{
					w=30,
					onUpdate=function(self)
						v=0
						pcall(function()
							v=((tbl.getValue()-minValue)/(maxValue-minValue))
						end)
						pcall(function()
							self:setPosition((self:getParent():getWidth()-self:getWidth())*v,self:getY())
						end)
						local ov=v
						pcall(function()
							if self:getTouchPoint()or self:getParent():getTouchPoint()then
								local x,fx
								if self:getTouchPoint()then
									x,_,fx=self:getTouchPoint()
								elseif self:getParent():getTouchPoint()then
									x,_,fx=self:getParent():getTouchPoint()
								end
								i=i+1
								if i==1 then
									xx= self:getAbsoluteX()
								else
									--_,_,_,_,speedX=self:getTouchPoint()
									--self:setPosition((x-self:getParent():getAbsoluteX())-(self:getWidth()/2),self:getY())
									self:setPosition((x-self:getParent():getAbsoluteX())-(fx-xx),self:getY())
									--self:setPosition(self:getX()+speedX,self:getY())
									pcall(function()
										if tbl.setValue then
											local v2=minValue+(self:getX()/(self:getParent():getWidth()-self:getWidth()))*maxValue
											if v2>=minValue and v2<=maxValue then
												tbl.setValue(v2)
												v=v2
											elseif v2<minValue then
												tbl.setValue(minValue)
												v=minValue
											elseif v2>maxValue then
												tbl.setValue(maxValue)
												v=maxValue
											end
										end
									end)
								end
								local w = (pb:getParent():getWidth()-self:getWidth())
								pb:setWidth(w*v)
							else
								i=0
								xx=0
							end
						end)
						pcall(function()
							if tbl.getText then
								self:setText(tostring(tbl.getText(minValue+(ov*maxValue))))
							else
								--self:setText((ov*100)..'%')
								self:setText(math.floor(ov*100)..'%')
							end
						end)
						pcall(function()
							local tw=Drawing.getTextSize(self:getText())
							self:setSize(math.max(30,tw+3),self:getHeight())
						end)
						if self:getX()<0 then
							self:setPosition(0,self:getY())
						elseif self:getX()>self:getParent():getWidth()-self:getWidth()then
							self:setPosition(self:getParent():getWidth()-self:getWidth(),self:getY())
						end
					end
				}
				pb=self:addCanvas{
					onUpdate = function(self)
						local x = 0
						local w = self:getParent():getWidth()
						local w2,x2=0,0
						pcall(function()
							if bt then
								w2=bt:getWidth()
							end
						end)
						x=x+(w2/2)
						w=w-w2
						pcall(function()
							if bt then
								x2=bt:getX()
							end
						end)
						self:setSize(w*(x2/w),4)
						self:setPosition(x,(self:getParent():getHeight()/2) - (self:getHeight() - 2))
					end,
					onInit = function(self)
						self:setTouchThrough(true)
						self:setChildIndex(1)
					end,
					onDraw=function(self,x,y,w,h)
						if darkUIMode()then
							Drawing.setColor(255,255,255)
						else
							Drawing.setColor(0,0,0)
						end
						Drawing.drawRect(x,y,w,h)
						Drawing.reset()
					end
				}
			end,
			onDraw=function(self,x,y,w,h)
				do
					pcall(function()
						local parent,isRoot=self:getParent()
						pcall(function()
							isRoot=parent==GUI.getRoot()
						end)
						while parent.type~="listBox"and not isRoot do
							parent=parent:getParent()
						end
						if parent.type=="listBox"then
							Drawing.setClipping(parent:getAbsoluteX()+1,parent:getAbsoluteY()+1,parent:getWidth()-2,parent:getHeight()-2)
						end
					end)
				end
				local w2,x2=0,0
				pcall(function()
					if bt then
						w2=bt:getWidth()
					end
				end)
				x=x+(w2/2)
				w=w-w2
				if darkUIMode()then
					Drawing.setColor(255,255,255)
				else
					Drawing.setColor(0,0,0)
				end
				drawOutline(x,y+(h/2)-2,w,4)
				pcall(function()
					if bt then
						x2=bt:getX()
					end
				end)
				--Drawing.drawRect(x,y+(h/2)-2,w*(x2/(self:getWidth()-w2)),4)
				Drawing.resetClipping()
				Drawing.reset()
			end
		}
	end
	GUI.addSlider=addSlider
	addTextField=function(self,tbl)
		local text,w=tbl.text or"",0
		return self:addCanvas{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onDraw=function(self,x,y,ww,h)
				if darkUIMode()then
					Drawing.setColor(0,0,0)
				else
					Drawing.setColor(255,255,255)
				end
				Drawing.drawRect(x,y,ww,h)
				if darkUIMode()then
					Drawing.setColor(255,255,255)
				else
					Drawing.setColor(0,0,0)
				end
				drawOutline(x,y,ww,h)
				w=0
				pcall(function()
					for _,v in pairs(text:table())do
						pcall(function()
							local tw,th=Drawing.getTextSize(v)
							w=w+tw
							Drawing.drawText(v,x+(w-tw),y+(h/2)-(th/2))
						end)
					end
				end)
			end,
			onInit=function(self)
				function self:getText()
					return text
				end
				function self:setText(s)
					text=tostring(s or '')
				end
			end
		}
	end
	--GUI.addTextField=addTextField
	addIcon=function(self,tbl)
		local icon=tbl.icon or 0
		local alignX,alignY=0.5,0.5
		return self:addCanvas{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			x=tbl.x or 0,
			y=tbl.y or 0,
			onDraw=function(self,x,y,w,h)
				do
					pcall(function()
						local parent,isRoot=self:getParent()
						pcall(function()
							isRoot=parent==GUI.getRoot()
						end)
						while parent.type~="listBox"and not isRoot do
							parent=parent:getParent()
						end
						if parent.type=="listBox"then
							Drawing.setClipping(parent:getAbsoluteX()+1,parent:getAbsoluteY()+1,parent:getWidth()-2,parent:getHeight()-2)
						end
					end)
				end
				if icon then
					local icon=icon
					pcall(function()
						if type(icon)=="table"then
							local draft=icon
							pcall(function()
								icon=draft:getFrame(1)
							end)
							pcall(function()
								icon=City.createDraftDrawer(draft).draw(x,y,w,h)
							end)
						end
					end)
					icon = icon or 0
					pcall(function()
						local iw,ih=Drawing.getImageSize(icon)
						local hx,hy=Drawing.getImageHandle(icon)
						iw = math.min(iw, w)
						ih = math.min(ih, h)
						Drawing.drawImageRect(icon,math.max(0,(x+hx)+(w*alignX)-(iw/2)),math.max(0,(y+hy)+(h*alignY)-(ih/2)), iw, ih)
					end)
				end
				Drawing.resetClipping()
			end,
			onInit=function(self,...)
				self.type="icon"
				function self:getIcon()
					return icon
				end
				function self:setIcon(s)
					icon=s or 0
				end
				function self:setAlignment(a1,a2)
					alignX,alignY=a1 or 0,a2 or 0
				end
				function self:getAlignment()
					return alignX,alignY
				end
				if tbl.onInit then
					tbl.onInit(self,...)
				end
			end,
			onUpdate=function(...)
				if tbl.onUpdate then
					tbl.onUpdate(...)
				end
			end
		}
	end
	GUI.addIcon=addIcon
	createDialog=function(tbl)
		local t2,op={}
		GUI.getRoot():addPanel{
			onInit=function(self)
				t2.close=function()
					local cc
					pcall(function()
						if type(tbl.onClose)~="nil" then
							cc=tbl.onClose()
						end
					end)
					if not cc then
						self:delete()
					end
				end
				function self:click()
					if not tbl.closeable then
						TheoTown.playSound(Draft.getDraft("$click_sound00"),1.3)
						pcall(function()
							if tbl.onCancel then
								tbl.onCancel(t2)
							end
						end)
						t2.close()
					end
				end
				self:addPanel{
					width=tbl.width or tbl.w or 300,
					height=tbl.height or tbl.h or 160,
					onUpdate=function(self)
						if op then
							if self:getY()>(self:getParent():getClientHeight()/2)-(self:getHeight()/2)then
								self:setY(self:getY()-((self:getParent():getHeight()-((self:getParent():getClientHeight()/2)-(self:getHeight()/2)))*0.1))
							elseif self:getY()>(self:getParent():getClientHeight()/2)-(self:getHeight()/2)then
								self:setY((self:getParent():getClientHeight()/2)-(self:getHeight()/2))
								op = nil
							end
						end
					end,
					onInit=function(self)
						self:setSize(math.min(self:getWidth(),GUI.getRoot():getClientWidth()),
							math.min(self:getHeight(),GUI.getRoot():getClientHeight()))
						self:setPosition((self:getParent():getClientWidth()/2)-(self:getWidth()/2), self:getParent():getHeight())
						op = true
						self:setPadding(2,2,2,2)
						self:addCanvas{
							h=30,
							onDraw=function(self,x,y,w,h)
								if darkUIMode()then
									Drawing.setColor(255,255,255)
								else
									Drawing.setColor(0,0,0)
								end
								local ii=self:getHeight()-1
								for i=0,ii do
									local h=h/(ii+1)
									Drawing.setAlpha(1-(1*(i/ii)))
									Drawing.setAlpha(Drawing.getAlpha()/2)
									Drawing.setAlpha(math.max(Drawing.getAlpha(), 0))
									Drawing.drawRect(x,y+(h*i),w,h)
								end
								Drawing.reset()
							end
						}
						do
							local text=tbl.title or""
							t2.title=self:addCanvas{
								h=30,
								onInit=function(self)
									function self:getText()
										return text
									end
									function self:setText(s)
										text=s
									end
								end,
								onDraw=function(self,x,y,w,h)
									local tw,th=Drawing.getTextSize(text,Font.BIG)
									if darkUIMode()then
										Drawing.setColor(0,0,0)
									else
										Drawing.setColor(255,255,255)
									end
									for _,v in pairs{1,0.75,0.5,0.25}do
										Drawing.drawText(text,(x+v)+(w/2)-(tw/2),(y-v)+(h/2)-(th/2),Font.BIG)
										Drawing.drawText(text,(x-v)+(w/2)-(tw/2),(y-v)+(h/2)-(th/2),Font.BIG)
										Drawing.drawText(text,(x-v)+(w/2)-(tw/2),(y+v)+(h/2)-(th/2),Font.BIG)
										Drawing.drawText(text,(x+v)+(w/2)-(tw/2),(y+v)+(h/2)-(th/2),Font.BIG)
									end
									if darkUIMode()then
										Drawing.setColor(255,255,255)
									else
										Drawing.setColor(0,0,0)
									end
									Drawing.drawText(text,x+(w/2)-(tw/2),y+(h/2)-(th/2),Font.BIG)
									Drawing.reset()
								end
							}
						end
						t2.icon=self:addCanvas{
							w=30,
							h=30,
							onDraw=function(self,x,y,w,h)
								if tbl.icon then
									local iw,ih=Drawing.getImageSize(tbl.icon)
									local hx,hy=Drawing.getImageHandle(tbl.icon)
									Drawing.drawImage(tbl.icon,(x+hx)+(w/2)-(iw/2),(y+hy)+(h/2)-(ih/2))
								end
							end,
							onInit=function(self)
								function self:getIcon()
									return tbl.icon
								end
								function self:setIcon(s)
									tbl.icon=s
								end
								t2.title:setX(self:getWidth())
								t2.title:setWidth(t2.title:getWidth()-self:getWidth())
							end
						}
						if not tbl.closeable then
							self:addCanvas{
								w=30,
								h=30,
								x=self:getClientWidth()-30,
								onInit=function(self)
									function self:click()
										TheoTown.playSound(Draft.getDraft("$click_sound00"),1.3)
										pcall(function()
											if tbl.onCancel then
												tbl.onCancel(t2)
											end
										end)
										t2.close()
									end
									t2.title:setWidth(t2.title:getWidth()-self:getWidth())
								end,
								onDraw=function(self,x,y,w,h)
									local iw,ih=Drawing.getImageSize(Icon.CLOSE_BUTTON)
									if self:getTouchPoint()then
										Drawing.setColor(255,0,0)
									end
									Drawing.drawImage(Icon.CLOSE_BUTTON,x+(w/2)-(iw/2),y+(h/2)-(ih/2))
									Drawing.reset()
								end,
								onClick=function(self)
									self:click()
								end
							}
						end
						if t2.title then
							t2.title:setChildIndex(3)
						end
						t2.text=self:addTextFrame{
							y=30,
							onInit=function(self)
								if tbl.text then
									self:setText(tostring(tbl.text))
								end
								self:setSize(self:getWidth(),self:getHeight()-30)
								self:setTouchThrough(true)
							end
						}
						t2.controls=self:addLayout{
							h=30,
							y=self:getClientHeight()-30,
							onInit=function(self)
								local addButton=function(tbl)
									self:getLastPart():addButton{
										--parent=self:getLastPart(),
										icon=tbl.icon,
										text=tbl.text,
										golden=tbl.golden,
										id=tbl.id,
										w=30,
										color=function()
											
										end,
										onClick=function(...)
											local t3=table.pack(...)
											pcall(function()
												if tbl.onClick then
													tbl.onClick(table.unpack(t3))
												end
											end)
											local autoClose=true
											pcall(function()
												if type(tbl.autoClose)~="nil" then
													autoClose=tbl.autoClose
												end
											end)
											if autoClose then
												t2.close()
											end
										end
									}
								end
								if tbl.actions then
									if #tbl.actions>=1 then
										for k in pairs(tbl.actions)do
											addButton(tbl.actions[k])
										end
									else
										addButton(tbl.actions)
									end
								end
							end,
							onUpdate=function(self)
								local i=1
								while self:getChild(i)do
									local c=self:getChild(i)
									pcall(function()
										c:setPosition(c:getPosition())
									end)
									i=i+1
								end
							end
						}
						t2.content=self:addCanvas{
							y=30,
							onInit=function(self)
								self:setTouchThrough(true)
							end,
							onUpdate=function(self)
								local i=1
								while self:getChild(i)do
									local c=self:getChild(i)
									pcall(function()
										c:setPosition(c:getPosition())
									end)
									i=i+1
								end
							end
						}
						self:addPanel{
							onUpdate=function(self)
								local c=self:getParent()
								local paddingLeft,paddingTop,paddingRight,paddingBottom=c:getPadding()
								self:setPosition(0-paddingLeft,0-paddingTop)
								self:setSize(c:getClientWidth()+paddingLeft+paddingRight,c:getClientHeight()+paddingTop+paddingBottom)
								self:setTouchThrough(true)
							end,
							onDraw=function(_,...)
								if darkUIMode()then
									Drawing.setColor(255,255,255)
								else
									Drawing.setColor(0,0,0)
								end
								drawOutline(...)
								Drawing.reset()
							end
						}
					end,
					onDraw=function(self,x,y,w,h)
						local paddingLeft,paddingTop,paddingRight,paddingBottom=self:getPadding()
						x=x-paddingLeft
						w=w+paddingLeft+paddingRight
						y=y-paddingTop
						h=h+paddingTop+paddingBottom
						if darkUIMode()then
							Drawing.setColor(0,0,0)
						else
							Drawing.setColor(255,255,255)
						end
						Drawing.drawRect(x,y,w,h)
						if darkUIMode()then
							Drawing.setColor(255,255,255)
						else
							Drawing.setColor(0,0,0)
						end
						drawOutline(x,y,w,h)
						Drawing.reset()
					end
				}
				if tbl.onInit then
					tbl.onInit(t2)
				end
			end,
			onUpdate=function(self)
				self:setPadding(paddingLeft,paddingTop,paddingRight,paddingBottom)
				self:setPosition(0-paddingLeft,0-paddingTop)
				self:setSize(self:getParent():getWidth(),self:getParent():getHeight())
				if tbl.onUpdate then
					tbl.onUpdate(t2)
				end
			end,
			onClick=function(self)
				self:click()
			end,
			onDraw=function(self,x,y)
				local w,h=self:getWidth(),self:getHeight()
				local paddingLeft,paddingTop,paddingRight,paddingBottom=self:getPadding()
				Drawing.setColor(0,0,0)
				Drawing.setAlpha(0.4)
				Drawing.drawRect(x-paddingLeft,y-paddingTop,w,h)
				Drawing.reset()
			end,
		}
		return t2
	end
	GUI.createDialog=createDialog
	createRenameDialog=function(tbl)
		local v=function()return "" end
		return createDialog{
			width=tbl.width,
			w=tbl.w,
			height=tbl.height,
			h=tbl.h,
			title=tbl.title,
			text=tbl.text,
			icon=tbl.icon,
			onInit=function(self)
				self.content:addTextField{
					h=30,
					y=15,
					onInit=function(self)
						pcall(function()
							if type(tbl.value)~="nil" then
								self:setText(tbl.value)
							end
						end)
						v=function()
							return self:getText()
						end
					end
				}
				self.controls:getLastPart():addButton{
					icon=tbl.okIcon or Icon.OK,
					text=tbl.okText or"Rename",
					w=30,
					onClick=function()
						tbl.onOk(v())
					end,
					onUpdate=function(self)
						if tbl.filter then
							self:setEnabled(tbl.filter())
						else
							self:setEnabled(true)
						end
					end
				}
			end,
			actions={
				{
					icon=tbl.cancelIcon or Icon.CANCEL,
					text=tbl.cancelText or"Cancel",
					onClick=function()
						tbl.onCancel()
					end
				}
			}
		}
	end
	GUI.createRenameDialog=createRenameDialog
	createSelectDraftDialog=function(tbl)
		local draft=tbl.drafts
		local selection=tbl.selection
		local oldSelection={}
		local minSelection=tbl.minSelection or 0
		local maxSelection=tbl.maxSelection or #draft
		local multiple=true
		if type(tbl.multiple)~=nil then
			multiple=tbl.multiple
		end
		if not multiple then
			minSelection=1
			maxSelection=1
		end
		for k in pairs(selection)do
			pcall(function()
				selection[k]=selection[k]:getId()
			end)
			pcall(function()
				oldSelection[k]=selection[k]
			end)
		end
		local dialog=GUI.createDialog{
			width=240,
			height=270,
			onInit=function(self)
				self.content:getParent():addButton{
					h=20,
					w=20,
					text="reset",
					x=self.content:getParent():getClientWidth()-60,
					y=4,
					onClick=function()
						selection={}
						for k in pairs(oldSelection)do
							selection[k]=oldSelection[k]
						end
					end
				}
			end,
			onClose=function()
				if #selection>=minSelection and#selection<=maxSelection then
					for k, v in pairs(selection) do
						selection[k] = Draft.getDraft(v)
					end
					tbl.onSelect(selection)
				else
					if #selection<minSelection then
						local p=""
						if minSelection~=1 then
							p="s"
						end
						Debug.toast("Select at least "..minSelection.." draft"..p)
					elseif #selection>maxSelection then
						local p=""
						if maxSelection~=1 then
							p="s"
						end
						Debug.toast("You can select a maximum of "..minSelection.." draft"..p)
					end
				end
				return not ((#selection>=minSelection)and(#selection<=maxSelection))
			end,
			onUpdate=function(self)
				self.title:setText(#selection.."/"..#draft)
			end
		}
		local listBox=dialog.content:addListBox{}
		local function addItems(draft)
			local selected=function()
				local e
				pcall(function()
					_,e=table.find(selection,draft:getId())
				end)
				return e
			end
			listBox:addCanvas{
				h=30,
				onInit=function(self)
					local entry=self:addCanvas{}
					entry:addIcon{
						w=30,
						icon = draft,
						onDraw=function(self,x,y,w,h)
							pcall(function()
								--City.createDraftDrawer(draft).draw(x,y,w,h)
							end)
						end
					}
					entry:addLabel{
						text=draft:getId(),
						x=40,
						onUpdate=function(self)
							if selected() then
								self:setColor(255,255,255)
							else
								if darkUIMode()then
									self:setColor(255,255,255)
								else
									self:setColor(0,0,0)
								end
							end
						end
					}
					local button=entry:addButton{
						width=30,
						height=30,
						icon=Icon.OK,
						onClick=function(self)
							if selected()then
								table.remove(selection,table.find(selection,draft:getId()))
							else
								table.insert(selection,draft:getId())
							end
						end,
						onUpdate=function(self)
							self:setPosition(self:getParent():getWidth()-30,self:getY())
							if selected() then
								self:setIcon(0)
								self:setText(table.find(selection,draft:getId()))
							else
								self:setIcon(Icon.PLUS)
								self:setText("")
							end
						end
					}
				end,
				onDraw=function(self,x,y,w,h)
					if selected() then
						Drawing.drawNinePatch(NinePatch.LIST_ITEM_SELECTED,x,y,w,h)
					end
				end
			}
		end
		for i=1,#draft do
			addItems(draft[i])
		end
	end
	GUI.createSelectDraftDialog=createSelectDraftDialog
	GUI.getType=function(self)
		local tbl=""
		pcall(function()
			if type(self.type)~="nil" then
				tbl=self.type
			end
		end)
		return tostring(tbl)
	end
	GUI.getRoot().type="root"
	GUI.getSize=function(self)
		return self:getWidth(),self:getHeight()
	end
	GUI.getClientSize=function(self)
		return self:getClientWidth(),self:getClientHeight()
	end
	GUI.getPosition=function(self)
		return self:getX(),self:getY()
	end
	GUI.getAbsolutePosition=function(self)
		return self:getAbsoluteX(),self:getAbsoluteY()
	end
	GUI.setX=function(self,x)
		self:setPosition(x or self:getX(),self:getY())
	end
	GUI.setY=function(self,y)
		self:setPosition(self:getX(),y or self:getY())
	end
	GUI.setWidth=function(self,w)
		self:setSize(w or self:getWidth(),self:getHeight())
	end
	GUI.setHeight=function(self,h)
		self:setSize(self:getWidth(),h or self:getHeight())
	end
	--Debug.tbl
	--Debug={}
	--Array={}
	--Draft={}
	--Vector={}
	--Building={}
	--Builder={}
	--Tile={}
	--Util={}
	--City={}
	--Drawing={}
	--Script={}
	--GUI={}
	--TheoTown={}
	--Drawing.drawImage=nil
	--Drawing.drawRect=nil
	--Drawing.reset=nil
	--Drawing.setColor=nil
	--Drawing.setAlpha=nil
	--local o=Drawing.setClipping
	--Drawing.setClipping=nil
	--Drawing.reset=function()end
	--GUI.getRoot=function()end
	--GUI.addCanvas=function()end
	--GUI.addPanel=function()end
	--GUI.addButton=function()end
	--GUI.addLabel=function()end
	--GUI.createDialog=function()end
	--GUI.createRenameDialog=function()end
	--GUI.createMenu=function()end
	--GUI.setPosition=function()end
	--GUI.getX=function()end
	--GUI.getY=function()end
	--GUI.getWidth=function()end
	--GUI.getHeight=function()end
	--GUI.setSize=function()end
	--GUI.delete=function()end
	--GUI.click=function()end
	--GUI.setIcon=function()end
	--GUI.getTouchPoint=function()end
	--GUI.isMouseOver=function()end
	--City.getStorage=function()return{}end
	--City.getView=function()return-1,-1 end
	--City.setView=function()end
	--City.getDay=function()return 0 end
	--City.getMonth=function()return 0 end
	--City.getYear=function()return 0 end
	--City.getPeople=function()return 0 end
	--City.getCommercialJobs=function()return 0 end
	--City.getIndustrialJobs=function()return 0 end
	--City.getResidentialSpace=function()return 0 end
	--Drawing.drawText=function()end
	--Drawing.drawImage=function()end
	--Drawing.drawImageRect=function()end
	--Drawing.drawRect=function()end
	--Drawing.drawNinePatch=function()end
	--TheoTown.RESOURCES=nil
	--Drawing.setClipping=function()
		--o(0,0,GUI.getRoot():getClientWidth(),GUI.getRoot():getClientHeight())
		--o(0,0,0,0)
	--end
	--Font=nil
	--Icon=nil
	--Runtime=nil
end
string.random=function(self)
	local a={}
	for v in self:gmatch(".")do
		a[#a+1]=v
	end
	return a[math.random(1,#a)]
end
string.table=function(self)
	local a={}
	for v in self:gmatch(".")do
		a[#a+1]=v
	end
	return a
end
