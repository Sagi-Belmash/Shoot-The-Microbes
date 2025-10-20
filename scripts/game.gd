extends Node
@export var bullet_scene: PackedScene
#@export var powerup_scene: PackedScene

var score := 0

var SHOOT_DELAY := 0.3

const BULLET_VELOCITY := Vector2(400,0)

var triple_shot := false

@onready var nanobot: Nanobot = $Nanobot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioController.play_game()
	get_tree().root.size_changed.connect(_update_window)
	_update_window()
	get_tree().root.focus_exited.connect($HUD.on_pause)
	$EnemyTimer.wait_time *= GameData.enemy_spawn_rate


func _update_window():
	var screen_size = get_viewport().get_visible_rect().size
	$StartPosition.position = screen_size / 2
	var point_offset = 64
	var curve = $EnemyPath.get_curve()
	curve.add_point(Vector2(-point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, -point_offset))


func _on_start():
	nanobot.start($StartPosition.position)
	$StartTimer.start()
	if not get_tree().root.has_focus():
		$HUD.on_pause()


func _on_start_timer_timeout() -> void:
	$EnemyTimer.start()


func _on_enemy_timer_timeout() -> void:
	call_deferred("_spawn_enemy")


func _spawn_enemy():
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	var enemy_pos = enemy_spawn_location.position
	var enemy_dir = enemy_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4)
	
	var enemy := EnemySpawner.get_random_enemy(enemy_pos, enemy_dir)
	enemy.connect("destroyed", _on_enemy_destroyed) 
	add_child(enemy)


func _on_enemy_destroyed(enemy_pos: Vector2, enemy_size: int):
	if enemy_size > 0:
		if enemy_size == 2:
			score += 20
			#call_deferred("_spawn_powerup", enemy_pos)
		else:
			score += 10
		for i in range(3):
			call_deferred("_create_enemy_child", enemy_pos, enemy_size - 1)
	else:
		score += 5
	$HUD.update_score(score)


func _create_enemy_child(enemy_pos: Vector2, enemy_size: int):
	var enemy: Enemy
	enemy = EnemySpawner.get_enemy(enemy_size, enemy_pos)
	enemy.connect("destroyed", _on_enemy_destroyed)
	add_child(enemy)


#func _spawn_powerup(position: Vector2):
	#var powerup = powerup_scene.instantiate()
	#powerup.position = position
	#powerup.connect("powerup_taken", _on_powerup_taken)
	#add_child(powerup)


#func _on_powerup_taken(powerup_type: Powerup.Powerup_Types):
	#if powerup_type == Powerup.Powerup_Types.EXTRA_LIFE:
		#GameData.lives += 1
		#$HUD.add_life()
	#elif powerup_type == Powerup.Powerup_Types.TRIPLE_SHOT:
		#triple_shot = true
		#await get_tree().create_timer(5).timeout
		#triple_shot = false
	#elif powerup_type == Powerup.Powerup_Types.SLOW_TIME:
		#pass
	#elif powerup_type == Powerup.Powerup_Types.SHIELD:
		#pass


func _on_nanobot_hit() -> void:
	$HUD.remove_life()


func _on_game_over() -> void:
	$EnemyTimer.stop()
	$HUD.game_over(score)


func _on_nanobot_shoot():
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.rotation = nanobot.rotation
	bullet.position = nanobot.position + Vector2.from_angle(nanobot.rotation - PI / 2) * 50
	bullet.linear_velocity = BULLET_VELOCITY.rotated(nanobot.rotation - PI / 2)
	add_child(bullet)
	if triple_shot:
		var extra_bullet_1: Bullet = bullet_scene.instantiate()
		var extra_bullet_2: Bullet = bullet_scene.instantiate()
		extra_bullet_1.rotation = nanobot.rotation + PI / 4
		extra_bullet_2.rotation = nanobot.rotation - PI / 4
		extra_bullet_1.position = bullet.position
		extra_bullet_2.position = bullet.position
		extra_bullet_1.linear_velocity = BULLET_VELOCITY.rotated(nanobot.rotation - PI / 2 + PI /4)
		extra_bullet_2.linear_velocity = BULLET_VELOCITY.rotated(nanobot.rotation - PI / 2 - PI /4)
		add_child(extra_bullet_1)
		add_child(extra_bullet_2)
		
		
