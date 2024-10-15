MM.DroppedMobjs = {}
local shallowCopy = MM.require "Libs/shallowCopy"

function MM:DropItem(p, slot, randomize, dont_notify)
	if not (p and p.mm and #p.mm.inventory.items) then
		if not dont_notify then
			chatprintf(p, "* There's nothing to drop...")
		end
		return
	end

	slot = $ or p.mm.inventory.cur_sel
	local item = p.mm.inventory.items[slot]

	if not (item) then
		if not dont_notify then
			chatprintf(p, "* There's nothing to drop...")
		end
		return
	end

	if not (item.droppable) then
		if not dont_notify then
			chatprintf(p, "* You can't drop this.")
		end
		return
	end

	local def = self.Items[item.id]

	local mobj = P_SpawnMobjFromMobj(p.mo, 0,0,FixedMul(p.mo.height/2, p.mo.scale), MT_THOK)
	mobj.state = item.state
	mobj.tics = -1
	mobj.fuse = -1
	mobj.angle = p.mo.angle

	if randomize then
		mobj.angle = FixedAngle(P_RandomRange(0, 360)*FU)
	end

	P_InstaThrust(mobj, mobj.angle, 5*FU)
	mobj.momz = (3*FU)*P_MobjFlip(p.mo)

	mobj.pickupid = item.id
	mobj.restrict = shallowCopy(item.restrict)

	mobj.magtime = 0

	mobj.flags = 0

	if def.drop then
		def.drop(mobj)
	end

	table.insert(MM.DroppedMobjs, mobj)

	if (item and item.mobj) then
		P_RemoveMobj(item.mobj)
	end
	p.mm.inventory.items[slot] = nil
end

function MM:GetCertainDroppedItems(id)
	local wpns = {}

	for i,item in pairs(MM.DroppedMobjs) do
		if item.pickupid == id then
			table.insert(wpns, item)
		end
	end

	return wpns
end

local function manage_unpicked_weapon(mobj)
	local angle = FixedAngle(FixedDiv(leveltime % 80, 80)*360)
	local z = 12*cos(angle)

	mobj.flags = $ & ~(MF_NOCLIP|MF_NOCLIPHEIGHT)

	mobj.spriteyoffset = z
	mobj.angle = angle
	mobj.flags = 0

	// PICK ME UP. PICK ME UP.
	for p in players.iterate do
		if not (p.mo
		and p.mo.health
		and p.mm
		and not p.mm.spectator
		and not p.mm.picking_up) then continue end

		if not (p.cmd.buttons & BT_CUSTOM3
		and not (p.lastbuttons & BT_CUSTOM3)) then
			continue
		end

		if mobj.restrict[p.mm.role] then
			chatprintf(p, "* This weapon is prohibited from your role.")
			continue
		end

		local radius = p.mo.radius*4

		if abs(p.mo.x - mobj.x) > radius
		or abs(p.mo.y - mobj.y) > radius
		or abs(p.mo.z - mobj.z) > p.mo.height then
			continue
		end

		mobj.pos = {x = mobj.x, y = mobj.y, z = mobj.z}
		mobj.magnetize = p.mo
		mobj.magtime = 0

		p.mm.picking_up = mobj

		break
	end
end

addHook("PostThinkFrame", do
	for i,mobj in pairs(MM.DroppedMobjs) do
		if not (mobj and mobj.valid) then
			table.remove(MM.DroppedMobjs, i)
			continue
		end

		if not (mobj and mobj.magnetize) then
			manage_unpicked_weapon(mobj)
			continue
		end

		mobj.flags = MF_NOCLIP|MF_NOCLIPHEIGHT

		local x = ease.incubic(mobj.magtime, mobj.pos.x, mobj.magnetize.x)
		local y = ease.incubic(mobj.magtime, mobj.pos.y, mobj.magnetize.y)
		local z = ease.incubic(mobj.magtime, mobj.pos.z, mobj.magnetize.z)

		P_MoveOrigin(mobj, x,y,z)

		mobj.magtime = min($+(FU/13), FU)

		if mobj.magtime == FU then
			local item = MM:GiveItem(mobj.magnetize.player, mobj.pickupid)

			if item then
				mobj.magnetize.player.mm.picking_up = nil
				table.remove(MM.DroppedMobjs, i)
				P_RemoveMobj(mobj)
				return
			end

			local angle = FixedAngle(P_RandomRange(0, 360)*FU)
			mobj.angle = angle

			P_InstaThrust(mobj, mobj.angle, 5*FU)
			mobj.momz = (3*FU)*P_MobjFlip(mobj.magnetize)

			if mobj.magnetize.player.mm then
				mobj.magnetize.player.mm.picking_up = nil
			end
	
			mobj.magnetize = nil
			mobj.magtime = 0
		end
	end
end)

addHook("NetVars", function(n)
	MM.DroppedMobjs = n($)
end)