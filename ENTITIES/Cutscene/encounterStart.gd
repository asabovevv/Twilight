extends Cutscene

var player : CharacterBody2D
var transitionType : int = 0
var sound : Array

func _ready() -> void:
	setup()

func setup() -> void:
	player = nodes[0]
	player.cutscene = true
	
	transitionType = Global.encounter.transitionStyle

func _act(delta: float) -> void:
	match transitionType:
		
		# Standard Fade
		0:
			if stage == 0:
				nodes.append( NinePatchRect.new() )
				nodes[1].texture = load("res://UI/BattleTransitions/DefaultGradient.png")
				nodes[1].size = Vector2(128, 300)
				nodes[1].scale = Vector2(5, 5)
				nodes[1].patch_margin_top = 58
				nodes[1].global_position = player.camera.global_position + Vector2(-320, 240)
				nodes[1].z_index = 3000
				add_child( nodes[1] )
				
				player.shake(1, 4)
				
				sound.append(Global.load_sound("res://SOUNDS/SoundEffect/SE_battle_encounter.ogg", Global.volume_levels[Global.Volumes.SoundEffect], self) )
				sound[0].play()
				
				stage = 1
				time = 0
			else:
				nodes[1].global_position.y -= delta * 1440
				
				if _time(1):
					get_tree().change_scene_to_file("res://ENCOUNTER/encounter.tscn")
			
