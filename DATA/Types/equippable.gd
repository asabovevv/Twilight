class_name Equippable

var name : String
var description : String
var can_unequip : bool = true
var owner : String
var icon : Texture2D
var stats : Dictionary[String, int]

func _init(
	name : String,
	description : String,
	owner : String,
	icon : Texture2D,
	stats : Dictionary[String, int],
	can_unequip : bool = true,
):
	self.name = name
	self.description = description
	self.owner = owner
	self.icon = icon
	self.stats = stats
	self.can_unequip = can_unequip
