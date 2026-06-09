class_name EnemyInfobox extends Control

@export var infobox : NinePatchRect
@export var enemy_name : Label
@export var hp_bar : TextureProgressBar
@export var state_icons : HFlowContainer

var enemy : Enemy

func bind(_enemy : Enemy) -> void:
	enemy = _enemy
	enemy.health_changed.connect(_on_health_changed)
	# TODO: if an enemy ever changes their max hp, this will need to be updated in real time
	hp_bar.max_value = enemy.base_stats[StatType.HEART]
	hp_bar.value = hp_bar.max_value
	enemy_name.text = enemy.name.to_upper()
	position = enemy.data.pointer_offset
	var width : float = maxf(infobox.custom_minimum_size.x, enemy_name.get_minimum_size().x + 15)
	infobox.size = Vector2(width, infobox.size.y)
	infobox.position = Vector2(-width / 2.0, infobox.position.y)

func _on_health_changed() -> void:
	hp_bar.value = enemy.current_health
