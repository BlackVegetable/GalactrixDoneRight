-- HE12
-- Trident Warship

return {
	name = "[HE12_NAME]";
	init_ship = "STWS";
	faction = _G.FACTION_TRIDENT;
	
	min_level = 10;
	max_level = 30;
	
	base_pilot = 14;
	base_gunnery = 22;
	base_engineer = 9;
	base_science = 4;
	gain_pilot = 1.5;
	gain_gunnery = 2.5;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I153";	
	item_2 = "I016";
	item_3 = "I012";
	item_4 = "I025";
	item_5 = "I090";
	item_5_min = 15;

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 1;
}
