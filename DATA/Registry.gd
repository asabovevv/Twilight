extends Node

## The global registry for storing game data.

var items : GameDataRegistry = GameDataRegistry.new()
var emotions : GameDataRegistry = GameDataRegistry.new()
var equipment : GameDataRegistry = GameDataRegistry.new()
var enemies : GameDataRegistry = GameDataRegistry.new()
var skills : GameDataRegistry = GameDataRegistry.new()
var status_effects : GameDataRegistry = GameDataRegistry.new()
var party_members : GameDataRegistry = GameDataRegistry.new()

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

## Shorthand for [code]Registry.party_members.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_party_member(id : String) -> PartyMemberData:
	return party_members.try_get(id) as PartyMemberData


func _init() -> void:
	# everything is registered here just as an example
	# these can be moved out to other places for organization
	_register_emotions()
	_register_equipment()
	_register_items()
	_register_skills()
	_register_party_members()

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
		load("res://ENCOUNTER/Sprites/EmotionSprites/T_Sad.png"), 0,
		load("res://ENCOUNTER/Sprites/EmotionSprites/G_Sad.png"), 0,
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
		Equippable.EquipType.CHARM
	))
	
	equipment.register("bat", Equippable.new(
		"BAT",
		"It's big and hard and will make you cream.",
		"aubrey",
		load("res://UI/ItemIcons/Hector.png"),
		{
			StatType.HEART: 6,
			StatType.JUICE: 6,
			StatType.ATTACK: 6,
			StatType.DEFENSE: 6,
			StatType.SPEED: 6,
			StatType.LUCK: 6,
			StatType.HIT: 106
		},
		Equippable.EquipType.WEAPON,
		true
	))

func _register_items():
	items.register("apple", Item.new(
		"APPLE",
		"Yum yum",
		load("res://UI/ItemIcons/Hector.png"),
		true,
		true
	))
	
	items.register("hector", Item.new(
		"HECTOR",
		"I fucking LOVE Hector",
		load("res://UI/ItemIcons/Hector.png")
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

func _register_party_members():
	party_members.register("aubrey", PartyMemberData.new(
		"aubrey", # key
		"Aubrey", # name
		"res://CHARACTERS/Aubrey/", # asset_path
		load("res://UI/Portraits/AubreyBattle/aubrey_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [33, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [7, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [5, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [1, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [1, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		2, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	## SUNNY (HS)
		#PartyMember_Const.new("SUNNY",
							#"res://CHARACTERS/Sunny/", # path
							#0, # portrait offset
							#Rect2i(0, 17, 363, 104), # battle clip rect
							#Rect2i(0, 17, 363, 104), # portrait clip rect
							#[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							#[9, 31, 56, 78, 109, 150] as Array[int], #juc
							#[10, 20, 40, 56, 75, 110] as Array[int], #atk
							#[5, 12, 25, 37, 49, 70] as Array[int], #def
							#[5, 12, 23, 34, 44, 65] as Array[int], #spd
							#0, 6, #lck, priority
							#[] as Array[String], # skill names
							#[] as Array[int]), # skill lvs
		#
		## MARI (HS)
		#PartyMember_Const.new("MARI",
							#"res://CHARACTERS/Mari/", # path
							#1, # portrait offset
							#Rect2i(18, 33, 264, 76), # battle clip rect
							#Rect2i(8, 17, 318, 104), # portrait clip rect
							#[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							#[9, 31, 56, 78, 109, 150] as Array[int], #juc
							#[10, 20, 40, 56, 75, 110] as Array[int], #atk
							#[5, 12, 25, 37, 49, 70] as Array[int], #def
							#[5, 12, 23, 34, 44, 65] as Array[int], #spd
							#0, 100, #lck, priority
							#[] as Array[String], # skill names
							#[] as Array[int]), # skill lvs
		#
		## KEL (HS)
		#PartyMember_Const.new("KEL",
							#"res://CHARACTERS/Kel/", # path
							#0, # portrait offset
							#Rect2i(10, 17, 318, 104), # battle clip rect
							#Rect2i(10, 17, 318, 104), # portrait clip rect
							#[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							#[9, 31, 56, 78, 109, 150] as Array[int], #juc
							#[10, 20, 40, 56, 75, 110] as Array[int], #atk
							#[5, 12, 25, 37, 49, 70] as Array[int], #def
							#[5, 12, 23, 34, 44, 65] as Array[int], #spd
							#0, 0, #lck, priority
							#[] as Array[String], # skill names
							#[] as Array[int]), # skill lvs
		#
		## HERO (HS)
		#PartyMember_Const.new("HERO",
							#"res://CHARACTERS/Hero/", # path
							#0, # portrait offset
							#Rect2i(10, 17, 318, 104), # battle clip rect
							#Rect2i(10, 17, 318, 104), # portrait clip rect
							#[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							#[9, 31, 56, 78, 109, 150] as Array[int], #juc
							#[10, 20, 40, 56, 75, 110] as Array[int], #atk
							#[5, 12, 25, 37, 49, 70] as Array[int], #def
							#[5, 12, 23, 34, 44, 65] as Array[int], #spd
							#0, 4, #lck, priority
							#[] as Array[String], # skill names
							#[] as Array[int]), # skill lvs
		#
		## BASIL (HS)
		#PartyMember_Const.new("BASIL",
							#"res://CHARACTERS/Basil/", # path
							#0, # portrait offset
							#Rect2i(6, 33, 264, 76), # battle clip rect
							#Rect2i(10, 17, 318, 104), # portrait clip rect
							#[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							#[9, 31, 56, 78, 109, 150] as Array[int], #juc
							#[10, 20, 40, 56, 75, 110] as Array[int], #atk
							#[5, 12, 25, 37, 49, 70] as Array[int], #def
							#[5, 12, 23, 34, 44, 65] as Array[int], #spd
							#0, 100, #lck, priority
							#[] as Array[String], # skill names
							#[] as Array[int]) # skill lvs
