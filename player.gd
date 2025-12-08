extends CharacterBody3D

# Setări
const VITEZA = 5.0
const VITEZA_SARITURA = 4.5
const SENZITIVITATE = 0.003

# Luăm gravitația
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Aici facem legătura cu camera
@onready var camera = $Camera3D

func _ready():
	# Când pornește jocul, ascundem cursorul mouse-ului
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Dacă mișcăm mouse-ul și cursorul este capturat (ascuns)
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotim corpul Player-ului stânga-dreapta
		rotate_y(-event.relative.x * SENZITIVITATE)
		
		# Rotim doar camera sus-jos
		camera.rotate_x(-event.relative.y * SENZITIVITATE)
		# Limităm privirea (să nu ne dăm peste cap)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# Dacă apăsăm ESC, eliberăm mouse-ul (ca să putem închide jocul)
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	# 1. Gravitație
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Săritura (Space) - folosește "ui_accept" (care e SPACE implicit)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = VITEZA_SARITURA

	# 3. Mișcare cu setările tale (move_forward, etc.)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * VITEZA
		velocity.z = direction.z * VITEZA
	else:
		velocity.x = move_toward(velocity.x, 0, VITEZA)
		velocity.z = move_toward(velocity.z, 0, VITEZA)

	move_and_slide()
