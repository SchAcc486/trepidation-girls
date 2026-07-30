class_name Player;
extends CharacterBody3D;

"""
	Larry is my wife <3
"""

const BASE_SPEED := 8.0;
const BASE_DECELERATION := 0.8;

var speed := BASE_SPEED;
var deceleration := BASE_DECELERATION;
var camera_direction := Vector3.ZERO;
var flashlight := false;
var picture_taken := 0;
var camera_usable := true;

static var crouching := false;
static var target_dir := 0.0;

func _ready() -> void:
	$footsteps.volume_db = -10.0;

func _process(delta):
	if Globals.game_paused:
		return;
	if Input.is_action_just_pressed("pause"):
		const scene = preload("res://UI/pausemenu_ui.tscn");
		var doinky = scene.instantiate() as CanvasLayer;
		add_sibling(doinky);
		Globals.game_paused = true;
		get_tree().paused = true;
	$texture.rotation.y = camera_direction.y;
	calculate_camerapos(delta);
	$flashlight/click.volume_db = Globals.sfx_volume;
	if Input.is_action_just_pressed("flashlight"):
		$flashlight/click.playing = true;
		if Slenderman.rage_mode:
			$flashlight/click.pitch_scale = 1.5;
			flashlight = false;
			pass;
		else:
			flashlight = !flashlight;
			$flashlight.visible = flashlight;
	if Input.is_action_just_pressed("take_picture") and CameraController.first_person and not flashlight and camera_usable:
		camera_usable = false;
		$camera_cooldown.start();
		$camera_flash_high/camera_shutter.playing = true;
		await get_tree().create_timer(0.36).timeout;
		$camera_flash.play("camera_flash");
		await get_tree().create_timer(0.15).timeout;
		picture_taken += 1;
		for body in $camera_flash_high/picture_radius.get_overlapping_bodies():
			if body is Slenderman:
				Slenderman.rage_mode = true;
				Slenderman.should_random_spawn = true;
		await get_tree().create_timer(0.15).timeout;
	if $camera_flash_high.visible == false:
		$camera_flash_high.rotation.y = Player.target_dir;

func set_look_direction() -> void:
	camera_direction = CameraController.get_camera_direction();
	$flashlight.rotation.y = Player.target_dir;
	$flashlight.rotation.x = camera_direction.x + PI / 8;
	
func player_movement(delta):
	speed = BASE_SPEED;
	var forward_dir := Input.get_axis("forwards", "backwards");
	if not CameraController.first_person:
		forward_dir += Input.get_axis("forwards_arrow", "backwards_arrow");
	forward_dir = sign(forward_dir);
	var sideways_dir := Input.get_axis("left", "right");
	var input_dir = Vector2(sideways_dir, forward_dir).normalized();
	if Input.is_action_pressed("crouch"):
		crouching = true;
		speed /= 2;
		var modifier := CameraController.FovModifier.new();
		var power := 0.0;
		if CameraController.fov_modifiers.has("crouch"):
			power = CameraController.fov_modifiers.get("crouch").get_strength();
			power = lerp(power, -30.0, delta);
		modifier.duration = 1.0;
		modifier.value = power;
		modifier.initial_duration = 1.0;
		modifier.fade = modifier.Fade.QUADRATIC;
		CameraController.fov_modifiers.set("crouch", modifier);
		$hitbox.shape.height = 1.0;
		$texture.mesh.height = 1.0;
	else:
		crouching = false;
		$hitbox.shape.height = 2.0;
		$texture.mesh.height = 2.0;
	if Input.is_action_pressed("sprint") and Globals.player_sprint > 0 and not crouching:
		speed *= 1.7;
		var modifier := CameraController.FovModifier.new();
		var power := 0.0;
		if CameraController.fov_modifiers.has("sprint"):
			power = CameraController.fov_modifiers.get("sprint").get_strength();
			power = lerp(power, 50.0, delta);
		modifier.duration = 1;
		modifier.value = power;
		modifier.initial_duration = 1;
		modifier.fade = modifier.Fade.QUADRATIC;
		CameraController.fov_modifiers.set("sprint", modifier);
	else:
		Globals.player_sprint += delta * 3;
		if not input_dir:
			Globals.player_sprint += delta * 24;
	
	if not is_on_floor():
		velocity += get_gravity() * delta;
	if input_dir:
		footstep_sfx();
		var forward := Vector2(sin(camera_direction.y), cos(camera_direction.y));
		var side := Vector2(forward.y, -forward.x);
		forward *= input_dir.y;
		side *= input_dir.x;
		if Input.is_action_pressed("sprint"):
			Globals.player_sprint -= delta * 12;
		
		var direction := (forward + side);
		if Vector2(velocity.x, velocity.z).length_squared() <= speed * speed:
			velocity.x = direction.x * speed;
			velocity.z = direction.y * speed;
	else:
		$footsteps.volume_db = -80.0;
	velocity.x *= deceleration;
	velocity.z *= deceleration;
	
	move_and_slide();

func _physics_process(delta: float) -> void:
	set_look_direction();
	player_movement(delta);
	Globals.player_position = global_position;
	Globals.player_rotation = global_rotation;
	if Globals.player_health <= 0:
		get_tree().call_deferred("reload_current_scene");
		Globals.player_health = 100;
		Globals.player_sprint = 100;


func _on_killbrick_body_entered(body: Node3D) -> void:
	var tween = get_tree().create_tween();
	tween.tween_property(Globals, "player_health", 0, 3)

func calculate_camerapos(delta):
	var target_pos := Vector3.ZERO;
	var camera_y_offset := 0.0;
	var SIN_Y := sin(camera_direction.y);
	var COS_Y := cos(camera_direction.y);
	var SIN_X := sin(camera_direction.x);
	var COS_X := cos(camera_direction.x);
	target_pos.x = SIN_Y * COS_X * CameraController.camera_dist;
	if Player.crouching:
		camera_y_offset = lerp(camera_y_offset, -0.5, delta * 12.0);
	else:
		camera_y_offset = lerp(camera_y_offset, 1.0, delta * 12.0);
	target_pos.y = -SIN_X * CameraController.camera_dist;
	target_pos.z = COS_Y * COS_X * CameraController.camera_dist;
	if CameraController.angled:
		CameraController.angle_smoothing = lerp(CameraController.angle_smoothing, 1.0, delta * 12.0);
		camera_y_offset = lerp(camera_y_offset, -0.25, delta * 12.0);
	else:
		CameraController.angle_smoothing= lerp(CameraController.angle_smoothing, 0.0, delta * 12.0);
	target_pos.x += COS_Y * CameraController.angle_smoothing;
	target_pos.z += -SIN_Y * CameraController.angle_smoothing;
	$cameracast.position = Vector3(0.0, camera_y_offset, 0.0);
	$cameracast.target_position = target_pos;
	$cameracast.force_raycast_update();
	if $cameracast.is_colliding():
		target_pos = $cameracast.get_collision_point() - global_position;
		target_pos.x -= SIN_Y * COS_X;
		target_pos.y += SIN_X;
		target_pos.z -= COS_Y;
	CameraController.target_pos = target_pos;
	CameraController.target_pos.y += camera_y_offset;
	CameraController.beabadoobee(delta);

func footstep_sfx():
	$footsteps.volume_db = -20.0;
	$footsteps.pitch_scale = 1.0;
	if Input.is_action_pressed("crouch"):
		$footsteps.volume_db = -25.0;
		$footsteps.pitch_scale = 0.6;
	if Input.is_action_pressed("sprint"):
		$footsteps.volume_db = -15.0;
		$footsteps.pitch_scale = 1.6;


func _on_camera_cooldown_timeout() -> void:
	camera_usable = true;
