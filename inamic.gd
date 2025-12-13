extends CharacterBody3D

@export var viteza: float = 2.5
@export var player_target: Node3D 
@export var distanta_de_atac: float = 1.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	var model_intern = get_node_or_null("Running")
	if model_intern:
		model_intern.rotation_degrees.y = 180
	
	var anim_player = find_child("AnimationPlayer", true, false)
	if anim_player:
		var lista_animatii = anim_player.get_animation_list()
		if lista_animatii.size() > 0:
			anim_player.get_animation_library("")
			anim_player.play(lista_animatii[0])

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player_target:
		var target_pos = player_target.global_position
		target_pos.y = global_position.y 
		
		look_at(target_pos, Vector3.UP)
		
		var directie = -transform.basis.z
		velocity.x = directie.x * viteza
		velocity.z = directie.z * viteza
		
		var distanta = global_position.distance_to(player_target.global_position)
		
		if distanta < distanta_de_atac:
			game_over()
	else:
		velocity.x = move_toward(velocity.x, 0, viteza)
		velocity.z = move_toward(velocity.z, 0, viteza)

	move_and_slide()

func game_over():
	print("TE-A PRINS! Game Over.")
	get_tree().reload_current_scene()
