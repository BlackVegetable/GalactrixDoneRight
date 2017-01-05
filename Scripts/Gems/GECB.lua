local function gem_match(battleground, player, obj, hex)
	if battleground.lastSwap[1] == hex or battleground.lastSwap[2] == hex then
		battleground:SpawnGem(hex, "GENC")
	end
end

local function transform(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GENC")
end

return {
	sound = "snd_craft2";
	particle = "YellowExplosion";
	effect = "engine_base";
	amount = 1;
	id = 1;
	sprite = "ZGBE";
	color = "yellow";
	
	font = "";	
	matchable = 1;
	swapable = 1;		
	Transform = transform;
	GemMatch = { [1]="GECB"};
}