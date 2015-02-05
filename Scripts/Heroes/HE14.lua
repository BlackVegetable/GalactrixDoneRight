-- HE14
-- Cy-Tech Missile Array

return {
	name = "[HE14_NAME]";
	init_ship = "SCMA";
	faction = _G.FACTION_CYTECH;
	
	min_level = 20;
	max_level = 45;
	
	base_pilot = 20;
	base_gunnery = 29;
	base_engineer = 20;
	base_science = 30;
	gain_pilot = 0.5;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 2;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I152";	
	item_2 = "I013";
	item_3 = "I117";
	item_4 = "I118";
	item_5 = "I119";
	item_6 = "I019";
	item_6_min = 22;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
