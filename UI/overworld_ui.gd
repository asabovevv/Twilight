extends Node2D

var my_uis : Array

func _ready() -> void:
	TWILIGHT.ui = self

func add_ui(path : String) -> void:
	my_uis.append( path )

func activate_ui(ui_index : int, player : Node) -> void:
	var uiscene = load( my_uis[ui_index] )
	var uiinstance = uiscene.instantiate()
	
	uiinstance.player = player
	
	add_child(uiinstance)

func activate_ui_textbox(ui_index : int, input_node : Node, dialogue_sequence : DialogueSequence) -> void:
	var uiscene = load( my_uis[ui_index] )
	var uiinstance = uiscene.instantiate()
	
	uiinstance.visible = false
	uiinstance.player = input_node
	uiinstance.dialogue = dialogue_sequence
	uiinstance.npc = input_node.interactable_node
	
	add_child(uiinstance)
