class_name MenuManager extends Node

@export var fight_run_menu : FightRunMenu
@export var fsst_menu : FSSTMenu
@export var skill_menu : SkillMenu
@export var snack_menu : ItemMenu
@export var toy_menu : ItemMenu

var current_state : MenuState.State = MenuState.State.NONE

var _current_menu : Menu
var _menus : Dictionary[MenuState.State, Menu]
var context : EncounterContext

var _last_selected : Dictionary[String, SelectionMemory] = {}

func _enter_tree() -> void:
	_menus = {
		MenuState.State.FIGHT_RUN: fight_run_menu,
		MenuState.State.FSST: fsst_menu,
		MenuState.State.SKILL: skill_menu,
		MenuState.State.SNACK: snack_menu,
		MenuState.State.TOY: toy_menu
	}

func _initialize(ctx : EncounterContext):
	context = ctx
	for menu in _menus.values():
		menu.context = ctx


func _process(delta: float) -> void:
	if current_state == MenuState.State.NONE:
		return
	if Input.is_action_just_pressed("Cancel"):
		context.turn.on_cancel()
		return
	if Input.is_action_just_pressed("Confirm"):
		_current_menu.on_input(Vector2i.ZERO)
	elif Input.is_action_just_pressed("Up"):
		_current_menu.on_input(Vector2i.UP)
	elif Input.is_action_just_pressed("Down"):
		_current_menu.on_input(Vector2i.DOWN)
	elif Input.is_action_just_pressed("Left"):
		_current_menu.on_input(Vector2i.LEFT)
	elif Input.is_action_just_pressed("Right"):
		_current_menu.on_input(Vector2i.RIGHT)

func show_menu(state : MenuState.State, immediate : bool = false, ignore_memory : bool = false):
	current_state = state
	if current_state == MenuState.State.NONE:
		for open in _menus.values().filter(func(x): return x.visible):
			open.move_down(state, immediate)
		_current_menu = null
		return
	
	if _current_menu:
		_current_menu.move_down(state, immediate)
	_current_menu = _menus[current_state]
	var current : PartyMember = context.party.current_selected()
	if ignore_memory:
		_current_menu.on_open(SelectionMemory.new(current_state, _current_menu.cursor_index))
	elif current:
		var selection : SelectionMemory = _last_selected.get(current.data.key)
		if selection:
			_current_menu.on_open(selection)
	else:
		_current_menu.on_open(SelectionMemory.new(current_state, 0))
	_current_menu.move_up(immediate)

## Adds a party member's menu selection to the memory
func save_last_selected(member_id : String) -> void:
	_last_selected[member_id] = SelectionMemory.new(current_state, _current_menu.cursor_index)

## Clears ALL menu selection entries
func clear_last_selected() -> void:
	_last_selected.clear()
