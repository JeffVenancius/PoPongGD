extends Node2D
class_name Paddle


var paddleSize    := Vector2(10.0,100.0)
var paddlePadding := 10.0

var speed := 0.0
var maxMagnitude := 3.0
var maxRotation  := 89.0


func set_start_pos(start_pos):
	start_pos.y = Screen.hScreenSize.y - paddleSize.y/2
	position = start_pos

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, paddleSize), Color.white)

func changeBallDirection(ball: Ball) -> void:
	var magnitude  : float = GameMath.pointConversion(ball.position.y, position.y, position.y+ paddleSize.y, maxMagnitude, -maxMagnitude)
	var _degree    : float = GameMath.pointConversion(ball.position.y, position.y, position.y+ paddleSize.y, maxRotation, -maxRotation)
	
	magnitude = max(abs(magnitude), 1.0)
	ball.set_rotation_and_direction(_degree)
	ball.set_magnitude(magnitude)
