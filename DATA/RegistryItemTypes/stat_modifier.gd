class_name StatModifier

var type : String
var multiplier : float
var flat_bonus : int

func _init(_type : String, _multiplier : float = 1, _flat_bonus : int = 0):
	self.type = _type
	self.multiplier = _multiplier
	self.flat_bonus = _flat_bonus

## Applies the stat modifier to the given [param value].
func apply(value : int) -> int:
	return round(value * multiplier + flat_bonus)
