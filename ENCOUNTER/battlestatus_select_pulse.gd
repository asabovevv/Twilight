class_name BattleStatusSelectPulse extends Sprite2D

@export var duration : float = 0.5
@export var delay : float = 0.5

var _tween : Tween

func _ready() -> void:
	_tween = create_tween()
	_tween.pause()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.tween_property(self, "modulate:a", 1, duration)
	_tween.tween_property(self, "modulate:a", 0, duration)
	_tween.tween_interval(delay)
	_tween.set_loops()

func start_pulse():
	_tween.play()
	show()

func stop_pulse():
	_tween.stop()
	hide()
