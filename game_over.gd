extends Control

@onready var panel: Panel
@onready var final_score_label: Label
@onready var time_label: Label
@onready var collectibles_label: Label
@onready var deaths_label: Label
@onready var retry_button: Button
@onready var main_menu_button: Button

func _ready():
	setup_ui()
	GameManager.game_over.connect(_on_game_over)
	visible = false

func setup_ui():
	panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.size = Vector2(500, 600)
	panel.position = Vector2(
		get_viewport().get_visible_rect().size.x / 2 - 250,
		get_viewport().get_visible_rect().size.y / 2 - 300
	)
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.position = Vector2(50, 50)
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "GAME OVER"
	title.add_theme_font_size_override("font_size", 56)
	title.add_theme_color_override("font_color", Color(1, 0, 0, 1))
	vbox.add_child(title)
	
	vbox.add_child(create_spacer(40))
	
	final_score_label = Label.new()
	final_score_label.text = "Final Score: 0"
	final_score_label.add_theme_font_size_override("font_size", 28)
	vbox.add_child(final_score_label)
	
	vbox.add_child(create_spacer(20))
	
	time_label = Label.new()
	time_label.text = "Time: 00:00"
	time_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(time_label)
	
	vbox.add_child(create_spacer(20))
	
	collectibles_label = Label.new()
	collectibles_label.text = "Collectibles: 0"
	collectibles_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(collectibles_label)
	
	vbox.add_child(create_spacer(20))
	
	deaths_label = Label.new()
	deaths_label.text = "Deaths: 0"
	deaths_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(deaths_label)
	
	vbox.add_child(create_spacer(40))
	
	retry_button = Button.new()
	retry_button.text = "Retry"
	retry_button.custom_minimum_size = Vector2(200, 50)
	retry_button.pressed.connect(_on_retry_pressed)
	vbox.add_child(retry_button)
	
	vbox.add_child(create_spacer(20))
	
	main_menu_button = Button.new()
	main_menu_button.text = "Main Menu"
	main_menu_button.custom_minimum_size = Vector2(200, 50)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	vbox.add_child(main_menu_button)

func create_spacer(height: float) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, height)
	return spacer

func _on_game_over(final_score: int, time: float):
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	final_score_label.text = "Final Score: %d" % final_score
	
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]
	
	collectibles_label.text = "Collectibles: %d" % GameManager.collectibles_taken
	deaths_label.text = "Deaths: %d" % GameManager.deaths

func _on_retry_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().quit()