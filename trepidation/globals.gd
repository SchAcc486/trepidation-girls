extends Node;

##item list
enum Item
{
	DOWSING_ROD,
	RADAR,
	COMPASS,
	POLAROID_PACK,
	BATTERY
};
var item_list := [Item.DOWSING_ROD, Item.RADAR, Item.COMPASS, Item.POLAROID_PACK, Item.BATTERY];

var objectives := "";
var sfx_volume := -5.0;
var game_paused := false;
var gamma := 1.0;
var death_message := "DEATH BE UPON YE";
var polaroids := 0;
var picture_taken := 0;
var picture_variant_taken := 0;
var shop = false;
var money = 30.0;
var title_screen = true;

var player_position := Vector3.ZERO;
var player_rotation := Vector3.ZERO;
var slenderman_position := Vector3.ZERO;
var crouch_toggle = false;
var sprint_toggle = false;
var player_health : float = 100.0:
	get():
		return player_health;
	set(value):
		player_health_changed = value - player_health;
		player_health = value;
		player_health = clampf(player_health, 0.0, 100.0);
var player_health_changed : float = 0.0;
var player_sprint: float = 100.0:
	get():
		return player_sprint;
	set(value):
		player_sprint = value;
		player_sprint = clampf(player_sprint, 0.0, 100.0);

func _ready() -> void:
	ReloadScene.connect("reload_signal", reload);

func reload():
	player_health = 100.0;
	player_sprint = 100.0;
