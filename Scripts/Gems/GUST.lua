
local function transform(battleground, player, obj, hex)
	_G.Hero.biohazardMatches = _G.Hero.biohazardMatches + 1
end

local function gem_match(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GBLX")
end

return {
	sound = "snd_gemimplosion";
	particle = "BlackExplosion";
	effect = "biohazard";
	amount = 1;
	id = 29;
	sprite = "ZGUC";
	
	font = "";
	matchable = 1;
	swapable = 0;
	Transform = transform;
	GemMatch = { [29]="GUST"};
}