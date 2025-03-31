local ML = MenuLib

return function(buffer, id, onclose, onenter)
	if ML.client.textbuffer_id == nil then return end
	
	ML.client.textbuffer = nil
	ML.client.textbuffer_id = nil
	ML.client.textbuffer_funcs = {}
	ML.client.textbuffer_sfx = nil
	ML.client.textbuffer_tooltip = nil
end