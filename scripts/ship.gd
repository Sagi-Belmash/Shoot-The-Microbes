extends Area2D
signal shoot
signal hit
signal game_over

var screen_size

const SPEED = 1000
var current_speed = 0
var dead = false

const SHOOT_DELAY = 0.3
var can_shoot = true

var inviciblity_frames = 5

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _physics_process(delta: float) -> void:
	if is_visible_in_tree() and not dead:
		# Shoot handling
		if Input.is_action_pressed("shoot") and can_shoot:
			shoot.emit()
			can_shoot = false
			await get_tree().create_timer(SHOOT_DELAY).timeout
			can_shoot = true
		
		# Rotate handling
		var direction := Input.get_axis("rotate_left", "rotate_right")
		rotate(direction * 4 / 60)
		
		# Move handling
		var degrees = rotation_degrees - 90
		var dirVec = Vector2(cos(deg_to_rad(degrees)), sin(deg_to_rad(degrees)))
		if Input.is_action_pressed("move"):
			current_speed += SPEED * delta
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.stop()
		
			@warning_ignore("integer_division")
			current_speed -= SPEED / 4 * delta
		current_speed = clampf(current_speed, 0, 500)
		position += dirVec * current_speed * delta
		position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(_body: Node2D) -> void:
	hit.emit()
	GameData.lives -= 1
	if GameData.lives == 0:
		death()
	else:
		$CollisionPolygon2D.set_deferred("disabled", true)
		for i in range(inviciblity_frames):
			modulate.a = 0
			await get_tree().create_timer(0.1).timeout
			modulate.a = 1
			await get_tree().create_timer(0.1).timeout
		$CollisionPolygon2D.set_deferred("disabled", false)


func death():
	$CollisionPolygon2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	z_index = 100
	dead = true
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(2).timeout
	hide()
	game_over.emit()


func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
