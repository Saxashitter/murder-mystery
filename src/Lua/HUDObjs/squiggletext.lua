local object = {}
local space = 8
local patches = {}

local function patchc(v, patch)
	if not (patches[patch]) then
		patches[patch] = v.cachePatch(patch)
	end

	return patches[patch]
end

local function draw_byte(v, x, y, s, byte, flags, color)
	local byte_str = string.format("STCFN%03d", byte)

	if not v.patchExists(byte_str) then return space end

	local patch = patchc(v, byte_str)

	v.drawScaled(x, y, s, patch, flags, color)
	return patch.width
end

local function get_text_width(v, str, scale)
	local width = 0

	for i = 1, #str do
		local byte = string.sub(str, i, i):byte()

		local gwidth = space
		local byte_str = string.format("STCFN%03d", byte)

		if v.patchExists(byte_str) then
			gwidth = patchc(v, byte_str).width
		end

		width = $+(gwidth*scale)
	end

	return width
end

local function draw_text(self, v, flags)
	local x = self.x
	local y = self.y

	if not (#self.text) then return end

	local width = get_text_width(v, self.text, self.scale)

	if self.align == "center" then
		x = $-(width/2)
	end
	if self.align == "right" then
		x = $-width
	end

	local angle = self.angle

	for i = 1, #self.text do
		local bit = string.sub(self.text, i, i)
		local byte = bit:byte()

		local _x = x
		local _y = y
		local color = nil

		if self.wiggle then
			y = $+FixedMul(self.strength, FixedMul(cos(angle), self.scale))
		end
		if self.shake then
			_x = $+v.RandomRange(-self.rumblepwr, self.rumblepwr)
			_y = $+v.RandomRange(-self.rumblepwr, self.rumblepwr)
		end
		if self.color then
			color = v.getColormap(TC_RAINBOW, self.color)
		end
		local space = draw_byte(v, _x, _y, self.scale, byte, flags, color)
		x = $+(space*self.scale)
		angle = $+self.change
	end

	self.angle = $+FixedAngle(self.speed)
end

setmetatable(object, {
	__call = function(self, x, y, scale, text, align, color, props, flags)
		local scale = scale or FU
		local text = text or "i pissed myself"
		local align = align or "left"
		local strength = props and props.strength or FU*3
		local rumblepwr = props and props.rumblepwr or FU*2
		local speed = props and props.speed or 4*FU
		local change = props and props.change or 32*ANG1
		local shake = props and props.shake
		local wiggle = props and props.wiggle
		local flags = flags or 0

		local obj = {}

		obj.x = x
		obj.y = y
		obj.scale = scale
		obj.text = text
		obj.strength = strength
		obj.speed = speed
		obj.align = align
		obj.change = change
		obj.shake = shake
		obj.wiggle = wiggle
		obj.rumblepwr = rumblepwr
		obj.color = color

		obj.draw = draw_text

		obj.angle = 0

		return obj
	end
})

return object