class_name Action

enum Target { SELF, ALLY, ALLY_NOT_SELF, ALL_ALLIES, ENEMY, ALL_ENEMIES, ALLY_OR_ENEMY, DEAD_ALLY, ALL_DEAD_ALLIES }

var name : String
var description : String
var target_type : Target
var can_overworld_use : bool
var battle_effects : Array[Effect] = []
var overworld_effects : Array[Effect] = []

# fuckass language doesn't let you set multiple constructors
func _init(
	_name : String,
	_description : String,
	_target_type : Target,
	_can_overworld_use : bool = false,
	_battle_effects : Array[Effect] = [],
	_overworld_effects : Array[Effect] = []
):
	name = _name
	description = _description
	target_type = _target_type
	can_overworld_use = _can_overworld_use
	battle_effects = _battle_effects
	overworld_effects = _overworld_effects
