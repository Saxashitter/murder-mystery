freeslot("MT_MM_CAMERA","S_MM_CAMERA","SPR_MMCM")
freeslot("SPR_MMCD")

mobjinfo[MT_MM_CAMERA] = {
	--$Name Camera
	--$Sprite MMCMJ0
	--$Category SaxaMM
	
	--$StringArg0 Name
	--$StringArg0ToolTip The name of this camera. (Ex. Kitchen, Hallway)
	
	--$Arg0 Interactable?
	--$Arg0Default 0
	--$Arg0Type 11
	--ik i can use yesno but idc
	--$Arg0Enum { 0="No"; 1="Yes";}
	--$Arg0Tooltip If true, players will be able to view other cameras through this one.
	
	--$Arg1 Sequence
	--$Arg1Default 0
	--$Arg1Type 0
	--$Arg1Tooltip The set of cameras this camera belongs to.
	
	--$Arg2 Order
	--$Arg2Default 0
	--$Arg2Type 0
	--$Arg2Tooltip The number of this camera in its set, where 0 is the first camera.\nThere should not be any "holes" in the orders. (0, 1, 2, 5) or (1, 2, 3)
	
	--$Arg3 Pan?
	--$Arg3Default 0
	--$Arg3Type 11
	--$Arg3Enum { 0="No"; 1="Yes";}
	--$Arg3Tooltip If true, this camera will look around periodically.
	
	--$Arg4 Pan Amount
	--$Arg4Default 0
	--$Arg4Type 8
	--$Arg4Tooltip The angle to pan left and right from.\nEx: 45 would tilt the camera 45 left, then back to the middle, then 45 right.

	--$Arg5 Pan Duration
	--$Arg5Default 0
	--$Arg5Type 0
	--$Arg5Tooltip The time the camera takes to do a pan cycle in tics.\nDefault is 2 seconds (70).

	--$Arg6 Invisible?
	--$Arg6Default 0
	--$Arg6Type 11
	--$Arg6Enum { 0="No"; 1="Yes";}
	--$Arg6Tooltip If true, this camera will be invisible.
	
	--$Arg7 Don't draw wire?
	--$Arg7Default 0
	--$Arg7Type 11
	--$Arg7Enum { 0="No"; 1="Yes";}
	--$Arg7Tooltip If true, this camera will not draw a wire from the ceiling.\nThe camera wont draw a wire at all if it's invisible.
	
	doomednum = 10000,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPTHING, --|MF_SPAWNCEILING,
	radius = 8*FRACUNIT,
	height = 12*FRACUNIT,
	spawnstate = S_MM_CAMERA
}

states[S_MM_CAMERA] = {
	sprite = SPR_MMCM,
	frame = A,
	tics = -1,
}

sfxinfo[ freeslot("sfx_mmcam0") ].caption = "Opening camera"
sfxinfo[ freeslot("sfx_mmcam1") ].caption = "Closing camera"

rawset(_G,"MMCAM",{})

MMCAM.Init = function(p)
	p.mmcam = {
		sequence = -1,
		cam = nil,
		fade = 0,
		
		left = 0,
		right = 0,
	}
end

MMCAM.StartViewing = function(p,cam)
	local mmc = p.mmcam
	
	p.awayviewmobj = cam
	p.awayviewtics = TICRATE
	p.awayviewaiming = cam.args.aiming
	
	mmc.sequence = cam.args.sequence
	mmc.cam = cam
	
	S_StartSound(nil,sfx_mmcam0,p)
end

MMCAM.StopViewing = function(p,cam)
	local mmc = p.mmcam
	
	cam.args.active = false
	cam.args.players[#p] = nil
	mmc.cam = nil
	p.awayviewmobj = nil
end

MMCAM.CAMS = {}
MMCAM.TOTALCAMS = {}
