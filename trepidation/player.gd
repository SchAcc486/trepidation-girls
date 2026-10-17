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
var camera_usable := true;
var doinky : CanvasLayer;

static var crouching := false;
static var sprinting := false;
static var target_dir := 0.0;

func _ready() -> void:
	$SFX/Footsteps.volume_db = -10.0;
	$SFX/CameraWhir.volume_db = -80.0;
	ReloadScene.connect("reload_signal", reload);

func reload():
	flashlight = false;
	crouching = false;
	target_dir = 0.0;
	global_position = Vector3(99.528, 1.05, 81.263);

func _process(delta: float) -> void:
	
	# makes sure the player can't be used when paused
	if Globals.game_paused:
		return;
	
	# makes annoying camera whir sound effect
	if (Input.get_vector("camera_left", "camera_right", "backwards_arrow", "forwards_arrow") or Input.get_axis("zoom_in", "zoom_out")) and CameraController.first_person:
		$SFX/CameraWhir.volume_db = -35.0;
	else:
		$SFX/CameraWhir.volume_db = -80.0;
	
	# will let the player interact with things
	if Input.is_action_just_pressed("interact"):
		pass;
	
	# toggles pause
	if Input.is_action_just_pressed("pause"):
		toggle_pause();
	
	# will play equip camera noise
	if Input.is_action_just_pressed("first_person"):
		$SFX/EquipCamera.playing = true;
		if not CameraController.first_person:
			$SFX/UnequipCamera.playing = true;
	
	# makes the player face the direction the camera is facing
	$Texture.rotation.y = camera_direction.y;
	calculate_camerapos(delta);
	$Flashlight/Click.volume_db = Globals.sfx_volume;
	
	manage_dowsing_rods(delta);
	
	# turns on flashlight
	if Input.is_action_just_pressed("flashlight"):
		toggle_flashlight();
	
	# makes sure ur in first person, the cooldown isn't on, and the flashlight isn't on before you take a picture
	var can_take_picture := CameraController.first_person and not flashlight and camera_usable;
	if Input.is_action_just_pressed("take_picture") and can_take_picture:
		if Globals.polaroids > 0:
			take_picture();
			Globals.polaroids -= 1;
		else:
			$CameraFlashHigh/CameraFail.playing = true;
	
	# moves camera flash rotation unless it is being used
	if $CameraFlashHigh.visible == false:
		$CameraFlashHigh.rotation.y = Player.target_dir;
	
	var dist := (Globals.slenderman_position - Globals.player_position).length();
	dist /= 70.0;
	if randf() >= dist:
		$Flashlight/JustLight.light_energy = randf_range(dist * 2.5, 3.0);
	else:
		$Flashlight/JustLight.light_energy = move_toward($Flashlight/JustLight.light_energy, 3.0, delta * 12.0);

## shows pause menu
func toggle_pause() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/pausemenu_ui.tscn");
	doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	Globals.game_paused = true;
	get_tree().paused = true;

## toggles flashlight, if rage mode does not
func toggle_flashlight() -> void:
	$Flashlight/Click.playing = true;
	if Slenderman.rage_mode:
		$Flashlight/Click.pitch_scale = 1.5;
		flashlight = false;
		pass;
	else:
		flashlight = !flashlight;
		$Flashlight.visible = flashlight;

## randomly complicated because it has a cooldown and I didn't want the player to hold a flashlight and camera at the same time
func take_picture() -> void:
	camera_usable = false;
	$CameraCooldown.start();
	$CameraFlashHigh/CameraShutter.playing = true;
	await get_tree().create_timer(0.36).timeout;
	$CameraFlash.play("camera_flash");
	await get_tree().create_timer(0.15).timeout;
	Globals.picture_taken += 1;
	$ThingInPic.target_position = Globals.slenderman_position - global_position;
	$ThingInPic.force_raycast_update();
	for body in $CameraFlashHigh/PictureRadius.get_overlapping_bodies():
		if body is Slenderman and $ThingInPic.get_collider() is Slenderman:
			Globals.picture_variant_taken += 1;
			Globals.player_health -= 15.0;
			Slenderman.rage_mode = true;
			Slenderman.should_random_spawn = true;
			Globals.objectives = "escape the forest";
			$"../Escape/Marker".visible = true;
	#spawn evil JEFFlings
	#the actual GOAT of a failsafe fr fr
	if Globals.polaroids <= 0 and Globals.money <= 0.0:
		const JEFF = preload("res://enemies/enemy.tscn");
		for i in range(10):
			var instance = JEFF.instantiate() as Enemy;
			add_sibling(instance);
			instance.global_position = self.global_position + Vector3(i * 5.0, 500.0, i * 5.0);
	await get_tree().create_timer(0.15).timeout;

## makes flashlight face the player direction
func set_look_direction() -> void:
	camera_direction = CameraController.get_camera_direction();
	$Flashlight.rotation.y = Player.target_dir;
	$Flashlight.rotation.x = camera_direction.x + PI / 8;

func player_movement(delta):
	speed = BASE_SPEED;
	
	# moves the player, if in first person, arrow controls become slightly different
	var forward_dir := Input.get_axis("forwards", "backwards");
	var sideways_dir := Input.get_axis("left", "right");
	if not CameraController.first_person:
		forward_dir += Input.get_axis("forwards_arrow", "backwards_arrow");
	forward_dir = sign(forward_dir);
	var input_dir = Vector2(sideways_dir, forward_dir).normalized();
	
	if input_dir:
		$Animation.play("walkcycle");
	else:
		$Animation.play("idle");
	
	# plays crouch sound effect
	if Input.is_action_just_pressed("crouch"):
		$SFX/CrouchEnd.playing = true;
	
	# plays crouch sound effect
	if Input.is_action_just_released("crouch") and not Globals.crouch_toggle:
		$SFX/CrouchEnd.playing = true;
	
	# toggles crouch and transforms the player
	if Input.is_action_just_pressed("crouch"):
		if Globals.crouch_toggle:
			crouching = !crouching;
		else:
			crouching = true;
	if Input.is_action_just_released("crouch"):
		if not Globals.crouch_toggle:
			crouching = false;
		$Hitbox.shape.height = 2.0;
		$Texture.mesh.height = 2.0;
	if crouching:
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
		$Hitbox.shape.height = 1.0;
		if $Texture.mesh.height != 1.0:
			global_position -= Vector3(0.0, 0.5, 0.0);
			$Texture.mesh.height = 1.0;
	
	# toggles sprint if ur not crouching
	if Input.is_action_just_pressed("sprint") and Globals.player_sprint > 0.0 and not crouching:
		if Globals.sprint_toggle:
			sprinting = !sprinting;
		else:
			sprinting = true;
	if Globals.player_sprint <= 0.0:
		sprinting = false;
	if Input.is_action_just_released("sprint") and not Globals.sprint_toggle:
		sprinting = false;
	if sprinting:
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
		$Animation.speed_scale = 1.25;
	else:
		Globals.player_sprint += delta * 3;
		$Animation.speed_scale = 0.75;
		if not input_dir:
			Globals.player_sprint += delta * 24;
	
	# makes player fall
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	# checks if wasd or arrow keys r pressed to move player and play footstep sound
	if input_dir:
		footstep_sfx();
		var forward := Vector2(sin(camera_direction.y), cos(camera_direction.y));
		var side := Vector2(forward.y, -forward.x);
		forward *= input_dir.y;
		side *= input_dir.x;
		if sprinting and get_real_velocity().length_squared() >= 0.5:
			Globals.player_sprint -= delta * 6;
		
		var direction := (forward + side);
		if Vector2(velocity.x, velocity.z).length_squared() <= speed * speed:
			velocity.x = direction.x * speed;
			velocity.z = direction.y * speed;
	else:
		$SFX/Footsteps.volume_db = -80.0;
	velocity.x *= deceleration;
	velocity.z *= deceleration;
	
	move_and_slide();


func _physics_process(delta: float) -> void:
	set_look_direction();
	player_movement(delta);
	Globals.player_position = global_position;
	Globals.player_rotation = global_rotation;
	# reloads game upon death

## in case you somehow fall off the map
func _on_killbrick_body_entered(_body: Node3D) -> void:
	var tween = get_tree().create_tween();
	tween.tween_property(Globals, "player_health", 0, 3)

## how camera is positioned
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
	$CameraCast.position = Vector3(0.0, camera_y_offset, 0.0);
	$CameraCast.target_position = target_pos;
	$CameraCast.force_raycast_update();
	if $CameraCast.is_colliding():
		target_pos = $CameraCast.get_collision_point() - global_position;
		target_pos.x -= SIN_Y * COS_X;
		target_pos.y += SIN_X;
		target_pos.z -= COS_Y;
	CameraController.target_pos = target_pos;
	CameraController.target_pos.y += camera_y_offset;
	CameraController.beabadoobee(delta);

## footsteps play and change depending on mode of transport
func footstep_sfx():
	$SFX/Footsteps.volume_db = -20.0;
	$SFX/Footsteps.pitch_scale = 1.0;
	if Input.is_action_pressed("crouch"):
		$SFX/Footsteps.volume_db = -25.0;
		$SFX/Footsteps.pitch_scale = 0.6;
	if Input.is_action_pressed("sprint"):
		$SFX/Footsteps.volume_db = -15.0;
		$SFX/Footsteps.pitch_scale = 1.6;

## waits till camera is usable
func _on_camera_cooldown_timeout() -> void:
	camera_usable = true;
	
func manage_dowsing_rods(delta):
	if Globals.Item.DOWSING_ROD in Globals.item_list:
		var dist = 1e308;
		for enemy in get_tree().get_nodes_in_group("Enemies"):
			if (self.global_position - enemy.global_position).length_squared() < dist:
				dist = (self.global_position - enemy.global_position).length_squared();
		
		if dist == 1e308:
			return;
		
		dist = sqrt(dist);
		
		dist = clampf(dist, 0.0, 75.0) - 50.0;
		
		$Items/DowsingRod/RodLeftPivot.rotation.y = lerp_angle($Items/DowsingRod/RodLeftPivot.rotation.y, deg_to_rad(dist), delta);
		$Items/DowsingRod/RodRightPivot.rotation.y = lerp_angle($Items/DowsingRod/RodRightPivot.rotation.y, deg_to_rad(-dist), delta);
		
		$Items/DowsingRod.rotation.y = camera_direction.y;
		
		#$SFX/DowsingRodHum.volume_db = clampf(-dist, -10.0, 10.0);
	else:
		$Items/DowsingRod.visible = false;
		$SFX/DowsingRodHum.volume_db = -80.0;
