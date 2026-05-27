extends NPCBasic

@export var glow : ColorRect
var glow_scale : float = 0

func _animate():
	glow.size.y = (38 + sin(time*0.8) * 15) * glow_scale
	
