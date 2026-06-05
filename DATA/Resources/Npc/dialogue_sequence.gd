class_name DialogueSequence
extends Resource

@export var branch_headers : Array[String]
var dialogue_tree : Dictionary[int, Array]

func set_tree( _branch_headers : Array[String] ):
	for i in range( _branch_headers.size() ):
		if Twilight.d.has( _branch_headers[i] ):
			dialogue_tree[i] = Twilight.d[_branch_headers[i]].duplicate()
		else:
			push_error("Dialogue tree does not contain " + _branch_headers[i])
