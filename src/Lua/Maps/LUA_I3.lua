--from chrispy chars!!! by Lach!!!!
rawset(_G,"SafeFreeslot",function(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			return freeslot(item)
		end
	end
end)

sfxinfo[SafeFreeslot("sfx_rikrol")] = {
	flags = SF_X4AWAYSOUND,
	caption = "/"
}

sfxinfo[SafeFreeslot("sfx_wkplsc")] = {
	flags = SF_X4AWAYSOUND,
	caption = "Skill check"
}

SafeFreeslot("SPR_WKPL_SPARKLE")
SafeFreeslot("S_WKPL_SPARKLE")
states[S_WKPL_SPARKLE] = {
    sprite = SPR_WKPL_SPARKLE,
    frame = A|FF_ADD|FF_FULLBRIGHT,
	tics = -1,
}
SafeFreeslot("MT_WKPL_SPARKLE")
mobjinfo[MT_WKPL_SPARKLE] = {
	doomednum = -1,
	spawnstate = S_WKPL_SPARKLE,
	radius = 5*FRACUNIT,
	height = 10*FRACUNIT,
	flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_NOGRAVITY
}

local min_x = -1536
local min_y = -1152

local max_x = -1128
local max_y = -1536

local sparkle_type = MT_WKPL_SPARKLE
local sparkle_fuse = TICRATE * 3/2
local roll_limit = 20

addHook("ThinkFrame",do
	if not mapheaderinfo[gamemap] then return end
	if mapheaderinfo[gamemap].lvlttl ~= "Workplace" then return end
	if (leveltime % (TICRATE * 3/4)) then return end
	
	for sector in sectors.tagged(62)
		if P_RandomChance(FU/5) then continue end
		
		local x = P_RandomRange(min_x, max_x) * FU
		local y = P_RandomRange(min_y, max_y) * FU
		local z = P_FloorzAtPos(x,y, sector.floorheight, mobjinfo[sparkle_type].height)
		
		local spark = P_SpawnMobj(x,y,z, sparkle_type)
		P_SetObjectMomZ(spark, P_RandomRange(1, 5)*FU)
		spark.tics = -1
		spark.fuse = sparkle_fuse + P_RandomRange(-5, 5)
		spark.start = spark.fuse
		spark.alpha = 0
		
		spark.threshold = P_RandomRange(-roll_limit, roll_limit) * ANG1
	end
end)

addHook("MobjThinker",function(spark)
	spark.rollangle = $ + spark.threshold
	
	if spark.fuse < 10
		spark.alpha = $ - (FU/10)
	elseif spark.fuse > spark.start - 15
		spark.alpha = $ + (FU/15)
	end
end,sparkle_type)