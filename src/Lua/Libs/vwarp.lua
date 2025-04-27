-------------------------------
-- VWarp by UnmatchedBracket --
-------------------------------
--     A library to make     --
--    moving/scaling HUD     --
--     elements easier.      --
-------------------------------

-- NOTE: VWarp relies on CustomHUD for strings,
 -- and therefore does not support these flags:
   -- V_6WIDTHSPACE, V_OLDSPACING, V_MONOSPACE
 -- But really, you shouldn't be using those anyway.

-- defined here, filled out later
local vwarpcustomhud = {}

local function def(modv, truev, key)
    modv[key] = truev[key]
end

local function iif(cond, tru, fals)
    if cond then return tru else return fals end
end

local align_nonfixed2fixed = {
    ["left"]              = "fixed",
    ["center"]            = "fixed-center",
    ["right"]             = "fixed-right",
    ["small"]             = "small-fixed",
    ["small-center"]      = "small-fixed-center",
    ["small-right"]       = "small-fixed-right",
    ["thin"]              = "thin-fixed",
    ["thin-center"]       = "thin-fixed-center",
    ["thin-right"]        = "thin-fixed-right",
    ["small-thin"]        = "small-thin-fixed",
    ["small-thin-center"] = "small-thin-fixed-center",
    ["small-thin-right"]  = "small-thin-fixed-right",
}

--[[ align, scale, font ]]
local align_propertymap = {
    ["fixed"]                   = {"left",  FU,   "STCFN"},
    ["fixed-center"]            = {"center",FU,   "STCFN"},
    ["fixed-right"]             = {"right", FU,   "STCFN"},
    ["small-fixed"]             = {"left",  FU/2, "STCFN"},
    ["small-fixed-center"]      = {"center",FU/2, "STCFN"},
    ["small-fixed-right"]       = {"right", FU/2, "STCFN"},
    ["thin-fixed"]              = {"left",  FU,   "TNYFN"},
    ["thin-fixed-center"]       = {"center",FU,   "TNYFN"},
    ["thin-fixed-right"]        = {"right", FU,   "TNYFN"},
    ["small-thin-fixed"]        = {"left",  FU/2, "TNYFN"},
    ["small-thin-fixed-center"] = {"center",FU/2, "TNYFN"},
    ["small-thin-fixed-right"]  = {"right", FU/2, "TNYFN"},
}

local font_lineheights = {
    STCFN = 12,
    TNYFN = 12,
    CRFNT = 16,
    LTFNT = 16,
    NTFNT = 21,
    NTFNO = 21
}

for k, v in pairs({
    MAGENTA = {177,177,178,178,178,180,180,180,182,182,182,182,184,184,184,185},
    YELLOW = {82,82,73,73,73,74,74,74,66,66,66,66,67,67,67,68},
    GREEN = {96,96,98,98,98,100,100,100,103,103,103,103,105,105,105,107},
    BLUE = {146,146,147,147,147,148,148,148,149,149,149,149,150,150,150,151},
    RED = {32,32,33,33,33,34,34,34,35,35,35,35,37,37,37,39},
    GRAY = {8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23},
    ORANGE = {50,50,52,52,52,54,54,54,56,56,56,56,59,59,59,60},
    SKY = {129,129,130,130,130,131,131,131,133,133,133,133,135,135,135,136},
    PURPLE = {160,160,161,161,161,162,162,162,163,163,163,163,164,164,164,165},
    AQUA = {120,120,121,121,121,122,122,122,123,123,123,123,124,124,124,125},
    PERIDOT = {73,73,188,188,188,189,189,189,190,190,190,190,191,191,191,94},
    AZURE = {144,144,145,145,145,146,146,146,170,170,170,170,171,171,171,172},
    BROWN = {219,219,221,221,221,222,222,222,224,224,224,224,227,227,227,229},
    ROSY = {200,200,201,201,201,202,202,202,203,203,203,203,204,204,204,205},
    -- INVERT = {15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0}
    INVERT = {31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16}
}) do
    -- print("SKINCOLOR_" .. k .. "MAP")
    if not pcall(function () return _G["SKINCOLOR_" .. k .. "MAP"] end) then
        -- print("defining")
        skincolors[freeslot("SKINCOLOR_" .. k .. "MAP")] = {
            name = "V_" .. k .. "MAP",
            accessible = false,
            ramp = v,
            invcolor = SKINCOLOR_NONE,
            invshade = 5,
            chatcolor = _G["V_" .. k .. "MAP"]
        }
    end
end

local color_flag2skincolor = {
    [0]            = SKINCOLOR_NONE,
    [V_MAGENTAMAP] = SKINCOLOR_MAGENTAMAP,
    [V_YELLOWMAP]  = SKINCOLOR_YELLOWMAP,
    [V_GREENMAP]   = SKINCOLOR_GREENMAP,
    [V_BLUEMAP]    = SKINCOLOR_BLUEMAP,
    [V_REDMAP]     = SKINCOLOR_REDMAP,
    [V_GRAYMAP]    = SKINCOLOR_GRAYMAP,
    [V_ORANGEMAP]  = SKINCOLOR_ORANGEMAP,
    [V_SKYMAP]     = SKINCOLOR_SKYMAP,
    [V_PURPLEMAP]  = SKINCOLOR_PURPLEMAP,
    [V_AQUAMAP]    = SKINCOLOR_AQUAMAP,
    [V_PERIDOTMAP] = SKINCOLOR_PERIDOTMAP,
    [V_AZUREMAP]   = SKINCOLOR_AZUREMAP,
    [V_BROWNMAP]   = SKINCOLOR_BROWNMAP,
    [V_ROSYMAP]    = SKINCOLOR_ROSYMAP,
    [V_INVERTMAP]  = SKINCOLOR_INVERTMAP
}
local function colorflag2skincolor(flags)
    return color_flag2skincolor[(flags or 0) & V_CHARCOLORMASK]
end

local function splitLines(str)
    local lines = {}
    for line in (str.."\n"):gmatch("(.-)\n") do
        table.insert(lines, line)
    end
    return lines
end

--[[@param x number]]
--[[@param y number]]
--[[@param settings WarpSettings]]
local function posWarp(x, y, settings)
    return (
        FixedMul(x - settings.xorigin, settings.xscale) + settings.xorigin + settings.xoffset
    ), (
        FixedMul(y - settings.yorigin, settings.yscale) + settings.yorigin + settings.yoffset
    )
end


local function scaleWarp(xs, ys, f, settings)
    local wxs = FixedMul(xs, settings.xscale)
    local wys = FixedMul(ys, settings.yscale)
    if wxs < 0 then
        wxs = -$
        f = $ ^^ V_FLIP
    end
    -- uhh we cant y-flip
    return
        wxs,
        wys,
        f
end

---@param v videolib
---@param flags? number
---@param settings WarpSettings
---@return number|string newflags
local function transmult(v, flags, settings)
    if settings.transp <= 0 then return flags or 0 end
    -- this value is from 0=invisible to 10=opaque
    local ftrans = ((flags or 0) & V_ALPHAMASK) / V_10TRANS
    if ftrans > 12 then
        --??? too high
        ftrans = 10
    elseif ftrans >= 10 then
        --hudtrans, 10=half, 11=normal, 12=double
        -- this value is also from 0=invisible to 10=opaque
        local hudtrans = 10-(v.localTransFlag()/V_10TRANS)
        if ftrans == 10 then
            hudtrans = $/2
        elseif ftrans == 12 then
            hudtrans = min(10, $*2)
        end
        ftrans = hudtrans
    else
        ftrans = 10-ftrans
    end

    -- add 5 to round in a normal way
    local transp = max(0, min(settings.transp, 10))
    local mult = ((ftrans * (10-transp))+5)/10
    if mult == 0 then
        return "invisible"
    end

    return ((flags or 0) & ~V_ALPHAMASK) | ((10-mult)*V_10TRANS)
end

-- for x=0,9 do
--     local s = ""
--     for y=0,10 do
--         s = $ .. transmult(nil, x*V_10TRANS, {transp = y}) .. " "
--     end
--     print(s)
-- end

---@class WarpSettings
---@field xscale fixed_t? Scale factor for x; this one can be negative (default: FU)
---@field yscale fixed_t? Scale factor for y; this one must be positive or 0 (default: FU)
---@field xorigin fixed_t? Scale origin for x (default: 0, center of screen: 160FU)
---@field yorigin fixed_t? Scale origin for y (default: 0, center of screen: 100FU)
---@field xoffset fixed_t? Offset for x (default: 0)
---@field yoffset fixed_t? Offset for y (default: 0)
---@field transp number? Transparency, from 0 (normal) to 10 (invisible) (default: 0)

--[[@param truev videolib]]
--[[@param settings WarpSettings]]
--[[@return videolib]]
local function VWarp (truev, settings)
    if not settings then settings = {} end
    settings = {
        xscale  = settings.xscale  or FU,
        yscale  = settings.yscale  or FU,
        xorigin = settings.xorigin or 0,
        yorigin = settings.yorigin or 0,
        xoffset = settings.xoffset or 0,--160*FU - FixedMul(160*FU, xs),
        yoffset = settings.yoffset or 0,--100*FU - FixedMul(100*FU, ys)+cos(leveltime*ANG2*3)*10
        transp  = settings.transp  or 0
    }

    --[[@type videolib]]
    local modv = {settings = settings}

    -- cache
    def(modv, truev, "patchExists")
    def(modv, truev, "cachePatch")
    def(modv, truev, "getSpritePatch")
    def(modv, truev, "getSprite2Patch")
    def(modv, truev, "getColormap")
    def(modv, truev, "getStringColormap")
    def(modv, truev, "getSectorColormap")
    -- drawing
    modv.draw = function (x, y, p, f, c)
        modv.drawStretched(x*FU, y*FU, FU, FU, p, f, c)
    end
    modv.drawScaled = function (x, y, s, p, f, c)
        modv.drawStretched(x, y, s, s, p, f, c)
    end
    modv.drawStretched = function (x, y, xs, ys, p, f, c)
        f = transmult(truev, f, settings)
        if f == "invisible" then return end

        local wx, wy = posWarp(x, y, settings)
        local wxs, wys, wf = scaleWarp(xs, ys, f, settings)

        truev.drawStretched(
            wx, wy, wxs, wys,
            p, wf, c
        )
    end
    modv.drawCropped = function (x, y, xs, ys, p, f, c, sx, sy, w, h)
        f = transmult(truev, f, settings)
        if f == "invisible" then return end

        local wx, wy = posWarp(x, y, settings)
        local wxs, wys, wf = scaleWarp(xs, ys, f, settings)

        truev.drawCropped(
            wx, wy, wxs, wys,
            p, wf, c, sx, sy, w, h
        )
    end
    modv.drawNum = function (x, y, n, f)
        vwarpcustomhud.CustomNum(
            -- v, x, y, num, fontName, padding, flags, align, scale, color
            modv,
            -- x, y, num
            x*FU, y*FU, n,
            -- fontName, padding, flags, align
            "STTNUM", nil, f, "right",
            -- scale, color
            FU, colorflag2skincolor(f), f & V_CHARCOLORMASK
        )
    end
    modv.drawPaddedNum = function (x, y, n, d, f)
        if type(d) != "number" then
            d = 2
        elseif d < 1 then
            error("nonpositive digits value " .. d .. "given to VWarp().drawPaddedNum. FYI the standard function freezes the game if you do that.")
        end
        local strnum = tostring(abs(n))
        vwarpcustomhud.CustomNum(
            -- v, x, y, num, fontName, padding, flags, align, scale, color
            modv,
            -- x, y, num
            x*FU, y*FU, strnum:sub(max(0, #strnum - d + 1)),
            -- fontName, padding, flags, align
            "STTNUM", d, f, "right",
            -- scale, color
            FU, colorflag2skincolor(f), f & V_CHARCOLORMASK
        )
    end
    modv.drawFill = function (x, y, w, h, c)
        -- this is funky to make sure no gaps appear
        -- TODO maybe make this draw a texture? would be hard to do for a drop-in library lua. you probably shouldn't be using this anyway.
        local wx, wy = posWarp(x*FU, y*FU, settings)
        local wx2, wy2 = posWarp((x+w)*FU, (y+h)*FU, settings)
        wx = $/FU
        wy = $/FU
        wx2 = $/FU
        wy2 = $/FU
        if (wx == wx2) or (wy == wy2) then return end
        truev.drawFill(
            wx, wy,
            wx2 - wx,
            wy2 - wy,
            c
        )
    end
    modv.drawString = function (x, y, t, f, a)
        if align_nonfixed2fixed[a or "left"] then
            a = align_nonfixed2fixed[a or "left"]
            x = $ * FU
            y = $ * FU
        end

        -- since CustomHUD uses normal drawing functions we just need to translate the request and pass in modv
        -- align, scale, font name
        local metadata = align_propertymap[a]

        if f and (f & V_ALLOWLOWERCASE) then
            f = $ & ~V_ALLOWLOWERCASE
        else
            t = tostring(t):upper()
        end

        local lineheight = font_lineheights[metadata[3]]
        if f and (f & V_RETURN8) then
            lineheight = 8;
        end

        -- print(x .. "/" .. y .. "/" .. x/FU .. "f/" .. y/FU .. "f/" .. t .. "/" .. f)

        for _, line in pairs(splitLines(tostring(t))) do
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x, y, line,
                -- fontname, flags, align
                metadata[3], f or 0, metadata[1],
                -- scale, color
                metadata[2], colorflag2skincolor(f), f & V_CHARCOLORMASK
            )
            y = $ + FixedMul(lineheight*FU, metadata[2])
        end
    end
    modv.drawNameTag = function (x, y, t, f, bc, oc)
        local align = "left"

        if f and (f & V_CENTERNAMETAG) then
            align = "center"
        end
        f = (f or 0) & ~V_FLIP

        t = tostring(t):upper()

        for _, line in pairs(splitLines(tostring(t))) do
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x*FU, y*FU, line,
                -- fontname, flags, align
                "NTFNO", f or 0, align,
                -- scale, color
                FU, oc
            )
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x*FU, y*FU, line,
                -- fontname, flags, align
                "NTFNT", f or 0, align,
                -- scale, color
                FU, bc
            )
            y = $ + font_lineheights.NTFNT*FU
        end
    end
    modv.drawScaledNameTag = function (x, y, t, f, s, bc, oc)
        local align = "left"

        if f and (f & V_CENTERNAMETAG) then
            align = "center"
        end
        f = (f or 0) & ~V_FLIP

        t = tostring(t):upper()

        for _, line in pairs(splitLines(tostring(t))) do
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x, y, line,
                -- fontname, flags, align
                "NTFNO", f or 0, align,
                -- scale, color
                s, oc
            )
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x, y, line,
                -- fontname, flags, align
                "NTFNT", f or 0, align,
                -- scale, color
                s, bc
            )
            y = $ + FixedMul(font_lineheights.NTFNT*FU, s)
        end
    end
    modv.drawLevelTitle = function (x, y, t, f)
        -- level title is always lowercaseable, remove the flag to not flip the letters
        f = ($ or 0) & ~V_ALLOWLOWERCASE

        local lineheight = font_lineheights.LTFNT
        if f and (f & V_RETURN8) then
            lineheight = 8;
        end

        x = $*FU
        y = $*FU

        for _, line in pairs(splitLines(tostring(t))) do
            vwarpcustomhud.CustomFontString(
                -- v, x, y, str, fontname, flags, align, scale, color
                modv,
                -- x, y, str
                x, y, line,
                -- fontname, flags, align
                "LTFNT", f or 0, "left",
                -- scale, color
                FU, colorflag2skincolor(f), f & V_CHARCOLORMASK
            )
            y = $ + lineheight*FU
        end
    end
    def(modv, truev, "fadeScreen")
    -- misc
    def(modv, truev, "stringWidth")
    def(modv, truev, "nameTagWidth")
    def(modv, truev, "levelTitleWidth")
    def(modv, truev, "levelTitleHeight")
    -- random
    def(modv, truev, "RandomFixed")
    def(modv, truev, "RandomByte")
    def(modv, truev, "RandomKey")
    def(modv, truev, "RandomRange")
    def(modv, truev, "SignedRandom")
    def(modv, truev, "RandomChance")
    -- properties
    def(modv, truev, "width")
    def(modv, truev, "height")
    def(modv, truev, "dupx")
    def(modv, truev, "dupy")
    def(modv, truev, "renderer")
    def(modv, truev, "localTransFlag")
    def(modv, truev, "userTransFlag")

    return modv
end









-- #region CustomHUD

-- == Custom HUD Functions by TehRealSalt ==
-- Trimmed and modified for use in VWarp (specifically so i don't have to draw strings myself)

-- vwarpcustomhud def higher up

local function warn(str)
	print("\131WARNING: \128"..str);
end

local fonts = {};

local function CreateNewFont(fontName, kerning, space, mono)
	if (type(kerning) != "number")
		kerning = 0;
	end

	if (type(space) != "number")
		space = 4;
	end

	local newFont = {
		name = fontName,
		kerning = kerning,
		space = space,
		mono = nil,
		patches = {},
		number = false,
	};

	if (type(mono) == "number")
		newFont.mono = mono;
	end

	return newFont;
end

function vwarpcustomhud.SetupFont(fontName, kerning, space, mono)
	if (type(fontName) != "string") then
		warn("Invalid font name \""..fontName.."\" in customhud.SetupFont");
		return;
	end

	if (fontName:find(" ")) then
		warn("Font name \""..fontName.."\" cannot have spaces in customhud.SetupFont");
		return;
	end

	if (fontName:len() > 5) or (fontName:len() < 1) then
		warn("Bad font name length in customhud.SetupFont");
		return;
	end

	fonts[fontName] = CreateNewFont(fontName, kerning, space, mono);
end

function vwarpcustomhud.GetFont(fontName)
	return fonts[fontName];
end

local function FontPatchNameDirect(fontName, charByte)
	return fontName .. string.format("%03d", charByte);
end

local function FontPatchName(v, fontName, charByte)
	local patchName = FontPatchNameDirect(fontName, charByte);

	local capsOffset = 32;
	if (charByte >= 65 and charByte <= 90 and not v.patchExists(patchName)) then
		charByte = $1 + capsOffset;
		patchName = FontPatchNameDirect(fontName, charByte);
	elseif (charByte >= 97 and charByte <= 122 and not v.patchExists(patchName)) then
		charByte = $1 - capsOffset;
		patchName = FontPatchNameDirect(fontName, charByte);
	end

	return patchName;
end

local function NumberPatchName(v, fontName, charByte)
	local charNumber = charByte - 48;
	if (charNumber >= 0 and charNumber <= 9) then
		return fontName .. string.format("%d", charNumber);
    else -- EDIT: support for minus
        return fonts[fontName].minus
    end
	return "";
end

function vwarpcustomhud.GetFontPatch(v, font, charByte)
	if not (font.patches[charByte] and font.patches[charByte].valid) then
		local patchName = "";

		if (font.number == true) then -- Number-only font
			patchName = NumberPatchName(v, font.name, charByte);
		else
			patchName = FontPatchName(v, font.name, charByte);
		end

		if (patchName == "")
			return nil;
		end

		-- Try to create a new patch & cache it
		if (v.patchExists(patchName)) then
			font.patches[charByte] = v.cachePatch(patchName);
		end
	end

	return font.patches[charByte];
end

function vwarpcustomhud.CustomFontStringWidth(v, str, fontName, scale)
	if not (type(str) == "string") then
		warn("No string given in customhud.CustomFontStringWidth");
		return;
	end

	if not (type(fontName) == "string") then
		warn("No font given in customhud.CustomFontStringWidth");
		return;
	end

    if fontName == "NTFNO" then
        fontName = "NTFNT"
    end

	local font = vwarpcustomhud.GetFont(fontName);
	if (font == nil) then
		warn("Invalid font given in customhud.CustomFontStringWidth");
		return;
	end

	local strwidth = 0;
	if (str == "") then
		return strwidth;
	end

	if (type(scale) != "number")
		scale = nil;
	end

	local kerning = font.kerning;
	if (scale != nil) then
		kerning = $1 * scale;
	end

	local space = font.space;
	if (scale != nil) then
		space = $1 * scale;
	end

	local mono = font.mono;
	if (mono != nil and scale != nil) then
		mono = $1 * scale;
	end

	for i = 1,str:len() do
		local charByte = str:byte(i,i);
        if charByte >= 0x80 and charByte <= 0x8f then continue end
		local patch = vwarpcustomhud.GetFontPatch(v, font, charByte);

		if (patch and patch.valid) then
			local charWidth = patch.width;

			if (mono != nil) then
				charWidth = mono;
			elseif (scale != nil) then
				charWidth = $1 * scale;
			end

			strwidth = $1 + charWidth + kerning;
		else
			strwidth = $1 + space;
		end
	end

	return strwidth;
end

function vwarpcustomhud.CustomFontChar(v, x, y, charByte, fontName, flags, scale, color, textmap)
	if not (type(charByte) == "number") then
		warn("No character byte given in customhud.CustomFontChar");
		return;
	end

	if not (type(fontName) == "string") then
		warn("No font given in customhud.CustomFontChar");
		return;
	end

	local font = vwarpcustomhud.GetFont(fontName);
	if (font == nil) then
		warn("Invalid font given in customhud.CustomFontStringWidth");
		return;
	end

	if (type(scale) != "number")
		scale = nil;
	end

	local kerning = font.kerning;
	if (scale != nil) then
		kerning = $1 * scale;
	end

	local space = font.space;
	if (scale != nil) then
		space = $1 * scale;
	end

	local mono = font.mono;
	if (mono != nil and scale != nil) then
		mono = $1 * scale;
	end

	local wc = nil;
	if (textmap) then
		wc = v.getStringColormap(textmap)
	elseif (color) then
        -- EDITED: rainbow instead of default sometimes
        local tc = iif(fontName == "STCFN" or fontName == "TNYFN" or fontName == "LTFNT", TC_RAINBOW, TC_DEFAULT)
		wc = v.getColormap(tc, color);
	end

	local patch = vwarpcustomhud.GetFontPatch(v, font, charByte);
	if (patch and patch.valid) then
		if (scale != nil) then
			v.drawScaled(x, y, scale, patch, flags, wc);
		else
			v.draw(x, y, patch, flags, wc);
		end
	end

    if fontName == "NTFNO" then -- EDITED: hack to make nametag text draw correctly
        patch = vwarpcustomhud.GetFontPatch(v, vwarpcustomhud.GetFont("NTFNT"), charByte);
    end

	local nextx = x;
	if (patch and patch.valid) then
		local charWidth = patch.width;

		if (mono != nil) then
			charWidth = mono;
		elseif (scale != nil) then
			charWidth = $1 * scale;
		end

		nextx = $1 + charWidth + kerning;
	else
		nextx = $1 + space;
	end

	return nextx;
end

function vwarpcustomhud.CustomFontString(v, x, y, str, fontName, flags, align, scale, color, textmap)
	if not (type(str) == "string") then
		warn("No string given in customhud.CustomFontString");
		return;
	end

	if not (type(fontName) == "string") then
		warn("No font given in customhud.CustomFontChar");
		return;
	end

	local font = vwarpcustomhud.GetFont(fontName);
	if (font == nil) then
		warn("Invalid font given in customhud.CustomFontStringWidth");
		return;
	end

	if (type(scale) != "number")
		scale = nil;
	end

	local kerning = font.kerning;
	if (scale != nil) then
		kerning = $1 * scale;
	end

	local space = font.space;
	if (scale != nil) then
		space = $1 * scale;
	end

	local mono = font.mono;
	if (mono != nil and scale != nil) then
		mono = $1 * scale;
	end

	local wc = nil;
	if textmap then
		wc = v.getStringColormap(textmap)
	elseif (color) then
        -- EDITED: rainbow instead of default sometimes
        local tc = iif(font == "STCFN" or font == "TNYFN" or font == "LTFNT", TC_RAINBOW, TC_DEFAULT)
		wc = v.getColormap(tc, color);
	end

	local nextx = x;

	if (align == "right") then
		nextx = $1 - vwarpcustomhud.CustomFontStringWidth(v, str, fontName, scale);
	elseif (align == "center") then
		nextx = $1 - (vwarpcustomhud.CustomFontStringWidth(v, str, fontName, scale) / 2);
	end

	for i = 1,str:len() do
		local nextByte = str:byte(i,i);
        if nextByte >= 0x80 and nextByte <= 0x8f then
            color = colorflag2skincolor((nextByte-0x80)*V_MAGENTAMAP)
			textmap = (nextByte-0x80)*V_MAGENTAMAP
            continue
        end
		nextx = vwarpcustomhud.CustomFontChar(v, nextx, y, nextByte, fontName, flags, scale, color, textmap);
	end
end

function vwarpcustomhud.SetupNumberFont(fontName, kerning, space, mono)
	if (type(fontName) != "string") then
		warn("Invalid font name \""..fontName.."\" in customhud.SetupNumberFont");
		return;
	end

	if (fontName:find(" ")) then
		warn("Font name \""..fontName.."\" cannot have spaces in customhud.SetupNumberFont");
		return;
	end

	if (fontName:len() > 7) or (fontName:len() < 1) then
		warn("Bad font name length in customhud.SetupNumberFont");
		return;
	end

	local newFont = CreateNewFont(fontName, kerning, space, mono);
	newFont.number = true;

	fonts[fontName] = newFont;
end

function vwarpcustomhud.CustomNumWidth(v, num, fontName, padding, scale)
	local str = "";

	if (padding != nil)
		str = string.format("%0"..padding.."d", num);
	else
		str = string.format("%d", num);
	end

	return vwarpcustomhud.CustomFontStringWidth(v, str, fontName, scale);
end

function vwarpcustomhud.CustomNum(v, x, y, num, fontName, padding, flags, align, scale, color)
	local str = "";

	if (padding != nil)
		str = string.format("%0"..padding.."d", num);
	else
		str = string.format("%d", num);
	end

	return vwarpcustomhud.CustomFontString(v, x, y, str, fontName, flags, align, scale, color);
end
-- #endregion

vwarpcustomhud.SetupFont("STCFN", 0,  4)
vwarpcustomhud.SetupFont("TNYFN", 0,  2)
vwarpcustomhud.SetupFont("CRFNT", 0, 16)
vwarpcustomhud.SetupFont("LTFNT", 0, 16)
vwarpcustomhud.SetupFont("NTFNT", 2,  4) 
vwarpcustomhud.SetupFont("NTFNO", 2,  4)-- EDITED: default kerning is 0 but we need to do a kack elsewhere so match NTFNT

--numbers
vwarpcustomhud.SetupNumberFont("STTNUM", 0, 0, 8)
fonts["STTNUM"].minus = "STTMINUS" -- this is NOT normal functionality of CustomHUD fyi


return VWarp