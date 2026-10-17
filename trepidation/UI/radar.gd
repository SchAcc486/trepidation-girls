extends Control

var points = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Mouse.rotation = PI - CameraController.get_camera().rotation.y;
	$Circle/RadarBar.rotation += delta;

## adds green points placement to the green point machine
func generate_points():
	points = [];
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		var point = vect_2d(Globals.player_position - enemy.global_position) * 0.8;
		point -= Vector2(32.0, 32.0);
		points.push_back(point);

## shows green points on the green point machine
func render_points():
	for child in $Dots.get_children():
		child.call_deferred("queue_free");
		child.hide();
	for point in points:
		var evil_clone = $Dot.duplicate();
		$Dots.add_child(evil_clone);
		evil_clone.show();
		evil_clone.position = point;


func vect_2d(vector: Vector3) -> Vector2:
	return Vector2(vector.x, vector.z);

## shows dots on timer
func _on_timer_timeout() -> void:
	#$Button2.play();
	generate_points();
	render_points();
	#$Dots.rotation = CameraController.get_camera().rotation.y + PI;
