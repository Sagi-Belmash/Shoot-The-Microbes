extends Node

var lives: int
var enemy_spawn_rate: float
var difficulty: String
var high_score = {"easy": 0, "normal": 0, "hard": 0}
const leaderboard_data_path = "res://data/leaderboard.json"

var leaderboard_data: Dictionary
var easyList: Array
var normalList: Array
var hardList: Array

func sort_score_descending(a, b) -> bool:
	if a["score"] > b["score"]:
		return true
	return false


func load_leaderboard():
	if FileAccess.file_exists(leaderboard_data_path):
		var dataFile = FileAccess.open(leaderboard_data_path, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			leaderboard_data = parsedResult
			for diff in leaderboard_data:
				leaderboard_data[diff].sort_custom(sort_score_descending)
			easyList = leaderboard_data["easy"]
			normalList = leaderboard_data["normal"]
			hardList = leaderboard_data["hard"]
			if not easyList.is_empty():
				high_score["easy"] = easyList[0]["score"]
			if not normalList.is_empty():
				high_score["normal"] = normalList[0]["score"]
			if not hardList.is_empty():
				high_score["hard"] = hardList[0]["score"]
		else:
			print("Error reading file")
		dataFile.close()
	else:
		print("File doesn't exist")

func save_leaderboard(p_name: String, score: int):
	if FileAccess.file_exists(leaderboard_data_path):
		var dataFile = FileAccess.open(leaderboard_data_path, FileAccess.WRITE)
		high_score[difficulty] = score
		leaderboard_data[difficulty].insert(0, {"name": p_name, "score": score})
		easyList = leaderboard_data["easy"]
		normalList = leaderboard_data["normal"]
		hardList = leaderboard_data["hard"]
		dataFile.store_string(JSON.stringify(leaderboard_data))
		dataFile.close()
	else:
		print("File doesn't exist")
