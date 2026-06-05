# I recommend you close up all the functions and only open them as you need them.
extends Node

## --- --- --- --- --- --- --- --- General Global Variables --- --- --- --- --- --- --- ---

var Version : float = 0.002 # Useful for save-files

var ui : Node2D # Whatever node is the current UI root.
var camera : Node2D # Whatever node is the currently used cameras root.
var entrance : int = 0 # Stores which way a room was entered from a previous room.
var room : String # Stores last loaded overworld room's path.

var d : Dictionary[String, Array] # Contains all loaded branches of dialogue, accessed via name
var Languages = { English = "English" }
var language : String = Languages.English

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

var Settings : Set = Set.new()

## --- --- --- --- --- --- --- --- Party Info --- --- --- --- --- --- --- --- --- ---

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
		Tag_Enabled, Happy_Swap_Unlocked, Sad_Swap_Unlocked, Angry_Swap_Unlocked
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
	for id in Party.all_members:
		var member : PartyMember = Party.all_members[id]
		file.store_16(member.current_health)
		file.store_16(member.current_juice)
		file.store_16(member.level)
		file.store_16(member.experience)
		file.store_pascal_string(member.weapon)
		file.store_pascal_string(member.charm)
		file.store_8(member.line_position)
		file.store_var(member.active_skills) # we don't need to store unlocked_skills since that's derived at runtime
	
	# Party Order + Size
	file.store_8(Party.current_party.size())
	for member in Party.current_party:
		file.store_pascal_string(member.data.key)
	
	# Party Quick Emotions
	file.store_var(Party.fast_emotion)
	
	file.close()

func load_from_slot(slot : int) -> void:
	
	## TEMP!!!!
	load_dialogue_file(language, "Dream1.txt")
	
	# SAVE FILE EXISTS
	if FileAccess.file_exists("user://Save%d_%f.dat" % [slot, Version]) && (slot != -1):
		var file = FileAccess.open("user://Save%d_%f.dat" % [slot, Version], FileAccess.READ)
		
		# Settings
		Settings = Set.new()
		for i in range(Settings.volume_levels.size()):
			Settings.volume_levels[i] = file.get_float()
		
		# Flags
		Flags = FlagData.new()
		for i in range(Flags.story_flags.size()):
			Flags.story_flags[i] = file.get_64()
		
		# Inventory
		Inventory = Inv.new()
		Inventory.contents = file.get_var() as Dictionary[String, int]
		
		# Party Member Data
		Party = PartyData.new()
		Party.all_members.clear()
		for data in Registry.party_members.all():
			var member := PartyMember.new(data)
			member.current_health = file.get_16() # current health
			member.current_juice = file.get_16() # current juice
			member.load_stats(
				file.get_16(), 					# level
				file.get_16(), 					# experience
				file.get_pascal_string(), 		# weapon
				file.get_pascal_string(), 		# charm
				file.get_8(), 					# line_position
				file.get_var() as Array[String] # active_skills
			)
			Party.all_members[data.key] = member
		
		# Party Order + Size
		var party_size = file.get_8() # Party Size
		for i in range(party_size):
			var id := file.get_pascal_string() # Party Member Id
			if Party.all_members.has(id):
				Party.current_party.append(Party.all_members[id])
		
		# Party Quick Emotions
		Party.fast_emotion = file.get_var() as Array[String] 
		
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
		for data in Registry.party_members.all():
			var member := PartyMember.new(data)
			member.load_stats(1, 0, Equippable.NONE, Equippable.NONE, 0, [""])
			member.current_health = member.base_stats[StatType.HEART]
			member.current_juice = member.base_stats[StatType.JUICE]
			Party.all_members[data.key] = member
		
		# Party Order + Size
		Party.current_party.append(Party.all_members["aubrey"])
		
		# Party Quick Emotions
		Party.fast_emotion = ["neutral"]

# Iterates through a text file, breaking lines into dialogue branch headers and dialogue branch contents
func load_dialogue_file(_language : String, file_name : String) -> void:
	if FileAccess.file_exists("res://LANGUAGE/" + _language + "/" + file_name):
		var langfile = FileAccess.open( "res://LANGUAGE/" + _language + "/" + file_name, FileAccess.READ)
	
		var read_line : String = langfile.get_line()
		while read_line != "EOF":
	
			# Store first string as branch name
			var branch_name : String = read_line
			# If branch name has an indent, remove it
			branch_name = branch_name.remove_chars("\t")
	
			# Get the rest of the chunk for branch dialogue (Stop at empty line)
			var branch_dialogue : Array[String]
			var branch_line : String = langfile.get_line()
			while branch_line != "":
				branch_dialogue.append(branch_line)
				branch_line = langfile.get_line()
	
			# Append branch to main dialogue
			d[branch_name] = branch_dialogue
	
			# Advance, next we will check if the below line is EOF or another header
			read_line = langfile.get_line()
	
		langfile.close()
	
	else:
		print("Lang file: " + "res://LANGUAGE/" + language + "/" + file_name + " doesn't exist.")
