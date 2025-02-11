local ML = MenuLib

return function(v, props)
	local m_x = ML.client.mouse_x / FU
	local m_y = ML.client.mouse_y / FU
	
	if ((m_x > props.x) and (m_x < props.x + props.width))
	and ((m_y > props.y) and (m_y < props.y + props.height))
		return true
	end
	return false
end