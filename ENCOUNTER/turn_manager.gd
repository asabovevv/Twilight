class_name TurnManager

var context : EncounterContext

enum Phase { PRE_BATTLE, FIGHT_RUN, OPENER, SELECT_COMMAND, SELECT_TARGET, SELECT_SKILL, EXECUTE_COMMAND, WAIT_FOR_BATTLELOG, BATTLE_OVER }

var turn : int = 0
var phase : Phase

const DELAY : float = 1

var _party_commands : Dictionary[int, QueuedAction] = {}
var _pending_action : Action

func _initialize(ctx : EncounterContext):
	context = ctx

func _is_busy() -> bool:
	return phase == Phase.EXECUTE_COMMAND or phase == Phase.WAIT_FOR_BATTLELOG or phase == Phase.BATTLE_OVER

func on_move(direction : Vector2i):
	if _is_busy(): return
	context.menu.on_input(direction)

func on_confirm():
	if _is_busy(): return
	match phase:
		Phase.SELECT_TARGET:
			Audio.play_sfx("SE_select", 0.9)
			_party_commands[context.party.current_selected_index] = QueuedAction.new(
				context.party.current_selected(), _pending_action, context.enemies.current_selected())

			if context.party.current_selected_index >= context.party.members.size() - 1:
				context.enemies.select_none()
				context.party.select_none()
				context.menu.show_menu(MenuState.State.NONE)
				execute_round()
			else:
				context.menu.show_menu(MenuState.State.FSST)
				context.party.select_next()
				context.enemies.select_none()
				context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
				phase = Phase.SELECT_COMMAND
		Phase.FIGHT_RUN, Phase.SELECT_COMMAND:
			context.menu.on_input(Vector2i.ZERO)

func start_battle():
	Audio.play_bgm("battle_pyrefly_forest", 0.5)
	context.menu.show_menu(MenuState.State.FIGHT_RUN)
	show_fight_run_message()
	phase = Phase.FIGHT_RUN

func show_fight_run_message():
	match context.party.members.size():
		1:
			context.battlelog.show_message("What will %s do?" % context.party.get_leader().name.to_upper())
		2:
			context.battlelog.show_message("What will %s and %s do?" % [context.party.get_leader().name.to_upper(), context.party.members[1].name.to_upper()])
		_:
			context.battlelog.show_message("What will %s and friends do?" % context.party.get_leader().name.to_upper())

func on_select_fight():
	context.menu.show_menu(MenuState.State.FSST, true)
	context.party.select_first()
	context.battlelog.show_message("What will %s do?" % context.party.current_selected().name.to_upper())
	phase = Phase.SELECT_COMMAND

func on_select_run():
	# temporary
	context.menu.get_tree().change_scene_to_file("res://ROOMS/a_Menus/InitRoom/startup.tscn")
	Audio.stop_bgm()

func on_select_action(index : int):
	context.menu.save_last_selected(context.party.current_selected().data.key)
	match index:
		0:
			_pending_action = Registry.get_skill("basic_attack")
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
	if _is_busy(): return
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
				_party_commands.clear()
				context.menu.show_menu(MenuState.State.FIGHT_RUN, true)
				show_fight_run_message()
				phase = Phase.FIGHT_RUN
		MenuState.State.SKILL, MenuState.State.SNACK, MenuState.State.TOY:
			Audio.play_sfx("SE_cancel", 0.9)
			context.menu.show_menu(MenuState.State.FSST)
			phase = Phase.SELECT_COMMAND

func execute_round() -> void:
	phase = Phase.EXECUTE_COMMAND
	context.battlelog.clear_battlelog()
	await context.core.wait(1.0)
	# TODO: speed/round_priority ordering
	for i in range(context.party.members.size()):
		if not _party_commands.has(i):
			continue
		await _execute_action(_party_commands[i])
		if _should_end_battle():
			return
		
	for enemy in context.enemies.enemies:
		if enemy.current_health <= 0:
			continue
		var queued : QueuedAction = enemy.process_ai(context)
		if queued == null:
			continue
		await _execute_action(queued)
		if _should_end_battle():
			return
	_start_next_round()

func _execute_action(queued : QueuedAction) -> void:
	if queued.user.current_health <= 0:
		return
	# TODO: retarget if original target is dead
	if queued.target != null and queued.target.current_health <= 0:
		return
	for effect in queued.action.battle_effects:
		await effect.execute(queued.user, queued.target, context)
	phase = Phase.WAIT_FOR_BATTLELOG
	if context.battlelog.processing_message:
		await context.battlelog.finished_logging
	await context.core.wait(DELAY)
	context.battlelog.clear_battlelog()
	phase = Phase.EXECUTE_COMMAND

func _should_end_battle() -> bool:
	if _all_enemies_defeated():
		_end_battle(true)
		return true
	if _party_defeated():
		_end_battle(false)
		return true
	return false

func _all_enemies_defeated() -> bool:
	for e in context.enemies.enemies:
		if e.current_health > 0:
			return false
	return true

func _party_defeated() -> bool:
	for m in context.party.members:
		if m.current_health > 0:
			return false
	return true

func _end_battle(victory : bool) -> void:
	phase = Phase.BATTLE_OVER
	context.menu.show_menu(MenuState.State.NONE)
	context.enemies.select_none()
	if victory:
		Audio.play_bgm("xx_victory", 0.5)
		context.battlelog.queue_message("%s's party was victorious!" % context.party.get_leader().name.to_upper())
	else:
		context.battlelog.queue_message("%s's party was defeated..." % context.party.get_leader().name.to_upper())
	if context.battlelog.processing_message:
		await context.battlelog.finished_logging
	await context.core.wait(10.0)
	Audio.stop_bgm()
	# placeholder exit
	context.core.get_tree().change_scene_to_file("res://ROOMS/a_Menus/InitRoom/startup.tscn")

func _start_next_round() -> void:
	turn += 1
	_party_commands.clear()
	context.party.select_first()
	context.enemies.select_none()
	phase = Phase.SELECT_COMMAND
	context.menu.show_menu(MenuState.State.FSST)
	context.battlelog.clear_and_show_message("What will %s do?" % context.party.current_selected().name.to_upper())
