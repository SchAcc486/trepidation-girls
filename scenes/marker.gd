extends MeshInstance3D
var target_pos := Vector3(99.515, 2.788, 82.15);
var player_pos := Globals.player_position;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player_pos = Globals.player_position;
	self.global_position = player_pos;
	self.global_position += player_pos.direction_to(target_pos) * min((player_pos - target_pos).length(), 20);
