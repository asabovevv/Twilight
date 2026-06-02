extends Node2D

@onready var party_cont : HBoxContainer = $Stats/ScrollContainer/PartyMemberContainer
@onready var partymember_cont = load("res://ROOMS/a_Menus/InitRoom/Contents/party_member_stats.tscn")

@onready var master_slider : HSlider = $VolumeControl/VBoxContainer/Master/MasterSlider
@onready var bgm_slider : HSlider = $VolumeControl/VBoxContainer/BGM/BGMSlider
@onready var sfx_slider : HSlider = $VolumeControl/VBoxContainer/SFX/SFXSlider

var rooms_misc : Array
var rooms_twilight : Array

func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(640*2, 480*2))
	DisplayServer.window_set_position(Vector2i(320, 60))
	
	master_slider.value = get_bus_volume("Master")
	bgm_slider.value = get_bus_volume("BGM")
	sfx_slider.value = get_bus_volume("SFX")
	
	_debug_start()

func _debug_start() -> void:
	# Debug
	TWILIGHT.load_from_slot(-1)
	display_stats()
	_load_all_rooms()
	
	$Stats.position.x = 9999; $Stats.visible = true
	$Inv.position.x = 9999; $Inv.visible = true
	$StoryFlags.position.x = 9999; $StoryFlags.visible = true
	$RoomSelect.position.x = 9999; $RoomSelect.visible = true
	
	#get_tree().change_scene_to_file("res://ROOMS/Twilight/displayroom.tscn")

func _on_save_stats_button_down() -> void:
	TWILIGHT.save_to_slot( int($Stats/SaveStats/SaveStatInt.text) )

func _on_load_stats_button_down() -> void:
	TWILIGHT.load_from_slot( int($Stats/LoadStats/LoadStatInt.text) )
	display_stats()

func _on_default_stats_pressed() -> void:
	TWILIGHT.load_from_slot( -1 )
	display_stats()

func _on_emotion_unlock_pressed() -> void:
	TWILIGHT.Party_Fast_Emotion = ["Neutral", "Happy", "Angry", "Sad"]

func display_stats() -> void:
	for i in party_cont.get_child_count():
		party_cont.get_child(i).queue_free()
	
	for i in range(TWILIGHT.All_Characters.size()):
		var pmc = partymember_cont.instantiate()
		var v : Array = pmc.get_children()
		pmc.mychar = TWILIGHT.All_Characters[i]
		pmc.myparent = self
		
		# Name
		v[0].text = TWILIGHT.All_Characters[i].Name
		
		# In party? + Pos
		pmc.modulate.a = 0.7
		for j in (TWILIGHT.Party_Order.size()):
			if TWILIGHT.Party_Order[j] == TWILIGHT.All_Characters[i]:
				v[1].text = "In Party (%d)" % [ float(TWILIGHT.All_Characters[i].TurnPriority) / 2.0 ]
				pmc.modulate.a = 1
		
		# Leveling
		v[2].get_child(0).text = str( TWILIGHT.All_Characters[i].Level )
		pmc.update_lvstats()
		
		# Weapon
		if TWILIGHT.All_Characters[i].Weapon == null:
			v[3].get_child(0).text = "None"
		else:
			v[3].get_child(0).text =  TWILIGHT.All_Characters[i].Weapon.name
			pmc.update_weaponstats(TWILIGHT.All_Characters[i].Weapon)
		
		# Charm
		if TWILIGHT.All_Characters[i].Charm == null:
			v[4].get_child(0).text = "None"
		else:
			v[4].get_child(0).text =  TWILIGHT.All_Characters[i].Charm.name
			pmc.update_charmstats(TWILIGHT.All_Characters[i].Charm)
		
		# Skills
		pmc.update_skills()
		
		party_cont.add_child(pmc)

func _on_party_stats_pressed() -> void:
	$Stats.position.x = 0
	$Inv.position.x = 9999
	$StoryFlags.position.x = 9999
	$RoomSelect.position.x = 9999

func _on_inventory_pressed() -> void:
	$Stats.position.x = 9999
	$Inv.position.x = 0
	$StoryFlags.position.x = 9999
	$RoomSelect.position.x = 9999

func _on_flags_pressed() -> void:
	$Stats.position.x = 9999
	$Inv.position.x = 9999
	$StoryFlags.position.x = 0
	$RoomSelect.position.x = 9999

func _on_rooms_pressed() -> void:
	$Stats.position.x = 9999
	$Inv.position.x = 9999
	$StoryFlags.position.x = 9999
	$RoomSelect.position.x = 0

func _on_encounters_pressed() -> void:
	pass # Replace with function body.

func _on_encounter_mockup_pressed() -> void:
	get_tree().change_scene_to_file("res://ENCOUNTER/encounter.tscn")

func _load_all_rooms() -> void:
	get_groups_rooms("res://ROOMS/a_Menus/", rooms_misc)
	get_groups_rooms("res://ROOMS/c_Interludes/", rooms_misc)
	get_groups_rooms("res://ROOMS/Twilight/", rooms_twilight)
	
	add_rooms_to_list(rooms_misc, $RoomSelect/MISC/VBoxContainer)
	add_rooms_to_list(rooms_twilight, $RoomSelect/TWILIGHT/VBoxContainer)
	
	$RoomSelect/HBoxContainer0.queue_free()
	$RoomSelect/room0.queue_free()
	
	$RoomSelect/TWILIGHT.position.x = 9999

func get_groups_rooms(group_path : String, array : Array) -> void:
	# MISC
	for i in DirAccess.get_directories_at(group_path):
		for j in DirAccess.get_files_at(group_path+i):
			if j.get_extension() == "tscn":
				array.append(j)
				array.append(group_path+i+"/"+j)

func add_rooms_to_list(array : Array, vbox_container : VBoxContainer) -> void:
	var hbox_row : int = 0
	var j : int = 0
	vbox_container.add_child($RoomSelect/HBoxContainer0.duplicate())
	
	for i in range(array.size()*0.5):
		var button = $RoomSelect/room0.duplicate()
		button.text = array[i*2]
		button.dir = array[i*2+1]
		
		vbox_container.get_child(hbox_row).add_child(button)
		
		j+=1
		if j == 5:
			hbox_row+=1
			vbox_container.add_child($RoomSelect/HBoxContainer0.duplicate())

func _on_g_misc_pressed() -> void:
	$RoomSelect/MISC.position.x = 0
	$RoomSelect/TWILIGHT.position.x = 9999

func _on_g_twilight_pressed() -> void:
	$RoomSelect/MISC.position.x = 9999
	$RoomSelect/TWILIGHT.position.x = 0

func set_bus_volume(bus: String, volume: float) -> void:
	var index = AudioServer.get_bus_index(bus)
	if index == -1:
		printerr("Unknown bus: %s" % bus)
		return
	AudioServer.set_bus_volume_linear(index, volume)

func get_bus_volume(bus: String) -> float:
	var index = AudioServer.get_bus_index(bus)
	if index == -1:
		printerr("Unknown bus: %s" % bus)
		return 0
	return AudioServer.get_bus_volume_linear(index)

func _on_master_value_changed(value: float) -> void:
	set_bus_volume("Master", value)

func _on_bgm_value_changed(value: float) -> void:
	set_bus_volume("BGM", value)

func _on_sfx_value_changed(value: float) -> void:
	set_bus_volume("SFX", value)
