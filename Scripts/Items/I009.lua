-- I009
-- Targeting HUD - Gives you the Targeting effect (+3 to all damage done) for 5 turns + 1 turn per 5 Red Energy you have

local function activate(item, world, player, obj,weapon,engine,cpu)
	local turns = 5 + math.floor(weapon/5)
	LOG("Targeting HUD "..tostring(turns))

	for i=1,player:NumAttributes("Effects") do
		if player:GetAttributeAt("Effects", i):GetAttribute("name") == "[FD08_NAME]" then
			local effect = player:GetAttributeAt("Effects",i)
			GameObjectManager:Destroy(effect)
			break
		end
	end

	item:AddEffect(world,player, "FD08", player, turns, item.classIDStr)
end

local function should_ai_use_item(item, world, player)
	-- use when there are lots of damage gems on the board
	local value = #world:GetGemList("GDMG")
	value = value + #world:GetGemList("GDM3",gemList)*2
	value = value + #world:GetGemList("GDM5",gemList)*4
	value = value + #world:GetGemList("GDMX",gemList)*6

	local numEffects = player:NumAttributes("Effects")
	for i=1,numEffects do
		if player:GetAttributeAt("Effects",i).classIDStr=="FD08" then
			return 1
		end
	end


	return math.min(90, math.floor(value * 5))
end

return {  psi_requirement = 0;


	icon = "img_ICC3";
	weapon_requirement = 4;
	engine_requirement = 0;
	cpu_requirement = 6;
	recharge = 4;
	rarity = 9;
	cost = 1200;
	status_on_enemy = 0;

	end_turn = 1;  passive = 0;
	user_input = 0;

	activation_sound = "snd_distortion";
	recharged_sound = "snd_recharge";

	Activate = activate;
	ShouldAIUseItem = should_ai_use_item;
}
