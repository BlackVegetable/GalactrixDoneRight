-- HC04
-- Quesadan Seeker # 1

return {
	name = "[HC04_NAME]";
	init_ship = "SQLS";
	faction = _G.FACTION_QUESADANS;

	min_level = 30;
	max_level = 30;

	base_pilot = 81;
	base_gunnery = 21;
	base_engineer = 26;
	base_science = 21;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 22;

	item_1 = "I011";
	item_2 = "I006";
	item_3 = "I323";
	item_4 = "I155";
	item_5 = "I122";
	item_6 = "I075";
	item_6_min = 15;

	cargo_1_type = _G.CARGO_FOOD;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 4;
	cargo_2_amount = 3;
}
