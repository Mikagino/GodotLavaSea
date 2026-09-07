@tool
extends GPUParticles3D

@export var particles_per_batch_min : int = 2
@export var particles_per_batch_max : int = 4

var random_number_generator := RandomNumberGenerator.new()


func _ready() -> void:
	emitting = false


func spawn_batch(center: Transform3D):
	if(center.origin.is_zero_approx()): return
	for i in range(RandomNumberUtil.random_number_generator.randi_range(particles_per_batch_min, particles_per_batch_max)):
		emit_particle(center.rotated(Vector3.LEFT, PI/2.0).translated(global_position), Vector3.ZERO, Color.WHITE, Color.WHITE, EMIT_FLAG_POSITION)
	pass
