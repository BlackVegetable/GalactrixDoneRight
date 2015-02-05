-- HE38
-- Copy of HE38 - Unidentified Vessel - without portrait for early quest(Q014) when nothing is known of the soulless

return {
	name = "[HE38_NAME]";
	init_ship = "SSWS";
	faction = _G.FACTION_SOULLESS;
	
	min_level = 20;
	max_level = 30;
	
	base_pilot = 25;
	base_gunnery = 24;
	base_engineer = 25;
	base_science = 25;
	gain_pilot = 1.5;
	gain_gunnery = 1;
	gain_engineer = 1;
	gain_science = 1.5;
	
	drop_ship_plan = 0;
	drop_item_plan = 0;

	item_1 = "I156";	
	item_2 = "I016";
	item_3 = "I101";
	item_4 = "I113";
	item_5 = "I084";
	item_6 = "I124";

	cargo_1_type = _G.CARGO_CONTRABAND;
	cargo_1_amount = 2;
}
