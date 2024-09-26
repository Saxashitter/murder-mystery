local function doAndInsert(file)
	MM[file] = dofile("Functions/Scripts/"..file)
end

doAndInsert("isMM")
doAndInsert("init")
doAndInsert("playerInit")
doAndInsert("endGame")
doAndInsert("pingMurderers")
doAndInsert("playerWithGun")