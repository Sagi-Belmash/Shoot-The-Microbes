extends Node

var lives: int
var asteroid_spawn_rate: float
var difficulty: String
var high_score = {"easy": 0, "normal": 0, "hard": 0}

var easyList: Array
var normalList: Array
var hardList: Array

func sort_score_descending(a, b) -> bool:
	if a["score"] > b["score"]:
		return true
	return false


func load_json_file(filePath: String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			for difficulty in parsedResult:
				parsedResult[difficulty].sort_custom(sort_score_descending)
			easyList = parsedResult["easy"]
			normalList = parsedResult["normal"]
			hardList = parsedResult["hard"]
			if not easyList.is_empty():
				high_score["easy"] = easyList[0]["score"]
			if not normalList.is_empty():
				high_score["normal"] = normalList[0]["score"]
			if not hardList.is_empty():
				high_score["hard"] = hardList[0]["score"]
			print(high_score)
			
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")

func save_json_file(filePath: String):
	pass
