@tool
extends MultiMeshInstance3D
class_name BubbleSpawner

## Variable amount of random time intervals spawn bubbles inside a random position of the lava polygon

## Currently total amount
## TODO: make amount/m^2
@export var bubble_amount = 2
@export var random_start_time_per_bubble: float = 2
@export var random_end_time_per_bubble: float = 5
@export var random_start_spawn_position: Vector3 = -Vector3.ONE
@export var random_end_spawn_position: Vector3 = Vector3.ONE
@export var random_min_scale: float = 0.1
@export var random_max_scale: float = 1


var timers: Array[Timer] = []
var bubbles: Array[Node3D] = []

var random_number_generator := RandomNumberGenerator.new()
var shader_material : ShaderMaterial

func _ready() -> void:
	multimesh.instance_count = bubble_amount
	shader_material = (multimesh.mesh.surface_get_material(0) as ShaderMaterial)
	for i in range(bubble_amount):
		create_random_timer()
		timers.back().timeout.connect(instantiate_bubble.bind(i))
		
		
func _process(_delta: float) -> void:
	#shader_material.set_shader_parameter("time", Time.get_ticks_msec())
	pass


## Adds a new timer to the timers array and randomizes its time.
func create_random_timer():
	timers.append(Timer.new())
	randomize_time(timers.back())
	timers.back().timeout.connect(restart_timer_random.bind(timers.back()))
	add_child(timers.back())
	timers.back().start()


## Randomizes the timers wait_time and restarts it.
func restart_timer_random(timer: Timer):
	randomize_time(timer)
	timer.start()


## Sets the timers wait_time to a random value between start_time - end_time
func randomize_time(timer: Timer):
	timer.wait_time = random_number_generator.randf_range(random_start_time_per_bubble, random_end_time_per_bubble)


func instantiate_bubble(index: int):
	# TODO: randomize only inside the polygon mesh
	var random_position := get_random_position(random_start_spawn_position, random_end_spawn_position)
	var random_scale := get_random_size(random_min_scale, random_max_scale)
	var random_basis := Basis().scaled(random_scale)
	#multimesh.
	multimesh.set_instance_transform(index, Transform3D(random_basis, random_position))


func get_random_position(start: Vector3, end: Vector3) -> Vector3:
	return Vector3(
		random_number_generator.randf_range(start.x, end.x),
		random_number_generator.randf_range(start.y, end.y),
		random_number_generator.randf_range(start.z, end.z),
	)


func get_random_size(start: float, end: float) -> Vector3:
	return Vector3.ONE * random_number_generator.randf_range(start, end)
	
	
