class_name Equipable
extends Resource

@export var name : String
@export_multiline var description : String
@export var can_unequip : bool = true
@export var is_weapon : bool
@export var owner : String
@export var icon : Texture

@export_category("Stats")
@export var heart : int
@export var juice : int
@export var attack : int
@export var defense : int
@export var speed : int
@export var luck : int
@export var hit : int = 100

func _equip() -> void:
	pass

func _unequip() -> void:
	pass
