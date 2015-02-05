-- HE17
-- Soulless Warship

return {
	name = "[HE17_NAME]";
	init_ship = "SSWS";
	faction = _G.FACTION_SOULLESS;
	portrait = "img_CSOUL";
	
	min_level = 20;
	max_level = 40;
	
	base_pilot = 25;
	base_gunnery = 24;
	base_engineer = 25;
	base_science = 25;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I156";	
	item_2 = "I016";
	item_3 = "I101";
	item_4 = "I113";
	item_5 = "I084";
	item_6 = "I124";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 2;
}
