extends Sprite2D

@export var speed : int = 1
@export var finished : bool = false
@export var next_room : String
@export var animate : bool = true
var time : float = 0
var rand = RandomNumberGenerator.new()

func _ready() -> void:
	finished = true

func _physics_process(delta: float) -> void:
	if animate:
		time += delta * speed
		if time > 3:
			time -= 3
		
		frame = time
	
	if finished:
		get_tree().change_scene_to_file(next_room)
