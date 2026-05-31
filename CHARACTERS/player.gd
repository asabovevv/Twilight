extends CharacterBody2D

var moving : bool = false
var running : bool = false
var target : Vector2
var speed : float = 200.0
var base_speed : float = 200
var cutscene : bool = false
var last_places : Array[Vector2]
var last_sprites : Array[int]
var i_entity : Node
var fade_target : float = 0
var fade_color : Color = Color.BLACK
var dialogue_active : bool = false

var shake_power : float = 0
var shake_speed : float = 45
var shake_vertical : bool = true
var shake_time : float = 0

var frame : float = 0
var frame_sequence : Array = [  [0, 1, 0, 2],
								[0, 1, 0, 2],
								[0, 1, 0, 2],
								[0, 1, 0, 2] ]
var walk_sprites : Array
var sprite : int

var is_fullscreen = false
var ow_menu = preload("res://UI/OverworldMenu/overworld_menu.tscn")

@export var party_lightmode : bool = false

@export var tile_node : Node2D
@export var collision_tile_layer : TileMapLayer
@export var entrances : Node2D

@export_category("Vignette")
@export var vignette_color : Color = Color(0, 0, 0, 1)
@export var vignette_intensity : float = 0.3

@export_category("Node Connections")
@export var fade : ColorRect
@export var camera : Camera2D
@export var vignette : ColorRect
@export var sprites : Node2D
@export var ui : Node2D
var camera_bounds : Vector4 = Vector4(320, 240, 320, 240)

const hbox_offset = 16
const mood_colors = [Color8(0, 0, 0, 0), Color8(74, 97, 213, 255), Color8(255, 60, 56, 255), Color8(254, 225, 56, 255)]
enum Moods { Neutral, Sad, Angry, Happy }
var mood : int = 0

func _ready() -> void:
	_enter_room()
	
	# Set Sprites + Emotion
	new_sprites()
	set_emotion_string(TWILIGHT.Party_Order[0].Emotion.name)
	
	# Set + Snap position and party member positions
	global_position = _grid_snap(global_position)
	target = global_position
	for i in range(20):
		last_places.append(global_position)
		last_sprites.append(sprite)
	
	# UI + Collision positions
	$StaticBody2D.global_position = target
	ui.global_position = $Camera2D.global_position - Vector2(320, 240)
	
	# Test for function collision at spawn tile
	$FunctionCast.global_position = global_position
	$FunctionCast.force_raycast_update()
	if $FunctionCast.is_colliding():
		var collider = $FunctionCast.get_collider()
		collider.execute()
	
	# Set Viginette
	vignette.material.set_shader_parameter("vignette_color", vignette_color)
	vignette.material.set_shader_parameter("intensity", vignette_intensity)
	
	# Tileset Camera Bounds
	var rect : Rect2i = _set_camera_bounds()
	var xmin : int = rect.position.x+1
	var xmax : int = xmin + rect.size.x-2
	var ymin : int = rect.position.y+1
	var ymax : int = ymin + rect.size.y-2
	camera_bounds = Vector4(xmin*32 + 320, xmax*32 - 320, ymin*32 + 240, ymax*32 - 240)
	$Camera2D.global_position = Vector2(clamp(global_position.x, camera_bounds.x, camera_bounds.y),
										clamp(global_position.y, camera_bounds.z, camera_bounds.w))
	
	# Room Fade In
	fade.self_modulate.a = 1

func _process(delta: float) -> void:
	if !cutscene:
		_get_inputs(delta)
	_move_and_animate(delta)
	
	fade.self_modulate.a = move_toward(fade.self_modulate.a, fade_target, delta*5)
	fade.modulate = fade_color
	
	if Input.is_action_just_pressed("Fullscreen"):
		if !is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			is_fullscreen = false

func _set_walksprite(_sprite : int) -> void:
	for i in walk_sprites:
		i.visible = false
		i.frame = 0
	
	sprite = _sprite
	walk_sprites[sprite].visible = true

func set_emotion_string(_mood_name : String) -> void:
	match _mood_name:
		"Neutral":
			mood = 0
		"Sad":
			mood = 1
		"Angry":
			mood = 2
		"Happy":
			mood = 3
	
	if TWILIGHT.Party_Order[0].Name == "AUBREY":
		for i in walk_sprites:
			i.material.set_shader_parameter("emotion", mood_colors[mood])
	else:
		new_sprites()
		
		for i in walk_sprites:
			i.material.set_shader_parameter("emotion", mood_colors[mood])
	
	# Adjust stats
	speed = base_speed * TWILIGHT.emotion( _mood_name ).walkspeed[0]
	running = (speed > base_speed)

func _move_and_animate(delta) -> void:
	
	global_position = Vector2(move_toward(global_position.x, target.x, delta*speed),
							  move_toward(global_position.y, target.y, delta*speed) )
	
	shake_time -= delta
	var _w : float = sin(shake_time * shake_speed) * shake_power
	var _s : Vector2
	if shake_time <= 0:
		_s = Vector2.ZERO
	else:
		_s = Vector2((1-float(shake_vertical))*_w, float(shake_vertical)*_w)
	
	$Camera2D.global_position = Vector2(clamp(global_position.x, camera_bounds.x, camera_bounds.y) + _s.x,
										clamp(global_position.y, camera_bounds.z, camera_bounds.w) + _s.y)
	RenderingServer.global_shader_parameter_set("position", $Camera2D.global_position)
	
	$StaticBody2D.global_position = target
	ui.global_position = $Camera2D.global_position - Vector2(320, 240)
	
	if (global_position == target):
		moving = false
	else:
		frame += delta * 6 * (float(running)+1)
		if floor(frame) >= frame_sequence[sprite].size():
			frame -= floor(frame)
			
	walk_sprites[sprite].frame = frame_sequence[sprite][floor(frame)]

func _attempt_move(dir : Vector2) -> bool:	
	if collision_tile_layer != null:
		if collision_tile_layer.get_cell_tile_data(Vector2i(floor((global_position + dir)/32) )) != null:
			return false
	
	$FunctionCast.position = dir
	$FunctionCast.force_raycast_update()
	if $FunctionCast.is_colliding():
		var collider = $FunctionCast.get_collider()
		collider.execute()
		if collider.collidable:
			return false
	
	$CollisionCast.position = dir
	$CollisionCast.force_raycast_update()
	if $CollisionCast.is_colliding():
		if $CollisionCast.get_collider().get_parent().collidable:
			return false
	
	target = _grid_snap(global_position) + dir
	moving = true
	return true

func _get_inputs(delta):
	# Test if almost at target
	var pos = global_position
	global_position = Vector2(move_toward(global_position.x, target.x, delta*speed),
							  move_toward(global_position.y, target.y, delta*speed) )
	if global_position == target:
		moving = false
	global_position = pos
	
	# Move
	if !moving:
		var hinput = sign(Input.get_axis("Left", "Right") )
		var vinput = sign(Input.get_axis("Up", "Down") )
		var spr = sprite
		
		if hinput:
			_set_walksprite(hinput+1)
			$InteractCast.position = Vector2(32 * hinput, 0)
		elif vinput:
			_set_walksprite(vinput+2)
			$InteractCast.position = Vector2(0, 32 * vinput)
		
		if hinput != 0:
			if _attempt_move(Vector2(32 * hinput, 0)):
				last_places.append(global_position)
				last_places.remove_at(0)
				last_sprites.append(spr)
				last_sprites.remove_at(0)
		elif vinput != 0:
			if _attempt_move(Vector2(0, 32 * vinput)):
				last_places.append(global_position)
				last_places.remove_at(0)
				last_sprites.append(spr)
				last_sprites.remove_at(0)
		else:
			frame = 0.9
		
		if Input.is_action_just_pressed("Cancel"):
			# overworld menu sequence
			cutscene = true
			var menu = ow_menu
			ui.add_child(menu.instantiate())
			ui.get_child(0).player = self
			return
		
		if Input.is_action_just_pressed("Confirm"):
			# dialogue sequence
			for i in range(2):
				$InteractCast.force_raycast_update()
				if $InteractCast.is_colliding():
					i_entity = $InteractCast.get_collider().get_parent()
					if i_entity.interactable == true:
						i_entity.interacted = true
						var menu = load("res://UI/Dialogue/DialogueBox/dialogue_box.tscn")
						ui.add_child(menu.instantiate())
						ui.get_child(0).player = self
						ui.get_child(0).dialogue.append_array( i_entity.dialogue )
						
						dialogue_active = true
						cutscene = true
						frame = 0.9
						return
				
				$InteractCast.global_position = global_position
		
		if Input.is_action_just_pressed("Tag"):
			# overworld menu sequence
			cutscene = true
			var menu = load("res://UI/Tag/tag_menu.tscn")
			ui.add_child(menu.instantiate())
			ui.get_child(0).player = self
			return

func new_sprites() -> void:
	for i in sprites.get_children():
		i.queue_free()
	
	var sprite_set = load(TWILIGHT.Party_Order[0].Path + "OW_sprites.tscn")
	
	sprite_set = sprite_set.instantiate()
	sprites.add_child(sprite_set)
	walk_sprites = [sprite_set.get_child(0), sprite_set.get_child(1), sprite_set.get_child(2), sprite_set.get_child(3)]

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)

func _enter_room() -> void:
	if entrances != null:
		for i in entrances.get_children():
			if i.ID == TWILIGHT.entrance:
				global_position = i.global_position
				if i.fader != null:
					i.fader.target_fade = i.set_fader
				if (i.npc_deactivate != null):
					i.npc_deactivate.global_position.y += 64000
				if i.player_collision_tile != null:
					collision_tile_layer = i.player_collision_tile

func _set_camera_bounds() -> Rect2i:
	if tile_node != null:
		
		for i in tile_node.get_children():
			if i is TileMapLayer:
				return i.get_used_rect()
	
	return Rect2i(0, 0, 640, 480)

func shake(_duration : float, _power : float, _vertical : bool = true, _speed : float = 45) -> void:
	shake_time = _duration
	shake_power = _power
	shake_speed = _speed
	shake_vertical = _vertical
