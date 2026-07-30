extends CharacterBody3D
# green aura and flies

var speed := 15;

func _ready() -> void:
	trigger_jeff_sfx();
	velocity.y += 100;
	pass;

func trigger_jeff_sfx() -> void:
	await get_tree().create_timer(randf() * 3).timeout;
	#await $"sound effect".finished;
	$"sound effect".play();
	trigger_jeff_sfx();

func _on_audio_stream_player_3d_finished() -> void:
	#$"sound effect".play();
	pass;

func _process(delta: float) -> void:
	look_at_player();
	var dir := global_position.direction_to(Globals.player_position);
	dir *= speed;
	velocity.x = move_toward(velocity.x, dir.x, 60*delta);
	velocity.z = move_toward(velocity.z, dir.z, 60*delta);
	move_and_slide();
	var distance := global_position.distance_to(Globals.player_position);
	$"sound effect".pitch_scale = 5.0 / (distance + 0.2) + 0.5;
	if not is_on_floor():
		velocity += get_gravity() * delta;

func look_at_player():
	var diff := Globals.player_position - self.global_position;
	var target_direction := atan2(diff.x, diff.z);
	rotation.y = target_direction;


func _on_touchregion_body_entered(body: Node3D) -> void:
	Globals.player_health -= 10;
