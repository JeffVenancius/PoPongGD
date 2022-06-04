extends Node

var screenSize:  Vector2
var hScreenSize: Vector2

func get_screen(screen: Vector2) -> void:
	screenSize = screen
	hScreenSize = screen/2

func update_screen():
	get_screen(get_tree().get_root().size)
