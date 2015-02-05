-- HC17

-- Right Enforcer

return {
	name = "[HC17_NAME]";
	init_ship = "SG1R";
	faction = _G.FACTION_TRIDENT;

	min_level = 40;
	max_level = 40;

	base_pilot = 1;
	base_gunnery = 180;
	base_engineer = 100;
	base_science = 1;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 0;
	drop_item_plan = 12;

	item_1 = "I325";
	item_2 = "I012";
	item_3 = "I080";
	item_4 = "I062";

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 2;
}
