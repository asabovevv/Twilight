class_name Emotions
extends Resource

@export var name : String
@export var label_texture : Texture2D
@export var gradient_texture : Texture2D
@export var color : Color
@export var sound : String

@export_category("Stat Effects")
@export var heart : Array[int] = [0, 0, 0]
@export var juice : Array[int] = [0, 0, 0]
@export var attack : Array[int] = [0, 0, 0]
@export var defense : Array[int] = [0, 0, 0]
@export var speed : Array[int] = [0, 0, 0]
@export var luck : Array[int] = [0, 0, 0]
@export var hit : Array[int] = [100, 100, 100]
@export var walkspeed : Array[int] = [1, 1, 1]
