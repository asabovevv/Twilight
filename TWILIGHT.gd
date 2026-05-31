extends Node

## --- --- --- --- --- --- --- --- General Global Variables --- --- --- --- --- --- --- ---
var entrance : int = 0 # Tracks which way a room was entered from a previous room.
var encounter : Encounter # Determines encounter setup on encounter room entered

## --- --- --- --- --- --- --- --- Options --- --- --- --- --- --- --- --- 

# Audio
enum Volumes { SoundEffect, MusicEffect, AmbientSound, AmbientMusic }
var volume_levels : Array # Default [0.8, 0.8, 0.8, 0.8]
func load_sound(_path : String, _volumetype : Volumes, _parent : Node) -> Node:
	var sound = AudioStreamPlayer.new()
	sound.volume_linear = volume_levels[_volumetype]
	sound.stream = load(_path)
	_parent.add_child(sound)
	return sound

# Text
var text_scroll_speed = 60

## --- --- --- --- --- --- --- --- Player Info --- --- --- --- --- --- --- --- --- ---
const LvlUp_Threshold = [0, 20, 40, 60, 80, 100, 200, 400, 600, 800] #lv 0-9

# PartyMember_Const values are all intialized independent of save files and passed into PartyMember on load.
# Used to set up PartyMember
class PartyMember_Const:
	var Name : String
	var Path : String
	var PortraitOffset : int
	var BattleClip : Rect2i
	var PortraitClip : Rect2i
	var HeartLV : Array[int] = []
	var JuiceLV : Array[int] = []
	var AtkLV : Array[int] = []
	var DefLV : Array[int] = []
	var SPDLV : Array[int] = []
	var Luck : int
	
	var TurnPriority : int
	var SkillNames : Array[String] = []
	var SkillLv : Array[int] = []
	
	func _init(_name : String, path: String, po : int, bc : Rect2i, pc : Rect2i, hlv : Array, jlv : Array, atklv : Array, deflv : Array, spdlv : Array, luck : int, priority : int, skillname : Array, skilllv : Array) -> void:
		Name = _name
		Path = path
		PortraitOffset = po
		BattleClip = bc
		PortraitClip = pc
		HeartLV = hlv
		JuiceLV = jlv
		AtkLV = atklv
		DefLV = deflv
		SPDLV = spdlv
		Luck = luck
		TurnPriority = priority
		
		SkillNames = skillname
		SkillLv = skilllv
func get_party_constants() -> Array: # Used ONLY for saving and loading. Get your constants from PartyMember.
	return [
		# Aubrey
		PartyMember_Const.new("AUBREY",
							"res://CHARACTERS/Aubrey/", # path
							0, #portrait offset
							Rect2i(0, 68, 363, 104), # battle clip rect
							Rect2i(0, 68, 363, 104), # portrait clip rect
							[33, 93, 164, 226, 300, 444] as Array[int], #hrt (every 10)
							[7, 31, 56, 78, 109, 150] as Array[int], #juc (every 10)
							[5, 20, 40, 56, 75, 110] as Array[int], #atk (every 10)
							[1, 12, 25, 37, 49, 70] as Array[int], #def (every 10)
							[1, 12, 23, 34, 44, 65] as Array[int], #spd (every 10)
							0, 2, #lck, priority
							["KNIFEGUY", "ANOTHER_SKILL"] as Array[String], # skill names
							[1, 5] as Array[int]), # skill lvs
		
		# SUNNY (HS)
		PartyMember_Const.new("SUNNY",
							"res://CHARACTERS/Sunny/", # path
							0, # portrait offset
							Rect2i(0, 17, 363, 104), # battle clip rect
							Rect2i(0, 17, 363, 104), # portrait clip rect
							[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							[9, 31, 56, 78, 109, 150] as Array[int], #juc
							[10, 20, 40, 56, 75, 110] as Array[int], #atk
							[5, 12, 25, 37, 49, 70] as Array[int], #def
							[5, 12, 23, 34, 44, 65] as Array[int], #spd
							0, 6, #lck, priority
							[] as Array[String], # skill names
							[] as Array[int]), # skill lvs
		
		# MARI (HS)
		PartyMember_Const.new("MARI",
							"res://CHARACTERS/Mari/", # path
							1, # portrait offset
							Rect2i(18, 33, 264, 76), # battle clip rect
							Rect2i(8, 17, 318, 104), # portrait clip rect
							[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							[9, 31, 56, 78, 109, 150] as Array[int], #juc
							[10, 20, 40, 56, 75, 110] as Array[int], #atk
							[5, 12, 25, 37, 49, 70] as Array[int], #def
							[5, 12, 23, 34, 44, 65] as Array[int], #spd
							0, 100, #lck, priority
							[] as Array[String], # skill names
							[] as Array[int]), # skill lvs
		
		# KEL (HS)
		PartyMember_Const.new("KEL",
							"res://CHARACTERS/Kel/", # path
							0, # portrait offset
							Rect2i(10, 17, 318, 104), # battle clip rect
							Rect2i(10, 17, 318, 104), # portrait clip rect
							[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							[9, 31, 56, 78, 109, 150] as Array[int], #juc
							[10, 20, 40, 56, 75, 110] as Array[int], #atk
							[5, 12, 25, 37, 49, 70] as Array[int], #def
							[5, 12, 23, 34, 44, 65] as Array[int], #spd
							0, 0, #lck, priority
							[] as Array[String], # skill names
							[] as Array[int]), # skill lvs
		
		# HERO (HS)
		PartyMember_Const.new("HERO",
							"res://CHARACTERS/Hero/", # path
							0, # portrait offset
							Rect2i(10, 17, 318, 104), # battle clip rect
							Rect2i(10, 17, 318, 104), # portrait clip rect
							[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							[9, 31, 56, 78, 109, 150] as Array[int], #juc
							[10, 20, 40, 56, 75, 110] as Array[int], #atk
							[5, 12, 25, 37, 49, 70] as Array[int], #def
							[5, 12, 23, 34, 44, 65] as Array[int], #spd
							0, 4, #lck, priority
							[] as Array[String], # skill names
							[] as Array[int]), # skill lvs
		
		# BASIL (HS)
		PartyMember_Const.new("BASIL",
							"res://CHARACTERS/Basil/", # path
							0, # portrait offset
							Rect2i(6, 33, 264, 76), # battle clip rect
							Rect2i(10, 17, 318, 104), # portrait clip rect
							[36, 93, 164, 226, 300, 444] as Array[int], #hrt
							[9, 31, 56, 78, 109, 150] as Array[int], #juc
							[10, 20, 40, 56, 75, 110] as Array[int], #atk
							[5, 12, 25, 37, 49, 70] as Array[int], #def
							[5, 12, 23, 34, 44, 65] as Array[int], #spd
							0, 100, #lck, priority
							[] as Array[String], # skill names
							[] as Array[int]) # skill lvs
	]

# Character Info Class
class PartyMember:
	var Name : String
	var Path : String
	var Const_ID : int
	
	var TurnPriority : int
	var Portrait_Off : int
	var Battle_Crop_Rect : Rect2i
	var Portrait_Crop_Rect : Rect2i
	
	var Heart : int
	var Heart_Max : int
	var Juice : int
	var Juice_Max : int
	var Attack_Base : int
	var Defense_Base : int
	var Speed_Base : int
	var Level : int
	var Exp : int
	
	var Weapon : Resource = null
	var Charm : Resource = null
	var Emotion : Resource = null
	
	var Skills : Array[String] = [] # All currently unlocked skills (Stored as just their names)
	var Skills_Active : Array[Resource] = [] # Up to 6 active skills from Skills[] (Loaded as Resources)
	var Skills_Special : Array[String] = [] # Skills that can be unlocked without leveling
	var Skill_Names : Array[String] = [] # Skills that can be unlocked with leveling
	var Skill_LV : Array[int] = [] # Levels that skills are unlocked at.
	
	var Heart_LV : Array[int] = []
	var Juice_LV : Array[int] = []
	var Attack_LV : Array[int] = []
	var Defense_LV : Array[int] = []
	var Speed_LV : Array[int] = []
	var Luck_LV : int
	var Hit_LV : int
	
	func _init(const_id : int, member_stats : PartyMember_Const) -> void:
		Const_ID = const_id
		
		Name = member_stats.Name
		Path = member_stats.Path
		Portrait_Off = member_stats.PortraitOffset
		Battle_Crop_Rect = member_stats.BattleClip
		Portrait_Crop_Rect = member_stats.PortraitClip
		Heart_LV = member_stats.HeartLV
		Juice_LV = member_stats.JuiceLV
		Attack_LV = member_stats.AtkLV
		Defense_LV = member_stats.DefLV
		Speed_LV = member_stats.SPDLV
		Luck_LV = member_stats.Luck
		TurnPriority = member_stats.TurnPriority
	
	func load_stats(member_stats : PartyMember_Const, _lvl : int, _exp : int, _sklsSpc : Array, _sklsActv : Array, _wpn : Resource, _chr : Resource, _emot : Resource) -> void:
		Skill_Names = member_stats.SkillNames
		Skill_LV = member_stats.SkillLv
		
		Skills_Special = _sklsSpc
		Skills_Active = _sklsActv
		Weapon = _wpn
		Charm = _chr
		Emotion = _emot
		set_level(_lvl, _exp)
	
	func set_level(_lvl, _exp) -> void:
		Heart_Max = lerp(Heart_LV[floor(_lvl*0.1)], Heart_LV[ceil(_lvl*0.1)], (_lvl % 10)*0.1 )
		Juice_Max = lerp(Juice_LV[floor(_lvl*0.1)], Juice_LV[ceil(_lvl*0.1)], (_lvl % 10)*0.1 )
		Attack_Base = lerp(Attack_LV[floor(_lvl*0.1)], Attack_LV[ceil(_lvl*0.1)], (_lvl % 10)*0.1 )
		Defense_Base = lerp(Defense_LV[floor(_lvl*0.1)], Defense_LV[ceil(_lvl*0.1)], (_lvl % 10)*0.1 )
		Speed_Base = lerp(Speed_LV[floor(_lvl*0.1)], Speed_LV[ceil(_lvl*0.1)], (_lvl % 10)*0.1 )
		
		Heart = Heart_Max
		Juice = Juice_Max
		Exp = _exp
		Level = _lvl
		
		refresh_skills()
	
	func refresh_skills() -> void:
		Skills.clear()
		for i in range(Skill_LV.size()):
			if Skill_LV[i] <= Level:
				Skills.append(Skill_Names[i])
		for i in range(Skills_Special.size()):
			Skills.append(Skills_Special[i])
		
		# Move active skills from Skills[] to Skills_Active[]
		var remove_positions : Array = []
		for i in range(Skills.size()):
			for j in range(Skills_Active.size()):
				if Skills[i] == Skills_Active[j].name:
					remove_positions.append(i)
		for i in range(remove_positions.size()-1, -1, -1):
			Skills.remove_at(remove_positions[i])
		
		Skills.append("------------")
	
	func swap_weapon(_i : int, _inventory : Inv) -> void:
		var new_weapon : Resource = TWILIGHT.equippable(_inventory.Weapons[_i])
		
		if new_weapon != null:
			_inventory.Weapons.remove_at(_inventory.Weapons.size()-1)
		
		if Weapon != null:
			var _name = Weapon.name
			for i in range(_name.length()):
				if _name[i] == "_":
					_name[i] = " "
			_inventory.Weapons.append(_name)
		
		_inventory.Weapons.append("------------")
		
		_inventory.Weapons.remove_at(_i)
		Weapon = new_weapon
	func swap_charm(_i : int, _inventory : Inv) -> void:
		var new_charm = TWILIGHT.equippable(_inventory.Charms[_i])
		
		if new_charm != null:
			_inventory.Charms.remove_at(_inventory.Charms.size()-1)
		
		if Charm != null:
			var _name = Charm.name
			for i in range(_name.length()):
				if _name[i] == "_":
					_name[i] = " "
			_inventory.Charms.append(_name)
		
		_inventory.Charms.append("------------")
		
		_inventory.Charms.remove_at(_i)
		Charm = new_charm
	func swap_skill(_active_skill_index : int, _new_skill_index : int) -> void:
		var new_skill : Resource = TWILIGHT.skill(Skills[_new_skill_index])
		
		if new_skill != null:
			if _active_skill_index < Skills_Active.size():
				Skills_Active[_active_skill_index] = new_skill
			else:
				Skills_Active.append(new_skill)
		else:
			Skills_Active.remove_at(_active_skill_index)
		
		refresh_skills()

var Party_Size : int = 1 # Mainly used for menus
var Party_Fast_Emotion : Array[String] = [] # Might scrap
# All_Characters contains all character information in the party or otherwise
var All_Characters : Array = []
# Party_Order contains references to indexes from All_Characters that are currently in the party
# Position in the array determines position in line in the overworld, with the player controlling id 0.
var Party_Order : Array = []

func get_char_data(name : String) -> PartyMember: # Return pointer to character data
	for i in range(All_Characters.size()):
		if All_Characters[i].Name == name:
			return All_Characters[i]
	return null
func get_char_id(name : String) -> int: # Position in All_Characters
	for i in range(All_Characters.size()):
		if All_Characters[i].Name == name:
			return i
	return -1
func get_char_party_order(name : String): # Position in Party_Order
	for i in range(Party_Order.size()):
		if Party_Order[i].Name == name:
			return i
	return -1
func add_char_to_party( name : String ) -> void:
	Party_Order.append( get_char_data(name) )
func get_required_exp(target_level : int) -> int: # Exp required to get to the next level
	return -0.19*pow(target_level, 3) + 18.54*pow(target_level, 2) - 8.8*target_level + 41.76

## --- --- --- --- --- --- --- --- Inventory --- --- --- --- --- --- --- --- ---
class Inv:
	var Weapons : Array[String] = []
	var Charms : Array[String] = []
	var Snacks : Array[String] = []
	var Toys : Array[String] = []
	var Important : Array[String] = []
	var Key_Items : Array[String] = [] # Stuff like map and hangman
	
	var Item_Count : Array
	
	func _init(_wpn, _chr, _snk, _toy, _imp, _key, _itmCnt) -> void:
		Weapons = array_insert(_wpn)
		Weapons.append("------------")
		Charms = array_insert(_chr)
		Charms.append("------------")
		Snacks = array_insert(_snk)
		Toys = array_insert(_toy)
		Important = array_insert(_imp)
		Key_Items = array_insert(_key)
		
		if _itmCnt != null:
			Item_Count = array_insert(_itmCnt)
		else:
			Item_Count = [[], []]
	
	func array_insert(array) -> Array:
		if array != null:
			return array
		return [] as Array[String]
	
	func has_item(list : Array, name : String) -> bool:
		for i in list:
			if i == name:
				return true
		return false

var Inventory : Inv

func equippable(_name : String) -> Resource:
	for i in range(_name.length()):
		if _name[i] == " ":
			_name[i] = "_"
	return load("res://RESOURCES/Equippable/"+_name+".tres")
func item(_name : String) -> Resource:
	for i in range(_name.length()):
		if _name[i] == " ":
			_name[i] = "_"
	return load("res://RESOURCES/Items/"+_name+".tres")
func skill(_name : String) -> Resource:
	for i in range(_name.length()):
		if _name[i] == " ":
			_name[i] = "_"
	return load("res://RESOURCES/Skills/"+_name+".tres")
func emotion(_name : String) -> Resource:
	return load("res://RESOURCES/Emotion/"+_name+".tres")

## --- --- --- --- --- --- --- --- Story Flags --- --- --- --- --- --- --- --- --- --- --- --- ---
# Flags are stored as bits within story_flags, meaning 64 flags per array entry.
# Inputting a number >63 in set_flag/get_flag will automatically increase the array index.
var story_flags : Array[int] # [0, 0, 0, 0, 0, 0, 0, 0]
enum Flag_Name {
	Pinkspace_Intro_Finished
}
func set_flag(flag_number : int, value : bool) -> void:
	var flag_entry : int = flag_number % 64
	var array_entry : int = floor( (flag_number - flag_entry)/64 )
	var flag_value : int = int( pow(2, flag_entry) )
	# Clear flag
	story_flags[array_entry] ^= 1 << flag_value
	# Set flag
	if value:
		story_flags[array_entry] |= 1 << flag_value
func get_flag(flag_number : int) -> bool:
	var flag_entry = flag_number % 64
	var array_entry = floor( (flag_number - flag_entry)/64 )
	var flag_value : int = int( pow(2, flag_entry) )
	return story_flags[array_entry] & (1 << flag_value ) != 0

## --- --- --- --- --- --- --- --- --- --- Save / Load --- --- --- --- --- --- --- --- --- ---
func save_to_slot(slot : int) -> void:
	var file = FileAccess.open("user://Save%d.dat" % [slot], FileAccess.WRITE)
	#Volume Levels
	for i in volume_levels:
		file.store_float(i)
	#Flags
	for i in story_flags:
		file.store_64(i)
	#Inventory
	save_store_inv(file)
	#PartyMember
	file.store_16(All_Characters.size())
	for i in All_Characters:
		_save_store_partymember(file, i)
	#Party Order + Size
	file.store_16(Party_Size)
	var list : Array
	for i in Party_Order:
		list.append(i.Const_ID)
	file.store_var(list )
	# Party Quick Emotions
	file.store_var(Party_Fast_Emotion )
	
	file.close()
func load_from_slot(slot : int) -> void:
	
	var Party_Constants : Array = get_party_constants()
	
	# SAVE FILE EXISTS
	if FileAccess.file_exists("user://Save%d.dat" % [slot]):
		var file = FileAccess.open("user://Save%d.dat" % [slot], FileAccess.READ)
		
		#Volume Levels
		for i in volume_levels:
			i = file.get_float()
		#Flags
		for i in story_flags:
			i = file.get_64()
		#Inventory
		load_get_inv(file)
		#PartyMember
		All_Characters.clear()
		var char_amt = file.get_16()
		for i in char_amt:
			var id : int = file.get_64()
			load_get_partymember(file, id, Party_Constants[id])
		#Party Order + Size
		Party_Size = file.get_16()
		Party_Order.clear()
		var id_array = file.get_var()
		for i in range(Party_Size):
			for j in All_Characters:
				if j.Const_ID == id_array[i]:
					Party_Order.append(j)
		print(All_Characters)
		print(Party_Order)
		# Party Quick Emotions
		var pfe = file.get_var()
		if pfe != null:
			Party_Fast_Emotion = pfe
		else:
			Party_Fast_Emotion = ["Neutral"]
	
	else: # SAVE FILE DOESN'T EXIST
		#Volume Levels
		volume_levels = [0.8, 0.8, 0.8, 0.8]
		#Flags
		story_flags = [0, 0, 0, 0, 0, 0, 0, 0]
		#Inventory
		var s_array : Array[String] = [] 
		Inventory = Inv.new(s_array, s_array, s_array, s_array, s_array, s_array, [[0], [0]])
		#PartyMember
		for i in range(Party_Constants.size()):
			All_Characters.append(PartyMember.new(i, Party_Constants[i]) )
			All_Characters[i].load_stats(Party_Constants[i], 1, 0, [] as Array[Resource], [] as Array[Resource], null, null, emotion("Neutral"))
		
		#Party Order + Size
		Party_Size = 6
		Party_Order = [All_Characters[0], All_Characters[1], All_Characters[2], All_Characters[3], All_Characters[4], All_Characters[5]]
		
		# Party Quick Emotions
		Party_Fast_Emotion = ["Neutral"]

# Functions that assist in saving/loading. Don't bother touching.
func save_store_inv(file) -> void:
	file.store_var(Inventory.Weapons)
	file.store_var(Inventory.Charms)
	file.store_var(Inventory.Snacks)
	file.store_var(Inventory.Toys)
	file.store_var(Inventory.Important)
	file.store_var(Inventory.Key_Items)
	file.store_var(Inventory.Item_Count)
func load_get_inv(file) -> void:
	Inventory = Inv.new(file.get_var(),
						file.get_var(),
						file.get_var(),
						file.get_var(),
						file.get_var(),
						file.get_var(),
						file.get_var())
func _save_store_partymember(file, member : PartyMember) -> void:
	file.store_64(member.Const_ID)
	file.store_64(member.Level)
	file.store_64(member.Exp)
	
	file.store_var(member.Skills_Special)
	
	var skill_list : Array[String]
	for i in member.Skills_Active:
		skill_list.append(i.name)
	file.store_var(skill_list)
	
	if member.Weapon != null:
		file.store_pascal_string(member.Weapon.name)
	else:
		""
	if member.Charm != null:
		file.store_pascal_string(member.Charm.name)
	else:
		""
	if member.Emotion != null:
		file.store_pascal_string(member.Emotion.name)
	else:
		""
func load_get_partymember(file, const_id, const_member) -> void:
	All_Characters.append(PartyMember.new(const_id, const_member))
	
	var _char = All_Characters[All_Characters.size()-1]
	_char.load_stats(const_member,
					file.get_64(),
					file.get_64(),
					file.get_var(),
					file.get_var(),
					equippable(file.get_pascal_string()),
					equippable(file.get_pascal_string()),
					emotion(file.get_pascal_string()) )
