extends Node

@export var virus_scene := preload("res://scenes/general/Virus.tscn")
@export var bacteria_scene := preload("res://scenes/general/Bacteria.tscn")
@export var amoeba_scene := preload("res://scenes/general/Amoeba.tscn")
@onready var hit_audio := preload("res://assets/SFX/enemy_hit.mp3")

const ENEMY_BASE_VELOCITY := Vector2(200, 0)

func get_random_enemy(enemy_pos: Vector2, enemy_dir: float) -> Enemy:
	var enemy: Enemy
	var random = randi() % 7
	if random < 1:
		enemy = amoeba_scene.instantiate()
	elif random < 3:
		enemy = bacteria_scene.instantiate()
	else:
		enemy = virus_scene.instantiate()
	
	enemy.linear_velocity = ENEMY_BASE_VELOCITY.rotated(enemy_dir) * enemy.speed_scale[enemy.enemy_size]
	enemy.position = enemy_pos
	enemy.add_child(get_hit_player())
	return enemy

func get_enemy(enemy_size: int, enemy_pos: Vector2) -> Enemy:
	var enemy: Enemy
	match enemy_size:
		0:
			enemy = virus_scene.instantiate()
		1:
			enemy = bacteria_scene.instantiate()
		2:
			enemy = amoeba_scene.instantiate()
	
	enemy.linear_velocity = ENEMY_BASE_VELOCITY.rotated(randf_range(0, 2 * PI)) * enemy.speed_scale[enemy_size]
	enemy.position = enemy_pos
	enemy.add_child(get_hit_player())
	return enemy

func get_hit_player() -> AudioStreamPlayer:
	var hit_player = AudioStreamPlayer.new()
	hit_player.name = "HitPlayer"
	hit_player.stream = hit_audio
	return hit_player
