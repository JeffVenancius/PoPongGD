extends Node2D
class_name Target

func _init(pos) -> void:
	position = pos

func _draw() -> void:
	draw_rect(Rect2(0,8,32, 2),Color.white); draw_rect(Rect2(-8,16,32+8, 2),Color.white) # L drawing
	draw_rect(Rect2(0,-32+10,2, 32),Color.white); draw_rect(Rect2(-8,-32+10,2, 32+8),Color.white)
