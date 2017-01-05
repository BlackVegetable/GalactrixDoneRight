-- HC13
-- "Balanced" Erin

return {
	name = "[HC13_NAME]";
	init_ship = "SLHC";
	faction = _G.FACTION_LUMINA;

	min_level = 40;
	max_level = 40;

	base_pilot = 81;
	base_gunnery = 81;
	base_engineer = 16;
	base_science = 21;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 14;

	item_1 = "I316";
	item_2 = "I317";
	item_3 = "I143";
	item_4 = "I085";
	item_5 = "I123";
	item_5_min = 1;

	cargo_1_type = _G.CARGO_MINERALS;
	cargo_2_type = _G.CARGO_GOLD;
	cargo_1_amount = 4;
	cargo_2_amount = 1;
}
