class_name Emotion

var name : String
var label_texture : Texture2D
var label_index : int
var gradient_texture : Texture2D
var gradient_index : int
var color : Color
var sound : String
var modifiers : Array[StatModifier]

func _init(
	name : String,
	label_texture : Texture2D,
	label_index : int,
	gradient_texture : Texture2D,
	gradient_index : int,
	color : Color,
	sound : String,
	modifiers : Array[StatModifier]
):
	self.name = name
	self.label_texture = label_texture
	self.label_index = label_index
	self.gradient_texture = gradient_texture
	self.gradient_index = gradient_index
	self.color = color
	self.sound = sound
	self.modifiers = modifiers
