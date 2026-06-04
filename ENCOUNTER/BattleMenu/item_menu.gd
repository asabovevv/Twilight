class_name ItemMenu extends Menu

var grid_size : Vector2i = Vector2i(2, 2)

func _ready() -> void:
	_cursor_positions = [Vector2i(20, 43)]
	_open_position = Vector2(142, 378)
	_closed_position = Vector2(142, 482)

func move_cursor(direction : Vector2i):
	pass

func on_select():
	pass
