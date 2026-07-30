extends Node;

var sfx_volume := -5.0;
var game_paused := false;
var gamma := 1.0;
var player_position := Vector3.ZERO;
var player_rotation := Vector3.ZERO;
var slenderman_position := Vector3.ZERO;
var player_health : float = 100.0:
	get():
		return player_health;
	set(value):
		player_health = value;
		player_health = clampf(player_health, 0.0, 100.0);
var player_sprint: float = 100.0:
	get():
		return player_sprint;
	set(value):
		player_sprint = value;
		player_sprint = clampf(player_sprint, 0.0, 100.0);
