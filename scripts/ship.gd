extends Area2D
signal hit

var screen_size

const SPEED = 1000
var current_speed = 0
var velocity = Vector2.ZERO
var dead = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

func _physics_process(delta: float) -> void:
	if not dead:
		var direction := Input.get_axis("rotate_left", "rotate_right")
		rotate(direction * 4 / 60)
		
		var degrees = rotation_degrees - 90
		var dirVec = Vector2(cos(deg_to_rad(degrees)), sin(deg_to_rad(degrees)))
		if Input.is_action_pressed("move"):
			current_speed += SPEED * delta
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.stop()
		
		current_speed -= SPEED / 2 * delta
		current_speed = clampf(current_speed, 0, 500)
		velocity = dirVec * current_speed
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionPolygon2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.1).timeout
	z_index = 100
	dead = true
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(2).timeout
	hide()
	
func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false
