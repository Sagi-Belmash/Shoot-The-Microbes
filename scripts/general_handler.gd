extends Node

var last_window_mode
var desired_size = Vector2i(1920, 1080)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DisplayServer.window_set_min_size(desired_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen():
	print(last_window_mode)
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		last_window_mode = DisplayServer.window_get_mode()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(last_window_mode)
