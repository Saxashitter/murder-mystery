local ML = MenuLib

return function(buffer, id, props)
	if ML.client.textbuffer_id ~= nil then return end
	
	local onclose = props.onclose
	local onenter = props.onenter
	local tooltip = props.tooltip
	local typesound = props.typesound
	
	ML.client.textbuffer = buffer
	ML.client.textbuffer_id = id
	ML.client.textbuffer_sfx = typesound or sfx_menu1
	ML.client.textbuffer_funcs = {
		close = onclose,
		enter = onenter
	}
	ML.client.textbuffer_tooltip = tooltip
end