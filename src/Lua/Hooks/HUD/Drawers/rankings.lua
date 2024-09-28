local TILEWIDTH = 64
local TILEHEIGHT = 16
local TILEMARGIN = 2
local ROWLENGTH = 300 / TILEWIDTH

local function isDead(p)
	-- print("death", (not (p and p.mo and p.mo.valid)), p.spectator, p.mo.health <= 0)
	return (not (p and p.mo and p.mo.valid)) or p.spectator or p.mo.health <= 0
end

local SECRECY_NOTSECRET = 0
local SECRECY_MURDERERALLOWED = 1
local SECRECY_SECRET = 2

local ROLESTYLES = {
	Unknown = {
		bgcolor = 197,
		secrecy = SECRECY_NOTSECRET
	},
	Dead = {
		bgcolor = 15,
		subtitle = "\x86" .. "Dead",
		secrecy = SECRECY_MURDERERALLOWED
	},
	MidgameJoin = {
		bgcolor = 15,
		subtitle = "\x82(joined midgame)",
		secrecy = SECRECY_NOTSECRET
	},
	Innocent = {
		bgcolor = 1975,
		subtitle = "Innocent",
		secrecy = SECRECY_SECRET
	},
	Murderer = {
		bgcolor = 40,
		subtitle = "\x85Murderer",
		secrecy = SECRECY_MURDERERALLOWED
	},
	Sheriff = {
		bgcolor = 149,
		subtitle = "\x84Sherrif",
		secrecy = SECRECY_SECRET
	}
}

local function getViewedPlayerRole(player, viewer)
	local role = "Unknown"

	if not player.mm then return "Unknown" end
	if player.mm.joinedmidgame then
		role = "MidgameJoin"
	elseif isDead(player) then
		role = "Dead"
	else
		role = MM.roleInfos[player.mm.role][1]
	end

	if player == viewer then
		-- i should know what i am
		return role
	end

	local secrecyLevel = (ROLESTYLES[role] and ROLESTYLES[role].secrecy) or 0
	local privilegeLevel = SECRECY_NOTSECRET
	if isDead(viewer) then
		privilegeLevel = SECRECY_SECRET
	elseif (viewer.mm and viewer.mm.role == 2) then
		privilegeLevel = SECRECY_MURDERERALLOWED
	end
	print(player.name .. ": " .. role .. " with secrecy " .. secrecyLevel .. " and priv " .. privilegeLevel)
	if (privilegeLevel < secrecyLevel) then
		role = "Unknown"
	end
	return role
end

--[[@param v videolib]]
local function HUD_TabScoresDrawer(v)
	local playerlist = {}
	-- while #playerlist < 32 do
	for p in players.iterate do
		if p and p.valid then
			table.insert(playerlist, p)
		end
	end
	-- end
	-- while #playerlist > 32 do
	-- 	table.remove(playerlist, #playerlist)
	-- end
	
	local xroot = 160 - TILEWIDTH/2 - (min(ROWLENGTH, #playerlist)-1)*(TILEWIDTH+TILEMARGIN)/2
	local yroot = 100 - TILEHEIGHT/2 - ((#playerlist-1)/ROWLENGTH)*(TILEHEIGHT+TILEMARGIN)/2
	
	for ind, p in ipairs(playerlist) do
		local x = xroot + (TILEWIDTH+TILEMARGIN)*((ind-1)%ROWLENGTH)
		local y = yroot + (TILEHEIGHT+TILEMARGIN)*((ind-1)/ROWLENGTH)
		
		local role = getViewedPlayerRole(p, consoleplayer)
		local roleStyle = ROLESTYLES[role] or ROLESTYLES.Unknown
		-- v.drawFill(x, y, TILEWIDTH, TILEHEIGHT, roleStyle.bgcolor)


		--#region life icon
		local iconpatch = v.getSprite2Patch(p.skin, SPR2_XTRA, false, A)
		local stndpatch = v.getSprite2Patch(p.skin, SPR2_STND, false, A)
		if iconpatch == stndpatch then
			iconpatch = v.cachePatch("WHODISICON")
		end
		v.drawScaled(x*FU, y*FU, FU/2, iconpatch, 0, v.getColormap(p.skin, p.skincolor))
		--#endregion

		--#region name rendering
		local style = "small"
		local name = p.name
		-- name = string.sub(name, 1, sin(ANG2*leveltime)/(FU/12)+14)
		if v.stringWidth(name, 0, "small") >= (TILEWIDTH-18) then
			style = "small-thin"
			if v.stringWidth(name, 0, "thin")/2 >= (TILEWIDTH-16) then
				while v.stringWidth(name .. "...", 0, "thin")/2 >= (TILEWIDTH-16) do
					name = string.sub(name, 1, #name-1)
				end
				name = name .. "..."
			end
		end
		v.drawString(
			x + 17, y,
			name, V_ALLOWLOWERCASE,
			style
		)
		--#endregion

		if roleStyle.subtitle then
			style = "small"
			if v.stringWidth(roleStyle.subtitle, 0, "small") >= (TILEWIDTH-18) then
				style = "small-thin"
			end
			v.drawString(
				x + 17, y+5,
				roleStyle.subtitle, V_ALLOWLOWERCASE,
				style
			)
		end
	end
end

return HUD_TabScoresDrawer