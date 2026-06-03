@abstract class_name Actor

var name : String
var battle_portrait : SpriteFrames
var current_emotion : Emotion
# TODO: potentially wrap this in some kind of class
# Stats.stats[StatType.TYPE] would be kind of stupid but it may be better than passing dictionaries around
var base_stats : Dictionary[String, int]

# temporary for mockup
func _init(name : String):
	self.name = name
