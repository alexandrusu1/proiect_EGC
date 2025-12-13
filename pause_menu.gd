extends Control

var is_paused = false

@onready var panel: Panel
@onready var resume_button: Button
@onready var restart_button: Button
@onready var main_menu_button: Button
@onready var quit_button: Button

func _ready():
	setup_ui()
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func setup_ui():
	panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.size = Vector2(400, 500)
	panel.position = Vector2(
		get_viewport().get_visible_rect().size.x / 2 - 200,
		get_viewport().get_visible_rect().size.y / 2 - 250
	)
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.position = Vector2(100, 100)
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "PAUSED"
	title.add_theme_font_size_override("font_size", 48)
	vbox.add_child(title)
	
	vbox.add_child(create_spacer(40))
	
	resume_button = Button.new()
	resume_button.text = "Resume"
	resume_button.custom_minimum_size = Vector2(200, 50)
	resume_button.pressed.connect(_on_resume_pressed)
	vbox.add_child(resume_button)
	
	vbox.add_child(create_spacer(20))
	
	restart_button = Button.new()
	restart_button.text = "Restart"
	restart_button.custom_minimum_size = Vector2(200, 50)
	restart_button.pressed.connect(_on_restart_pressed)
	vbox.add_child(restart_button)
	
	vbox.add_child(create_spacer(20))
	
	quit_button = Button.new()
	quit_button.text = "Quit"
	quit_button.custom_minimum_size = Vector2(200, 50)
	quit_button.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_button)

func create_spacer(height: float) -> Control:
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, height)
	return spacer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	visible = is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed():
	toggle_pause()

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()