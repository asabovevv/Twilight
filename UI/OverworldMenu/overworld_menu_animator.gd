extends Node2D

@export var ow : Node
var t_anim : float
var set_up : bool = false
var animation : String = ""
var variants : Array
var stage : int

func start(_animation : String, _variants : Array = [0]) -> void:
	animation = _animation
	variants = _variants
	stage = 1
	set_up = false

func _physics_process(delta: float) -> void:
	if (ow.place[0] < 3) || (ow.place[0] == 4):
		var j : int = 1
		for i in ow.ow_status.get_children():
			var portrait = i.get_child(8)
			
			portrait.frame = 0
			if (ow.stage > 0 && j == ow.place[1]) || (ow.stage == 6 && j == ow.place[6]): # if character was not selected in previous stage fade
				portrait.frame = int(ow.anim_t*3) % 3
			
			j += 1
	
	match animation:
		"Overworld Status Enter":
			if stage == 1:
				if !set_up:
					set_up = true
					t_anim = 0.8
					
				t_anim += delta*t_anim*8
				var j : int = 1
				for i in ow.ow_status.get_children():
					if j != ow.place[1]: # if character was not selected in previous stage fade
						i.position.y = move_toward(i.position.y, 750, t_anim)
						i.modulate.a = move_toward(i.modulate.a, 0, t_anim/8)
					j += 1
				
				ow.clams.scale.y = move_toward(ow.clams.scale.y, 0, delta*6)
				ow.clams.get_child(0).visible = false
				
				if t_anim > 4.1:
					stage = 2
					set_up = false
			
			if stage == 2:
				if !set_up:
					set_up = true
					t_anim = 0.8
					
				t_anim += delta*t_anim*10
				var ow_stat = ow._child_by_name(ow.ow_status, "OverworldStatus%d"%[ow.place[1]])
				ow_stat.position.x = move_toward(ow_stat.position.x, 87, t_anim)
					
				if ow_stat.position.x == 87:
					stage = 3
					set_up = false
			
			if stage == 3:
				if !set_up:
					set_up = true
					t_anim = 0.8
					
					if variants[0] == 0:
						ow.menu_equip_wc.visible = true
						for i in ow.menu_equip_wc.get_children():
							if i.name == "Option1":
								var weapon = Twilight.Party.current_party[ow.place[1]-1].Weapon
								if weapon != null:
									ow._set_text(weapon.name, Color.WHITE, i)
								else:
									ow._set_text("------------", Color.WHITE, i)
							if i.name == "Option2":
								var charm = Twilight.Party.current_party[ow.place[1]-1].Charm
								if charm != null:
									ow._set_text(charm.name, Color.WHITE, i)
								else:
									ow._set_text("------------", Color.WHITE, i)
					else:
						ow.menu_skill_s.visible = true
						ow._update_options_res(ow.menu_skill_s, ow.lists[ ow.place[1]*3+8 ])
				
				var option = ow._child_by_name(ow.menu_equip_wc, "Option1")
				ow.p_equip_wc.position = Vector2(-option.size.x*0.5, option.position.y) + ow.p_off
				option = ow._child_by_name(ow.menu_skill_s, "Option1")
				ow.p_skill_s.position = Vector2(-option.size.x*0.5, option.position.y) + ow.p_off
				
				t_anim += delta*t_anim*6
				var ow_stat = ow._child_by_name(ow.ow_status, "OverworldStatus%d"%[ow.place[1]])
				ow_stat.position.y = move_toward(ow_stat.position.y, 345, t_anim)
				
				if variants[0] == 0:
					ow.menu_equip_wc.position.y = ow_stat.position.y + 67
				else:
					ow.menu_skill_s.position.y = ow_stat.position.y + 67
					
				if ow_stat.position.y == 345:
					stage = 4
					set_up = false
			
			if stage == 4:
				ow.await_animation = false
				animation = ""
		
		"Overworld Status Exit":
			if stage == 1:
				if !set_up:
					set_up = true
					t_anim = 3
				
				t_anim += delta*t_anim*14
				ow.menu_equip_disp.size.x = move_toward(ow.menu_equip_disp.size.x, 0, t_anim)
				ow.menu_equip_disp.position.x = move_toward(ow.menu_equip_disp.position.x, 20, t_anim/3)
				ow.menu_skill_disp.size.x = move_toward(ow.menu_skill_disp.size.x, 0, t_anim)
				ow.menu_skill_disp.position.x = move_toward(ow.menu_skill_disp.position.x, 20, t_anim/3)
				
				var charm = ow._child_by_name(ow.menu_equip_disp, "Charms")
				charm.position.x = move_toward(charm.position.x, 300, t_anim/1.4)
				charm.visible = ow.menu_equip_disp.size.x > 400
				
				if ow.menu_equip_disp.size.x < 100 && ow.menu_skill_disp.size.x < 100:
					ow.menu_equip_disp.visible = false
					ow.menu_skill_disp.visible = false
					stage = 2
					set_up = false
			
			if stage == 2:
				if !set_up:
					set_up = true
					t_anim = 0.8
					
				t_anim += delta*t_anim*6
				var ow_stat = ow._child_by_name(ow.ow_status, "OverworldStatus%d"%[ow.place[1]])
				ow_stat.position.y = move_toward(ow_stat.position.y, 480, t_anim)
				
				if variants[0] == 0:
					ow.menu_equip_wc.position.y = ow_stat.position.y + 67
				else:
					ow.menu_skill_s.position.y = ow_stat.position.y + 67
					
				if ow_stat.position.y == 480:
					stage = 3
					ow.menu_equip_wc.visible = false
					ow.menu_skill_s.visible = false
					set_up = false
			
			if stage == 3:
				if !set_up:
					set_up = true
					t_anim = 0.8
					
				t_anim += delta*t_anim*10
				var ow_stat = ow._child_by_name(ow.ow_status, "OverworldStatus%d"%[ow.place[1]])
				ow_stat.position.x = move_toward(ow_stat.position.x, 87 + (ow.place[1]-1)*155, t_anim)
					
				if ow_stat.position.x == (87 + (ow.place[1]-1)*155):
					stage = 4
					set_up = false
			
			if stage == 4:
				if !set_up:
					set_up = true
					t_anim = 2
					
				t_anim += delta*t_anim*8
				var j : int = 1
				var y = 0
				for i in ow.ow_status.get_children():
					if j != ow.place[1]: # if character was not selected in previous stage fade
						i.position.y = move_toward(i.position.y, 480, t_anim)
						i.modulate.a = move_toward(i.modulate.a, 1, t_anim/20)
						y = i.position.y
					j += 1
					
				if y == 480:
					animation = ""
					ow.await_animation = false
		
		"Tag":
			if stage == 1:
				for i in ow.get_children():
					if (i.name == "MenuMain") || (i.name == "OverworldStatus"):
						i.visible = false
				
				var image = ow._child_by_name(ow.tag, "TagImage")
				image.visible = true
				image.position.y = -240
				
				stage = 2
				t_anim = 0
				# update using variants here
			
			if stage == 2:
				t_anim += delta
				var image = ow._child_by_name(ow.tag, "TagImage")
				image.position.y = clamp(lerpf(-240, 240, t_anim * 3), -240, 240)
				
				if t_anim >= 1.1:
					stage = 3
					t_anim = 0
					
					# update character order here
					ow.player.new_sprites()
					ow.player.set_emotion_string(Twilight.Party.current_party[0].Emotion.name)
			
			if stage == 3:
				t_anim += delta
				var image = ow._child_by_name(ow.tag, "TagImage")
				image.position.y = lerpf(240, 700, t_anim * 3)
				ow.blur.material.set_shader_parameter("fade", (1-t_anim) *3 )
				
				if image.position.y == 700:
					ow.player.cutscene = false
					ow.queue_free()
		
		"Equip Menu Display":
			if !set_up:
				set_up = true
				t_anim = 3
			
			t_anim += delta*t_anim*14
			ow.menu_equip_disp.size.x = move_toward(ow.menu_equip_disp.size.x, variants[0]*465, t_anim)
			ow.menu_equip_disp.position.x = move_toward(ow.menu_equip_disp.position.x, 20 + variants[0]*145, t_anim/3)
			
			var charm = ow._child_by_name(ow.menu_equip_disp, "Charms")
			charm.position.x = move_toward(charm.position.x, 300 + variants[0]*105, t_anim/1.4)
			charm.visible = ow.menu_equip_disp.size.x > 400
			
			ow.menu_equip_disp.visible = (ow.menu_equip_disp.size.x > 100)
			
			if ow.menu_equip_disp.position.x == 20 + variants[0]*145:
				animation = ""
		
		"Equip Menu Replace":
			if stage == 1:
				if !set_up:
					set_up = true
					t_anim = 3
					ow.menu_equip_replace.visible = true
					ow.menu_equip_stat.visible = true
					ow.menu_equip_thinkballs.visible = true
					
					for i in ow.menu_equip_stat.get_children():
						i.visible = false
				
				t_anim += delta*t_anim*10
				ow.menu_equip_replace.position.x = move_toward(ow.menu_equip_replace.position.x, 20 + variants[0]*145, t_anim*0.7)
				ow.menu_equip_replace.size.x = move_toward(ow.menu_equip_replace.size.x, variants[0]*465, t_anim*2.1)
				ow.menu_equip_stat.scale.y = move_toward(ow.menu_equip_stat.scale.y, variants[0], max(t_anim-8, 0)*0.005)
				
				var thinkball_1 = ow.menu_equip_thinkballs.get_child(0)
				var thinkball_size_x = move_toward(thinkball_1.scale.x, variants[0], max(t_anim-4, 0)*0.005)
				var thinkball_size_y = move_toward(thinkball_1.scale.y, variants[0], max(t_anim-4, 0)*0.01) 
				thinkball_1.scale = Vector2(thinkball_size_x, thinkball_size_y)
				var thinkball_2 = ow.menu_equip_thinkballs.get_child(1)
				thinkball_size_x = move_toward(thinkball_2.scale.x, variants[0], t_anim*0.005)
				thinkball_size_y = move_toward(thinkball_2.scale.y, variants[0], t_anim*0.01) 
				thinkball_2.scale = Vector2(thinkball_size_x, thinkball_size_y)
				
				ow.menu_equip_replace.visible = ow.menu_equip_replace.size.x > 110
				
				if t_anim > 50:
					ow.anim_t = 0
					ow.await_animation = false
					stage = 2
					if variants[0] == 1:
						for i in ow.menu_equip_stat.get_children():
							i.visible = true
			
			# equip menu display
			var list_last = ow.lists[ ow.place[3]-1 ].size()
			if ow.place[4] != variants[2]:
				# if on final index or moving off final index
				if (ow.place[4] == list_last) || (variants[2] == list_last):
					variants[1] = 3 # reset timer
			variants[2] = ow.place[4]
			
			var is_last : int = int(ow.place[4] != list_last)
			variants[1] = clamp(variants[1] + delta*variants[1]*14, 0, 300)
			ow.menu_equip_disp.size.x = move_toward(ow.menu_equip_disp.size.x, is_last*465, variants[1])
			ow.menu_equip_disp.position.x = move_toward(ow.menu_equip_disp.position.x, 20 + is_last*145, variants[1]/3)
			
			var charm = ow._child_by_name(ow.menu_equip_disp, "Charms")
			charm.position.x = move_toward(charm.position.x, 300 + is_last*105, variants[1]/1.4)
			charm.visible = ow.menu_equip_disp.size.x > 400
			
			ow.menu_equip_disp.visible = (ow.menu_equip_disp.size.x > 100)
		
		"Pocket":
			if !set_up:
				set_up = true
				t_anim = 1.5
			
			t_anim += delta*t_anim*10
			ow.menu_pocket.position.y = move_toward(ow.menu_pocket.position.y, 30 + variants[0]*24, t_anim*0.7)
			ow.menu_pocket.scale.y = move_toward(ow.menu_pocket.scale.y, 0.5+variants[0]*0.5, t_anim*0.02)
			
			ow.clams.scale.y = move_toward(ow.clams.scale.y, 0, delta*6)
			ow.clams.get_child(0).visible = false
			
			var b : bool = false
			if variants[0] == 1:
				b = (ow.clams.scale.y < 0.001) && ow.menu_pocket.position.y == 30+variants[0]*24
			else:
				b = ow.menu_pocket.position.y == 30+variants[0]*24
			
			if b:
				ow.await_animation = false
				ow.category_parent.visible = ow.menu_pocket.position.y != 0
				animation = ""
				if variants[0] == 0:
					ow.category_parent.visible = false
		
		"Pocket List":
			if !set_up:
				set_up = true
				t_anim = 1.5
				ow.menu_pocket_list.visible = true
				ow.menu_pocket_disp.visible = true
			
			t_anim += delta*t_anim*7
			ow.menu_pocket_list.position.y = move_toward(ow.menu_pocket_list.position.y, variants[0]*54, t_anim*0.7)
			ow.menu_pocket_list.scale.y = move_toward(ow.menu_pocket_list.scale.y, variants[0], t_anim*0.02)
			ow.menu_pocket_disp.position.y = move_toward(ow.menu_pocket_disp.position.y, 44+variants[0]*54, t_anim*0.7)
			ow.menu_pocket_disp.scale.y = move_toward(ow.menu_pocket_disp.scale.y, variants[0], t_anim*0.02)
			
			ow.p_pocket_list.global_position = ow._child_by_name(ow.menu_pocket_list, "Option1").global_position + ow.p_off
			
			if ow.menu_pocket_list.position.y == variants[0]*54 && ow.menu_pocket_disp.position.y == 44+variants[0]*54:
				ow.await_animation = false
				ow.menu_pocket_list.visible = ow.menu_pocket_list.position.y != 0
				ow.menu_pocket_disp.visible = ow.menu_pocket_list.position.y != 0
				animation = ""
		
		"Pocket Confirm":
			if !set_up:
				set_up = true
				t_anim = 1.5
				ow.menu_pocket_confirm.visible = true
			
			t_anim += delta*t_anim*10
			ow.menu_pocket_confirm.position.y = move_toward(ow.menu_pocket_confirm.position.y, 148 + variants[0]*40, t_anim*0.7)
			ow.menu_pocket_confirm.scale.y = move_toward(ow.menu_pocket_confirm.scale.y, 0.5+variants[0]*0.5, t_anim*0.02)
			
			if ow.menu_pocket_confirm.position.y == 148+variants[0]*40:
				ow.await_animation = false
				ow.menu_pocket_confirm.visible = ow.menu_pocket_confirm.position.y != 148
				animation = ""
		
		"Pocket You Sure":
			if !set_up:
				set_up = true
				t_anim = 1.5
				ow.menu_pocket_yousure.visible = true
			
			t_anim += delta*t_anim*10
			ow.menu_pocket_yousure.position.y = move_toward(ow.menu_pocket_yousure.position.y, 148 + variants[0]*40, t_anim*0.7)
			ow.menu_pocket_yousure.scale.y = move_toward(ow.menu_pocket_yousure.scale.y, 0.5+variants[0]*0.5, t_anim*0.02)
			
			if ow.menu_pocket_yousure.position.y == 148+variants[0]*40:
				ow.await_animation = false
				ow.menu_pocket_yousure.visible = ow.menu_pocket_yousure.position.y != 148
				animation = ""
		
		"Skill Menu Display":
			if !set_up:
				set_up = true
				t_anim = 3
			
			t_anim += delta*t_anim*14
			ow.menu_skill_disp.size.x = move_toward(ow.menu_skill_disp.size.x, variants[0]*465, t_anim)
			ow.menu_skill_disp.position.x = move_toward(ow.menu_skill_disp.position.x, 20 + variants[0]*145, t_anim/3)
			
			ow.menu_skill_disp.visible = (ow.menu_skill_disp.size.x > 100)
			
			if ow.menu_skill_disp.position.x == 20 + variants[0]*145:
				animation = ""
		
		"Skill Menu Replace":
			if stage == 1:
				if !set_up:
					set_up = true
					t_anim = 7
					ow.menu_skill_replace.visible = true
					ow._update_options(ow.menu_skill_replace, ow.lists[ ow.place[1]+4 ])
				
				t_anim += delta*t_anim*12
				ow.menu_skill_replace.position.x = move_toward(ow.menu_equip_replace.position.x, 60 + variants[0]*105, t_anim*0.7)
				ow.menu_skill_replace.size.x = move_toward(ow.menu_equip_replace.size.x, variants[0]*465, t_anim*2.1)
				
				ow.menu_skill_replace.visible = ow.menu_skill_replace.size.x > 110
				
				if ow.menu_skill_replace.position.x == 60 + variants[0]*105:
					ow.await_animation = false
					stage = 2
			
			# equip menu display
			var list_last = ow.lists[ ow.place[1]+4 ].size()
			if ow.place[4] != variants[2]:
				# if on final index or moving off final index
				if (ow.place[4] == list_last) || (variants[2] == list_last):
					variants[1] = 3 # reset timer
			variants[2] = ow.place[4]
			
			var is_last : int = int(ow.place[4] != list_last)
			variants[1] = clamp(variants[1] + delta*variants[1]*14, 0, 300)
			ow.menu_skill_disp.size.x = move_toward(ow.menu_skill_disp.size.x, is_last*465, variants[1])
			ow.menu_skill_disp.position.x = move_toward(ow.menu_skill_disp.position.x, 20 + is_last*145, variants[1]/3)
			
			ow.menu_skill_disp.visible = (ow.menu_skill_disp.size.x > 100)
		
		"Clam":
			if !set_up:
				set_up = true
				ow.clams.visible = true
			
			ow.clams.scale.y = move_toward(ow.clams.scale.y, variants[0], delta*6)
			
			if ow.clams.scale.y == variants[0]:
				ow.clams.visible = variants[0]
				ow.clams.get_child(0).visible = true
				animation = ""
		
		"Skill Do What":
			if !set_up:
				set_up = true
				ow.menu_skill_dowhat.visible = true
				ow.menu_skill_thinkballs.visible = true
				t_anim = 3
				
				for i in ow.menu_skill_dowhat.get_children():
					i.visible = false
			
			t_anim += delta*t_anim*10
			
			ow.menu_skill_dowhat.scale.y = move_toward(ow.menu_skill_dowhat.scale.y, variants[0],  max(t_anim-8, 0)*0.005)
			
			var thinkball_1 = ow.menu_skill_thinkballs.get_child(0)
			var thinkball_size_x = move_toward(thinkball_1.scale.x, variants[0], max(t_anim-4, 0)*0.005)
			var thinkball_size_y = move_toward(thinkball_1.scale.y, variants[0], max(t_anim-4, 0)*0.01) 
			thinkball_1.scale = Vector2(thinkball_size_x, thinkball_size_y)
			var thinkball_2 = ow.menu_skill_thinkballs.get_child(1)
			thinkball_size_x = move_toward(thinkball_2.scale.x, variants[0], t_anim*0.005)
			thinkball_size_y = move_toward(thinkball_2.scale.y, variants[0], t_anim*0.01) 
			thinkball_2.scale = Vector2(thinkball_size_x, thinkball_size_y)
			
			if t_anim > 50:
				ow.anim_t = 0
				ow.await_animation = false
				animation = ""
				
				if variants[0] == 1:
					for i in ow.menu_skill_dowhat.get_children():
						i.visible = true
		
		"Skill Use On Who":
			if !set_up:
				set_up = true
				t_anim = 2
			
			t_anim += delta*t_anim*8
			
			var j : int = 1
			for i in ow.ow_status.get_children():
				if j != ow.place[1]: # if character is not using skill fade
					if i.position.x == 87:
						i.position.x = 242
					i.position.y = move_toward(i.position.y, 480+(1-variants[0])*270, t_anim)
					i.modulate.a = move_toward(i.modulate.a, variants[0], t_anim/20)
				j += 1
			
			if t_anim > 4:
				ow.await_animation = false
				animation = ""
				
				if variants[0] == 0:
					for i in ow.ow_status.get_children():
						if i.position.x == 242:
							i.position.x = 87
