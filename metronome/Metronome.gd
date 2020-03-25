extends Node
class_name Metronome, "res://metronome/media/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome with BPM & time signature
- Dynamically convert time to tempo through pure functions
- 2 arrays : primary [1/1, 1/4, 1/16, 1/64] and secondary [1/2, 1/8, 1/32, 1/128]
"""

# decide if use 2 separate arrays (primary & secondary) without split and fuse
# add dotted arrays computation function
# time_start needs to triggered by an event and be stored only once
# better design for input check, lock field inputs for no error checking


var fake_signature := {bpm = 120, bar = 4, beat = 4}
var time_start := 0.0

func _ready() -> void:
	time_start = get_time_now()

func _physics_process(_delta: float) -> void:
	print(time_to_tempo(fake_signature, get_time_duration(time_start)))

func time_to_tempo(signature: Dictionary, time: float) -> Array:
	var s := split_main_tempo((signature_to_tempo(signature)).values())
	var tp := [1,1,1,1]
	var ts := [1,1,1,1]
	var acc_p := time
	var acc_s := 0.0
	
	for i in s.primary.size():
		var count := int(acc_p / s.primary[i])
		tp[i] += count
		acc_p = acc_p - (count * s.primary[i])
		if i == 0: acc_s = acc_p
	
	for i in s.secondary.size():
		var count := int(acc_s / s.secondary[i])
		ts[i] += count
		acc_s = acc_s - (count * s.secondary[i])

	return join_tempos({primary=tp, secondary=ts})

func signature_to_tempo(signature: Dictionary) -> Dictionary:
	var s := signature
	if check_signature_input(s):
		return beat_to_tempo(signature_to_beat(s.bpm, s.beat), s.bar)
	else: return {d = false}

func beat_to_tempo(beat_duration: float, bar: int) -> Dictionary:
	var d := {}
	d["1"] = beat_duration * bar
	d["2"] = beat_duration * 2
	d["4"] = beat_duration
	d["8"] = d["4"] / 2.0
	d["16"] = d["8"] / 2.0
	d["32"] = d["16"] / 2.0
	d["64"] = d["32"] / 2.0
	d["128"] = d["64"] / 2.0
	return d

func tempo_to_dotted(durations: Dictionary) -> Dictionary:
	var d := {}
	d["1d"] = durations["1"] + durations["2"]
	d["2d"] = durations["2"] + durations["4"]
	d["4d"] = durations["4"] + durations["8"]
	d["8d"] = durations["8"] + durations["16"]
	d["16d"] = durations["16"] + durations["32"]
	d["32d"] = durations["32"] + durations["64"]
	d["64d"] = durations["64"] + durations["128"]
	d["128d"] = 0
	return d

func divide_time(duration_array: Array, acc: float) -> Array:
	var tempo_array := [1,1,1,1]
	for i in duration_array.size():
		var count := int(acc / duration_array[i])
		tempo_array[i] += count
		acc = acc - (count * duration_array[i])
	return tempo_array

func signature_to_beat(bpm: int, beat_length: int) -> float:
	return (60.0 / bpm) * (4.0 / beat_length)

func get_time_duration(start) -> float:
	return get_time_now() - start

func get_time_now() -> float:
	return OS.get_system_time_msecs() / 1000.0

func check_signature_input(signature_input: Dictionary) -> bool:
	var check_status = false
	var i := 2

	while i <= 64:
		if signature_input.beat == i: check_status = true
		i *= 2

	if signature_input.bpm and signature_input.bar and signature_input.beat and check_status:
		return true
	else: return false

func split_main_tempo(arr: Array) -> Dictionary:
	var d := {primary = [0,0,0,0], secondary = [0,0,0,0]}
	for i in arr.size() / 2:
		d.primary[i] = arr[i * 2]
		d.secondary[i] = arr[i * 2 + 1]
	return d

func join_tempos(dic: Dictionary) -> Array:
	var a := []
	a.resize(8)
	for i in a.size():
		if i % 2 == 0: a[i] = dic.primary[i / 2]
		else: a[i] = dic.secondary[ceil(i / 2)]
	return a
