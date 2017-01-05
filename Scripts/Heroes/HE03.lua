-- HE03
-- Pirate Fighter

return {
	name = "[HE03_NAME]";
	init_ship = "STDS";
	faction = _G.FACTION_PIRATES;
	portrait = "img_CLOR";
	
	min_level = 1;
	max_level = 12;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1;
	gain_gunnery = 3;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I157";	
	item_2 = "I100";
	item_3 = "I021";
	item_3_min = 5;

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 1;
	cargo_2_amount = 2;
}
