extends Node

var current_scene: Node = null
var game_path := "res://scenes/game/Game.tscn"
var main_menu_path := "res://scenes/main_menu/Main.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_to_game(lives: int, asteroid_spawn_rate: float, difficulty: String):
	GameData.lives = lives
	GameData.asteroid_spawn_rate = asteroid_spawn_rate
	GameData.difficulty = difficulty
	call_deferred("_deferred_switch_scene", game_path)

func switch_to_main_menu():
	call_deferred("_deferred_switch_scene", main_menu_path)

func _deferred_switch_scene(res_path: String):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
