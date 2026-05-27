extends NPCBasic

@export var Player : CharacterBody2D
@export var scroll_amount : Vector2 = Vector2(0.5, 0.5)
var start : Vector2
var cam

func _custom_ready() -> void:
	cam = Player.camera
	start = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _move(_delta: float):
	global_position = cam.global_position * scroll_amount + start
	
	if Player.global_position.x < global_position.x - 50:
		frame = 0
	elif Player.global_position.x > global_position.x + 50:
		frame = 2
	else:
		frame = 1
