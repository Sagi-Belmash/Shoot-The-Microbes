extends Area2D
class_name Powerup
signal powerup_taken(poweup_type: Powerup_Types)

@onready var extra_life_img = preload("res://assets/sprites/nanobot.svg")
@onready var triple_shot_img = preload("res://assets/sprites/nanobot.svg")
@onready var slow_time_img = preload("res://assets/sprites/nanobot.svg")
@onready var shield_img = preload("res://assets/sprites/nanobot.svg")

enum Powerup_Types {EXTRA_LIFE, TRIPLE_SHOT, SLOW_TIME, SHIELD}

var type = randi() % Powerup_Types.size()

func _ready() -> void:
	if type == Powerup_Types.EXTRA_LIFE:
		$Icon.texture = extra_life_img
	elif type == Powerup_Types.TRIPLE_SHOT:
		$Icon.texture = triple_shot_img
	elif type == Powerup_Types.SLOW_TIME:
		$Icon.texture = slow_time_img
	elif type == Powerup_Types.SHIELD:
		$Icon.texture = shield_img

func _on_area_entered(area: Area2D) -> void:
	if area is Nanobot:
		emit_signal("powerup_taken", Powerup_Types.EXTRA_LIFE)
		queue_free()
