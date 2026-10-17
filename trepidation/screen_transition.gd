extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;

## changes the scene
func change_scene(path:String) -> void:
	$SFX/Loading.play();
	$Background.show();
	$Background.position = Vector2(0.0, -650.0);
	var tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_BOUNCE);
	tween.set_ease(Tween.EASE_OUT);
	tween.tween_property($Background, "position", Vector2(0.0, 0.0), 2.0);
	await tween.finished;
	await get_tree().create_timer(5.3).timeout;
	get_tree().change_scene_to_file(path);
	tween = get_tree().create_tween();
	tween.set_trans(Tween.TRANS_BOUNCE);
	tween.set_ease(Tween.EASE_IN);
	tween.tween_property($Background, "position", Vector2(0.0, -1280.0), 2.0);
	$SFX/Loading.stop();
	$SFX/Finished.play();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Background/Overlay.texture.noise.seed = randf_range(0.0, 1000.0);
	$Background/DarkOverlay.texture.noise.seed = randf_range(100.0, 100000.0);
	$Background.texture.noise.frequency = randf();
