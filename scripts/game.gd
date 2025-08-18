extends Node

@export var asteroid_scene: PackedScene
@export var bullet_scene: PackedScene
var score

var SHOOT_DELAY = 0.3
var can_shoot = true

const ASTEROID_BASE_VELOCITY = Vector2(200, 0)
const BULLET_VELOCITY = Vector2(400,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	var screen_size = get_viewport().size
	$StartPosition.position = screen_size / 2
	
	# Setting Asteroid Path's points
	var point_offset = 64
	var curve = $AsteroidPath.get_curve()
	curve.add_point(Vector2(-point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, -point_offset))
	curve.add_point(Vector2(screen_size.x + point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, screen_size.y + point_offset))
	curve.add_point(Vector2(-point_offset, -point_offset))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()


func new_game():
	score = 0
	await get_tree().create_timer(1).timeout
	$Ship.start($StartPosition.position)
	$StartTimer.start()


func pause():
	print("pause")

func _on_start_timer_timeout() -> void:
	$AsteroidTimer.start()


func _on_asteroid_timer_timeout() -> void:
	call_deferred("_spawn_asteroid")


func _spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	asteroid.position = asteroid_spawn_location.position
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	#asteroid.rotation = direction
	
	asteroid.linear_velocity = ASTEROID_BASE_VELOCITY.rotated(direction)
	
	asteroid.connect("destroyed", _on_asteroid_destroyed)
	add_child(asteroid)
	asteroid.linear_velocity *= asteroid.speed_scale[asteroid.asteroid_size]



func _on_asteroid_destroyed(position: Vector2, asteroid_size: int):
	if asteroid_size > 0:
		for i in range(3):
			call_deferred("_create_asteroid_child", position, asteroid_size - 1)


func _create_asteroid_child(position: Vector2, asteroid_size: int):
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = position
	asteroid.linear_velocity = ASTEROID_BASE_VELOCITY.rotated(randf_range(0, 2 * PI))
	asteroid.connect("destroyed", _on_asteroid_destroyed)
	add_child(asteroid)
	asteroid._set_asteroid_size(asteroid_size)
	asteroid.linear_velocity *= asteroid.speed_scale[asteroid_size]



func _on_ship_hit() -> void:
	$Lives.remove_life()
	if $Lives.lives > 0:
		$Ship.ship_hit()
	else:
		$AsteroidTimer.stop()
		$Ship.game_over()


func _on_ship_shoot():
	var bullet = bullet_scene.instantiate()
	bullet.rotation = $Ship.rotation
	bullet.position = $Ship.position + Vector2.from_angle($Ship.rotation - PI / 2) * 50
	
	bullet.linear_velocity = BULLET_VELOCITY.rotated($Ship.rotation - PI / 2)
	
	add_child(bullet)
