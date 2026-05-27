extends Node

var node
var node_y
var height : float
var duration : float
var speed : float
var time : float

func _ready() -> void:
	speed = 1/duration
	node_y = node.global_position.y

func _process(delta: float) -> void:
	time += delta * speed
	node.global_position.y = node_y - sin(time*PI)*height
	
	if time >= 1:
		node.global_position.y = node_y
		queue_free()
