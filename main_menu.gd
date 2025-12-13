extends Control

@onready var panel: Panel
@onready var title_label: Label
@onready var start_button: Button
@onready var settings_button: Button
@onready var quit_button: Button
@onready var best_score_label: Label

func _ready():
	setup_ui()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

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
	
	title_label = Label.new()
	title_label.text = "ESCAPE GAME"
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.add_theme_color_override("font_color", Color(1, 0.5, 0, 1))
	vbox.add_child(title_label)
	
	vbox.add_child(create_spacer(60))
	
	best_score_label = Label.new()
	best_score_label.text = "Best Score: %d" % GameManager.best_score
	best_score_label.add_theme_font_size_override("font_size", 24)
	vbox.add_child(best_score_label)
	
	vbox.add_child(create_spacer(40))
	
	start_button = Button.new()
	start_button.text = "Start Game"
	start_button.custom_minimum_size = Vector2(200, 60)
	start_button.pressed.connect(_on_start_pressed)
	vbox.add_child(start_button)
	
	vbox.add_child(create_spacer(20))
	
	settings_button = Button.new()
	settings_button.text = "Settings"
	settings_button.custom_minimum_size = Vector2(200, 60)
	settings_button.pressed.connect(_on_settings_pressed)
	vbox.add_child(settings_button)
	
	vbox.add_child(create_spacer(20))
	
	quit_button = Button.new()
	quit_button.text = "Quit"
	quit_button.custom_minimum_size = Vector2(200, 60)
	quit_button.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_button)

func create_spacer(height: float) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, height)
	return spacer

func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_settings_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()