local function gem_match(battleground, player, obj, hex)
	if battleground.lastSwap[1] == hex or battleground.lastSwap[2] == hex then
		battleground:SpawnGem(hex, "GWEC")
	end
end

local function transform(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GWEC")
end

return {
	sound = "snd_craft1";
	particle = "RedExplosion";
	effect = "weapon_base";
	amount = 1;
	id = 3;
	sprite = "ZGBW";
	color = "red";
	
	font = "";	
	matchable = 1;
	swapable = 1;
	Transform = transform;	
	GemMatch = { [3]="GWCB"};
}