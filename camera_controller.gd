extends Camera3D

@export var rotation_speed : float = 0.002

func _ready() -> void:
	Input.mouse_mode = Input.MouseMode.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, -event.relative.x * rotation_speed)
		rotate_object_local(Vector3.LEFT, event.relative.y * rotation_speed)
		#rotation_degrees += Vector3(rotation_degrees.x, , event.relative.y)
