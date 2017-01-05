-- HE15
-- Lumina Cruiser

return {
	name = "[HE15_NAME]";
	init_ship = "SLHC";
	faction = _G.FACTION_LUMINA;

	min_level = 20;
	max_level = 45;

	base_pilot = 30;
	base_gunnery = 20;
	base_engineer = 9;
	base_science = 40;
	gain_pilot = 1;
	gain_gunnery = 1.5;
	gain_engineer = 0.5;
	gain_science = 2;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I154";
	item_2 = "I016";
	item_3 = "I313";
	item_4 = "I104";
	item_5 = "I310";
	item_5_min = 25;

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 1;
}
