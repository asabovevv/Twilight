class_name Item

var name : String
var description : String
var can_overworld_use : bool = false
var can_trash : bool = false
var icon : Texture2D

enum ItemType { Snacks, Toys, Important }
var item_type

func _init(
	_name : String,
	_description : String,
	_icon : Texture2D,
	_can_overworld_use : bool = false,
	_can_trash : bool = false
):
	self.name = _name
	self.description = _description
	self.icon = _icon
	self.can_overworld_use = _can_overworld_use
	self.can_trash = _can_trash
