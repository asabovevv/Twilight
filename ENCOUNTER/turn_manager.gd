class_name TurnManager

var context : EncounterContext

enum Phase { PRE_BATTLE, FIGHT_RUN, OPENER, SELECT_COMMAND, SELECT_TARGET, SELECT_SKILL, EXECUTE_COMMAND, WAIT_FOR_BATTLELOG, BATTLE_OVER }

var turn : int = 0
var phase : Phase

func _initialize(ctx : EncounterContext):
	context = ctx
	
func on_move(direction : Vector2i):
	context.menu.on_input(direction)

func on_confirm():
	if phase == Phase.SELECT_TARGET:
		# temporary, do nothing for now and just move to the next party member
		Audio.play_sfx("SE_select", 0.9)
		context.menu.show_menu(MenuState.State.FSST)
		context.party.select_next()
		context.enemies.select_none()
		context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
		phase = Phase.SELECT_COMMAND
	else:
		context.menu.on_input(Vector2i.ZERO)

func start_battle():
	context.menu.show_menu(MenuState.State.FIGHT_RUN)
	show_fight_run_message()
	phase = Phase.FIGHT_RUN

func show_fight_run_message():
	match context.party.members.size():
		1:
			context.battlelog.show_message("What will %s do?" % context.party.members[0].name.to_upper())
		2:
			context.battlelog.show_message("What will %s and %s do?" % [context.party.members[0].name.to_upper(), context.party.members[1].name.to_upper()])
		_:
			context.battlelog.show_message("What will %s and friends do?" % context.party.members[0].name.to_upper())

func on_select_fight():
	context.menu.show_menu(MenuState.State.FSST, true)
	context.party.select_first()
	context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
	phase = Phase.SELECT_COMMAND

func on_select_run():
	# temporary
	context.menu.get_tree().change_scene_to_file("res://ROOMS/a_Menus/InitRoom/startup.tscn")

func on_select_action(index : int):
	context.menu.save_last_selected(context.party.current_selected().data.key)
	match index:
		0:
			context.menu.show_menu(MenuState.State.NONE)
			context.enemies.select_first()
			phase = Phase.SELECT_TARGET
		1: 
			context.menu.show_menu(MenuState.State.SKILL)
		2:
			context.menu.show_menu(MenuState.State.SNACK)
		3:
			context.menu.show_menu(MenuState.State.TOY)

func on_cancel():
	match context.menu.current_state:
		MenuState.State.NONE:
			if phase == Phase.SELECT_TARGET:
				Audio.play_sfx("SE_cancel", 0.9)
				context.menu.show_menu(MenuState.State.FSST)
				context.enemies.select_none()
				phase = Phase.SELECT_COMMAND
		MenuState.State.FSST:
			Audio.play_sfx("SE_cancel", 0.9)
			if context.party.back():
				context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
			else:
				context.menu.show_menu(MenuState.State.FIGHT_RUN, true)
				show_fight_run_message()
				phase = Phase.FIGHT_RUN
		MenuState.State.SKILL, MenuState.State.SNACK, MenuState.State.TOY:
			Audio.play_sfx("SE_cancel", 0.9)
			context.menu.show_menu(MenuState.State.FSST)
			phase = Phase.SELECT_COMMAND
