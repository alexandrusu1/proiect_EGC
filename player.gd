extends CharacterBody3D

const VITEZA = 5.0
const VITEZA_SARITURA = 4.5
const SENZITIVITATE = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENZITIVITATE)
		
		camera.rotate_x(-event.relative.y * SENZITIVITATE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = VITEZA_SARITURA

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * VITEZA
		velocity.z = direction.z * VITEZA
	else:
		velocity.x = move_toward(velocity.x, 0, VITEZA)
		velocity.z = move_toward(velocity.z, 0, VITEZA)

	move_and_slide()
