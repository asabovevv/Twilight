class_name CursorBounce extends Sprite2D

## Handles cursor bouncing in both directions

@export var horizontal : bool = true
@export var distance : float = 3
@export var speed : float = 0.25
@export var delay : float = 0.1
var tween : Tween

func _ready() -> void:
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var direction = "offset:x" if horizontal else "offset:y"
	tween.tween_property(self, direction, distance, speed)
	tween.tween_property(self, direction, -distance, speed)
	tween.set_loops()

## Starts the cursor bounce, switches to the colored texture
func start_bounce() -> void:
	tween.play()
	frame = 0

## Stops the cursor bounce, switches to the grayscale texture, and resets the offset to zero
func stop_bounce() -> void:
	tween.stop()
	frame = 1
	offset = Vector2.ZERO
