class_name BattleLogManager extends Control

signal finished_logging

@export var log_line : PackedScene
@export var immediate_label : RichTextLabel
@export var icon : Sprite2D
@export var message_delay : float = 0.55
# TODO: refactor if the battlelog ever supports more than one font for queued messages
@export var font : Font
@export var font_size : int = 24

const PADDING : int = 11
const HEIGHT : int = 26

var _message_queue : Array[String] = []
var _line_queue : Array[String] = []
var _active_lines : Array[Control] = []

var processing_message : bool = false
var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx

func queue_message(message : String) -> void:
	_message_queue.append(message)
	if !processing_message:
		_process_message()

func show_message(message : String):
	immediate_label.text = message

func clear_and_show_message(message : String):
	clear_battlelog()
	show_message(message)

func clear_battlelog():
	_message_queue.clear()
	_line_queue.clear()
	for line in _active_lines:
		line.queue_free()
	_active_lines.clear()
	immediate_label.text = ""

func _process_message() -> void:
	processing_message = true
	while not _message_queue.is_empty():
		var next : String = _message_queue.pop_front()
		for line in next.split("\n", false):
			for wrapped_line in _word_wrap(line):
				_line_queue.append(wrapped_line)
		await _process_lines()
	processing_message = false
	finished_logging.emit()

func _process_lines() -> void:
	while not _line_queue.is_empty():
		while _active_lines.size() >= 3:
			_move_off_screen(_active_lines[0])
			_active_lines.pop_front()
		
		var new_line : Control = log_line.instantiate()
		new_line.get_node("Label").text = _line_queue.pop_front()
		new_line.position = Vector2(11, 5 + (_active_lines.size() * HEIGHT))
		new_line.modulate = Color.TRANSPARENT
		add_child(new_line)
		_active_lines.append(new_line)
		
		var tween : Tween = create_tween()
		tween.tween_property(new_line, "modulate:a", 1, 0.15)
		
		for i in range(_active_lines.size()):
			var line : Control = _active_lines[i]
			var target = Vector2(11, 5 + (i * HEIGHT))
			var reposition : Tween = create_tween()
			reposition.tween_property(line, "position", target, 0.15).set_trans(Tween.TRANS_SINE)
		
		await get_tree().create_timer(message_delay).timeout

func _word_wrap(text : String) -> Array[String]:
	var result : Array[String] = []
	if text.is_empty():
		return result
	var max_width : float = size.x - (PADDING * 2)
	var words : PackedStringArray = text.split(' ', false)
	var line : String = words[0]
	for i in range(1, words.size()):
		var word := words[i]
		var candidate := line + ' ' + word
		if _text_width(candidate) <= max_width:
			line = candidate
		else:
			result.append(line)
			line = word
	result.append(line)
	return result

func _text_width(text : String) -> float:
	return font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x

func _move_off_screen(line : Control) -> void:
	var tween : Tween = create_tween().set_parallel()
	tween.tween_property(line, "position", Vector2(11, -HEIGHT), 0.15).set_trans(Tween.TRANS_SINE)
	tween.tween_property(line, "modulate:a", 0, 0.15)
	await tween.finished
	line.queue_free()
