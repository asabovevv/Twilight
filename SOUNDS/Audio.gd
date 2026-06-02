extends Node

##
## Mediates audio using preallocated audio streams
##

## The number of sfx players to preallocate
@export var sfx_players : int = 10
## Whether to allow duplicate sounds to play at the same time instead of cutting off
@export var allow_duplicate_sounds : bool = false

var bgm : AudioStreamPlayer
var sfx : Array[AudioStreamPlayer]

var loaded_bgm: Dictionary[String, AudioStreamOggVorbis] = {}
var loaded_sfx: Dictionary[String, AudioStreamOggVorbis] = {}
## TODO: currently, this uses the stream.resource_path as a key, which works but bothers me for some reason. look into improving at some point
var active_sounds: Dictionary[String, AudioStreamPlayer] = {}

func _ready() -> void:
	bgm = AudioStreamPlayer.new()
	bgm.bus = "BGM"
	add_child(bgm)
	
	for i in range(sfx_players):
		var new_sfx = AudioStreamPlayer.new()
		new_sfx.bus = "SFX"
		new_sfx.finished.connect(_on_sfx_finished.bind(new_sfx))
		sfx.append(new_sfx)
		add_child(new_sfx)

func _on_sfx_finished(player: AudioStreamPlayer) -> void:
	# reset any pitch or volume changes
	player.pitch_scale = 1.0
	player.volume_linear = 1.0
	active_sounds.erase(player.stream.resource_path)

## Plays the given SFX [param name].
##
## Also accepts optional [param volume] and [param pitch] values, both of which default to 1.
func play_sfx(name : String, volume : float = 1, pitch : float = 1) -> void:
	var stream = loaded_sfx.get(name)
	if !stream:
		# TODO: change this path if necessary
		stream = load("res://SOUNDS/SoundEffect/%s.ogg" % name)
		if !stream:
			printerr("Unknown SFX: %s" % name)
			return
		loaded_sfx[name] = stream
	
	if !allow_duplicate_sounds:
		var existing = active_sounds.get(stream.resource_path)
		if existing:
			existing.stream = stream
			existing.pitch_scale = pitch
			existing.volume_linear = volume
			existing.play()
			return
	
	for player in sfx:
		if player.playing:
			continue
		player.stream = stream
		player.pitch_scale = pitch
		player.volume_linear = volume
		player.play()
		active_sounds[stream.resource_path] = player
		return
		
	push_warning("SFX overloaded!")

## Plays the given BGM [param name].
##
## Also accepts optional [param volume] and [param pitch] values, both of which default to 1.
func play_bgm(name : String, volume : float = 1, pitch : float = 1) -> void:
	var stream = loaded_bgm.get(name)
	if !stream:
		# TODO: change this path if necessary
		stream = load("res://SOUNDS/AmbientMusic/%s.ogg" % name)
		if !stream:
			printerr("Unknown BGM: %s" % name)
			return
		loaded_bgm[name] = stream

	bgm.stream = stream
	bgm.pitch_scale = pitch
	bgm.volume_linear = volume
	bgm.play()
	
## Stops the currently playing BGM.
func stop_bgm() -> void:
	bgm.stop()

## Stops all currently playing BGM and SFX and resets all players to their default values.
func reset() -> void:
	active_sounds.clear()
	stop_bgm()
	bgm.pitch_scale = 1.0
	bgm.volume_linear = 1.0
	for player in sfx:
		player.stop()
		player.stream = null
		player.pitch_scale = 1.0
		player.volume_linear = 1.0
