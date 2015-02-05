-- HE36
-- Jahrwoxi Traveler

return {
	name = "[HE36_NAME]";
	init_ship = "STDS";
	faction = _G.FACTION_JAHRWOXI;
	
	min_level = 1;
	max_level = 10;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I158";	
	item_2 = "I015";
	item_3 = "I002";
	item_4 = "I001";

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_1_amount = 2;
}
