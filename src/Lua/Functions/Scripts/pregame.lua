--this is a function incase we wanna do something with this in the future
return function(self)
	if (self.waiting_for_players) then return false end
	return leveltime <= self.pregame_time
end