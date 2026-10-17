class_name Settings
extends CanvasLayer

static var debounce := 0.5;
signal exit;
var play_vol := false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Gamma.value = Globals.gamma;
	debounce = 0.5;
	play_vol = false;
	$Control/Volume.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debounce -= delta;
	PauseMenu.debounce = 0.5;
	if Input.is_action_just_pressed("pause"):
		$SFX/Click.playing = true;
		if debounce <= 0.0:
			_on_back_pressed();

## goes back to pause menu
func _on_back_pressed() -> void:
	if Globals.title_screen == true:
		PauseMenu.debounce = 0.5;
		exit.emit();
		var buttonsfx := $SFX/Click.duplicate();
		add_sibling(buttonsfx);
		buttonsfx.play();
		call_deferred("queue_free");
	else:
		PauseMenu.debounce = 0.5;
		exit.emit();
		var buttonsfx := $SFX/Click.duplicate();
		add_sibling(buttonsfx);
		buttonsfx.play();
		call_deferred("queue_free");

## changes brightness cool right?
func _on_gamma_value_changed(value: float) -> void:
	Globals.gamma = value;

## turns on sprint toggle
func _on_sprint_toggle_toggled(toggled_on: bool) -> void:
	Globals.sprint_toggle = toggled_on;

## turns on crouch toggle
func _on_crouch_toggle_2_toggled(toggled_on: bool) -> void:
	Globals.crouch_toggle = toggled_on;

## plays sound
func _on_sprint_toggle_pressed() -> void:
	$SFX/Click.playing = true;

## plays sound
func _on_crouch_toggle_2_pressed() -> void:
	$SFX/Click.playing = true;


func _on_volume_value_changed(value: float) -> void:
	if play_vol:
		$SFX/Yodle.playing = true;
	else:
		play_vol = true;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value);
