extends Node2D

@onready var menu_emotion = $SpinPortraits/EmotionSelect
@onready var text_emotion = $SpinPortraits/EmotionSelect/Emotion
@onready var spin_root = $SpinPortraits
@onready var center_portrait = $SpinPortraits/CenterPortrait/Portrait
@onready var blur = $Blur
@onready var tagImage = $TagImage
@onready var arrows = $SpinPortraits/EmotionSelect/UiArrowLarge
var player : CharacterBody2D
var sounds_list : Array
var blur_strength : float = 0

var spin_spread : float = 0
var spin_step : float = deg_to_rad(360)
var spin_offset : float = PI*0.5

var stage = 0
var spin_pos : float = -PI
var spin_target_pos : float = 0
var max_pos : int = 0
var emotion_pos : Array[int]
var anim_t : float = 0
var center_frame : float = 0

var spin_portraits : Array
var spin_count : int = 4

func _ready() -> void:
	spin_portraits = [$SpinPortraits/SpinPortrait1, $SpinPortraits/SpinPortrait2, $SpinPortraits/SpinPortrait3, $SpinPortraits/SpinPortrait4]
	max_pos = Global.Party_Order.size()
	
	for i in range(4):
		if i < max_pos:
			spin_portraits[i].get_child(0).texture = Global.Party_Order[i].Emotion.gradient_texture
			
			spin_portraits[i].get_child(1).texture = load(Global.Party_Order[i].Path + "Portraits/Portrait0.png")
			spin_portraits[i].get_child(1).region_rect = Global.Party_Order[i].Portrait_Crop_Rect
			
			for j in range( Global.Party_Fast_Emotion.size() ):
				if Global.Party_Order[i].Emotion.name == Global.Party_Fast_Emotion[j]:
					emotion_pos.append(j)
		else:
			spin_portraits[i].queue_free()
			spin_count -= 1
	
	center_portrait.texture = load(Global.Party_Order[0].Path + "Portraits/Portrait0.png")
	center_portrait.region_rect = Global.Party_Order[0].Portrait_Crop_Rect
	
	spin_step /= spin_count
	
	sounds_list.append( Global.load_sound("res://SOUNDS/SoundEffect/SE_move1.ogg", Global.Volumes.SoundEffect, self) )
	sounds_list.append( Global.load_sound("res://SOUNDS/SoundEffect/SE_tag.ogg", Global.Volumes.SoundEffect, self) )
	for i in Global.Party_Fast_Emotion.size():
		sounds_list.append( Global.load_sound( Global.emotion(Global.Party_Fast_Emotion[i]).sound, Global.Volumes.SoundEffect, self) )
	
	if Global.Party_Fast_Emotion.size() == 1:
		arrows.visible = false

func _process(delta: float) -> void:
	match stage:
		0:
			blur_strength = move_toward(blur_strength, 1, delta*5)
			blur.material.set_shader_parameter("fade", blur_strength)
			spin_root.modulate.a = blur_strength
			
			spin_spread = lerpf(0, blur_strength*160, blur_strength)
			spin_pos = lerpf(-PI*0.3, spin_target_pos, blur_strength)
			for i in range(spin_count):
				spin_portraits[i].position = Vector2(-57, -57) + Vector2(spin_spread, 0).rotated( (spin_pos*spin_step) + (spin_step*i) - spin_offset)
			
			if blur_strength == 1:
				stage = 1
		
		1:
			# Tag Select
			spin_spread = move_toward(spin_spread, 160, delta*120)
			
			if abs(spin_target_pos - spin_pos) < 3:
				if Input.is_action_just_pressed("Left"):
					spin_target_pos -= 1
					sounds_list[0].play()
				if Input.is_action_just_pressed("Right"):
					spin_target_pos += 1
					sounds_list[0].play()
			
			spin_pos = move_toward(spin_pos, spin_target_pos, delta*6)
			var actual_pos : int = wrap(int(spin_target_pos), 0, max_pos )
			
			for i in range(spin_count):
				spin_portraits[i].position = Vector2(-57, -57) + Vector2(spin_spread, 0).rotated( (spin_pos*spin_step) + (spin_step*i) - spin_offset)
			
			# Emotion Select
			menu_emotion.visible = spin_target_pos == spin_pos
			if menu_emotion.visible:
				text_emotion.texture = Global.Party_Order[actual_pos].Emotion.label_texture
				
				if Input.is_action_just_pressed("Down"):
					emotion_pos[actual_pos] = wrap( (emotion_pos[actual_pos] - 1), 0, Global.Party_Fast_Emotion.size())
					_update_emotion_pos(actual_pos)
				if Input.is_action_just_pressed("Up"):
					emotion_pos[actual_pos] = wrap( (emotion_pos[actual_pos] + 1), 0, Global.Party_Fast_Emotion.size())
					_update_emotion_pos(actual_pos)
			
			# Anim
			center_frame += delta
			center_portrait.frame = int(center_frame*3) % 3
			
			if !Input.is_action_pressed("Tag"):
				stage = 2
		
		2:
			var actual_pos : int = wrap(int(spin_target_pos), 0, max_pos )
			
			if actual_pos == 0:
				if anim_t == 0:
					player.set_emotion_string(Global.Party_Order[actual_pos].Emotion.name)
					menu_emotion.visible = false
				
				anim_t += delta
				
				blur_strength = move_toward(blur_strength, 0, delta*5)
				blur.material.set_shader_parameter("fade", blur_strength)
				spin_root.modulate.a = blur_strength
				
				spin_spread = lerpf(0, blur_strength*160, blur_strength)
				spin_pos = lerpf(-PI*0.3, actual_pos, blur_strength)
				for i in range(spin_count):
					spin_portraits[i].position = Vector2(-57, -57) + Vector2(spin_spread, 0).rotated( (spin_pos*spin_step) + (spin_step*i) - spin_offset)
				
				if blur_strength == 0:
					player.cutscene = false
					queue_free()
				
			else:
				if anim_t == 0:
					sounds_list[1].play()
					spin_root.visible = false
					
					var new_order : Array = [ Global.Party_Order[actual_pos] ]
					for i in range(max_pos):
						if Global.Party_Order[i] != new_order[0]:
							new_order.append(Global.Party_Order[i])
					Global.Party_Order = new_order
					
					tagImage.visible = true
					tagImage.position.y = -240
				
				anim_t += delta
				
				if anim_t < 1.1:
					tagImage.position.y = clamp(lerpf(-240, 240, anim_t * 3), -240, 240)
				else:
					# player order set
					player.new_sprites()
					player.set_emotion_string(Global.Party_Order[0].Emotion.name)
					
					tagImage.position.y = lerpf(240, 700, (anim_t-1.1) * 3)
					blur.material.set_shader_parameter("fade", 1 - (anim_t-1.1)*3 )
					
					if tagImage.position.y >= 700:
						player.cutscene = false
						queue_free()

func _update_emotion_pos(pos : int) -> void:
	if Global.Party_Fast_Emotion.size() > 1:
		sounds_list[emotion_pos[pos]+2].play()
		Global.Party_Order[pos].Emotion = Global.emotion( Global.Party_Fast_Emotion[ emotion_pos[pos] ])
		spin_portraits[pos].get_child(0).texture = Global.Party_Order[pos].Emotion.gradient_texture
