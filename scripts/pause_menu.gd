extends PanelContainer
signal resume


func _on_resume_pressed() -> void:
	resume.emit()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	SceneSwitcher.switch_to_main_menu()


func _on_quit_pressed() -> void:
	get_tree().quit()
