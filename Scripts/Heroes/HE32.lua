-- HE32
-- Keck Merchant

return {
	name = "[HE32_NAME]";
	init_ship = "SSMT";
	faction = _G.FACTION_KECK;
	
	min_level = 1;
	max_level = 10;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 2;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I161";	
	item_2 = "I015";
	item_3 = "I011";
	item_4 = "I012";

	cargo_1_type = _G.CARGO_TEXTILES;
	cargo_2_type = _G.CARGO_LUXURIES;
	cargo_1_amount = 3;
	cargo_2_amount = 1;
}
