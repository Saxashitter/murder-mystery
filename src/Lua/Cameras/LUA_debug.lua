/*
TODO: reimplement this cvar someday

local cvd = CV_RegisterVar({"showdebug", "1", 0, CV_YesNo})
*/

-- sorted pairs but cooler

local function spairs(t, sortfun)
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end -- collect keys
	
	table.sort(keys, sortfun) -- sort
	
	local i = 0
	return function() -- iterate
		i = $+1
		if keys[i] then return keys[i],t[keys[i]] end
	end
end

local dict = {
	["nil"] = "nil",
	["boolean"] = "bool",
	["number"] = "int",
	["string"] = "str",
	["function"] = "func",
	["userdata"] = "udata",
	["thread"] = "thrd",
	["table"] = "table",
}
rawset(_G, "drawContentsRecursively", function(dw, t, s)
	-- draws table t recursively
	-- dw must be a drawer, t must be a table, s must be a table
	-- ensure s is already populated with position, do not modify during runtime
	-- s = state
	
	--if s == nil then error("argument #3 is missing",2) end
	if s.level == nil then
		s.level = 0
	end
	
	local levelpush = s.level*4
	
	if next(t) == nil then
		dw.drawString(s.x + levelpush, s.y,
			"\134".."[empty]",
		V_ALLOWLOWERCASE, "small-thin")
		s.y = $+4
		return
	end
	if t._HIDE then
		dw.drawString(s.x + levelpush, s.y,
			"\134".."[hidden]",
		V_ALLOWLOWERCASE, "small-thin")
		s.y = $+4
		return
	end
	for k,v in spairs(t) do
		local vstr = tostring(v)
		local vtype,utype = type(v),""
		
		local hex = vstr:sub(-8,-1)
		local pre,post = dict[vtype],vstr
		
		if vtype == "userdata" then
			utype = userdataType(v)
			post = utype.." "..hex
			--if utype ~= "unknown" then post = utype end
		elseif vtype == "table" then
			--post = hex.." #"..#v
			post = hex
			pre = $.."["..#v.."]"
		elseif vtype == "function" or vtype == "thread" then
			post = hex
		end
		
		
		
		dw.drawString(s.x + levelpush, s.y,
			("\130%s \128%s \131%s"):format(pre, tostring(k), post),
		V_ALLOWLOWERCASE, "small-thin")
		
		s.y = $+4
		if vtype == "table" then
			s.level = $+1
			drawContentsRecursively(dw, v, s)
			s.level = $-1
		end
	end
end)

/*
function: 16e52400
function: 08104940
table: 07eba4c8
userdata: 1692d750
userdata: 1692d8a0

128	0x80	White/Reset	Sampletext-none.png
129	0x81	Magenta	Sampletext-magenta.png
130	0x82	Yellow	Sampletext-yellow.png
131	0x83	Green	Sampletext-green.png
132	0x84	Blue	Sampletext-blue.png
133	0x85	Red	Sampletext-red.png
134	0x86	Gray	Sampletext-gray.png
135	0x87	Orange	Sampletext-orange.png
136	0x88	Sky	Sampletext-sky.png
137	0x89	Purple	Sampletext-purple.png
138	0x8A	Aqua	Sampletext-aqua.png
139	0x8B	Peridot	Sampletext-peridot.png
140	0x8C	Azure	Sampletext-azure.png
141	0x8D	Brown	Sampletext-brown.png
142	0x8E	Rosy	Sampletext-rosy.png
143	0x8F	Inverted
*/

