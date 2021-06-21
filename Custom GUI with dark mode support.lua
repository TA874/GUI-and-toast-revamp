local darkMode = function()
	local b
	pcall(function()
		if TheoTown.darkUIMode then
			b = TheoTown.darkUIMode()
		end
	end)
	return b
end
local addButton = function(t)
	local text = t.text or ""
	local icon = t.icon or 0
	return t.parent:addCanvas {
		onInit = function(self, ...)
			if t.id then
				self:setId(t.id)
			end
			pcall(function()
				if t.id then
					self:setId(t.id)
				end
				self:setPosition(t.x or 0, t.y or 0)
			end)
			function self:click(...)
				t.onClick(self, ...)
			end
			function self:getText()
				return text
			end
			function self:setText(s)
				text = s
			end
			function self:getIcon()
				return icon
			end
			function self:setIcon(s)
				icon = s
			end
			pcall(function()
				local tw = Drawing.getTextSize(text)
				self:setSize(math.max(30, 30 + tw), self:getHeight())
				if text:len() > 0 then
					self:setSize(self:getWidth() + 10, self:getHeight())
				end
				self:setSize(math.max(self:getWidth(), t.width or t.w or (self:getParent():getClientWidth() - self:getX())), t.height or t.h or (self:getParent():getClientHeight() - self:getY()))
			end)
			if t.onInit then
				t.onInit(self, ...)
			end
		end,
		onUpdate = function(...)
			if t.onUpdate then
				t.onUpdate(...)
			end
		end,
		onClick = function(self, ...)
			self:click(...)
		end,
		onDraw = function(self, x, y, w, h)
			local dc, dc2 = 0, 255
			if dm() then
				dc = 255
				dc2 = 0
			end
			if t.clipping then
				Drawing.setClipping(t.clipping())
			end
			local tw, th = Drawing.getTextSize(text)
			Drawing.setColor(dc2, dc2, dc2)
			if t.color then
				local r, g, b, a = t.color()
				Drawing.setColor(r or dc2, g or dc2, b or dc2)
				Drawing.setAlpha(a or 1)
			end
			Drawing.drawRect(x, y, w, h)
			Drawing.setColor(dc, dc, dc)
			Drawing.setAlpha(1)
			if (self:getTouchPoint() or self:isMouseOver()) and self:isEnabled() then
				if self:getTouchPoint() then
					Drawing.setAlpha(0.3)
				elseif self:isMouseOver() then
					Drawing.setAlpha(0.2)
				end
				Drawing.drawRect(x, y, w, h)
			end
			Drawing.reset()
			do
				local iw, ih = Drawing.getImageSize(icon)
				local xx = x + (w / 2) - (iw / 2)
				if text:len() > 1 then
					xx = x + (30 / 2) - (iw / 2)
				end
				Drawing.drawImage(icon, xx, y + (h / 2) - (ih / 2))
			end
			Drawing.reset()
			do
				local xx = x + (w / 2) - (tw / 2)
				if icon > 0 then
					xx = x + 30
				end
				Drawing.setColor(dc, dc, dc)
				local r, g, b = Drawing.getColor()
				if t.textColor then
					local r, g, b, a = t.textColor()
					Drawing.setColor(r or dc, g or dc, b or dc)
					Drawing.setAlpha(a or 1)
				end
				Drawing.drawText(text, xx, y + (h / 2) - (th / 2))
				Drawing.setColor(r, g, b)
			end
			Drawing.setColor(dc, dc, dc)
			if t.outlineColor then
				local r, g, b, a = t.outlineColor()
				Drawing.setColor(r or dc, g or dc, b or dc)
				Drawing.setAlpha(a or 1)
			end
			drawRect(x, y, w, h)
			Drawing.resetClipping()
			Drawing.reset()
		end
	}
end
local addTextFrame = function(t)
	local text = t.text or ""
	local gth = 10
	local y, sy, th = 0, 0, gth
	return t.parent:addPanel {
		w = t.w,
		width = t.width,
		h = t.h,
		height = t.height,
		x = t.x or 0,
		y = t.y or 0,
		onInit = function(self, ...)
			function self:getText()
				return text
			end
			function self:setText(s)
				text = s or ""
			end
			self:addPanel {
				onUpdate = function(self)
					self:setChildIndex(self:getChildIndex() + 2)
					if th > self:getParent():getClientHeight() then
						self:setSize(5, self:getParent():getClientHeight() * (self:getParent():getHeight() / th))
					else
						self:setSize(5, self:getParent():getClientHeight())
					end
					self:setSize(self:getWidth(), math.max(15, self:getHeight()))
					--self:setSize(10, self:getParent():getHeight() * 0.2)
					local i = (self:getParent():getHeight() - self:getHeight()) * (y / (th - self:getParent():getHeight()))
					self:setPosition(self:getParent():getClientWidth() - self:getWidth(),
					i - (i * 2))
				end,
				onDraw = function(self, x, y, w, h)
					local c = self:getParent()
					Drawing.setClipping(c:getAbsoluteX(), c:getAbsoluteY(),
					c:getWidth(), c:getHeight())
					x = x - 2
					y = y + 2
					h = h - 2
					if dm() then
						Drawing.setColor(0, 0, 0)
					else
						Drawing.setColor(255, 255, 255)
					end
					Drawing.drawRect(x - 1, y - 1, w + 2, h + 2)
					if dm() then
						Drawing.setColor(255, 255, 255)
					else
						Drawing.setColor(0, 0, 0)
					end
					drawRect(x, y, w, h)
					Drawing.resetClipping()
					Drawing.reset()
				end
			}
			if t.onInit then
				t.onInit(self, ...)
			end
		end,
		onUpdate = function(self, ...)
			if self:getTouchPoint() then
				_, _, _, _, _, sy = self:getTouchPoint()
			else
				if sy > 0 then
					sy = sy / 1.1
				end
				if sy < 0 then
					sy = tonumber('-'..(math.abs(sy) / 1.1))
				end
			end
			if th > self:getClientHeight() then
				y = y + sy
				if y < 0 - (th - self:getHeight()) then
					y = 0 - (th - self:getHeight())
					sy = 0
				elseif y > 0 then
					y = 0
					sy = 0
				end
			end
		end,
		onDraw = function(self, x, yy, w, h)
			Drawing.setClipping(x, yy, w - 5, h)
			local tw = 0
			th = gth
			local t = {}
			for v in text:gmatch(".") do
				t[#t + 1] = v
			end
			if dm() then
				Drawing.setColor(255, 255, 255)
			else
				Drawing.setColor(0, 0, 0)
			end
			pcall(function()
				for k, v in pairs(t) do
					local tw2 = Drawing.getTextSize(v)
					if t[k - 1] == "\n" or (tw + (tw2 * 2) > w - 5 and (t[k - 1] == " " or t[k - 1] == "." or t[k - 1] == ",")) then
						tw = 0
						th = th + gth
					end
					tw = tw + tw2
					Drawing.drawText(v, x + (tw - tw2), (yy + y) + (th - gth))
				end
			end)
			Drawing.resetClipping()
			Drawing.reset()
		end
	}
end
local createDialog = function(t)
	local t2 = {}
	GUI.getRoot():addPanel {
		onInit = function(self)
			t2.close = function()
				if t.onClose then
					if type(t.onClose) == "function" then
						t.onClose()
					end
				end
				self:delete()
			end
			function self:click()
				t2.close()
			end
			self:addPanel {
				width = t.width or t.w or 300,
				height = t.height or t.h or 160,
				onUpdate = function(self)
					self:setPosition(
						(self:getParent():getClientWidth() / 2) - (self:getWidth() / 2),
						(self:getParent():getClientHeight() / 2) - (self:getHeight() / 2)
					)
				end,
				onInit = function(self)
					self:setSize(math.min(self:getWidth(), GUI.getRoot():getClientWidth()), math.min(self:getHeight(), GUI.getRoot():getClientHeight()))
					self:setPadding(2, 2, 2, 2)
					self:addCanvas {
						h = 30,
						onInit = function(self)
							do
								local text = t.title or ""
								t2.title = self:addCanvas {
									onInit = function(self)
										function self:getText()
											return text
										end
										function self:setText(s)
											text = s
										end
									end,
									onDraw = function(self, x, y, w, h)
										local tw, th = Drawing.getTextSize(text, Font.BIG)
										if dm() then
											Drawing.setColor(255, 255, 255)
										else
											Drawing.setColor(0, 0, 0)
										end
										Drawing.drawText(text, x + (w / 2) - (tw / 2), y + (h / 2) - (th / 2), Font.BIG)
										Drawing.reset()
									end
								}
							end
							self:addCanvas {
								w = 30,
								onDraw = function(self, x, y, w, h)
									if t.icon then
										local iw, ih = Drawing.getImageSize(t.icon)
										Drawing.drawImage(t.icon, x + (w / 2) - (iw / 2), y + (h / 2) - (ih / 2))
									end
								end
							}
							self:addCanvas {
								w = 30,
								x = self:getClientWidth() - 30,
								onDraw = function(self, x, y, w, h)
									local iw, ih = Drawing.getImageSize(Icon.CLOSE_BUTTON)
									if self:getTouchPoint() then
										Drawing.setColor(255, 0, 0)
									end
									Drawing.drawImage(Icon.CLOSE_BUTTON, x + (w / 2) - (iw / 2), y + (h / 2) - (ih / 2))
									Drawing.reset()
								end,
								onClick = function()
									t2.close()
								end
							}
						end
					}
					t2.text = addTextFrame {
						parent = self,
						y = 30,
						onInit = function(self)
							if t.text then
								self:setText(tostring(t.text))
							end
							self:setSize(self:getWidth(), self:getHeight() - 30)
							self:setTouchThrough(true)
						end
					}
					t2.content = self:addCanvas {
						y = 30,
						onInit = function(self)
							self:setTouchThrough(true)
						end
					}
					t2.controls = self:addLayout {
						h = 30,
						y = self:getClientHeight() - 30,
						onInit = function(self)
							local addButton = function(t)
								addButton {
									parent = self:getLastPart(),
									icon = t.icon,
									text = t.text,
									color = function()
										
									end,
									onClick = function(...)
										local t3 = table.pack(...)
										pcall(function()
											if t.onClick then
												t.onClick(table.unpack(t3))
											end
										end)
										if not t.autoClose then
											t2.close()
										end
									end
								}
							end
							if t.actions then
								if #t.actions >= 1 then
									for k in pairs(t.actions) do
										addButton(t.actions[k])
									end
								else
									addButton(t.actions)
								end
							end
						end
					}
					self:addPanel {
						onUpdate = function(self)
							local c = self:getParent()
							local p2, p3, p4, p5 = c:getPadding()
							self:setPosition(0 - p2, 0 - p3)
							self:setSize(c:getClientWidth() + p2 + p4, c:getClientHeight() + p3 + p5)
							self:setTouchThrough(true)
						end,
						onDraw = function(_, ...)
							if dm() then
								Drawing.setColor(255, 255, 255)
							else
								Drawing.setColor(0, 0, 0)
							end
							drawRect(...)
							Drawing.reset()
						end
					}
				end,
				onDraw = function(self, x, y, w, h)
					local p2, p3, p4, p5 = self:getPadding()
					x = x - p2
					w = w + p2 + p4
					y = y - p3
					h = h + p3 + p5
					if dm() then
						Drawing.setColor(0, 0, 0)
					else
						Drawing.setColor(255, 255, 255)
					end
					Drawing.drawRect(x, y, w, h)
					if dm() then
						Drawing.setColor(255, 255, 255)
					else
						Drawing.setColor(0, 0, 0)
					end
					drawRect(x, y, w, h)
					Drawing.reset()
				end
			}
			if t.onInit then
				t.onInit(t2)
			end
		end,
		onUpdate = function(self)
			self:setPadding(p2, p3, p4, p5)
			self:setPosition(0 - p2, 0 - p3)
			self:setSize(self:getParent():getWidth(), self:getParent():getHeight())
			if t.onUpdate then
				t.onUpdate(t2)
			end
		end,
		onClick = function(self)
			self:click()
		end,
		onDraw = function(self, x, y)
			local w, h = self:getWidth(), self:getHeight()
			local p2, p3, p4, p5 = self:getPadding()
			Drawing.setColor(0, 0, 0)
			Drawing.setAlpha(0.4)
			Drawing.drawRect(x - p2, y - p3, w, h)
			Drawing.reset()
		end,
	}
	return t2
end
