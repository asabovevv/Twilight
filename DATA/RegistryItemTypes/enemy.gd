class_name Enemy extends Actor

var data : EnemyData

func _init(_data : EnemyData):
	super(_data.name, _data.asset_path, _data.battle_portrait, _data.round_priority)
	data = _data
	base_stats = _data.stats
	current_health = base_stats[StatType.HEART]
	current_juice = base_stats[StatType.JUICE]
	## TODO: random emotion
	current_emotion = Registry.get_emotion("neutral")

func get_current_stats() -> Dictionary[String, int]:
	var result : Dictionary[String, int] = base_stats.duplicate()
	# apply emotion modifiers
	for modifier in current_emotion.modifiers:
		result[modifier.type] = modifier.apply(result[modifier.type])
	# TODO: apply status effects
	return result

func process_ai():
	pass
