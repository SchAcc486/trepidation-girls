class_name Slenderman
extends CharacterBody3D
enum State
{
	IDLING, ##forest, teleports when player close and when stares for too long, non-aggresive, flashlight wonky when player close.
	SCARING, ##forest, teleports in front of player third person, snaps player look first person, slowly drifts to player.
	TAKING, ##potholes spawn, trap player button mash escape, slenderman moves slowly towards player.
	BLINDING, ##blinds player, slowness, plays audio cues/footsteps around player.
	HIDING ##daytime, keeps distance from player, out of sight, no hurt, focusing makes teleport.
}
static var state := State.IDLING;
static var camerashy := 0.0;
var can_spawn := true;
var teleport_count := 0;
static var rage_mode := false;
static var should_random_spawn := false;
var slenderman_rage_timer := 0.0;
var stinger := [
	preload("res://sounds/Horror2.ogg"),
	preload("res://sounds/Horror14.ogg")
	];

func _ready():
	random_spawn(Globals.player_position);
	await get_tree().create_timer(240.0).timeout;
	teleport_count += 5;
	$RandomSpawn.start();

func _process(delta: float) -> void:
	if Globals.game_paused:
		return;
	Globals.slenderman_position = global_position;
	if not $"../../Assets/InnerFence".has_overlapping_bodies():
		random_spawn(Vector3.ZERO);
	if should_random_spawn:
		random_spawn(Vector3.ZERO);
		should_random_spawn = false;
	if rage_mode == true:
		$DisappearingHatTrick/Hitbox.shape.radius = 2.0;
		if $EvilTeleportation.is_stopped():
			$EvilTeleportation.start();
		slenderman_rage_timer += delta;
		if $SFX/CameraStinger.playing == false and slenderman_rage_timer <= 1.0:
			$SFX/CameraStinger.playing = true;
	if camerashy >= 60.0:
		random_spawn(Globals.player_position);

## when does slenderman teleport
func _on_spawntimer_timeout() -> void:
	can_spawn = true;
	visible = true;

## makes slenderman teleport
func random_spawn(origin):
	var direction = randf_range(-PI, PI);
	var SIN = sin(direction) * 100;
	var COS = cos(direction) * 100;
	$SFX/Static.pitch_scale = randf();
	global_position.y = 0.0;
	global_position.x = origin.x + SIN;
	global_position.z = origin.z + COS;
	can_spawn = false;
	teleport_count += 1;
	if teleport_count > 5:
		$RandomSpawn.start();
		print($RandomSpawn);

## Causes slenderman to translate his transform to directly in front of the position of which the player is in possession of as well as making sure the camera has a direction that is oriented to face the new location of slenderman
func slenderman_teleport_near_player(dist: float) -> void:
	var direction = CameraController.get_camera().rotation.y + PI;
	var SIN = sin(direction) * dist;
	var COS = cos(direction) * dist;
	
	global_position = Globals.player_position;
	global_position.y = 0.0;
	global_position.x += SIN;
	global_position.z += COS;

## when player gets in certain range, slenderman teleports away
func _on_disappearing_hat_trick_body_entered(_body: Node3D) -> void:
	$SFX/TeleportSound.play();
	$SpawnTimer.start();
	can_spawn = false;
	visible = false;
	random_spawn(Globals.player_position);
	Globals.death_message = "they say a being as tall as the trees stalks in this forest";
	Globals.player_health -= 10.0;

## basically makes slenderman teleport randomly
func _on_randomspawn_timeout() -> void:
	$RandomSpawn.wait_time = randf_range(60.0, 240.0);
	random_spawn(Globals.player_position);

## slenderman teleports to the player in rage mode
func _on_evil_teleportation_timeout() -> void:
	Globals.death_message = "they say a being as tall as the trees stalks in this forest";
	$EvilTeleportation.wait_time = randf_range(5.0, 10.0);
	slenderman_teleport_near_player(randf_range(2.3, 5.0));
	$SFX/StingerSound.stream = stinger.pick_random();
	$SFX/StingerSound.playing = true;
	await get_tree().create_timer(1.0).timeout;
	random_spawn(Globals.player_position);

## makes sure slenderman can't teleport outside of map
func _on_inner_fence_body_exited(_body: Node3D) -> void:
	random_spawn(Globals.player_position);
