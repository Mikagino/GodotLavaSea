@tool
extends Node
class_name RandomNumberUtil

static var random_number_generator : RandomNumberGenerator


func _ready() -> void:
	random_number_generator = RandomNumberGenerator.new()
	

static func get_random_vector(start: Vector3, end: Vector3) -> Vector3:
	return Vector3(
		random_number_generator.randf_range(start.x, end.x),
		random_number_generator.randf_range(start.y, end.y),
		random_number_generator.randf_range(start.z, end.z),
	)


static func get_random_uniform_vector(start: float, end: float) -> Vector3:
	return Vector3.ONE * random_number_generator.randf_range(start, end)
