class_name EncounterContext

# !!! DO NOT TOUCH !!!
var menu : MenuManager
var battlelog : BattleLogManager
var turn : TurnManager
var party : PartyState
var enemies : EnemyState
var state : EncounterState
var core : EncounterCore

func _init(
	_menu : MenuManager,
	_battlelog : BattleLogManager,
	_turn : TurnManager,
	_party : PartyState,
	_enemies : EnemyState,
	_state : EncounterState,
	_core : EncounterCore
):
	menu = _menu
	battlelog = _battlelog
	turn = _turn
	party = _party
	enemies = _enemies
	state = _state
	core = _core
