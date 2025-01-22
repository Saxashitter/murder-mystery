local TR = TICRATE

local sglib = MM.require("Libs/sglib")
local shallowCopy = MM.require "Libs/shallowCopy"

local function interpolate(v,set)
	if v.interpolate ~= nil then v.interpolate(set) end
end

local buttontotext = {
	[BT_CUSTOM1] = "C1",
	[BT_CUSTOM2] = "C2",
	[BT_CUSTOM3] = "C3",
	[BT_TOSSFLAG] = "TF",
	[BT_SPIN] = "S",
	[BT_FIRENORMAL] = "FN",
}

--TODO: this source edit really needs a setorigin for interp...
local function HUD_InteractDrawer(v,p,cam)
	if (p.mm.interact == nil) then return end
	if (p.spectator) then return end
	if (p.awayviewmobj and p.awayviewmobj.dontdrawinteract) then return end
	if (MM.gameover) then return end -- If the game is over, we dont care about seeing interaction.
	
	--Re-sort so inactive widgets dont overlap the active one
	local placehold_inter = shallowCopy(p.mm.interact.points)
	table.sort(placehold_inter,function(a,b)
		return not MM.sortInteracts(p,a,b)
	end)
	
	interpolate(v,true)
	for k,inter in ipairs(placehold_inter)
		local mo = inter.mo
		if not (mo and mo.valid) then mo = inter.backup end
		if not (mo and mo.valid) then continue end
		
		local trans = (k ~= #placehold_inter and V_50TRANS or 0)
		do
			local icon = v.cachePatch("MM_INTERBOX")
			local w2s = sglib.ObjectTracking(v,p,cam,mo)
			
			local goingaway = inter.hud.goingaway and inter.timesinteracted
			local timetic = FixedDiv(
				((p.mm.interact.interacted or goingaway) and inter.interacttime or inter.interacting)*FU,
				inter.interacttime*FU
			)
			
			local scalef = inter.hud.xscale
			local longeststr = v.stringWidth("Howlongcan",0,"thin")
			local longest = max(
				v.stringWidth(inter.name or '',0,"thin"),
				v.stringWidth(inter.interacttext or '',0,"thin")
			)
			longest = max($ - longeststr, 0)
			if longest ~= 0
			and not timetic
				scalef = $ + FixedDiv(longest*FU,(longeststr + 17)*FU)
			end
			
			
			local x = w2s.x - (FixedMul(icon.width*FU,scalef)/2)
			local y = w2s.y
			do	
				if scalef > 0
					v.drawStretched(x, y,
						scalef,
						FU,
						icon,
						trans and V_80TRANS or V_50TRANS
					)
				end
				
				if not timetic
					v.drawString(x + 30*FU,
						y + 3*FU,
						inter.name,
						V_ALLOWLOWERCASE|trans,
						"thin-fixed"
					)
					v.drawString(x + 30*FU,
						y + 13*FU,
						inter.interacttext,
						V_ALLOWLOWERCASE|V_GRAYMAP|trans,
						"thin-fixed"
					)
					if inter.price ~= 0
						v.drawScaled(x + 30*FU,
							y + 22*FU,
							FU/2,
							v.cachePatch("NRNG1"),
							trans
						)
						v.drawString(x + 40*FU,
							y + 23*FU,
							inter.price,
							V_ALLOWLOWERCASE|V_YELLOWMAP|trans,
							"thin-fixed"
						)
					end
				end
				
				v.drawScaled(x + (timetic == 0 and 15*FU or 0),
					y + 16*FU,
					FU,
					v.cachePatch("MM_INTERBALLBG"),
					trans and V_60TRANS or V_30TRANS,
					v.getColormap(nil,SKINCOLOR_CARBON)
				)
				v.drawScaled(x + (timetic == 0 and 15*FU or 0),
					y + 16*FU,
					FU/2,
					v.cachePatch("MM_INTERBUT"),
					trans
				)
				v.drawString(x + (timetic == 0 and 15*FU or 0),
					y + 12*FU,
					buttontotext[inter.button] or "?",
					V_ALLOWLOWERCASE|trans,
					"thin-fixed-center"
				)
				
				local resolution = 55
				local timetic = FixedDiv(inter.interacting*FU,inter.interacttime*FU)
				local radi = 12
				if timetic ~= 0
					for i = 0,resolution
						local angle = FixedAngle(
							FixedMul(
								FixedDiv(
									FixedMul(360*FU,timetic),
									resolution*FU
								),
								i*FU
							)-90*FU
						)
						v.drawScaled(x + radi*cos(angle),
							y + 16*FU + radi*sin(angle),
							FU/6,
							v.cachePatch("MM_INTERBALL"),
							trans,
							v.getColormap(nil,SKINCOLOR_CLOUDY)
						)
					end
				end
				
			end
		end
		
	end
	interpolate(v,false)
	
end
return HUD_InteractDrawer