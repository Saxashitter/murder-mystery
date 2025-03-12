local radio = {}

rawset(_G, "MMRadio", {})

states[freeslot "S_MM_RADIO"] = {
	sprite = freeslot "SPR_RADO",
	frame = A,
	tics = -1,
	nextstate = S_MM_RADIO
}

-- BPM might be unused but still fill it out.
MMRadio.songs = {
	["macca"] = {
		name = "RSONG1",
		bpm = 150
	},
	["portal"] = {
		name = "RSONG2",
		bpm = 120,
	},
	["fellas"] = {
		name = "RSONG3",
		bpm = 120,
	},
	["tacos"] = {
		name = "RSONG4",
		bpm = 120
	},
	["elevator"] = {
		name = "RSONG5",
		bpm = 120
	},
	["sonicr"] = {
		name = "RSONG6",
		bpm = 120
	},
	["overtime"] = {
		name = "RSONG7",
		bpm = 149
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
radio.shootable = false
radio.shootmobj = MT_THOK

radio.drop = function(item,p,mobj)
	mobj.targetplayer = p
	mobj.song = p.mmradio_song or sfx_rsong1
	mobj.color_set = p.mo.color
	mobj.ticker = 0
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
	
	for p in players.iterate do
		if not (p and p.mo and p.mm) then continue end

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