class_name QueuedAction

var user : Actor
var action : Action
var target : Actor

func _init(_user : Actor, _action : Action, _target : Actor = null):
	user = _user
	action = _action
	target = _target
