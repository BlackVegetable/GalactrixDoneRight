-- HE09
-- Keck Tradeship

return {
	name = "[HE09_NAME]";
	init_ship = "SKTS";
	faction = _G.FACTION_KECK;

	min_level = 10;
	max_level = 40;

	base_pilot = 20;
	base_gunnery = 6;
	base_engineer = 18;
	base_science = 5;
	gain_pilot = 2;
	gain_gunnery = 0.5;
	gain_engineer = 2;
	gain_science = 0.5;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I161";
	item_2 = "I004";
	item_3 = "I011";
	item_4 = "I079";
	item_5 = "I032";

	cargo_1_type = _G.CARGO_TECH;
	cargo_2_type = _G.CARGO_LUXURIES;
	cargo_3_type = _G.CARGO_GEMS;
	cargo_1_amount = 4;
	cargo_2_amount = 2;
	cargo_3_amount = 1;
}
