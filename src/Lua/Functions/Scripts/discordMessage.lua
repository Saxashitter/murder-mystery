return function(self,text)
	if isdedicatedserver
		print(text)
	end
	
	if not DiscordBot then return end
	
	DiscordBot.Data.msgsrb2 = $ .. text .."\n"
end