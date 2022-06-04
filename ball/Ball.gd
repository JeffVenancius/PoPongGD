extends Node2D
class_name Ball

var _radius := 10.0
const START_SPEED := Vector2(300.0, 0.0); var speed := START_SPEED

var START_POS
var acceleration: int = 1 # 1 is so it resets at start

func _init() -> void:
	START_POS = Screen.hScreenSize

func restart() -> void:
	position = START_POS
	speed = START_SPEED
	update()

func out() -> bool:
	return position.x <= -_radius or position.x >= Screen.screenSize.x + _radius or position.y >= Screen.screenSize.y or position.y <= 0

func corners() -> bool:
	return position.y - _radius <= 0 or position.y + _radius >= Screen.screenSize.y

func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, Color.white)
