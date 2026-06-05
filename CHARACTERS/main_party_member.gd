extends CharacterBody2D

# MOVEMENT
var moving : bool = false
var running : bool = false
var speed : float = 200.0
var base_speed : float = 200

var target_position : Vector2
var last_positions : Array[Vector2]
var last_frames : Array[int]

const hbox_offset = 16

# INTERACTION + CUTSCENES
var in_cutscene : bool = false
var in_cutscene_last : bool = false

var interactable_node : Node
var dialogue_active : bool = false

# SCREEN
var camera_bounds : Vector4 = Vector4(320, 240, 320, 240)

# ANIMATION
var frame : float = 0
var frame_sequence : Array = [ 0, 1, 0, 2 ]
var character_sprites : Array
var sprite : int

const mood_colors = [Color8(0, 0, 0, 0), Color8(74, 97, 213, 255), Color8(255, 60, 56, 255), Color8(254, 225, 56, 255)]
const bow_mood_colors = [Color8(255, 255, 255, 255), Color8(242, 203, 255, 255),
						 Color8(142, 193, 255, 255), Color8(141, 106, 181, 255),
						 Color8(235, 76, 71, 255), Color8(137, 85, 105, 255),
						 Color8(225, 184, 48, 255), Color8(211, 86, 86, 255)]
enum Moods { Neutral, Sad, Angry, Happy }
var mood : int = 0
signal mood_changed()

# Exports
@export var vignette_color : Color = Color(0, 0, 0, 1)
@export var vignette_intensity : float = 0.3
@export var ui_node : Node2D
@export var tile_node : Node2D
@export var collision_tile_layer : TileMapLayer
@export var entrances_node : Node2D

@export_category("Node Connections")
@export var sprites : Node2D
@export var collider : StaticBody2D
@export var collidercast : RayCast2D
@export var functioncast : RayCast2D
@export var interactcast : RayCast2D

func _ready() -> void:
	_enter_room()
	
	# Set Sprites + Emotion
	new_sprites()
	set_emotion_by_name(Twilight.Party.current_party[0].current_emotion.name)
	
	# Set + Snap position
	global_position = _grid_snap(global_position)
	target_position = global_position
	collider.global_position = target_position
	# Setup party member positions
	for i in range(20):
		last_positions.append(global_position)
		last_frames.append(sprite)
	
	# Set camera on top of player within camera bounds
	_set_camera_bounds()
	Twilight.camera.global_position = Vector2(clamp(global_position.x, camera_bounds.x, camera_bounds.y),
											  clamp(global_position.y, camera_bounds.z, camera_bounds.w))
	
	# Tell GUI to load neccessary menus
	Twilight.ui.add_ui("res://UI/OverworldMenu/overworld_menu.tscn")
	Twilight.ui.add_ui("res://UI/Dialogue/DialogueBox/dialogue_box.tscn")
	Twilight.ui.add_ui("res://UI/Tag/tag_menu.tscn")
	
	# Test for function collision at spawn tile
	_check_special_collision(functioncast, Vector2.ZERO, true)
	
	# Set Viginette
	Twilight.camera.vignette.material.set_shader_parameter("vignette_color", vignette_color)
	Twilight.camera.vignette.material.set_shader_parameter("intensity", vignette_intensity)

func _process(delta: float) -> void:
	if !in_cutscene:
		_get_inputs(delta)
	_move_and_animate(delta)
	
	if Input.is_action_just_pressed("Fullscreen"):
		Twilight.toggle_fullscreen()
	
	in_cutscene_last = in_cutscene

func _set_walksprite(_sprite : int) -> void:
	for i in character_sprites:
		i.visible = false
		i.frame = 0
	
	sprite = _sprite
	character_sprites[sprite].visible = true

func set_emotion_by_name(_mood_name : String) -> void:
	match _mood_name:
		"Neutral":
			mood = 0
		"Sad":
			mood = 1
		"Angry":
			mood = 2
		"Happy":
			mood = 3
	
	if Twilight.Party.current_party[0].data.key == "aubrey":
		for i in character_sprites:
			i.material.set_shader_parameter("emotion", mood_colors[mood])
			i.material.set_shader_parameter("bow_emotion_highlight", bow_mood_colors[mood*2])
			i.material.set_shader_parameter("bow_emotion_shadow", bow_mood_colors[mood*2+1])
	else:
		for i in character_sprites:
			i.material.set_shader_parameter("emotion", mood_colors[mood])
	
	# Adjust stats
	speed = base_speed * _emotion_walk_mult(_mood_name)
	running = (speed > base_speed)

	mood_changed.emit()

## Walk speed multiplier for the named emotion (from the Registry). Defaults to 1.0 when the
## emotion carries no WALK_SPEED modifier.
# TODO: this is most likely temporary and can be improved
func _emotion_walk_mult(_mood_name : String) -> float:
	var emo := Registry.get_emotion(_mood_name.to_lower())
	if emo:
		for m in emo.modifiers:
			if m.type == StatType.WALK_SPEED:
				return m.multiplier
	return 1.0

func _move_and_animate(delta) -> void:
# MOVEMENT
	# Update player pos
	global_position = Vector2(move_toward(global_position.x, target_position.x, delta*speed),
							  move_toward(global_position.y, target_position.y, delta*speed) )
	collider.global_position = target_position
	
	# Update cam pos
	Twilight.camera.global_position = Vector2(clamp(global_position.x, camera_bounds.x, camera_bounds.y),
										clamp(global_position.y, camera_bounds.z, camera_bounds.w))
	
# ANIMATION
	# Only allow movement when locked to a tile
	if (global_position == target_position):
		moving = false
	else:
		frame += delta * 6 * (float(running)+1)
		if floor(frame) >= 4:
			frame -= floor(frame)
	
	# Animate character
	character_sprites[sprite].frame = frame_sequence[floor(frame)]

func _attempt_move(dir : Vector2) -> bool:	
	# Check if tile in input direction
	if collision_tile_layer != null:
		if collision_tile_layer.get_cell_tile_data(Vector2i(floor((global_position + dir)/32) )) != null:
			return false
	
	# Check for special colliders
	if _check_special_collision(functioncast, dir, true):
		return false
	if _check_special_collision(collidercast, dir, false):
		return false
	
	# If no obstruction, move
	target_position = _grid_snap(global_position) + dir
	moving = true
	return true

func _check_special_collision(caster : RayCast2D, offset : Vector2, executable : bool) -> bool:
	caster.position = offset
	caster.force_raycast_update()
	if caster.is_colliding():
		var _collider = caster.get_collider()
		
		if executable:
			_collider.execute()
			if _collider.has_collision:
				return true
		else:
			if _collider.get_parent().has_collision:
				return true
	return false

func _get_inputs(delta):
	# Test if almost at target_position
	var pos = global_position
	global_position = Vector2(move_toward(global_position.x, target_position.x, delta*speed),
							  move_toward(global_position.y, target_position.y, delta*speed) )
	if global_position == target_position:
		moving = false
	global_position = pos
	
	# Move
	if !moving:
		var hinput = sign(Input.get_axis("Left", "Right") )
		var vinput = sign(Input.get_axis("Up", "Down") )
		var spr = sprite
		
		# Place Interactcast in front of player facing direction
		if hinput:
			_set_walksprite(hinput+1)
			interactcast.position = Vector2(32 * hinput, 0)
		elif vinput:
			_set_walksprite(vinput+2)
			interactcast.position = Vector2(0, 32 * vinput)
		
		# Attempt to begin moving to another tile
		if hinput != 0:
			if _attempt_move(Vector2(32 * hinput, 0)):
				last_positions.append(global_position)
				last_positions.remove_at(0)
				last_frames.append(spr)
				last_frames.remove_at(0)
		elif vinput != 0:
			if _attempt_move(Vector2(0, 32 * vinput)):
				last_positions.append(global_position)
				last_positions.remove_at(0)
				last_frames.append(spr)
				last_frames.remove_at(0)
		else:
			frame = 0.9
		
		# overworld menu
		if Input.is_action_just_pressed("Cancel"):
			in_cutscene = true
			Twilight.ui.activate_ui(0, self)
			return
		
		# interact with npc
		if Input.is_action_just_pressed("Confirm"):
			
			# Check tile infront of where player is facing, then current tile
			var ic_pos : Vector2 = interactcast.position
			for i in range(2):
				interactcast.force_raycast_update()
				if interactcast.is_colliding():
					interactable_node = interactcast.get_collider().get_parent()
					
					# If interactable node can be interacted with
					if interactable_node.interactable == true && !in_cutscene_last:
						
						# If interaction type is dialogue
						if interactable_node.interaction_type == NPCBasic.InteractionType.Dialogue:
							
							interactable_node.interacting = true
							
							# Set npc's dialogue tree to their current interaction and make ui
							Twilight.ui.activate_ui_textbox(1, self, interactable_node.set_dialogue_tree_new_interaction())
							interactable_node.interacted_count += 1
							
							dialogue_active = true
							in_cutscene = true
							
							frame = 0.9
							return
							
						else: # If interaction type is Runs_Script
							
							## TODO: alongside cutscene rework
							interactable_node.interacting = true
							load( interactable_node.interact_script_path )
				
				interactcast.global_position = global_position
			
			interactcast.position = ic_pos
		
		# tag menu
		if Input.is_action_just_pressed("Tag"):
			in_cutscene = true
			Twilight.ui.activate_ui(2, self)
			return

func new_sprites() -> void:
	for i in sprites.get_children():
		i.queue_free()
	
	var sprite_set = load(Twilight.Party.current_party[0].data.asset_path + "OW_sprites.tscn")
	
	sprite_set = sprite_set.instantiate()
	sprites.add_child(sprite_set)
	character_sprites = [sprite_set.get_child(0), sprite_set.get_child(1), sprite_set.get_child(2), sprite_set.get_child(3)]

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)

func _enter_room() -> void:
	if entrances_node != null:
		for i in entrances_node.get_children():
			if i.ID == Twilight.entrance:
				global_position = i.global_position
				if i.fader != null:
					i.fader.target_fade = i.set_fader
				if (i.npc_deactivate != null):
					i.npc_deactivate.global_position.y += 64000
				if i.player_collision_tile != null:
					collision_tile_layer = i.player_collision_tile

func _set_camera_bounds() -> void:
	var rect : Rect2i = Rect2i(0, 0, 640, 480)
	
	# If there's a reference tileset, get its size
	if tile_node != null:
		
		for i in tile_node.get_children():
			if i is TileMapLayer:
				rect = i.get_used_rect()
				break
	
	# Adjust so that the outer borders of the map aren't included
	var xmin : int = rect.position.x+1
	var xmax : int = xmin + rect.size.x-2
	var ymin : int = rect.position.y+1
	var ymax : int = ymin + rect.size.y-2
	
	# Set cam bounds
	camera_bounds = Vector4(xmin*32 + 320, xmax*32 - 320, ymin*32 + 240, ymax*32 - 240)
