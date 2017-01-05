-- HC01
-- Marked Pirate

return {
	name = "[HC01_NAME]";
	init_ship = "STDS";
	faction = _G.FACTION_PIRATES;
	portrait = "img_CLOR";

	min_level = 10;
	max_level = 15;

	base_pilot = 10;
	base_gunnery = 37;
	base_engineer = 5;
	base_science = 5;
	gain_pilot = 1;
	gain_gunnery = 3;
	gain_engineer = 0.5;
	gain_science = 0.5;

	drop_ship_plan = 10;
	drop_item_plan = 12;

	item_1 = "I157";
	item_2 = "I100";
	item_3 = "I314";
	item_3_min = 6;

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 2;
	cargo_2_amount = 2;
}
