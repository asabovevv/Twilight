@abstract class_name Actor

var name : String
var asset_path : String
var battle_portrait : SpriteFrames
var center_point : Vector2 = Vector2.ZERO

# Stats
var base_stats : Dictionary[String, int]
# store these separate, the ones in current_stats are current max health and max juice
var current_health : int :
	get:
		return current_health
	set(value):
		current_health = value
		health_changed.emit()

var current_juice : int :
	get:
		return current_juice
	set(value):
		current_juice = value
		juice_changed.emit()

@abstract func get_current_stats() -> Dictionary[String, int]

signal health_changed
signal juice_changed
signal damaged

# State
var current_emotion : Emotion
var status_effects : Array[StatusEffect]
var round_priority : int

signal emotion_changed

func _init(_name : String, _asset_path : String, _battle_portrait : SpriteFrames, _round_priority : int) -> void:
	name = _name
	asset_path = _asset_path
	battle_portrait = _battle_portrait
	round_priority = _round_priority

## Damages the actor by the given amount. Must be a positive integer.
func damage(dmg : int) -> void:
	if dmg <= 0:
		return
	
	current_health -= dmg
	if current_health <= 0:
		current_health = 0
	
	damaged.emit()

func set_emotion(emotion : Emotion) -> void:
	# TODO: handle "can/cannot feel" logic
	current_emotion = emotion
	emotion_changed.emit()
