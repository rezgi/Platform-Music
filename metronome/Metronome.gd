extends Node
class_name Metronome, "res://metronome/media/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome with BPM & time signature
- Dynamically converts time to tempo through pure functions
- API : 
	- time_to_tempo(signature, time) -> {[rp],[rs],[dp],[ds]}
		- takes time signature & actual time duration then returns a dictionary with 4 arrays : 
		- regular tempo : primary [1/1, 1/4, 1/16, 1/64] & secondary [1/2, 1/8, 1/32, 1/128]
		- dotted tempo : primary [1/1 + 1/2, 1/4 + 1/18, 1/16 + 1/32, 1/64 + 1/128] & secondary 
	- start()
	- stop()
	- tempo_to_time()
"""

#var fake_signature := {bpm = 120, bar = 4, beat = 4}
var time_start := 0.0

func _ready() -> void:
	time_start = get_time_now()

#func _physics_process(_delta: float) -> void:
#	time_to_tempo(fake_signature, get_time_duration(time_start))

func time_to_tempo(signature: Dictionary, time: float) -> Dictionary:
	var s := signature_to_tempo(signature)
	var tempo := {regular = {}, dotted = {}}
	
	var tr := split_tempo(s.regular)
	var td := split_tempo(s.dotted)
	
	tempo.regular.primary = divide_time(tr.primary, time)
	tempo.regular.secondary = divide_time(tr.secondary, measure_remainder(tr.primary[0], time))
	
	tempo.dotted.primary = divide_time(td.primary, time)
	tempo.dotted.secondary = divide_time(td.secondary, measure_remainder(td.primary[0], time))

	return tempo

func signature_to_tempo(signature: Dictionary) -> Dictionary:
	var s := signature
	var reg := beat_to_tempo(signature_to_beat(s.bpm, s.beat), s.bar)
	var dot := tempo_to_dotted(reg)
	return {regular = reg, dotted = dot}

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
	d["128d"] = 1
	return d

func divide_time(duration_array: Array, time: float) -> Array:
	var tempo_array := [1,1,1,1]
	var acc := time
	for i in duration_array.size():
		var count := int(acc / duration_array[i])
		tempo_array[i] += count
		acc = acc - (count * duration_array[i])
	return tempo_array

func measure_remainder(measure_duration: float, time: float) -> float:
	return time - (int(time / measure_duration) * measure_duration)

func signature_to_beat(bpm: int, beat_length: int) -> float:
	return (60.0 / bpm) * (4.0 / beat_length)

func get_time_duration(start) -> float:
	return get_time_now() - start

func get_time_now() -> float:
	return OS.get_system_time_msecs() / 1000.0

func split_tempo(dict: Dictionary) -> Dictionary:
	var a := dict.values()
	var d := {primary = [0,0,0,0], secondary = [0,0,0,0]}
# warning-ignore:integer_division
	for i in a.size() / 2:
		d.primary[i] = a[i * 2]
		d.secondary[i] = a[i * 2 + 1]
	return d
