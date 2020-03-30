extends Node

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome counts using BPM & time signature
- Converts time to tempo in both directions through pure functions
- Takes triplet and dotted into account (optional) when computing subdivision duration
- Subdivisions : 1/1, 1/2, 1/4, 1/8, 1/16, 1/32, 1/64, 1/128 : [1, 2, 4, 8, 16, 32, 64, 128]
- Divides sub-16th duration to 1/120 ratio and rounds it to 5 increments
"""

var default_signature := {bpm = 120, bar = 4, beat = 4}
var default_subdivisions := [1, 4, 16, 0]
enum {NORMAL, TRIPLET, DOTTED}

## Main Methods

func time_to_tempo(time: float, signature: Dictionary = default_signature) -> Array:
	var tempo_array := [1, 1, 1, 0]
	var acc := time
	
	for i in tempo_array.size():
		if i == 3: tempo_array[i] = sub_time_counter(acc, signature_to_duration(default_subdivisions[i - 1], signature))
		else:
			var duration := signature_to_duration(default_subdivisions[i], signature)
			var count := int(acc / duration)
			tempo_array[i] += count
			acc = acc - (count * duration)
	
	return tempo_array

func tempo_to_time(tempo: Array, signature: Dictionary = default_signature) -> float:
	var acc := 0.0
	
	for i in tempo.size():
		if i == 3 :
			acc += (signature_to_duration(default_subdivisions[i - 1], signature) / 120) * tempo[i]
			break
		else:
			var duration := signature_to_duration(default_subdivisions[i], signature)
			acc += (tempo[i] - 1) * duration
	
	return acc

func signature_to_duration(subdivision: int, signature: Dictionary = default_signature, tempo_type: int = 0) -> float:
	var beat = (60.0 / signature.bpm) * (4.0 / signature.beat)

	if subdivision == 1: return beat * signature.bar
	else:
		var duration = beat / (subdivision / 4.0)
		match tempo_type:
			0: return duration
			1: return duration * 2 / 3.0
			2: return duration + (duration / 2.0)
			_: return -1.0

## Tools

func sub_time_counter(time_left: float, sixteenth: float) -> int:
	if time_left == 0: return 0
	var increment_duration := sixteenth / 120
	var count := time_left / increment_duration
	var rounded_count = count + (5 - fposmod(count, 5))
	
	return 0 if rounded_count == 120 else rounded_count

func get_time_duration(start) -> float:
	return get_time_now() - start

func get_time_now() -> float:
	return OS.get_system_time_msecs() / 1000.0
