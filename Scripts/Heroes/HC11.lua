-- HC11
-- MRI Captain

return {
	name = "[HC11_NAME]";
	init_ship = "SMRM";
	faction = _G.FACTION_MRI;

	min_level = 50;
	max_level = 50;

	base_pilot = 91;
	base_gunnery = 41;
	base_engineer = 131;
	base_science = 151;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I151";
	item_2 = "I106";
	item_3 = "I103";
	item_4 = "I028";
	item_5 = "I026";
	item_6 = "I082";
	item_7 = "I064";
	item_8 = "I085";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 4;
}
