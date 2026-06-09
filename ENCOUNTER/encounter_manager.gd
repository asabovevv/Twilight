class_name EncounterManager extends Node

@export var menu_manager : MenuManager
@export var battlelog_manager : BattleLogManager
@export var party_view : PartyView
@export var enemy_view : EnemyView
@export var power_bar : PowerBar
@export var input : BattleInput
@export var core : EncounterCore

@export var starting_power : int = 3

func _ready() -> void:
	var state = EncounterState.new()
	var party = PartyState.new(Twilight.Party.current_party)
	var enemies = EnemyState.new([Enemy.new(Registry.get_enemy("forest_bunny"))])
	var turn_manager = TurnManager.new();
	var ctx = EncounterContext.new(menu_manager, battlelog_manager, turn_manager, party, enemies, state, core)

	menu_manager._initialize(ctx)
	battlelog_manager._initialize(ctx)
	enemy_view._initialize(ctx)
	party_view._initialize(ctx)
	power_bar._initialize(ctx)
	turn_manager._initialize(ctx)
	input._initialize(ctx)
	core._initialize(ctx)
	
	state.power = starting_power
	turn_manager.start_battle()

func _process(_delta : float) -> void:
	input.poll()
