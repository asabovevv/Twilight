extends Node2D

@export var group_node : Node
@export var player : CharacterBody2D
var fade : float
@export var target_fade : float = 1
@export var target_depth : int = 0

func _physics_process(delta: float) -> void:
	if group_node.modulate.a == 1:
		group_node.z_index = target_depth
	group_node.modulate.a = move_toward(group_node.modulate.a, target_fade, delta*3* (float(player.running)+1) )
