extends CanvasLayer


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass ## Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$FPS.text = str(Performance.get_monitor(Performance.TIME_FPS));
	if CameraController.first_person == true:
		$Health.visible = false;
		$Sprint.visible = false;
	else:
		$Health.visible = true;
		$Sprint.visible = true;
