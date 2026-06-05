class_name EncounterManager extends Node

@export var menu_manager : MenuManager
@export var battlelog_manager : BattleLogManager
@export var party_view : PartyView
@export var power_bar : PowerBar

@export var starting_power : int = 3

func _ready() -> void:
	var state = EncounterState.new(starting_power)
	var party = PartyState.new(Twilight.Party.current_party)
	var turn_manager = TurnManager.new();
	var ctx = EncounterContext.new(menu_manager, battlelog_manager, turn_manager, party, state)

	menu_manager._initialize(ctx)
	battlelog_manager._initialize(ctx)
	party_view._initialize(ctx)
	power_bar._initialize(ctx)
	turn_manager._initialize(ctx)

	turn_manager.start_battle()
