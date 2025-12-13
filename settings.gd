extends Node

var settings = {
	"master_volume": 1.0,
	"sfx_volume": 1.0,
	"music_volume": 1.0,
	"mouse_sensitivity": 0.003,
	"graphics_quality": "medium"
}

const SETTINGS_PATH = "user://settings.json"

func _ready():
	load_settings()

func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings))
		file.close()

func load_settings():
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				settings = json.data

func set_setting(key: String, value):
	settings[key] = value
	save_settings()

func get_setting(key: String):
	return settings.get(key)