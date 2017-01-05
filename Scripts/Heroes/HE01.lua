-- HE01
-- MRI Blade

return {
	name = "[HE01_NAME]";
	init_ship = "SMBL";
	faction = _G.FACTION_MRI;
	
	min_level = 1;
	max_level = 10;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 2;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I151";	
	item_2 = "I015";
	item_3 = "I026";
	item_4 = "I027";
	item_4_min = 6;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 3;
	cargo_2_amount = 2;
}
