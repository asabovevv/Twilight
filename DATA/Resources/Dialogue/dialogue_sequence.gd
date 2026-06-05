class_name DialogueSequence
extends Resource

@export var branch_headers : Array[String]
var dialogue_tree : Dictionary[int, Array]

func set_tree( _branch_headers : Array[String] ):
	for i in range( _branch_headers.size() ):
		dialogue_tree[i] = Twilight.d[_branch_headers[i]].duplicate()
