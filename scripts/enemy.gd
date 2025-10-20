extends RigidBody2D
class_name Enemy
signal destroyed(position: Vector2, enemy_name: String)

enum Sizes {SMALL, MEDIUM, BIG}
var enemy_size: Sizes

const speed_scale = [1.5, 1, 0.75]


func _ready() -> void:
	var notifier = VisibleOnScreenNotifier2D.new()
	notifier.name = "ScreenNotifier"
	add_child(notifier)
	notifier.screen_exited.connect(_on_screen_exited)


func _on_screen_exited() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()


func hit():
	AudioController.play_enemy_hit()
	emit_signal("destroyed", position, enemy_size)
	queue_free()
