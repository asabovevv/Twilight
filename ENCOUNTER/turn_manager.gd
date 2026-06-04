class_name TurnManager

var context : EncounterContext

func _initialize(ctx : EncounterContext):
	context = ctx

func start_battle():
	context.menu.show_menu(MenuState.State.FIGHT_RUN)
	context.battlelog.show_message("What will AUBREY and friends do?")

func on_select_fight():
	context.menu.show_menu(MenuState.State.FSST, true)
	context.party.select_first()
	context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())

func on_select_run():
	# temporary
	context.menu.get_tree().change_scene_to_file("res://ROOMS/a_Menus/InitRoom/startup.tscn")

func on_select_action(index : int):
	context.menu.save_last_selected(context.party.current_selected().data.key)
	match index:
		0:
			# temporary, always just cycle to the next member
			context.party.select_next()
			context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
		1: 
			context.menu.show_menu(MenuState.State.SKILL)
		2:
			context.menu.show_menu(MenuState.State.SNACK)
		3:
			context.menu.show_menu(MenuState.State.TOY)

func on_cancel():
	match context.menu.current_state:
		MenuState.State.FSST:
			Audio.play_sfx("SE_cancel", 0.9)
			if context.party.back():
				context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
			else:
				context.menu.show_menu(MenuState.State.FIGHT_RUN, true)
				context.battlelog.show_message("What will AUBREY and friends do?")
		MenuState.State.SKILL, MenuState.State.SNACK, MenuState.State.TOY:
			Audio.play_sfx("SE_cancel", 0.9)
			context.menu.show_menu(MenuState.State.FSST)
