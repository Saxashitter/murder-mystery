MM.showdownSprites = {
	["sonic"] = "MMSD_SONIC";
	["tails"] = "MMSD_TAILS";
	["knuckles"] = "MMSD_KNUCKLES";
	["amy"] = "MMSD_AMY";
	["fang"] = "MMSD_FANG";
	["metalsonic"] = "MMSD_METAL";
	-- you may be asking why im doing this instead of directly getting the XTRAB0 spr2
	-- i wanna plan to add custom sprites for this sometime soon
}

local Squiggle = MM.require "HUDObjs/squiggletext"
local int_ease = MM.require "Libs/int_ease"

local last_innocent_data
local murderer_data
local showdown_text
local showdown_str = "SHOWDOWN!!"
local got_players = false

return function(v, p)
	if (not MM_N.showdown or MM_N.gameover) then
		last_innocent_data = nil
		murderer_data = nil
		got_players = false
		showdown_text = nil
		return
	end

	-- its showdown? iterate through players and get the last innocent and murderers
	if not got_players then
		for p in players.iterate do
			if not (p and p.mo and p.mo.health and p.mm and not p.mm.spectator) then continue end

			if p.mm.role ~= 2 then
				last_innocent_data = {
					skin = p.mo.skin,
					color = p.mo.color
				}
				continue
			end

			murderer_data = {
				skin = p.mo.skin,
				color = p.mo.color
			}

			if (last_innocent_data and murderer_data) then break end
			-- TODO: rewrite code and put in where showdown starts, this is just a placeholder cause im lazy
		end
		showdown_text = Squiggle(160*FU,
			200*FU,
			FU*3,
			string.sub(showdown_str, 1, 1),
			"center",
			SKINCOLOR_RED,
			{
				shake = true,
				wiggle = false
			},
			V_SNAPTOBOTTOM)
		got_players = true
	end

	if not (MM_N.showdown_ticker) then return end

	local start_t = max(0, min(FixedDiv(MM_N.showdown_ticker, TICRATE), FU))
	local end_t = max(0, min(FixedDiv((3*TICRATE)-MM_N.showdown_ticker, TICRATE), FU))

	local t = MM_N.showdown_ticker < TICRATE and start_t or end_t

	-- insert showdown animation here, not ready yet
	if MM_N.showdown_ticker < 3*TICRATE then
		local twn = int_ease(t, 0, 16)
		v.fadeScreen(0xFF00, twn)

		if last_innocent_data then
			local data = last_innocent_data
			local patch = v.cachePatch(MM.showdownSprites[data.skin] or MM.showdownSprites["sonic"])
			local scale = FU
			local color = v.getColormap(data.skin, data.color)

			local x = ease.outcubic(t, -patch.width*FU, -patch.width*(FU/3))
			local y = 20*FU

			x = $+v.RandomRange(-2*FU, 2*FU)
			y = $+v.RandomRange(-2*FU, 2*FU)

			v.drawScaled((320*FU)-x, y, FU, patch, V_SNAPTORIGHT|V_FLIP, color)
		end
		
		if murderer_data then
			local data = murderer_data
			local patch = v.cachePatch(MM.showdownSprites[data.skin] or MM.showdownSprites["sonic"])
			local scale = FU
			local color = v.getColormap(data.skin, data.color)

			local x = ease.outcubic(t, -patch.width*FU, -patch.width*(FU/3))
			local y = 20*FU

			x = $+v.RandomRange(-2*FU, 2*FU)
			y = $+v.RandomRange(-2*FU, 2*FU)

			v.drawScaled(x, y, FU, patch, V_SNAPTOLEFT, color)
		end

		local width = v.nameTagWidth "SHOWDOWN!"
		local x = (160*FU)-(width*(FU/2))
		local y = ease.outcubic(t, 200*FU, 162*FU)

		/*x = $+v.RandomRange(-2*FU, 2*FU)
		y = $+v.RandomRange(-2*FU, 2*FU)

		v.drawScaledNameTag(x, y, "SHOWDOWN", V_SNAPTOBOTTOM, FU, SKINCOLOR_RED, SKINCOLOR_WHITE)*/

		local text_twn = ease.linear(FixedDiv(MM_N.showdown_ticker, 16), 1, #showdown_str)

		showdown_text.text = string.sub(showdown_str, 1, text_twn)
		showdown_text.y = y
		showdown_text:draw(v)
	end
end