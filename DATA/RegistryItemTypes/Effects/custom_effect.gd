class_name CustomEffect extends Effect

var _fn : Callable   # func(user, target, ctx) -> void

func _init(fn : Callable) -> void:
	_fn = fn

func execute(user : Actor, target : Actor, ctx : EncounterContext) -> void:
	# simply call the provided function
	await _fn.call(user, target, ctx)
