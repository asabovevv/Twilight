extends Node2D

@export var bg : Sprite2D
@export var enemy_root : Node2D
@export var menu_enemyhealth : Sprite2D
@export var bar_enemyhealth : Sprite2D
@export var text_enemyhealth : Label
@export var menu_updatebox : NinePatchRect
@export var text_updatebox : Label
@export var root_updates : Node2D
@export var small_status_root : Node2D
@export var big_status_root : Node2D
@export var bars_root : Node2D
@export var fightrun_bar_root : Node2D
@export var p_fightrun_bar : Sprite2D
@export var fsst_bar_root : Node2D
@export var p_fsst_bar : Sprite2D
@export var power_bar : Sprite2D
@export var text_power_bar : Label
@export var dots_power_bar : Sprite2D

var enemiesHealth : Array
var enemiesJuice : Array

func _ready() -> void:
	set_status(big_status_root, false)
	set_status(small_status_root, true)
	
	bg.texture = Global.encounter.background
	
	#for i in Global.encounter.enemies:
	#	var e = Sprite2D.new()
	#	e.texture = Global.encounter.enemies[i].Idle
	#	enemy_root.append(e)
	#	enemiesHealth.append(Global.encounter.enemies[i].Max_Health)

func set_status(root:Node2D, support : bool) -> void:
	var j : int = 0
	for i in root.get_children():
		var portrait = i.get_child(1)
		
		if j == Global.Party_Size:
			i.visible = false
		else:
			while portrait.texture == null:
				if j == Global.Party_Size:
					i.visible = false
					break
				
				if Global.Party_Order[j].Is_Support == support:
					portrait.texture = load(Global.Party_Order[j].Path + "Portraits/Portrait0.png")
					portrait.region_rect = Global.Party_Order[j].Battle_Crop_Rect
					portrait.position.y -= Global.Party_Order[j].Battle_Crop_Rect.size.y*0.5
				j += 1
