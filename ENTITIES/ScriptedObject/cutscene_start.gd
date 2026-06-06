## TODO FIX
extends ScriptedObject

@export var cutscene_path : String 
@export var cutscene_variant : int = 0
@export var check_flag : int = -1

func _ready() -> void:
	check_valid()

func execute() -> void:
	if !check_valid():
		return
	
	player.cutscene = true
	
	var cut = load(cutscene_path)
	var node = Node2D.new()
	node.script = cut
	node.variant = cutscene_variant
	node.nodes = cutscene_nodes
	add_child(node)

func check_valid() -> bool:
	if check_flag != -1:
		if Twilight.Flags.get_flag(check_flag):
			queue_free()
			return false
	
	return true
