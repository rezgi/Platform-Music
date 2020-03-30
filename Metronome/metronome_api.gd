extends "res://Metronome/metronome_core.gd"

# check how to use triplet & dotted
# start and stop need to send corresponding signals and know if started or not outside
# metronome has to send data to CDS, first through signal, then through UDF
# global variables should be in CDS

# UI inputs become red when not in right format
# BPM ranged int (1,360) / bar ranged int (1, 64) / beat menu (2,4,8,16,32,64)
# no 1/1 & 1/128 on triplet / dotted

var time_start := 0.0
var metronome_on := false
var custom_signature := {bpm = 60, bar = 3, beat = 4}

func _ready() -> void:
	start()

func _physics_process(_delta: float) -> void:
	print(time_to_tempo(get_time_duration(time_start)))
#	print(tempo_to_time([1,3,1,45]))

func start() -> void:
	time_start = get_time_now()
	metronome_on = true
	set_physics_process(true)

func stop() -> void:
	metronome_on = false
	set_physics_process(false)
