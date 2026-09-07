@tool
extends Node
class_name TimerArray


@export var random_start_time: float = 2
@export var random_end_time: float = 5
var timers: Array[Timer] = []
var random_number_generator := RandomNumberGenerator.new()


signal timeout(index: int)


## Adds a new timer to the timers array and randomizes its time.
func create_random_timer():
	timers.append(Timer.new())
	randomize_time(timers.back())
	timers.back().timeout.connect(restart_timer_random.bind(timers.back()))
	add_child(timers.back())
	timers.back().start()
	var current_index := timers.size() - 1
	timers[current_index].timeout.connect(timeout.emit.bind(current_index))


## Randomizes the timers wait_time and restarts it.
func restart_timer_random(timer: Timer):
	randomize_time(timer)
	timer.start()


## Sets the timers wait_time to a random value between start_time - end_time
func randomize_time(timer: Timer):
	timer.wait_time = random_number_generator.randf_range(random_start_time, random_end_time)
