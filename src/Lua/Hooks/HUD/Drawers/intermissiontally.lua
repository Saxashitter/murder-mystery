local function HUD_IntermissionText(v)
	local type = MM_N.endType or MM.endTypes[1]

	v.drawString(160, 60, type.name, V_SNAPTOTOP|type.color, "center")
	v.drawString(160, 200-24, "This mode is in alpha!", V_SNAPTOBOTTOM, "center")
end

return HUD_IntermissionText