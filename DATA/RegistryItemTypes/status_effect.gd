class_name StatusEffect

## Fairly incomplete, you know better how to implement these than I do

var name : String
var description : String
var can_overworld_use : bool = false
var level # Pretty sure Omori buffs/debuffs go by level like emotions do?

func _init(
	_name : String,
	_description : String,
	_icon : Texture2D,
	_level : int
):
	self.name = _name
	self.description = _description
	self.icon = _icon
	self.level = _level
