extends Node
@export var asteroid_scene : PackedScene

const ASTEROID_BASE_VELOCITY = Vector2(200, 0)



func _ready() -> void:
	GameData.load_leaderboard()
	get_tree().root.size_changed.connect(_update_window)
	_update_window()
	$Leaderboard.load_data()
	

func _update_window():
	var screen_size = get_viewport().size
	var point_offset = 64
	var curve: Curve2D = $AsteroidPath.get_curve()
	curve.clear_points()
	curve.add_point(Vector2(-point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, -point_offset))


func _on_asteroid_timer_timeout() -> void:
	call_deferred("_spawn_asteroid")


func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	asteroid.position = asteroid_spawn_location.position
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	
	asteroid.linear_velocity = ASTEROID_BASE_VELOCITY.rotated(direction)
	
	add_child(asteroid)
	asteroid.linear_velocity *= asteroid.speed_scale[asteroid.asteroid_size]


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
