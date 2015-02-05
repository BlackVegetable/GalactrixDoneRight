-- HE05
-- Cy-Tech Botship

return {
	name = "[HE05_NAME]";
	init_ship = "SCBS";
	faction = _G.FACTION_CYTECH;
	
	min_level = 1;
	max_level = 10;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 1.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I152";	
	item_2 = "I015";
	item_3 = "I070";
	item_4 = "I061";
	item_4_min = 5;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
