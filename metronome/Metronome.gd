extends Node
class_name Metronome, "res://metronome/media/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome with custom BPM & time signature
- Tempo subdivision up to 128 per measure depending on FPS and BPM
"""

# func time_to_tempo(time, signature)

var fake_signature := {bpm = 120, bar = 4, beat = 4}
var fake_dico := {}
var time_start := 0.0
var arr := [1,1,1,1]

func _ready() -> void:
	time_start = get_time_now()

func _physics_process(delta: float) -> void:
	var time_now := get_time_duration(time_start)
	time_to_tempo(fake_signature, time_now)

func time_to_tempo(signature: Dictionary, time: float):
	var d := signature_to_tempo_subdivisions_duration(signature)
	if fposmod(time, d.subdivisions["1"]) < get_physics_process_delta_time():
		arr[0] += 1
		arr[1] = 1
		arr[2] = 1
		arr[3] = 1
	elif fposmod(time, d.subdivisions["4"]) < get_physics_process_delta_time():
		arr[1] += 1
		arr[2] = 1
		arr[3] = 1
	elif fposmod(time, d.subdivisions["16"]) < get_physics_process_delta_time():
		arr[2] += 1
		arr[3] = 1
	elif fposmod(time, d.subdivisions["64"]) < get_physics_process_delta_time():
		arr[3] += 1
	print(arr)

func signature_to_tempo_subdivisions_duration(signature: Dictionary) -> Dictionary:
	# how to pass delta here ?
	var d := {}
	if check_signature_input(signature):
		d.input_is_ok = true
		d.beat_duration = signature_to_beat_duration(signature.bpm, signature.beat)
		d.subdivisions = beat_duration_to_subdivisions_duration(d.beat_duration, signature.bar)
		d.smallest_subdivision_index = get_smallest_subdivision(d.subdivisions, get_physics_process_delta_time())
	else: d.input_is_ok = false
	return d

func get_time_now() -> float:
	return OS.get_system_time_msecs() / 1000.0

func get_time_duration(start) -> float:
	return get_time_now() - start

func check_signature_input(signature_input: Dictionary) -> bool:
	# add specific field error
	var check_status = false
	var i := 2

	while i <= 64:
		if signature_input.beat == i: check_status = true
		i *= 2

	if signature_input.bpm and signature_input.bar and signature_input.beat and check_status:
		return true
	else: return false

func signature_to_beat_duration(bpm: int, beat_length: int) -> float:
	return (60.0 / float(bpm)) * (4.0 / float(beat_length))

func beat_duration_to_subdivisions_duration(beat_duration: float, bar: int) -> Dictionary:
	var d = {}
	d["1"] = beat_duration * bar
	d["2"] = beat_duration * 2
	d["4"] = beat_duration
	d["8"] = d["4"] / 2.0
	d["16"] = d["8"] / 2.0
	d["32"] = d["16"] / 2.0
	d["64"] = d["32"] / 2.0
	d["128"] = d["64"] / 2.0
	return d

func get_smallest_subdivision(subdivisions, delta) -> int:
	var index := 0
	for key in subdivisions.values():
		if key >= delta: index += 1
		else: return index
	return index
