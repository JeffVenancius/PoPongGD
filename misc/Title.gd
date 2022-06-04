extends Node2D
class_name Title

const robotoFont := preload("res://Roboto-Light.ttf")

var font       := DynamicFont.new()
var hWidthFont : float
var heightFont : float
var text       : String setget set_text

func _init(fontSize) -> void:
	font.font_data = robotoFont
	font.size = fontSize


func set_text(value) -> void:
	text = value
	hWidthFont = font.get_string_size(text).x/2
	heightFont = font.get_height()
	position = Vector2(Screen.hScreenSize.x - hWidthFont,Screen.hScreenSize.y - 64)
	update()

func _draw() -> void:
	draw_string(font, Vector2.ZERO, text)
