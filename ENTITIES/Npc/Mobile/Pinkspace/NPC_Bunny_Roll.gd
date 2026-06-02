extends NPCBasic

@export var roll_speed : float = 2
@export var roll_dist : float = 30
@export var frame_freq : float = 7
var roll_time = 0

func _move(delta: float):
	roll_time += delta
	global_position = origin + Vector2( sin(roll_time*roll_speed)*roll_dist, 0)
	
	_frame = int(20.5 + (global_position.x - origin.x) / frame_freq) % 4
	frame = _frame
	
	target = (global_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)
