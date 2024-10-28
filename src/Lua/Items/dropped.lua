MM.DroppedMobjs = {}
local shallowCopy = MM.require "Libs/shallowCopy"

function MM:DropItem(p, slot, randomize, dont_notify, forced)
	--TODO: weird bug where you cant drop an item even if its in your inventory
	if not (p and p.mm and #p.mm.inventory.items) then
		if not dont_notify then
			chatprintf(p, "\x82*There's nothing to drop.")
		end
		return
	end

	slot = $ or p.mm.inventory.cur_sel
	local item = p.mm.inventory.items[slot]

	if not (item) then
		if not dont_notify then
			chatprintf(p, "\x82*There's nothing to drop.")
		end
		return
	end

	if not (item.droppable) then
		if not dont_notify then
			chatprintf(p, "\x82*You can't drop this.")
		end
		
		if not forced then 
			return
		end
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
	mobj.pickupsfx = item.pickupsfx
	mobj.restrict = shallowCopy(item.restrict)

	mobj.magtime = 0

	mobj.flags = 0

	if def.drop then
		def.drop(mobj, p)
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
	local z = (12*FU)+12*cos(angle)

	local def = MM.Items[mobj.pickupid]

	mobj.flags = $ & ~(MF_NOCLIP|MF_NOCLIPHEIGHT)

	mobj.spriteyoffset = z
	mobj.angle = angle
	mobj.flags = 0

	if def.dropthinker then
		def.dropthinker(mobj)
	end

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
			chatprintf(p, "\x82*This weapon is prohibited from your role.")
			continue
		end

		local radius = p.mo.radius*4

		if abs(p.mo.x - mobj.x) > radius
		or abs(p.mo.y - mobj.y) > radius
		or abs(p.mo.z - mobj.z) > p.mo.height then
			continue
		end

		if def.pickup
		and def.pickup(mobj, p) then
			continue
		end

		local item = MM:GiveItem(p, mobj.pickupid)

		if item then
			if mobj.pickupsfx then
				S_StartSound(p.mo, mobj.pickupsfx)
			end
			if def.postpickup then
				def.postpickup(item, p)
			end

			P_RemoveMobj(mobj)
			return true
		end
	end
end

addHook("PostThinkFrame", do
	for i,mobj in pairs(MM.DroppedMobjs) do
		if not (mobj and mobj.valid and not manage_unpicked_weapon(mobj)) then
			table.remove(MM.DroppedMobjs, i)
			continue
		end
	end
end)

addHook("NetVars", function(n)
	MM.DroppedMobjs = n($)
end)