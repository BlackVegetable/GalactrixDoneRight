-- HE35
-- Plasmid Shuttle

return {
	name = "[HE35_NAME]";
	init_ship = "SSMT";
	faction = _G.FACTION_PLASMIDS;
	
	min_level = 1;
	max_level = 25;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 2;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;
	
	item_1 = "I015";
	item_2 = "I020";
	item_3 = "I021";

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_1_amount = 2;
}
