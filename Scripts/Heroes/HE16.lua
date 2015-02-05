-- HE16
-- Vortraag Cruiser

return {
	name = "[HE16_NAME]";
	init_ship = "SVHC";
	faction = _G.FACTION_VORTRAAG;
	
	min_level = 20;
	max_level = 40;
	
	base_pilot = 30;
	base_gunnery = 50;
	base_engineer = 9;
	base_science = 10;
	gain_pilot = 2;
	gain_gunnery = 2;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I159";	
	item_2 = "I126";
	item_3 = "I127";
	item_4 = "I128";
	item_5 = "I124";
	item_6 = "I129";
	item_6_min = 22;

	cargo_1_type = _G.CARGO_ALLOYS;
	cargo_1_amount = 1;
}
