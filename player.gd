extends CharacterBody3D

const VITEZA_NORMALA = 5.0
const VITEZA_SPRINT = 8.0
const VITEZA_DASH = 15.0
const VITEZA_SARITURA = 4.5
const STAMINA_MAX = 100.0
const STAMINA_CONSUM_SPRINT = 20.0
const STAMINA_REGENERARE = 15.0
const DASH_COOLDOWN = 2.0
const SENZITIVITATE = 0.003
const BOBBING_AMPLITUDE = 0.05
const BOBBING_FREQUENCY = 2.0
const FOV_NORMAL = 75.0
const FOV_SPRINT = 85.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var stamina = STAMINA_MAX
var poate_dash = true
var timp_bobbing = 0.0
var viteza_actuala = VITEZA_NORMALA
var dash_timer = 0.0
var camera_initial_y = 0.0

@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_initial_y = camera.position.y
	if camera.fov != FOV_NORMAL:
		camera.fov = FOV_NORMAL
	GameManager.start_game()
	add_to_group("player")

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENZITIVITATE)
		
		camera.rotate_x(-event.relative.y * SENZITIVITATE)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	update_dash_cooldown(delta)
	update_stamina(delta)
	apply_gravity(delta)
	handle_jump_and_dash()
	handle_movement(delta)
	update_camera_effects(delta)
	
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func handle_jump_and_dash():
	var dash_pressed = Input.is_action_just_pressed("dash")
	var sprint_pressed = Input.is_action_pressed("sprint")
	
	if dash_pressed and is_on_floor() and not sprint_pressed:
		velocity.y = VITEZA_SARITURA
	elif dash_pressed and poate_dash and (not is_on_floor() or sprint_pressed):
		perform_dash()

func perform_dash():
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0:
		velocity.x = direction.x * VITEZA_DASH
		velocity.z = direction.z * VITEZA_DASH
		poate_dash = false
		dash_timer = DASH_COOLDOWN

func handle_movement(delta):
	var is_sprinting = Input.is_action_pressed("sprint") and stamina > 0 and is_on_floor()
	
	if is_sprinting:
		viteza_actuala = VITEZA_SPRINT
	else:
		viteza_actuala = VITEZA_NORMALA
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * viteza_actuala
		velocity.z = direction.z * viteza_actuala
	else:
		velocity.x = move_toward(velocity.x, 0, viteza_actuala)
		velocity.z = move_toward(velocity.z, 0, viteza_actuala)

func update_stamina(delta):
	var is_sprinting = Input.is_action_pressed("sprint") and is_on_floor()
	var is_moving = velocity.length() > 0.1
	
	if is_sprinting and is_moving and stamina > 0:
		stamina -= STAMINA_CONSUM_SPRINT * delta
		stamina = max(0, stamina)
	elif stamina < STAMINA_MAX:
		stamina += STAMINA_REGENERARE * delta
		stamina = min(STAMINA_MAX, stamina)

func update_camera_effects(delta):
	var is_moving = velocity.length() > 0.1 and is_on_floor()
	var is_sprinting = Input.is_action_pressed("sprint") and stamina > 0
	
	if is_moving:
		timp_bobbing += delta * BOBBING_FREQUENCY * velocity.length() / VITEZA_NORMALA
		camera.position.y = camera_initial_y + sin(timp_bobbing * 10.0) * BOBBING_AMPLITUDE
	else:
		camera.position.y = lerp(camera.position.y, camera_initial_y, delta * 10.0)
		timp_bobbing = 0.0
	
	var target_fov = FOV_SPRINT if is_sprinting else FOV_NORMAL
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func update_dash_cooldown(delta):
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			poate_dash = true

func add_stamina(amount: float):
	stamina = min(STAMINA_MAX, stamina + amount)
