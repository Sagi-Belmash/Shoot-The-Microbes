extends Control
signal main_menu

@onready var instruction_container = $InstructionContainer
@onready var instruction_buttons = $InstructionButtons
@onready var bullet_path : Path2D = $InstructionContainer/Shooting/BulletPath
@onready var bullet_img = preload("res://assets/sprites/bullet.svg")

var current_instruction := 0


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		_on_back_pressed()
		
	for follow in bullet_path.get_children():
		if follow is PathFollow2D:
			follow.progress_ratio += 0.01


func _on_back_pressed():
	hide()
	main_menu.emit()	


func _change_instruction(instruction_num: int) -> void:
	instruction_container.get_children()[current_instruction].hide()
	current_instruction = instruction_num
	instruction_container.get_children()[current_instruction].show()


func _next_instruction(direction: int) -> void:
	instruction_buttons.get_children()[(current_instruction + direction + 3) % 3].button_pressed = true
	instruction_buttons.get_children()[(current_instruction + direction + 3) % 3].pressed.emit()


func _on_visibility_changed() -> void:
	if visible:
		instruction_buttons.get_children()[0].button_pressed = true
		instruction_buttons.get_children()[0].pressed.emit()
