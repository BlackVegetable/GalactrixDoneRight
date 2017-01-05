-- ST1B
-- Trident Battleship Mk. II

return {

	model = "TridentBattleship";
	particle_offset = 50;

	weapons_rating = 47; --  +4 Weapons
	engine_rating = 31;
	cpu_rating = 26;
	max_items = 8;
	hull = 220; -- +20 Hull
	shield = 45; -- -5 Shields
	cargo_capacity = 2800; -- -200 Cargo

	cost = 1100000; -- +100,000 Cost

	max_speed = 40; -- -5 Speed
	turn_speed = 45;
	acceleration = 45;
	decceleration = 45;

	engines = 3;
	purchasable = 1;

	sound = "music_trident";
}
