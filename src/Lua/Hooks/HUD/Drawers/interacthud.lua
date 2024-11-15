/*
	local me = p.realmo
	p.mm.interact = $ or {}
	
	if not (me and me.valid) then return end
	
	MM.interactPoint(p,me,p.name,nil,BT_CUSTOM3)
	
	for k,inter in ipairs(p.mm.interact)
		if not (inter.mo and inter.mo.valid)
			table.remove(p.mm.interact,k)
			continue
		end
		local mo = inter.mo
		
		inter.timespan = $+1
	end
*/

local TR = TICRATE
local TWEENTIME = TR/2

local sglib = MM.require("Libs/sglib")

local scales = {}

local function interpolate(v,set)
	if v.interpolate ~= nil then v.interpolate(set) end
end

local function HUD_InteractDrawer(v,p,cam)
	if (p.mm.interact == nil) then return end
	
	interpolate(v,true)
	for k,inter in ipairs(p.mm.interact)
		local mo = inter.mo
		
		local timespan = min(inter.timespan,TWEENTIME)
		local trans = (k ~= 1 and V_50TRANS or 0)
		do
			local icon = v.cachePatch("MM_INTERBOX")
			local w2s = sglib.ObjectTracking(v,p,cam,mo)
			
			scales[k] = ($ ~= nil) and ease.outquad(FU/4,$,FixedDiv(timespan*FU,TWEENTIME*FU)) or 0
			local scalef = scales[k]
			
			local x = w2s.x - (FixedMul(icon.width*FU,scalef)/2)
			if w2s.onScreen or true
				v.drawStretched(x, w2s.y,
					scalef,
					FU,
					icon,
					trans and V_90TRANS or V_50TRANS
				)
				
				v.drawString(x + 30*FU,
					w2s.y + 3*FU,
					inter.name,
					V_ALLOWLOWERCASE|trans,
					"thin-fixed"
				)
				v.drawString(x + 30*FU,
					w2s.y + 13*FU,
					inter.interacttext,
					V_ALLOWLOWERCASE|V_GRAYMAP|trans,
					"thin-fixed"
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
						v.drawScaled(x + 15*FU + radi*cos(angle),
							w2s.y + 16*FU + radi*sin(angle),
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