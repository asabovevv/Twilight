extends ScriptedObject

@export var my_scene : PackedScene
## If left blank, sends cutscene object to Twilight.cutscene
@export var my_scene_parent : Node2D = null
@export var flag_triggers : Array[int] = [0]
@export var cutscene_variant : int = 0
@export var cutscene_path : String

func _process(delta: float) -> void:
	
	# Check all flags
	var flags_required : int = flag_triggers.size()
	var flags_true : int = 0
	for i in range(flag_triggers.size()):
		if Twilight.Flags.get_flag( flag_triggers[i] ):
			flags_true += 1
	
	# If all flags are true
	if flags_true == flags_required:
		
		var cut = my_scene.instantiate()
		cut.set_script( load(cutscene_path) )
		
		if my_scene_parent == null:
			Twilight.cutscene.add_child( cut )
		else:
			my_scene_parent.add_child( cut )
		
		queue_free()
