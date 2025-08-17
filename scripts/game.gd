extends Node

@export var asteroid_scene: PackedScene
@export var bullet_scene: PackedScene
var score

var SHOOT_DELAY = 0.3
var can_shoot = true

const base_velocity = Vector2(200, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet = bullet_scene.instantiate()
		bullet.rotation = $Ship.rotation
		bullet.position = $Ship.position + Vector2.from_angle($Ship.rotation - PI / 2) * 50
		
		bullet.linear_velocity = base_velocity.rotated($Ship.rotation - PI / 2)
		
		add_child(bullet)
		can_shoot = false
		await get_tree().create_timer(SHOOT_DELAY).timeout
		can_shoot = true


func game_over() -> void:
	$AsteroidTimer.stop()


func new_game():
	score = 0
	await get_tree().create_timer(1).timeout
	$Ship.start($StartPosition.position)
	$StartTimer.start()


func _on_start_timer_timeout() -> void:
	$AsteroidTimer.start()


func _on_asteroid_timer_timeout() -> void:
	var asteroid = asteroid_scene.instantiate()
	
	var asteroid_spawn_location = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()
	
	asteroid.position = asteroid_spawn_location.position
	
	var direction = asteroid_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	#asteroid.rotation = direction
	
	asteroid.linear_velocity = base_velocity.rotated(direction)
	
	asteroid.connect("destroyed", _on_asteroid_destroyed)
	add_child(asteroid)
	asteroid.linear_velocity *= asteroid.speed_scale[asteroid.asteroid_size]


func _on_asteroid_destroyed(position: Vector2, asteroid_size: int):
	if asteroid_size > 0:
		for i in range(3):
			var asteroid = asteroid_scene.instantiate()
			asteroid.position = position
			asteroid.linear_velocity = base_velocity.rotated(randf_range(0, 2 * PI))
			asteroid.connect("destroyed", _on_asteroid_destroyed)
			add_child(asteroid)
			asteroid._set_asteroid_size(asteroid_size - 1)
			asteroid.linear_velocity *= asteroid.speed_scale[asteroid.asteroid_size]
