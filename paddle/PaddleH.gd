extends Paddle
class_name PaddleH

func set_start_pos(start_pos):
	paddleSize = Vector2(100.0, 10.0)
	start_pos.x = Screen.hScreenSize.x/2 + paddleSize.x*2
	position = start_pos

func changeBallDirection(ball: Ball) -> void:
#	if collided: return
	var magnitude  : float = GameMath.pointConversion(ball.position.x, position.x, position.x + paddleSize.x, maxMagnitude, -maxMagnitude)
	var _degree    : float = GameMath.pointConversion(ball.position.x, position.x, position.x + paddleSize.x, maxRotation,  -maxRotation)
	magnitude = max(abs(magnitude), 1.0)
	
	if _degree >= 0: _degree *=- 1 
	ball.set_rotation_and_directionY(_degree)
	ball.set_magnitude(magnitude)
