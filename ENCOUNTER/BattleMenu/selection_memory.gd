class_name SelectionMemory

var saved_state : MenuState.State
var saved_index : int
var saved_page : int = 0

func _init(_saved_state : MenuState.State, _saved_index : int, _saved_page : int = 0):
	saved_state = _saved_state
	saved_index = _saved_index
	saved_page = _saved_page
