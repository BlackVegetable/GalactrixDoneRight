-- HC16
-- "Stat-kill"

return {
	name = "[HC16_NAME]";
	init_ship = "SDMS";
	faction = _G.FACTION_DEGANI;

	min_level = 48;
	max_level = 48;

	base_pilot = 51;
	base_gunnery = 76;
	base_engineer = 56;
	base_science = 46;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 12;
	drop_item_plan = 14;

	item_1 = "I314";
	item_2 = "I010";
	item_3 = "I022";
	item_4 = "I096";
	item_5 = "I310";
	item_5_min = 1;

	cargo_1_type = _G.CARGO_LUXURIES;
	cargo_2_type = _G.CARGO_GEMS;
	cargo_1_amount = 2;
	cargo_2_amount = 1;
}
