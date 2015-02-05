-- HE40
-- Gun Turrets

return {
	name = "[HE40_NAME]";
	init_ship = "SSGT";
	faction = _G.FACTION_NONE;
	
	min_level = 1;
	max_level = 50;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 0;
	gain_gunnery = 4;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 0;
	drop_item_plan = 16;
	
	item_1 = "I016";
	item_2 = "I015";
	item_3 = "I017";

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 2;
}
