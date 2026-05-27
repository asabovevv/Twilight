extends FunctionCollider

var mysound : AudioStreamPlayer

func _custom_ready() -> void:
	mysound = Global.load_sound("res://SOUNDS/SoundEffect/SE_gross.ogg", Global.Volumes.SoundEffect, self)

func execute() -> void:
	mysound.play()
