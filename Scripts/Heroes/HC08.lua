-- HC08
-- Trident Investigator

return {
	name = "[HC08_NAME]";
	init_ship = "STWS";
	faction = _G.FACTION_TRIDENT;

	min_level = 41;
	max_level = 41;

	base_pilot = 51;
	base_gunnery = 67;
	base_engineer = 60;
	base_science = 26;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 14;

	item_1 = "I130";
	item_2 = "I122";
	item_3 = "I116";
	item_4 = "I332";
	item_4_min = 15;

	cargo_1_type = _G.CARGO_LUXURIES;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 4;
}
