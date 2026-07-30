extends CanvasLayer

signal exit;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/Gamma.value = Globals.gamma;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;


func _on_back_pressed() -> void:
	exit.emit();
	call_deferred("queue_free");


func _on_gamma_value_changed(value: float) -> void:
	Globals.gamma = value;
