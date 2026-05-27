extends FunctionCollider

@export var parent_node : Node
@export var set_fade : float
@export var set_depth : int
@export var player_collision_tile : TileMapLayer
@export var npc_activate : Node
@export var npc_deactivate : Node

func execute() -> void:
	parent_node.target_fade = set_fade
	parent_node.target_depth = set_depth
	
	if player_collision_tile != null:
		player.collision_tile_layer = player_collision_tile
	
	if (npc_activate != null):
		if (npc_activate.global_position.y == 64000):
			npc_activate.global_position.y -= 64000
			
	if (npc_deactivate != null):
		if (npc_deactivate.global_position.y == 0):
			npc_deactivate.global_position.y += 64000
			
