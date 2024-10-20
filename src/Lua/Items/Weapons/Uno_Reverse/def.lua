local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/3

weapon.id = "uno_reverse"
weapon.category = "Test"
weapon.display_name = "Uno Reverse"
weapon.display_icon = "MM_UNO_REVERSE"
weapon.state = dofile "Items/Weapons/Uno_Reverse/freeslot"
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE
weapon.cooldown_time = TICRATE*2
weapon.range = FU*3
weapon.zrange = FU*2
weapon.position = {
	x = FU,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = 0,
	y = (FU/10)*8,
	z = FU/3
}
weapon.stick = true
weapon.animation = true
weapon.damage = false
weapon.weaponize = true
weapon.droppable = false
weapon.shootable = false
weapon.shootmobj = MT_THOK
weapon.equipsfx = sfx_None
weapon.attacksfx = sfx_None

weapon.hiddenforothers = true

weapon.cantouch = true

function weapon:onhit(player, player2)
	local mo1 = player.mo
	local mo2 = player2.mo
	
	if (player.mm and player2.mm) and
	(mo1 and mo1.valid) and
	(mo2 and mo2.valid) then
		local old = {
			[1] = {
				name = player.mm.alias.name or player.name,
				skin = mo1.skin,
				color = mo1.color,
				x = mo1.x,
				y = mo1.y,
				z = mo1.z,
				angle = mo1.angle,
				drawangle = player.drawangle,
				momx = mo1.momx,
				momy = mo1.momy,
				momz = mo1.momz,
				state = mo1.state,
				sprite = mo1.sprite,
				frame = (mo1.frame & FF_FRAMEMASK),
				perm_level = 0, -- set later
			},
			[2] = {
				name = player2.mm.alias.name or player2.name,
				skin = mo2.skin,
				color = mo2.color,
				x = mo2.x,
				y = mo2.y,
				z = mo2.z,
				angle = mo2.angle,
				drawangle = player2.drawangle,
				momx = mo2.momx,
				momy = mo2.momy,
				momz = mo2.momz,
				state = mo2.state,
				sprite = mo2.sprite,
				frame = (mo2.frame & FF_FRAMEMASK),
				perm_level = 0, -- set later
			},
		}
		
		-- where "set later" comes in play
		if player.mm.alias.perm_level ~= nil then
			old[1].perm_level = player.mm.alias.perm_level
		else
			old[1].perm_level = MM:getpermlevel(player)
		end
		
		if player2.mm.alias.perm_level ~= nil then
			old[2].perm_level = player2.mm.alias.perm_level
		else
			old[2].perm_level = MM:getpermlevel(player2)
		end
		
		
		-- Player 1
		P_SetOrigin(mo1, old[2].x, old[2].y, old[2].z)
		mo1.angle = old[2].angle
		mo1.momx = old[2].momx
		mo1.momy = old[2].momy
		mo1.momz = old[2].momz
		mo1.state = old[2].state
		mo1.sprite = old[2].sprite
		mo1.frame = $|old[2].frame
		player.drawangle = old[2].drawangle
		
		mo1.color = old[2].color
		R_SetPlayerSkin(player, old[2].skin)
		player.mm.alias.name = old[2].name
		player.mm.alias.skin = old[2].skin
		player.mm.alias.skincolor = old[2].color
		player.mm.alias.perm_level = old[2].perm_level
		player.mm.alias.posingas = player2
		
		-- Player 2
		P_SetOrigin(mo2, old[1].x, old[1].y, old[1].z)
		mo2.angle = old[1].angle
		mo2.momx = old[1].momx
		mo2.momy = old[1].momy
		mo2.momz = old[1].momz
		mo2.state = old[1].state
		mo2.sprite = old[1].sprite
		mo2.frame = $|old[1].frame
		player2.drawangle = old[1].drawangle
		
		mo2.color = old[1].color
		R_SetPlayerSkin(player2, old[1].skin)
		player2.mm.alias.name = old[1].name
		player2.mm.alias.skin = old[1].skin
		player2.mm.alias.skincolor = old[1].color
		player2.mm.alias.perm_level = old[1].perm_level
		player2.mm.alias.posingas = player
		
		-- This is for if you swap back to your original body.
		-- You shouldn't have an alias set if you're going back to your own body
		if player.mm.alias.posingas ~= nil then
			if player.mm.alias.posingas.valid and player.mm.alias.posingas == player then
				player.mm.alias = {}
			end
		end
		
		if player2.mm.alias.posingas ~= nil then
			if player2.mm.alias.posingas.valid and player2.mm.alias.posingas == player2 then
				player2.mm.alias = {}
			end
		end
		
		local wp = MM:FetchInventorySlot(player)
		
		/*
		if (wp.timeleft <= 0) then
			wp.timeleft = 15*TICRATE
		end
		*/
	end
end

return weapon