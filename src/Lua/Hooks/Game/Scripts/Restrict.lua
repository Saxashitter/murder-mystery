return function()
	--Funny
	if leveltime == 10*TICRATE and isserver then
		CV_Set(CV_FindVar("restrictskinchange"),1)
	end

	-- Set the locked skincolor 
	if leveltime == 10*TICRATE then
		for p in players.iterate do
			if not (p and p.mo and p.mm) then continue end
			if p.mm.joinedmidgame then continue end
			if p.spectator then continue end
			
			p.mm.permanentcolor = p.skincolor
			p.mm.permanentskin = skins[p.skin].name
			
			-- r_ = restored
			p.mm_save.r_color = p.skincolor 
			p.mm_save.r_skin = skins[p.skin].name
		end
	end
	
	if leveltime >= 10*TICRATE then
		for p in players.iterate do
			if not (p and p.mo and p.mm) then continue end
			if p.mm.joinedmidgame then continue end
			if p.spectator then continue end
			
			if p.mm.permanentcolor ~= nil then
				if p.mm.permanentcolor ~= p.skincolor 
				and p.mo.color ~= p.mm.lastcolor then
					p.skincolor = p.mm.permanentcolor
					
					p.mo.color = p.mm.lastcolor
				end
			end
			
			p.mm.lastcolor = p.mo.color 
		end
	end
end