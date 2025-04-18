local norespawn_mobjs = {
	[MT_RING] = true,
	[MT_COIN] = true,
}

-- Make the game use a completely different ring variable.
local function special_override(special, toucher)
	if special and special.valid and toucher and toucher.valid then
		local player = toucher.player
		
		if player and player.valid then
			player.rings = 0
			player.mm_save.rings = $ + 1
			player.mm.rings = $ + 1
		end
	end
end


addHook("TouchSpecial", special_override, MT_RING)
addHook("TouchSpecial", special_override, MT_COIN)
addHook("TouchSpecial", special_override, MT_FLINGRING)
addHook("TouchSpecial", special_override, MT_FLINGCOIN)

-- Disable respawning for rings.
addHook("MapLoad", function()
	if not MM:isMM() then
		return
	end
	
	for thing in mapthings.iterate do
		if thing and thing.valid then
			local mobj = thing.mobj
			
			if mobj and mobj.valid 
			and norespawn_mobjs[mobj.type] then
				mobj.flags2 = $|MF2_DONTRESPAWN
			end
		end
	end
end)