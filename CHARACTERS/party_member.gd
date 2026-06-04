extends Node2D

# MOVEMENT

var moving : bool = false
var target_position : Vector2 = Vector2.ZERO

var last_pos : Vector2 = Vector2.ZERO
var last_sprite : Node = null
var dir : float

var normal_movement : bool = true

# ANIMATION

var frame : float = 0
var frame_sequence : Array = [0, 1, 0, 2]
var character_sprites : Array
var sprite : int

const mood_colors = [Color8(0, 0, 0, 0), Color8(109, 74, 230, 255), Color8(255, 60, 56, 255), Color8(254, 225, 56, 255)]
const bow_mood_colors = [Color8(255, 255, 255, 255), Color8(242, 203, 255, 255),
						 Color8(142, 193, 255, 255), Color8(141, 106, 181, 255),
						 Color8(235, 76, 71, 255), Color8(137, 85, 105, 255),
						 Color8(225, 184, 48, 255), Color8(211, 86, 86, 255)]
const mood_strings = ["Neutral", "Sad", "Angry", "Happy"]

# Exports
@export var player : CharacterBody2D
@export var line_position : int = 0
@export var auto_delete : bool = true
@export var order_swap : bool = true

var init : bool = false

func _ready() -> void:
	if (auto_delete) && (TWILIGHT.Party.current_party.size() < (line_position+2)):
		queue_free()
		return
	
	global_position = player.global_position
	last_pos = global_position
	init = true

func _process(delta: float) -> void:
	
	if normal_movement:
		if !_move_to_target(delta):
			
			if last_pos == global_position:
				for i in range(character_sprites.size()):
					character_sprites[i].frame = 0
	
	if (player.character_sprites[0] != last_sprite) && order_swap:
		new_sprites()
	last_sprite = player.character_sprites[0]
	
	last_pos = global_position

func _move_to_target(delta : float) -> bool:
	# If not in correct grid tile, go to grid tile
	if _grid_snap(global_position) != _grid_snap(player.last_positions[19-line_position]):
		
		var distance : Vector2 = player.last_positions[19-line_position] - global_position 
		var moved_delta : float = delta*player.speed
		
		# Move in whichever direction has the greater distance
		if !moving:
			moving = true
			if abs(distance.x) > abs(distance.y):
				target_position = _grid_snap(global_position) + Vector2( sign(distance.x)*32, 0)
				dir = lerp(0, 2, int( sign(distance.x) == 1 ))
			else:
				target_position = _grid_snap(global_position) + Vector2( 0, sign(distance.y)*32)
				dir = lerp(1, 3, int( sign(distance.y) == 1 ))
		
		# If next tile reached, switch to fine movement
		if abs(target_position.x-global_position.x) <= moved_delta*2 && abs(target_position.y-global_position.y) <= moved_delta*2:
			moving = false
			return true
		
		# If not near target, move toward it
		global_position = Vector2(move_toward(global_position.x, target_position.x, moved_delta),
								  move_toward(global_position.y, target_position.y, moved_delta))
		
		# Animate
		frame += delta * 6
		if frame >= 4:
			frame -= 4
		
		for i in range(character_sprites.size()):
			if i == dir:
				character_sprites[i].frame = frame_sequence[floor(frame) ]
				character_sprites[i].visible = true
			else:
				character_sprites[i].visible = false
		
		return true
		
	# If in correct grid tile but not the exact right location
	elif global_position != player.last_positions[19-line_position]:
		
		target_position = player.last_positions[19-line_position]
		
		# Move toward target
		global_position = Vector2(move_toward(global_position.x, player.last_positions[19-line_position].x, delta*player.speed),
								   move_toward(global_position.y, player.last_positions[19-line_position].y, delta*player.speed))
		
		# If done, be done
		if round(target_position) == round(global_position):
			return true
		
		# Animate
		frame = player.frame
		
		for i in range(character_sprites.size()):
			if i == dir:
				character_sprites[i].frame = frame_sequence[floor(frame) ]
				character_sprites[i].visible = true
			else:
				character_sprites[i].visible = false
		
		return true
	
	moving = false
	return false

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)

func new_sprites() -> void:
	get_child(1).queue_free()
	
	var sprites = load(TWILIGHT.Party.current_party[line_position+1].data.asset_path + "OW_sprites.tscn")
	sprites = sprites.instantiate()
	add_child(sprites)
	
	character_sprites = [sprites.get_child(0), sprites.get_child(1), sprites.get_child(2), sprites.get_child(3)]

func _on_main_party_member_mood_changed() -> void:
	if init:
		var mood : int
		match TWILIGHT.Party.current_party[line_position-1].current_emotion.name:
			"Neutral":
				mood = 0
			"Sad":
				mood = 1
			"Angry":
				mood = 2
			"Happy":
				mood = 3
		
		if TWILIGHT.Party.current_party[line_position-1].data.key == "aubrey":
			for i in character_sprites:
				i.material.set_shader_parameter("emotion", mood_colors[mood])
				i.material.set_shader_parameter("bow_emotion_highlight", bow_mood_colors[mood*2])
				i.material.set_shader_parameter("bow_emotion_shadow", bow_mood_colors[mood*2+1])
		else:
			for i in character_sprites:
				i.material.set_shader_parameter("emotion", mood_colors[mood])
