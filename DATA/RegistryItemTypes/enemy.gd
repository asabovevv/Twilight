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

# placeholder ai for testing
func process_ai(ctx : EncounterContext) -> QueuedAction:
	var living : Array[PartyMember] = ctx.party.members.filter(func(x : PartyMember): return x.current_health > 0)
	var target := living[Twilight.rng.randi_range(0, living.size() - 1)]
	return QueuedAction.new(self, Registry.get_skill("basic_attack"), target)
