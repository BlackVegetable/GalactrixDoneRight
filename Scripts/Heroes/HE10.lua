-- HE10
-- MRI Psionics Array

return {
	name = "[HE10_NAME]";
	init_ship = "SMPA";
	faction = _G.FACTION_MRI;
	
	min_level = 10;
	max_level = 30;
	
	base_pilot = 16;
	base_gunnery = 8;
	base_engineer = 5;
	base_science = 20;
	gain_pilot = 2;
	gain_gunnery = 0.5;
	gain_engineer = 0.5;
	gain_science = 2;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I151";	
	item_2 = "I017";
	item_3 = "I026";
	item_4 = "I027";
	item_5 = "I013";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 1;
}
