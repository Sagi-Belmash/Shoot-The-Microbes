extends Area2D
class_name Nanobot

signal shoot
signal hit
signal game_over

var screen_size: Vector2

const SPEED := 20.0
var velocity := Vector2.ZERO
const MAX_VELOCITY := Vector2(50,50)
var dead := false

const SHOOT_DELAY = 0.3
var can_shoot = true

var inviciblity_frames = 5

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _physics_process(delta: float) -> void:
	var x_speed: float
	var y_speed: float
	if is_visible_in_tree() and not dead:
		# Shoot handling
		if Input.is_action_pressed("shoot") and can_shoot:
			AudioController.play_player_shoot()
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
			velocity += SPEED * delta * dirVec
			velocity = velocity.clamp(-MAX_VELOCITY, MAX_VELOCITY)
		else:
			if velocity.x != 0:
				x_speed = max(0, abs(velocity.x) - SPEED / 4 * delta)
				velocity.x = velocity.x / abs(velocity.x) * x_speed
			if velocity.y != 0:
				y_speed = max(0, abs(velocity.y) - SPEED / 4 * delta)
				velocity.y = velocity.y / abs(velocity.y) * y_speed
		position += velocity
		position = position.clamp(Vector2.ZERO, screen_size)
		
		if position.x == 0 or position.x == screen_size.x:
			velocity.x = 0
		if position.y == 0 or position.y == screen_size.y:
			velocity.y = 0


func _on_body_entered(_body: Node2D) -> void:
	hit.emit()
	GameData.lives -= 1
	if GameData.lives == 0:
		death()
	else:
		AudioController.play_player_hit()
		$CollisionShape2D.set_deferred("disabled", true)
		for i in range(inviciblity_frames):
			modulate.a = 0
			await get_tree().create_timer(0.1).timeout
			modulate.a = 1
			await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", false)


func death():
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	z_index = 100
	dead = true
	AudioController.play_player_explosion()
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(2).timeout
	hide()
	game_over.emit()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
