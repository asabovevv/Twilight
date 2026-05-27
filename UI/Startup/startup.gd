extends Node2D

func _ready() -> void:
	Global.load_from_slot(0)
	
	DisplayServer.window_set_size(Vector2i(640*2, 480*2))
	DisplayServer.window_set_position(Vector2i(320, 60))
	
	await get_tree().create_timer(0.4)
	
	get_tree().change_scene_to_file("res://ROOMS/Twilight/displayroom.tscn")
