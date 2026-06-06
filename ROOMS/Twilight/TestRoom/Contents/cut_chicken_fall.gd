extends Cutscene

var velocity : float = 0.1
var already_shook : bool = false

func _act(delta : float) -> void:
	
	if time < 0.4:
		velocity += delta*0.5
		$Turkey.position.y += velocity
	else:
		if !already_shook:
			already_shook = true
			Twilight.camera.shake(0.3, 8)
			Audio.play_sfx("SE_impact_double")
