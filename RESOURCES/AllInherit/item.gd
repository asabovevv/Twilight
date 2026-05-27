class_name Item
extends Resource

@export var name : String
@export_multiline var description : String
@export var overworld_use : bool = false
@export var can_trash : bool = true
@export var icon : Texture

func _use() -> void:
	pass
