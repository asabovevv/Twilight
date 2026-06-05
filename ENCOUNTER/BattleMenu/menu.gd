@abstract class_name Menu extends Control

@export var cursor_sprite : CursorBounce

var _options : Array[String]
var _cursor_positions : Array[Vector2i]
var _tween : Tween
var _open_position : Vector2
var _closed_position : Vector2
var cursor_index : int = 0

var context : EncounterContext

func on_input(direction : Vector2i):
	if direction == Vector2i.ZERO:
		on_select()
	else:
		move_cursor(direction)

@abstract func move_cursor(direction : Vector2i)
@abstract func on_select()

func update_cursor():
	cursor_sprite.position = _cursor_positions[cursor_index]

func on_open(memory : SelectionMemory):
	cursor_index = 0
	cursor_sprite.start_bounce()
	update_cursor()
	show()

## TODO: this isn't great in my opinion. the open/close mechanic for menus should be improved
func should_close_visually(new_state : MenuState.State) -> bool:
	return true

func move_up(immediate : bool):
	visible = true
	if _tween: _tween.kill()
	if immediate:
		position = _open_position
	else:
		_tween = create_tween()
		_tween.tween_property(self, "position", _open_position, 0.2).set_trans(Tween.TRANS_SINE)

func move_down(new_state : MenuState.State, immediate : bool):
	if should_close_visually(new_state):
		if _tween: _tween.kill()
		if immediate:
			position = _closed_position
			visible = false
		else:
			_tween = create_tween()
			_tween.tween_property(self, "position", _closed_position, 0.2).set_trans(Tween.TRANS_SINE)
			await _tween.finished
			visible = false
