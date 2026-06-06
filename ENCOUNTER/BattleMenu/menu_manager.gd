class_name MenuManager extends Node

@export var fight_run_menu : FightRunMenu
@export var fsst_menu : FSSTMenu
@export var skill_menu : SkillMenu
@export var snack_menu : ItemMenu
@export var toy_menu : ItemMenu

signal menu_changed(new_menu, immediate)

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


func on_input(direction : Vector2i):
	if current_state == MenuState.State.NONE:
		return
	_current_menu.on_input(direction)

func show_menu(state : MenuState.State, immediate : bool = false, ignore_memory : bool = false):
	current_state = state
	if current_state == MenuState.State.NONE:
		for open in _menus.values().filter(func(x): return x.visible):
			open.move_down(state, immediate)
		_current_menu = null
		menu_changed.emit(current_state, immediate)
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
	menu_changed.emit(current_state, immediate)

## Adds a party member's menu selection to the memory
func save_last_selected(member_id : String) -> void:
	_last_selected[member_id] = SelectionMemory.new(current_state, _current_menu.cursor_index)

## Clears ALL menu selection entries
func clear_last_selected() -> void:
	_last_selected.clear()
