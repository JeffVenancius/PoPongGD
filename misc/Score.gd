extends Node2D
class_name Score

const robotoFont := preload("res://Roboto-Light.ttf")

var font := DynamicFont.new()

var points    := 0 setget set_score
var strPoints := points as String

var halfWidth  : float
var heightFont : float

var firstX     : float

func _init(fontSize, initial_x) -> void:
	font.font_data = robotoFont
	font.size = fontSize
	firstX = initial_x
	self.points = 0

func set_score(value) -> void:
	points = value
	strPoints = str(points)
	halfWidth = font.get_string_size(strPoints).x/2
	position = Vector2(firstX - halfWidth, heightFont + 80)
	update()

func _draw() -> void:
	draw_string(font, Vector2.ZERO, strPoints)
