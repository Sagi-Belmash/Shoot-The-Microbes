extends Control

const data_file_path = "res://data/leaderboard.json"

var score

func set_score(new_score: int):
	score = new_score
	$Panel/VBoxContainer/HighScoreLabel.text.replace("?", str(score))
	show()

func _on_submit_pressed() -> void:
	GameData.high_score[GameData.difficulty] = score
	
	SceneSwitcher.switch_to_main_menu()


func _on_cancel_pressed() -> void:
	SceneSwitcher.switch_to_main_menu()
