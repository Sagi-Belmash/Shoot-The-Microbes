extends CanvasLayer
signal start

var can_pause = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await show_message("SHOOT THE ASTEROIDS!")
	await countdown()
	can_pause = true
	start.emit()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and can_pause:
		if get_tree().paused:
			_on_resume()
		else:
			on_pause()


func countdown():
	$Countdown.show()
	for i in range(3):
		$Countdown.text = str(3 - i)
		await get_tree().create_timer(1).timeout
	$Countdown.hide()
	get_tree().paused = false


func on_pause():
	if can_pause:
		$PauseMenu.show()
		get_tree().paused = true


func _on_resume():
	can_pause = false
	$PauseMenu.hide()
	await countdown()
	can_pause = true


func update_score(score: int):
	$ScoreLabel.text = str(score)


func remove_life():
	$Lives.remove_life()
	if $Lives.lives == 0:
		can_pause = false


func game_over(score: int):
	can_pause = false
	await show_message("GAME OVER")
	if GameData.high_score[GameData.difficulty] < score:
		$NewHighScore.set_score(score)
	else:
		SceneSwitcher.switch_to_main_menu()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func show_message(text: String):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	await $MessageTimer.timeout
