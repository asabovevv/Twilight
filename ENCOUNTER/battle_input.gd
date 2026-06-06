class_name BattleInput extends Node

## Handles input polling and proper handoff

var context : EncounterContext

func _initialize(ctx : EncounterContext) -> void:
	context = ctx

func poll() -> void:
	if Input.is_action_just_pressed("Cancel"):
		context.turn.on_cancel()
	elif Input.is_action_just_pressed("Confirm"):
		context.turn.on_confirm()
	elif Input.is_action_just_pressed("Up"):
		context.turn.on_move(Vector2i.UP)
	elif Input.is_action_just_pressed("Down"):
		context.turn.on_move(Vector2i.DOWN)
	elif Input.is_action_just_pressed("Left"):
		context.turn.on_move(Vector2i.LEFT)
	elif Input.is_action_just_pressed("Right"):
		context.turn.on_move(Vector2i.RIGHT)
