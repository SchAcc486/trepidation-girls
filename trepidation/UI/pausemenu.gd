extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;
	#if Input.is_action_just_pressed("pause") and Globals.game_paused == true:
		#_on_resume_pressed();


func _on_settings_pressed() -> void:
	const scene = preload("res://UI/settings_ui.tscn");
	var doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	$".".visible = false;
	doinky.connect("exit", show);


func _on_resume_pressed() -> void:
	Globals.game_paused = false;
	get_tree().paused = false;
	call_deferred("queue_free");
