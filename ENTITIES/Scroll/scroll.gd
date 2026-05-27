extends Sprite2D

@export var Player : CharacterBody2D
@export var scroll_amount : Vector2 = Vector2(0.5, 0.5)
@export var frame_amount : int = 1
var cam
var origin : Vector2
var time : float = 0

func _ready() -> void:
	cam = Player.camera
	origin = global_position

func _process(delta: float) -> void:
	global_position = cam.global_position * scroll_amount + origin
	
	time += delta
	if time >= frame_amount:
		time -= frame_amount
	frame = time
