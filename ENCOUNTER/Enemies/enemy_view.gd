class_name EnemyView extends Node

@export var enemy_scene : PackedScene

var statuses : Array[EnemyStatus]
var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx
	_spawn(ctx.enemies)
	ctx.enemies.selection_changed.connect(_on_selection_changed)

func _exit_tree() -> void:
	context.enemies.selection_changed.disconnect(_on_selection_changed)
	
func _spawn(enemies : EnemyState):
	for enemy in enemies.enemies:
		var status : EnemyStatus = enemy_scene.instantiate()
		add_child(status)
		# TODO: enemy positioning, for now just spawn them all at the center of the screen
		# TODO: respect offsets
		status.global_position = Vector2(320, 240)
		status.bind(enemy)
		status.hide_infobox()
		statuses.append(status)

func _on_selection_changed(old_index : int, new_index : int):
	if old_index >= 0:
		hide_infobox(old_index)
	if new_index >= 0:
		show_infobox(new_index)

func show_infobox(index : int):
	statuses[index].show_infobox()

func hide_infobox(index : int):
	statuses[index].hide_infobox()
