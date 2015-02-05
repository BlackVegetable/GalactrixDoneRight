-- HC07
-- Trident Patrol Vessel

return {
	name = "[HC07_NAME]";
	init_ship = "STWS";
	faction = _G.FACTION_TRIDENT;

	min_level = 40;
	max_level = 40;

	base_pilot = 50;
	base_gunnery = 72;
	base_engineer = 47;
	base_science = 30;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 14;

	item_1 = "I075";
	item_2 = "I130";
	item_3 = "I122";
	item_4 = "I128";
	item_4_min = 15;

	cargo_1_type = _G.CARGO_LUXURIES;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 3;
	cargo_2_amount = 3;
}
