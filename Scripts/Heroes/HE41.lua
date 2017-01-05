-- HE41
-- Damaged Science Station

return {
	name = "[HE41_NAME]";
	init_ship = "SMTN";
	faction = _G.FACTION_MRI;
	
	min_level = 1;
	max_level = 20;
	
	base_pilot = 1;
	base_gunnery = 1;
	base_engineer = 1;
	base_science = 1;
	gain_pilot = 1;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 2;
	
	drop_ship_plan = 0;
	drop_item_plan = 16;
	
	item_1 = "I035";
	item_2 = "I036";
	item_3 = "I107";
	item_4 = "I115";
	item_5 = "I082";

	cargo_1_type = _G.CARGO_TECH;
	cargo_2_type = _G.CARGO_MEDICINE;
	cargo_1_amount = 4;
	cargo_2_amount = 2;
}
