-- HC10
-- MRI Veteran Psionics Array

return {
	name = "[HC10_NAME]";
	init_ship = "SMPA";
	faction = _G.FACTION_MRI;

	min_level = 50;
	max_level = 50;

	base_pilot = 116;
	base_gunnery = 49;
	base_engineer = 55;
	base_science = 133;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I151";
	item_2 = "I314";
	item_3 = "I318";
	item_4 = "I027";
	item_5 = "I107";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
}
