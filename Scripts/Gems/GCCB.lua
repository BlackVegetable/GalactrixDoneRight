local function gem_match(battleground, player, obj, hex)
	if battleground.lastSwap[1] == hex or battleground.lastSwap[2] == hex then
		battleground:SpawnGem(hex, "GCPC")
	end
end

local function transform(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GCPC")
end

return {
	sound = "snd_craft3";
	particle = "GreenExplosion";
	effect = "cpu_base";
	amount = 1;
	classIDStr = "GCPB";
	id = 2;
	sprite = "ZGBC";
	color = "green";
	
	font = "";	
	matchable = 1;
	swapable = 1;
	Transform = transform;
	GemMatch = { [2]="GCCB"};
}