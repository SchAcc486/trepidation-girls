class_name PauseMenu
extends CanvasLayer

static var debounce := 0.5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debounce = 0.5;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debounce -= delta;
	if Input.is_action_just_pressed("pause") and debounce <= 0.0:
		_on_resume_pressed();


## settings menu
func _on_settings_pressed() -> void:
	Settings.debounce = 0.5;
	const scene = preload("res://UI/settings_ui.tscn");
	var doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	$".".visible = false;
	doinky.connect("exit", show);
	$SFX/Button.playing = true;


## resume game
func _on_resume_pressed() -> void:
	$SFX/Button.playing = true;
	Globals.game_paused = false;
	get_tree().paused = false;
	var buttonsfx := $SFX/Button.duplicate();
	add_sibling(buttonsfx);
	buttonsfx.play();
	call_deferred("queue_free");

## controls menu
func _on_controls_pressed() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/controls_ui.tscn");
	var doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	$".".visible = false;
	doinky.connect("exit", show);
	$SFX/Button.playing = true;


func _on_title_pressed() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://scenes/title_screen.tscn")
	var doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	doinky.connect("exit", show);
	var buttonsfx := $SFX/Button.duplicate();
	add_sibling(buttonsfx);
	buttonsfx.play();
	Globals.game_paused = false;
	get_tree().paused = false;
	call_deferred("queue_free");


func _on_about_pressed() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/about_ui.tscn");
	var doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
	$".".visible = false;
	doinky.connect("exit", show);
	$SFX/Button.playing = true;
