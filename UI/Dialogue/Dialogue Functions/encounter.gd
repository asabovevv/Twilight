# INT sets TWILIGHT.encounter by searching for a specific id in - res://ENCOUNTER/EncounterResources/

extends Node

func run( myInt:int, player:CharacterBody2D ) -> void:
	TWILIGHT.encounter = load("res://ENCOUNTER/EncounterResources/Encounter%d.tres" % [myInt])
	
	var cutNode = Cutscene.new()
	cutNode.script = load("res://ENTITIES/Cutscene/encounterStart.gd")
	cutNode.nodes = [player] as Array[Node]
	
	player.add_child(cutNode)
	cutNode.setup()
