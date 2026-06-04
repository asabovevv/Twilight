class_name Equippable

var name : String
var description : String
var can_unequip : bool = true
var owner : String
var icon : Texture2D
var stats : Dictionary[String, int]

enum EquipType { WEAPON, CHARM }
const NONE = "none"
var equip_type

func _init(
	_name : String,
	_description : String,
	_owner : String,
	_icon : Texture2D,
	_stats : Dictionary[String, int],
	_equip_type : EquipType,
	_can_unequip : bool = true,
):
	self.name = _name
	self.description = _description
	self.owner = _owner
	self.icon = _icon
	self.stats = _stats
	self.equip_type = _equip_type
	self.can_unequip = _can_unequip

func get_stat(stat_type : String) -> int:
	if stats.has(stat_type):
		return stats[stat_type]
	return 0
