class_name PartyView extends Node

@export var battle_status : PackedScene

var statuses : Array[BattleStatus]
var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx
	_spawn(ctx.party)
	ctx.party.selection_changed.connect(_on_selection_changed)

func _exit_tree() -> void:
	context.party.selection_changed.disconnect(_on_selection_changed)

func _spawn(party : PartyState):
	for i in range(party.members.size()):
		var status : BattleStatus = battle_status.instantiate()
		add_child(status)
		match i:
			0:
				status.position = Vector2(14, 305)
			1:
				status.position = Vector2(14, 5)
			2:
				status.position = Vector2(512, 305)
			3:
				status.position = Vector2(512, 5)
			_:
				status.position = Vector2.ZERO
		status.bind(party.members[i])
		statuses.append(status)

func _on_selection_changed(old_index : int, new_index : int):
	if old_index >= 0:
		_stop_pulse(old_index)
	if new_index >= 0:
		_start_pulse(new_index)
	
func _start_pulse(i : int):
	statuses[i].battle_status_frost.start_pulse()

func _stop_pulse(i : int):
	statuses[i].battle_status_frost.stop_pulse()
