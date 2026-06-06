class_name TieredStatusEffect extends TempStatusEffect

## A temporary status effect that has multiple tiers. Expires after the given number of [member TieredStatusEffect.turns], but can be refreshed.

var tier : int
var max_tier : int

# TODO: support come kind of Array[Array[StatModifier]] for tiered stat modifiers, right now they only support one StatModifier per tier

func _init(
	_name : String,
	_description : String,
	_max_tier : int,
	_turns : int = 6,
	_modifiers : Array[StatModifier] = [],
	_icon : Texture2D = null
):
	super(_name, _description, _turns, _modifiers, _icon)
	assert(_max_tier > 0)
	tier = 1
	max_tier = _max_tier

## Attempts to apply the [param new_tier] to this [TieredStatusEffect], following OMORI stacking rules.
## Returns [code]true[/code] if the tier was changed or the turn counter was refreshed.
func set_tier(new_tier : int) -> bool:
	new_tier = mini(new_tier, max_tier)
	# case 1: new tier is higher than the old tier
	# refresh the turn counter and directly set the new tier
	if new_tier > tier:
		tier = new_tier
		refresh_turns()
		return true
	# case 2: we're already at max tier
	if tier == max_tier:
		# if the tier being applied is also a max tier, refresh the turn counter
		if new_tier == max_tier:
			refresh_turns()
			return true
		# otherwise do nothing
		return false
	# case 3: the new tier is lower and we're not at max tier
	# increment the tier by one and refresh the turn counter
	tier += 1
	refresh_turns()
	return true
