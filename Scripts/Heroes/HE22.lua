-- HE22
-- Quesadan Lightship

return {
	name = "[HE22_NAME]";
	init_ship = "SQLS";
	faction = _G.FACTION_QUESADANS;
	
	min_level = 30;
	max_level = 42;
	
	base_pilot = 40;
	base_gunnery = 9;
	base_engineer = 50;
	base_science = 50;
	gain_pilot = 1.5;
	gain_gunnery = 0.5;
	gain_engineer = 1.5;
	gain_science = 1.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I155";	
	item_2 = "I004";
	item_3 = "I068";
	item_4 = "I070";
	item_5 = "I122";
	item_6 = "I013";
	item_7 = "I014";

	cargo_1_type = _G.CARGO_GEMS;
	cargo_2_type = _G.CARGO_GOLD;
	cargo_1_amount = 3;
	cargo_2_amount = 3;
}
