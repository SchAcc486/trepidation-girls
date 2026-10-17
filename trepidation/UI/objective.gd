extends CanvasLayer

var mouse_hover := false;
var objective_intro := 5.0;
static var previous_objective := "";
static var current_objective := "";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Anchor/ObjectiveTextShadow.modulate.a = 0.0;
	$Anchor/ObjectiveText.modulate.a = 0.0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if previous_objective != current_objective:
		$Anchor/ObjectiveTextShadow.modulate.a = 0.0;
		$Anchor/ObjectiveText.modulate.a = 0.0;
		$SFX/ObjectiveJingle.play();
		objective_intro = 7.0;
	$Anchor/ObjectiveText.modulate.a = move_toward($Anchor/ObjectiveText.modulate.a, 1.0, delta * 1)
	$Anchor/ObjectiveTextShadow.modulate.a = move_toward($Anchor/ObjectiveText.modulate.a, 1.0, delta * 1)
	objective_intro -= 1 * delta;
	objective_intro = clampf(objective_intro, 0.0, 3.0);
	previous_objective = current_objective;
	current_objective = Globals.objectives;
	$Anchor/ObjectiveText.text = "objective: " + current_objective;
	$Anchor/ObjectiveTextShadow.text = "objective: " + current_objective;
	if objective_intro <= 0.0:
		if mouse_hover:
			$Anchor/ObjectiveText.modulate.a = move_toward($Anchor/ObjectiveText.modulate.a, 1.0, delta * 6);
			$Anchor/ObjectiveTextShadow.modulate.a = 1.0;
		else:
			$Anchor/ObjectiveText.modulate.a = move_toward($Anchor/ObjectiveText.modulate.a, 0.0, delta * 2);
			$Anchor/ObjectiveTextShadow.modulate.a = 0.0;

## shows objective
func _on_hover_detect_mouse_entered() -> void:
	mouse_hover = true;

## hides objective
func _on_hover_detect_mouse_exited() -> void:
	mouse_hover = false;
