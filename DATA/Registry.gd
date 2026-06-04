extends Node

## The global registry for storing game data.

var items : GameDataRegistry = GameDataRegistry.new()
var emotions : GameDataRegistry = GameDataRegistry.new()
var equipment : GameDataRegistry = GameDataRegistry.new()
var enemies : GameDataRegistry = GameDataRegistry.new()
var skills : GameDataRegistry = GameDataRegistry.new()
var status_effects : GameDataRegistry = GameDataRegistry.new()
var portraits : GameDataRegistry = GameDataRegistry.new()

## Shorthand for [code]Registry.items.try_get(id) as Item[/code]. Will return [code]null[/code] if the entry does not exist.
func get_item(id : String) -> Item:
	return items.try_get(id) as Item

## Shorthand for [code]Registry.emotions.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_emotion(id : String) -> Emotion:
	return emotions.try_get(id) as Emotion

## Shorthand for [code]Registry.equipment.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_equipment(id : String) -> Equippable:
	return equipment.try_get(id) as Equippable

## Shorthand for [code]Registry.enemies.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_enemy(id : String) -> Enemy:
	return enemies.try_get(id) as Enemy

## Shorthand for [code]Registry.skills.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_skill(id : String) -> Skill:
	return skills.try_get(id) as Skill

## Shorthand for [code]Registry.status_effects.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_status_effect(id : String) -> StatusEffect:
	return status_effects.try_get(id) as StatusEffect

## Shorthand for [code]Registry.portraits.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_portrait(id : String) -> Portrait:
	return portraits.try_get(id) as Portrait

func _init() -> void:
	# everything is registered here just as an example
	# these can be moved out to other places for organization
	_register_emotions()
	_register_equipment()
	_register_items()
	_register_skills()

func _register_emotions():
	emotions.register("neutral", Emotion.new(
		"Neutral",
		load("res://ENCOUNTER/Sprites/EmotionSprites/T_Neutral.png"), 0,
		load("res://ENCOUNTER/Sprites/EmotionSprites/G_Neutral.png"), 0,
		Color.TRANSPARENT,
		"SE_chirp",
		[]
	))
	
	emotions.register("angry", Emotion.new(
		"Angry",
		load("res://ENCOUNTER/Sprites/EmotionSprites/T_Angry.png"), 0,
		load("res://ENCOUNTER/Sprites/EmotionSprites/G_Angry.png"), 0,
		Color(1.0, 0.235, 0.22),
		"SE_angry",
		[]
	))
	
	emotions.register("happy", Emotion.new(
		"Happy",
		load("res://ENCOUNTER/Sprites/EmotionSprites/T_Happy.png"), 0,
		load("res://ENCOUNTER/Sprites/EmotionSprites/G_Happy.png"), 0,
		Color(0.996, 0.882, 0.22),
		"SE_happy",
		[StatModifier.new(StatType.WALK_SPEED, 2.0)]
	))
	
	emotions.register("sad", Emotion.new(
		"Sad",
		load("res://ENCOUNTER/Sprites/EmotionSprites/T_sad.png"), 0,
		load("res://ENCOUNTER/Sprites/EmotionSprites/G_sad.png"), 0,
		Color(0.29, 0.38, 0.835),
		"SE_sad",
		[]
	))

func _register_equipment():
	equipment.register("zero", Equippable.new(
		"ZERO",
		"",
		"",
		Texture2D.new(),
		{},
		Equippable.EquipType.Charm
	))
	
	equipment.register("bat", Equippable.new(
		"BAT",
		"It's big and hard and will make you cream.",
		"aubrey",
		load("res://RESOURCES/Hector.png"),
		{
			StatType.HEART: 6,
			StatType.JUICE: 6,
			StatType.ATTACK: 6,
			StatType.DEFENSE: 6,
			StatType.SPEED: 6,
			StatType.LUCK: 6,
			StatType.HIT: 106
		},
		Equippable.EquipType.Weapon,
		true
	))

func _register_items():
	items.register("apple", Item.new(
		"APPLE",
		"Yum yum",
		load("res://RESOURCES/Hector.png"),
		true,
		true
	))
	
	items.register("hector", Item.new(
		"HECTOR",
		"I fucking LOVE Hector",
		load("res://RESOURCES/Hector.png")
	))

func _register_skills():
	skills.register("knifeguy", Skill.new(
		"Knife Guy",
		"He stabs you a lot and you die.",
		300,
		2
	))
	
	skills.register("another_skill", Skill.new(
		"Another Skill",
		"I ran out of ideas.",
		3,
		5,
		-1,
		true
	))
