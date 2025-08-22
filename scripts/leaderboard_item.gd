extends PanelContainer


func load_data(name: String, score: int):
	$VBoxContainer/Name.text = name
	$VBoxContainer/Score.text = str(score)
