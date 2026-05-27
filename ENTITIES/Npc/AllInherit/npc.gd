class_name NPCBasic
extends Sprite2D

var rand : RandomNumberGenerator
@export var collidable : bool = true
@export var hbox_offset : int = 16
@export var hbox_scale : Vector2 = Vector2.ONE
@export var sprite_offset : Vector2
@export var snap : bool = true

@export_category("Dialogue")
@export var interactable : bool = true
var interacted : bool = false
@export_multiline var dialogue : Array[String] = ["|dbox|Default dialogue."]

@export_category("Movement")
@export var moves : bool = false
@export var speed : float = 200.0
var target : Vector2
var moving : bool = false
var origin : Vector2
@export var action_loop : Array
var action_loop_phase : int = 0
var wait : float = 0

@export_category("Animation")
@export var anim_default : bool = true
@export var anim_speed : float = 2.0
var _frame : float = 0.0
var time : float = 0.0
var max_frames : int = 1

func _ready() -> void:
	rand = RandomNumberGenerator.new()
	if snap:
		global_position = _grid_snap(global_position) + sprite_offset
	origin = global_position
	target = global_position - sprite_offset
	
	if hframes == 1:
		max_frames = vframes
	else:
		max_frames = hframes
	
	if collidable:
		$StaticBody2D.scale = hbox_scale
		$StaticBody2D.global_position = _grid_snap(global_position)
	
	_custom_ready()

func _process(delta: float) -> void:
	if moves && !interacted:
		_move(delta)
		if collidable:
			$StaticBody2D.global_position = _grid_snap(global_position)
	
	_animate()
	time += delta
	
	if anim_default:
		_frame += delta * anim_speed
		if _frame >= max_frames:
			_frame -= max_frames
		frame = floor(_frame)

func _move(delta: float) -> void:
	wait -= delta
	
	if !moving && wait <= 0:
		if action_loop_phase >= action_loop.size():
			action_loop_phase = 0
		
		if action_loop[action_loop_phase] is float:
			wait = action_loop[action_loop_phase]
			action_loop_phase += 1
			
		elif action_loop[action_loop_phase] is Vector2:
			$RayCast2D.global_position = global_position - sprite_offset + action_loop[action_loop_phase]*32
			$RayCast2D.force_raycast_update()
			if !$RayCast2D.is_colliding():
				target = global_position - sprite_offset + action_loop[action_loop_phase]*32
				moving = true
				action_loop_phase += 1
			else:
				wait = 0.2
	
	global_position = Vector2(move_toward(global_position.x, target.x+sprite_offset.x, delta * speed),
							  move_toward(global_position.y, target.y+sprite_offset.y, delta * speed) )
	if global_position == target-sprite_offset:
		moving = false

func _grid_snap(_position : Vector2) -> Vector2:
	return (_position + Vector2(16, 16)).snapped(Vector2(32, 32)) - Vector2(16, 16)

func _animate() -> void:
	pass

func _custom_ready() -> void:
	pass
