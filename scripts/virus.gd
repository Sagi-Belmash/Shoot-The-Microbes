extends RigidBody2D

const ROT_SPEED := 0.25;
var ROT_DIR: int;

func _ready() -> void:
	ROT_DIR = [1, -1].pick_random()


func _process(delta: float) -> void:
	$Sprite2D.rotate(delta * ROT_DIR * ROT_SPEED)
