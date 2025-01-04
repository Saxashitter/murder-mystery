return function(pos)
	local fakerange = 256*FU
	local dummy = P_SpawnMobj(pos.x,pos.y,pos.z,MT_RAY)
	
	searchBlockmap("lines", function(ref, line)
		if line.frontsector
			P_SpawnLightningFlash(line.frontsector)
			
			for rover in line.frontsector.ffloors()
				P_SpawnLightningFlash(rover.sector)
			end
		end
		if line.backsector
			P_SpawnLightningFlash(line.backsector)
			
			for rover in line.backsector.ffloors()
				P_SpawnLightningFlash(rover.sector)
			end
		end
	end, 
	dummy,
	pos.x-fakerange, pos.x+fakerange,
	pos.y-fakerange, pos.y+fakerange)
	
	if dummmy and dummy.valid
		P_RemoveMobj(dummy)
	end
end