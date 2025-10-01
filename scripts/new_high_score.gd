extends Control

var score
@onready var highscore_label: Label = $Panel/VBoxContainer/HighScoreLabel
@onready var name_edit: LineEdit = $Panel/VBoxContainer/Name/NameEdit

func _process(_delta: float) -> void:
	if visible:
		if Input.is_action_just_pressed("escape"):
			_on_cancel_pressed()
		if Input.is_action_just_pressed("submit"):
			_on_submit_pressed()

func set_score(new_score: int):
	score = new_score
	highscore_label.text = highscore_label.text.replace("?", str(score))
	show()

func _on_submit_pressed() -> void:
	var p_name := name_edit.text
	if not p_name.is_empty():
		GameData.save_leaderboard(p_name, score)
		SceneSwitcher.switch_to_main_menu()


func _on_cancel_pressed() -> void:
	SceneSwitcher.switch_to_main_menu()


func _on_name_edit_focus_entered() -> void:
	GeneralHandler.is_typing = true


func _on_name_edit_focus_exited() -> void:
	GeneralHandler.is_typing = false
