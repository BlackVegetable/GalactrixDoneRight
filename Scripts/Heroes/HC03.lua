-- HC03
-- Cy-Tech Vagabond

return {
	name = "[HC03_NAME]";
	init_ship = "SCBS";
	faction = _G.FACTION_CYTECH;

	min_level = 23;
	max_level = 23;

	base_pilot = 41;
	base_gunnery = 31;
	base_engineer = 41;
	base_science = 1;
	gain_pilot = 0;
	gain_gunnery = 0;
	gain_engineer = 0;
	gain_science = 0;

	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I001";
	item_2 = "I015";
	item_3 = "I118";
	item_4 = "I061";
	item_4_min = 10;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
