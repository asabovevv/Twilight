# I recommend you close up all the functions and only open them as you need them.
extends Node

## --- --- --- --- --- --- --- --- General Global Variables --- --- --- --- --- --- --- ---

var Version : float = 0.002 # Useful for save-files

var ui : Node2D # Whatever node is the current UI root.
var camera : Node2D # Whatever node is the currently used cameras root.
var entrance : int = 0 # Stores which way a room was entered from a previous room.
var room : String # Stores last loaded overworld room's path.

## --- --- --- --- --- --- --- --- Options --- --- --- --- --- --- --- --- 

class Set:
	# Visual
	var is_fullscreen : bool = false
	
	func set_fullscreen(full : bool) -> void:
		if full:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			is_fullscreen = false
	func toggle_fullscreen() -> void:
		if !is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			is_fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			is_fullscreen = false
	
	# Audio
	enum Volumes { SoundEffect, MusicEffect, AmbientSound, AmbientMusic }
	var volume_levels : Array = [0.8, 0.8, 0.8, 0.8]
	func load_sound(_path : String, _volumetype : Volumes, _parent : Node) -> Node:
		var sound = AudioStreamPlayer.new()
		sound.volume_linear = volume_levels[_volumetype]
		sound.stream = load(_path)
		_parent.add_child(sound)
		return sound
	
	# Text
	var text_scroll_speed = 60
	
var Settings : Set

## --- --- --- --- --- --- --- --- Party Info --- --- --- --- --- --- --- --- --- ---

# Class of constant values referenced by party_member.gd's init()
class PartyMemberConst:
	var name : String
	var asset_path : String
	var battle_portrait_folder_path : String
	var battle_portrait : Portrait
	var level_up_stats : Dictionary[String, Array]
	var round_priority : int
	var all_skills : Array[String]
	
	func _init( _name : String,
				_asset_path: String,
				_battle_portrait_folder_path : String,
				_battle_portrait : Portrait,
				_level_up_stats : Dictionary[String, Array],
				_round_priority : int,
				_all_skills : Array[String]) -> void:
		
		name = _name
		asset_path = _asset_path
		battle_portrait_folder_path = _battle_portrait_folder_path
		battle_portrait = _battle_portrait
		level_up_stats = _level_up_stats
		round_priority = _round_priority
		all_skills = _all_skills
func get_party_constants() -> Dictionary: # Array of constant values referenced by party_member.gd's init()
	return {
		# Aubrey
		"aubrey" : PartyMemberConst.new(  "Aubrey", "res://CHARACTERS/Aubrey/", # name, asset_path
									"res://UI/Portraits/AubreyBattle/", # Battle Portrait Folder
								Portrait.new(
									"Aub_Battle", # Name
									Rect2i(0, 0, 0, 0),# Battle Crop 
									Rect2i(0, 0, 0, 0) # Dialogue Crop
								),
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
							)
							
			}

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
	
	
	#func refresh_skills() -> void:
		#Skills.clear()
		#for i in range(Skill_LV.size()):
			#if Skill_LV[i] <= Level:
				#Skills.append(Skill_Names[i])
		#for i in range(Skills_Special.size()):
			#Skills.append(Skills_Special[i])
		#
		## Move active skills from Skills[] to Skills_Active[]
		#var remove_positions : Array = []
		#for i in range(Skills.size()):
			#for j in range(Skills_Active.size()):
				#if Skills[i] == Skills_Active[j].name:
					#remove_positions.append(i)
		#for i in range(remove_positions.size()-1, -1, -1):
			#Skills.remove_at(remove_positions[i])
		#
		#Skills.append("------------")
	
	
	#func swap_skill(_active_skill_index : int, _new_skill_index : int) -> void:
		#var new_skill : Resource = TWILIGHT.skill(Skills[_new_skill_index])
		#
		#if new_skill != null:
			#if _active_skill_index < Skills_Active.size():
				#Skills_Active[_active_skill_index] = new_skill
			#else:
				#Skills_Active.append(new_skill)
		#else:
			#Skills_Active.remove_at(_active_skill_index)
		#
		#refresh_skills()

# All of a member's values
class PartyMemberData:
	var key : String # Ex: aubrey
	var name : String # Ex: Aubrey
	var asset_path : String # res://CHARACTERS/...
	var active : bool # Used to skip over party member in battle or while tagging
	
	# Stats
	var level_up_stats : Dictionary[String, Array] # used for setting new max values on level-up
	var base_stats : Dictionary[String, int] # max hp/juice, base attack, base def
	var current_stats : Dictionary[String, int] # base stats + weapons/charms & current health
	
	var level : int
	@warning_ignore("shadowed_global_identifier")
	var exp : int
	
	# Battle
	var current_emotion : Emotion
	var status_effects : Array[StatusEffect]
	var round_priority : int # previously TurnPriority
	
	var battle_portrait_folder_path : String
	var battle_portrait : Portrait
	
	# Accessories
	var weapon : String = ""
	var charm : String = ""
	
	# Skills
	var all_skills : Array[String] # Skills that can be unlocked with leveling / certain flags set
	var unlocked_skills : Array[String] # All currently unlocked skills (Stored as just their names)
	var active_skills : Array[String] = [""] # List of pointers to entries in Skills. What appears in battle.
	
	# Overworld
	var line_position : int = 0
	
	func _init( _key : String,
				_name : String,
				_asset_path : String,
				_battle_portrait_folder_path : String,
				_battle_portrait : Portrait,
				_level_up_stats : Dictionary[String, Array],
				_round_priority : int,
				_all_skills : Array[String]
	) -> void:
		key = _key
		
		name = _name
		asset_path = _asset_path
		battle_portrait_folder_path = _battle_portrait_folder_path
		battle_portrait = _battle_portrait
		level_up_stats = _level_up_stats
		round_priority = _round_priority
		all_skills = _all_skills
	
	func load_stats(
					_level : int,
					_exp : int,
					_weapon : String,
					_charm : String,
					_line_position : int,
					_active_skills : Array[String]
					) -> void:
		current_emotion = Registry.get_emotion("neutral")
		weapon = _weapon
		charm = _charm
		line_position = _line_position
		active_skills = _active_skills
		
		set_level(_level, _exp)
	
	func set_level(_level, _exp) -> void:
		level = _level
		exp = _exp
		
		# Set Max Stats
		base_stats[StatType.HEART] = get_level_stat(_level, StatType.HEART)
		base_stats[StatType.JUICE] = get_level_stat(_level, StatType.JUICE)
		base_stats[StatType.ATTACK] = get_level_stat(_level, StatType.ATTACK)
		base_stats[StatType.DEFENSE] = get_level_stat(_level, StatType.DEFENSE)
		base_stats[StatType.SPEED] = get_level_stat(_level, StatType.SPEED)
		base_stats[StatType.LUCK] = get_level_stat(_level, StatType.LUCK)
		base_stats[StatType.HIT] = get_level_stat(_level, StatType.HIT)
		base_stats[StatType.WALK_SPEED] = get_level_stat(_level, StatType.WALK_SPEED)
		
		# Set Current Stats
		current_stats[StatType.HEART] = base_stats[StatType.HEART]
		current_stats[StatType.JUICE] = base_stats[StatType.JUICE]
		current_stats[StatType.ATTACK] = base_stats[StatType.ATTACK]
		current_stats[StatType.DEFENSE] = base_stats[StatType.DEFENSE]
		current_stats[StatType.SPEED] = base_stats[StatType.SPEED]
		current_stats[StatType.LUCK] = base_stats[StatType.LUCK]
		current_stats[StatType.HIT] = base_stats[StatType.HIT]
		current_stats[StatType.WALK_SPEED] = base_stats[StatType.WALK_SPEED]
		
		unlocked_skills.clear()
		
		for i in all_skills:
			var skill = Registry.get_skill(i)
			if skill != null:
				
				var level_check : bool = (skill.level_requirement < level)
				var flag_check : bool = TWILIGHT.Flags.get_flag( skill.required_flag ) || (skill.required_flag == -1)
				
				if level_check && flag_check:
					
					unlocked_skills.append(i)
	
	func get_level_stat(_level, stattype : String) -> int:
		return lerp(level_up_stats[stattype][floor(_level*0.1)], level_up_stats[stattype][ceil(_level*0.1)], (_level % 10)*0.1 )
	
	# Returns xp required to get to specified level from level 1.
	func get_required_exp(_level : int) -> int: 
		@warning_ignore("narrowing_conversion")
		return -0.19*pow(_level, 3) + 18.54*pow(_level, 2) - 8.8*_level + 41.76
	
	func swap_item(_replacing_item_name : String, _inventory : Inv) -> void:
		if !_inventory.contents.has(_replacing_item_name):
			print(_replacing_item_name, " not in inventory.")
			return
		
		_inventory.contents[weapon] = 1
		_inventory.contents[_replacing_item_name] = 0
		weapon = _replacing_item_name

class PartyData:
	var fast_emotion : Array[String] = [ "neutral" ] # Array of emotions available in overworld quicktag
	var all_members : Dictionary[String, PartyMemberData] # All party members
	var current_party : Array[String] # Current party members
		
var Party : PartyData

## --- --- --- --- --- --- --- --- Inventory --- --- --- --- --- --- --- --- ---

# Contains Inventory items as well as items currently used by Party Members.
class Inv:
	var contents : Dictionary[String, int]
	
	func _init(_contents : Dictionary[String, int] = { "Empty" : 0 }) -> void:
		contents = _contents # in use == 0 for weapons/charms (1 == unused)
var Inventory : Inv

## --- --- --- --- --- --- --- --- Story Flags --- --- --- --- --- --- --- --- --- --- --- --- ---

# Flags are stored as bits within story_flags, meaning 64 flags per array entry.
# Inputting a number >63 in set_flag/get_flag will automatically increase the array index.
class FlagData:
	var story_flags : Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	enum Flag_Name {
		Tag_Enabled
	}
	
	func set_flag(flag_number : int, value : bool) -> void:
		var flag_entry : int = flag_number % 64
		@warning_ignore("integer_division")
		var array_entry : int = floor( (flag_number - flag_entry)/64 )
		var flag_value : int = int( pow(2, flag_entry) )
		# Clear flag
		story_flags[array_entry] ^= 1 << flag_value
		# Set flag
		if value:
			story_flags[array_entry] |= 1 << flag_value
	func get_flag(flag_number : int) -> bool:
		var flag_entry = flag_number % 64
		@warning_ignore("integer_division")
		var array_entry = floor( (flag_number - flag_entry)/64 )
		var flag_value : int = int( pow(2, flag_entry) )
		return story_flags[array_entry] & (1 << flag_value ) != 0
var Flags : FlagData

## --- --- --- --- --- --- --- --- --- --- Save / Load --- --- --- --- --- --- --- --- --- ---

func save_to_slot(slot : int) -> void:
	var file = FileAccess.open("user://Save%d_%f.dat" % [slot, Version], FileAccess.WRITE)
	
	# Settings
	for i in Settings.volume_levels:
		file.store_float(i)
	
	# Flags
	for i in Flags.story_flags:
		file.store_64(i)
	
	# Inventory
	file.store_var(Inventory.contents)
	
	# Party Member Data
	for member in Party.all_members:
		file.store_16(Party.all_members[member].level)
		file.store_16(Party.all_members[member].exp)
		file.store_pascal_string(Party.all_members[member].weapon)
		file.store_pascal_string(Party.all_members[member].charm)
		file.store_8(Party.all_members[member].line_position)
		file.store_var(Party.all_members[member].unlocked_skills)
		file.store_var(Party.all_members[member].active_skills)
	
	# Party Order + Size
	file.store_8(Party.current_party.size()) # Party Size
	
	for i in range( Party.current_party.size() ): # Current Party
		file.store_pascal_string( Party.current_party[i] )
	
	# Party Quick Emotions
	file.store_var( Party.fast_emotion )
	
	file.close()

func load_from_slot(slot : int) -> void:
	
	var _party_constants : Dictionary = get_party_constants()
	
	# SAVE FILE EXISTS
	if FileAccess.file_exists("user://Save%d_%f.dat" % [slot, Version]) && (slot != -1):
		var file = FileAccess.open("user://Save%d_%f.dat" % [slot, Version], FileAccess.READ)
		
		# Settings
		Settings = Set.new()
		for i in Settings.volume_levels:
			Settings.volume_levels[i] = file.get_float()
		
		# Flags
		Flags = FlagData.new()
		for i in Flags.story_flags:
			Flags.story_flags[i] = file.get_64()
		
		# Inventory
		Inventory = Inv.new()
		Inventory.contents = file.get_var() as Dictionary[String, int]
		
		# Party Member Data
		Party = PartyData.new()
		Party.all_members.clear()
		for i in _party_constants:
			# Add Party Member + Constants
			Party.all_members[i] = PartyMemberData.new(
				 					i,
									_party_constants[i].name,
									_party_constants[i].asset_path,
									_party_constants[i].battle_portrait_folder_path,
									_party_constants[i].battle_portrait,
									_party_constants[i].level_up_stats,
									_party_constants[i].round_priority,
									_party_constants[i].all_skills
									)
			
			# Load Party Member Stats
			Party.all_members[i].load_stats(
				file.get_16(), # level
				file.get_16(), # exp
				file.get_pascal_string(), # weapon
				file.get_pascal_string(), # charm
				file.get_8(), # line position
				file.get_var() as Array[String] # active_skills
			)
		
		# Party Order + Size
		var party_size = file.get_8() # Party Size
		for i in range( party_size ): # Current Party
			Party.current_party.append( file.get_pascal_string() )
		
		# Party Quick Emotions
		var fastemotion = file.get_var()
		Party.fast_emotion = fastemotion as Array[String] 
		
		file.close()
		
	else: # SAVE FILE DOESN'T EXIST
	
		# Settings
		Settings = Set.new()
		Settings.volume_levels = [0.8, 0.8, 0.8, 0.8]
		
		# Flags
		Flags = FlagData.new()
		Flags.story_flags = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		# Inventory
		Inventory = Inv.new()
		Inventory.contents = { "Empty" : 0 }
		
		# Party Member Data
		Party = PartyData.new()
		Party.all_members.clear()
		for i in _party_constants:
			# Add Party Member + Constants
			Party.all_members[i] = PartyMemberData.new(
				 					i,
									_party_constants[i].name,
									_party_constants[i].asset_path,
									_party_constants[i].battle_portrait_folder_path,
									_party_constants[i].battle_portrait,
									_party_constants[i].level_up_stats,
									_party_constants[i].round_priority,
									_party_constants[i].all_skills
									)
			
			# Load Party Member Stats
			Party.all_members[i].load_stats(
				1, # level
				0, # exp
				"", # weapon
				"", # charm
				0, # line position
				[""] # active_skills
			)
		
		# Party Order + Size
		for i in range( 1 ): # Current Party
			Party.current_party.append( "aubrey" )
		
		# Party Quick Emotions
		Party.fast_emotion = [ "neutral" ]
