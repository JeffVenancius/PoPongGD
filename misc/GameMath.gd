extends Resource
class_name GameMath

static func pointConversion(pointA: float, originalStart: float, originalEnd: float,newStart: float,newEnd: float) -> float:
	var length := originalEnd - originalStart
	var newLength := newEnd - newStart

	return ((pointA - originalStart) * (newLength/length)) + newStart

static func vectorScaling(original: Vector2, scale: float) -> Vector2:
	return original * scale

static func vectorRotation(original: Vector2, degree: float) -> Vector2:
	var result : Vector2
	var radian := deg2rad(degree)
	var sine   := sin(radian)
	var cosine := cos(radian)
	
	result.x = (original.x * cosine) - (original.y * sine)
	result.y = ((original.x * sine) + (original.y * cosine)) * -1

	return result

static func primitiveDistributionRandom() -> float:
	var iterate := 6
	var result := 0.0
	randomize()
	for i in iterate: result += randf()

	return result / float(iterate)
