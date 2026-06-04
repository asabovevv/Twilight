@abstract class_name Actor

var name : String
var asset_path : String
var battle_portrait : Portrait
var base_stats : Dictionary[String, int]
var current_emotion : Emotion

# I'm not sure what you'll need to incorporate into this so i'll leave it at this for now
var status_effects : Array[StatusEffect]

func _init(_name : String):
	self.name = _name
