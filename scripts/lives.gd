extends Node2D

var lives = 3

func remove_life():
	lives -= 1
	remove_child(get_children()[lives])
