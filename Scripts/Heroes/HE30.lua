-- HE30
-- Gamma Sphere

return {
	name = "[HE30_NAME]";
	init_ship = "SSGS";
	faction = _G.FACTION_SOULLESS;
	portrait = "img_CGAM";
	boss = true;
	
	min_level = 50;
	max_level = 50;
	
	base_pilot = 65;
	base_gunnery = 60;
	base_engineer = 62;
	base_science = 62;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1.5;
	
	drop_ship_plan = 100;
	drop_item_plan = 16;

	item_1 = "I156";	
	item_2 = "I132";
	item_3 = "I122";
	item_4 = "I107";
	item_5 = "I073";
	item_6 = "I060";
	item_7 = "I031";
	item_8 = "I009";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 5;
}
