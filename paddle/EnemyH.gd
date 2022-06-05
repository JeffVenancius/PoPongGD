extends PaddleH
class_name EnemyH

onready var chasePos := paddleSize.x/2

func change_enemy_pos():
	var rndDist: float = GameMath.primitiveDistributionRandom()
	var rndMin := 0.0
	var rndMax := 1.0
	var minChaseSize := 0.0
	var maxChaseSize := paddleSize.x
	
	chasePos = GameMath.pointConversion(rndDist, rndMin, rndMax, minChaseSize, maxChaseSize)


func changeBallDirection(ball: Ball) -> void:
	var magnitude  : float = GameMath.pointConversion(ball.position.x, position.x, position.x+ paddleSize.x, maxMagnitude, -maxMagnitude)
	var _degree    : float = GameMath.pointConversion(ball.position.x, position.x, position.x + paddleSize.x, -maxRotation,  -maxRotation)
	
	magnitude = max(abs(magnitude), 1.0)
	if _degree >= 0: _degree *=- 1 
	ball.set_rotation_and_directionY(_degree)
	ball.set_magnitude(magnitude)
