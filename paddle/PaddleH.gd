extends Paddle
class_name PaddleH

func set_start_pos(start_pos):
	paddleSize = Vector2(100.0, 10.0)
	start_pos.x = Screen.hScreenSize.x/2 + paddleSize.x*2
	position = start_pos

func changeBallDirection(ball: Ball) -> void:
	var magnitude  : float = GameMath.pointConversion(ball.position.x, position.x, position.x + paddleSize.x, maxMagnitude, -maxMagnitude)
	var _degree    : float = GameMath.pointConversion(ball.position.x, position.x, position.x + paddleSize.x, maxRotation,  -maxRotation)
	magnitude = max(abs(magnitude), 1.0)

	ball.set_rotation_and_direction(_degree)
	ball.set_magnitude(magnitude)
	if ball.speed.y > 0 : ball.speed *= -1
