extends Node

func run( myInt:int, player:CharacterBody2D ) -> void:
	Global.encounter = load("res://RESOURCES/Encounter/Encounter%d.tres" % [myInt])
	
	var cutNode = Cutscene.new()
	cutNode.script = load("res://ENTITIES/Cutscene/encounterStart.gd")
	cutNode.nodes = [player] as Array[Node]
	
	player.add_child(cutNode)
	cutNode.setup()
