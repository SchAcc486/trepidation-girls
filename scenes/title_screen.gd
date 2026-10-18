extends CanvasLayer

var doinky : CanvasLayer;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons.modulate = Color(1.0, 1.0, 1.0, 0.0);
	$SFX/Churchbells.play();
	var tween := get_tree().create_tween();
	tween.tween_property($Background/EyesClosed, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0);
	tween = get_tree().create_tween();
	tween.tween_property($Buttons, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0);
	await get_tree().create_timer(2.0).timeout;
	Globals.game_paused = true;
	get_tree().paused = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass;

func _on_about_pressed() -> void:
	toggle_about();
	$SFX/Click.play();

## opens settings
func _on_settings_pressed() -> void:
	toggle_settings();
	$SFX/Click.play();

## opens controls
func _on_controls_pressed() -> void:
	toggle_controls();
	$SFX/Click.play();
	

## quits program
func _on_quit_pressed() -> void:
	var buttonsfx := $SFX/Click.duplicate();
	add_sibling(buttonsfx);
	buttonsfx.play();
	$Background/EyesOpen.visible = true;
	$SFX/Start.play();
	await get_tree().create_timer(0.55).timeout;
	get_tree().quit(0);

## starts game
func _on_start_pressed() -> void:
	$SFX/Click.play();
	Globals.title_screen = false;
	Globals.game_paused = false;
	get_tree().paused = false;
	$Background/EyesOpen.visible = true;
	$SFX/Start.play();
	await get_tree().create_timer(4.0).timeout;
	ScreenTransition.change_scene("res://scenes/town.tscn");

## loads controls
func toggle_controls() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/controls_ui.tscn");
	doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);

## loads settings
func toggle_settings() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/settings_ui.tscn");
	doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);

func toggle_about() -> void:
	PauseMenu.debounce = 0.5;
	const scene = preload("res://UI/about_ui.tscn");
	doinky = scene.instantiate() as CanvasLayer;
	add_sibling(doinky);
