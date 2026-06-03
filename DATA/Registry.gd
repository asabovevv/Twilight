extends Node

## The global registry for storing game data.

var items : GameDataRegistry
var emotions : GameDataRegistry
var equipment : GameDataRegistry
var party_members : GameDataRegistry
var enemies : GameDataRegistry
var skills : GameDataRegistry

## Shorthand for [code]Registry.items.try_get(id) as Item[/code]. Will return [code]null[/code] if the entry does not exist.
func get_item(id : String) -> Item:
	return items.try_get(id) as Item

## Shorthand for [code]Registry.emotions.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_emotion(id : String) -> Emotion:
	return emotions.try_get(id) as Emotion

## Shorthand for [code]Registry.equipment.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_equipment(id : String) -> Equippable:
	return equipment.try_get(id) as Equippable

## Shorthand for [code]Registry.party_members.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_party_member(id : String) -> PartyMember:
	return party_members.try_get(id) as PartyMember

## Shorthand for [code]Registry.enemies.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_enemy(id : String) -> Enemy:
	return enemies.try_get(id) as Enemy

## Shorthand for [code]Registry.skills.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_skill(id : String) -> Skill:
	return skills.try_get(id) as Skill


func _init() -> void:
	# everything is registered here just as an example
	# these can be moved out to other places for organization
	_register_emotions()
	_register_equipment()
	_register_items()

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
		{}
	))
	
	equipment.register("bat", Equippable.new(
		"BAT",
		"It's big and hard and will make you cream.",
		"aubrey",
		load("res://RESOURCES/Hector.png"),
		{
			StatType.MAX_HEART: 6,
			StatType.MAX_JUICE: 6,
			StatType.ATTACK: 6,
			StatType.DEFENSE: 6,
			StatType.SPEED: 6,
			StatType.LUCK: 6,
			StatType.HIT: 106
		},
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
