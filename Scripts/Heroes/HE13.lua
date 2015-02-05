-- HE13
-- Degani Marketship

return {
	name = "[HE13_NAME]";
	init_ship = "SDMS";
	faction = _G.FACTION_DEGANI;

	min_level = 20;
	max_level = 35;

	base_pilot = 40;
	base_gunnery = 18;
	base_engineer = 32;
	base_science = 9;
	gain_pilot = 2;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 0.5;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I125";
	item_2 = "I118";
	item_3 = "I314";
	item_4 = "I077";
	item_5 = "I021";
	item_5_min = 22;

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_1_amount = 2;
}
