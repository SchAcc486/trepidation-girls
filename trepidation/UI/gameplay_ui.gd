extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$fps.text = str(Performance.get_monitor(Performance.TIME_FPS));
	if CameraController.first_person == true:
		$health.visible = false;
		$sprint.visible = false;
	else:
		$health.visible = true;
		$sprint.visible = true;
