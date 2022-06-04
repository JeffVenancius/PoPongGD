extends Resource
class_name Collisions

#static func pointToPoint(pointA:Vector2, pointB:Vector2) -> bool:
#	return pointA == pointB

static func pointToRect(point:Vector2, rect:Rect2) -> bool:
	var rectTop    := rect.position.y; 
	var rectLeft   := rect.position.x
	var rectRight  := rectLeft + rect.size.x
	var rectBottom := rectTop + rect.size.y
	
	var horizontal := rectLeft <= point.x and point.x <= rectRight
	var vertical   := rectTop  <= point.y and point.y <= rectBottom
	return horizontal and vertical
