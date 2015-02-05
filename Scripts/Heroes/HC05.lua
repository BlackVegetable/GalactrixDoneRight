-- HC05
-- Quesadan Seeker # 2

return {
	name = "[HC05_NAME]";
	init_ship = "SQLS";
	faction = _G.FACTION_QUESADANS;

	min_level = 32;
	max_level = 32;

	base_pilot = 81;
	base_gunnery = 21;
	base_engineer = 36;
	base_science = 21;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 20;

	item_1 = "I011";
	item_2 = "I006";
	item_3 = "I324";
	item_4 = "I155";
	item_5 = "I122";
	item_6 = "I075";
	item_6_min = 15;

	cargo_1_type = _G.CARGO_FOOD;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 3;
	cargo_2_amount = 4;
}
