extends TextureRect

func _ready() -> void:
	pivot_offset = Vector2(size.x / 2, size.y / 2)

func _process(_delta: float) -> void:
	rotation_degrees -= 2
	
