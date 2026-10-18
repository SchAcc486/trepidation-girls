extends Node3D

var bgm := [preload("res://music/nighttime_bgm/late night with a cannibal.ogg"), 
			preload("res://music/nighttime_bgm/night stalking.ogg"), 
			preload("res://music/nighttime_bgm/the streets at night.ogg")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$BGM/Angle.stream = bgm.pick_random();
	#$BGM/Angle.playing = true;
	objective();
	CameraController.first_person = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if CameraController.first_person == true:
		$UI/Camera.visible = true;
	else:
		$UI/Camera.visible = false;

## plays new song after old song ends
func _on_angle_finished() -> void:
	#$BGM/Angle.stream = bgm.pick_random();
	#$BGM/Angle.playing = true;
	pass;

## screen transition is called
func _on_area_3d_body_entered(_body: Node3D) -> void:
	ScreenTransition.change_scene("res://scenes/forest.tscn");
	Slenderman.rage_mode = false;
	
	await get_tree().create_timer(10.0).timeout;

## changes objective
func objective():
	await get_tree().create_timer(0.5).timeout;
	if Globals.polaroids == 0:
		Globals.objectives = "buy polaroids";
		$UI/ShopMarker.visible = true;
		$UI/FenceMarker.visible = false;
	if Globals.polaroids >= 1:
		Globals.objectives = "go into the forest";
		$UI/FenceMarker.visible = true;
		$UI/ShopMarker.visible = false;
	if Globals.picture_variant_taken >= 1:
		Globals.objectives = "sell treestalker photo";
		$UI/ShopMarker.visible = true;
		$UI/FenceMarker.visible = false;

func _on_detect_body_exited(_body: Node3D) -> void:
	objective();
