local function transform(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GWEC")
end

return {
	sound = "snd_gemred";
	particle = "RedExplosion";
	effect = "red";
	beam = "BM08";
	amount = 1;
	id = 3;
	sprite = "ZGG1";
	color = "red";
	
	font = "";	
	matchable = 1;
	swapable = 1;
	Transform = transform;	
	GemMatch = { [3]="GWEB"};
}