class_name PartyMember extends Actor
 
var data : PartyMemberData	# static party member data from the registry
var active : bool = true # skip in battle/tagging (future use)

# Progression
var level : int
var experience : int

# Accessories (registry id)
var weapon : String = Equippable.NONE
var charm : String = Equippable.NONE

# Skills (registry ids)
var unlocked_skills : Array[String]
var active_skills : Array[String]

# Overworld
var line_position : int = 0

func _init(_data : PartyMemberData) -> void:
	super(_data.name, _data.asset_path, _data.battle_portrait, _data.round_priority)
	data = _data

## Applies stats from a save
func load_stats(
		_level : int,
		_exp : int,
		_weapon : String,
		_charm : String,
		_line_position : int,
		_active_skills : Array[String]
) -> void: 
	current_emotion = Registry.get_emotion("neutral")
	weapon = _weapon
	charm = _charm
	line_position = _line_position
	active_skills = _active_skills
	set_level(_level, _exp)

func get_current_stats() -> Dictionary[String, int]:
	var result : Dictionary[String, int] = base_stats.duplicate()
	# apply weapon and charm
	var cur_weapon : Equippable = Registry.get_equipment(weapon)
	if cur_weapon:
		for key in cur_weapon.stats.keys():
			result[key] += cur_weapon.stats[key]
	var cur_charm : Equippable = Registry.get_equipment(charm)
	if cur_charm:
		for key in cur_charm.stats.keys():
			result[key] += cur_charm.stats[key]
	# apply emotion modifiers
	for modifier in current_emotion.modifiers:
		result[modifier.type] = modifier.apply(result[modifier.type])
	# TODO: apply status effects
	return result

## Sets level/exp and recomputes base + current stats and unlocked skills
func set_level(_level : int, _exp : int) -> void:
	level = _level
	experience = _exp
	for stat in data.level_up_stats:
		base_stats[stat] = data.get_level_stat(_level, stat)
	_refresh_unlocked_skills()

func _refresh_unlocked_skills() -> void:
	unlocked_skills.clear()
	for id in data.all_skills:
		var skill := Registry.get_skill(id)
		if !skill: continue
		var level_ok : bool = skill.level_requirement < level
		var flag_ok : bool = skill.required_flag == -1 or Twilight.Flags.get_flag(skill.required_flag)
		if level_ok and flag_ok:
			unlocked_skills.append(id)

## Swaps the equipped weapon
func swap_item(_replacing_item_name : String, _inventory) -> void:
	if not _inventory.contents.has(_replacing_item_name):
		print(_replacing_item_name, " not in inventory.")
		return
	_inventory.contents[weapon] = 1
	_inventory.contents[_replacing_item_name] = 0
	weapon = _replacing_item_name
