class_name EncounterState

signal power_changed(value)

var power : int :
	get:
		return power
	set(value):
		power = value
		power_changed.emit(value)
