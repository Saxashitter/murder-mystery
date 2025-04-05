local mute = CV_RegisterVar({
	name = "mm_muteradio",
	defaultvalue = 0,
	PossibleValue = CV_YesNo
})

local function is_in_dist(self, p)
	local MAX_DIST = 500*FU
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
		P_RestoreMusic(p)
		if p.mm then
			p.mm.cur_listening = nil
		end
		return
	end

	local play,dist = is_in_dist(self, p)

	if not play
	and p.mm.cur_listening then
		P_RestoreMusic(p)
		p.mm.cur_listening = nil
	end

	if not play then return end

	local volume = ease.linear(dist, 100, 0)

	if p == consoleplayer
	and S_MusicName() ~= song.name
	and not (mute.value) then
		S_ChangeMusic(song.name, true, p)
	end

	if p == consoleplayer then
		if not (mute.value) then
			S_SetInternalMusicVolume(volume)
		end
		
		local pos = S_GetMusicPosition()
		local leng = S_GetMusicLength()
		
		if leng ~= 0 then
			local ticpos = self.ticker%(leng*TICRATE/MUSICRATE)
			
			if abs(ticpos - (pos*TICRATE/MUSICRATE)) >= TICRATE then
				S_SetMusicPosition(ticpos*MUSICRATE/TICRATE)
			end
		end
	end
end

MM.addHook("PlayerThink", function(p)
	if not (p.mm.cur_listening and p.mm.cur_listening.valid) then
		if p.mm.cur_listening then
			p.mm.cur_listening = nil
			P_RestoreMusic(p)
		end
		return
	end

	manage_music(p.mm.cur_listening, p)
end)