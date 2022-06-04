extends Paddle
class_name PaddleH


func set_start_pos(start_pos):
	paddleSize = Vector2(100.0, 10.0)
	start_pos.x = Screen.hScreenSize.x/2 + paddleSize.x*2
	position = start_pos
