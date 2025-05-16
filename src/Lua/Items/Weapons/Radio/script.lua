local LAST_POSITION = 0
addHook("MapChange",do LAST_POSITION = 0; end)

local mute = CV_RegisterVar({
	name = "mm_muteradio",
	defaultvalue = 0,
	PossibleValue = CV_YesNo
})

local function restoremusic(p)
	if not MM_N.gameover
		if P_IsLocalPlayer(p)
			P_RestoreMusic(p)
			if LAST_POSITION
				S_SetMusicPosition(LAST_POSITION)
			end
		end
	end
	LAST_POSITION = 0
end

local function is_in_dist(self, p)
	local MAX_DIST = 256*FU
	local dist = R_PointToDist2(self.x, self.y, p.mo.x, p.mo.y)
	
	--?
	if not p.mo.health then return false; end
	
	if dist <= MAX_DIST then
		return true, FixedDiv(dist, MAX_DIST)
	end

	return false
end

local function manage_music(self, p)
	local song = self.song or MMRadio.songs["macca"]
	
	local applymusic = false
	if (p and p.mo and p.mo.health
	and p.mm and not p.mm.spectator)
		applymusic = true
	end
	if MM_N.gameover
		applymusic = false
	end
	
	if not (applymusic) then
		restoremusic(p)
		if p.mm then
			p.mm.cur_listening = nil
		end
		return
	end

	local play,dist = is_in_dist(self, p)

	if not play
	and p.mm.cur_listening then
		restoremusic(p)
		p.mm.cur_listening = nil
	end

	if not play then return end

	local volume = ease.inexpo(dist, 100, 0)
	--audio attenuation
	local radius = 32 * self.scale + p.mo.radius
	if (abs(p.mo.x - self.x) > radius
	or abs(p.mo.y - self.y) > radius)
		local pointto = R_PointToAngle2(p.mo.x, p.mo.y, self.x,self.y)
		local myang = p.mo.angle
		local diff = FixedAngle(
			AngleFixed(pointto) - AngleFixed(myang)
		)
		if AngleFixed(diff) > 180*FU
			diff = InvAngle($)
		end
		
		if AngleFixed(diff) > 15*FU
			diff = FixedAngle( AngleFixed($) - 15*FU )
			
			local factor = FixedDiv(AngleFixed(diff), (180 - 15)*FU)
			factor = $ * 3/4
			
			volume = FixedMul($, FU - factor)
		end
	end

	if P_IsLocalPlayer(p)
	and not (mute.value)
		if (p.mm.last_listening ~= p.mm.cur_listening) then
			LAST_POSITION = S_GetMusicPosition()
			P_PlayJingleMusic(p, song.name, 0, true, JT_OTHER)
			
			--only synch when music starts
			local pos = S_GetMusicPosition()
			local leng = S_GetMusicLength()
			
			if leng ~= 0 then
				local ticpos = self.ticker%(leng*TICRATE/MUSICRATE)
				
				if abs(ticpos - (pos*TICRATE/MUSICRATE)) >= TICRATE then
					S_SetMusicPosition(ticpos*MUSICRATE/TICRATE)
				end
			end
		end
		
		if not (mute.value) then
			S_SetInternalMusicVolume(volume)
		end
		
	end
end

MM.addHook("PlayerThink", function(p)
	if not (p.mm.cur_listening and p.mm.cur_listening.valid) then
		if p.mm.cur_listening then
			p.mm.cur_listening = nil
			restoremusic(p)
		end
		return
	end

	manage_music(p.mm.cur_listening, p)
end)