-- HC02
-- Skilled Pirate

return {
	name = "[HC02_NAME]";
	init_ship = "STDS";
	faction = _G.FACTION_PIRATES;
	portrait = "img_CLOR";

	min_level = 12;
	max_level = 15;

	base_pilot = 38;
	base_gunnery = 37;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1;
	gain_gunnery = 3;
	gain_engineer = 0.5;
	gain_science = 0.5;

	drop_ship_plan = 10;
	drop_item_plan = 12;

	item_1 = "I015";
	item_2 = "I012";
	item_3 = "I157";
	item_3_min = 6;

	cargo_1_type = _G.CARGO_GEMS;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 1;
	cargo_2_amount = 2;
}
