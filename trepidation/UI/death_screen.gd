extends CanvasLayer

var player_death_timer = 0.0;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false;
	$Text/YouDied.text = Globals.death_message;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Text/YouDied.text = Globals.death_message;
	var pos = $Button/Button.position + $Button/Button.size / 2;
	var dir = pos.direction_to(get_viewport().get_mouse_position());
	var dist = (get_viewport().get_mouse_position() - pos).length();
	dist = 60000.0 / dist;
	$Button/Button.position -= dir * dist * delta;
	$Button/Button.position.x = clampf($Button/Button.position.x, 0.0, 1731 - $Button/Button.size.x)
	$Button/Button.position.y = clampf($Button/Button.position.y, 0.0, 974 - $Button/Button.size.y)
	
	if Globals.player_health <= 0.0:
		self.visible = true;
		get_tree().paused = true;
		player_death_timer += delta;
		if not $Yodle.playing and player_death_timer < 1.0:
			$Yodle.playing = true;
		if not $YouDied.playing and player_death_timer > 7.0:
			$YouDied.playing = true;

## reloads scene
func _on_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene");
	Globals.player_health = 100;
	Globals.player_sprint = 100;
	Globals.money = 30.0;
	Globals.polaroids = 0;
	Globals.picture_taken = 0;
	Globals.picture_variant_taken = 0;
	CameraController.first_person = false;
	Slenderman.rage_mode = false;
	$YouDied.playing = false;
	get_tree().paused = false;
