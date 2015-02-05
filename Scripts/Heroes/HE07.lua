-- HE07
-- Lumina Warship

return {
	name = "[HE07_NAME]";
	init_ship = "SLWS";
	faction = _G.FACTION_LUMINA;
	
	min_level = 5;
	max_level = 20;
	
	base_pilot = 6;
	base_gunnery = 10;
	base_engineer = 2;
	base_science = 6;
	gain_pilot = 1;
	gain_gunnery = 2;
	gain_engineer = 0.5;
	gain_science = 1.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I154";	
	item_2 = "I100";
	item_3 = "I096";
	item_4 = "I014";
	item_4_min = 8;

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 3;
	cargo_2_amount = 2;
}
