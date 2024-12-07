local cur_state
local state_list = {}
local buttons = 0
local lastbuttons = 0
local forwardmove = 0
local sidemove = 0

-- THIS IS CLIENTSIDED!!
-- the magic lies in commands

function MM.addStateToList(state)
	state_list[name] = dofile "States/"..state
end

function MM.changeState(state)
	cur_state = state
end

addHook("PlayerCmd", function(p, cmd)
	if cur_state then
		lastbuttons = buttons
		buttons = cmd.buttons

		cmd.buttons = 0
		cmd.forwardmove = 0
		cmd.sidemove = 0

		return
	end

	lastbuttons = 0
	buttons = 0
end)

addHook("ThinkFrame", function(p)
	if not cur_state then return end

	cur_state:think(button, lastbuttons, forwardmove, sidemove)
end)