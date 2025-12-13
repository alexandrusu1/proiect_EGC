extends Node

signal score_changed(new_score)
signal health_changed(new_health)
signal collectible_taken(position)
signal game_over(final_score, time)
signal level_complete(score, time)

var score: int = 1000
var health: int = 3
var collectibles_taken: int = 0
var game_time: float = 0.0
var is_game_active: bool = false
var deaths: int = 0
var best_time: float = 0.0
var best_score: int = 0

func _ready():
	load_best_stats()

func _process(delta):
	if is_game_active:
		game_time += delta
		score = max(0, score - int(delta))
		score_changed.emit(score)

func start_game():
	score = 1000
	health = 3
	collectibles_taken = 0
	game_time = 0.0
	deaths = 0
	is_game_active = true
	score_changed.emit(score)
	health_changed.emit(health)

func collect_item(pos: Vector3):
	score += 100
	collectibles_taken += 1
	collectible_taken.emit(pos)
	score_changed.emit(score)

func take_damage():
	health -= 1
	deaths += 1
	health_changed.emit(health)
	
	if health <= 0:
		end_game()
	else:
		score = max(0, score - 200)
		score_changed.emit(score)

func end_game():
	is_game_active = false
	
	if score > best_score:
		best_score = score
	if game_time > best_time:
		best_time = game_time
	
	save_best_stats()
	game_over.emit(score, game_time)

func complete_level():
	is_game_active = false
	
	if score > best_score:
		best_score = score
	if game_time > best_time:
		best_time = game_time
		
	save_best_stats()
	level_complete.emit(score, game_time)

func save_best_stats():
	var save_data = {
		"best_score": best_score,
		"best_time": best_time
	}
	var file = FileAccess.open("user://game_stats.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

func load_best_stats():
	if FileAccess.file_exists("user://game_stats.json"):
		var file = FileAccess.open("user://game_stats.json", FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var data = json.data
				best_score = data.get("best_score", 0)
				best_time = data.get("best_time", 0.0)
