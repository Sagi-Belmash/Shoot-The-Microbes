extends PanelContainer
signal resume

var can_resume = false

func _process(_delta: float) -> void:
	if can_resume and Input.is_action_just_pressed("escape"):
		_on_resume_pressed()

func _on_resume_pressed() -> void:
	resume.emit()
	can_resume = false


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	SceneSwitcher.switch_to_main_menu()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0.1).timeout
		can_resume = true
