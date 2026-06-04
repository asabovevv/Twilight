@abstract class_name Actor

var name : String
var asset_path : String
var battle_portrait : SpriteFrames

# Stats
var base_stats : Dictionary[String, int]
var current_stats : Dictionary[String, int]

# State
var current_emotion : Emotion
var status_effects : Array[StatusEffect]
var round_priority : int

func _init(_name : String, _asset_path : String, _battle_portrait : SpriteFrames, _round_priority : int) -> void:
	name = _name
	asset_path = _asset_path
	battle_portrait = _battle_portrait
	round_priority = _round_priority
