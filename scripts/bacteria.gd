extends Enemy


func _process(_delta: float) -> void:
	rotation = linear_velocity.angle() + PI / 2
	enemy_size = Sizes.MEDIUM
