extends "res://Metronome/Metronome.gd"

# start and stop need to send corresponding signals and know if started or not outside
# a metronome_run() function only for process ? divide between static and dynamic methods

#time_to_tempo(time: float, signature: Dictionary = default_signature, type: int = 1) -> Array
#tempo_to_time(tempo: Array, signature: Dictionary = default_signature, type: int = 1) -> float

var time_start := 0.0
var metronome_on := false
var custom_signature := {bpm = 120, bar = 3, beat = 4}


func _ready() -> void:
#	print(time_to_tempo(4.75))
#	print(tempo_to_time([2,2,1,1]))
	start()

func _physics_process(_delta: float) -> void:
	print(time_to_tempo(get_time_duration(time_start), custom_signature, 2))

func start() -> void:
	time_start = get_time_now()
	metronome_on = true
	set_physics_process(true)

func stop() -> void:
	metronome_on = false
	set_physics_process(false)
