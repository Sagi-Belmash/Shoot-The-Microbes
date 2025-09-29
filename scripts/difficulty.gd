extends Control
signal main_menu

@export var game: PackedScene

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		_on_back_pressed()

func _on_back_pressed() -> void:
	main_menu.emit()
	hide()


func _on_easy_pressed() -> void:
	SceneSwitcher.switch_to_game(5, 1.5, "easy")


func _on_medium_pressed() -> void:
	SceneSwitcher.switch_to_game(3, 1, "normal")


func _on_hard_pressed() -> void:
	SceneSwitcher.switch_to_game(1, 0.75, "hard")
