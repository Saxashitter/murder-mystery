customhud.SetupFont("STCFG")

local function sortByDist(a,b) -- Because making a function every frame causes lag.
	local viewx, viewy, viewz, viewangle, aimingangle, viewroll = SG_GetViewVars(nil, displayplayer, camera, true)

	local dist1 = R_PointToDist2(viewx, viewy, a.mo.x, a.mo.y)
	local dist2 = R_PointToDist2(viewx, viewy, b.mo.x, b.mo.y)

	return dist1 > dist2
end

-- Chat bubble.

local function _getChatBubbleParts(v)
	local name = "CHATBUBBLE"
	local chatbubble = v.cachePatch("CHATBUBBLE")

	local parts = {}

	-- offset by amount of blank spaces
	local width = chatbubble.width-4
	local height = chatbubble.height-1

	local tileWidth = width/5
	local tileHeight = height/2

	for y = 0, height / tileHeight do
		parts[y+1] = {}
		for x = 0, width / tileWidth do
			parts[y+1][x+1] = {
				x = ((x*tileWidth)+x)*FU,
				y = ((y*tileHeight)+y)*FU,
				width = tileWidth*FU,
				height = tileHeight*FU
			}
		end
	end

	return chatbubble, parts
end

local function drawChatBubble(v, x, y, scale, str, color, wisp)
	local chatbubble, parts = _getChatBubbleParts(v)

	local leftBorder = parts[1][1]
	local extendablePart = parts[1][2]
	local centerPart = parts[1][3]
	local rightBorder = parts[1][5]


	local width = customhud.CustomFontStringWidth(v, str, "STCFG", scale)
	if width >= FixedMul(leftBorder.width, scale)*2 then
		width = $-FixedMul(leftBorder.width, scale)
	end

	y = $ - (9*scale)

	if wisp then
		v.drawCropped(
			x-FixedMul(parts[2][3].width, scale/2), y-(scale*2),
			scale, scale,
			chatbubble,
			0,
			color and v.getColormap(nil, color),
			parts[2][3].x,
			parts[2][3].y,
			parts[2][3].width,
			parts[2][3].height)
	end

	y = $ - (16*scale)

	local progress = 0

	v.drawCropped(
		x-(width/2)-FixedMul(leftBorder.width, scale), y,
		scale, scale,
		chatbubble,
		0,
		color and v.getColormap(TC_RAINBOW, color),
		leftBorder.x,
		leftBorder.y,
		leftBorder.width,
		leftBorder.height)

	v.drawCropped(
		x+(width/2), y,
		scale, scale,
		chatbubble,
		0,
		color and v.getColormap(TC_RAINBOW, color),
		rightBorder.x,
		rightBorder.y,
		rightBorder.width,
		rightBorder.height)

	local stretchScale = FixedDiv(width, FixedMul(extendablePart.width, scale))

	v.drawCropped(
		x-(width/2), y,
		FixedMul(stretchScale, scale), scale,
		chatbubble,
		0,
		color and v.getColormap(TC_RAINBOW, color),
		extendablePart.x,
		extendablePart.y,
		extendablePart.width,
		extendablePart.height)

	v.drawCropped(
		x-FixedMul(centerPart.width/2, scale), y,
		scale, scale,
		chatbubble,
		0,
		color and v.getColormap(TC_RAINBOW, color),
		centerPart.x,
		centerPart.y,
		centerPart.width,
		centerPart.height)

	customhud.CustomFontString(v,
		x, y+(4*scale),
		str,
		"STCFG",
		nil,
		"center",
		scale,
		SKINCOLOR_WHITE)

end
-- Code stuff
local function playerHUDThink(v,p,c,p2)
	if not (p and p.mo and p2 and p2.mo and P_CheckSight(p.mo, p2.mo)) then return end

	local x = p2.mo.x
	local y = p2.mo.y
	local z = p2.mo.z+FixedMul(p2.mo.height, p2.mo.scale)

	if P_MobjFlip(p2.mo) == -1 then
		z = p2.mo.z-(16*FU)
	end

	local result = SG_ObjectTracking(v,p,c,{
		x = p2.mo.x,
		y = p2.mo.y,
		z = p2.mo.z+FixedMul(p2.mo.height, p2.mo.scale)+(6*FU)
	})
	local color = p2.skincolor

	if not result.onScreen then return end

	if p2.mm.chat_messages then
		for _,msg in ipairs(p2.mm.chat_messages) do
			local i = #p2.mm.chat_messages-_
			local y = result.y - ((18*result.scale)*i)
			drawChatBubble(v, result.x, y, result.scale, msg.msg, p2.mo.color, i == 0)
		end
	end
end

addHook("HUD", function(v,p,c)
	if not MM:isMM() then return end
	local nametagStuff = {}

	for p2 in players.iterate do
		if not (p2 and p2.valid and p2.mo and p2.mm and p2.mo.health) then continue end
		nametagStuff[#nametagStuff+1] = p2
	end

	table.sort(nametagStuff, sortByDist)

	for k,p2 in ipairs(nametagStuff) do
		playerHUDThink(v,p,c,p2)
	end
end)

addHook("PlayerThink", function(p)
	if not (p and p.valid and p.mm) then return end

	local rmvList = {}

	for i,msg in pairs(p.mm.chat_messages) do
		msg.time = $-1
		if not (msg.time) then
			rmvList[#rmvList+1] = i
		end
	end

	for _,i in pairs(rmvList) do
		table.remove(p.mm.chat_messages, i)
	end
end)

addHook("PlayerMsg", function(p, t, trgt, msg)
	if not MM:isMM() then return end
	if gamestate ~= GS_LEVEL then return end

	if not (p
	and p.valid
	and p.mo
	and p.mm) then return true end

	if t then
		return true
	end

	p.mm.chat_messages[#p.mm.chat_messages+1] = {
		time = 8*TICRATE,
		msg = msg
	}

	if #p.mm.chat_messages > 5 then
		table.remove(p.mm.chat_messages, 1)
	end

	S_StartSound(p.mo, sfx_radio)

	return true
end)