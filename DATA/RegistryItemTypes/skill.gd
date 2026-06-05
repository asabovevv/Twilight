class_name Skill

var name : String
var description : String
var cost : int
var can_overworld_use : bool 

var level_requirement : int
var required_flag : int = -1 # Story flag required to unlock skill

#var in_use : bool <-- varying (not implemented)
#var menu_position : int <-- varying (not implemented)

func _init(
	_name : String,
	_description : String,
	_cost : int,
	_level_requirement : int,
	_required_flag : int = -1,
	_can_overworld_use : bool = false
):
	self.name = _name
	self.description = _description
	self.cost = _cost
	self.can_overworld_use = _can_overworld_use
	self.level_requirement = _level_requirement
	self.required_flag = _required_flag
