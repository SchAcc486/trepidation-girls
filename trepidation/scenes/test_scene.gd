"""nighttime worldenvironment: #160221 - Background, #3e0086 - Ambient Light, #010206 - Fog Emission"""
"""daytime worldenvironment: #eae7e6 - Background, #ffffff - Ambient Light, #eeebe1 - Fog Emission"""

extends Node3D

var rage_timer := 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Scene/Environment/WorldEnvironment.environment.volumetric_fog_emission = Color(0.006, 0.011, 0.034, 1.0);
	$Scene/Environment/WorldEnvironment.environment.ambient_light_color = Color(0.243, 0.0, 0.525, 1.0);
	$Scene/Environment/WorldEnvironment.environment.background_color = Color(0.039, 0.003, 0.068, 1.0);
	$Scene/Environment/Lighting.light_color = Color(0.142, 0.045, 0.222, 1.0);
	CameraController.first_person = false;
	if Globals.polaroids >= 1:
		Globals.objectives = "take a photo of the treestalker";
	else:
		Globals.objectives = "buy polaroids";
		$Scene/Escape/Marker.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CameraController.first_person == true:
		$Camera.visible = true;
	else:
		$Camera.visible = false;
	if Slenderman.rage_mode:
		rage_timer += delta;
		$Scene/Environment/WorldEnvironment.environment.volumetric_fog_emission = Color(0.122, 0.0, 0.006, 1.0);
		$Scene/Environment/WorldEnvironment.environment.ambient_light_color = Color(0.147, 0.0, 0.017, 1.0);
		$Scene/Environment/WorldEnvironment.environment.background_color = Color(0.138, 0.0, 0.01, 1.0);
		$Scene/Escape/YouCantEscape/Collision.disabled = true;
		
		if $Scene/Music/Crickets.playing == true or $Scene/Music/OwlHoot.playing == true:
			$Scene/Music/Crickets.playing = false;
			$Scene/Music/OwlHoot.playing = false;
		
		if rage_timer >= 5.0 and $Scene/Music/EvilRageAmbience.playing == false:
			$Scene/Music/EvilRageAmbience.playing = true;

## when the player tries to leave before completing objective
func _on_hitbox_body_entered(_body: Node3D) -> void:
	if Globals.polaroids <= 0:
		$Scene/Escape/YouCantEscape/Collision.disabled = true;
		return;
	if Player.crouching and Slenderman.rage_mode == false and Globals.picture_variant_taken < 1:
		$Scene/UI/Gameplay/InnerThoughts/InnerThoughts.text = "I can't leave yet, I still need to get a picture...";
		var tween := get_tree().create_tween();
		tween.tween_property($Scene/UI/Gameplay/InnerThoughts/InnerThoughts, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0);
		await get_tree().create_timer(4.0).timeout;
		tween = get_tree().create_tween();
		tween.tween_property($Scene/UI/Gameplay/InnerThoughts/InnerThoughts, "modulate", Color(1.0, 1.0, 1.0, 0.0), 2.0);
	if Player.crouching and Slenderman.rage_mode or Globals.picture_variant_taken >= 1:
		$Scene/Escape/YouCantEscape/Collision.disabled = true;


func _on_timer_timeout() -> void:
	pass # Replace with function body.

## calls the loading screen transition
func _on_escape_body_entered(_body: Node3D) -> void:
	ScreenTransition.change_scene("res://scenes/town.tscn");
