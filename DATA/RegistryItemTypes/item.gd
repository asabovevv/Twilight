class_name Item extends Action

var can_trash : bool = false
var icon : Texture2D

enum ItemType { Snacks, Toys, Important }
var item_type

func _init(
	_name : String,
	_item_type : ItemType,
	_description : String,
	_target_type: Target,
	_icon : Texture2D,
	_can_overworld_use : bool = false,
	_can_trash : bool = false,
	_battle_effects : Array[Effect] = [],
	_overworld_effects : Array[Effect] = []
):
	super(_name, _description, _target_type, _can_overworld_use, _battle_effects, _overworld_effects)
	item_type = _item_type
	icon = _icon
	can_trash = _can_trash
