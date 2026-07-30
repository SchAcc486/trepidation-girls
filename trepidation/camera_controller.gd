# credit to Atreya's camera code :3

extends Node
class FovModifier:
	var value := 0.0;
	var duration := 0.0;
	var initial_duration := 0.0;
	var custom := 1.0;
	enum Fade{NONE, LINEAR, QUADRATIC, QUINTIC, SQUAREROOT, CUSTOM};
	var fade := Fade.NONE;
	func get_strength() -> float:
		var ratio = duration / initial_duration;
		ratio = clampf(ratio, 0, 1);
		match fade:
			Fade.NONE:
				return value;
			Fade.LINEAR:
				return value * ratio;
			Fade.QUADRATIC:
				return value * (ratio ** 2);
			Fade.QUINTIC:
				return value * (ratio ** 3);
			Fade.SQUAREROOT:
				return value * (ratio ** 0.5);
			Fade.CUSTOM:
				return value * (ratio ** custom);
		return value;

var max_pitch := PI / 2.0;
var max_move := 180.0;
var control_sensitivity := 50.0;
var control_smooth := 4.0;
var camera_move := Vector3.ZERO;
var camera_y_offset := 1.0;
var mouse_sensitivity := 10.0;
var fov_modifiers: Dictionary[String, FovModifier] = {};
const BASE_CAMERADIST := 5.0;
var camera_dist := BASE_CAMERADIST;
var angled := false;
var angle_smoothing := 0.0;
var target_pos := Vector3.ZERO;
var first_person := false;
var move_speed := 0.0;
var internal_timer := 0.0;
var base_fov := 70.0;



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;
 
func update_fov(delta, camera) -> void:
	if not camera:
		return;
	camera.fov = base_fov;
	for key in fov_modifiers:
		var modifier = fov_modifiers.get(key);
		camera.fov += modifier.get_strength();
		if modifier.duration > 0:
			modifier.duration -= delta;
		else:
			fov_modifiers.erase(key);
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	internal_timer += delta;
	if Input.is_action_just_pressed("camera_angle"):
		angled = !angled;
	if Input.is_action_just_pressed("first_person"):
		first_person = !first_person;
		var big_tree := preload("res://mesh_libraries/big_tree_material.tres");
		big_tree.distance_fade_mode = 1 - big_tree.distance_fade_mode;
	if not get_camera():
		return;
	get_camera().attributes.exposure_multiplier = Globals.gamma;

func update_camera(delta: float) -> void:
	var camera := get_camera();
	if not camera:
		return; # if no camera exists, exit before errors happen
	camera.rotation_degrees.x += camera_move.y * delta;
	if max_pitch:
		camera.rotation.x = clampf(camera.rotation.x, -max_pitch, max_pitch);
	camera.rotation_degrees.y += camera_move.x * delta;
	camera_move /= control_smooth;
	if first_person:
		move_speed = 1.0;
		if Player.crouching:
			camera.position = Vector3(0.0, 0.5, 0.0);
		else:
			camera.position = Vector3(0.0, 1.0, 0.0);
	else:
		move_speed = 2.0;
		camera.position = lerp(camera.position, target_pos, 1.0);
	Player.target_dir = camera.rotation.y;

func get_camera() -> Camera3D:
	return get_viewport().get_camera_3d();
	
func get_camera_direction(deg := false) -> Vector3:
	if get_camera():
		if deg:
			return get_camera().rotation_degrees;
		else:
			return get_camera().rotation;
	else:
		return Vector3.ZERO;

func get_camera_movement(delta):
	if first_person and fmod(internal_timer, 0.1) <= delta * 1:
		return;
	else:
		var move := Input.get_axis("camera_right", "camera_left");
		move *= control_sensitivity * move_speed;
		camera_move.x += move * delta * 45;
	if first_person:
		var move := Input.get_axis("backwards_arrow", "forwards_arrow");
		camera_move.y += move * control_sensitivity * move_speed * delta * 45;
		max_pitch = PI / 4;
	else:
		max_pitch = PI / 2;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_drag"):
		camera_move.x += -event.relative.x * mouse_sensitivity;
		camera_move.y += -event.relative.y * mouse_sensitivity;
	
func beabadoobee(delta):
	get_camera_movement(delta);
	update_camera(delta);
	update_fov(delta, get_camera());
	var scroll :float= Input.get_axis("zoom_out", "zoom_in");
	if first_person:
		base_fov += scroll;
		base_fov = clampf(base_fov, 40.0, 90.0);
	else:
		camera_dist += scroll * delta * 4;
		camera_dist = clampf(camera_dist, 3, 10);

# Don't catch me, just let me swim away.
# From everyone, I need a place to stay.
# Where I can soemtthing smothing somet.
# Don't cry, I am just a fish.
