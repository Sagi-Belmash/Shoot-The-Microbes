extends Control
@export var LBItem : PackedScene
signal main_menu

@onready var easy_container := $Panel/TabContainer/Easy/VBoxContainer
@onready var normal_container := $Panel/TabContainer/Normal/VBoxContainer
@onready var hard_container := $Panel/TabContainer/Hard/VBoxContainer

const MAX_NAME_LENGTH = 10

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		_on_back_pressed()

func load_data() -> void:
	_fill_leaderboard_list(easy_container, GameData.easyList)
	_fill_leaderboard_list(normal_container, GameData.normalList)
	_fill_leaderboard_list(hard_container, GameData.hardList)


func _fill_leaderboard_list(DiffContainer: VBoxContainer, list: Array):
	var p_name: String
	var score: int
	for i in range(list.size()):
		var item = LBItem.instantiate()
		score = list[i]["score"]
		p_name = list[i]["name"]
		if p_name.length() > MAX_NAME_LENGTH:
			p_name = p_name.substr(0, MAX_NAME_LENGTH) + "..."
		item.load_data(str(i + 1) + ".  " + p_name, score)
		DiffContainer.add_child(item)


func _on_back_pressed() -> void:
	main_menu.emit()
	hide()
