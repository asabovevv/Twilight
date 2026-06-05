class_name EncounterContext

# !!! DO NOT TOUCH !!!
var menu : MenuManager
var battlelog : BattleLogManager
var turn : TurnManager
var party : PartyState
var state : EncounterState

func _init(
	_menu : MenuManager,
	_battlelog : BattleLogManager,
	_turn : TurnManager,
	_party : PartyState,
	_state : EncounterState
):
	menu = _menu
	battlelog = _battlelog
	turn = _turn
	party = _party
	state = _state
