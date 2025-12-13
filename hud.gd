extends CanvasLayer

@onready var stamina_bar: ProgressBar
@onready var health_container: HBoxContainer
@onready var score_label: Label
@onready var timer_label: Label
@onready var dash_indicator: ColorRect
@onready var danger_vignette: ColorRect

var player: CharacterBody3D

func _ready():
	await get_tree().process_frame
	setup_ui()
	connect_signals()
	find_player()

func setup_ui():
	stamina_bar = ProgressBar.new()
	stamina_bar.position = Vector2(20, get_viewport().get_visible_rect().size.y - 60)
	stamina_bar.size = Vector2(200, 20)
	stamina_bar.max_value = 100
	stamina_bar.value = 100
	stamina_bar.show_percentage = false
	add_child(stamina_bar)
	
	var stamina_style = StyleBoxFlat.new()
	stamina_style.bg_color = Color(0, 0, 0, 0.7)
	stamina_bar.add_theme_stylebox_override("background", stamina_style)
	
	var stamina_fill = StyleBoxFlat.new()
	stamina_fill.bg_color = Color(0, 1, 0, 1)
	stamina_bar.add_theme_stylebox_override("fill", stamina_fill)
	
	health_container = HBoxContainer.new()
	health_container.position = Vector2(20, 20)
	add_child(health_container)
	
	for i in range(3):
		var heart = Label.new()
		heart.text = "♥"
		heart.add_theme_font_size_override("font_size", 40)
		heart.add_theme_color_override("font_color", Color(1, 0, 0, 1))
		health_container.add_child(heart)
	
	score_label = Label.new()
	score_label.position = Vector2(get_viewport().get_visible_rect().size.x - 250, 20)
	score_label.text = "SCORE: 1000"
	score_label.add_theme_font_size_override("font_size", 32)
	score_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	add_child(score_label)
	
	timer_label = Label.new()
	timer_label.position = Vector2(get_viewport().get_visible_rect().size.x / 2 - 100, 20)
	timer_label.text = "TIME: 00:00"
	timer_label.add_theme_font_size_override("font_size", 28)
	timer_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	add_child(timer_label)
	
	dash_indicator = ColorRect.new()
	dash_indicator.position = Vector2(get_viewport().get_visible_rect().size.x / 2 - 25, get_viewport().get_visible_rect().size.y / 2 - 25)
	dash_indicator.size = Vector2(50, 50)
	dash_indicator.color = Color(1, 1, 1, 0.3)
	dash_indicator.visible = false
	add_child(dash_indicator)
	
	danger_vignette = ColorRect.new()
	danger_vignette.set_anchors_preset(Control.PRESET_FULL_RECT)
	danger_vignette.color = Color(1, 0, 0, 0)
	danger_vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(danger_vignette)
	move_child(danger_vignette, 0)

func connect_signals():
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)

func find_player():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		var root = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
		player = find_player_recursive(root)

func find_player_recursive(node: Node) -> CharacterBody3D:
	if node is CharacterBody3D and node.has_method("add_stamina"):
		return node
	
	for child in node.get_children():
		var result = find_player_recursive(child)
		if result:
			return result
	
	return null

func _process(delta):
	update_stamina_bar()
	update_timer()
	update_dash_indicator()
	update_danger_vignette()

func update_stamina_bar():
	if player and player.has("stamina"):
		stamina_bar.value = player.stamina
		
		var stamina_percentage = player.stamina / 100.0
		var fill_style = StyleBoxFlat.new()
		
		if stamina_percentage > 0.5:
			fill_style.bg_color = Color(0, 1, 0, 1)
		elif stamina_percentage > 0.25:
			fill_style.bg_color = Color(1, 1, 0, 1)
		else:
			fill_style.bg_color = Color(1, 0, 0, 1)
		
		stamina_bar.add_theme_stylebox_override("fill", fill_style)

func update_timer():
	if GameManager.is_game_active:
		var time = GameManager.game_time
		var minutes = int(time) / 60
		var seconds = int(time) % 60
		timer_label.text = "TIME: %02d:%02d" % [minutes, seconds]

func update_dash_indicator():
	if player and player.has("poate_dash"):
		dash_indicator.visible = not player.poate_dash
		if not player.poate_dash and player.has("dash_timer"):
			var alpha = 1.0 - (player.dash_timer / 2.0)
			dash_indicator.color = Color(1, 1, 1, alpha * 0.5)

func update_danger_vignette():
	var enemy = get_tree().get_first_node_in_group("enemy")
	if player and enemy:
		var distance = player.global_position.distance_to(enemy.global_position)
		var danger_alpha = 0.0
		
		if distance < 5.0:
			danger_alpha = (5.0 - distance) / 5.0 * 0.5
		
		danger_vignette.color = Color(1, 0, 0, danger_alpha)

func _on_score_changed(new_score):
	score_label.text = "SCORE: %d" % new_score

func _on_health_changed(new_health):
	for i in range(health_container.get_child_count()):
		var heart = health_container.get_child(i)
		if i < new_health:
			heart.modulate = Color(1, 1, 1, 1)
		else:
			heart.modulate = Color(0.3, 0.3, 0.3, 1)