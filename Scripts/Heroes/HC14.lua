-- HC14
-- "Doctor Horrible"

return {
	name = "[HC14_NAME]";
	init_ship = "SMRM";
	faction = _G.FACTION_MRI;

	min_level = 42;
	max_level = 42;

	base_pilot = 81;
	base_gunnery = 16;
	base_engineer = 26;
	base_science = 86;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 6;
	drop_item_plan = 14;

	item_1 = "I311";
	item_2 = "I124";
	item_3 = "I122";
	item_4 = "I093";
	item_5 = "I070";
	item_6 = "I014";
	item_7 = "I043";
	item_7_min = 1;

	cargo_1_type = _G.CARGO_TECH;
	cargo_2_type = _G.CARGO_GOLD;
	cargo_1_amount = 1;
	cargo_2_amount = 1;
}
