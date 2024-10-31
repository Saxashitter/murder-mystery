local getCount = MM.require "Libs/getCount"

local function is_showdown(innocents, count)
	if count > 2 then
		return innocents == 1
	end

	return false
end

return function()
	local count, innocents = getCount()

	-- 1 innocent? start showdown
	if is_showdown(innocents, count)
	and not MM_N.showdown then
		MM:startShowdown()
	end

	if MM_N.showdown then
		if mapmusname ~= MM_N.showdown_song then
			mapmusname = MM_N.showdown_song
			S_ChangeMusic(MM_N.showdown_song, true)
		end
		MM_N.showdown_ticker = $+1
	end
end