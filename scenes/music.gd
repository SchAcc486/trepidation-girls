extends Node3D
var cricket_volume := -15.0;
var owl_hoot_volume := 0.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$OwlHoot.playing = true;
	$Footsteps.playing = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var dist := (Globals.slenderman_position - Globals.player_position).length();
	dist = sqrt(dist); #yo u want the square root of the distance times the four B)
	dist /= 14.142135623730951; #sqrt 200
	dist = 0.5 - dist;
	dist = max(dist, 0.0);
	if dist > 0.0:
		$Crickets.volume_db = cricket_volume - dist * 500;
		$OwlHoot.volume_db = owl_hoot_volume - dist * 500;
	else:
		$Crickets.volume_db = cricket_volume;
		$OwlHoot.volume_db = owl_hoot_volume;
		if Slenderman.rage_mode:
			$Crickets.volume_db = -80.0;
			$OwlHoot.volume_db = -80.0;


## footstep sound randomly plays to make player paranoid lol
func _on_footstep_timer_timeout() -> void:
	$FootstepTimer.wait_time = randf_range(20.0, 240.0);
	$Footsteps.pitch_scale = randf_range(0.6, 1.6);
	$Footsteps.playing = true;


## random owl noise
func _on_owl_timer_timeout() -> void:
	$OwlTimer.wait_time = randf_range(60.0, 300.0);
	var direction = randf_range(-PI, PI);
	var SIN = sin(direction) * 100;
	var COS = cos(direction) * 100;
	$OwlHoot.pitch_scale = randf_range(0.6, 1.1);
	global_position.y = 0.0;
	global_position.x = Globals.player_position.x + SIN;
	global_position.z = Globals.player_position.z + COS;
	$OwlHoot.playing = true;
