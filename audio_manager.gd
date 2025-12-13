extends Node

var master_volume: float = 1.0
var sfx_volume: float = 1.0
var music_volume: float = 1.0

var current_music: AudioStreamPlayer = null
var sfx_players: Array[AudioStreamPlayer] = []

func _ready():
	for i in range(10):
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players.append(player)

func play_sfx(sound_name: String, position: Vector3 = Vector3.ZERO):
	var available_player = get_available_sfx_player()
	if available_player:
		available_player.volume_db = linear_to_db(master_volume * sfx_volume)

func play_music(music_name: String, fade_duration: float = 1.0):
	if current_music:
		stop_music(fade_duration)
	
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.volume_db = linear_to_db(master_volume * music_volume)

func stop_music(fade_duration: float = 1.0):
	if current_music:
		var tween = create_tween()
		tween.tween_property(current_music, "volume_db", -80, fade_duration)
		tween.tween_callback(current_music.queue_free)
		current_music = null

func set_master_volume(volume: float):
	master_volume = clamp(volume, 0.0, 1.0)

func get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null
