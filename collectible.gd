extends Area3D

const ROTATION_SPEED = 2.0
const BOBBING_AMPLITUDE = 0.3
const BOBBING_SPEED = 2.0
const SCORE_BONUS = 100
const STAMINA_BONUS = 30.0

var time_passed = 0.0
var initial_y = 0.0

func _ready():
	initial_y = global_position.y
	body_entered.connect(_on_body_entered)
	
	var mesh = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.3
	sphere_mesh.height = 0.6
	mesh.mesh = sphere_mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(1, 0.8, 0, 1)
	material.emission_enabled = true
	material.emission = Color(1, 0.8, 0, 1)
	material.emission_energy_multiplier = 2.0
	material.metallic = 0.8
	material.roughness = 0.2
	mesh.material_override = material
	
	add_child(mesh)
	
	var collision = CollisionShape3D.new()
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = 0.4
	collision.shape = sphere_shape
	add_child(collision)

func _process(delta):
	time_passed += delta
	
	rotate_y(ROTATION_SPEED * delta)
	
	var bobbing_offset = sin(time_passed * BOBBING_SPEED) * BOBBING_AMPLITUDE
	global_position.y = initial_y + bobbing_offset

func _on_body_entered(body):
	if body.has_method("add_stamina"):
		GameManager.collect_item(global_position)
		body.add_stamina(STAMINA_BONUS)
		queue_free()