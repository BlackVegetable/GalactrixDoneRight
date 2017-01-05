-------------------------------------------------------------------------------
--
--   InitGridPlatform.lua
--
--		Code to hand back some initialized tables with platform-specific values
--
-------------------------------------------------------------------------------


local function InitAdjacent()

    local grid = {}
    
	grid[-1] =   {-1,-1,-1,-1,-1,-1}
	grid[1] =    {-1, 5, 6, 2,-1,-1}
	grid[2] =    { 1, 6, 7, 3,-1,-1}
	grid[3] =    { 2, 7, 8,-1,-1,-1}

	grid[4] =    {-1,10,11, 5,-1,-1}
	grid[5] =    { 4,11,12, 6, 1,-1}
	grid[6] =    { 5,12,13, 7, 2, 1}
	grid[7] =    { 6,13,14, 8, 3, 2}
	grid[8] =    { 7,14,15, 9,-1, 3}
	grid[9] =    { 8,15,16,-1,-1,-1}

	grid[10] =  {-1,17,18,11, 4,-1}
	grid[11] =  {10,18,19,12, 5, 4}
	grid[12] =  {11,19,20,13, 6, 5}
	grid[13] =  {12,20,21,14, 7, 6}
	grid[14] =  {13,21,22,15, 8, 7}
	grid[15] =  {14,22,23,16, 9, 8}
	grid[16] =  {15,23,24,-1,-1, 9}

	grid[17] =  {-1,-1,25,18,10,-1}
	grid[18] =  {17,25,26,19,11,10}
	grid[19] =  {18,26,27,20,12,11}
	grid[20] =  {19,27,28,21,13,12}
	grid[21] =  {20,28,29,22,14,13}
	grid[22] =  {21,29,30,23,15,14}
	grid[23] =  {22,30,31,24,16,15}
	grid[24] =  {23,31,-1,-1,-1,16}

	grid[25] =  {-1,32,33,26,18,17}
	grid[26] =  {25,33,34,27,19,18}
	grid[27] =  {26,34,35,28,20,19}
	grid[28] =  {27,35,36,29,21,20}
	grid[29] =  {28,36,37,30,22,21}
	grid[30] =  {29,37,38,31,23,22}
	grid[31] =  {30,38,39,-1,24,23}

	grid[32] =  {-1,-1,40,33,25,-1}
	grid[33] =  {32,40,41,34,26,25}
	grid[34] =  {33,41,42,35,27,26}
	grid[35] =  {34,42,43,36,28,27}
	grid[36] =  {35,43,44,37,29,28}
	grid[37] =  {36,44,45,38,30,29}
	grid[38] =  {37,45,46,39,31,30}
	grid[39] =  {38,46,-1,-1,-1,31}

	grid[40] =  {-1,-1,47,41,33,32}
	grid[41] =  {40,47,48,42,34,33}
	grid[42] =  {41,48,49,43,35,34}
	grid[43] =  {42,49,50,44,36,35}
	grid[44] =  {43,50,51,45,37,36}
	grid[45] =  {44,51,52,46,38,37}
	grid[46] =  {45,52,-1,-1,39,38}

	grid[47] =  {-1,-1,-1,48,41,40}
	grid[48] =  {47,-1,53,49,42,41}
	grid[49] =  {48,53,54,50,43,42}
	grid[50] =  {49,54,55,51,44,43}
	grid[51] =  {50,55,-1,52,45,44}
	grid[52] =  {51,-1,-1,-1,46,45}

	grid[53] =  {-1,-1,-1,54,49,48}
	grid[54] =  {53,-1,-1,55,50,49}
	grid[55] =  {54,-1,-1,-1,51,50}

    return grid
end
	
local function InitPoints()

 	local grid = {}
 	
	grid[-1] =  {0,0} 	 
	grid[1] =   {271,453}
	grid[2] =   {271,384}
	grid[3] =   {271,315}

	grid[4] =   {331,556}
	grid[5] =   {331,487}
	grid[6] =   {331,418}
	grid[7] =   {331,349}
	grid[8] =   {331,280}
	grid[9] =   {331,211}

	grid[10] =  {391,591}
	grid[11] =  {391,522}
	grid[12] =  {391,453}
	grid[13] =  {391,384}
	grid[14] =  {391,315}
	grid[15] =  {391,244}
	grid[16] =  {391,177}

	grid[17] =  {451,625}
	grid[18] =  {451,556}
	grid[19] =  {451,487}
	grid[20] =  {451,418}
	grid[21] =  {451,349}
	grid[22] =  {451,280}
	grid[23] =  {451,211}
	grid[24] =  {451,142}

	grid[25] =  {511,591}
	grid[26] =  {511,522}
	grid[27] =  {511,453}
	grid[28] =  {511,384}
	grid[29] =  {511,315}
	grid[30] =  {511,244}
	grid[31] =  {511,177}

	grid[32] =  {571,625}
	grid[33] =  {571,556}
	grid[34] =  {571,487}
	grid[35] =  {571,418}
	grid[36] =  {571,349}
	grid[37] =  {571,280}
	grid[38] =  {571,211}
	grid[39] =  {571,142}

	grid[40] =  {631,591}
	grid[41] =  {631,522}
	grid[42] =  {631,453}
	grid[43] =  {631,384}
	grid[44] =  {631,315}
	grid[45] =  {631,244}
	grid[46] =  {631,177}

	grid[47] =  {691,556}
	grid[48] =  {691,487}
	grid[49] =  {691,418}
	grid[50] =  {691,349}
	grid[51] =  {691,280}
	grid[52] =  {691,211}

	grid[53] =  {751,453}
	grid[54] =  {751,384}
	grid[55] =  {751,315}

 	return grid
end
	
local function InitBlackHole()

	local grid = {}
	
	grid[-1] = {-1,4}
	grid[1] =  {1,6}
	grid[2] =  {2,6}
	grid[3] =  {3,5}

	grid[4] =  {4,6}
	grid[5] =  {5,6}
	grid[6] =  {1,6}
	grid[7] =  {3,5}
	grid[8] =  {8,5}
	grid[9] =  {9,5}

	grid[10] = {10,1}
	grid[11] = {4,6}
	grid[12] = {5,6}
	grid[13] = {3,5}
	grid[14] = {8,5}
	grid[15] = {9,5}
	grid[16] = {16,4}

	grid[17] = {17,1}
	grid[18] = {17,1}
	grid[19] = {4,6}
	grid[20] = {5,6}
	grid[21] = {8,5}
	grid[22] = {9,5}
	grid[23] = {24,4}
	grid[24] = {24,4}

	grid[25] = {25,1}
	grid[26] = {25,1}
	grid[27] = {25,1}
	grid[28] = {25,4}
	grid[29] = {31,4}
	grid[30] = {31,4}
	grid[31] = {31,4}

	grid[32] = {32,1}
	grid[33] = {32,1}
	grid[34] = {47,2}
	grid[35] = {48,2}
	grid[36] = {51,3}
	grid[37] = {52,3}
	grid[38] = {39,4}
	grid[39] = {39,4}

	grid[40] = {40,1}
	grid[41] = {47,2}
	grid[42] = {48,2}
	grid[43] = {53,2}
	grid[44] = {51,3}
	grid[45] = {52,3}
	grid[46] = {46,4}

	grid[47] = {47,2}
	grid[48] = {48,2}
	grid[49] = {53,2}
	grid[50] = {55,3}
	grid[51] = {51,3}
	grid[52] = {52,3}

	grid[53] = {53,2}
	grid[54] = {54,3}
	grid[55] = {55,3}

	return grid
end
	
local function InitOddRow()
	local grid = {}
	
    grid[-1] = true
    grid[1] =  true
    grid[2] =  true
    grid[3] =  true

    grid[4] =  false
    grid[5] =  false
    grid[6] =  false
    grid[7] =  false
    grid[8] =  false
    grid[9] =  false

    grid[10] = true
    grid[11] = true
    grid[12] = true
    grid[13] = true
    grid[14] = true
    grid[15] = true
    grid[16] = true

    grid[17] = false
    grid[18] = false
    grid[19] = false
    grid[20] = false
    grid[21] = false
    grid[22] = false
    grid[23] = false
    grid[24] = false

    grid[25] = true
    grid[26] = true
    grid[27] = true
    grid[28] = true
    grid[29] = true
    grid[30] = true
    grid[31] = true

    grid[32] = false
    grid[33] = false
    grid[34] = false
    grid[35] = false
    grid[36] = false
    grid[37] = false
    grid[38] = false
    grid[39] = false

    grid[40] = true
    grid[41] = true
    grid[42] = true
    grid[43] = true
    grid[44] = true
    grid[45] = true
    grid[46] = true

    grid[47] = false
    grid[48] = false
    grid[49] = false
    grid[50] = false
    grid[51] = false
    grid[52] = false

    grid[53] = true
    grid[54] = true
    grid[55] = true

 	return grid
end


local INIT_GRID = 
{
	InitAdjacent  = InitAdjacent,
 	InitPoints    = InitPoints,
	InitBlackHole = InitBlackHole,
 	InitOddRow    = InitOddRow,

}

return INIT_GRID