-- HC15
-- "Shotgun Jimmy"

return {
	name = "[HC15_NAME]";
	init_ship = "SPWS";
	faction = _G.FACTION_PIRATES;

	min_level = 46;
	max_level = 46;

	base_pilot = 81;
	base_gunnery = 66;
	base_engineer = 46;
	base_science = 26;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 12;
	drop_item_plan = 14;

	item_1 = "I332";
	item_2 = "I116";
	item_3 = "I317";
	item_3_min = 1;

	cargo_1_type = _G.CARGO_MINERALS;
	cargo_2_type = _G.CARGO_GEMS;
	cargo_1_amount = 2;
	cargo_2_amount = 1;
}
