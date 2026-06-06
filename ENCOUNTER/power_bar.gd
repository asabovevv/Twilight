class_name PowerBar extends Node2D

@export var power_num : Label
@export var power_bar : Sprite2D
@export var power_bar_dots : Sprite2D

var context : EncounterContext

var _open_position : Vector2 = Vector2.ZERO
var _closed_position : Vector2 = Vector2(0, 92)
var _tween : Tween

func _initialize(ctx : EncounterContext):
	context = ctx
	context.state.power_changed.connect(_on_update)
	context.menu.menu_changed.connect(_on_menu_changed)
	
func _on_update(value : int):
	power_num.text = "%02d" % value
	power_bar.region_rect = Rect2(0, ceil(value / 3.0) * 45, power_bar.region_rect.size.x, power_bar.region_rect.size.y)
	power_bar_dots.frame = value
	
func _on_menu_changed(new_state : MenuState.State, immediate : bool):
	if new_state == MenuState.State.NONE:
		_move_down(immediate)
	else:
		_move_up(immediate)

func _exit_tree() -> void:
	context.state.power_changed.disconnect(_on_update)
	context.menu.menu_changed.disconnect(_on_menu_changed)

func _move_down(immediate : bool):
	if immediate:
		position = _closed_position
	else:
		if _tween: _tween.kill()
		_tween = create_tween()
		_tween.tween_property(self, "position", _closed_position, 0.2).set_trans(Tween.TRANS_SINE)

func _move_up(immediate : bool):
	if immediate:
		position = _open_position
	else:
		if _tween: _tween.kill()
		_tween = create_tween()
		_tween.tween_property(self, "position", _open_position, 0.2).set_trans(Tween.TRANS_SINE)
