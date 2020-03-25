extends Node
class_name Metronome, "res://metronome/media/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome with custom BPM & time signature
- Tempo subdivision up to 128 per measure depending on FPS and BPM
"""

# is smallest_subdivision necessary with this method ?
# divide arrays from the start in beat_duration_to_subdivisions_duration ?
# do we need one array for all subdivisions ? or keep 2 arrays ?

# time_start needs to triggered by an event and be stored only once
# better design for input check


var fake_signature := {bpm = 120, bar = 4, beat = 4}
var time_start := 0.0

func _ready() -> void:
	time_start = get_time_now()

func _physics_process(_delta: float) -> void:
	time_to_tempo(fake_signature, get_time_duration(time_start))

func time_to_tempo(signature: Dictionary, time: float) -> Array:
	var d := signature_to_tempo_subdivisions_duration(signature)
	var s = divide_main_tempo_array(d.subdivisions.values())
	var t := [1,1,1,1]
	var acc := time
	
	var ts := [1,1,1,1]
	var acc2 := 0.0
	
	for i in s.primary.size():
		var count := int(acc / s.primary[i])
		t[i] += count
		acc = acc - (count * s.primary[i])
		if i == 0: acc2 = acc
	
	for i in s.secondary.size():
		var count := int(acc2 / s.secondary[i])
		ts[i] += count
		acc2 = acc2 - (count * s.secondary[i])
	
	return t

func signature_to_tempo_subdivisions_duration(signature: Dictionary) -> Dictionary:
	# how to pass delta here ?
	var d := {}
	if check_signature_input(signature):
		d.input_is_ok = true
		d.subdivisions = beat_duration_to_subdivisions_duration(
			signature_to_beat_duration(signature.bpm, signature.beat), 
			signature.bar)
		d.smallest_subdivision_index = get_smallest_subdivision(
			d.subdivisions, 
			get_physics_process_delta_time())
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

func divide_main_tempo_array(arr: Array) -> Dictionary:
	# should take dict
	var d := {primary = [0,0,0,0], secondary = [0,0,0,0]}
	for i in arr.size() / 2:
		d.primary[i] = arr[i * 2]
		d.secondary[i] = arr[i * 2 + 1]
	return d

func fuse_tempo_arrays(dic: Dictionary) -> Array:
	var a := []
	a.resize(8)
	for i in a.size():
		if i % 2 == 0: a[i] = dic.primary[i / 2]
		else: a[i] = dic.secondary[ceil(i / 2)]
	return a
