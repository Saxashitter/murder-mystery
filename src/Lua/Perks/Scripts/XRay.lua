local perk_name = "X-Ray"
local perk_price = 525 --1500

local cv_fov = CV_FindVar("fov")
local sglib = MM.require "Libs/sglib"

MM_PERKS[MMPERK_XRAY] = {
	drawer = function(v,p,cam, order)
		if not (MM:isMM()) then return end
		if not (p.mm) then return end
		if not (p.mm_save) then return end
		if (p.spectator) then return end
		if (MM_N.gameover) then return end
		if (MM_N.showdown) then return end
		if (MM_N.dueling) then return end
		
		if (p.mm.role ~= MMROLE_MURDERER) then return end
		
		local me = p.mo
		local maxdist = 10240*me.scale
		if order == "sec"
			maxdist = $/3
		end
		
		local drawwork = {}
		for play in players.iterate()
			if not (play.mm) then continue end
			if not (play.mm_save) then continue end
			if (play.spectator) then continue end
			if not (play.mo and play.mo.valid) then continue end
			if not (play.mo.health) then continue end
			if (play.mm.role == MMROLE_MURDERER) then continue end
			
			if (P_CheckSight(me, play.mo)) then continue end
			local dist = R_PointToDist(play.mo.x,play.mo.y)
			if (dist > maxdist) then continue end
			
			do
				local adiff = FixedAngle(
					AngleFixed(R_PointToAngle(play.mo.x, play.mo.y) - cam.angle)
				)
				if AngleFixed(adiff) > 180*FU
					adiff = InvAngle($)
				end
				if (AngleFixed(adiff) > cv_fov.value)
					continue
				end
			end
			
			table.insert(drawwork, {
				dist = dist,
				player = play
			})
		end
		
		table.sort(drawwork,function(a,b)
			return a.dist > b.dist
		end)
		
		for k,item in pairs(drawwork)
			local play = item.player

			local patch = v.cachePatch("MM_SHOWDOWNMARK")
			local w2s = sglib.ObjectTracking(v, p, cam, play.mo)

			MMHUD.interpolate(v,#play)
			v.drawScaled(
				w2s.x,
				w2s.y,
				w2s.scale,
				patch,
				0,
				v.getColormap(nil, play.skincolor)
			)
			MMHUD.interpolate(v,false)
			
		end
		MMHUD.interpolate(v,false)
	end,

	icon = "MM_PI_XRAY",
	icon_scale = FU/2,
	name = perk_name,

	description = {
		"\x82Primary:\x80 See everyone through walls!",
		
		"",
		
		"\x82Secondary:\x80 See everyone through walls,",
		"for a short distance."
	},
	cost = perk_price,
}

local id = MM.Shop.addItem({
	name = perk_name,
	price = perk_price,
	category = MM_PERKS.category_id
})
MM.Shop.items[id].perk_id = MMPERK_XRAY