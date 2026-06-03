class_name SelectionMemory

var saved_state : MenuState.State
var saved_index : int
var saved_page : int = 0

func _init(saved_state : MenuState.State, saved_index : int, saved_page : int = 0):
	self.saved_state = saved_state
	self.saved_index = saved_index
	self.saved_page = saved_page
