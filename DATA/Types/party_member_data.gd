class_name PartyMemberData

var key : String 
var name : String
var asset_path : String
var battle_portrait : SpriteFrames
var level_up_stats : Dictionary[String, Array] # Stat curves
var round_priority : int
var all_skills : Array[String] # All skills the party member can/will have

func _init(
		_key : String,
		_name : String,
		_asset_path : String,
		_battle_portrait : SpriteFrames,
		_level_up_stats : Dictionary[String, Array],
		_round_priority : int,
		_all_skills : Array[String]
) -> void:
	key = _key
	name = _name
	asset_path = _asset_path
	battle_portrait = _battle_portrait
	level_up_stats = _level_up_stats
	round_priority = _round_priority
	all_skills = _all_skills

func get_level_stat(_level, stat_type : String) -> int:
	return lerp(level_up_stats[stat_type][floor(_level * 0.1)], level_up_stats[stat_type][ceil(_level * 0.1)], (_level % 10) * 0.1)

# Returns xp required to get to specified level from level 1.
func get_required_exp(_level : int) -> int: 
	return round(-0.19 * pow(_level, 3) + 18.54 * pow(_level, 2) - 8.8 * _level + 41.76)
