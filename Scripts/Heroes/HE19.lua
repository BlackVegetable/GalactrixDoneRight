-- HE19
-- MRI Science Station

return {
	name = "[HE19_NAME]";
	init_ship = "SMTN";
	faction = _G.FACTION_MRI;
	
	min_level = 30;
	max_level = 40;
	
	base_pilot = 25;
	base_gunnery = 25;
	base_engineer = 25;
	base_science = 74;
	gain_pilot = 1;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 2;
	
	drop_ship_plan = 0;
	drop_item_plan = 16;

	item_1 = "I151";	
	item_2 = "I035";
	item_3 = "I036";
	item_4 = "I107";
	item_5 = "I115";
	item_6 = "I082";
	item_7 = "I032";
	item_7_min = 35;

	cargo_1_type = _G.CARGO_TECH;
	cargo_2_type = _G.CARGO_MEDICINE;
	cargo_1_amount = 4;
	cargo_2_amount = 2;
}
