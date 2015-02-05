-- HC12
-- MRI Command Center

return {
	name = "[HC12_NAME]";
	init_ship = "SMTN";
	faction = _G.FACTION_MRI;

	min_level = 50;
	max_level = 50;

	base_pilot = 50;
	base_gunnery = 50;
	base_engineer = 125;
	base_science = 220;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 0;
	drop_item_plan = 99;

	item_1 = "I327";
	item_2 = "I145";
	item_3 = "I131";
	item_4 = "I090";
	item_5 = "I087";
	item_6 = "I313";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 60;
}
