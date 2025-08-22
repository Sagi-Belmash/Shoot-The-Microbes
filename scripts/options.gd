extends Control
signal main_menu

func _process(_delta: float) -> void:
	$Panel/VBoxContainer/FullScreen/FullscreenBtn.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func _on_back_pressed() -> void:
	main_menu.emit()
	hide()


func _on_fullscreen_pressed() -> void:
	GeneralHandler.toggle_fullscreen()


func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
