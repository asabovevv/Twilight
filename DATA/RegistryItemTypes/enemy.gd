class_name Enemy extends Actor

var pointer_offset : Vector2
var position_offset: Vector2i = Vector2i.ZERO
var skills : Array[String]

func get_current_stats() -> Dictionary[String, int]:
	var result : Dictionary[String, int] = base_stats.duplicate()
	# apply emotion modifiers
	for modifier in current_emotion.modifiers:
		result[modifier.type] = modifier.apply(result[modifier.type])
	# TODO: apply status effects
	return result
