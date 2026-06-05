# NOTE: First layer of vframes are default animation. Second layer are talking alts.

@tool

class_name NPCBasic
extends Node2D

# Connections
@onready var sprite : Sprite2D = $Sprite2D
@onready var collider : StaticBody2D = $StaticBody2D
@onready var movingcollider : StaticBody2D = $StaticBody2D_2
@onready var raycast : RayCast2D = $RayCast2D

# Preferences
var rand : RandomNumberGenerator
@export var editor_grid_snap : bool = true
@export var hitbox_scale : Vector2i = Vector2i.ONE
@export var hitbox_offset : Vector2i = Vector2i.ZERO
@export var sprite_offset : Vector2
@export var has_collision : bool = true

@export var sprite_img : Texture2D:
	set(value):
		sprite_img = value
		if is_node_ready() and sprite:
			sprite.texture = sprite_img
		elif has_node("Sprite2D"):
			get_node("Sprite2D").texture = sprite_img

@export var sprite_hvframes : Vector2i = Vector2i.ONE:
	set(value):
		sprite_hvframes = value
		if is_node_ready() and sprite:
			sprite.hframes = sprite_hvframes.x
			sprite.vframes = sprite_hvframes.y

# Dialogue
@export_category("Interaction")
@export var interactable : bool = false
@export var interact_script_path : String

enum InteractionType { Dialogue, Runs_Script }
@export var interaction_type : InteractionType = InteractionType.Dialogue

@export var has_talkframes : bool = false
@export var max_unique_interactions : int = 1
var interacted_count : int = 0
var interacting : bool = false

## Array of DialogueSequences. DialogueSequences should contain at least 1 branch of dialogue.
## Branches of dialogue are grabbed via their header name from the Twilight.d dictionary.
@export var dialogue : Array[DialogueSequence] = [DialogueSequence.new()]

## When dialogue is initiated, the game checks for flags listed here.
## If the flag is TRUE, it runs the specified DialogueSequence in dialogue[]
@export var dialogue_flag_triggers : Array[DialogueFlagTrigger]

# Movement
@export_category("Movement")
@export var moves : bool = false
var target : Vector2
var origin : Vector2

@export var action_loop : Array[NpcAction]
var action_loop_phase : int = 9999
var act_repeat : int = 0
var act_wait : float = 0
var act_moving : bool = false

# Animation
@export_category("Animation")
@export var anim_default : bool = true
@export var anim_speed : float = 2.0
@export var talk_anim_speed : float = 15.0
var frame : float = 0.0
var local_time : float = 0.0

func _ready() -> void:
	rand = RandomNumberGenerator.new()
	
	# Sprite setup
	sprite.position = sprite_offset
	sprite.texture = sprite_img
	sprite.hframes = sprite_hvframes.x
	sprite.vframes = sprite_hvframes.y
	
	# Collider setup
	collider.scale = hitbox_scale
	var tile_off : Vector2 = floor(hitbox_scale*2 - hitbox_scale)*0.5 - Vector2(0.5, 0.5)
	var offset : Vector2 = Vector2( fposmod(tile_off.x, 1.0), fposmod(tile_off.y, 1.0) )
	collider.position = (offset + Vector2( hitbox_offset )) * 32
	
	# Used for movement
	origin = global_position
	target = global_position
	
	# Remove collider if no collision
	if !has_collision && !Engine.is_editor_hint():
		collider.queue_free()
		movingcollider.queue_free()
	
	# Runs additional setup script
	_custom_ready()

func _process(delta: float) -> void:
	
	if Engine.is_editor_hint():
		if editor_grid_snap:
			global_position = _grid_snap(global_position)
		
		sprite.position = sprite_offset
		
		collider.scale = hitbox_scale
		var tile_off : Vector2 = floor(hitbox_scale*2 - hitbox_scale)*0.5 - Vector2(0.5, 0.5)
		var offset : Vector2 = Vector2( fposmod(tile_off.x, 1.0), fposmod(tile_off.y, 1.0) )
		collider.position = (offset + Vector2( hitbox_offset )) * 32
		
		movingcollider.global_position = collider.global_position
		
		_animate(delta)
	
	else:
		
		if moves && !interacting:
			_move(delta)
			
			if has_collision:
				collider.global_position = _grid_snap(global_position)
				movingcollider.global_position = target
		
		_custom_animate() # Remember to handle both colliders
		local_time += delta
		
		_animate(delta)

func _move(delta: float) -> void:
	act_wait -= delta
	
	# Once previous iteration of Action is done
	if !act_moving && act_wait <= 0:
		
		# If action done repeating, go to next action
		var current_action
		if act_repeat <= 1:
			action_loop_phase += 1
			
			# If at the end of action loop, go back to start
			if action_loop_phase >= action_loop.size():
				action_loop_phase = 0
			
			current_action = action_loop[action_loop_phase]
			act_repeat = current_action.repeat_count
			
		else:
			current_action = action_loop[action_loop_phase]
			act_repeat -= 1
		
		# Begin Action
		match current_action.action:
			# MOVE
			current_action.ActionType.move:
				
				raycast.position = Vector2(current_action.move_to) * 32
				raycast.force_raycast_update()
				if !raycast.is_colliding():
					
					target = global_position + Vector2(current_action.move_to) * 32
					act_moving = true
				else:
					act_wait = 0.2
					act_repeat += 1
			
			# WAIT
			current_action.ActionType.wait:
				
				act_wait = current_action.wait_time
	
	# Do actions
	
	global_position = Vector2(move_toward(global_position.x, target.x, delta * action_loop[action_loop_phase].move_speed),
							  move_toward(global_position.y, target.y, delta * action_loop[action_loop_phase].move_speed) )
	if global_position == target:
		act_moving = false

func _animate(delta : float) -> void:
	
	# Talk anim
	if interacting && has_talkframes: # Talking
		
		# moves sprite down 1 vframe at talk_anim_speed
		sprite.frame = floor(frame) + (floor( sin(local_time*talk_anim_speed) * 0.5) + 1) * (sprite.vframes+1)
	
	# Normal anim
	if anim_default:
		frame += delta * anim_speed
		if frame >= sprite.hframes:
			frame -= sprite.hframes
		sprite.frame = floor(frame)

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)

func set_dialogue_tree_new_interaction():
	
	# Check flags for special interactions
	if dialogue_flag_triggers.size() > 0:
		
		for special_branch in dialogue_flag_triggers:
			
			# Check all flags for each special dialogue branch
			var flags_required : int = special_branch.flags.size()
			var flags_true : int = 0
			for flag in special_branch.flags:
				if Twilight.Flags.get_flag( special_branch.flags[flag] ):
					flags_true += 1
			
			# If all flags for special branch are true
			if flags_true == flags_required:
				
				dialogue[ special_branch.sequence ].set_tree( dialogue[ special_branch.sequence ].branch_headers )
				return dialogue[ special_branch.sequence ]
	
	# Do basic dialogue if no flag checks succeed
	interacted_count = min(interacted_count, max_unique_interactions-1)
	
	dialogue[interacted_count].set_tree( dialogue[interacted_count].branch_headers )
	return dialogue[interacted_count]

func _custom_animate() -> void:
	pass

func _custom_ready() -> void:
	pass
