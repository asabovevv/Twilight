class_name PowerBar extends Node2D

@export var power_num : Label
@export var power_bar : Sprite2D
@export var power_bar_dots : Sprite2D

var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx
	context.state.power_changed.connect(_on_update)
	
func _on_update(value : int):
	power_num.text = "%02d" % value
	power_bar.region_rect = Rect2(0, ceil(value / 3) * 45, power_bar.region_rect.size.x, power_bar.region_rect.size.y)
	power_bar_dots.frame = value

func _exit_tree() -> void:
	context.state.power_changed.disconnect(_on_update)
