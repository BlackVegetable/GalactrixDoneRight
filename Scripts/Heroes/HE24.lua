-- HE24
-- MRI Mindship

return {
	name = "[HE24_NAME]";
	init_ship = "SMRM";
	faction = _G.FACTION_MRI;
	
	min_level = 40;
	max_level = 50;
	
	base_pilot = 39;
	base_gunnery = 40;
	base_engineer = 40;
	base_science = 80;
	gain_pilot = 1;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 2;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I151";	
	item_2 = "I106";
	item_3 = "I103";
	item_4 = "I028";
	item_5 = "I026";
	item_6 = "I082";
	item_7 = "I064";
	item_8 = "I085";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 1;
}
