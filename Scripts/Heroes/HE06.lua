-- HE06
-- Pirate Warship

return {
	name = "[HE06_NAME]";
	init_ship = "SPWS";
	faction = _G.FACTION_PIRATES;
	
	min_level = 5;
	max_level = 30;
	
	base_pilot = 6;
	base_gunnery = 12;
	base_engineer = 3;
	base_science = 3;
	gain_pilot = 1;
	gain_gunnery = 3;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I157";	
	item_2 = "I016";
	item_3 = "I011";
	item_4 = "I012";
	item_4_min = 8;

	cargo_1_type = _G.CARGO_MINERALS;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 4;
	cargo_2_amount = 4;
}
