class_name PartyState

signal selection_changed(old_index, new_index)

var members : Array[PartyMember]

var current_selected_index : int = -1

func _init(_members : Array[PartyMember]):
	members = _members

func get_leader() -> PartyMember:
	return members[0]

func current_selected() -> PartyMember:
	return members[current_selected_index] if current_selected_index >= 0 else null

func select_first():
	_set_selected(0)

func select_none():
	_set_selected(-1)

# temporary behavior
func select_next():
	_set_selected(0 if current_selected_index < 0 else (current_selected_index + 1) % members.size())

func back() -> bool:
	if current_selected_index < 0:
		return false
	_set_selected(current_selected_index - 1)
	return current_selected_index >= 0

func _set_selected(index : int):
	var old = current_selected_index
	current_selected_index = index
	selection_changed.emit(old, index)
