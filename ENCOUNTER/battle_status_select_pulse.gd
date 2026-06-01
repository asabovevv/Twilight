extends Sprite2D

## Handles the pulse effect whenever a party member is selecting their action

var tween : Tween

func _ready() -> void:
	tween = create_tween()
	tween.pause()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1, 0.5)
	tween.tween_property(self, "modulate:a", 0, 0.5)
	tween.tween_interval(0.5)
	tween.set_loops()

func start_pulse() -> void:
	tween.play()
	show()

func stop_pulse() -> void:
	tween.pause()
	hide()
