class_name FightRunMenu extends Menu

func _ready() -> void:
	_options = ["Fight", "Run"]
	_cursor_positions = [Vector2i(253, 407), Vector2i(253, 451)]
	_open_position = Vector2.ZERO
	_closed_position = Vector2(0, 95)

func move_cursor(direction : Vector2i):
	var old = cursor_index
	cursor_index = (cursor_index + direction.y + _options.size()) % _options.size()
	update_cursor()
	if old != cursor_index:
		Audio.play_sfx("SE_move1", 0.9)
		
func on_select():
	cursor_sprite.stop_bounce()
	Audio.play_sfx("SE_select", 0.9)
	if cursor_index == 0:
		context.turn.on_select_fight()
	else:
		context.turn.on_select_run()
