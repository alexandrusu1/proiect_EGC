extends CharacterBody3D

# --- SETĂRI ---
@export var viteza: float = 2.5
@export var player_target: Node3D 

# Luăm gravitația din setările jocului
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- PORNIRE AUTOMATĂ (Animație) ---
func _ready():
	# Căutăm nodul AnimationPlayer în copiii inamicului
	var anim_player = find_child("AnimationPlayer", true, false)
	
	if anim_player:
		# Luăm lista cu toate animațiile disponibile
		var lista_animatii = anim_player.get_animation_list()
		
		if lista_animatii.size() > 0:
			# Dăm Play la prima animație găsită (de obicei e 'mixamo.com' sau 'Unamed')
			anim_player.play(lista_animatii[0])
			print("A pornit animatia: ", lista_animatii[0])
		else:
			print("ATENTIE: Nu am gasit nicio animatie in AnimationPlayer!")
	else:
		print("ATENTIE: Nu am gasit nodul AnimationPlayer! Verifica daca ai bifat 'Editable Children'.")

# --- FIZICA (Mișcarea) ---
func _physics_process(delta):
	# 1. Aplicăm gravitația
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Urmărirea
	if player_target:
		# Calculăm poziția unde trebuie să se uite (la nivelul ochilor lui, nu sus/jos)
		var target_pos = player_target.global_position
		target_pos.y = global_position.y 
		
		# Se rotește spre jucător
		look_at(target_pos, Vector3.UP)
		
		# 3. Mișcarea în față
		# În Godot, "-transform.basis.z" este direcția "în față" a obiectului
		var directie = -transform.basis.z
		
		velocity.x = directie.x * viteza
		velocity.z = directie.z * viteza
	else:
		# Dacă nu are țintă, se oprește lin
		velocity.x = move_toward(velocity.x, 0, viteza)
		velocity.z = move_toward(velocity.z, 0, viteza)

	move_and_slide()
