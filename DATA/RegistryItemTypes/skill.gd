class_name Skill extends Action

var cost : int 

var level_requirement : int
var required_flag : int = -1 # Story flag required to unlock skill

#var in_use : bool <-- varying (not implemented)
#var menu_position : int <-- varying (not implemented)

func _init(
	_name : String,
	_description : String,
	_target_type : Target,
	_cost : int,
	_level_requirement : int,
	_required_flag : int = -1,
	_can_overworld_use : bool = false,
	_battle_effects : Array[Effect] = [],
	_overworld_effects : Array[Effect] = []
):
	super(_name, _description, _target_type, _can_overworld_use, _battle_effects, _overworld_effects)
	cost = _cost
	level_requirement = _level_requirement
	required_flag = _required_flag
