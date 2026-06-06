class_name EnemyStatus extends Node2D

@export var sprite : AnimatedSprite2D
@export var infobox : EnemyInfobox

func bind(_enemy : Enemy) -> void:
	sprite.sprite_frames = _enemy.battle_portrait
	sprite.animation = _enemy.current_emotion.name
	sprite.play()
	infobox.bind(_enemy)

func show_infobox():
	infobox.show()

func hide_infobox():
	infobox.hide()
