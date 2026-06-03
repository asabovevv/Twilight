class_name EncounterContext

# !!! DO NOT TOUCH !!!
var menu : MenuManager
var battlelog : BattleLogManager
var turn : TurnManager
var party : PartyState
var state : EncounterState

func _init(
	menu : MenuManager,
	battlelog : BattleLogManager,
	turn : TurnManager,
	party : PartyState,
	state : EncounterState
):
	self.menu = menu
	self.battlelog = battlelog
	self.turn = turn
	self.party = party
	self.state = state
