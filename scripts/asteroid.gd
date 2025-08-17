extends RigidBody2D
signal destroyed(position: Vector2, size: Sizes)

@onready var asteroid1 = preload("res://assets/sprites/asteroid_1.svg")
@onready var asteroid2 = preload("res://assets/sprites/asteroid_2.svg")
@onready var asteroid3 = preload("res://assets/sprites/asteroid_3.svg")

enum Sizes {SMALL, MEDIUM, BIG}
var asteroid_size: Sizes

const speed_scale = [1.5, 1, 0.75]
const size_scale = [0.5, 1, 2]

const OG_SPRITE_SCALE = Vector2(0.13, 0.13)

var rotation_direction

func _ready() -> void:
	$Sprite2D.texture = [asteroid1, asteroid2, asteroid3].pick_random()
	var random = randi() % 6
	if random < 3:
		_set_asteroid_size(Sizes.SMALL)
	elif random < 5:
		_set_asteroid_size(Sizes.MEDIUM)
	else:
		_set_asteroid_size(Sizes.BIG)
	
	rotation_direction = [1, -1].pick_random()
	
func _set_asteroid_size(a_size: Sizes):
	asteroid_size = a_size
	$Sprite2D.scale = OG_SPRITE_SCALE * size_scale[asteroid_size]
	$CollisionShape2D.scale = Vector2(size_scale[asteroid_size], size_scale[asteroid_size])
	

func _process(delta: float) -> void:
	$Sprite2D.rotate(speed_scale[asteroid_size] * delta * rotation_direction)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()

func hit():
	emit_signal("destroyed", position, asteroid_size)
	queue_free()
