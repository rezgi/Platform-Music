extends Node

#	check how to trigger event on tempo change
#	check how to use triplet & dotted

# CDS :
#	start and stop need to send corresponding signals and know if started or not outside
#	metronome has to send data, first through signal, then through UDF
#	global variables should be in CDS

# UI 
#	inputs become red when not in right format
#	BPM ranged int (1,360) / bar ranged int (1, 64) / beat menu (2,4,8,16,32,64)
#	no 1/1 & 1/128 on triplet / dotted
#	can enter tempo directly ? compute new measure over 5 ? how to have ranged selection within label ?

onready var m := preload("res://Metronome/Scripts/metronome_core.gd").new()

var time_start := 0.0
var metronome_on := false
var custom_signature := {bpm = 120, bar = 4, beat = 4}

#func _ready() -> void:
#	print(m.time_to_tempo(0.539, custom_signature))
#	start()

#func _physics_process(_delta: float) -> void:
#	print(m.time_to_tempo(m.get_time_duration(time_start)))
#	print(m.tempo_to_time([1,3,1,60]))

func start() -> void:
	time_start = m.get_time_now()
	metronome_on = true
	set_physics_process(true)

func stop() -> void:
	metronome_on = false
	set_physics_process(false)
