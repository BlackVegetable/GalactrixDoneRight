local function transform(battleground, player, obj, hex)
	battleground:SpawnGem(hex, "GENC")
end

return {
	sound = "snd_gemyellow";
	particle = "YellowExplosion";
	beam = "BM05";
	effect = "yellow";
	amount = 1;
	id = 1;
	sprite = "ZGG3";
	color = "yellow";
	
	path = "YellowPath";
	font = "";	
	matchable = 1;
	swapable = 1;		
	Transform = transform;
	GemMatch = { [1]="GENB"};
}