extends Enemy


const ROT_SPEED := 0.25;
var ROT_DIR: int;

func _ready() -> void:
	ROT_DIR = [1, -1].pick_random()
	enemy_size = Sizes.SMALL


func _process(delta: float) -> void:
	$Sprite2D.rotate(delta * ROT_DIR * ROT_SPEED)
