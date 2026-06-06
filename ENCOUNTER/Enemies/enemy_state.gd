class_name EnemyState

signal selection_changed(old_index, new_index)

var enemies : Array[Enemy]

var current_selected_index = -1

func _init(_enemies : Array[Enemy]):
	enemies = _enemies

func current_selected() -> Enemy:
	return enemies[current_selected_index] if current_selected_index >= 0 else null

func select_first():
	_set_selected(0)

# temporary behavior
func select_next():
	_set_selected(0 if current_selected_index < 0 else (current_selected_index + 1) % enemies.size())

func select_none():
	_set_selected(-1)

func _set_selected(index : int):
	var old = current_selected_index
	current_selected_index = index
	selection_changed.emit(old, index)
