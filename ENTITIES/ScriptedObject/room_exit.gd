extends ScriptedObject

@export var new_scene_path : String
@export var ID : int

func execute() -> void:
	player.cutscene = true
	player.fade_target = 1
	player.fade_color = Color.BLACK
	
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	await get_tree().create_timer(0.4).timeout
	Twilight.entrance = ID
	Twilight.room = new_scene_path
	get_tree().change_scene_to_file(new_scene_path)
