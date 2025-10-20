extends Node

func _ready() -> void:
	AudioController.play_main()
	GameData.load_leaderboard()
	get_tree().root.size_changed.connect(_update_window)
	_update_window()
	$Leaderboard.load_data()
	

func _update_window():
	var screen_size = get_viewport().size
	var point_offset = 64
	var curve: Curve2D = $EnemyPath.get_curve()
	curve.clear_points()
	curve.add_point(Vector2(-point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, -point_offset))


func _on_enemy_timer_timeout() -> void:
	call_deferred("_spawn_enemy")


func _spawn_enemy():
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	var enemy_pos = enemy_spawn_location.position
	var enemy_dir = enemy_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4)
	
	var enemy := EnemySpawner.get_random_enemy(enemy_pos, enemy_dir)
	add_child(enemy)


func _on_start_pressed() -> void:
	$Difficulty.show()


func _on_main_menu_pressed() -> void:
	$MainMenu.show()


func _on_options_pressed() -> void:
	$Options.show()


func _on_leaderboard_pressed() -> void:
	$Leaderboard.show()


func _on_instructions_pressed() -> void:
	$Instructions.show()
