extends PanelContainer


func load_data(p_name: String, score: int):
	$VBoxContainer/Name.text = p_name
	$VBoxContainer/Score.text = str(score)
