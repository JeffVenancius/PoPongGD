extends Node2D
class_name Ball

var _radius := 10.0
const START_SPEED := Vector2(300.0, 0.0); var speed := START_SPEED

var START_POS
var acceleration: float = 1.0 # 1 is so it resets at start

var _scale

func _init() -> void:
	START_POS = Screen.hScreenSize

func restart() -> void:
	position = START_POS
	speed = START_SPEED
	acceleration = 0
	update()

func out() -> bool:
	return position.x <= -_radius or position.x >= Screen.screenSize.x + _radius or position.y >= Screen.screenSize.y or position.y <= 0

func corners() -> bool:
	return position.y - _radius <= 0 or position.y + _radius >= Screen.screenSize.y

func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Color.white)


func set_magnitude(_scale: float) -> void:
	speed = GameMath.vectorScaling(speed, _scale)

func set_rotation_and_direction(_degree):
	speed.x = -speed.x
	var direction
	direction = acceleration if speed.x > 0 else -acceleration
	var _rotate = GameMath.vectorRotation(START_SPEED, _degree)
	_rotate.x *= direction
	
	speed = _rotate


func set_rotation_and_directionY(_degree):
	speed.y = -speed.y
	var direction
	direction = acceleration if speed.y > 0 else -acceleration
	var _rotate = GameMath.vectorRotation(START_SPEED, _degree)
	_rotate.y *= direction
	print(_rotate)
	speed = _rotate
	




