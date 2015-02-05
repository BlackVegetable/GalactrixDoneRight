-- HE11
-- Cy-Tech Needle

return {
	name = "[HE11_NAME]";
	init_ship = "SCTN";
	faction = _G.FACTION_CYTECH;
	
	min_level = 10;
	max_level = 20;
	
	base_pilot = 10;
	base_gunnery = 10;
	base_engineer = 14;
	base_science = 15;
	gain_pilot = 0.5;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 2;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I152";	
	item_2 = "I068";
	item_3 = "I062";
	item_4 = "I067";
	item_5 = "I013";

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_2_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
	cargo_2_amount = 3;
}
