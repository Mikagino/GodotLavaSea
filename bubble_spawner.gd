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
@export var bubbles_squared_poison_minimum: float = 2
@export var poison_iterations: int = 5


var timers: Array[Timer] = []

var random_number_generator := RandomNumberGenerator.new()
var shader_material : ShaderMaterial

func _ready() -> void:
	multimesh.instance_count = 0
	multimesh.use_custom_data = true
	multimesh.use_colors = true
	multimesh.instance_count = bubble_amount
	shader_material = (multimesh.mesh.surface_get_material(0) as ShaderMaterial)
	for i in range(bubble_amount):
		create_random_timer()
		timers.back().timeout.connect(instantiate_bubble.bind(i))
		
		
func _exit_tree() -> void:
	multimesh.instance_count = 0
	
		
func _process(_delta: float) -> void:
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
	#var shader_time : float = shader_material.get_shader_parameter("time")
	#var shader_start_time : float = multimesh.get_instance_custom_data(0).r
	#printt(shader_time, shader_start_time, shader_time - shader_start_time, timers[0].wait_time)
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
	var new_transform : Transform3D = Transform3D()
	var random_scale := get_random_size(random_min_scale, random_max_scale)
	new_transform.basis = Basis().scaled(random_scale)
	
	for i in range(poison_iterations):
		if(i == 0 || bubble_position_occupied_approx(new_transform)):
			new_transform.origin = get_random_position(random_start_spawn_position, random_end_spawn_position)
			
	
	## TODO: pass color of ground below
	## [start time], [max lifetime]
	var start_time_color := Color(Time.get_ticks_msec() / 1000.0, timers[index].wait_time, 0, 0)
	multimesh.set_instance_custom_data(index, start_time_color)
	multimesh.set_instance_transform(index, new_transform)


func bubble_position_occupied_approx(new_transform: Transform3D) -> bool:
	for i in range(multimesh.instance_count):
		if multimesh.get_instance_transform(i).origin.distance_squared_to(new_transform.origin) < bubbles_squared_poison_minimum:
			return true
	return false

func get_random_position(start: Vector3, end: Vector3) -> Vector3:
	return Vector3(
		random_number_generator.randf_range(start.x, end.x),
		random_number_generator.randf_range(start.y, end.y),
		random_number_generator.randf_range(start.z, end.z),
	)
	
	
func get_random_size(start: float, end: float) -> Vector3:
	return Vector3.ONE * random_number_generator.randf_range(start, end)
	
	
