class_name DamageNumber extends Node2D

static var active_numbers : Dictionary[Vector2, DamageNumber]
static var texture : Texture2D = preload("res://ENCOUNTER/Sprites/UI/Damage_Numbers.png")

enum DamageType { DAMAGE, HEAL, JUICE_LOSS, JUICE_GAIN, MISS }

var _digits : Array
var _damage_type : DamageType
var _critical : bool

const _WIDTH : int = 30
const _HEIGHT : int = 42
const _SPACING : float = 25.0
const _SCALE : float = 1
const _SPEED : float = 0.15

func _init(
	_damage : int,
	_position : Vector2,
	_type : DamageType = DamageType.DAMAGE,
	_crit : bool = false
):
	# split each digit of the incoming damage number
	_digits = Array(str(_damage).split()).map(func(c): return int(c))
	_damage_type = _type
	_critical = _crit
	z_as_relative = false
	position = _position
	var existing : DamageNumber = active_numbers.get(position)
	if existing:
		_shift_up(existing)
	active_numbers[position] = self

func _ready() -> void:
	var tween : Tween = get_tree().create_tween().set_parallel()
	const stagger : float = 0.05
	if _damage_type == DamageType.MISS:
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = texture
		sprite.region_enabled = true
		sprite.region_rect = Rect2(0, 182, 62, _HEIGHT)
		add_child(sprite)
		tween.tween_property(sprite, "position:y", 20, _SPEED).set_delay(stagger).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		return
	
	const scaled_spacing : float = _SPACING * _SCALE
	var total_width : float = (_digits.size() - 1) * scaled_spacing
	for i in range(_digits.size()):
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = texture
		sprite.modulate = Color(1, 0, 0, 0) if _critical else Color.TRANSPARENT
		sprite.region_enabled = true
		sprite.region_rect = Rect2(32 * _digits[i], 48 * _damage_type, _WIDTH, _HEIGHT)
		add_child(sprite)
		sprite.scale = Vector2(_SCALE, _SCALE)
		var offset : float = i * scaled_spacing - total_width / 2.0
		sprite.position = Vector2(offset, -20)
		var delay : float = i * stagger
		tween.tween_property(sprite, "position:y", 20, _SPEED).set_delay(delay).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(sprite, "modulate:a", 1, _SPEED).set_delay(delay)
		if _critical:
			tween.tween_property(sprite, "modulate:g", 1, 0.5).set_delay(delay)
			tween.tween_property(sprite, "modulate:b", 1, 0.5).set_delay(delay)

func _shift_up(number : DamageNumber):
	active_numbers.erase(number.position)
	var new_pos : Vector2 = number.position + Vector2(0, -40)
	var other_number : DamageNumber = active_numbers.get(new_pos)
	if other_number:
		_shift_up(other_number)
	number.position = new_pos
	active_numbers[new_pos] = number

func despawn():
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, _SPEED)
	await tween.finished
	active_numbers.erase(position)
	queue_free()

static func despawn_all():
	for number in active_numbers.values():
		if is_instance_valid(number):
			number.despawn()
	active_numbers.clear()
