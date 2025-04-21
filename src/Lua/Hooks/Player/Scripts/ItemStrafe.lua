local function ApplyStrafe(p)
	--no PF_FORCESTRAFE since that turns camera turn buttons
	--into strafe movement buttons (we want to keep old behavior)
	p.pflags = $ &~(PF_ANALOGMODE|PF_DIRECTIONCHAR)
	p.drawangle = p.cmd.angleturn << 16
end
local function NoStrafe(p)
	p.pflags = $ &~(PF_FORCESTRAFE|PF_ANALOGMODE)
end

return function(player)
	if player and player.valid and player.mm and player.mo and player.mo.valid then
		local item = player.mm.inventory.items[player.mm.inventory.cur_sel]
		
		if not (item) then
			NoStrafe(player)
			return 
		end
		
		if item.nostrafe or player.mm.inventory.hidden then
			NoStrafe(player)
			return
		end
		
		ApplyStrafe(player)
	end
end