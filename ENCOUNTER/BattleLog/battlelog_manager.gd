class_name BattleLogManager extends Node

signal finished_logging

@export var log_line : PackedScene
@export var immediate_label : RichTextLabel

var _message_queue : Array[String] = []
var _line_queue : Array[String] = []
var _active_lines : Array[Control] = []

var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx

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
