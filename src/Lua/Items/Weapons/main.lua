local path = "Items/Weapons/"

local spread = 10
MM.BulletDies = function(mo, moagainst, line)
	for i = 0, P_RandomRange(2,5)
		local ghs = P_SpawnMobjFromMobj(mo,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU,
			MT_SMOKE
		)
		--get rid of interp
		P_SetOrigin(ghs, ghs.x,ghs.y,ghs.z)
	end
	
	local sfx = P_SpawnGhostMobj(mo)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse = TICRATE
	S_StartSound(sfx,sfx_turhit)
	
	local angle = mo.angle + ANGLE_90
	if (moagainst and moagainst.valid)
		angle = R_PointToAngle2(
			mo.x, mo.y,
			moagainst.x, moagainst.y
		) + ANGLE_90
	elseif (line and line.valid)
		angle = R_PointToAngle2(line.v1.x, line.v1.y, line.v2.x, line.v2.y)
	end
	
	local spokes = 8
	local fa = FixedDiv(360*FU, spokes*FU)
	local speed = 6*mo.scale
	
	local rev_x = P_ReturnThrustX(nil, mo.angle, -mo.scale * 3)
	local rev_y = P_ReturnThrustY(nil, mo.angle, -mo.scale * 3)
	
	local floormode = false
	if mo.z <= mo.floorz
	or mo.z+mo.height >= mo.ceilingz
		floormode = true
	end
	
	for i = 1, spokes
		local my_ang = FixedAngle(fa * i)
		
		local spark = P_SpawnMobjFromMobj(mo, rev_y, rev_x,
			FixedDiv((41*mo.height)/48, mo.scale),
			MT_MINECARTSPARK
		)
		if not floormode
			P_InstaThrust(spark, angle, FixedMul(cos(my_ang), speed))
			spark.momz = FixedMul(sin(my_ang), speed)
			
			P_Thrust(spark, angle + ANGLE_90,
				speed / 3
			)
		else
			local sign = (mo.z+mo.height >= mo.ceilingz) and -1 or 1
			P_SetObjectMomZ(spark, speed * sign)
			P_InstaThrust(spark, my_ang, speed / 3)
		end
		
		spark.flags = $ &~MF_NOGRAVITY
		spark.fuse = TICRATE * 2 --/3
		/*
		spark.blendmode = AST_ADD
		spark.alpha = FU * 3/4
		spark.destscale = 0
		spark.scalespeed = FixedDiv(spark.scale, spark.fuse*FU)
		*/
		P_SetOrigin(spark, spark.x, spark.y, spark.z)
	end
end

MM.GenericHitscan = function(mo)
	if not mo.valid then return end
	
	local def = MM.Items[mo.origin.id]
	
	/*
	mo.momx = FixedMul(32*cos(mo.angle), cos(mo.aiming))
	mo.momy = FixedMul(32*sin(mo.angle), cos(mo.aiming))
	mo.momz = 32*sin(mo.aiming)
	*/
	mo.bullframe = A
	
	for i = 0,255 do
		if not (mo and mo.valid) then
			return
		end
		
		--we do this so its easier to hit players from farther away, while also 
		--being able to hit players closer up in small areas
		local gs = P_SpawnGhostMobj(mo)
		gs.flags2 = $|MF2_DONTDRAW
		gs.fuse = 1
		
		mo.radius = $ + mo.scale/4
		if not (mo and mo.valid)
			MM.BulletDies(gs)
			return
		end
		mo.height = $ + mo.scale/2
		
		if def.bulletthinker
			def.bulletthinker(mo, i)
			
			--thinker removed the bullet
			if not (mo and mo.valid) then
				return
			end
		end
		
		--drop off
		/*
		if (i >= 192)
			if mo.origin.state ~= S_MM_LUGER
				mo.momz = $ - (mo.scale/3)*P_MobjFlip(mo)
			else
				mo.momz = $ - (mo.scale/2)*P_MobjFlip(mo)
			end
		end
		if (i >= 64)
		and mo.origin.state ~= S_MM_LUGER
			mo.momz = $ - (mo.scale/2)*P_MobjFlip(mo)
		end
		*/
		
		if mo.z <= mo.floorz
		or mo.z+mo.height >= mo.ceilingz
		and (i > 0) then
			MM.BulletDies(mo)
			P_RemoveMobj(mo)
			return
		end

		if i % 4 == 0 then
			local ghs = P_SpawnGhostMobj(mo)
			ghs.frame = (mo.bullframe % E)|FF_SEMIBRIGHT
			ghs.fuse = $*2
			P_SetOrigin(ghs, ghs.x,ghs.y,ghs.z)
			mo.bullframe = $ + 1
		end
		
		P_XYMovement(mo)
		
		if not (mo and mo.valid) then
			return
		end
		
		P_ZMovement(mo)
		
		if not (mo and mo.valid) then
			return
		end
		
		if FixedHypot(mo.momx,mo.momy) == 0
			MM.BulletDies(mo)
			P_RemoveMobj(mo)
			return			
		end
	end
	
	if mo and mo.valid then
		MM.BulletDies(mo)
		P_RemoveMobj(mo)
	end
end

MM.BulletHit = function(ring,pmo)
	if not (ring and ring.valid) then return end
	if not (pmo and pmo.valid) then return end
	if (pmo == ring.target) then return end
	if not (ring.target and ring.target.valid) then return end
	
	if ring.z > pmo.z+pmo.height then return end
	if pmo.z > ring.z+ring.height then return end
	if not (pmo.health) then return end
	
	if not (pmo.player and pmo.player.valid)
		if (pmo.flags & MF_SHOOTABLE)
		or pmo.camhitbox
			
			--if this is a generic shootable (monitors, enemies, etc...),
			--damage it with the ring's target (the player) or the ring itself as the source
			if not pmo.camhitbox
				P_DamageMobj(pmo, ring, (ring.target and ring.target.valid) and ring.target or ring, 2)
			
			--otherwise, we're shooting a camera, so kill it and make it offline
			elseif (ring.target.player.mm.role == MMROLE_MURDERER)
				P_KillMobj(pmo.tracer, ring, (ring.target and ring.target.valid) and ring.target or ring, 2)
			end
			
			MM.BulletDies(ring)
			P_RemoveMobj(ring)
		end
		return
	end
	
	if not (pmo.player and pmo.player.mm) then return end

	if pmo.player and pmo.player.mm
	and pmo.player.mm.role == ring.target.player.mm.role
	and ring.target.player.mm.role ~= MMROLE_INNOCENT
		return
	end
	
	P_DamageMobj(pmo, ring, (ring.target and ring.target.valid) and ring.target or ring, 999, DMG_INSTAKILL)
	MM.BulletDies(ring)
	P_RemoveMobj(ring)
end

MM:CreateItem(dofile(path.."Revolver/def"))
MM:CreateItem(dofile(path.."Shotgun/def"))
MM:CreateItem(dofile(path.."Luger/def"))
MM:CreateItem(dofile(path.."Knife/def"))
MM:CreateItem(dofile(path.."Burger/def"))
MM:CreateItem(dofile(path.."Swap_Gear/def"))
MM:CreateItem(dofile(path.."Sword/def"))
MM:CreateItem(dofile(path.."Snowball/def"))
MM:CreateItem(dofile(path.."DevLuger/def"))
MM:CreateItem(dofile(path.."Tripmine/def"))
MM:CreateItem(dofile(path.."BearTrap/def"))
MM:CreateItem(dofile(path.."LoudSpeaker/def"))
MM:CreateItem(dofile(path.."Radio/def"))