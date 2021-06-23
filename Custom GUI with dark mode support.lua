local darkUIMode = function()
	local b
	pcall(function()
		if TheoTown.darkUIMode then
			b = TheoTown.darkUIMode()
		end
	end)
	return b
end
local p2, p3, p4, p5 = 0, 0, 0, 0
pcall(function()
	p2, p3, p4, p5 = GUI.getRoot():getPadding()
end)
function drawOutline(x, y, w, h)
	Drawing.drawRect(x, y, w, 1)
	Drawing.drawRect(x, y + h - 1, w, 1)
	Drawing.drawRect(x, y, 1, h)
	Drawing.drawRect(x + w - 1, y, 1, h)
end
local addButton = function(self, t)
	local text = t.text or ""
	local icon = t.icon or 0
	return self:addCanvas {
		w = 10,
		h = 10,
		onInit = function(self, ...)
			self.type = "button"
			pcall(function()
				if t.id then
					self:setId(t.id)
				end
				self:setPosition(t.x or 0, t.y or 0)
			end)
			function self:click(...)
				TheoTown.playSound(Draft.getDraft("$click_sound00"), 1.3)
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
			self:setSize(10, 10)
			pcall(function()
				local iw, ih = Drawing.getImageSize(icon)
				self:setSize(math.max(self:getWidth(), iw), math.max(self:getHeight(), ih))
				self:setSize(math.min(self:getWidth(), ih), math.min(self:getHeight(), iw))
			end)
			pcall(function()
				local text = tostring(text)
				local tw = Drawing.getTextSize(text)
				if text:len() > 0 then
					--tw = tw or 0
					self:setSize(self:getWidth() + tw + 10, self:getHeight())
				end
			end)
			pcall(function()
				pcall(function()
					if self:getX() < 0 then
						self:setPosition((0 + self:getParent():getWidth()) + self:getX(), self:getY())
					end
				end)
				pcall(function()
					if self:getY() < 0 then
						self:setPosition(self:getX(), (0 + self:getParent():getHeight()) + self:getY())
					end
				end)
			end)
			pcall(function()
				self:setSize(math.max(self:getWidth(), t.width or t.w or (self:getParent():getClientWidth() - self:getX())), t.height or t.h or (self:getParent():getClientHeight() - self:getY()))
			end)
			pcall(function()
				local enabled = true
				if t.enabled then
					enabled = t.enabled
				end
				self:setEnabled(enabled)
			end)
			if t.onInit then
				t.onInit(self, ...)
			end
		end,
		onUpdate = function(...)
			local t2 = table.pack(...)
			if t.onUpdate then
				pcall(function()
					t.onUpdate(table.unpack(t2))
				end)
			end
		end,
		onClick = function(self, ...)
			self:click(...)
		end,
		onDraw = function(self, x, y, w, h)
			local text = text
			local isPressed = t.isPressed
			if type(isPressed) == "function" then
				pcall(function()
					isPressed = isPressed()
				end)
			end
			if type(text) == "function" then
				pcall(function()
					text = text()
				end)
			end
			text = tostring(text)
			local dc, dc2 = 0, 255
			if darkUIMode() then
				dc = 255
				dc2 = 0
			end
			if t.clipping then
				Drawing.setClipping(t.clipping())
			end
			local tw, th = 0, 0
			pcall(function()
				tw, th = Drawing.getTextSize(text)
			end)
			pcall(function()
				if t.golden then
					Drawing.setColor(dc, dc, dc)
				else
					Drawing.setColor(dc2, dc2, dc2)
				end
			end)
			do
				local r, g, b = Drawing.getColor()
				local a = Drawing.getAlpha()
				if t.color then
					local rr, gg, bb, aa = t.color()
					Drawing.setColor(rr or r, gg or g, bb or b)
					Drawing.setAlpha(aa or a)
				end
			end
			if not self:isEnabled() then
				Drawing.setAlpha(Drawing.getAlpha() / 2)
			end
			Drawing.drawRect(x, y, w, h)
			pcall(function()
				if t.golden then
					Drawing.setColor(dc2, dc2, dc2)
				else
					Drawing.setColor(dc, dc, dc)
				end
			end)
			Drawing.setAlpha(1)
			if (self:getTouchPoint() or self:isMouseOver() or isPressed) and self:isEnabled() then
				if self:getTouchPoint() then
					Drawing.setAlpha(0.3)
				elseif isPressed then
					Drawing.setAlpha(0.25)
				elseif self:isMouseOver() then
					Drawing.setAlpha(0.2)
				end
				Drawing.drawRect(x, y, w, h)
			end
			Drawing.reset()
			do
				local iw, ih = Drawing.getImageSize(icon)
				local hx, hy = Drawing.getImageHandle(icon)
				local xx = x + (w / 2) - (iw / 2)
				if text:len() > 1 then
					xx = x + (30 / 2) - (iw / 2)
				end
				if not self:isEnabled() then
					Drawing.setAlpha(Drawing.getAlpha() / 2)
				end
				Drawing.drawImage(icon, xx + hx, (y + (h / 2) - (ih / 2)) + hy)
			end
			Drawing.reset()
			do
				local xx = x + (w / 2) - (tw / 2)
				if icon > 0 then
					xx = x + 30
				end
				pcall(function()
					if t.golden then
						Drawing.setColor(dc2, dc2, dc2)
					else
						Drawing.setColor(dc, dc, dc)
					end
				end)
				local r, g, b = Drawing.getColor()
				local a = Drawing.getAlpha()
				if t.color then
					local rr, gg, bb, aa = t.color()
					Drawing.setColor(rr or r, gg or g, bb or b)
					Drawing.setAlpha(aa or a)
				end
				if not self:isEnabled() then
					Drawing.setAlpha(Drawing.getAlpha() / 2)
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
			if not self:isEnabled() then
				Drawing.setAlpha(Drawing.getAlpha() / 2)
			end
			drawOutline(x, y, w, h)
			Drawing.resetClipping()
			Drawing.reset()
		end
	}
end
GUI.addButton = addButton
local addLabel = function(self, t)
	local text = t.text or ""
	local r, g, b
	local ax, ay = 0, 0.5
	local font = t.font or Font.DEFAULT
	local rgb = function()
		if darkUIMode() then
			return 255, 256, 255
		else
			return 0, 0, 0
		end
	end
	return self:addCanvas {
		width = t.width,
		w = t.w,
		height = t.height,
		h = t.h,
		x = t.x or 0,
		y = t.y or 0,
		onInit = function(self, ...)
			pcall(function()
				self.type = "label"
				if t.id then
					self:setId(t.id)
				end
				function self:getText()
					return text
				end
				function self:setText(s)
					text = s
				end
				function self:setFont(s)
					font = s
				end
				function self:getFont()
					return font
				end
				function self:setColor(rr, gg, bb)
					r, g, b = rr, gg, bb
				end
				function self:setAlignment(a1, a2)
					ax, ay = a1 or 0, a2 or 0
				end
				function self:getAlignment()
					return ax, ay
				end
				self:setTouchThrough(true)
				pcall(function()
					self:setPosition(t.x or 0, t.y or 0)
				end)
				pcall(function()
					self:setSize(t.width or t.w or (self:getParent():getClientWidth() - self:getX()), t.height or t.h or (self:getParent():getClientHeight() - self:getY()))
				end)
			end)
			if t.onInit then
				t.onInit(self, ...)
			end
		end,
		onDraw = function(self, x, y, w, h)
			local text = tostring(text)
			Drawing.setColor(rgb())
			pcall(function()
				Drawing.setColor(r, g, b)
			end)
			local tw, th = Drawing.getTextSize(text, font)
			Drawing.drawText(text, x + (w * ax) - (tw * ax), y + (h * ay) - (th * ay), font)
		end,
		onUpdate = function(...)
			if t.onUpdate then
				t.onUpdate(...)
			end
		end
	}
end
GUI.addLabel = addLabel
local addPanel = function(self, t)
	pcall(function()
		if not t.onDraw then
			t.onDraw = function(self, ...)
				if darkUIMode() then
					Drawing.setColor(0, 0, 0)
				else
					Drawing.setColor(255, 255, 255)
				end
				Drawing.drawRect(...)
				if darkUIMode() then
					Drawing.setColor(255, 255, 255)
				else
					Drawing.setColor(0, 0, 0)
				end
				drawOutline(...)
				Drawing.reset()
			end
		end
	end)
	pcall(function()
		local onInit
		if t.onInit then
			onInit = t.onInit
		end
		t.onInit = function(self, ...)
			self.type = "panel"
			if onInit then
				onInit(self, ...)
			end
		end
	end)
	return self:addCanvas (t)
end
GUI.addPanel = addPanel
local addTextFrame = function(self, t)
	local text = t.text or ""
	local gth = 10
	local y, sy, th = 0, 0, gth
	return self:addPanel {
		w = t.w,
		width = t.width,
		h = t.h,
		height = t.height,
		x = t.x or 0,
		y = t.y or 0,
		onInit = function(self, ...)
			self.type = "textFrame"
			if t.id then
				self:setId(t.id)
			end
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
					if th > self:getParent():getHeight() then
						local c = self:getParent()
						Drawing.setClipping(c:getAbsoluteX(), c:getAbsoluteY(),
						c:getWidth(), c:getHeight())
						x = x - 2
						y = y + 2
						h = h - 2
						if darkUIMode() then
							Drawing.setColor(0, 0, 0)
						else
							Drawing.setColor(255, 255, 255)
						end
						Drawing.drawRect(x - 1, y - 1, w + 2, h + 2)
						if darkUIMode() then
							Drawing.setColor(255, 255, 255)
						else
							Drawing.setColor(0, 0, 0)
						end
						drawOutline(x, y, w, h)
						Drawing.resetClipping()
						Drawing.reset()
					end
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
			if darkUIMode() then
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
GUI.addTextFrame = addTextFrame
local addListBox = function(self, t)
	t.parent = self
	t.vertical = true
	t.scroll = true
	return CLayout.addLayout (t)
end
GUI.addListBox = addListBox
local addLayout = function(self, t)
	return self:addCanvas {
		width = t.width,
		w = t.w,
		height = t.height,
		h = t.h,
		x = t.x or 0,
		y = t.y or 0,
		onInit = function(self, ...)
			self.type = "layout"
			self:setTouchThrough(true)
			local vertical
			if t.vertical then
				vertical = t.vertical
			end
			if t.id then
				self:setId(t.id)
			end
			local fp = self:addCanvas {
				w = self:getWidth(),
				h = self:getHeight(),
				x = 0,
				y = 0,
				onUpdate = function(self)
					self:setTouchThrough(true)
					self:setPosition(0, 0)
					self:setSize(self:getParent():getClientSize())
					pcall(function()
						local w, h, i = 0, 0, 1
						while self:getChild(i) do
							local c = self:getChild(i)
							pcall(function()
								pcall(function()
									c:setTouchThrough(self:getParent():getParent().type == "listBox")
								end)
								if vertical then
									h = h + (c:getHeight() + 1)
									c:setPosition(c:getX(), 0 + (h - c:getHeight() - 1))
									c:setVisible(c:getAbsoluteY() >= self:getAbsoluteY() - c:getHeight() and c:getAbsoluteY() <= self:getAbsoluteY() + (self:getHeight() - c:getHeight()) + c:getHeight())
								else
									w = w + (c:getWidth() + 1)
									c:setPosition(0 + (w - c:getWidth() - 1), c:getY())
									c:setVisible(c:getAbsoluteX() >= self:getAbsoluteX() - c:getWidth() and c:getAbsoluteX() <= self:getAbsoluteX() + (self:getWidth() - c:getWidth()) + c:getWidth())
								end
								c:setVisible(c:isVisible() and (c:getWidth() > 0 and c:getHeight() > 0))
							end)
							i = i + 1
						end
					end)
				end
			}
			function self:getFirstPart()
				return fp
			end
			local cp = self:addCanvas {
				w = self:getWidth(),
				h = self:getHeight(),
				x = 0,
				y = 0,
				onUpdate = function(self)
					self:setTouchThrough(true)
					self:setPosition(0, 0)
					self:setSize(self:getParent():getClientSize())
					pcall(function()
						local w, h, i = 0, 0, 1
						while self:getChild(i) do
							local c = self:getChild(i)
							pcall(function()
								pcall(function()
									c:setTouchThrough(self:getParent():getParent().type == "listBox")
								end)
								if vertical then
									h = h + (c:getHeight() + 1)
									c:setPosition(c:getX(), (0 + (self:getHeight() / 2)) - (h - c:getHeight() - 1))
									c:setVisible(c:getAbsoluteY() >= self:getAbsoluteY() - c:getHeight() and c:getAbsoluteY() <= self:getAbsoluteY() + (self:getHeight() - c:getHeight()) + c:getHeight())
								else
									w = w + (c:getWidth() + 1)
									c:setPosition((0 + (self:getWidth() / 2)) - (w - c:getWidth() - 1), c:getY())
									c:setVisible(c:getAbsoluteX() >= self:getAbsoluteX() - c:getWidth() and c:getAbsoluteX() <= self:getAbsoluteX() + (self:getWidth() - c:getWidth()) + c:getWidth())
								end
								c:setVisible(c:isVisible() and (c:getWidth() > 0 and c:getHeight() > 0))
							end)
							i = i + 1
						end
					end)
				end
			}
			function self:getCenterPart()
				return cp
			end
			local lp = self:addCanvas {
				w = self:getWidth(),
				h = self:getHeight(),
				x = 0,
				y = 0,
				onUpdate = function(self)
					self:setTouchThrough(true)
					self:setPosition(0, 0)
					self:setSize(self:getParent():getClientSize())
					pcall(function()
						local w, h, i = 0, 0, self:countChildren()
						while self:getChild(i) do
							local c = self:getChild(i)
							pcall(function()
								pcall(function()
									c:setTouchThrough(self:getParent():getParent().type == "listBox")
								end)
								if vertical then
									h = h + (c:getHeight() + 1)
									c:setPosition(c:getX(), (0 + self:getHeight()) - h)
									c:setVisible(c:getAbsoluteY() >= self:getAbsoluteY() - c:getHeight() and c:getAbsoluteY() <= self:getAbsoluteY() + (self:getHeight() - c:getHeight()) + c:getHeight())
								else
									w = w + (c:getWidth() + 1)
									c:setPosition((0 + self:getWidth()) - w, c:getY())
									c:setVisible(c:getAbsoluteX() >= self:getAbsoluteX() - c:getWidth() and c:getAbsoluteX() <= self:getAbsoluteX() + (self:getWidth() - c:getWidth()) + c:getWidth())
								end
								c:setVisible(c:isVisible() and (c:getWidth() > 0 and c:getHeight() > 0))
							end)
							i = i - 1
						end
					end)
				end
			}
			function self:getLastPart()
				return lp
			end
			function self:addLayout(t)
				return self:getFirstPart():addLayout(t)
			end
			function self:addLabel(t)
				return self:getFirstPart():addLabel(t)
			end
			function self:addButton(t)
				return self:getFirstPart():addButton(t)
			end
			function self:addTextFrame(t)
				return self:getFirstPart():addTextFrame(t)
			end
			function self:addTextField(t)
				return self:getFirstPart():addTextField(t)
			end
			function self:addIcon(t)
				return self:getFirstPart():addIcon(t)
			end
			function self:addCanvas(t)
				return self:getFirstPart():addCanvas(t)
			end
			function self:addPanel(t)
				return self:getFirstPart():addPanel(t)
			end
			if t.onInit then
				t.onInit(self, ...)
			end
		end,
		onUpdate = function(...)
			if t.onUpdate then
				t.onUpdate(...)
			end
		end
	}
end
GUI.addLayout = addLayout
local addSlider = function(self, t)
	local minValue = t.minValue or 0
	local maxValue = t.maxValue or 10
	local v, bt = 0
	return self:addPanel {
		width = t.width,
		w = t.w,
		height = t.height,
		h = t.h,
		x = t.x or 0,
		y = t.y or 0,
		onInit = function(self)
			local i, xx = 0, 0
			bt = self:addButton {
				w = 30,
				onUpdate = function(self)
					v = 0
					pcall(function()
						v = ((t.getValue() - minValue) / (maxValue - minValue))
					end)
					pcall(function()
						self:setPosition((self:getParent():getWidth() - self:getWidth()) * v, self:getY())
					end)
					local ov = v
					pcall(function()
						if self:getTouchPoint() then
							x, _, fx = self:getTouchPoint()
							i = i + 1
							if i == 1 then
								xx =  self:getAbsoluteX()
							else
								--_, _, _, _, sx = self:getTouchPoint()
								--self:setPosition((x - self:getParent():getAbsoluteX()) - (self:getWidth() / 2), self:getY())
								self:setPosition((x - self:getParent():getAbsoluteX()) - (fx - xx), self:getY())
								--self:setPosition(self:getX() + sx, self:getY())
								pcall(function()
									if t.setValue then
										local v2 = minValue + (self:getX() / (self:getParent():getWidth() - self:getWidth())) * maxValue
										if v2 >= minValue and v2 <= maxValue then
											t.setValue(v2)
											v = v2
										elseif v2 < minValue then
											t.setValue(minValue)
											v = minValue
										elseif v2 > maxValue then
											t.setValue(maxValue)
											v = maxValue
										end
									end
								end)
							end
						else
							i = 0
							xx = 0
						end
					end)
					pcall(function()
						if t.getText then
							self:setText(tostring(t.getText(minValue + (ov * maxValue))))
						else
							--self:setText((ov * 100)..'%')
							self:setText(math.floor(ov * 100)..'%')
						end
					end)
					pcall(function()
						local tw = Drawing.getTextSize(self:getText())
						self:setSize(math.max(30, tw + 3), self:getHeight())
					end)
					if self:getX() < 0 then
						self:setPosition(0, self:getY())
					elseif self:getX() > self:getParent():getWidth() - self:getWidth() then
						self:setPosition(self:getParent():getWidth() - self:getWidth(), self:getY())
					end
				end
			}
		end,
		onDraw = function(self, x, y, w, h)
			local w2, x2 = 0, 0
			pcall(function()
				if bt then
					w2 = bt:getWidth()
				end
			end)
			x = x + (w2 / 2)
			w = w - w2
			if darkUIMode() then
				Drawing.setColor(255, 255, 255)
			else
				Drawing.setColor(0, 0, 0)
			end
			drawOutline(x, y + (h / 2) - 2, w, 4)
			pcall(function()
				if bt then
					x2 = bt:getX()
				end
			end)
			Drawing.drawRect(x, y + (h / 2) - 2, w * (x2 / (self:getWidth() - w2)), 4)
			Drawing.reset()
		end
	}
end
GUI.addSlider = addSlider
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
				if not t.closeable then
					TheoTown.playSound(Draft.getDraft("$click_sound00"), 1.3)
					if t.onCancel then
						t.onCancel(t2)
					end
					t2.close()
				end
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
						onDraw = function(self, x, y, w, h)
							if darkUIMode() then
								Drawing.setColor(255, 255, 255)
							else
								Drawing.setColor(0, 0, 0)
							end
							local ii = self:getHeight() - 1
							for i = 0, ii do
								local h = h / (ii + 1)
								Drawing.setAlpha(1 - (1 * (i / ii)))
								Drawing.drawRect(x, y + (h * i), w, h)
							end
							Drawing.reset()
						end
					}
					do
						local text = t.title or ""
						t2.title = self:addCanvas {
							h = 30,
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
								if darkUIMode() then
									Drawing.setColor(0, 0, 0)
								else
									Drawing.setColor(255, 255, 255)
								end
								for _, v in pairs{1, 0.75, 0.5, 0.25} do
									Drawing.drawText(text, (x + v) + (w / 2) - (tw / 2), (y - v) + (h / 2) - (th / 2), Font.BIG)
									Drawing.drawText(text, (x - v) + (w / 2) - (tw / 2), (y - v) + (h / 2) - (th / 2), Font.BIG)
									Drawing.drawText(text, (x - v) + (w / 2) - (tw / 2), (y + v) + (h / 2) - (th / 2), Font.BIG)
									Drawing.drawText(text, (x + v) + (w / 2) - (tw / 2), (y + v) + (h / 2) - (th / 2), Font.BIG)
								end
								if darkUIMode() then
									Drawing.setColor(255, 255, 255)
								else
									Drawing.setColor(0, 0, 0)
								end
								Drawing.drawText(text, x + (w / 2) - (tw / 2), y + (h / 2) - (th / 2), Font.BIG)
								Drawing.reset()
							end
						}
					end
					t2.icon = self:addCanvas {
						w = 30,
						h = 30,
						onDraw = function(self, x, y, w, h)
							if t.icon then
								local iw, ih = Drawing.getImageSize(t.icon)
								local hx, hy = Drawing.getImageHandle(t.icon)
								Drawing.drawImage(t.icon, (x + hx) + (w / 2) - (iw / 2), (y + hy) + (h / 2) - (ih / 2))
							end
						end,
						onInit = function(self)
							function self:getIcon()
								return t.icon
							end
							function self:setIcon(s)
								t.icon = s
							end
							t2.title:setX(self:getWidth())
							t2.title:setWidth(t2.title:getWidth() - self:getWidth())
						end
					}
					if not t.closeable then
						self:addCanvas {
							w = 30,
							h = 30,
							x = self:getClientWidth() - 30,
							onInit = function(self)
								function self:click()
									TheoTown.playSound(Draft.getDraft("$click_sound00"), 1.3)
									if t.onCancel then
										t.onCancel(t2)
									end
									t2.close()
								end
								t2.title:setWidth(t2.title:getWidth() - self:getWidth())
							end,
							onDraw = function(self, x, y, w, h)
								local iw, ih = Drawing.getImageSize(Icon.CLOSE_BUTTON)
								if self:getTouchPoint() then
									Drawing.setColor(255, 0, 0)
								end
								Drawing.drawImage(Icon.CLOSE_BUTTON, x + (w / 2) - (iw / 2), y + (h / 2) - (ih / 2))
								Drawing.reset()
							end,
							onClick = function(self)
								self:click()
							end
						}
					end
					t2.title:setChildIndex(2)
					t2.text = self:addTextFrame {
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
						end,
						onUpdate = function(self)
							local i = 1
							while self:getChild(i) do
								local c = self:getChild(i)
								pcall(function()
									c:setPosition(c:getPosition())
								end)
								i = i + 1
							end
						end
					}
					t2.controls = self:addLayout {
						h = 30,
						y = self:getClientHeight() - 30,
						onInit = function(self)
							local addButton = function(t)
								self:getLastPart():addButton {
									--parent = self:getLastPart(),
									icon = t.icon,
									text = t.text,
									golden = t.golden,
									id = t.id,
									w = 30,
									color = function()
										
									end,
									onClick = function(...)
										local t3 = table.pack(...)
										pcall(function()
											if t.onClick then
												t.onClick(table.unpack(t3))
											end
										end)
										local autoClose = true
										pcall(function()
											if type(t.autoClose) ~= "nil" then
												autoClose = t.autoClose
											end
										end)
										if autoClose then
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
							if darkUIMode() then
								Drawing.setColor(255, 255, 255)
							else
								Drawing.setColor(0, 0, 0)
							end
							drawOutline(...)
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
					if darkUIMode() then
						Drawing.setColor(0, 0, 0)
					else
						Drawing.setColor(255, 255, 255)
					end
					Drawing.drawRect(x, y, w, h)
					if darkUIMode() then
						Drawing.setColor(255, 255, 255)
					else
						Drawing.setColor(0, 0, 0)
					end
					drawOutline(x, y, w, h)
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
GUI.createDialog = createDialog
local createRenameDialog = function(t)
	local v = function() return "" end
	return createDialog {
		width = t.width,
		w = t.w,
		height = t.height,
		h = t.h,
		title = t.title,
		text = t.text,
		icon = t.icon,
		onInit = function(self)
			self.content:addTextField {
				h = 30,
				y = 15,
				onInit = function(self)
					pcall(function()
						if type(t.value) ~= "nil" then
							self:setText(t.value)
						end
					end)
					v = function()
						return self:getText()
					end
				end
			}
			self.controls:getLastPart():addButton {
				icon = t.okIcon or Icon.OK,
				text = t.okText or "Rename",
				w = 30,
				onClick = function()
					t.onOk(v())
				end,
				onUpdate = function(self)
					if t.filter then
						self:setEnabled(t.filter())
					else
						self:setEnabled(true)
					end
				end
			}
		end,
		actions = {
			{
				icon = t.cancelIcon or Icon.CANCEL,
				text = t.cancelText or "Cancel",
				onClick = function()
					t.onCancel()
				end
			}
		}
	}
end
GUI.createRenameDialog = createRenameDialog
GUI.getType = function(self)
	local t = ""
	pcall(function()
		if type(self.type) ~= "nil" then
			t = self.type
		end
	end)
	return tostring(t)
end
GUI.getRoot().type = "root"
GUI.getSize = function(self)
	return self:getWidth(), self:getHeight()
end
GUI.getClientSize = function(self)
	return self:getClientWidth(), self:getClientHeight()
end
GUI.getPosition = function(self)
	return self:getX(), self:getY()
end
GUI.getAbsolutePosition = function(self)
	return self:getAbsoluteX(), self:getAbsoluteY()
end
GUI.setX = function(self, x)
	self:setPosition(x or self:getX(), self:getY())
end
GUI.setY = function(self, y)
	self:setPosition(self:getX(), y or self:getY())
end
GUI.setWidth = function(self, w)
	self:setSize(w or self:getWidth(), self:getHeight())
end
GUI.setHeight = function(self, h)
	self:setSize(self:getWidth(), h or self:getHeight())
end
