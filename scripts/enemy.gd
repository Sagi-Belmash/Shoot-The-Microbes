extends Node2D
class_name Enemy
signal destroyed(position: Vector2, enemy_name: String)

@export var virus_scene: PackedScene
@export var bacteria_scene: PackedScene
@export var amoeba_scene: PackedScene

enum Sizes {SMALL, MEDIUM, BIG}
var enemy_size: Sizes
var child : RigidBody2D

const speed_scale = [1.5, 1, 0.75]
const size_scale = [0.5, 1, 2]

const OG_SPRITE_SCALE = Vector2(0.13, 0.13)

var rotation_direction

func _ready() -> void:
	var random = randi() % 6
	if random < 3:
		set_enemy_size(Sizes.SMALL)
	elif random < 5:
		set_enemy_size(Sizes.MEDIUM)
	else:
		set_enemy_size(Sizes.BIG)
	
	rotation_direction = [1, -1].pick_random()
	
func set_enemy_size(e_size: Sizes):
	enemy_size = e_size
	if (enemy_size == Sizes.SMALL):
		child = virus_scene.instantiate()
	elif (enemy_size == Sizes.MEDIUM):
		child = bacteria_scene.instantiate()
	else:
		child = amoeba_scene.instantiate()
	child.connect("body_entered", hit)
	add_child(child)
	
func set_velocity(base_speed: Vector2):
	child.linear_velocity = base_speed * speed_scale[enemy_size]


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()


func hit():
	emit_signal("destroyed", position, enemy_size)
	queue_free()
