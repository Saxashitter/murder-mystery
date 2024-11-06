local roles = MM.require "Variables/Data/Roles"

local vowels = {
	["a"] = true,
	["e"] = true,
	["i"] = true,
	["o"] = true,
	["u"] = true,
}

local teammates
local function HUD_TFW_DrawTeammates(v,p)
	if (p.mm.role == MMROLE_INNOCENT) then return end
	
	if not teammates
		teammates = {}
		
		table.insert(teammates,p)
		for play in players.iterate
			if (play == p) then continue end
			if not (play.mm) then continue end
			if (play.mm.role ~= p.mm.role) then continue end
			
			table.insert(teammates,play)
		end
	end
	
	if #teammates
		local work = 0
		for k,play in ipairs(teammates)
			
			local hires = FU
			if (skins[play.skin].highresscale)
				hires = skins[play.skin].highresscale
			end
			
			v.drawScaled(5*FU - MMHUD.weaponslidein,
				65*FU + work,
				hires/2,
				v.getSprite2Patch(play.skin,SPR2_LIFE,false,0,0,0),
				V_SNAPTOLEFT,
				v.getColormap(play.skin,play.skincolor)
			)
			
			v.drawString(10*FU - MMHUD.weaponslidein,
				60*FU + work,
				play.name,
				V_SNAPTOLEFT|V_ALLOWLOWERCASE|(play == p and V_YELLOWMAP or roles[p.mm.role].color),
				"thin-fixed"
			)
			
			work = $ + 10*FU
		end
		
		v.drawString(5*FU - MMHUD.weaponslidein,
			50*FU,
			"Team:",
			V_SNAPTOLEFT|V_ALLOWLOWERCASE,
			"fixed"
		)
	end
	
end

local function HUD_TimeForWeapon(v,p)
	if not MM:isMM() then return end
	if not (p.mo and p.mo.health and p.mm) then return end
	
	if MM_N.waiting_for_players then
		v.drawString(160*FU,
			40*FU - MMHUD.weaponslidein,
			"Waiting for players...",
			V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-center"
		)
		return
	end
	
	if leveltime >= 10*TICRATE + 5 then return end
	
	local time = (10*TICRATE)-leveltime
	if (leveltime <= 4)
		teammates = nil
	end

	do
		local color = roles[p.mm.role].colorcode
		local name = roles[p.mm.role].name
		local grammar = ''
		if vowels[string.sub(string.lower(name),1,1)] == true
			grammar = "n"
		end
		
		v.drawString(160*FU,
			32*FU - MMHUD.weaponslidein,
			"You're a"..grammar..' '..color..name.."\x80!",
			V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-fixed-center"
		)
	end
	
	v.drawString(160*FU,
		40*FU - MMHUD.weaponslidein,
		roles[p.mm.role].weapon and "You'll get your weapon in" or
		"Round starts in",
		V_SNAPTOTOP|V_ALLOWLOWERCASE,
		roles[p.mm.role].weapon and "thin-fixed-center" or "fixed-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		50*FU - MMHUD.weaponslidein,
		FU,
		v.cachePatch("STTNUM"..(time/TICRATE)),
		V_SNAPTOTOP
	)

	v.drawString(160*FU,
		140*FU + MMHUD.weaponslidein,
		"\x85"..MM_N.special_count.." Murderer"..(MM_N.special_count > 1 and "s" or '').."\x80 this round.",
		V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
		"thin-fixed-center"
	)
	if p == consoleplayer
		local mchance = p.mm_save.cons_murderer_chance
		local schance = p.mm_save.cons_sheriff_chance
		local y = 148*FU + MMHUD.weaponslidein
		
		v.drawString(160*FU,
			y,
			string.format("%.2f",mchance).."% Murderer chance",
			V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_REDMAP,
			"thin-fixed-center"
		)
		v.drawString(160*FU,
			y + (8*FU),
			string.format("%.2f",schance).."% Sheriff chance",
			V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_BLUEMAP,
			"thin-fixed-center"
		)
	end
	
	if (leveltime >= 4)
		HUD_TFW_DrawTeammates(v,p)
	end
end

return HUD_TimeForWeapon