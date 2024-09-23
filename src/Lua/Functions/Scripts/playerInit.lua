local shallowCopy = MM.require "Libs/shallowCopy"
local playerVars = MM.require "Variables/Data/Player"

return function(self, p)
	p.mm = shallowCopy(playerVars)
end