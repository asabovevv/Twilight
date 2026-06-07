class_name EnemyStatus extends Node2D

@export var sprite : AnimatedSprite2D
@export var infobox : EnemyInfobox
@export var hurt_timer : Timer

var enemy : Enemy

func bind(_enemy : Enemy) -> void:
	enemy = _enemy
	enemy.center_point = sprite.global_position
	sprite.sprite_frames = enemy.battle_portrait
	sprite.animation = enemy.current_emotion.name
	sprite.play()
	infobox.bind(enemy)
	enemy.damaged.connect(_on_damaged)
	hurt_timer.timeout.connect(_on_hurt_timer_timeout)

func _exit_tree() -> void:
	enemy.damaged.disconnect(_on_damaged)
	hurt_timer.timeout.disconnect(_on_hurt_timer_timeout)

func show_infobox():
	infobox.show()

func hide_infobox():
	infobox.hide()

func _on_damaged() -> void:
	sprite.animation = "Hurt"
	hurt_timer.start()

func _on_hurt_timer_timeout() -> void:
	if enemy.current_health == 0:
		# TODO: fall off screen
		if sprite.animation != "Toast":
			sprite.animation = "Toast"
	else:
		sprite.animation = enemy.current_emotion.name
