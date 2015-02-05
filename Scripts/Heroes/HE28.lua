-- HE28
-- Luminary Archive

return {
	name = "[HE28_NAME]";
	init_ship = "SLAS";
	faction = _G.FACTION_LUMINA;
	boss = true;
	
	min_level = 50;
	max_level = 50;
	
	base_pilot = 20;
	base_gunnery = 22;
	base_engineer = 22;
	base_science = 135;
	gain_pilot = 1;
	gain_gunnery = 1.5;
	gain_engineer = 0.5;
	gain_science = 2;
	
	drop_ship_plan = 0;
	drop_item_plan = 16;

	item_1 = "I154";	
	item_2 = "I016";
	item_3 = "I061";
	item_4 = "I131";
	item_5 = "I055";
	item_6 = "I101";
	item_7 = "I042";
	item_8 = "I141";

	cargo_1_type = _G.CARGO_TECH;
	cargo_2_type = _G.CARGO_LUXURIES;
	cargo_1_amount = 8;
	cargo_2_amount = 2;
}
