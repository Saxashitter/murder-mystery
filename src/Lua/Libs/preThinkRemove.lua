local thinkerMobjs = {}
addHook("NetVars", function(n) thinkerMobjs = n($) end)

addHook("PreThinkFrame", do
	for k,mobj in pairs(thinkerMobjs) do
		if not (mobj and mobj.valid) then
			table.remove(thinkerMobjs, k)
			continue
		end

		P_RemoveMobj(mobj)
		table.remove(thinkerMobjs, k)
	end
end

-- made to prevent killing freezes
return function(mobj)
	if not (mobj and mobj.valid) then return end

	table.insert(thinkerMobjs, mobj)
end