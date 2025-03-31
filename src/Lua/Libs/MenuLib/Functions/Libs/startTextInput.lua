local ML = MenuLib

return function(buffer, id, onclose, onenter, typesound)
	if ML.client.textbuffer_id ~= nil then return end
	
	ML.client.textbuffer = buffer
	ML.client.textbuffer_id = id
	ML.client.textbuffer_sfx = typesound or sfx_menu1
	ML.client.textbuffer_funcs = {
		close = onclose,
		enter = onenter
	}
end