class_name AllRegister

#region ----- ITEMS REGISTRY -----
static func register_items( items : GameDataRegistry ):
	items.register("apple", Item.new(
		"APPLE",
		Item.ItemType.Snacks,
		"Yum yum",
		null,
		true,
		true
	))
	
	items.register("hector", Item.new(
		"HECTOR",
		Item.ItemType.Important,
		"I fucking LOVE Hector",
		load("res://UI/ItemIcons/Hector.png")
	))
	
#endregion

#region ----- EQUIPMENT REGISTRY -----
static func register_equipment( equipment : GameDataRegistry ):
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
#endregion

#region ----- SKILLS REGISTRY -----
static func register_skills( skills : GameDataRegistry ):
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
#endregion

#region ----- ENEMIES REGISTRY -----
static func register_enemies( enemies : GameDataRegistry ):
	enemies.register("forest_bunny", EnemyData.new(
		"forest_bunny",
		"Forest Bunny",
		"",
		load("res://UI/Portraits/Enemy_Battle_Portraits/forest_bunny.tres"),
		{
			StatType.HEART: 85,
			StatType.JUICE: 42,
			StatType.ATTACK: 10,
			StatType.DEFENSE: 2,
			StatType.SPEED: 10,
			StatType.LUCK: 10,
			StatType.HIT: 95
		},
		0
	))
#endregion

#region ----- STATUS EFFECTS REGISTRY -----
static func register_status_effects( status_effects : GameDataRegistry ):
	pass
#endregion

#region ----- EMOTIONS REGISTRY -----
static func register_emotions( emotions : GameDataRegistry):
	emotions.register("neutral", Emotion.new(
		"Neutral",
		0,
		0,
		Color.TRANSPARENT,
		"SE_chirp",
		[]
	))
	
	emotions.register("angry", Emotion.new(
		"Angry",
		9,
		2,
		Color(1.0, 0.235, 0.22),
		"SE_angry",
		[]
	))
	
	emotions.register("happy", Emotion.new(
		"Happy",
		3,
		3,
		Color(0.996, 0.882, 0.22),
		"SE_happy",
		[StatModifier.new(StatType.WALK_SPEED, 2.0)]
	))
	
	emotions.register("sad", Emotion.new(
		"Sad",
		6,
		1,
		Color(0.29, 0.38, 0.835),
		"SE_sad",
		[]
	))
#endregion

#region ----- PARTY MEMBERS REGISTRY -----
static func register_party_members( party_members : GameDataRegistry ):
	party_members.register("kel", PartyMemberData.new(
		"kel", # key
		"Kel", # name
		"res://CHARACTERS/Kel/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/kel_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [36, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [9, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [10, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [5, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [5, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		0, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	
	party_members.register("aubrey", PartyMemberData.new(
		"aubrey", # key
		"Aubrey", # name
		"res://CHARACTERS/Aubrey/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/aubrey_battle.tres"), # battle portrait
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
	
	party_members.register("hero", PartyMemberData.new(
		"hero", # key
		"Hero", # name
		"res://CHARACTERS/Hero/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/hero_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [36, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [9, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [10, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [5, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [5, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		4, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	
	party_members.register("sunny", PartyMemberData.new(
		"sunny", # key
		"Sunny", # name
		"res://CHARACTERS/Sunny/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/sunny_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [36, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [9, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [10, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [5, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [5, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		6, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	
	party_members.register("basil", PartyMemberData.new(
		"basil", # key
		"Basil", # name
		"res://CHARACTERS/Basil/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/basil_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [36, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [9, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [10, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [5, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [5, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		8, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	
	party_members.register("mari", PartyMemberData.new(
		"mari", # key
		"Mari", # name
		"res://CHARACTERS/Mari/", # asset_path
		load("res://UI/Portraits/Battle_Portraits/mari_battle.tres"), # battle portrait
		{	# Levels 0, 10, 20, 30, 40, 50. Interpolated between during levelup.
			StatType.HEART : [36, 93, 164, 226, 300, 444],  # Heart
			StatType.JUICE : [9, 31, 56, 78, 109, 150],     # Juice
			StatType.ATTACK : [10, 20, 40, 56, 75, 110],     # Attack
			StatType.DEFENSE : [5, 12, 25, 37, 49, 70],     # Defense
			StatType.SPEED : [5, 12, 23, 34, 44, 65],       # Speed
			StatType.LUCK : [0, 0, 0, 0, 0],                # Luck
			StatType.HIT : [0, 0, 0, 0, 0],                 # Hit
			StatType.WALK_SPEED : [200, 200, 200, 200, 200] # Walk Speed
		},
		10, # Priority
		[  # All Skills
			"knifeguy", "another_skill"
		]
	))
	
#endregion
