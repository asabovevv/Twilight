extends AnimationPlayer

@export var sound : AudioStreamPlayer
@export var next_image : Texture2D

func _ready() -> void:
	sound.volume_linear = Global.volume_levels[Global.Volumes.AmbientMusic]
	play("Pinkspace_Intro")

func _set_image() -> void:
	$ImageDisplay.texture = next_image
