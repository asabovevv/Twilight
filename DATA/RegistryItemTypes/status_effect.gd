class_name StatusEffect

## Default status effect. Gives the [member StatusEffect.modifiers] to the [Actor] until manually removed.

var name : String
var description : String
var modifiers : Array[StatModifier]
var icon : Texture2D # state icon, can be null if status effect has no state icon

func _init(
	_name : String,
	_description : String,
	_modifiers : Array[StatModifier] = [],
	_icon : Texture2D = null
):
	self.name = _name
	self.description = _description
	self.modifiers = _modifiers
	self.icon = _icon
