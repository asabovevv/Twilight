class_name BattleStatus extends Control

@export var profile : AnimatedSprite2D
@export var battle_status_frost : BattleStatusSelectPulse
@export var emotion : Sprite2D
@export var emotion_label : Sprite2D
@export var health_bar : TextureProgressBar
@export var juice_bar : TextureProgressBar
@export var health_label : Label
@export var juice_label : Label
@export var state_icons : HFlowContainer
@export var hurt_timer : Timer

# the party member this BattleStatus is bound to
var member : PartyMember

var _displayed_heart : float
var _displayed_juice : float

func bind(_member : PartyMember) -> void:
	member = _member
	member.center_point = profile.global_position
	member.emotion_changed.connect(_on_emotion_changed)
	profile.sprite_frames = member.battle_portrait
	profile.play()
	var current : Dictionary[String, int] = member.get_current_stats()
	health_bar.max_value = current[StatType.HEART]
	health_bar.value = member.current_health
	juice_bar.max_value = current[StatType.JUICE]
	juice_bar.value = member.current_juice
	member.damaged.connect(_on_damaged)
	hurt_timer.timeout.connect(_on_hurt_timer_timeout)

func _exit_tree() -> void:
	member.emotion_changed.disconnect(_on_emotion_changed)
	member.damaged.disconnect(_on_damaged)
	hurt_timer.timeout.disconnect(_on_hurt_timer_timeout)

func _process(delta : float) -> void:
	_displayed_heart = move_toward(_displayed_heart, member.current_health, delta * (health_bar.max_value / 0.5))
	_displayed_juice = move_toward(_displayed_juice, member.current_juice, delta * (juice_bar.max_value / 0.5))
	
	health_bar.value = _displayed_heart
	juice_bar.value = _displayed_juice
	
	health_label.text = "%d/%d" % [_displayed_heart, health_bar.max_value]
	juice_label.text = "%d/%d" % [_displayed_juice, juice_bar.max_value]

func _on_damaged() -> void:
	profile.animation = "Hurt"
	hurt_timer.start()

func _on_hurt_timer_timeout() -> void:
	if member.current_health == 0:
		if profile.animation != "Toast":
			Audio.play_sfx("SYS_you_died", 0.9)
			profile.animation = "Toast"
			emotion.frame = 8
			emotion_label.frame = 1
	else:
		profile.animation = member.current_emotion.name

func _on_emotion_changed() -> void:
	emotion_label.frame = member.current_emotion.label_index
	# create a copy of the emotion sprite and fade it in on top of the old one
	var new_emotion : Sprite2D = emotion.duplicate()
	# this might cause issues if an animation or something travels across the box during an emotion change, address if necessary
	emotion.z_index -= 1;
	add_child(new_emotion)
	new_emotion.modulate = Color.TRANSPARENT
	new_emotion.frame = member.current_emotion.gradient_index
	var tween : Tween = new_emotion.create_tween()
	tween.tween_property(new_emotion, "modulate:a", 1.0, 0.25)
	await tween.finished
	emotion.free()
	emotion = new_emotion
