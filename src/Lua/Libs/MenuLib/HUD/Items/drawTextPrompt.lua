local ML = MenuLib

local textinput_time = 0
local textinput_tween = TICRATE/4
local textinput_tweenfrac = FU / textinput_tween

local function drawRect(v,x,y, w,h)
	do
		--top/bottom
		v.drawFill(x - 2,
			y - 2,
			w + 3, 1,
			156
		)
		v.drawFill(x - 2,
			y + h + 1,
			w + 3, 1,
			156
		)
		
		--left/right
		v.drawFill(x - 2,
			y - 2,
			1, h + 4,
			156
		)
		v.drawFill(x + w + 1,
			y - 2,
			1, h + 4,
			156
		)
	end
	
	v.drawFill(x,y,w,h,156)
	
end

local function drawBackground(v, x,y)
	local w = BASEVIDWIDTH - (x*2)
	local h = 128
	y = $ - 45
	v.drawFill(x,
		y,
		w,h,
		159
	)
	
	--inner outline
	do
		--top/bottom
		v.drawFill(x + 1,
			y + 1,
			w - 2, 1,
			156
		)
		v.drawFill(x + 1,
			y + h - 2,
			w - 2, 1,
			156
		)
		
		--left/right
		v.drawFill(x + 1,
			y + 1,
			1, h - 2,
			156
		)
		v.drawFill(x + w - 2,
			y + 1,
			1, h - 2,
			156
		)
	end
	
	v.drawString(x+w - 3,
		y + 4,
		"Press ESC to close.",
		V_ALLOWLOWERCASE,
		"thin-right"
	)
	v.drawFill(x + 1,
		y + 13,
		w - 2, 1,
		156
	)
end

local function drawIt(v, ML)
	--text input
	if (ML.client.textbuffer ~= nil)
		textinput_time = min($ + 1, textinput_tween + 1)
	else
		textinput_time = max($ - 1, 0)
	end
	
	if textinput_time
		local boxwidth = (8*(32 + 1)) + 7
		local x = BASEVIDWIDTH/2 - (boxwidth/2) - 16
		local y = 80 + ease.outquad(
			min(textinput_tweenfrac * textinput_time, FU),
			320*FU, 0
		) / FU
		local leftmost = (BASEVIDWIDTH - boxwidth)/2
		
		v.fadeScreen(0xFF00,
			ease.outquad(
				min(textinput_tweenfrac * textinput_time, FU),
				0, 24*FU
			) / FU
		)
		
		drawBackground(v,x,y)
		
		local typestr = "Use your keyboard to type."
		drawRect(v, leftmost, y-8, v.stringWidth(typestr,0,"thin") + 6, 14)
		v.drawString(leftmost + 3,
			y - 5,
			typestr,
			V_ALLOWLOWERCASE,
			"thin"
		)
		
		--text box
		drawRect(v, leftmost, y+9, boxwidth - 8, 14)
		if ML.client.textbuffer == nil then return end
		
		local blinking = (((4*leveltime)/TICRATE) & 1) and "_" or ""
		if ML.client.textbuffer:len() == 32 then blinking = ""; end
		v.drawString(leftmost + 3,
			y + 12 + 1,
			ML.client.textbuffer .. blinking,
			V_ALLOWLOWERCASE|V_6WIDTHSPACE,
			"left"
		)
		
		if ML.client.textbuffer_tooltip ~= nil
			local tip = ML.client.textbuffer_tooltip
			
			if type(tip) == "string"
				drawRect(v, leftmost, y+26, v.stringWidth(tip,0,"thin") + 6, 14)
				v.drawString(leftmost + 3,
					y + 29,
					tip,
					V_ALLOWLOWERCASE,
					"thin"
				)
			elseif type(tip) == "table"
				drawRect(v, leftmost, y+26, boxwidth - 8, 4 + #tip*10)
				local worky = 29
				
				for k,string in ipairs(tip)
					v.drawString(leftmost + 3,
						y + worky,
						string,
						V_ALLOWLOWERCASE,
						"thin"
					)
					worky = $ + 10
				end
				
			end
			
		end
	end
end

return function(v, ML)
	drawIt(v, ML)	
end, nil, true