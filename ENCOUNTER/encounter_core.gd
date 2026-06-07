class_name EncounterCore extends Node

var context : EncounterContext

var _effectiveness_matrix : Array[Array] = [
#  		angry sad happy
# angry  n/a weak strong
# sad   strong n/a weak
# happy weak strong n/a
	[0, -1, 1],
	[1, 0, -1],
	[-1, 1, 0]
]
var _weakness : Array[float] = [1.5, 2.0, 2.5]
var _resistance : Array[float] = [0.8, 0.65, 0.5]

func _initialize(ctx : EncounterContext):
	context = ctx

func damage(
	user : Actor,
	target : Actor,
	damage_func : Callable,
	variance : float = 0.2
) -> int:
	# TODO: reinstate this, temporary for mockup until more weapons are added
	# var miss : bool = user.get_current_stats()[StatType.HIT] < Twilight.rng.randi_range(0, 100)
	var miss : bool = false
	if miss:
		context.battlelog.queue_message("%s's attack missed..." % user.name.to_upper())
		Audio.play_sfx("BA_miss")
		spawn_damage_number(-1, target.center_point, DamageNumber.DamageType.MISS)
		return -1
	
	var dmg : float = maxf(0, damage_func.call())
	# gdscript is a poop language and doesn't have out parameters
	# so we have to calculate this before passing it into _calculate_emotion_modifiers
	var user_index : int = _get_effectiveness_index(user.current_emotion.name)
	var target_index : int = _get_effectiveness_index(target.current_emotion.name)
	var effectiveness : int = 0
	if user_index != -1 and target_index != -1:
		effectiveness = _effectiveness_matrix[target_index][user_index]
		dmg = _calculate_emotion_modifiers(user.current_emotion.name, target.current_emotion.name, dmg, effectiveness)
	
	var critical : bool = user.get_current_stats()[StatType.LUCK] * 0.01 >= Twilight.rng.randf() 
	if critical:
		dmg *= 1.5
		dmg += 1.5
		context.battlelog.queue_message("IT HIT RIGHT IN THE HEART!")
		Audio.play_sfx("BA_CRITICAL_HIT", 2)
	
	dmg = _calculate_variance(dmg, variance)
	
	var rounded : float = round(dmg)
	if rounded < 0:
		rounded = 0
	elif rounded > 9999:
		rounded = 9999
		
	var juice_lost : int = 0
	match target.current_emotion.name:
		"Miserable":
			juice_lost = mini(floor(rounded), target.current_juice)
		"Depressed":
			juice_lost = mini(floor(rounded * 0.5), target.current_juice)
		"Sad":
			juice_lost = mini(floor(rounded * 0.3), target.current_juice)
	rounded -= juice_lost
	target.current_juice -= juice_lost
	
	if rounded < 0:
		rounded = 0
	elif rounded > 9999:
		rounded = 9999
	var final : int = round(rounded)
	target.damage(final)
	if target is PartyMember:
		context.state.power = mini(10, context.state.power + 1)
	
	spawn_damage_number(final, target.center_point, DamageNumber.DamageType.DAMAGE, critical)
	if !critical and final > 0:
		if effectiveness > 0:
			context.battlelog.queue_message("...It was a moving attack!")
			Audio.play_sfx("SE_impact_double", 0.9)
		elif effectiveness < 0:
			context.battlelog.queue_message("...It was a dull attack.")
			Audio.play_sfx("SE_impact_soft", 0.9)
		else:
			Audio.play_sfx("SE_dig", 0.9, 0.7)
	
	context.battlelog.queue_message("%s takes %d damage!" % [target.name.to_upper(), final])
	if juice_lost > 0:
		context.battlelog.queue_message("%s lost %d JUICE..." % [target.name.to_upper(), juice_lost])
		spawn_damage_number(juice_lost, target.center_point, DamageNumber.DamageType.JUICE_LOSS)
	
	return final
	
func _calculate_emotion_modifiers(user : String, target : String, dmg : float, effectiveness : int):
	# afraid takes 1.5x damage from all non-neutral sources
	if user != "Neutral" and target == "Afraid":
		return dmg * 1.5
	
	var target_tier : int = _get_emotion_tier(target)
	var multiplier : float = 1
	if effectiveness > 0:
		multiplier = _weakness[target_tier]
	elif effectiveness < 0:
		multiplier = _resistance[target_tier]
	return dmg * multiplier
	
# TODO: checking these by string is kinda dumb. look into another solution
func _get_effectiveness_index(emotion : String) -> int:
	match emotion:
		"Angry", "Enraged", "Furious":
			return 0
		"Sad", "Depressed", "Miserable":
			return 1
		"Happy", "Ecstatic", "Manic":
			return 2
		_:
			return -1

func _get_emotion_tier(emotion : String) -> int:
	match emotion:
		"Miserable", "Manic", "Furious":
			return 2
		"Depressed", "Ecstatic", "Enraged":
			return 1
		"Sad", "Happy", "Angry":
			return 0
		_:
			return -1

func _calculate_variance(dmg : float, variance : float):
	var amp : int = floor(max(abs(dmg) * variance, 0))
	var v : int = Twilight.rng.randi_range(0, amp) + Twilight.rng.randi_range(0, amp) - amp
	return dmg + v

func spawn_damage_number(
	dmg : int, 
	position : Vector2, 
	type : DamageNumber.DamageType = DamageNumber.DamageType.DAMAGE,
	critical : bool = false
):
	var number = DamageNumber.new(dmg, position, type, critical)
	add_child(number)
	await get_tree().create_timer(1.5).timeout
	number.despawn()

func wait(seconds : float) -> void:
	await get_tree().create_timer(seconds).timeout
