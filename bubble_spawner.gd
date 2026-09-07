@tool
extends MultiMeshInstance3D
class_name BubbleSpawner

## Variable amount of random time intervals spawn bubbles inside a random position of the lava polygon

## Currently total amount
## TODO: make amount/m^2
@export var bubble_amount = 2
@export var random_start_spawn_position: Vector3 = -Vector3.ONE
@export var random_end_spawn_position: Vector3 = Vector3.ONE
@export var random_min_scale: float = 0.1
@export var random_max_scale: float = 1
@export var bubbles_squared_poison_minimum: float = 2
@export var poison_iterations: int = 5
@export var timer_array: TimerArray

var shader_material : ShaderMaterial

signal bubble_popped(transform: Transform3D)


func _ready() -> void:
	multimesh.instance_count = 0
	multimesh.use_custom_data = true
	multimesh.use_colors = true
	multimesh.instance_count = bubble_amount
	shader_material = (multimesh.mesh.surface_get_material(0) as ShaderMaterial)
	for i in range(bubble_amount):
		timer_array.create_random_timer()
		
	if !timer_array.timeout.is_connected(instantiate_bubble):
		timer_array.timeout.connect(instantiate_bubble)
		
		
func _exit_tree() -> void:
	multimesh.instance_count = 0
	timer_array.timeout.disconnect(instantiate_bubble)
	
	
func _process(_delta: float) -> void:
	shader_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
	#var shader_time : float = shader_material.get_shader_parameter("time")
	#var shader_start_time : float = multimesh.get_instance_custom_data(0).r
	#printt(shader_time, shader_start_time, shader_time - shader_start_time, timers[0].wait_time)
	pass


func instantiate_bubble(index: int):
	bubble_popped.emit(multimesh.get_instance_transform(index))
	# TODO: randomize only inside the polygon mesh
	var new_transform : Transform3D = Transform3D()
	var random_scale := RandomNumberUtil.get_random_uniform_vector(random_min_scale, random_max_scale)
	new_transform.basis = Basis().scaled(random_scale)
	
	for i in range(poison_iterations):
		if(i == 0 || bubble_position_occupied_approx(new_transform)):
			new_transform.origin = RandomNumberUtil.get_random_vector(random_start_spawn_position, random_end_spawn_position)
			
	
	## TODO: pass color of ground below
	## [start time], [max lifetime]
	var start_time_color := Color(Time.get_ticks_msec() / 1000.0, timer_array.timers[index].wait_time, 0, 0)
	multimesh.set_instance_custom_data(index, start_time_color)
	multimesh.set_instance_transform(index, new_transform)


func bubble_position_occupied_approx(new_transform: Transform3D) -> bool:
	for i in range(multimesh.instance_count):
		if multimesh.get_instance_transform(i).origin.distance_squared_to(new_transform.origin) < bubbles_squared_poison_minimum:
			return true
	return false
	
