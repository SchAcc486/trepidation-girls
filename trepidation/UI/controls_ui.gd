class_name ControlsMenu
extends CanvasLayer

static var debounce := 0.5;
signal exit;

func _ready() -> void:
	debounce = 0.5;

func _process(delta: float) -> void:
	debounce -= delta;
	PauseMenu.debounce = 0.5;
	if Input.is_action_just_pressed("pause"):
		$SFX/Button.playing = true;
		if debounce <= 0.0:
			_on_back_pressed();

## goes back to settings
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
