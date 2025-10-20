extends Control
signal start
signal leaderboard
signal options
signal instuctions

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("escape"):
		_on_quit_pressed()

func _on_start_pressed() -> void:
	start.emit()
	hide()


func _on_leaderboard_pressed() -> void:
	leaderboard.emit()
	hide()


func _on_options_pressed() -> void:
	options.emit()
	hide()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_instructions_pressed() -> void:
	instuctions.emit()
	hide()
