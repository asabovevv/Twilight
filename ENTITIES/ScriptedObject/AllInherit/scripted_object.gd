class_name ScriptedObject
extends Node2D

@export var player : CharacterBody2D
@export var snap : bool = true
@export var has_collision : bool = true

func _ready() -> void:
	if snap:
		global_position = _grid_snap(global_position)
	_custom_ready()

func _custom_ready() -> void:
	pass

func execute() -> void:
	pass

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)
