extends Node

func play_main():
	$GameBGMusic.stop()
	$MainBGMusic.play()


func play_game():
	$MainBGMusic.stop()
	$GameBGMusic.play()


func play_player_hit():
	$PlayerHitSound.play()


func play_enemy_hit():
	$EnemyHitSound.play()


func play_player_shoot():
	$PlayerShootSound.play()


func play_player_explosion():
	$PlayerExplosionSound.play()
