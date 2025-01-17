local roles = MM.require "Variables/Data/Roles"
local TR = TICRATE

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
			if not (play and play.valid)
				table.remove(teammates,k)
				continue
			end
			
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

local lastp
local function HUD_TimeForWeapon(v,p)
	if not MM:isMM() then return end
	--if not (p.mo and p.mo.health and p.mm) then return end
	
	if MM_N.waiting_for_players then
		v.drawString(160*FU,
			40*FU - MMHUD.weaponslidein,
			"Waiting for players...",
			V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-center"
		)
		return
	end
	
	if leveltime >= MM_N.pregame_time + 5 then return end
	
	local time = (MM_N.pregame_time)-leveltime
	if (leveltime < TR)
	or (displayplayer ~= lastp)
		teammates = nil
	end
	lastp = displayplayer
	
	if not (p.spectator)
		local color = roles[p.mm.role].colorcode
		local name = roles[p.mm.role].name
		local grammar = ''
		if vowels[string.sub(string.lower(name),1,1)] == true
			grammar = "n"
		end
		local text = (MM_N.dueling and "You're dueling!" or "You're a"..grammar..' '..color..name.."\x80!")
		
		v.drawString(160*FU,
			32*FU - MMHUD.weaponslidein,
			text,
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
	do
		local letterpatch = v.cachePatch("STTNUM"..(time/TR))
		local letteroffset = v.cachePatch("STTNUM0").width*FU * tostring(time/TR):len()
		local yoff = 0
		if time/TR <= 3
			letterpatch = v.cachePatch("RACE"..(time/TR == 0 and "GO" or (time/TR)))
			letteroffset = letterpatch.width*FU
			if (time % TR) > TR*3/4
				yoff = 9*FU - (TR - (time % TR))*FU
				yoff = ease.linear(FU*3/4,$,0)
			end

			if (MM_N.dueling and time/TR == 0)
				v.drawString(160*FU,
					50*FU - MMHUD.weaponslidein - yoff,
					"DUEL!!",
					V_SNAPTOTOP|V_YELLOWMAP,
					"fixed-center"
				)
			else
				v.drawScaled(160*FU - letteroffset/2,
					50*FU - MMHUD.weaponslidein - yoff,
					FU,
					letterpatch,
					V_SNAPTOTOP
				)
			end

		else
			local work = 0
			local tstr = tostring(time/TR)
			for i = 1,string.len(tstr)
				v.drawScaled(160*FU - letteroffset/2 + work,
					50*FU - MMHUD.weaponslidein - yoff,
					FU,
					v.cachePatch("STTNUM"..string.sub(tstr,i,i)),
					V_SNAPTOTOP
				)
				work = $ + v.cachePatch("STTNUM0").width*FU
			end

		end
		
	end
	
	v.drawString(160*FU,
		150*FU + MMHUD.weaponslidein,
		"\x85"..MM_N.special_count.." Murderer"..(MM_N.special_count ~= 1 and "s" or '').."\x80 this round.",
		V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
		"thin-fixed-center"
	)
	if p == consoleplayer
	and not (p.spectator)
		local mchance = p.mm_save.cons_murderer_chance
		--local schance = p.mm_save.cons_sheriff_chance
		local y = 158*FU + MMHUD.weaponslidein
		
		v.drawString(160*FU,
			y,
			string.format("%.2f",mchance).."% chance to be a Murderer",
			V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_REDMAP,
			"thin-fixed-center"
		)
		/*
		v.drawString(160*FU,
			y + (8*FU),
			string.format("%.2f",schance).."% chance to be a Sheriff",
			V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_BLUEMAP,
			"thin-fixed-center"
		)
		*/
	end
	
	if (leveltime >= TR)
		HUD_TFW_DrawTeammates(v,p)
	end
end

return HUD_TimeForWeapon