extends Node2D

@export var player : CharacterBody2D
@export var line_position : int = 0
@export var auto_delete : bool = true
@export var order_swap : bool = true

var frame : float = 0
var frame_sequence : Array = [  [0, 1, 0, 2],
								[0, 1, 0, 2],
								[0, 1, 0, 2],
								[0, 1, 0, 2] ]
var walk_sprites : Array
var sprite : int
const mood_colors = [Color8(0, 0, 0, 0), Color8(109, 74, 230, 255), Color8(255, 60, 56, 255), Color8(254, 225, 56, 255)]
const mood_strings = ["Neutral", "Sad", "Angry", "Happy"]

var last_pos : Vector2 = Vector2.ZERO
var can_move : int = 2
var last_sprite : Node = null

var freeing : bool = false

func _ready() -> void:
	if (auto_delete) && (TWILIGHT.Party_Size < (line_position+2)):
		queue_free()
		freeing = true
	
	await get_tree().create_timer(0.03).timeout
	global_position = player.global_position
	last_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !freeing:
		can_move -= 1
		if (player.moving) || (last_pos != global_position):
			can_move = 3
		
		if can_move > 0:
			frame = player.frame
			
			global_position = Vector2(move_toward(global_position.x, player.last_places[19-line_position].x, delta*player.speed),
									  move_toward(global_position.y, player.last_places[19-line_position].y, delta*player.speed))
			
			for i in range(walk_sprites.size()):
				walk_sprites[i].visible = (player.last_sprites[19-line_position] == i)
				walk_sprites[i].frame = frame_sequence[sprite][frame]
		else:
			for i in range(walk_sprites.size()):
				walk_sprites[i].frame = 0
		
		for i in range(walk_sprites.size()):
			walk_sprites[i].material.set_shader_parameter("emotion", TWILIGHT.Party_Order[line_position+1].Emotion.color)
		if (player.walk_sprites[0] != last_sprite) && order_swap:
			new_sprites()
		last_sprite = player.walk_sprites[0]
		
		last_pos = global_position

func new_sprites() -> void:
	get_child(1).queue_free()
	
	var path1 : String = TWILIGHT.Party_Order[line_position+1].Path + TWILIGHT.Party_Order[line_position+1].Name
	
	var sprites = load(path1 + "_OW_sprites.tscn")
	sprites = sprites.instantiate()
	add_child(sprites)
	
	walk_sprites = [sprites.get_child(0), sprites.get_child(1), sprites.get_child(2), sprites.get_child(3)]
	for i in range(walk_sprites.size()):
			walk_sprites[i].material.set_shader_parameter("emotion", TWILIGHT.Party_Order[line_position+1].Emotion.color)
