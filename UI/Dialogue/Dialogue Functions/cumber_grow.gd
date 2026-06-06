# INT determines frame set

extends Node

func run( myInt:int, player:CharacterBody2D ) -> void:
	var node = Twilight.get_room_contents_node("NPC_cumber")
	var nodepos = node.position
	
	var tween = node.create_tween()
	tween.tween_property(node, "frame", float( myInt ), 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "scale", Vector2(1.8, 1.8), 0.2).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "position", node.position - Vector2(0, 10), 0.2).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0)
	tween.parallel().tween_property(node, "position", nodepos, 0)
