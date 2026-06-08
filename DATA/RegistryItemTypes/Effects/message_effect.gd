class_name MessageEffect extends Effect

## Logs a message to the battle log.
## Placeholders [user] and [target] can be used to insert [Actor] names.

var _message : String

func _init(message : String) -> void:
	_message = message

func execute(user : Actor, target : Actor, ctx : EncounterContext) -> void:
	ctx.battlelog.queue_message(_message.replace("[user]", user.name.to_upper()).replace("[target]", target.name.to_upper()))
