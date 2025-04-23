--player tip: you needa kill yourself
local Roles = MM.require("Variables/Data/Roles")
local rolebutt = {
	w = 70,
	h = 16,
}
local RoleExtraData = {
	icons = {
		[MMROLE_INNOCENT] = "MM_RADIO",
		[MMROLE_SHERIFF] = "MM_REVOLVER",
		[MMROLE_MURDERER] = "MM_KNIFE"
	},
	palette = {
		-- {light, dark}
		[MMROLE_INNOCENT] = {102, 111},
		[MMROLE_SHERIFF] = {150, 159},
		[MMROLE_MURDERER] = {38, 47},
	}
}

local function drawRoleButton(v,x,y, role)
	local role_t = Roles[role]
	
	MenuLib.addButton(v, {
		x = x, y = y,
		width = rolebutt.w, height = rolebutt.h,
		name = "",
		color = 13,
		outline = RoleExtraData.palette[role][2],
		
		pressFunc = function()
			local newpage = MenuLib.findMenu("GuidePage_"..(role_t.name))
			if newpage ~= -1
				MenuLib.initMenu(newpage)
			end
		end
	})
	v.drawScaled(
		(x + (rolebutt.w - 16))*FU,
		y*FU, FU/2,
		v.cachePatch(RoleExtraData.icons[role]),
		0
	)
	v.drawString(x + 2, y + (rolebutt.h / 2) - 3,
		role_t.name, V_ALLOWLOWERCASE|(role_t.color),
		"thin"
	)
end

local function drawGenericButton(v,x,y, name, pagename, openpopup, h)
	MenuLib.addButton(v, {
		x = x, y = y,
		width = rolebutt.w, height = rolebutt.h + (h or 0),
		name = name,
		color = 13,
		outline = 19,
		
		pressFunc = function()
			local newpage = MenuLib.findMenu("GuidePage_"..tostring(pagename))
			if newpage ~= -1
				local func = (openpopup) and MenuLib.initPopup or MenuLib.initMenu
				func(newpage)
			end
		end
	})
end

MenuLib.addMenu({
	stringId = "GuidePage_HUDPU",
	title = "Controls",
	
	x = -2, y = -2,
	width = BASEVIDWIDTH + 4,
	height = BASEVIDHEIGHT + 4,
	color = 27,
	
	ps_flags = PS_DRAWTITLE|PS_NOSLIDEIN,
	
	drawer = function(v, ML, menu, props)
		--dont fill the whole screen
		v.draw(1, props.corner_y + 13, v.cachePatch("MMGUD_HUDUI"), 0)
		
		--draw whatever text we need on top of the graphic
		v.drawString(98, 144 + 13,
			"Cycle with WEAPON NEXT/PREV",
			V_ALLOWLOWERCASE, "thin"
		)
	end
})

local sher_cc = Roles[MMROLE_SHERIFF].colorcode
local inno_text = {
	"* Collect clues scattered around the map as an \x83Innocent\x80!", "",

	"* Getting all your clues before other people can earn you",
	"a useful item! If you're slow, you'll get a junk item instead.", "",

	"* Stay alive as long as you can for a \x82".."Coin Payout\x80!", "",
	
	"* Find bodies to earn cash! \x82Remember\x80: get close to",
	"bodies to find them. \x85Murderers cannot find bodies\x80!", "",
	
	"patchdraw", "",
	"* Collect guns dropped by "..(sher_cc).."Sheriffs\x80 to fend for yourself!", "",
	"* \x85Murderer\x80 camping the gun? Jump over and get the",
	"gun from above!"
}
MenuLib.addMenu({
	stringId = "GuidePage_Innocent",
	title = "\x83Innocents",

	width = 250,
	height = 150,
	
	drawer = function(v, ML, menu, props)
		local x,y = props.corner_x, props.corner_y
		x = $ + 2
		y = $ + 15
		
		for k,str in ipairs(inno_text)
			if str == "patchdraw"
				local scale = FU / 2
				local patch = v.cachePatch("MMGUD_DEADT")
				x = $ + 4
				v.drawScaled(x*FU,y*FU, scale, patch, 0)
				
				v.drawScaled( (x + 25)*FU + patch.width*scale,
					(y - 5)*FU + (patch.height * scale), scale,
					v.getSprite2Patch("sonic", SPR2_STND, false, A, 2, 0),
					0, v.getColormap("sonic", SKINCOLOR_BLUE)
				)
				v.drawString((x + 65)*FU,
					(y + 10)*FU, "+25 coins",
					V_GREENMAP|V_ALLOWLOWERCASE, "thin-fixed"
				)
				
				y = $ + FixedInt(patch.height * scale) + 3
				x = $ - 4
				continue
			end
			
			local addspace = str:sub(1,2) ~= "* "
			if addspace then x = $ + 6 end
			
			v.drawString(x,y,str, V_ALLOWLOWERCASE, "small")
			
			if str == ""
				y = $ + 7
			else
				y = $ + 5
			end
			if addspace then x = $ - 6 end
			
		end
	end
})

local sher_text = {
	"* You and your teammates must protect the \x83Innocents\x80!", "",

	"* Neutralize all \x85Murderers\x80 with your weapon. Don't",
	"shoot \x83Innocents\x80! Your teammates are fair game, though.", "",

	"* Save as much \x83Innocents\x80 as you can for a huge \x82".."Coin Payout\x80!", "",
	
	"* Drop your gun with \x82[CUSTOM2]\x80 to relieve yourself of your duties,",
	"or have someone else do your job for you!", "",
	
	"* You will be alerted when your teammates die.", "",
	"* \x85".."Don't shoot people all willy-nilly! \x80Unless you want a pay cut."
}
MenuLib.addMenu({
	stringId = "GuidePage_Sheriff",
	title = sher_cc.."Sheriffs\x80",

	width = 270,
	height = 110,
	
	drawer = function(v, ML, menu, props)
		local x,y = props.corner_x, props.corner_y
		x = $ + 2
		y = $ + 15
		
		--Bruh
		MenuLib.interpolate(v,false)
		v.draw(x + props.fakewidth - 35,
			y + 30,
			v.cachePatch("BGLSF0"), 0
		)
		MenuLib.interpolate(v,true)
		
		for k,str in ipairs(sher_text)
			
			local addspace = str:sub(1,2) ~= "* "
			if addspace then x = $ + 6 end
			
			v.drawString(x,y,str, V_ALLOWLOWERCASE, "small")
			
			if str == ""
				y = $ + 7
			else
				y = $ + 5
			end
			if addspace then x = $ - 6 end
			
		end
	end
})

local murd_text = {
	"* You and your teammates must \x85".."dispatch everyone\x80.", "",

	"* Be sneaky! Try to pick off people in secluded areas, or take a risk",
	"and kill multiple people with a sweeping motion!", "",
	
	"patchdraw", "",

	"* \x85Kill\x80 as many people as you can to get a massive \x82".."Coin Payout\x80!", "",
	
	"* If you don't kill enough people before the timer ends, \x85Overtime\x80",
	"will start and \x89The Storm\x80 will start closing in.",
	"\x82Showdown\x80 will start when the number of \x85Murderers\x80 matches",
	"the number of \x83Innocents\x80, and takes priority over \x85Overtime\x80.", "",
	
	"* Collect your clues to earn a \x85Luger\x80, a silent gun with no bullet drop off!", "",
	
	"* Pick up "..(sher_cc).."Sheriffs'\x80 guns to use as your own.", "",
	"* Purchase \x82Perks\x80 from the Shop to make your job easier!", "",
}
MenuLib.addMenu({
	stringId = "GuidePage_Murderer",
	title = "\x85Murderer\x80",

	width = 270,
	height = 180,
	
	drawer = function(v, ML, menu, props)
		local x,y = props.corner_x, props.corner_y
		x = $ + 2
		y = $ + 15
		
		--Bruh
		MenuLib.interpolate(v,false)
		v.draw(x + props.fakewidth - 35,
			y + 70,
			v.cachePatch("BGLSE0"), 0
		)
		MenuLib.interpolate(v,true)
		
		for k,str in ipairs(murd_text)
			if str == "patchdraw"
				local scale = FU / 4
				local patch = v.cachePatch("MMGUD_KILL")
				x = $ + 4
				v.drawScaled(x*FU,y*FU, scale, patch, 0)
				
				y = $ + FixedInt(patch.height * scale) + 3
				v.drawString(x,y,
					"The red arrow indicates people in range.",
					V_ALLOWLOWERCASE|V_YELLOWMAP,
					"small-thin"
				)
				x = $ - 4
				continue
			end
			
			local addspace = str:sub(1,2) ~= "* "
			if addspace then x = $ + 6 end
			
			v.drawString(x,y,str, V_ALLOWLOWERCASE, "small")
			
			if str == ""
				y = $ + 7
			else
				y = $ + 5
			end
			if addspace then x = $ - 6 end
			
		end
	end
})

MenuLib.addMenu({
	stringId = "GuidePage_Mechanics",
	title = "Mechanics",
	
	width = 250,
	height = 130,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 10
		y = $ + 20
		
		drawGenericButton(v,x,y, "\x89".."The Storm", "TheStorm")	
		y = $ + rolebutt.h + 4
		
		drawGenericButton(v,x,y, "", "Overtime", false, 8)
		do
			local center = y + (rolebutt.h + 8) / 2
			v.drawString(x + rolebutt.w/2, center - 9,
				"\x85Overtime\n\x82Showdown",
				V_ALLOWLOWERCASE,
				"thin-center"
			)
		end
		y = $ + rolebutt.h + 4 + 8
		
		drawGenericButton(v,x,y, "\x82Interactions", "TheStorm")	
		y = $ + rolebutt.h + 4
		
		drawGenericButton(v,x,y, "\x82Perks", nil,nil,nil, 3)
		y = $ + rolebutt.h + 4
		
	end
})

MenuLib.addMenu({
	stringId = "Protips",
	title = "Guide",
	
	width = 250,
	height = 130,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 5
		y = $ + 20
		
		do
			v.drawString(x,y,"Roles",V_YELLOWMAP|V_ALLOWLOWERCASE,"left")
			y = $ + 12
			
			drawRoleButton(v,x,y, MMROLE_INNOCENT)
			y = $ + rolebutt.h + 4
			
			drawRoleButton(v,x,y, MMROLE_SHERIFF)
			y = $ + rolebutt.h + 4
			
			drawRoleButton(v,x,y, MMROLE_MURDERER)
			y = $ + rolebutt.h + 4
			
			y = $ + 6
			drawGenericButton(v,x,y, "\x82".."HUD", "HUDPU", true)
			
		end
		
		x = props.corner_x + 100
		y = props.corner_y + 32
		
		do
			drawGenericButton(v,x,y, "\x82".."Mechanics", "Mechanics")			
		end
	end
})