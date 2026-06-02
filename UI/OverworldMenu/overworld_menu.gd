# This is the worst code you will see in this entire game

extends Node2D

var stage : int = 0
var place : Array = [1, 1, 1, 1, 1, 1, 1]
var place_scroll : int = 0
var last_place : int = 1
var category_parent : Node = null
var set_up : bool = false
var await_animation : bool = false

const p_base_off = Vector2(-16, 12)
var p_off : Vector2 = Vector2.ZERO
const who_off = Vector2(-67, -279)
const green = Color(0.487, 0.968, 0.739, 1.0)
const red = Color(1.0, 0.0, 0.297, 1.0)
const grey = Color(1, 1, 1, 0.586)

var anim_t : float = 0
var blur_strength : float = 0

var player : CharacterBody2D
var lists : Array
var sounds_list : Array
enum i_sound { Move1, Select, Selectbad, Cancel, Equip, Tag, Wah }

#region Connections
@onready var animator = $Animator
@onready var blur = $Blur
@onready var ow_status = $OverworldStatus
@onready var menu_main = $MenuMain
@onready var p_main = $MenuMain/Pointer
@onready var clams = $MenuMain/Clams
@onready var tag = $Option1
@onready var menu_equip_wc = $Option2/EquipWeaponCharm
@onready var menu_equip_disp = $Option2/EquipMenuDisplay
@onready var text_equip_disp_name = $Option2/EquipMenuDisplay/ItemName
@onready var text_equip_disp_desc = $Option2/EquipMenuDisplay/ItemDescription
@onready var ico_equip_disp = $Option2/EquipMenuDisplay/Charms
@onready var p_equip_wc = $Option2/EquipWeaponCharm/Pointer
@onready var menu_equip_replace = $Option2/EquipMenuReplace
@onready var p_equip_replace = $Option2/EquipMenuReplace/Pointer
@onready var arrow_equip_replace_d = $Option2/EquipMenuReplace/UiArrow_Down
@onready var arrow_equip_replace_u = $Option2/EquipMenuReplace/UiArrow_Up
@onready var menu_equip_stat = $Option2/EquipMenuStats
@onready var menu_equip_thinkballs = $Option2/Thinkballs
@onready var menu_pocket = $Option3/PocketMenu
@onready var menu_pocket_list = $Option3/PocketMenuList
@onready var p_pocket_list = $Option3/PocketMenuList/Pointer
@onready var arrow_pocket_list_d = $Option3/PocketMenuList/UiArrow_Down
@onready var arrow_pocket_list_u = $Option3/PocketMenuList/UiArrow_Up
@onready var menu_pocket_disp = $Option3/PocketMenuDisplay
@onready var text_pocket_disp_name = $Option3/PocketMenuDisplay/ItemName
@onready var text_pocket_disp_desc = $Option3/PocketMenuDisplay/ItemDescription
@onready var ico_pocket_disp = $Option3/PocketMenuDisplay/Charms
@onready var menu_pocket_confirm = $Option3/PocketConfirm
@onready var p_pocket_confirm = $Option3/PocketConfirm/Pointer
@onready var p_pocket = $Option3/PocketMenu/Pointer
@onready var menu_pocket_yousure = $Option3/PocketYouSure
@onready var p_pocket_yousure = $Option3/PocketYouSure/Pointer
@onready var menu_skill_s = $Option4/SkillsSelect
@onready var p_skill_s = $Option4/SkillsSelect/Pointer
@onready var menu_skill_replace = $Option4/SkillsMenuReplace
@onready var p_skill_replace = $Option4/SkillsMenuReplace/Pointer
@onready var arrow_skill_replace_d = $Option4/SkillsMenuReplace/UiArrow_Down
@onready var arrow_skill_replace_u = $Option4/SkillsMenuReplace/UiArrow_Up
@onready var menu_skill_disp = $Option4/SkillsMenuDisplay
@onready var text_skill_disp_name = $Option4/SkillsMenuDisplay/SkillName
@onready var text_skill_disp_desc = $Option4/SkillsMenuDisplay/SkillDescription
@onready var menu_skill_dowhat = $Option4/DoWhat
@onready var p_skill_dowhat = $Option4/DoWhat/Pointer
@onready var menu_skill_thinkballs = $Option4/Thinkballs
@onready var sounds = $Sounds
#endregion

func _ready() -> void:
	lists = [TWILIGHT.Inventory.Weapons, TWILIGHT.Inventory.Charms, TWILIGHT.Inventory.Snacks,
			TWILIGHT.Inventory.Toys, TWILIGHT.Inventory.Important,
			5, 6, 7, 8, #Skills
			9, 10, 11, #WCA
			12, 13, 14, #WCA
			15, 16, 17, #WCA
			18, 19, 20] #WCA
	var j = 0
	for i in TWILIGHT.Party_Order:
		lists[5+j] = TWILIGHT.Party_Order[j].Skills
		lists[9+j*3] = TWILIGHT.Party_Order[j].Weapon
		lists[10+j*3] = TWILIGHT.Party_Order[j].Charm
		lists[11+j*3] = TWILIGHT.Party_Order[j].Skills_Active
		j+=1
	
	for i in range(4-TWILIGHT.Party_Size):
		ow_status.get_child(3-i).visible = false
	for i in range(TWILIGHT.Party_Size):
		var stat = ow_status.get_child(i)
		stat.get_child(1).text = TWILIGHT.Party_Order[i].Name
		stat.get_child(2).scale.y = (1/ float(TWILIGHT.get_required_exp(TWILIGHT.Party_Order[i].Level))) * TWILIGHT.Party_Order[i].Exp
		stat.get_child(3).text = "LVL. %d" % [TWILIGHT.Party_Order[i].Level]
		stat.get_child(4).region_rect = Rect2(0, 0, (116/ float(TWILIGHT.Party_Order[i].Heart_Max)) * TWILIGHT.Party_Order[i].Heart, 70)
		stat.get_child(5).text = "%d/%d" % [TWILIGHT.Party_Order[i].Heart, TWILIGHT.Party_Order[i].Heart_Max]
		stat.get_child(6).region_rect = Rect2(0, 0, (116/ float(TWILIGHT.Party_Order[i].Juice_Max)) * TWILIGHT.Party_Order[i].Juice, 70)
		stat.get_child(7).text = "%d/%d" % [TWILIGHT.Party_Order[i].Juice, TWILIGHT.Party_Order[i].Juice_Max]
		var portrait = stat.get_child(8)
		portrait.texture = load(TWILIGHT.Party_Order[i].Path + "Portraits/Portrait0.png")
		portrait.position.y = -109 - portrait.texture.get_height()*0.5
	
	if !TWILIGHT.Inventory.has_item(TWILIGHT.Inventory.Key_Items, "TAG"):
		_set_text("???", Color.WHITE, menu_main.get_child(0))
	if (lists[2].size() == 0) && (lists[3].size() == 0) && (lists[4].size() == 0):
		_set_text("POCKET", grey, menu_main.get_child(2))
	if (lists[2].size() == 0):
		_set_text("SNACKS", grey, menu_pocket.get_child(0))
	if (lists[3].size() == 0):
		_set_text("TOYS", grey, menu_pocket.get_child(1))
	if (lists[4].size() == 0):
		_set_text("IMPORTANT", grey, menu_pocket.get_child(2))
	
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_move1.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_select.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_select_bad.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_cancel.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_equip.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_tag.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	sounds_list.append( TWILIGHT.load_sound("res://SOUNDS/SoundEffect/SE_wah.ogg", TWILIGHT.Volumes.SoundEffect, sounds) )
	
	sounds_list[i_sound.Select].play()

func _process(delta: float) -> void:
	if await_animation:
		return
	
	_menu_logic(delta)
	last_place = place[stage]

func _menu_logic(delta: float) -> void:
	var hinput = sign(Input.get_axis("Left", "Right") )
	var vinput = sign(Input.get_axis("Up", "Down") )
	
	anim_t += delta
	p_off = p_base_off + Vector2(sin(anim_t*5)*3, 0)
	
	match stage:
		0:
			# ----- MENU MAIN -----
			if place[0] != -1:
				if !set_up:
					set_up = true
					p_main.frame = 0
					animator.start("Clam", [1])
				
				if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
					place[0] = _wrap(place[0]+hinput, 1, 5)
				p_main.global_position = _child_by_name(menu_main, "Option%d"%[place[0]]).global_position + p_off
				
				if (place[0] != last_place):
					sounds_list[i_sound.Move1].play()
				
				blur_strength = move_toward(blur_strength, 1, delta*8)
				blur.material.set_shader_parameter("fade", blur_strength)
				
				if Input.is_action_just_pressed("Cancel"):
					menu_main.visible = false
					ow_status.visible = false
					sounds_list[i_sound.Cancel].play()
					place[0] = -1
					anim_t = 0
					return
				if Input.is_action_just_pressed("Confirm"):
					if (place[0] == 1) && (!TWILIGHT.Inventory.has_item(TWILIGHT.Inventory.Key_Items, "TAG") ):
						sounds_list[i_sound.Selectbad].play()
						return
					
					category_parent = _child_by_name(self, "Option%d"%[place[0]])
					category_parent.visible = true
					p_main.frame = 1
					p_main.global_position = _child_by_name(menu_main, "Option%d"%[place[0]]).global_position + p_base_off
					_advance()
				
			else: # Exit sequence
				blur_strength = move_toward(blur_strength, 0, delta*8)
				blur.material.set_shader_parameter("fade", blur_strength)
				
				if !sounds_list[i_sound.Cancel].playing:
					player.in_cutscene = false
					queue_free()
		
		1:
			# ----- POCKET MENU -----
			if place[0] == 3:
				if !set_up:
					set_up = true
					p_pocket.frame = 0
					await_animation = true
					animator.start("Pocket", [1])
					return
				
				if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
					place[1] = _wrap(place[1]+hinput, 1, 3)
				p_pocket.global_position = _child_by_name(menu_pocket, "Option%d"%[place[1]]).global_position + p_off
				
				if (place[1] != last_place):
					sounds_list[i_sound.Move1].play()
				
				if Input.is_action_just_pressed("Cancel"):
					_back()
					await_animation = true
					animator.start("Pocket", [0])
					return
				if Input.is_action_just_pressed("Confirm"):
					if lists[ place[1]+1 ].size() != 0:
						_advance()
						p_pocket.frame = 1
						p_pocket.global_position = _child_by_name(menu_pocket, "Option%d"%[place[1]]).global_position + p_base_off
					else:
						sounds_list[i_sound.Selectbad].play()
				return
			
			# ----- SETTINGS MENU -----
			if place[0] == 5:
				
				if Input.is_action_just_pressed("Cancel"):
					_back()
					category_parent.visible = false
					return
				#if Input.is_action_just_pressed("Confirm"):
					#_advance()
				return
			
			# ----- SELECT/TAG WHO? -----
			if !set_up:
				set_up = true
				var who : Node = _child_by_name(category_parent, "SelectWho")
				who.visible = true
				who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[1]]).global_position + who_off
			
			if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
				place[1] = _wrap(place[1]+hinput, 1, TWILIGHT.Party_Size)
				var who : Node = _child_by_name(category_parent, "SelectWho")
				who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[1]]).global_position + who_off
			
			if (place[1] != last_place):
					sounds_list[i_sound.Move1].play()
			
			if Input.is_action_just_pressed("Cancel"):
				_back()
				category_parent.visible = false
				return
			if Input.is_action_just_pressed("Confirm"):
				if !(place[0] == 1 && place[1] == 1): # As long as a party leader isnt tagging themselves
					_advance()
					var who : Node = _child_by_name(category_parent, "SelectWho")
					who.visible = false
				else:
					sounds_list[i_sound.Selectbad].play()
		
		2:
			# ----- TAG ANIMATION -----
			if place[0] == 1:
				animator.start("Tag", [0, 1, 0]) # variants = leader, tagged, background
				sounds_list[i_sound.Tag].play()
				
				var new_order : Array = [ TWILIGHT.Party_Order[place[1]-1] ]
				for i in range(TWILIGHT.Party_Order.size()):
					if TWILIGHT.Party_Order[i] != new_order[0]:
						new_order.append(TWILIGHT.Party_Order[i])
				TWILIGHT.Party_Order = new_order
				
				stage = 3
			
			# ----- EQUIP ANIMATION -----
			if place[0] == 2:
				animator.start("Overworld Status Enter", [0])
				await_animation = true
				place[3] = 1
				stage = 3
			
			# ----- POCKET LIST MENU -----
			if place[0] == 3:
				var list_max = lists[ place[1]+1 ].size()
				
				if !set_up:
					set_up = true
					arrow_pocket_list_u.visible = place[2] != 1
					arrow_pocket_list_d.visible = place[2] != list_max
					if list_max < 5:
						arrow_pocket_list_u.visible = false
						arrow_pocket_list_d.visible = false
					
					if place[2]-place_scroll > 4:
						place_scroll = place[2]-4
					if place[2]-place_scroll < 1:
						place_scroll = place[2]-1
					
					p_pocket_list.frame = 0
					animator.start("Pocket List", [1])
					await_animation = true
					
					if place[1] < 3:
						_update_options(menu_pocket_list, lists[ place[1]+1 ], TWILIGHT.Inventory.Item_Count[place[1]-1])
					if place[1] == 3:
						_update_options(menu_pocket_list, TWILIGHT.Inventory.Important)
					
					var item = TWILIGHT.item( lists[ place[1]+1 ][ place[2]-1 ] )
					if item != null:
						_set_text(item.name, Color.WHITE, text_pocket_disp_name)
						_set_text(item.description, Color.WHITE, text_pocket_disp_desc)
						ico_pocket_disp.texture = item.icon
					return
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
					place[2] = _wrap(place[2]+vinput, 1, list_max)
					
					if place[2]-place_scroll > 4:
						place_scroll = place[2]-4
					if place[2]-place_scroll < 1:
						place_scroll = place[2]-1
					
					arrow_pocket_list_u.visible = place[2] != 1
					arrow_pocket_list_d.visible = place[2] != list_max
					if list_max < 5:
						arrow_pocket_list_u.visible = false
						arrow_pocket_list_d.visible = false
					
					if place[1] < 3:
						_update_options(menu_pocket_list, lists[ place[1]+1 ], TWILIGHT.Inventory.Item_Count[place[1]-1])
					if place[1] == 3:
						_update_options(menu_pocket_list, TWILIGHT.Inventory.Important)
					
					var item = TWILIGHT.item( lists[ place[1]+1 ][ place[2]-1 ] )
					if item != null:
						_set_text(item.name, Color.WHITE, text_pocket_disp_name)
						_set_text(item.description, Color.WHITE, text_pocket_disp_desc)
						ico_pocket_disp.texture = item.icon
				
				if (place[2] != last_place):
					sounds_list[i_sound.Move1].play()
				
				p_pocket_list.global_position = _child_by_name(menu_pocket_list, "Option%d"%[ place[2]-place_scroll ]).global_position + p_off
				
				if Input.is_action_just_pressed("Cancel"):
					_back()
					await_animation = true
					animator.start("Pocket List", [0])
					return
				if Input.is_action_just_pressed("Confirm"):
					p_pocket_list.frame = 1
					p_pocket_list.global_position = _child_by_name(menu_pocket_list, "Option%d"%[ place[2]-place_scroll ]).global_position + p_base_off
					_advance()
			
			# ----- SKILLS ANIMATION -----
			if place[0] == 4:
				animator.start("Overworld Status Enter", [1])
				await_animation = true
				place[3] = 1
				stage = 3
			
			# ----- SETTINGS -----
			#if place[0] == 5:
			#	return
		
		3:
			# ----- EQUIP WEAPON/CHARM MENU -----
			if place[0] == 2:
				var option : Node
				
				if !set_up:
					set_up = true
					p_equip_wc.frame = 0
					option = _child_by_name(menu_equip_wc, "Option%d"%[place[3]])
					animator.start("Equip Menu Display", [int(option.text != "------------")] )
					
					var equip
					if place[3] == 1:
						equip = TWILIGHT.Party_Order[ place[1]-1 ].Weapon
					else:
						equip = TWILIGHT.Party_Order[ place[1]-1 ].Charm
					if equip != null:
						_set_text(equip.name, Color.WHITE, text_equip_disp_name)
						_set_text(equip.description, Color.WHITE, text_equip_disp_desc)
						ico_equip_disp.texture = equip.icon
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
					place[3] = _wrap(place[3]+vinput, 1, 2)
					# control info panel anim
					option = _child_by_name(menu_equip_wc, "Option%d"%[place[3]])
					animator.start("Equip Menu Display", [int(option.text != "------------")] )
					
					if lists[ place[1]*3+5+place[3] ] != null:
						_set_text(lists[ place[1]*3+5+place[3] ].name, Color.WHITE, text_equip_disp_name)
						_set_text(lists[ place[1]*3+5+place[3] ].description, Color.WHITE, text_equip_disp_desc)
						ico_equip_disp.texture = lists[ place[1]*3+5+place[3] ].icon
				
				if (place[3] != last_place):
					sounds_list[i_sound.Move1].play()
				
				option = _child_by_name(menu_equip_wc, "Option%d"%[place[3]])
				p_equip_wc.position = Vector2(-option.size.x*0.5, option.position.y) + p_off
				
				if Input.is_action_just_pressed("Cancel"):
					animator.start("Overworld Status Exit", [0])
					await_animation = true
					stage = 1
					set_up = false
					p_equip_wc.position = Vector2(-option.size.x*0.5, option.position.y) + p_base_off
					sounds_list[i_sound.Cancel].play()
					return
				if Input.is_action_just_pressed("Confirm"):
					var b1 : bool = lists[place[3]-1].size() > 1
					var b2 : bool = (TWILIGHT.Party_Order[place[1]-1].Weapon != null) && (place[3] == 1)
					var b3 : bool = (TWILIGHT.Party_Order[place[1]-1].Charm != null) && (place[3] == 2)
					
					if b1 || b2 || b3:
						_advance()
						p_equip_wc.frame = 1
						p_equip_wc.position = Vector2(-option.size.x*0.5, option.position.y) + p_base_off
					else:
						sounds_list[i_sound.Selectbad].play()
			
			# ----- POCKET CONFIRM -----
			if place[0] == 3:
				var item
				match place[1]:
					1:
						item = TWILIGHT.Inventory.Snacks
					2:
						item = TWILIGHT.Inventory.Toys
					3:
						item = TWILIGHT.Inventory.Important
				
				if !set_up:
					set_up = true
					animator.start("Pocket Confirm", [1])
					p_pocket_confirm.frame = 0
					await_animation = true
					
					if TWILIGHT.item(item[place[2]-1]).can_trash:
						_child_by_name(menu_pocket_confirm, "Option1").self_modulate = Color.WHITE
					else:
						_child_by_name(menu_pocket_confirm, "Option1").self_modulate = grey
					if TWILIGHT.item(item[place[2]-1]).overworld_use:
						_child_by_name(menu_pocket_confirm, "Option2").self_modulate = Color.WHITE
					else:
						_child_by_name(menu_pocket_confirm, "Option2").self_modulate = grey
					return
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
					place[3] = _wrap(place[3]+vinput, 1, 2)
				p_pocket_confirm.global_position = _child_by_name(menu_pocket_confirm, "Option%d"%[place[3]]).global_position + p_off
				
				if (place[3] != last_place):
					sounds_list[i_sound.Move1].play()
				
				if Input.is_action_just_pressed("Cancel"):
					await_animation = true
					animator.start("Pocket Confirm", [0])
					_back()
					return
				if Input.is_action_just_pressed("Confirm"):
					if (place[3] == 1):
						if TWILIGHT.item(item[place[2]-1]).overworld_use:
							_advance()
							animator.start("Pocket Confirm", [0])
							p_pocket_confirm.global_position = _child_by_name(menu_pocket_confirm, "Option%d"%[place[3]]).global_position + p_base_off
							p_pocket_confirm.frame = 1
						else:
							sounds_list[i_sound.Selectbad].play()
					else:
						if TWILIGHT.item(item[place[2]-1]).can_trash:
							sounds_list[i_sound.Select].play()
							set_up = false
							stage += 2
							p_pocket_confirm.global_position = _child_by_name(menu_pocket_confirm, "Option%d"%[place[3]]).global_position + p_base_off
							p_pocket_confirm.frame = 1
							place[5] = 2
						else:
							sounds_list[i_sound.Selectbad].play()
			
			# ----- SKILLS SELECT MENU -----
			if place[0] == 4:
				var option : Node
				
				if !set_up:
					set_up = true
					p_skill_s.frame = 0
					option = _child_by_name(menu_skill_s, "Option%d"%[place[3]])
					animator.start("Skill Menu Display", [int(option.text != "------------")] )
					
					if lists[ place[1]*3+8 ].size() >= place[3]:
						if lists[ place[1]*3+8 ][place[3]-1] != null:
							_set_text(lists[ place[1]*3+8 ][place[3]-1].name, Color.WHITE, text_skill_disp_name)
							_set_text(lists[ place[1]*3+8 ][place[3]-1].description, Color.WHITE, text_skill_disp_desc)
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
					place[3] = _wrap(place[3]+vinput, 1, 4)
					# control info panel anim
					option = _child_by_name(menu_skill_s, "Option%d"%[place[3]])
					animator.start("Skill Menu Display", [int(option.text != "------------")] )
					
					if lists[ place[1]*3+8 ].size() >= place[3]:
						if lists[ place[1]*3+8 ][place[3]-1] != null:
							_set_text(lists[ place[1]*3+8 ][place[3]-1].name, Color.WHITE, text_skill_disp_name)
							_set_text(lists[ place[1]*3+8 ][place[3]-1].description, Color.WHITE, text_skill_disp_desc)
				
				if (place[3] != last_place):
					sounds_list[i_sound.Move1].play()
				
				option = _child_by_name(menu_skill_s, "Option%d"%[place[3]])
				p_skill_s.position = Vector2(-option.size.x*0.5, option.position.y) + p_off
				
				if Input.is_action_just_pressed("Cancel"):
					animator.start("Overworld Status Exit", [1])
					await_animation = true
					stage = 1
					set_up = false
					p_skill_s.position = Vector2(-option.size.x*0.5, option.position.y) + p_base_off
					sounds_list[i_sound.Cancel].play()
					return
				if Input.is_action_just_pressed("Confirm"):
					if (lists[place[1]+4].size() > 1) || (TWILIGHT.Party_Order[place[1]-1].Skills_Active.size() > 0):
						_advance()
						p_skill_s.frame = 1
						p_skill_s.position = Vector2(-option.size.x*0.5, option.position.y) + p_base_off
						
						if option.text != "------------":
							var skill = lists[ 8+place[1]*3 ][place[3]-1]
							if skill != null:
								if skill.overworld_use:
									stage = 5
					else:
						sounds_list[i_sound.Selectbad].play()
			
			# ----- OPTIONS MENU -----
			#if place[0] == 5:
		
		4:
			# ----- EQUIP REPLACE MENU -----
			if place[0] == 2:
				var list_max = lists[ place[3]-1 ].size()
				
				if !set_up:
					set_up = true
					place_scroll = 0
					
					p_equip_replace.frame = 0
					p_equip_replace.global_position = _child_by_name(menu_equip_replace, "Option1").global_position + p_off
					arrow_equip_replace_u.visible = place_scroll > 0
					arrow_equip_replace_d.visible = place_scroll + 6 <= list_max
					if list_max < 7:
						arrow_equip_replace_u.visible = false
						arrow_equip_replace_d.visible = false
					
					animator.start("Equip Menu Replace", [1, 3, -1])
					await_animation = true
					menu_equip_thinkballs.get_child(0).position.y = 161
					menu_equip_thinkballs.get_child(1).position.y = 189
					
					_update_options(menu_equip_replace, lists[ place[3]-1 ])
					
					if lists[ place[3]-1 ] != null:
						var item = TWILIGHT.equippable( lists[ place[3]-1 ][ place[4]-1 ] )
						if item != null:
							_set_text(item.name, Color.WHITE, text_equip_disp_name)
							_set_text(item.description, Color.WHITE, text_equip_disp_desc)
							ico_equip_disp.texture = item.icon
							
							_update_stat_menu(item)
					return
				
				if Input.is_action_just_pressed("Left") && (int(place[4]) % 2 == 0):
						place[4] = clamp(place[4]-1, 1, list_max)
				if Input.is_action_just_pressed("Right") && (int(place[4]) % 2 == 1):
						place[4] = clamp(place[4]+1, 1, list_max)
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
						if !(place[4]+vinput*2 < 1 || place[4]+vinput*2 > list_max):
							place[4] = place[4]+vinput*2
						
						if place[4]-place_scroll > 6:
							place_scroll = (place[4]-6) * 2
						if place[4]-place_scroll < 1:
							place_scroll = (place[4]-1) * 2
						
						arrow_equip_replace_u.visible = place_scroll > 0
						arrow_equip_replace_d.visible = place_scroll + 6 <= list_max
						if list_max < 7:
							arrow_equip_replace_u.visible = false
							arrow_equip_replace_d.visible = false
				
				p_equip_replace.global_position = _child_by_name(menu_equip_replace, "Option%d"%[ place[4]-place_scroll ]).global_position + p_off
				menu_equip_thinkballs.get_child(0).position.y = 161 + sin(anim_t*5)*7
				menu_equip_thinkballs.get_child(1).position.y = 189 + sin(anim_t*5)*-7
				
				if place[4] != last_place:
					if lists[ place[3]-1 ] != null:
						var item = TWILIGHT.equippable( lists[ place[3]-1 ][ place[4]-1 ] )
						if item != null:
							_set_text(item.name, Color.WHITE, text_equip_disp_name)
							_set_text(item.description, Color.WHITE, text_equip_disp_desc)
							ico_equip_disp.texture = item.icon
							
							_update_stat_menu(item)
					sounds_list[i_sound.Move1].play()
					_update_options(menu_equip_replace, lists[ place[3]-1 ])
				
				if Input.is_action_just_pressed("Cancel"):
					animator.start("Equip Menu Replace", [0, 3, -1])
					await_animation = true
					_back()
					return
				if Input.is_action_just_pressed("Confirm"):
					if place[3] == 1:
						TWILIGHT.Party_Order[ place[1]-1 ].swap_weapon(place[4]-1, TWILIGHT.Inventory)
						var weapon = TWILIGHT.Party_Order[ place[1]-1 ].Weapon
						if weapon != null:
							_set_text(weapon.name, Color.WHITE, _child_by_name(menu_equip_wc, "Option1"))
						else:
							_set_text("------------", Color.WHITE, _child_by_name(menu_equip_wc, "Option1"))
					else:
						TWILIGHT.Party_Order[ place[1]-1 ].swap_charm(place[4]-1, TWILIGHT.Inventory)
						var charm = TWILIGHT.Party_Order[ place[1]-1 ].Charm
						if charm != null:
							_set_text(charm.name, Color.WHITE, _child_by_name(menu_equip_wc, "Option2"))
						else:
							_set_text("------------", Color.WHITE, _child_by_name(menu_equip_wc, "Option2"))
					
					place[stage] = 1
					stage -= 1
					set_up = false
					sounds_list[i_sound.Equip].play()
					
					animator.start("Equip Menu Replace", [0, 3, -1])
					await_animation = true
					p_equip_replace.frame = 1
					p_equip_replace.global_position = _child_by_name(menu_equip_replace, "Option%d"%[ place[4]-place_scroll ]).global_position + p_base_off
			
			# ----- POCKET USE ON WHO -----
			if place[0] == 3:
				var who : Node = _child_by_name(category_parent, "SelectWho")
				
				if !set_up:
					set_up = true
					who.visible = true
					who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[4]]).global_position + who_off
				
				if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
					place[4] = _wrap(place[4]+hinput, 1, TWILIGHT.Party_Size)
					who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[4]]).global_position + who_off
				
				if (place[4] != last_place):
						sounds_list[i_sound.Move1].play()
				
				if Input.is_action_just_pressed("Cancel"):
					_back()
					who.visible = false
					return
				if Input.is_action_just_pressed("Confirm"):
					pass
					#DO WHAT THE ITEM SAYS TO DO!!!
					
					#sounds_list[i_sound.Select].play()
					#place[stage] = 1
					#stage -= 1
					#set_up = false
					#who.visible = false
			
			# ----- SKILL REPLACE MENU -----
			if place[0] == 4:
				var list_max = lists[ place[1]+4 ].size()
				
				if !set_up:
					set_up = true
					place_scroll = 0
					
					p_skill_replace.frame = 0
					p_skill_replace.global_position = _child_by_name(menu_skill_replace, "Option1").global_position + p_off
					arrow_skill_replace_u.visible = place_scroll > 0
					arrow_skill_replace_d.visible = place_scroll + 6 <= list_max
					if list_max < 7:
						arrow_skill_replace_u.visible = false
						arrow_skill_replace_d.visible = false
					
					animator.start("Skill Menu Replace", [1, 3, -1])
					await_animation = true
					
					var skill = TWILIGHT.skill( lists[ place[1]+4 ][ place[4]-1 ] )
					if skill != null:
						_set_text(skill.name, Color.WHITE, text_skill_disp_name)
						_set_text(skill.description, Color.WHITE, text_skill_disp_desc)
					return
				
				if Input.is_action_just_pressed("Left") && (int(place[4]) % 2 == 0):
						place[4] = clamp(place[4]-1, 1, list_max)
				if Input.is_action_just_pressed("Right") && (int(place[4]) % 2 == 1):
						place[4] = clamp(place[4]+1, 1, list_max)
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
						if !(place[4]+vinput*2 < 1 || place[4]+vinput*2 > list_max):
							place[4] = place[4]+vinput*2
						
						if place[4]-place_scroll > 6:
							place_scroll = (place[4]-6) * 2
						if place[4]-place_scroll < 1:
							place_scroll = (place[4]-1) * 2
						
						arrow_skill_replace_u.visible = place_scroll > 0
						arrow_skill_replace_d.visible = place_scroll + 6 <= list_max
						if list_max < 7:
							arrow_skill_replace_u.visible = false
							arrow_skill_replace_d.visible = false
				
				p_skill_replace.global_position = _child_by_name(menu_skill_replace, "Option%d"%[ place[4]-place_scroll ]).global_position + p_off
				
				if place[4] != last_place:
					var skill = TWILIGHT.skill( lists[ place[1]+4 ][ place[4]-1 ] )
					if skill != null:
						_set_text(skill.name, Color.WHITE, text_skill_disp_name)
						_set_text(skill.description, Color.WHITE, text_skill_disp_desc)
					sounds_list[i_sound.Move1].play()
					_update_options(menu_skill_replace, lists[ place[1]+4 ])
				
				if Input.is_action_just_pressed("Cancel"):
					animator.start("Skill Menu Replace", [0, 3, -1])
					await_animation = true
					_back()
					return
				if Input.is_action_just_pressed("Confirm"):
					TWILIGHT.Party_Order[ place[1]-1 ].swap_skill(place[3]-1, place[4]-1)
					_update_options_res(menu_skill_s, TWILIGHT.Party_Order[place[1]-1].Skills_Active)
					
					animator.start("Skill Menu Replace", [0, 3, -1])
					await_animation = true
					
					place[stage] = 1
					stage -= 1
					set_up = false
					sounds_list[i_sound.Equip].play()
					
					p_skill_replace.frame = 1
					p_skill_replace.global_position = _child_by_name(menu_skill_replace, "Option%d"%[ place[4]-place_scroll ]).global_position + p_base_off
		
		5:
			# ----- POCKET YOU SURE? -----
			if place[0] == 3:
				if !set_up:
					set_up = true
					animator.start("Pocket You Sure", [1])
				
				if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
					place[5] = _wrap(place[5]+hinput, 1, 2)
				p_pocket_yousure.global_position = _child_by_name(menu_pocket_yousure, "Option%d"%[place[5]]).global_position + p_off
				
				if (place[5] != last_place):
					sounds_list[i_sound.Move1].play()
				
				if Input.is_action_just_pressed("Cancel") || (Input.is_action_just_pressed("Confirm") && place[5] == 2):
					sounds_list[i_sound.Cancel].play()
					place[stage] = 1
					stage -= 2
					set_up = false
					animator.start("Pocket You Sure", [0])
					await_animation = true
					return
				if Input.is_action_just_pressed("Confirm"):
					sounds_list[i_sound.Wah].play()
					place[stage] = 1
					stage -= 2
					set_up = false
					animator.start("Pocket You Sure", [0])
					await_animation = true
					
					if place[1] < 3:
						var ic = TWILIGHT.Inventory.Item_Count[ place[1]-1 ]
						var item
						if place[1] == 1:
							item = TWILIGHT.Inventory.Snacks
						else:
							item = TWILIGHT.Inventory.Toys
						ic[place[2]-1] -= 1
						
						if ic[place[2]-1] <= 0:
							ic.remove_at( place[2]-1 )
							item.remove_at( place[2]-1 )
						_update_options(menu_pocket_list, lists[ place[1]+1 ], TWILIGHT.Inventory.Item_Count[place[1]-1])
					return
			
			# ----- SKILL DO WHAT -----
			if place[0] == 4:
				if !set_up:
					set_up = true
					animator.start("Skill Do What", [1])
					await_animation = true
					menu_skill_thinkballs.get_child(0).position.y = 161
					menu_skill_thinkballs.get_child(1).position.y = 189
					p_skill_dowhat.global_position = _child_by_name(menu_skill_dowhat, "Option%d"%[place[5]]).global_position + p_off
					return
				
				if Input.is_action_just_pressed("Up") || Input.is_action_just_pressed("Down"):
					place[5] = _wrap(place[5]+vinput, 1, 2)
				
				if (place[5] != last_place):
					sounds_list[i_sound.Move1].play()
				
				p_skill_dowhat.global_position = _child_by_name(menu_skill_dowhat, "Option%d"%[place[5]]).global_position + p_off
				menu_skill_thinkballs.get_child(0).position.y = 161 + sin(anim_t*5)*7
				menu_skill_thinkballs.get_child(1).position.y = 189 + sin(anim_t*5)*-7
				
				if Input.is_action_just_pressed("Cancel"):
					animator.start("Skill Do What", [0])
					await_animation = true
					place[stage] = 1
					stage -= 2
					set_up = false
					sounds_list[i_sound.Cancel].play()
					return
				if Input.is_action_just_pressed("Confirm"):
					if place[5] == 1:
						_advance()
						animator.start("Skill Do What", [0])
						await_animation = true
					else:
						_back()
						animator.start("Skill Do What", [0])
						await_animation = true
		
		6: 
			# SKILL USE ON WHO?
			if place[0] == 4:
				if !set_up:
					set_up = true
					place[6] = 1
					var who : Node = _child_by_name(category_parent, "SelectWho")
					who.visible = true
					who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[1]]).global_position + who_off
					animator.start("Skill Use On Who", [1])
					await_animation = true
					return
				
				if Input.is_action_just_pressed("Right") || Input.is_action_just_pressed("Left"):
					place[6] = _wrap(place[6]+hinput, 1, TWILIGHT.Party_Size)
					var who : Node = _child_by_name(category_parent, "SelectWho")
					who.global_position = _child_by_name(ow_status, "OverworldStatus%d"%[place[6]]).global_position + who_off
				
				if (place[5] != last_place):
					sounds_list[i_sound.Move1].play()
				
				if Input.is_action_just_pressed("Cancel"):
					_back()
					_child_by_name(category_parent, "SelectWho").visible = false
					animator.start("Skill Use On Who", [0])
					await_animation = true
					return
				if Input.is_action_just_pressed("Confirm"):
					pass

func _child_by_name(parent : Node, child_name : String) -> Node:
	for i in parent.get_children():
		if i.name == child_name:
			return i
	return null

func _wrap(value : int, _min : int, _max : int) -> int:
	if value > _max:
		return _min
	if value < _min:
		return _max
	return value

func _back() -> void:
	sounds_list[i_sound.Cancel].play()
	place[stage] = 1
	stage -= 1
	set_up = false

func _advance() -> void:
	sounds_list[i_sound.Select].play()
	set_up = false
	stage += 1

func _set_text(_text : String, _color : Color, _node : Node):
	_node.text = _text
	_node.self_modulate = _color
	if _node.text == "------------" || _node.text == "???":
		_node.self_modulate = grey

func _update_options(parent : Node, name_array : Array, quantity_array : Array = []):
	for i in parent.get_children():
		if i.name.substr(0, 6) == "Option":
			var new_index = int(i.name.substr(6, 1))-1+place_scroll
			
			if new_index < name_array.size():
				i.visible = true
				_set_text(name_array[new_index], Color.WHITE, i)
			else:
				i.visible = false
			
		elif i.name.substr(0, 8) == "Quantity":
			if quantity_array == []:
				i.visible = false
			else:
				var new_index = int(i.name.substr(8, 1))-1+place_scroll
				
				if new_index < quantity_array.size():
					i.visible = true
					_set_text("x%d" % [quantity_array[new_index] ], Color.WHITE, i)
				else:
					i.visible = false

func _update_options_res(parent : Node, res_array : Array):	
	for i in parent.get_children():
		if i.name.substr(0, 6) == "Option":
			var new_index = int(i.name.substr(6, 1))-1+place_scroll
			
			i.visible = true
			if new_index < res_array.size():
				_set_text(res_array[new_index].name, Color.WHITE, i)
			else:
				_set_text("------------", Color.WHITE, i)

func _color_compare(item_stat : int, now_item_stat : int) -> Color:
	if item_stat > now_item_stat:
		return green
	elif item_stat < now_item_stat:
		return red
	return Color.WHITE

func _update_stat_menu(item) -> void:
	var now_item
	if place[3] == 1:
		now_item = TWILIGHT.Party_Order[ place[1]-1 ].Weapon
	else:
		now_item = TWILIGHT.Party_Order[ place[1]-1 ].Charm
	if now_item == null:
		now_item = load("res://RESOURCES/Equippable/ZERO.tres")
	
	_set_text(str(now_item.heart), Color.WHITE, _child_by_name(menu_equip_stat, "HeartOld"))
	_set_text(str(item.heart), _color_compare(item.heart, now_item.heart), _child_by_name(menu_equip_stat, "HeartNew"))
	_set_text(str(now_item.juice), Color.WHITE, _child_by_name(menu_equip_stat, "JuiceOld"))
	_set_text(str(item.juice), _color_compare(item.juice, now_item.juice), _child_by_name(menu_equip_stat, "JuiceNew"))
	_set_text(str(now_item.attack), Color.WHITE, _child_by_name(menu_equip_stat, "AttackOld"))
	_set_text(str(item.attack), _color_compare(item.attack, now_item.attack), _child_by_name(menu_equip_stat, "AttackNew"))
	_set_text(str(now_item.defense), Color.WHITE, _child_by_name(menu_equip_stat, "DefenseOld"))
	_set_text(str(item.defense), _color_compare(item.defense, now_item.defense), _child_by_name(menu_equip_stat, "DefenseNew"))
	_set_text(str(now_item.speed), Color.WHITE, _child_by_name(menu_equip_stat, "SpeedOld"))
	_set_text(str(item.speed), _color_compare(item.speed, now_item.speed), _child_by_name(menu_equip_stat, "SpeedNew"))
	_set_text(str(now_item.luck), Color.WHITE, _child_by_name(menu_equip_stat, "LuckOld"))
	_set_text(str(item.luck), _color_compare(item.luck, now_item.luck), _child_by_name(menu_equip_stat, "LuckNew"))
	_set_text(str(now_item.hit), Color.WHITE, _child_by_name(menu_equip_stat, "HitOld"))
	_set_text(str(item.hit), _color_compare(item.hit, now_item.hit), _child_by_name(menu_equip_stat, "HitNew"))
