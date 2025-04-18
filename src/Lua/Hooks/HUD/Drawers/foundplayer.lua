local LAST_TIME = 7*TICRATE
local CHANGE_TIME = TICRATE/2

local BIO_TEXTS = {
	"BRING", "IT", "ON!"
}
local HEIGHT = (9*FU)*#BIO_TEXTS

local STATE_CHANGE = 4*TICRATE

local BIO_Y = -256
local BIO_SHAKE = 0
local BIO_INDEX = 0
local BIO_CHANGETIME = CHANGE_TIME
local BIO_TICKER = LAST_TIME

local FADE = 0

local SI_Y = -256

local function init_vars(v)
	BIO_Y = v.height()*(FU/2)/v.dupy()
	BIO_SHAKE = 0
	BIO_INDEX = 0
	BIO_CHANGETIME = CHANGE_TIME
	BIO_TICKER = LAST_TIME
    FADE = 0

	SI_Y = v.height()*FU/v.dupy()
end

return function(v,p)
    if BIO_Y == -256
        BIO_Y = v.height()*(FU/2)/v.dupy()
    end
    if SI_Y == -256
        SI_Y = v.height()*FU/v.dupy()
    end

	if not (MM_N.waiting_for_players and MM_N.found_player) then
		init_vars(v)
		return
	end

	FADE = min($+1, 13)

	v.fadeScreen(0xFF00, FADE)

	BIO_CHANGETIME = max(0, $-1)
	BIO_SHAKE = max(0, $-(FU/12))

	if BIO_TICKER <= STATE_CHANGE then
		BIO_Y = ease.linear(FU/7, $, 8*FU + HEIGHT/2)
		SI_Y = ease.linear(FU/7, $, (v.height()*FU/v.dupy())-(10*FU))

		if not (MM_N.waiting_start_time % TICRATE) then
			S_StartSound(nil, sfx_menu1)
		end
	end

	if not (BIO_CHANGETIME)
	and BIO_INDEX < #BIO_TEXTS then
		BIO_INDEX = $+1
		BIO_CHANGETIME = CHANGE_TIME
		S_StartSound(nil, sfx_pstop)
		BIO_SHAKE = FU
	end

	if BIO_INDEX then
		local y = -HEIGHT/2
		local shakeX = v.RandomRange(-4*BIO_SHAKE, 4*BIO_SHAKE)
		local shakeY = v.RandomRange(-4*BIO_SHAKE, 4*BIO_SHAKE)

		for i = 1,BIO_INDEX do
			local text = BIO_TEXTS[i]

			v.drawString(160*FU + shakeX, BIO_Y+y+shakeY, text, V_SNAPTOTOP, "fixed-center")
			y = $+(9*FU)
		end
	end

	v.drawString(160*FU, SI_Y, "START IN "..(MM_N.waiting_start_time/TICRATE), V_SNAPTOTOP|V_YELLOWMAP, "fixed-center")
    BIO_TICKER = max($ - 1, 0)
end