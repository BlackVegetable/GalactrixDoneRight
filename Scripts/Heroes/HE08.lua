-- HE08
-- Elysian Ferry

return {
	name = "[HE08_NAME]";
	init_ship = "SELF";
	faction = _G.FACTION_ELYSIA;
	
	min_level = 10;
	max_level = 35;
	
	base_pilot = 20;
	base_gunnery = 5;
	base_engineer = 15;
	base_science = 4;
	gain_pilot = 2;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I160";	
	item_2 = "I079";
	item_3 = "I070";
	item_4 = "I010";
	item_5 = "I090";

	cargo_1_type = _G.CARGO_LUXURIES;
	cargo_2_type = _G.CARGO_GEMS;
	cargo_1_amount = 5;
	cargo_2_amount = 2;
}
