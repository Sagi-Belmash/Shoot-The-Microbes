extends Control
@export var LBItem : PackedScene

const data_file_path = "res://data/leaderboard.json"




func load_data() -> void:
	GameData.load_json_file(data_file_path)
	for i in range(GameData.easyList.size()):
		var item = LBItem.instantiate()
		item.load_data(str(i + 1) + "." + GameData.easyList[i]["name"], GameData.easyList[i]["score"])
		$Panel/TabContainer/Easy/VBoxContainer.add_child(item)
	for i in range(GameData.normalList.size()):
		var item = LBItem.instantiate()
		item.load_data(str(i + 1) + "." + GameData.normalList[i]["name"], GameData.normalList[i]["score"])
		$Panel/TabContainer/Normal/VBoxContainer.add_child(item)
	for i in range(GameData.hardList.size()):
		var item = LBItem.instantiate()
		item.load_data(str(i + 1) + "." + GameData.hardList[i]["name"], GameData.hardList[i]["score"])
		$Panel/TabContainer/Hard/VBoxContainer.add_child(item)
