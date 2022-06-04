extends Node2D
class_name Paddle


var paddleSize    := Vector2(10.0,100.0)
var paddlePadding := 10.0
#var center: float

var speed := 0.0

func set_start_pos(start_pos):
	start_pos.y = Screen.hScreenSize.y - paddleSize.y/2
	position = start_pos

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, paddleSize), Color.white)
