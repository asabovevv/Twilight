extends ScriptedObject

@export var ID : int = 0

@export_category("Layer Fading")
@export var fader : Node
@export var set_fader : float = 1
@export var npc_deactivate : Node
@export var player_collision_tile : TileMapLayer

func _ready() -> void:
	if snap:
		global_position = global_position.snapped(Vector2(32, 32)) - Vector2(16, 12)
	
	$CollisionShape2D.queue_free()
