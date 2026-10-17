extends Node
signal reload_signal();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func reload_scene():
	Globals.player_health = 100.0;
	Globals.player_sprint = 100.0;
	Slenderman.rage_mode = false;
	CameraController.first_person = false;
	reload_signal.emit();
	get_tree().call_deferred("reload_current_scene");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
