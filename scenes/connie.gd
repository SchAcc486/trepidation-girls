extends StaticBody3D

var shop = preload("res://scenes/shop.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Interact.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Detect.has_overlapping_bodies():
		$Interact.visible = true;
		if Input.is_action_just_pressed("interact"):
			Globals.shop = true;
			var scene = shop.instantiate() as CanvasLayer;
			add_child(scene);
			$"../BGM/Angle".stream_paused = true;
			$"../BGM/ShopTheme".play();
	else:
		$Interact.visible = false;
	
	if Globals.shop == false:
		$"../BGM/Angle".stream_paused = false;
		$"../BGM/ShopTheme".stop();
