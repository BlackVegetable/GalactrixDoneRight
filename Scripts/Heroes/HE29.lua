-- HE29
-- Trident Battleship

return {
	name = "[HE29_NAME]";
	init_ship = "STBS";
	faction = _G.FACTION_TRIDENT;
	
	min_level = 50;
	max_level = 50;
	
	base_pilot = 50;
	base_gunnery = 100;
	base_engineer = 25;
	base_science = 24;
	gain_pilot = 1.5;
	gain_gunnery = 2.5;
	gain_engineer = 0.5;
	gain_science = 0.5;
	
	drop_ship_plan = 10;
	drop_item_plan = 16;

	item_1 = "I153";	
	item_2 = "I130";
	item_3 = "I116";
	item_4 = "I030";
	item_5 = "I086";
	item_6 = "I053";
	item_7 = "I036";
	item_8 = "I040";

	cargo_1_type = _G.CARGO_TECH;
	cargo_1_amount = 4;
}
