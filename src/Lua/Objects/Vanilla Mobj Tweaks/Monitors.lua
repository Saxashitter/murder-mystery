--trg is assumed to be stationary
local function nuZCollide(src, trg)
	local z1 = src.z + src.momz
	
	if z1 > trg.height+trg.z - src.momz then return false end
	if trg.z > src.height+src.z then return false end
	return true
end

local monitor_flags = MF_SOLID
local monitor_types = {
	MT_RING_BOX,
	MT_PITY_BOX,
	MT_ATTRACT_BOX,
	MT_FORCE_BOX,
	MT_ARMAGEDDON_BOX,
	MT_WHIRLWIND_BOX,
	MT_ELEMENTAL_BOX,
	MT_SNEAKERS_BOX,
	MT_INVULN_BOX,
	MT_1UP_BOX,
	MT_EGGMAN_BOX,
	MT_MIXUP_BOX,
	MT_MYSTERY_BOX,
	MT_GRAVITY_BOX,
	MT_RECYCLER_BOX,
	MT_SCORE1K_BOX,
	MT_SCORE10K_BOX,
	MT_FLAMEAURA_BOX,
	MT_BUBBLEWRAP_BOX,
	MT_THUNDERCOIN_BOX,
	MT_ATTRACT_GOLDBOX,
	MT_FORCE_GOLDBOX,
	MT_ARMAGEDDON_GOLDBOX,
	MT_WHIRLWIND_GOLDBOX,
	MT_ELEMENTAL_GOLDBOX,
	MT_SNEAKERS_GOLDBOX,
	MT_INVULN_GOLDBOX,
	MT_EGGMAN_GOLDBOX,
	MT_GRAVITY_GOLDBOX,
	MT_FLAMEAURA_GOLDBOX,
	MT_BUBBLEWRAP_GOLDBOX,
	MT_THUNDERCOIN_GOLDBOX
}
local function monitor_spawn(mo)
	if not MM:isMM() then return end
	if CV_MM.debug.value then return end
	
	mo.flags = monitor_flags
end

local function monitor_touch(mon, me)
	if not (mon and mon.valid)	then return end
	if not (mon.health)			then return end
	if not (me and me.valid)	then return end
	if not (me.health)			then return end
	if not (me.player and me.player.valid) then return end
	
	--im lazy
	if P_MobjFlip(mon) ~= P_MobjFlip(me) then return end
	if not P_PlayerCanDamage(me.player, mon) then return end
	if not nuZCollide(me,mon) then return end
	
	--PIT_DoCheckThing
	if me.momz * P_MobjFlip(me) < 0
		/*
		local below = false
		if flip == -1
			below = (me.z + me.height > mon.z)
		elseif flip == 1
			below = (me.z < mon.z + mon.height)
		end
		
		if below
			me.z = (flip == -1) and mon.z or mon.z + mon.height
		end
		*/
		
		P_SetObjectMomZ(me, 10*FU)		
		--me.momz = abs($) * P_MobjFlip(me)
		me.player.pflags = $ &~PF_JUMPDOWN
		S_StartSoundAtVolume(me, sfx_s3k49, 255 * 4/5)
		
		--return false
	end
	
	--return notouch;
end

for k,type in ipairs(monitor_types)
	addHook("MobjSpawn",monitor_spawn, type)
	addHook("MobjCollide",monitor_touch, type)
end


/*
--Normal Monitors
mobjinfo[MT_RING_BOX].flags = monitor_flags
mobjinfo[MT_PITY_BOX].flags = monitor_flags
mobjinfo[MT_ATTRACT_BOX].flags = monitor_flags
mobjinfo[MT_FORCE_BOX].flags = monitor_flags
mobjinfo[MT_ARMAGEDDON_BOX].flags = monitor_flags
mobjinfo[MT_WHIRLWIND_BOX].flags = monitor_flags
mobjinfo[MT_ELEMENTAL_BOX].flags = monitor_flags
mobjinfo[MT_SNEAKERS_BOX].flags = monitor_flags
mobjinfo[MT_INVULN_BOX].flags = monitor_flags
mobjinfo[MT_1UP_BOX].flags = monitor_flags
mobjinfo[MT_EGGMAN_BOX].flags = monitor_flags
mobjinfo[MT_MIXUP_BOX].flags = monitor_flags
mobjinfo[MT_MYSTERY_BOX].flags = monitor_flags
mobjinfo[MT_GRAVITY_BOX].flags = monitor_flags
mobjinfo[MT_RECYCLER_BOX].flags = monitor_flags
mobjinfo[MT_SCORE1K_BOX].flags = monitor_flags
mobjinfo[MT_SCORE10K_BOX].flags = monitor_flags
mobjinfo[MT_FLAMEAURA_BOX].flags = monitor_flags
mobjinfo[MT_BUBBLEWRAP_BOX].flags = monitor_flags
mobjinfo[MT_THUNDERCOIN_BOX].flags = monitor_flags
--Golden Monitors
mobjinfo[MT_ATTRACT_GOLDBOX].flags = monitor_flags
mobjinfo[MT_FORCE_GOLDBOX].flags = monitor_flags
mobjinfo[MT_ARMAGEDDON_GOLDBOX].flags = monitor_flags
mobjinfo[MT_ARMAGEDDON_BOX].flags = monitor_flags
mobjinfo[MT_WHIRLWIND_GOLDBOX].flags = monitor_flags
mobjinfo[MT_ELEMENTAL_GOLDBOX].flags = monitor_flags
mobjinfo[MT_SNEAKERS_GOLDBOX].flags = monitor_flags
mobjinfo[MT_INVULN_GOLDBOX].flags = monitor_flags
mobjinfo[MT_EGGMAN_GOLDBOX].flags = monitor_flags
mobjinfo[MT_GRAVITY_GOLDBOX].flags = monitor_flags
mobjinfo[MT_FLAMEAURA_GOLDBOX].flags = monitor_flags
mobjinfo[MT_BUBBLEWRAP_GOLDBOX].flags = monitor_flags
mobjinfo[MT_THUNDERCOIN_GOLDBOX].flags = monitor_flags
*/