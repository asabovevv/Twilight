extends Node2D

@export var my_camera : Camera2D

# Overlay
var vignette : ColorRect
var vignette_color : Color = Color(0, 0, 0, 0)
var vignette_intensity : float = 0.3

var screen_fade : ColorRect
var screen_fade_target : float = 0
var screen_fade_color : Color = Color.BLACK

# Shake
var shake_power : float = 0
var shake_speed : float = 45
var shake_vertical : bool = true
var shake_time : float = 0

func _ready() -> void:
	TWILIGHT.camera = self
	
	vignette = my_camera.get_child(0)
	
	screen_fade = my_camera.get_child(1)
	screen_fade.self_modulate.a = 1

func _process(delta: float) -> void:
	# Shake
	if shake_time < 0:
		pass
		my_camera.position = Vector2.ZERO
	
	else:
		shake_time -= delta
		var _w : float = sin(shake_time * shake_speed) * shake_power
		var _s : Vector2
		
		my_camera.position = Vector2((1-float(shake_vertical))*_w, float(shake_vertical)*_w)
	
	RenderingServer.global_shader_parameter_set("position", my_camera.global_position)
	
	# Screen Fade
	screen_fade.self_modulate.a = move_toward(screen_fade.self_modulate.a,
											  TWILIGHT.camera.screen_fade_target,
											  delta*5)
	screen_fade.modulate = screen_fade_color

func cam_shake(_duration : float, _power : float, _vertical : bool = true, _speed : float = 45) -> void:
	shake_time = _duration
	shake_power = _power
	shake_speed = _speed
	shake_vertical = _vertical
