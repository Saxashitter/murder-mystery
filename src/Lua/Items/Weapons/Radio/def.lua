local radio = {}

rawset(_G, "MMRadio", {})

states[freeslot "S_MM_RADIO"] = {
	sprite = freeslot "SPR_RADO",
	frame = A,
	tics = -1,
	nextstate = S_MM_RADIO
}

local note_fuse = TICRATE * 3/2
freeslot("S_MM_RADIO_NOTE")
states[S_MM_RADIO_NOTE] = {
	sprite = SPR_RADO,
	frame = B,
	tics = 1,
	nextstate = S_MM_RADIO_NOTE,
	action = function(note)
		if P_IsObjectOnGround(note)
		and (note.lastmomz ~= nil)
			if not note.wasgrounded
			and abs(note.lastmomz) > note.scale * 4
				note.momz = - note.lastmomz / 2
			end
			note.momx = $ * 9/10
			note.momy = $ * 9/10
		end
		
		if not P_IsObjectOnGround(note)
			note.momz = $ + P_GetMobjGravity(note)
		end
		
		note.lastmomz = note.momz
		note.wasgrounded = P_IsObjectOnGround(note)
		if note.myframe ~= nil
			note.frame = note.myframe
		end
		if note.fuse < 10
			note.alpha = $ - FU/10
		end
	end
}

-- BPM might be unused but still fill it out.
MMRadio.songs = {
	["macca"] = {
		name = "RSONG1",
		bpm = 150,
        --for menu
        realname = "macca"
	},
	["portal"] = {
		name = "RSONG2",
		bpm = 120,
        realname = "portal"
	},
	["fellas"] = {
		name = "RSONG3",
		bpm = 120,
        realname = "fellas"
	},
	["tacos"] = {
		name = "RSONG4",
		bpm = 120,
        realname = "tacos"
	},
	["elevator"] = {
		name = "RSONG5",
		bpm = 120,
        realname = "elevator"
	},
	["sonicr"] = {
		name = "RSONG6",
		bpm = 120,
        realname = "sonicr"
	},
	["overtime"] = {
		name = "RSONG7",
		bpm = 149,
        realname = "overtime"
	},
}

radio.id = "radio"
radio.category = "Item"
radio.display_name = "Radio"
radio.display_icon = "MM_RADIO"
radio.state = S_MM_RADIO

radio.timeleft = -1

radio.hit_time = 0
radio.animation_time = 8
radio.cooldown_time = 0

radio.range = 0
radio.zrange = 0

radio.position = {
	x = FU,
	y = 0,
	z = 0
}
radio.animation_position = {
	x = FU,
	y = 0,
	z = -FU/3
}

radio.stick = true
radio.animation = true
radio.damage = false
radio.weaponize = false
radio.droppable = true
radio.droppable_clue = true
radio.shootable = false
radio.shootmobj = MT_THOK
radio.allowdropmobj = true
radio.noitemsparkles = true

radio.drop = function(item,p,mobj)
	if mobj and mobj.valid then
		mobj.targetplayer = p
		mobj.song = p.mmradio_song or sfx_rsong1
		mobj.color_set = p.mo.color
		mobj.ticker = 0
	end
end

radio.pickup = function(mobj,p2)
	local p = mobj.targetplayer

	if not (p
	and p.valid
	and p.mo
	and p.mo.health
	and p.mm
	and not p.mm.spectator) then
		return
	end

	return p2 ~= p
end

local function is_in_dist(self, p)
	local MAX_DIST = 500*FU
	local dist = R_PointToDist2(self.x, self.y, p.mo.x, p.mo.y)

	if dist <= MAX_DIST then
		return true, FixedDiv(dist, MAX_DIST)
	end

	return false
end

local function can_assign(self, p, dist)
	if not (p.mm.cur_listening and p.mm.cur_listening.valid) then
		return true
	end

	local other = p.mm.cur_listening

	local play,dist2 = is_in_dist(other, p)

	if not play then
		return true
	end

	return dist < dist2
end

radio.dropthinker = function(mobj)
	mobj.colorized = true
	mobj.color = mobj.color_set
	
	if (leveltime % 10) == 0
		local wind = P_SpawnMobj(
			mobj.x + P_RandomRange(-18,18)*mobj.scale,
			mobj.y + P_RandomRange(-18,18)*mobj.scale,
			mobj.z + (mobj.height/2) + P_RandomRange(-20,20)*mobj.scale,
			MT_PARTICLE
		)
		wind.flags = MF_NOCLIPTHING
		wind.state = S_MM_RADIO_NOTE
		wind.fuse = note_fuse
		wind.renderflags = $|RF_FULLBRIGHT
		wind.frame = $ + P_RandomRange(0, 3)
		wind.myframe = wind.frame
		P_Thrust(wind, R_PointToAngle2(wind.x,wind.y, mobj.x,mobj.y), 2 * mobj.scale)
		P_SetObjectMomZ(wind,P_RandomRange(3,6)*FU)
	end
	
	for p in players.iterate do
		if not (p and p.mo and p.mm) then continue end
		
		p.mm.last_listening = p.mm.cur_listening
		if p.mm.cur_listening
		and not (p.mm.cur_listening.valid) then
			p.mm.cur_listening = nil
		end
		
		local play,dist = is_in_dist(mobj, p)
		
		if not play then continue end
		
		if can_assign(mobj, p, dist) then
			p.mm.cur_listening = mobj
		end
	end

	mobj.ticker = $+1
end

dofile "Items/Weapons/Radio/script"

return radio