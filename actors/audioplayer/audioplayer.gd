extends Node

var paddle = preload("res://actors/audioplayer/BallPaddle.wav")
var wall = preload("res://actors/audioplayer/BallWall.wav")
var block = preload("res://actors/audioplayer/BallBlock.wav")
var win = preload("res://actors/audioplayer/win.wav")
var lost = preload("res://actors/audioplayer/lost.wav")

var sfxChannel = AudioServer.get_bus_index("SFX");
var musicChannel = AudioServer.get_bus_index("Music");

enum Sfx { HIT_PADDLE, HIT_WALL, HIT_BLOCK, LOST, WIN }

func play_sfx(effect: Sfx) -> void:
	var stream = null
	match effect:
		Sfx.HIT_PADDLE:
			stream = paddle
		Sfx.HIT_WALL:
			stream = wall
		Sfx.HIT_BLOCK:
			stream = block
		Sfx.LOST:
			stream = lost
		Sfx.WIN:
			stream = win

	var asp = AudioStreamPlayer.new()
	asp.set_bus("SFX")
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()

func set_sfx_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(sfxChannel, linear_to_db(volume))

func set_music_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(musicChannel, linear_to_db(volume))

func get_sfx_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(sfxChannel))

func get_music_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(musicChannel))
