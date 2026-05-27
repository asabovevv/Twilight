extends Cutscene

var player : CharacterBody2D
var party_members : Node2D

var mintySprites : Array[Sprite2D]
var sunnySprites : Array
var bunnySprites : Array[Sprite2D]
var question : Node2D
var door : Sprite2D
var rushBunny : Array
var happy_bun : Texture
var normal_bun : Texture

var walkframes : Array = [0, 1, 0, 2]

var sound : Array

func _ready() -> void:
	player = nodes[0]
	party_members = nodes[1]
	mintySprites = [nodes[2], nodes[3], nodes[4], nodes[5]]
	sunnySprites = [nodes[6], nodes[7], nodes[8], nodes[9], nodes[10], nodes[11], nodes[12], nodes[26]]
	bunnySprites = [nodes[13], nodes[14], nodes[15], nodes[16]]
	question = nodes[17]
	door = nodes[18]
	rushBunny = [nodes[19], nodes[20], nodes[21], nodes[22], nodes[23], nodes[24], nodes[25]]
	
	counter = [0, 0, 0, 0]
	
	player.cutscene = true
	player.sprites.visible = false
	party_members.visible = false
	
	happy_bun = load("res://ENTITIES/Npc/Mobile/Pinkspace/NPC_Bunny_Happy.png")
	normal_bun = load("res://ENTITIES/Npc/Mobile/Pinkspace/NPC_Bunny_Idle.png")
	
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_sad_squeak.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_jump.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_impact_double.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_doorknob1.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_doorknob2.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_door_slam.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_wah.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
	sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_sparkle.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )

func _act(delta: float) -> void:
	match stage:
		0:
			# Opens Eyes
			if time < 2:
				mintySprites[0].frame = clamp(  (time-0.9)*2,  0,2)
			
			# Chewing hair
			if time < 5:
				bunnySprites[3].frame = int(time*2) % 2
			if time > 5.5:
				bunnySprites[3].flip_h = true
				bunnySprites[3].position += Vector2(delta * 70, delta * -45)
				bunnySprites[3].frame = int(time_const*2) % 2
			if time > 6:
				bunnySprites[3].z_index = 0
			
			# Sleeping bunny
			bunnySprites[2].frame = int(time_const) % 2
			
			# Bunny Zooms In
			if (time > 3) && (time < 5):
				bunnySprites[0].position.y = move_toward(bunnySprites[0].position.y, 23, delta*250)
			if time > 3:
				bunnySprites[0].frame = int(time*5) % 2
			
			# Sit up
			if _time(5):
				mintySprites[0].visible = false
				mintySprites[1].visible = true
				sound[0].play()
			
			# Minty looks at bunny
			if _time(6):
				_dialogue(player, [ "|dbox||face:Minty:1||wait:@:0.2|...What happened,@ little bunny?",
									"Do you need me to console you?"])
			
			# End dialogue
			if (time > 6) && (!player.dialogue_active):
				mintySprites[1].frame = 1
				stage = 1
				time = -0.3
		
		1:
			# Sleeping bunny
			bunnySprites[2].frame = int(time_const) % 2
			# Chew hair escape
			bunnySprites[3].position += Vector2(delta * 70, delta * -45)
			bunnySprites[3].frame = int(time_const*2) % 2
			
			# Bunny jump into arms
			if (time > 0.5) && (time < 1):
				bunnySprites[0].position.y += (time-0.82)*850*delta
			if _time(0.5):
				sound[1].play()
			
			# Lay back and pet bunny
			if _time(1):
				mintySprites[1].visible = false
				mintySprites[2].visible = true
				bunnySprites[0].visible = false
			if time > 1:
				mintySprites[2].frame = int(time*2) % 2
			
			# I wish someone would console me
			if _time(3):
				_dialogue(player, [ "|dbox||face:Minty:2||wait:@:0.3|*Sniffle, sniffle...*@ I understand...",
									"|face:Minty:3||wait:@:0.2|I wish someone would console me,@ too..."] )
			
			# Squeeze Shake
			if counter[0] == 1:
				counter[1] += delta
				mintySprites[3].frame = min(counter[1] * 6, 4)
			elif _dialogue_place(1):
				counter[0] = 1
				mintySprites[2].visible = false
				mintySprites[3].visible = true
				player.shake(0.3, 7, false)
				sound[2].play()
			
			# End animation
			if counter[1] > 1 && (!player.dialogue_active):
				stage = 2
				time = -2
		
		2:
			# Sleeping bunny
			bunnySprites[2].frame = int(time_const) % 2
			# Jiggle doorknob
			if _time(-0.6):
				sound[3].play()
			
			# Question mark
			if (time > 0) && (time < 0.5):
				question.visible = true
				question.frame = min(time*8, 2)
				question.position.y = -22 + sin(time * 6) * 3
			# Remove question mark
			if time > 0.5 && time < 1:
				question.position.y = -22 + sin(time * 6) * 3
				question.modulate.a = 1-(time-0.5)*2
			
			# Sit up
			if _time(1):
				mintySprites[3].visible = false
				mintySprites[1].visible = true
				mintySprites[1].frame = 2
				bunnySprites[3].position = Vector2(22, -4)
			# Bunny get off lap
			if (time > 1) && (time < 1.1):
				bunnySprites[3].position.x += delta * 100
			
			# Jiggle again
			if _time(2.2):
				sound[4].play()
			
			# WHAT THE FU
			if _time(3):
				_dialogue(player, [ "|dbox||br:@|Grhh...@ What's the matter with this thing!?",
									"|wave:&:50:5.0||wait:^:0.6|&OPEN...^ UP!!!"] )
			
			if (time > 3) && !player.dialogue_active:
				stage = 3
				time = 0
				
				bunnySprites[2].texture = bunnySprites[3].texture
				_hop(bunnySprites[2], 20, 0.2)
				
				sound[5].play()
				sunnySprites[1].visible = true
				player.shake(0.3, 10)
		
		3:
			# Break down door and charge through
			if (time < 0.4):
				door.frame = time * 8
				door.glow_scale = time * 2.2
				sunnySprites[1].frame = walkframes[wrap(time*6, 0, 3)]
				sunnySprites[0].position.y += delta * 150
			elif (time < 0.52):
				sunnySprites[1].frame = 0
			
			# Bunnies surprise
			if _time(0.8):
				rushBunny[0].moves = false
				rushBunny[0].texture = happy_bun
				rushBunny[1].moves = false
				rushBunny[1].hframes = 2
				rushBunny[1].texture = happy_bun
				rushBunny[2].moves = false
				rushBunny[2].texture = happy_bun
				rushBunny[3].texture = happy_bun
				rushBunny[4].texture = happy_bun
				rushBunny[4].flip_h = false
				rushBunny[5].moves = false
				rushBunny[5].texture = happy_bun
				rushBunny[6].moves = false
				rushBunny[6].texture = happy_bun
				
				sound[1].play()
				
				for i in rushBunny:
					_hop(i, 10, 0.2)
			if (time > 1):
				for i in rushBunny:
					i.frame = int(time_const * 5) % 2
			
			# Get sunny position
			var s_x : float = sunnySprites[0].global_position.x+134
			var s_y : float = sunnySprites[0].global_position.y-58
			
			# Bunnies rush to sunny
			if (time > 1.2) && (time < 4):
				if rushBunny[0].global_position.y != s_y:
					rushBunny[0].global_position.y = move_toward(rushBunny[0].global_position.y, s_y, delta*300)
				else:
					rushBunny[0].global_position.x = move_toward(rushBunny[0].global_position.x,  s_x-32, delta*300)
				
				if rushBunny[1].global_position.x != s_x+32:
					rushBunny[1].global_position.x = move_toward(rushBunny[1].global_position.x,  s_x+32, delta*200)
				else:
					rushBunny[1].flip_h = true
					rushBunny[1].global_position.y = move_toward(rushBunny[1].global_position.y,  s_y, delta*200)
				
				if rushBunny[2].global_position.y != s_y:
					rushBunny[2].global_position.y = move_toward(rushBunny[2].global_position.y, s_y, delta*200)
				else:
					rushBunny[2].global_position.x = move_toward(rushBunny[2].global_position.x,  s_x, delta*200)
				
				if rushBunny[3].global_position.y != s_y+32:
					rushBunny[3].global_position.y = move_toward(rushBunny[3].global_position.y, s_y+32, delta*300)
				else:
					rushBunny[3].global_position.x = move_toward(rushBunny[3].global_position.x,  s_x, delta*300)
				
				if rushBunny[4].global_position.y != s_y-32:
					rushBunny[4].global_position.y = move_toward(rushBunny[4].global_position.y, s_y-32, delta*200)
				else:
					rushBunny[4].global_position.x = move_toward(rushBunny[4].global_position.x,  s_x-32, delta*200)
				
				if rushBunny[5].global_position.x != s_x+32:
					rushBunny[5].global_position.x = move_toward(rushBunny[5].global_position.x,  s_x+32, delta*200)
				else:
					rushBunny[5].flip_h = true
					rushBunny[5].global_position.y = move_toward(rushBunny[5].global_position.y, s_y-32, delta*200)
				
				if rushBunny[6].global_position.y != s_y-64:
					rushBunny[6].global_position.y = move_toward(rushBunny[6].global_position.y, s_y-64, delta*250)
				else:
					rushBunny[6].global_position.x = move_toward(rushBunny[6].global_position.x, s_x, delta*250)
			
			# Sunny uoooghh...
			if _time(4):
				sunnySprites[1].visible = false
				sunnySprites[2].visible = true
				sound[6].play()
			
			# Bunny jump on head
			if (time > 5) && (time < 5.67):
				rushBunny[6].position.y += (time-5.3)*400*delta
				if time > 5.2:
					rushBunny[6].z_index = 200
					rushBunny[6].texture = normal_bun
					rushBunny[6].flip_h = true
			if _time(5):
				sound[1].play()
			
			# Bunny Close in on Sunny
			if (time > 5) && (time < 6):
				for i in range(rushBunny.size() - 1):
					rushBunny[i].global_position.x = move_toward(rushBunny[i].global_position.x, s_x, delta * 10)
					rushBunny[i].global_position.y = move_toward(rushBunny[i].global_position.y, s_y-32, delta * 6)
				
				rushBunny[5].z_index = 200
				rushBunny[5].global_position += delta * Vector2(-11, 12)
			
			# Attach to leg
			if _time(6):
				sunnySprites[2].visible = false
				sunnySprites[3].visible = true
				
				rushBunny[5].visible = false
				counter[0] = rushBunny[6].global_position.x-1
				counter[1] = rushBunny[6].global_position.y
			
			# Shake bunny off foot
			if (time > 6) && (time < 7.6):
				var f = int(time * 4) % 2
				sunnySprites[3].frame = f
				rushBunny[6].global_position = Vector2(counter[0]-(f-0.5)*2, counter[1]+(f-0.5)*2)
			
			# Give up shaking
			if _time(8.2):
				sunnySprites[1].visible = true
				sunnySprites[3].visible = false
				rushBunny[5].visible = true
			# Bunny chase off slightly
			if (time > 8.2) && (time < 8.4):
				rushBunny[5].position.x += delta * 100
			
			# Bunnies approach again
			if (time > 8.6) && (time < 9):
				for i in range(rushBunny.size() - 1):
					rushBunny[i].global_position.x = move_toward(rushBunny[i].global_position.x, s_x, delta * 10)
					rushBunny[i].global_position.y = move_toward(rushBunny[i].global_position.y, s_y-32, delta * 6)
			
			if _time(9.6):
				sunnySprites[1].visible = false
				sunnySprites[4].visible = true
				_dialogue(player, [ "|dbox||face:Sunny:1||br:@|Uh...@ I think someone broke your door.",
									"|face:Sunny:0|Maybe get that checked out."] )
			
			if (time > 9.6) && !player.dialogue_active:
				stage = 4
				time = 0
				counter[0] = sunnySprites[0].position.y - 32
				counter[1] = sunnySprites[0].position.x - 32
				counter[2] = 0
				for i in rushBunny:
					i.texture = normal_bun
		
		4:
			for i in rushBunny:
				i.frame = int(time_const * 2) % 2
			rushBunny[6].global_position = Vector2( sunnySprites[0].global_position.x+134,
													sunnySprites[0].global_position.y-112)
			
			# Sunny walk around Bunnies
			if time > 0.25:
				match int(counter[2]):
					0:
						if sunnySprites[0].position.y != counter[0]:
							sunnySprites[4].visible = false
							sunnySprites[7].visible = true
							sunnySprites[0].position.y = move_toward(sunnySprites[0].position.y, counter[0], delta*120)
						else:
							sunnySprites[4].visible = true
							sunnySprites[7].visible = false
							
							sunnySprites[0].position.x = move_toward(sunnySprites[0].position.x, counter[1], delta*120)
							if sunnySprites[0].position.x == counter[1]:
								counter[2] = 1
								counter[0] = floor(counter[0]+93)
					# Sunny walk to Aubrey
					1:
						if sunnySprites[0].position.y != counter[0]:
							sunnySprites[1].visible = true
							sunnySprites[4].visible = false
							
							sunnySprites[0].position.y = move_toward(sunnySprites[0].position.y, counter[0], delta*120)
							if sunnySprites[0].position.y == counter[0]:
								counter[2] = 2
					2:
							sunnySprites[4].visible = true
							sunnySprites[1].visible = false
							
							sunnySprites[0].position.x = move_toward(sunnySprites[0].position.x, -92, delta*120)
							if sunnySprites[0].position.x == -92:
								counter[2] = 3
				
				# Animate Walking
				if counter[2] < 3:
					var f = floor(wrap(time*5, 0, 4))
					sunnySprites[1].frame = walkframes[f]
					sunnySprites[4].frame = walkframes[f]
					sunnySprites[7].frame = walkframes[f]
			
			# Bunny Follow
			if counter[2] == 2:
				for i in range(rushBunny.size() - 1):
					rushBunny[i].global_position.x -= delta * 80
					rushBunny[i].flip_h = false
			
			# Walking ended
			if counter[2] == 3:
				sunnySprites[4].frame = 0
				stage = 5
				time = 0
				counter[0] = 0
				_dialogue(player, [ "|dbox||face:Sunny:0||br:@||wait:&:0.2|We should get going,& your majesty.@ Your friends are starting to get impatient."] )
		
		5:
			if !player.dialogue_active:
				counter[0] += 1
			
			if counter[0] == 1:
				mintySprites[1].frame = 3
				_hop(mintySprites[1], 4, 0.15)
				_dialogue(player, [ "|dbox||face:Minty:5|...",
									"|face:Sunny:1|...What?",
									"|face:Sunny:2|Don't pretend you can't walk."] )
				counter[0] = 2
			
			if _dialogue_place(1):
				stage = 6
				time = 0
				counter[0] = 0
		
		6:
			if !player.dialogue_active:
				counter[0] += delta
			
			# Bunny Follow (Inch closer)
			if time < 1:
				for i in range(rushBunny.size() - 1):
					rushBunny[i].global_position.x -= delta * 32
			
			# Minty look BIG EYES
			if counter[0] > 0.3:
				mintySprites[1].frame = 4
				sound[7].play()
				_dialogue(player, [ "|dbox||face:Minty:4|[shake rate=30.0 level=6 connected=1].....................................",
									"|face:Sunny:2|...",
									"|face:Sunny:3|The things I do.",
									"|face:Sunny:0||br:@|.......Fine.@ Don't expect me to do this again." ] )
				stage = 7
		
		7:
			if !player.dialogue_active:
				stage = 8
				time = 0
				
				counter[0] = 0
				
				sunnySprites[4].visible = false
				mintySprites[1].visible = false
				sunnySprites[5].visible = true
		
		8:
			rushBunny[6].global_position = Vector2( sunnySprites[0].global_position.x+134,
													sunnySprites[0].global_position.y-112)
			
			# Drag Minty
			if time > 0.6:
				if sunnySprites[0].position.x != -6:
					sunnySprites[0].position.x = move_toward(sunnySprites[0].position.x, -6, delta*70)
					
					for i in range(rushBunny.size() - 1):
						rushBunny[i].global_position.x += delta * 90
				else:
					sunnySprites[5].visible = false
					sunnySprites[6].visible = true
					sunnySprites[0].position.y = move_toward(sunnySprites[0].position.y, -32, delta*70)
					
					if sunnySprites[0].position.y == -32:
						counter[0] = 1
						player.fade_target = 1
				
				# Animate dragging
				if counter[0] == 0:
					var f = floor(wrap(time*4, 0, 4))
					sunnySprites[5].frame = walkframes[f]
					sunnySprites[6].frame = walkframes[f]
					
				# Exit room
				else:
					if player.fade.self_modulate.a == 1:
						Global.set_flag(Global.Flag_Name.Pinkspace_Intro_Finished, true)
						get_tree().change_scene_to_file("res://ROOMS/Afterglow/WS_NeighborsRoom/ws_neighborsroom.tscn")
				
				# Bunny Follow
				if sunnySprites[0].position.y < 45:
					for i in range(rushBunny.size() - 1):
						rushBunny[i].global_position.y -= delta * 20
