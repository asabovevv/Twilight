class_name Emotion

## An emotion. Each tier of an emotion is a separate object.

var name : String
var label_texture : Texture2D
var label_index : int
var gradient_texture : Texture2D
var gradient_index : int
var color : Color
var sound : String
var modifiers : Array[StatModifier]

func _init(
	_name : String,
	_label_texture : Texture2D,
	_label_index : int,
	_gradient_texture : Texture2D,
	_gradient_index : int,
	_color : Color,
	_sound : String,
	_modifiers : Array[StatModifier]
):
	self.name = _name
	self.label_texture = _label_texture
	self.label_index = _label_index
	self.gradient_texture = _gradient_texture
	self.gradient_index = _gradient_index
	self.color = _color
	self.sound = _sound
	self.modifiers = _modifiers
