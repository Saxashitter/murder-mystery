MM.endTypes = {
	{
		name = "Innocents win!",
		color = V_GREENMAP,
		results = "innocents"
	},
	{
		name = "Murderer wins!",
		color = V_REDMAP,
		results = "murderers"
	}
}

return function(self, endType)
	if MM_N.gameover then return end

	-- select theme
	local themes = {}
	for k,v in pairs(MM.themes) do
		table.insert(themes, k)
	end

	MM_N.theme = themes[P_RandomRange(1, #themes)]
	if MM.themes[MM_N.theme].init then
		MM.themes[MM_N.theme].init(endType)
	end

	local endType = MM.endTypes[endType] or 1
	MM:discordMessage("***"..endType.name.."***\n")
	
	MM_N.endType = endType
	MM_N.gameover = true

	if not MM_N.sniped_end then
		S_StopMusic(consoleplayer)
	end
	
	for mo in mobjs.iterate()
		if not (mo and mo.valid) then continue end
		if (mo == MM_N.end_camera) then continue end
		
		if mo.flags & MF_NOTHINK
			mo.notthinking = true
			continue
		end
		
		mo.flags = $|MF_NOTHINK
		S_StopSound(mo)
	end
	
	--stop spectating
	displayplayer = consoleplayer

	if (MM_N.disconnect_end) then return end
	if (MM_N.dueling) then return end
	if (MM_N.waiting_for_players) then return end
	if (MM:pregame()) then return end
	
	--pay people rings
	for p in players.iterate
		if not (p.mm) then continue end
		if not (p.mm_save) then continue end
		if (p.mm.lastafkmode and p.spectator) then continue end
		
		local payout = 0
		local reason = ""
		
		if (p.mm.role == MMROLE_INNOCENT)
			local percent = FixedDiv(
				min(p.mm.timesurvived, MM_N.maxtime)*FU, MM_N.maxtime*FU
			)
			reason = "surviving "..(p.mm.timesurvived/TICRATE).." seconds"
			payout = FixedFloor(FixedMul(50*FU, percent)) >> FRACBITS
		elseif (p.mm.role == MMROLE_MURDERER)
			--dont get paid if you suck at the game
			if (MM_N.peoplekilled >= MM_N.minimum_killed)
				local percent = FixedDiv(
					min(MM_N.peoplekilled, MM_N.numbertokill)*FU, MM_N.numbertokill*FU
				)
				local amount = FixedMul(MM_N.numbertokill*4*FU, 3*FU/4)
				amount = ease.outsine(FU/3, $, 50*FU)

				reason = "killing "..MM_N.peoplekilled.." out of "..MM_N.numbertokill.." innocents"
				payout = FixedFloor(FixedMul(amount, percent)) >> FRACBITS
			end
		--TODO: heroes
		elseif (p.mm.role == MMROLE_SHERIFF)
			local percent = FixedDiv(
				(MM_N.numbertokill - min(MM_N.peoplekilled, MM_N.numbertokill))*FU, MM_N.numbertokill*FU
			)
			reason = "saving "..(MM_N.numbertokill - min(MM_N.peoplekilled, MM_N.numbertokill)).." out of "..MM_N.numbertokill.." innocents"
			payout = FixedFloor(FixedMul(65*FU, percent)) >> FRACBITS

			--gotta be alive tho
			payout = (not p.spectator) and $ or 0
		end
		
		if payout ~= 0
			p.mm_save.rings = $ + payout
			CONS_Printf(p,"\x82Got "..payout.." ring"..(payout ~= 1 and "s" or "")..
			" that round for "..reason.."!")
		end
		p.mm.ringspaid = payout
	end
end