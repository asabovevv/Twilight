class_name StatModifier

var type : String
var multiplier : float
var flat_bonus : int

func _init(type : String, multiplier : float = 1, flat_bonus : int = 0):
	self.type = type
	self.multiplier = multiplier
	self.flat_bonus = flat_bonus
