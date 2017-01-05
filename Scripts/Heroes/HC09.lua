-- HC09
-- MRI "Beta" Blade

return {
	name = "[HC09_NAME]";
	init_ship = "SM1B";
	faction = _G.FACTION_MRI;

	min_level = 43;
	max_level = 43;

	base_pilot = 61;
	base_gunnery = 41;
	base_engineer = 71;
	base_science = 41;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 99;
	drop_item_plan = 5;

	item_1 = "I320";
	item_2 = "I315";
	item_3 = "I319";
	item_3_min = 6;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
