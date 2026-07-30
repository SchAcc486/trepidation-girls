class_name Slenderman
extends CharacterBody3D
var can_spawn := true;
var teleport_count := 0;
static var rage_mode := false;
static var should_random_spawn := false;

func _ready():
	random_spawn(Globals.player_position);

func _process(delta: float) -> void:
	if Globals.game_paused:
		return;
	Globals.slenderman_position = global_position;
	if $forbidden_area.has_overlapping_areas():
		random_spawn(Vector3.ZERO);
	if should_random_spawn:
		random_spawn(Vector3.ZERO);
		should_random_spawn = false;

func _on_spawntimer_timeout() -> void:
	can_spawn = true;
	visible = true;

func random_spawn(origin):
	var direction = randf_range(-PI, PI);
	var SIN = sin(direction) * 100;
	var COS = cos(direction) * 100;
	$static.pitch_scale = randf();
	global_position.y = 0.0;
	global_position.x = origin.x + SIN;
	global_position.z = origin.z + COS;
	can_spawn = false;
	teleport_count += 1;
	if teleport_count > 5:
		$randomspawn.start();

func _on_disappearing_hat_trick_body_entered(_body: Node3D) -> void:
	$spawntimer.start();
	can_spawn = false;
	visible = false;
	random_spawn(Globals.player_position);


func _on_forbidden_area_area_entered(area: Area3D) -> void:
	random_spawn(Globals.player_position);


func _on_randomspawn_timeout() -> void:
	$randomspawn.wait_time = randf_range(20.0, 60.0);
	random_spawn(Globals.player_position);
