extends FunctionCollider

@export var target : Node2D
@export var horizontal : bool = false
@export var vertical : bool = false

func _ready() -> void:
	if snap:
		global_position = global_position.snapped(Vector2(32, 32)) - Vector2(16, 12)
		target.global_position = target.global_position.snapped(Vector2(32, 32)) - Vector2(16, 12)

func execute() -> void:
	if horizontal:
		player.global_position.x = target.global_position.x
		player.target_position = player.global_position
	if vertical:
		player.global_position.y = target.global_position.y
		player.target_position = player.global_position
