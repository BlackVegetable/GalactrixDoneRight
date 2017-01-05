-- HC06
-- Pirate Minelayer

return {
	name = "[HC06_NAME]";
	init_ship = "SPSS";
	faction = _G.FACTION_PIRATES;

	min_level = 32;
	max_level = 32;

	base_pilot = 31;
	base_gunnery = 51;
	base_engineer = 56;
	base_science = 21;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 14;

	item_1 = "I125";
	item_2 = "I113";
	item_3 = "I112";
	item_4 = "I127";
	item_5 = "I063";
	item_6 = "I328";
	item_6_min = 21;

	cargo_1_type = _G.CARGO_GOLD;
	cargo_2_type = _G.CARGO_CONTRABAND;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
