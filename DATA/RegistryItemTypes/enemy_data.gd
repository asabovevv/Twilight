class_name EnemyData

var key : String
var name : String
var asset_path : String
var battle_portrait : SpriteFrames
var stats : Dictionary[String, int]
var round_priority : int
var pointer_offset : Vector2 = Vector2.ZERO
var position_offset: Vector2i = Vector2i.ZERO
# TODO: maybe store skills here too?
# TODO: drop pool, exp given, etc.

func _init(
		_key : String,
		_name : String,
		_asset_path : String,
		_battle_portrait : SpriteFrames,
		_stats : Dictionary[String, int],
		_round_priority : int,
		_pointer_offset: Vector2 = Vector2.ZERO,
		_position_offset: Vector2i = Vector2i.ZERO
) -> void:
	key = _key
	name = _name
	asset_path = _asset_path
	battle_portrait = _battle_portrait
	stats = _stats
	round_priority = _round_priority
	pointer_offset = _pointer_offset
	position_offset = _position_offset
