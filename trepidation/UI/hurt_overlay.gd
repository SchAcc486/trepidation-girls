extends CanvasLayer

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass ## Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ratio = Globals.player_health / 100.0;
	ratio += 2;
	$Brambles.scale.x = lerpf(scale.x, ratio, delta * 12);
	$Brambles.scale.y = lerpf(scale.y, ratio, delta * 12);
	$Vignette.scale.x = lerpf(scale.x, ratio, delta * 12);
	$Vignette.scale.y = lerpf(scale.y, ratio, delta * 12);
	if Globals.player_health_changed <= Globals.player_health:
		pass;
