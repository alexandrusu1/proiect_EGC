extends Node3D

@export var enemy_scene: PackedScene
@export var player: Node3D
@export var num_enemies: int = 3
@export var spawn_radius: float = 20.0

func _ready():
	spawn_enemies()

func spawn_enemies():
	if not enemy_scene or not player:
		return
	
	for i in range(num_enemies):
		var enemy = enemy_scene.instantiate()
		add_child(enemy)
		
		var angle = (2.0 * PI / num_enemies) * i
		var spawn_pos = Vector3(
			cos(angle) * spawn_radius,
			1.0,
			sin(angle) * spawn_radius
		)
		
		enemy.global_position = spawn_pos
		enemy.player_target = player
		enemy.add_to_group("enemy")