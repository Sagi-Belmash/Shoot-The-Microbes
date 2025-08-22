extends HBoxContainer

var lives := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives = GameData.lives
	for i in range (lives - 1):
		var life_dup = $Life.duplicate()
		life_dup.position = $Life.position + Vector2.RIGHT * 50 * (i + 1)
		add_child(life_dup)


func remove_life():
	lives -= 1
	remove_child(get_children()[lives])
