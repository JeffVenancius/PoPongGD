extends Paddle
class_name Enemy

onready var chasePos := paddleSize.y/2

func change_enemy_pos():
	var rndDist: float = GameMath.primitiveDistributionRandom()
	var rndMin := 0.0
	var rndMax := 1.0
	var minChaseSize := 0.0
	var maxChaseSize := paddleSize.y
	
	chasePos = GameMath.pointConversion(rndDist, rndMin, rndMax, minChaseSize, maxChaseSize)
