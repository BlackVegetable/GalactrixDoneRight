-- HE20
-- Jahrwoxi Homeship

return {
	name = "[HE20_NAME]";
	init_ship = "SJHS";
	faction = _G.FACTION_JAHRWOXI;
	
	min_level = 30;
	max_level = 40;
	
	base_pilot = 40;
	base_gunnery = 34;
	base_engineer = 48;
	base_science = 27;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1.5;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I158";	
	item_2 = "I005";
	item_3 = "I015";
	item_4 = "I034";
	item_5 = "I075";
	item_6 = "I014";
	item_7 = "I010";

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_2_type = _G.CARGO_GEMS;
	cargo_1_amount = 4;
	cargo_2_amount = 1;
}
