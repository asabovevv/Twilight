class_name Cutscene
extends Node

var variant : int = 0
var counter : Array[float]

var time : float = 0
var time_const : float = 0
var last_time : float = 0
var stage : int = 0
var nodes : Array[Node]

var dialogue_node : Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time += delta
	time_const += delta
	
	_act(delta)
	
	last_time = time

func _act(delta : float) -> void:
	pass

## TODO: redo
func _dialogue(player_node : CharacterBody2D, dialogue : Array[String]) -> void:
	for i in player_node.ui.get_children():
		i.queue_free()
	
	var menu = load("res://UI/Dialogue/DialogueBox/dialogue_box.tscn")
	player_node.ui.add_child(menu.instantiate())
	dialogue_node = player_node.ui.get_child(player_node.ui.get_child_count()-1)
	
	dialogue_node.player = player_node
	dialogue_node.end_cutscene = false
	dialogue_node.dialogue = dialogue
	player_node.dialogue_active = true

func _time(target_time : float) -> bool:
	return (time > target_time) && (last_time < target_time)

func _dialogue_place(target_place : int) -> bool:
	if dialogue_node != null:
		return dialogue_node.dialogue_place == target_place
	return false

func _hop(_node, _height, _duration) -> void:
	var hop = Node.new()
	hop.node = _node
	hop.height = _height
	hop.duration = _duration
	
	add_child(hop)
