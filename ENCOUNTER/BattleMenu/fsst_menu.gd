class_name FSSTMenu extends Menu

var grid_size : Vector2 = Vector2(2, 2)

func _ready() -> void:
	_options = ["Attack", "Skill", "Snack", "Toy"]
	_cursor_positions = [Vector2i(170, 405), Vector2i(350, 405), Vector2i(170, 450), Vector2i(350, 450)]
	_open_position = Vector2.ZERO
	_closed_position = Vector2(0, 95)
	
func on_open(memory : SelectionMemory):
	cursor_index = memory.saved_index
	cursor_sprite.start_bounce()
	update_cursor()
	show()

func move_cursor(direction : Vector2i):
	var old = cursor_index
	if direction == Vector2i.LEFT:
		cursor_index = maxi(cursor_index - 1, 0)
	elif direction == Vector2i.RIGHT:
		cursor_index = mini(cursor_index + 1, _cursor_positions.size() - 1)
	elif direction == Vector2i.UP && cursor_index > 1:
		cursor_index -= 2
	elif direction == Vector2i.DOWN && cursor_index < 2:
		cursor_index += 2
	update_cursor()
	if old != cursor_index:
		Audio.play_sfx("SE_move1", 0.9)

func on_select():
	Audio.play_sfx("SE_select", 0.9)
	cursor_sprite.stop_bounce()
	context.turn.on_select_action(cursor_index)

func should_close_visually(new_state : MenuState.State) -> bool:
	return new_state == MenuState.State.FSST or new_state == MenuState.State.NONE or new_state == MenuState.State.FIGHT_RUN
