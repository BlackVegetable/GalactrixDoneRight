-- HE23
-- Trident Gunship

return {
	name = "[HE23_NAME]";
	init_ship = "STDG";
	faction = _G.FACTION_TRIDENT;
	
	min_level = 30;
	max_level = 45;
	
	base_pilot = 39;
	base_gunnery = 72;
	base_engineer = 20;
	base_science = 18;
	gain_pilot = 1.5;
	gain_gunnery = 2.5;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I153";	
	item_2 = "I130";
	item_3 = "I116";
	item_4 = "I071";
	item_5 = "I030";
	item_6 = "I001";
	item_7 = "I120";
	item_7_min = 35;

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 1;
}
