-- HE04
-- Pirate Miner

return {
	name = "[HE04_NAME]";
	init_ship = "SSMT";
	faction = _G.FACTION_PIRATES;
	portrait = "img_CLOR";

	min_level = 1;
	max_level = 10;

	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1.5;
	gain_gunnery = 2;
	gain_engineer = 1;
	gain_science = 0.5;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I157";
	item_2 = "I098";
	item_3 = "I099";
	item_4 = "I089";
	item_4_min = 5;

	cargo_1_type = _G.CARGO_MINERALS;
	cargo_2_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 6;
	cargo_2_amount = 4;
}
