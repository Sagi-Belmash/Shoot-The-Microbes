extends PanelContainer
signal start
signal leaderboard
signal options

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
