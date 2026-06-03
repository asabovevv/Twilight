class_name NpcAction
extends Resource

enum ActionType { move, wait }

@export var action : ActionType = ActionType.move
@export var repeat_count : int = 1
@export var move_to : Vector2i = Vector2i(0, 0)
@export var move_speed : float = 200
@export var wait_time : float = 1.0
