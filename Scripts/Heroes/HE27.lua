-- HE27
-- Soulless Dreadnaught

return {
	name = "[HE27_NAME]";
	init_ship = "SSHC";
	faction = _G.FACTION_SOULLESS;
	portrait = "img_CSOUL";
	
	min_level = 40;
	max_level = 50;
	
	base_pilot = 50;
	base_gunnery = 49;
	base_engineer = 50;
	base_science = 50;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I156";	
	item_2 = "I060";
	item_3 = "I062";
	item_4 = "I113";
	item_5 = "I101";
	item_6 = "I020";
	item_7 = "I001";
	item_8 = "I009";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 3;
}
