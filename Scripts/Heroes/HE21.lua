-- HE21
-- Pirate Battlecruiser

return {
	name = "[HE21_NAME]";
	init_ship = "SPSS";
	faction = _G.FACTION_PIRATES;
	
	min_level = 30;
	max_level = 40;
	
	base_pilot = 50;
	base_gunnery = 80;
	base_engineer = 10;
	base_science = 9;
	gain_pilot = 1;
	gain_gunnery = 3;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I157";	
	item_2 = "I100";
	item_3 = "I097";
	item_4 = "I085";
	item_5 = "I064";
	item_6 = "I110";

	cargo_1_type = _G.CARGO_MINERALS;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 6;
	cargo_2_amount = 6;
}
