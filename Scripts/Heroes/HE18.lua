-- HE18
-- Degani Hauler

return {
	name = "[HE18_NAME]";
	init_ship = "SSHL";
	faction = _G.FACTION_DEGANI;
	
	min_level = 30;
	max_level = 40;
	
	base_pilot = 78;
	base_gunnery = 20;
	base_engineer = 30;
	base_science = 21;
	gain_pilot = 2;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;
	
	item_1 = "I083";
	item_2 = "I020";
	item_3 = "I015";
	item_4 = "I089";
	item_5 = "I108";
	item_6 = "I075";
	item_6_min = 34;

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_1_amount = 3;
}
