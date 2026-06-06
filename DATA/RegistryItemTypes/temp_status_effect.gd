class_name TempStatusEffect extends StatusEffect

## A temporary status effect. Expires after the given number of [member TempStatusEffect.turns], but can be refreshed.

var turns : int
var _max_turns : int

func _init(
	_name : String,
	_description : String,
	_turns : int = 6,
	_modifiers : Array[StatModifier] = [],
	_icon : Texture2D = null
):
	super(_name, _description, _modifiers, _icon)
	_turns = turns
	_max_turns = turns

## Decreases the [member TempStatusEffect.turns] counter by 1.
func decrease_turns() -> void:
	if turns > 0:
		turns -= 1

## Refreshes the turn counter to the status effect's max turns.
func refresh_turns() -> void:
	turns = _max_turns
