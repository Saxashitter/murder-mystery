local skullcounter = 8
local otherskullcounter = 16
local debug = false

--takis
local function getabsolute(v, x,y, flags)
	local total_width = (v.width() / v.dupx()) + 1
	local total_height = (v.height() / v.dupy()) + 1
	
	local fx,fy
	
	if x ~= nil
		if (flags & V_SNAPTOLEFT)
			fx = (160*FU-(total_width*FU/2)) + x
		elseif (flags & V_SNAPTORIGHT)
			fx = (160*FU+(total_width*FU/2)) + x
		end
	end
	
	if y ~= nil
		if (flags & V_SNAPTOTOP)
			fy = ((100*FU)-(total_height*FU/2)) + y
		elseif (flags & V_SNAPTOBOTTOM)
			fy = ((100*FU)+(total_height*FU/2)) + y
		end
	end

	return fx,fy
end

local function HUD_DrawCamera(v,p)
	if not (MM) then return end
	if not (MM:isMM()) then return end
	
	--DEBUG
	if debug
	and (Tprtable ~= nil) --takis func
		local x,y = 5,0
		
		for i = 0,#MMCAM.CAMS
			local str = Tprtable("CAMS["..i.."]",MMCAM.CAMS[i],false)
			for k,va in ipairs(str)
				
				v.drawString(x,y,va,V_ALLOWLOWERCASE,"small")
				y = $ + 4
			end
		end
		
	end
	
	local p = displayplayer
	local mmc = p.mmcam
	
	if not (mmc.cam and mmc.cam.valid) then return end
	
	MMHUD.xoffset = ease.inexpo(FU*6/10,$,1000*FU)
	MMHUD.weaponslidein = MMHUD.xoffset
	MMHUD.dontslidein = true
	
	for k,scan in ipairs(mmc.cam.args.scanlines)
		local _,sy = getabsolute(v, nil, scan.y, V_SNAPTOTOP)
		local _,by = getabsolute(v, nil, 0, V_SNAPTOBOTTOM)
		
		if sy > by then continue end
		
		v.drawStretched(0,
			scan.y,
			((v.width() / v.dupx()) + 1)*FU,
			scan.height,
			v.cachePatch("1PIXEL"),
			V_60TRANS|V_SNAPTOLEFT|V_SNAPTOTOP
		)
	end
	
	local flicker = ((leveltime&1) and v.RandomChance(FU/6)) and -1 or 0
	do
		local soft = v.renderer() == "software"
		local off = 16
		local bright = R_PointInSubsector(mmc.cam.x,mmc.cam.y).sector.lightlevel
		if bright < (soft and 127 or 97)
			off = $ - (bright) / (soft and 3 or 5)
		end
		
		off = max($,soft and 2 or 5)
		v.fadeScreen(0xFF00,off + flicker)
	end
	
	do
		flicker = ((leveltime&1) and v.RandomChance(FU/2)) and -3 or 0
		local top = v.cachePatch("MMCAM_T0")
		local bot = v.cachePatch("MMCAM_B0")
		local tr = (4 - flicker)<<V_ALPHASHIFT
		local offset = 0 --(leveltime/3)&1
		
		v.draw(0,offset,top,V_SNAPTOTOP|V_SNAPTOLEFT|tr)
		v.draw(0,200-offset,bot,V_SNAPTOBOTTOM|V_SNAPTOLEFT|tr)
		
		v.draw(320,offset,top,V_FLIP|V_SNAPTOTOP|V_SNAPTORIGHT|tr)
		v.draw(320,200-offset,bot,V_FLIP|V_SNAPTOBOTTOM|V_SNAPTORIGHT|tr)
	end
	
	do
		local camname = mmc.cam.args.name or "Camera "..(mmc.cam.args.order + 1)
		local w = (v.stringWidth(camname,0,"thin")/2) + 4
		local back = max(w*2 + 
			(#MMCAM.CAMS[mmc.sequence] >= 1 and 16 or 0),
			v.stringWidth("[Spin] - Exit",0,"thin")
		)
		
		v.drawStretched(160*FU - (back/2 + 2)*FU,
			158*FU,
			(back+4)*FU,
			30*FU,
			v.cachePatch("1PIXEL"),
			V_50TRANS
		)
		
		v.drawString(160,160,
			camname,
			V_YELLOWMAP|V_ALLOWLOWERCASE,
			"thin-center"
		)
		
		if #MMCAM.CAMS[mmc.sequence] >= 1
			v.drawString(160 - w - (skullcounter/5),
				160,
				"\28",
				V_YELLOWMAP|V_ALLOWLOWERCASE,
				"thin-right"
			)
			v.drawString(160 + w + (skullcounter/5),
				160,
				"\29",
				V_YELLOWMAP|V_ALLOWLOWERCASE,
				"thin"
			)
		end
		
		v.drawString(160,178,
			"[Spin] - Exit",
			V_ALLOWLOWERCASE,
			"thin-center"
		)
	end
	
	do
		if (((2*leveltime)/TICRATE) & 1)
			v.draw(20,20,v.cachePatch("STCFN015"),0,v.getStringColormap(V_REDMAP))
			v.drawString(30,20,"REC",V_REDMAP,"left")
		end
		
		do
			local date = os.date("*t")
			--incorrect non-american date format
			local str = date.day.."/"..date.month.."/"..date.year
			str = $.." "..date.hour..":"..(date.min < 10 and "0" or '')..date.min..":"..(date.sec < 10 and "0" or '')..date.sec
			v.drawString(300,20,str,0,"thin-right")
		end
		
		local top = v.cachePatch("MMCAM_T1")
		local bot = v.cachePatch("MMCAM_B1")
		
		v.draw(11,11,top,0)
		v.draw(11,189,bot,0)
		
		v.draw(309,11,top,V_FLIP)
		v.draw(309,189,bot,V_FLIP)
		
	end
	
	do
		local x,y = 10*FU, 201*FU
		for i = 0,#players - 1
			local player = mmc.cam.args.players[i]
			
			if not (player and player.valid) then continue end
			if not (player.mo and player.mo.valid) then continue end
			
			local patch,flip = v.getSprite2Patch(player.skin,
				player.mo.sprite2,false,
				player.mo.frame,
				6
			)
			if player.mo.sprite ~= SPR_PLAY
				patch,flip = v.getSpritePatch(player.mo.sprite,
					player.mo.frame,
					6
				)
			end
			
			if patch == nil
				patch = v.cachePatch("MMCAM_FALLBACK")
				flip = 0
			end
			
			v.drawScaled(x,y,
				skins[player.skin].highresscale/2,
				patch,
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|(flip and V_FLIP or 0),
				v.getColormap(player.skin,player.mo.color)
			)
			
			if (i == #p)
				v.drawScaled(x,
					y - 30*FU - ((otherskullcounter/11)*FU),
					FU/4,
					v.cachePatch("MM_SHOWDOWNMARK"),
					V_SNAPTOLEFT|V_SNAPTOBOTTOM,
					v.getColormap(nil, p.skincolor)
				)
			end
			
			x = $ + 10*FU
		end
	end
	
	if (mmc.fade)
		v.fadeScreen(0xFF00,mmc.fade)
	end
	
	skullcounter = $ - 1
	if skullcounter <= 0 then skullcounter = 8 end
	
	otherskullcounter = $ - 1
	if otherskullcounter <= 0 then otherskullcounter = 16 end
end


addHook("HUD",HUD_DrawCamera,"game")
addHook("HUD",HUD_DrawCamera,"scores")