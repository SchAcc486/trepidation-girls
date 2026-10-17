extends CanvasLayer

static var debounce := 0.5;
signal exit;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debounce = 0.5;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debounce -= delta;
	PauseMenu.debounce = 0.5;
	if Input.is_action_just_pressed("pause"):
		$SFX/Button.playing = true;
		if debounce <= 0.0:
			_on_back_pressed();


func _on_back_pressed() -> void:
	if Globals.title_screen == true:
		PauseMenu.debounce = 0.5;
		exit.emit();
		var buttonsfx := $SFX/Button.duplicate();
		add_sibling(buttonsfx);
		buttonsfx.play();
		call_deferred("queue_free");
	else:
		PauseMenu.debounce = 0.5;
		exit.emit();
		var buttonsfx := $SFX/Button.duplicate();
		add_sibling(buttonsfx);
		buttonsfx.play();
		call_deferred("queue_free");
