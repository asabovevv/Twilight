extends Node2D

@onready var party_cont : HBoxContainer = $Stats/ScrollContainer/PartyMemberContainer
@onready var partymember_cont = load("res://ROOMS/a_Menus/InitRoom/Contents/party_member_stats.tscn")

@onready var master_slider : HSlider = $VolumeControl/VBoxContainer/Master/MasterSlider
@onready var bgm_slider : HSlider = $VolumeControl/VBoxContainer/BGM/BGMSlider
@onready var sfx_slider : HSlider = $VolumeControl/VBoxContainer/SFX/SFXSlider

var inventory_loaded : bool = false

var flag_page : int = 0
var flags_loaded : bool = false

var rooms_loaded : bool = false
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
	Twilight.load_from_slot(-1)
	display_stats()
	
	$Stats.position.x = 0; $Stats.visible = true
	$Inv.position.x = 9999; $Inv.visible = true
	$StoryFlags.position.x = 9999; $StoryFlags.visible = true
	$RoomSelect.position.x = 9999; $RoomSelect.visible = true
	
	#get_tree().change_scene_to_file("res://ROOMS/Twilight/displayroom.tscn")

func _on_save_stats_button_down() -> void:
	Twilight.save_to_slot( int($Stats/SaveStats/SaveStatInt.text) )

func _on_load_stats_button_down() -> void:
	Twilight.load_from_slot( int($Stats/LoadStats/LoadStatInt.text) )
	display_stats()
	_unload_inventory()
	_clear_flags()
	load_flag_page(flag_page)

func _on_default_stats_pressed() -> void:
	Twilight.load_from_slot( -1 )
	display_stats()
	_unload_inventory()
	_clear_flags()
	load_flag_page(flag_page)

func _on_emotion_unlock_pressed() -> void:
	Twilight.Party.fast_emotion = ["neutral", "happy", "angry", "sad"]

func display_stats() -> void:
	for i in party_cont.get_child_count():
		party_cont.get_child(i).queue_free()
	
	for member in Twilight.Party.all_members:
		var pmc = partymember_cont.instantiate()
		var v : Array = pmc.get_children()
		pmc.mychar = member
		pmc.myparent = self
		
		# Name
		v[0].text = Twilight.Party.all_members[member].name
		
		# In party? + Pos
		pmc.modulate.a = 0.7
		if Twilight.Party.current_party.has(Twilight.Party.all_members[member]):
			v[1].text = "In Party (%d)" % [ float(Twilight.Party.all_members[member].round_priority) / 2.0 ]
			pmc.modulate.a = 1
		
		# Leveling
		v[2].get_child(0).text = str( Twilight.Party.all_members[member].level )
		pmc.update_lvstats()
		
		# Weapon
		if Twilight.Party.all_members[member].weapon == Equippable.NONE:
			v[3].get_child(0).text = "None"
		else:
			v[3].get_child(0).text = Registry.get_equipment( Twilight.Party.all_members[member].weapon ).name
			pmc.update_weaponstats( Twilight.Party.all_members[member].weapon )
		
		# Charm
		if Twilight.Party.all_members[member].charm == Equippable.NONE:
			v[4].get_child(0).text = "None"
		else:
			v[4].get_child(0).text = Registry.get_equipment( Twilight.Party.all_members[member].charm ).name
			pmc.update_charmstats( Twilight.Party.all_members[member].charm )
		
		# Skills
		pmc.update_skills()
		
		party_cont.add_child(pmc)

func _on_party_stats_pressed() -> void:
	$Stats.position.x = 0
	$Inv.position.x = 9999
	$StoryFlags.position.x = 9999
	$RoomSelect.position.x = 9999

func _on_inventory_pressed() -> void:
	if !inventory_loaded:
		inventory_loaded=true
		_load_inventory()
	
	$Stats.position.x = 9999
	$Inv.position.x = 0
	$StoryFlags.position.x = 9999
	$RoomSelect.position.x = 9999

func _on_flags_pressed() -> void:
	if !flags_loaded:
		load_flag_page(flag_page)
	$Stats.position.x = 9999
	$Inv.position.x = 9999
	$StoryFlags.position.x = 0
	$RoomSelect.position.x = 9999

func _on_rooms_pressed() -> void:
	if !rooms_loaded:
		rooms_loaded=true
		_load_all_rooms()
	
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

func add_rooms_to_list(array : Array, _vbox_container : VBoxContainer) -> void:
	var hbox_row : int = 0
	var j : int = 0
	_vbox_container.add_child( $RoomSelect/HBoxContainer0.duplicate() )
	
	for i in range(array.size()*0.5):
		var button = $RoomSelect/room0.duplicate()
		button.text = array[i*2]
		button.dir = array[i*2+1]
		
		_vbox_container.get_child(hbox_row).add_child(button)
		
		j+=1
		if j == 5:
			hbox_row+=1
			_vbox_container.add_child($RoomSelect/HBoxContainer0.duplicate())

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

func _unload_inventory() -> void:
	inventory_loaded = false
	
	for i in $Inv/ColorRect/Weapon/VBoxContainer.get_children():
		i.queue_free()
	for i in $Inv/ColorRect/Charm/VBoxContainer.get_children():
		i.queue_free()
	for i in $Inv/ColorRect/Snack/VBoxContainer.get_children():
		i.queue_free()
	for i in $Inv/ColorRect/Toy/VBoxContainer.get_children():
		i.queue_free()
	for i in $Inv/ColorRect/Important/VBoxContainer.get_children():
		i.queue_free()

func _load_inventory() -> void:
	add_equippables_to_browser( Registry.equipment.all_keys() )
	add_items_to_browser( Registry.items.all_keys() )
	
	$Inv/ColorRect/Charm.position.x = 9999
	$Inv/ColorRect/Snack.position.x = 9999
	$Inv/ColorRect/Toy.position.x = 9999
	$Inv/ColorRect/Important.position.x = 9999

func add_equippables_to_browser( array : Array[String] ) -> void:
	
	for i in array:
		var button = $Inv/browser_item0.duplicate()
		button.text = i
		button.pressed.connect( _on_browser_item_0_pressed.bind(i, button) )
		
		button.get_child(0).text_changed.connect( _on_quantity_text_changed.bind( i, button ) )
		if Twilight.Inventory.contents.has(i):
			if Twilight.Inventory.contents[i] < 1:
				button.modulate.a = 0.6
				button.get_child(0).text = "0"
			else:
				button.get_child(0).text = str( Twilight.Inventory.contents[i] )
		else:
			button.modulate.a = 0.6
			button.get_child(0).text = "0"
		
		button.get_child(1).queue_free()
		
		if Registry.equipment.try_get(i).equip_type == Equippable.EquipType.WEAPON:
			$Inv/ColorRect/Weapon/VBoxContainer.add_child(button)
		else:
			$Inv/ColorRect/Charm/VBoxContainer.add_child(button)

func add_items_to_browser( array : Array[String] ) -> void:
	
	for i in array:
		var button = $Inv/browser_item0.duplicate()
		button.text = i
		button.pressed.connect( _on_browser_item_0_pressed.bind(i, button) )
		
		button.get_child(0).text_changed.connect( _on_quantity_text_changed.bind( i, button ) )
		if Twilight.Inventory.contents.has(i):
			if Twilight.Inventory.contents[i] < 1:
				button.modulate.a = 0.6
				button.get_child(0).text = "0"
			else:
				button.get_child(0).text = str( Twilight.Inventory.contents[i] )
		else:
			button.modulate.a = 0.6
			button.get_child(0).text = "0"
		
		button.get_child(1).texture = Registry.items.try_get(i).icon
		
		var _vbox_container
		match Registry.items.try_get(i).item_type:
			Item.ItemType.Snacks:
				_vbox_container = $Inv/ColorRect/Snack/VBoxContainer
			Item.ItemType.Toys:
				_vbox_container = $Inv/ColorRect/Toy/VBoxContainer
			Item.ItemType.Important:
				_vbox_container = $Inv/ColorRect/Important/VBoxContainer
		
		_vbox_container.add_child(button)

func _on_browser_item_0_pressed(key : String, button) -> void:
	
	if Twilight.Inventory.contents.has(key):
		
		if Twilight.Inventory.contents[key] < 1:
			button.modulate.a = 1
			Twilight.Inventory.contents[key] = 1
			
		else:
			button.modulate.a = 0.6
			Twilight.Inventory.contents[key] = 0
		
	else:
		button.modulate.a = 1
		Twilight.Inventory.contents[key] = 1

func _on_browser_button_pressed( node ) -> void:
	$Inv/ColorRect/Weapon.position.x = 9999
	$Inv/ColorRect/Charm.position.x = 9999
	$Inv/ColorRect/Snack.position.x = 9999
	$Inv/ColorRect/Toy.position.x = 9999
	$Inv/ColorRect/Important.position.x = 9999
	
	get_node(node).position.x = 1

func _on_quantity_text_changed(new_text: String, key : String, button) -> void:
	Twilight.Inventory.contents[key] = int(new_text)
	
	if int(new_text) > 0:
		button.modulate.a = 1
	else:
		button.modulate.a = 0.6

func _clear_flags() -> void:
	flags_loaded = false
	for i in $StoryFlags/ColorRect/Flags/VBoxContainer.get_children():
		i.queue_free()

func load_flag_page(page : int) -> void:
	flags_loaded = true
	
	_add_flag_buttons(page*64)

func _add_flag_buttons(start_i : int) -> void:
	var flag_names : Array = Twilight.Flags.Flag_Name.keys()
	var flag_names_size : int = Twilight.Flags.Flag_Name.size()
	
	for i in range(start_i, start_i+64):
		
		if i >= flag_names_size:
			return
		
		var button = $StoryFlags/Flag0.duplicate()
		button.text = str(i) + " - " + flag_names[i]
		button.pressed.connect( _on_flag_0_pressed.bind(i, button) )
		
		if !Twilight.Flags.get_flag(i):
			button.modulate.a = 0.6
		
		$StoryFlags/ColorRect/Flags/VBoxContainer.add_child(button)

func _on_flag_0_pressed(i : int, button) -> void:
	
	if button.modulate.a < 1:
		Twilight.Flags.set_flag(i, 1)
		button.modulate.a = 1
	else:
		Twilight.Flags.set_flag(i, 0)
		button.modulate.a = 0.6

func _on_next_page_pressed() -> void:
	_clear_flags()
	
	flag_page = clamp(flag_page+1, 0, Twilight.Flags.Flag_Name.size()/64)
	load_flag_page(flag_page)
	$StoryFlags/Range.text = str(flag_page*64) + " - " + str(flag_page*64+63)

func _on_last_page_pressed() -> void:
	_clear_flags()
	
	flag_page = clamp(flag_page-1, 0, Twilight.Flags.Flag_Name.size()/64)
	load_flag_page(flag_page)
	$StoryFlags/Range.text = str(flag_page*64) + " - " + str(flag_page*64+63)
