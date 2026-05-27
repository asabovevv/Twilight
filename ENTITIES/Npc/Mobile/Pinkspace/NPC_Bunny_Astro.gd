extends NPCBasic

var screen_pos : Vector2 = Vector2(999, 999)
var wait_time : float = 2.0
var move_dir : Vector2 = Vector2.ZERO
@export var player : CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _move(delta: float):
	wait_time -= delta
	
	if wait_time <= 0:
		wait_time = rand.randi_range(10, 30)
		move_dir = Vector2( (float(rand.randi_range(0, 1))-0.5)*2, (float(rand.randi_range(0, 1))-0.5)*2)
		
		speed = 120 + rand.randi_range(-40, 40)
		screen_pos = -(move_dir * Vector2(500, 260)) + Vector2(rand.randi_range(-40, 40), rand.randi_range(-40, 40))
	
	screen_pos += move_dir * delta * speed
	global_position = player.global_position + screen_pos
	
	#var _frame = int(20.5 + (global_position.x - origin.x) / frame_freq) % 4
	#frame = _frame
	
	#target = (global_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)
