extends Enemy


func _ready() -> void:
	rotation = randf_range(1, 2 * PI)
	enemy_size = Sizes.BIG
