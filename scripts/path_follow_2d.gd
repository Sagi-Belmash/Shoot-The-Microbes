extends PathFollow2D

const SPEED = 0.2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * SPEED
