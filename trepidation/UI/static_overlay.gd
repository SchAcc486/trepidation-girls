extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture.noise.seed = 0;
	$TextureRect.modulate.a = 0.0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.game_paused:
		return;
	var target_dir := atan2(Globals.player_position.x - Globals.slenderman_position.x, Globals.player_position.z - Globals.slenderman_position.z)
	var dist := (Globals.slenderman_position - Globals.player_position).length();
	$Label.text = str(dist);
	var ang_dist = angle_difference(CameraController.get_camera_direction().y, target_dir);
	if abs(rad_to_deg(ang_dist)) <= 40:
		$TextureRect.texture.noise.seed += 1;
		dist = sqrt(dist); #yo u want the square root of the distance times the four B)
		dist /= 14.142135623730951; #sqrt 200
		dist = 0.5 - dist;
		dist = max(dist, 0.0);
		$TextureRect.modulate.a = lerp($TextureRect.modulate.a, dist, delta * 6);
		var modifier := CameraController.FovModifier.new();
		var power :float= -60.0 * $TextureRect.modulate.a;
		modifier.value = power;
		modifier.duration = 3;
		modifier.initial_duration = 3;
		modifier.fade = modifier.Fade.QUADRATIC;
		CameraController.fov_modifiers.set("slenderman_zoom", modifier);
	else:
		$TextureRect.modulate.a = lerp($TextureRect.modulate.a, 0.0, delta * 6);
	
