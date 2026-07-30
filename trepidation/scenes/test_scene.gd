extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CameraController.first_person == true:
		$camera.visible = true;
	else:
		$camera.visible = false;
	if Slenderman.rage_mode:
		$scene/environment/WorldEnvironment.environment.volumetric_fog_emission = Color(0.21, 0.0, 0.015, 1.0);
		$scene/environment/WorldEnvironment.environment.ambient_light_color = Color(0.29, 0.0, 0.059, 1.0);
		$scene/environment/WorldEnvironment.environment.background_color = Color(0.138, 0.0, 0.01, 1.0);


func _on_hitbox_body_entered(body: Node3D) -> void:
	var tween := get_tree().create_tween();
	tween.tween_property($scene/UI/gameplay/Label, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2).from(Color(1.0, 1.0, 1.0, 0.0));
