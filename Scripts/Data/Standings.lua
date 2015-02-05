--[[
Faction Standing Range
CRIMINAL  	 (-50 or -100)	
SUSPECT   	 ( -10 to -49)
NEUTRAL 	(-9 to +9)
FRIENDLY	(+10 to +49)
ALLIED	(+50 or 100)
--]]

return {
	[_G.STANDING_CRIMINAL]	={cost=0.96,color="R",sprite="E",min_safe_distance=750};
	[_G.STANDING_SUSPECT]	={cost=0.98,color="R",sprite="E",min_safe_distance=450};
	[_G.STANDING_NEUTRAL]	={cost=1,	color="B",sprite="N",min_safe_distance=350};
	[_G.STANDING_FRIENDLY]	={cost=1.01,color="G",sprite="F",min_safe_distance=250};
	[_G.STANDING_ALLIED]		={cost=1.02,color="G",sprite="F",min_safe_distance=150};
}

