class_name Enemy
extends Resource

@export var Max_Health : int = 20
@export var Max_Juice : int = 20
@export var Move_List : Array

@export_category("Visual")
@export var Pointer_Offset : float = 50
@export var Position_Offset : Vector2i = Vector2i(0, 0)
@export var Idle : Texture2D
@export var Hurt : Texture2D
@export var Die : Texture2D
@export var Happy : Texture2D
@export var Sad : Texture2D
@export var Angry : Texture2D
