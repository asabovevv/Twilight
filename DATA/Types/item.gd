class_name Item

var name : String
var description : String
var can_overworld_use : bool = false
var can_trash : bool = false
var icon : Texture2D

func _init(
	name : String,
	description : String,
	icon : Texture2D,
	can_overworld_use : bool = false,
	can_trash : bool = false
):
	self.name = name
	self.description = description
	self.icon = icon
	self.can_overworld_use = can_overworld_use
	self.can_trash = can_trash
