extends Node2D

@onready var animator = $Animator
@onready var d_main = $DialogueMain
@onready var text_main = $DialogueMain/Dialogue
@onready var p_main = $DialogueMain/Pointer
@onready var d_name = $DialogueName
@onready var d_portrait_cont = $PortraitsAndChoices/HBoxPortraits
@onready var d_portrait_targets : Array = [$PortraitsAndChoices/HBoxPortraits/DialoguePortraitTarget]
@onready var d_choice_cont = $PortraitsAndChoices/DialogueChoiceTarget
@onready var d_choice = $PortraitsAndChoices/DialogueChoiceTarget/DialogueChoice
@onready var p_choice = $PortraitsAndChoices/DialogueChoiceTarget/DialogueChoice/Pointer
@onready var option = $PortraitsAndChoices/DialogueChoiceTarget/Option
var rand = RandomNumberGenerator.new()

var end_cutscene : bool = true

var time : float = 0.0
var wait_time : float = 0
var player : CharacterBody2D
var npc : Node2D

var dialogue : DialogueSequence
var dialogue_branch : int = 0
var dialogue_stage : int = 0
var dialogue_place : int = 0
var dialogue_scroll : float = 0
var dialogue_speed : float = Twilight.Settings.text_scroll_speed
var dialogue_paused : bool = false
var dialogue_sound_cooldown : float = 0

var await_animation : bool = false
var event_locations : Array[int]
var event_names : Array[String]

const p_base_off = Vector2(-16, 12)
var p_choice_base_pos = Vector2.ZERO
var current_choice : int = 0

var tsound : String = "SE_text_basic"
const portrait_location = "res://UI/Portraits/"
const font_path : String = "res://UI/Dialogue/"

var sounds : Array

func _process(delta: float) -> void:
	time += delta
	p_main.position = Vector2(544, 86) + Vector2(sin(time*5)*3, 0)
	p_choice.global_position = p_choice_base_pos + Vector2(sin(time*5)*3, 0) # change y value to menu pos
	
	_do_option_select()
	_do_text_crawl(delta)

func _do_option_select() -> void:
	if d_choice.get_child_count() > 1:
		
		if Input.is_action_just_pressed("Down"):
			current_choice -= 1
			Audio.play_sfx("SE_move1", 0.9)
		if Input.is_action_just_pressed("Up"):
			current_choice += 1
		
		if current_choice > d_choice.get_child_count()-2:
			current_choice = 0
		if current_choice < 0:
			current_choice = d_choice.get_child_count()-2
		
		p_choice_base_pos = d_choice.get_child( current_choice+1 ).global_position + Vector2(-24, 15)

func _do_text_crawl(delta: float) -> void:
	if await_animation:
		return
	if wait_time > 0:
		wait_time -= delta
		return
	
	match dialogue_stage:
		0: # text escape
			_text_escape()
			dialogue_stage = 1
		
		1: # text crawl
			
			# Scroll text
			if (text_main.visible_ratio < 1.0) && !dialogue_paused && wait_time <= 0:
				dialogue_scroll += delta * dialogue_speed
				text_main.visible_characters = dialogue_scroll
				
				# Make noise
				dialogue_sound_cooldown -= delta
				if dialogue_sound_cooldown <= 0:
					Audio.play_sfx(tsound, 0.9, rand.randf_range(0.8, 1.1))
					dialogue_sound_cooldown = 0.04
				
				# On new letter
				if (dialogue_scroll - delta * dialogue_speed) < floor(dialogue_scroll):
					
					# Check for events
					for i in range(event_locations.size()):
						if event_locations[i] == text_main.visible_characters:
							_text_event(event_names[i])
			
			if Input.is_action_just_pressed("Confirm"):
				if text_main.visible_ratio >= 1.0:
					_end_dialogue()
					
				elif dialogue_paused:
				# Text breaks
					dialogue_paused = false
					
				else:
				# Text skip
					for i in range(event_names.size()):
						# Check for breaks
						if event_names[i] == "br":
							if event_locations[i] > text_main.visible_characters:
								# Do all the other stuff between position and next break
								var max_pos : int = event_locations[i]
								for j in range(event_names.size()):
									if (event_locations[j] >= dialogue_scroll) && (event_locations[j] < max_pos):
										_text_event(event_names[i])
								
								# Go to next break, also no waiting
								wait_time = 0
								dialogue_scroll = event_locations[i] - 0.01
								return
					dialogue_scroll = 999
					text_main.visible_ratio = 1.0

func _text_escape() -> void:
	event_locations.clear()
	event_names.clear()
	dialogue_scroll = 0.99
	text_main.visible_characters = 0
	dialogue_speed = Twilight.Settings.text_scroll_speed
	sounds.clear()
	
	var i = 0
	
	if dialogue.dialogue_tree.is_empty():
		print("Failed to set dialogue")
		return
	
	while (dialogue.dialogue_tree[dialogue_branch][dialogue_place][i] == "|"):
		# Get this escape sequence
		var substring_end : int = _get_char_next_position(dialogue.dialogue_tree[dialogue_branch][dialogue_place], "|", i)
		var substring : String = dialogue.dialogue_tree[dialogue_branch][dialogue_place].substr(i+1, substring_end-i-1)
		# Always returns [name, x, y, ...]
		var escape_var : Array = _parse_substring(substring)
		
		# Execute escape
		match escape_var[0]:
			"dbox": # Visible = 1
				if escape_var.size() > 1:
					visible = int(escape_var[1])
				else:
					visible = true
			
			"name": # Text
				d_name.get_child(0).text = escape_var[1]
				d_name.visible = (escape_var[1] == "")
			
			"face": # Portrait Name, Portrait ID
				if escape_var.size() < 2:
					escape_var.append(0)
				if escape_var.size() < 3:
					escape_var.append(0)
				
				var tex = load( portrait_location + escape_var[1] + ".png")
				if tex != null:
					
					var myportrait = d_portrait_targets[ int(escape_var[2]) ].get_child(0).get_child(0)
					
					myportrait.texture = tex
					myportrait.hframes = ceil( tex.get_width() / 121.0 )
					#myportrait.position = # offset
					
					if !d_portrait_targets[ int(escape_var[2]) ].visible:
						d_portrait_targets[ int(escape_var[2]) ].visible = true
				else:
					d_portrait_targets[ int(escape_var[2]) ].visible = false
			
			"p": # Marker Char, Amount = 1
				var amt = 1
				if escape_var.size() > 2:
					amt = int(escape_var[2])
				for j in range(amt):
					event_locations.append( _find_position_marker(escape_var[1], substring_end) )
					event_names.append("p")
			
			"wait": # Marker Char, Duration, Amount = 1
				var amt : float = 0.1
				if escape_var.size() > 3:
					amt = float(escape_var[3])
				for j in range(amt):
					event_locations.append( _find_position_marker(escape_var[1], substring_end) )
					event_names.append( "wait:" + escape_var[2] )
			
			"font": # Marker Char, Font Name
				var start_index : int = _find_position_marker(escape_var[1], substring_end)
				dialogue.dialogue_tree[dialogue_branch][dialogue_place] = dialogue.dialogue_tree[dialogue_branch][dialogue_place].insert(start_index, "[font="+font_path+escape_var[2]+"]")
			
			"speed": # Marker Char, Speed
				event_locations.append( _find_position_marker(escape_var[1], substring_end) )
				var amt = "default"
				if escape_var.size() > 2:
					amt = int(escape_var[2])
				event_names.append( "speed:" + amt )
			
			"choice": # Option 1, Option 2, etc.
				#await_animation = true
				
				d_choice_cont.visible = true
				var choice_amount = escape_var.size()-1
				d_choice.custom_minimum_size.y = 24 + 28 * choice_amount
				d_choice.size.y = 0
				d_choice.position.y = -(d_choice.custom_minimum_size.y-55)
				_make_choice_options(escape_var)
				
				current_choice = 0
			
			"end": # Marker Char
				event_locations.append( _find_position_marker(escape_var[1], substring_end) )
				event_names.append( "end" )
			
			"sound": # Marker Char, # Sound Path, #Volume Type (SE, ME, AS, AM)
				var volume
				match escape_var[3]:
					"ME":
						volume = Twilight.Settings.Volumes.MusicEffect
					"AS":
						volume = Twilight.Settings.Volumes.AmbientSound
					"AM":
						volume = Twilight.Settings.Volumes.AmbientMusic
					_:
						volume = Twilight.Settings.Volumes.SoundEffect
				
				sounds.append(Twilight.Settings.load_sound(escape_var[2], volume, self)) 
				event_locations.append( _find_position_marker(escape_var[1], substring_end) )
				event_names.append( "sound:%d" % [sounds.size()-1] )
			
			"func": # Marker Char, Dialogue Function Name, ~Int=0
				var myInt : String = "0"
				if escape_var.size() > 3:
					myInt = escape_var[3]
				event_locations.append( _find_position_marker(escape_var[1], substring_end) )
				event_names.append( "func:" + escape_var[2] + ".gd:" + myInt )
			
			"size_gradual": # Marker Char, Start Size, Target Size, Step Size
				var start_index : int = _find_position_marker(escape_var[1], substring_end)
				var start_size : int = 28
				if escape_var[2] != "d" && escape_var[2] != "default":
					start_size = int(escape_var[2])
				var target_size : int = int(escape_var[3])
				var step : int = int(escape_var[4])
				var end : int = ceil(start_index + float(target_size-start_size)/step)
				for j in range(end, start_index, -1):
					if j < dialogue.dialogue_tree[dialogue_branch][dialogue_place].length():
						dialogue.dialogue_tree[dialogue_branch][dialogue_place] = dialogue.dialogue_tree[dialogue_branch][dialogue_place].insert(j, "[font_size=%d]" % [ (j-start_index)*step + start_size ])
			
			"wave": # Marker Char, Amp, Frequency = 5.0
				var freq : float = 5
				if escape_var.size() > 3:
					freq = float(escape_var[3])
				
				if escape_var[2] == "0":
					dialogue.dialogue_tree[dialogue_branch][dialogue_place] = dialogue.dialogue_tree[dialogue_branch][dialogue_place].insert(_find_position_marker(escape_var[1], substring_end), "[/wave]")
				else:
					var _s : String = "[wave amp=%f freq=%f connected=1]" % [float(escape_var[2]), freq]
					dialogue.dialogue_tree[dialogue_branch][dialogue_place] = dialogue.dialogue_tree[dialogue_branch][dialogue_place].insert(_find_position_marker(escape_var[1], substring_end), _s )
		
		# Look for start of next escape sequence
		i = _get_char_next_position(dialogue.dialogue_tree[dialogue_branch][dialogue_place], "|", substring_end)
		# Attempt to end loop if no more
		if i == substring_end:
			break
	
	# Remove escapes from string
	var last_length : int = dialogue.dialogue_tree[dialogue_branch][dialogue_place].length()
	var plain_string = dialogue.dialogue_tree[dialogue_branch][dialogue_place].substr(i+1-float(i == 0), -1)
	
	dialogue.dialogue_tree[dialogue_branch][dialogue_place] = plain_string
	
	# Set richlabel
	text_main.text = dialogue.dialogue_tree[dialogue_branch][dialogue_place]
	
	# Move back events because the string is way shorter now
	var dif = last_length - text_main.get_parsed_text().length()
	for j in range(event_locations.size()):
		event_locations[j] = clamp(event_locations[j] - dif, 1, last_length-1)
	
	# If string is functions only, do funcs and skip to next
	if dialogue.dialogue_tree[dialogue_branch][dialogue_place].length() < 1:
		for j in range(event_names.size()):
			_text_event(event_names[j])
		
		_end_dialogue()

func _text_event(_event) -> void:
	var event_var : Array = _parse_substring(_event)
	
	match event_var[0]:
		"p":
			dialogue_paused = true
		"wait":
			wait_time = float(event_var[1])
		"speed":
			if event_var[1] == "default" || event_var[1] == "d":
				dialogue_speed = Twilight.Settings.text_scroll_speed
			else:
				dialogue_speed = float(event_var[1])
		"end":
			_end_dialogue()
		"sound":
			sounds[ int(event_var[1]) ].play()
		"func":
			var _script = load("res://UI/Dialogue/Dialogue Functions/" + event_var[1])
			if _script != null:
				var _script_inst = _script.new()
				_script_inst.run( int(event_var[2]), player )
				_script_inst.queue_free()
			else:
				print("Not real script: ", event_var)

# ---

func _get_char_next_position(_string : String, _char : String, _start_i : int) -> int:
	var i : int = _start_i + 1
	
	while i < _string.length():
		if _string[i] == _char:
			return i
		i += 1
	
	return _start_i

func _parse_substring(_string : String) -> Array:
	var i : int = -1
	var parsed_array : Array
	
	while true:
		var substring_end = _get_char_next_position(_string, ":", i)
		# Finish
		if (substring_end == 0) || (i == substring_end):
			parsed_array.append(_string.substr(i+1, -1))
			return parsed_array
		
		parsed_array.append(_string.substr(i+1, substring_end-i-1) )
		
		i = substring_end
	
	return []

func _make_choice_options(_array : Array) -> void:
	# Remove old labels
	for i in d_choice.get_children():
		if i.name != "Pointer":
			i.queue_free()
	
	# Add labels
	var longest : float = 0
	
	for i in range(1, _array.size()):
		var _option = option.duplicate()
		_option.position = Vector2(70, -19 + 28 * i)
		_option.get_child(0).text = str( i )
		_option.visible = true
		d_choice.add_child(_option)
		
		longest = 100
	
	# Rescale to longest word
	d_choice.custom_minimum_size.x = max(60 + longest, 117)
	d_choice.position.x = (d_choice.custom_minimum_size.x - 117)/2
	for i in d_choice.get_children():
		if i.name != "Pointer":
			i.position.x += max(longest - 60, 0)
	
	# Position pointer
	p_choice_base_pos = Vector2(394.0, 285.0) + Vector2(-24, 15)

func _find_position_marker(_char : String, _start_index : int) -> int:
	for i in range(_start_index, dialogue.dialogue_tree[dialogue_branch][dialogue_place].length()):
		if dialogue.dialogue_tree[dialogue_branch][dialogue_place][i] == _char:
			dialogue.dialogue_tree[dialogue_branch][dialogue_place] = dialogue.dialogue_tree[dialogue_branch][dialogue_place].substr(0, i) + dialogue.dialogue_tree[dialogue_branch][dialogue_place].substr(i+1, -1)
			return i
	
	return -1

func _child_by_name(parent : Node, child_name : String) -> Node:
	for i in parent.get_children():
		if i.name == child_name:
			return i
	return null

func _end_dialogue() -> void:
	dialogue_stage = 0
	dialogue_place += 1
	
	if dialogue_place >= dialogue.dialogue_tree[dialogue_branch].size():
		queue_free()
		
		if end_cutscene:
			player.in_cutscene = false
		player.dialogue_active = false
		
		if npc != null:
			npc.interacted = false
