extends CharacterBody3D

enum State { PATROL, ALERT, CHASE, ATTACK }

@export var player_target: Node3D 
@export var distanta_de_atac: float = 1.5

const VITEZA_PATROL = 1.5
const VITEZA_ALERT = 2.5
const VITEZA_CHASE = 3.5
const VITEZA_ATTACK = 4.0
const RAZA_DETECTARE_ALERT = 15.0
const RAZA_DETECTARE_CHASE = 10.0
const RAZA_ATAC = 2.0
const TIMP_SCHIMBARE_DIRECTIE = 3.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_state: State = State.PATROL
var viteza_curenta: float = VITEZA_PATROL
var patrol_point = Vector3.ZERO
var timp_schimbare_directie = 0.0
var initial_position = Vector3.ZERO
var material_original: Material = null
var material_alert: StandardMaterial3D = null

@onready var mesh_instance = find_child("MeshInstance3D", true, false)

func _ready():
	initial_position = global_position
	generate_new_patrol_point()
	setup_materials()
	
	var model_intern = get_node_or_null("Running")
	if model_intern:
		model_intern.rotation_degrees.y = 180
	
	var anim_player = find_child("AnimationPlayer", true, false)
	if anim_player:
		var lista_animatii = anim_player.get_animation_list()
		if lista_animatii.size() > 0:
			anim_player.get_animation_library("")
			anim_player.play(lista_animatii[0])

func setup_materials():
	material_alert = StandardMaterial3D.new()
	material_alert.albedo_color = Color(1.0, 0.0, 0.0, 1.0)
	material_alert.emission_enabled = true
	material_alert.emission = Color(1.0, 0.0, 0.0, 1.0)
	material_alert.emission_energy_multiplier = 0.5

func _physics_process(delta):
	apply_gravity(delta)
	update_state()
	execute_state_behavior(delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func update_state():
	if not player_target:
		return
	
	var distance_to_player = global_position.distance_to(player_target.global_position)
	var has_line_of_sight = check_line_of_sight()
	
	if distance_to_player <= RAZA_ATAC:
		change_state(State.ATTACK)
	elif distance_to_player <= RAZA_DETECTARE_CHASE and has_line_of_sight:
		change_state(State.CHASE)
	elif distance_to_player <= RAZA_DETECTARE_ALERT and has_line_of_sight:
		change_state(State.ALERT)
	else:
		change_state(State.PATROL)

func change_state(new_state: State):
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.PATROL:
			viteza_curenta = VITEZA_PATROL
			set_alert_visual(false)
		State.ALERT:
			viteza_curenta = VITEZA_ALERT
			set_alert_visual(true)
		State.CHASE:
			viteza_curenta = VITEZA_CHASE
			set_alert_visual(true)
		State.ATTACK:
			viteza_curenta = VITEZA_ATTACK
			set_alert_visual(true)

func execute_state_behavior(delta):
	match current_state:
		State.PATROL:
			patrol_behavior(delta)
		State.ALERT:
			alert_behavior()
		State.CHASE:
			chase_behavior()
		State.ATTACK:
			attack_behavior()

func patrol_behavior(delta):
	timp_schimbare_directie += delta
	
	if timp_schimbare_directie >= TIMP_SCHIMBARE_DIRECTIE:
		generate_new_patrol_point()
		timp_schimbare_directie = 0.0
	
	move_to_position(patrol_point)

func alert_behavior():
	if player_target:
		var target_pos = player_target.global_position
		target_pos.y = global_position.y
		look_at(target_pos, Vector3.UP)
		
		var directie = -transform.basis.z
		velocity.x = directie.x * viteza_curenta
		velocity.z = directie.z * viteza_curenta

func chase_behavior():
	if player_target:
		var target_pos = player_target.global_position
		target_pos.y = global_position.y
		look_at(target_pos, Vector3.UP)
		
		var directie = -transform.basis.z
		velocity.x = directie.x * viteza_curenta
		velocity.z = directie.z * viteza_curenta

func attack_behavior():
	if player_target:
		var distanta = global_position.distance_to(player_target.global_position)
		
		if distanta < distanta_de_atac:
			game_over()
		else:
			chase_behavior()

func move_to_position(target_pos: Vector3):
	var direction_to_target = (target_pos - global_position).normalized()
	direction_to_target.y = 0
	
	if direction_to_target.length() > 0.1:
		var target_rotation = Vector3(global_position.x + direction_to_target.x, global_position.y, global_position.z + direction_to_target.z)
		look_at(target_rotation, Vector3.UP)
		
		velocity.x = direction_to_target.x * viteza_curenta
		velocity.z = direction_to_target.z * viteza_curenta
	else:
		velocity.x = move_toward(velocity.x, 0, viteza_curenta)
		velocity.z = move_toward(velocity.z, 0, viteza_curenta)

func generate_new_patrol_point():
	var random_offset = Vector3(
		randf_range(-10.0, 10.0),
		0,
		randf_range(-10.0, 10.0)
	)
	patrol_point = initial_position + random_offset

func check_line_of_sight() -> bool:
	if not player_target:
		return false
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position + Vector3(0, 1, 0),
		player_target.global_position + Vector3(0, 1, 0)
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		return result.collider == player_target
	return true

func set_alert_visual(is_alert: bool):
	if mesh_instance and material_alert:
		if is_alert:
			mesh_instance.set_surface_override_material(0, material_alert)
		else:
			mesh_instance.set_surface_override_material(0, null)

func game_over():
	print("TE-A PRINS! Game Over.")
	GameManager.take_damage()
	
	if GameManager.health <= 0:
		get_tree().reload_current_scene()
	else:
		reset_player_position()

func reset_player_position():
	if player_target:
		player_target.global_position = Vector3(0, 2, 0)
		player_target.velocity = Vector3.ZERO
