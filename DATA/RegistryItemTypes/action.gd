class_name Action

enum Target { SELF, ALLY, ALLY_NOT_SELF, ALL_ALLIES, ENEMY, ALL_ENEMIES, ALLY_OR_ENEMY, DEAD_ALLY, ALL_DEAD_ALLIES }

var name : String
var description : String
var target_type : Target
var can_overworld_use : bool
## TODO: using lambdas for skills may get out of hand quick...potentially look into alternate solutions
var overworld_use : Callable
var battle_use : Callable

# fuckass language doesn't let you set multiple constructors
func _init(
	_name : String,
	_description : String,
	_target_type : Target,
	_can_overworld_use : bool = false,
	_overworld_use : Callable = func(): pass,
	_battle_use : Callable = func(): pass
):
	name = _name
	description = _description
	target_type = _target_type
	can_overworld_use = _can_overworld_use
	overworld_use = _overworld_use
	battle_use = _battle_use
