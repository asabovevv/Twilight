class_name DamageEffect extends Effect

var _formula : Callable   # func(user: Actor, target: Actor) -> int
var _variance : float

func _init(formula : Callable, variance : float = 0.2) -> void:
	_formula = formula
	_variance = variance

## Damage that follows the common user.ATTACK * multiplier - target.DEFENSE formula
static func physical(multiplier : float = 1.0, variance : float = 0.2) -> DamageEffect:
	return DamageEffect.new(
		func(user : Actor, target : Actor) -> int:
			return int(user.get_current_stats()[StatType.ATTACK] * multiplier) \
				 - target.get_current_stats()[StatType.DEFENSE],
		variance)

## Damage that deals a flat number of damage, with optional variance
static func flat(amount : int, variance : float = 0.0) -> DamageEffect:
	return DamageEffect.new(
		func(_user : Actor, _target : Actor) -> int: return amount, variance
	)

func execute(user : Actor, target : Actor, ctx : EncounterContext) -> void:
	ctx.core.damage(user, target, func() -> int: return _formula.call(user, target), _variance)
