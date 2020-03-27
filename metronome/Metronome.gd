extends Node
#class_name Metronome, "res://metronome/media/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome regular counting using BPM & time signature
- Dynamically converts time to tempo count through pure functions

- time_to_tempo(time, signature, type) converts time to tempo count
- tempo_to_time(tempo, signature, type) converts tempo to time

- Regular tempo : primary [1/1, 1/4, 1/16, 1/64] & secondary [1/2, 1/8, 1/32, 1/128]
- Dotted tempo : adds half duration to each tempo subdivision
"""

# try divide 16th by 128 (or 125 like cubase) to have only one array : 
# [1,4,4,128] -> 1/128 = .16, 1/64 (2x128) = .32, 1/32 = .64, 1/16 = .128

# metronome has to send data to CDS, first through signal, then through UDF


var default_signature := {bpm = 120, bar = 4, beat = 4}
enum {FULL, REGULAR_PRIMARY, REGULAR_SECONDARY, DOTTED_PRIMARY, DOTTED_SECONDARY}

## Main Methods

func time_to_tempo(time: float, signature: Dictionary = default_signature, type: int = 1) -> Array:
	var s := signature_to_durations(signature)
	match type:
		FULL:
			var tempo := []
			tempo.append(time_divider(s.regular.primary, time))
			tempo.append(time_divider(s.regular.secondary, measure_remainder(s.regular.primary[0], time)))
			tempo.append(time_divider(s.dotted.primary, time))
			tempo.append(time_divider(s.dotted.secondary, measure_remainder(s.dotted.primary[0], time)))
			return tempo
		REGULAR_PRIMARY:
			return time_divider(s.regular.primary, time)
		REGULAR_SECONDARY:
			return time_divider(s.regular.secondary, measure_remainder(s.regular.primary[0], time))
		DOTTED_PRIMARY:
			return time_divider(s.dotted.primary, time)
		DOTTED_SECONDARY:
			return time_divider(s.dotted.secondary, measure_remainder(s.dotted.primary[0], time))
		_:
			return []

func tempo_to_time(tempo: Array, signature: Dictionary = default_signature, type: int = 1) -> float:
	if tempo.size() == 0:
		return 0.0
	var s := signature_to_durations(signature)
	match type:
		FULL:
			return 0.0
		REGULAR_PRIMARY:
			return tempo_multiplier(tempo, s.regular.primary)
		REGULAR_SECONDARY:
			return tempo_multiplier(tempo, s.regular.secondary)
		DOTTED_PRIMARY:
			return tempo_multiplier(tempo, s.dotted.primary)
		DOTTED_SECONDARY:
			return tempo_multiplier(tempo, s.dotted.secondary)
		_:
			return 0.0

## Time Conversion

func time_divider(duration_array: Array, time: float) -> Array:
	var tempo_array := [1,1,1,1]
	var acc := time
	for i in duration_array.size():
		var count := int(acc / duration_array[i])
		tempo_array[i] += count
		acc = acc - (count * duration_array[i])
	return tempo_array

func tempo_multiplier(tempo: Array, duration: Array) -> float:
	var acc := 0.0
	for i in range(tempo.size()):
		acc += (tempo[i] - 1) * duration[i]
	return acc

func signature_to_durations(signature: Dictionary) -> Dictionary:
	var reg := beat_to_tempo(signature_to_beat(signature.bpm, signature.beat), signature.bar)
	var dot := tempo_to_dotted(reg)
	return {regular = split_tempo(reg), dotted = split_tempo(dot)}

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

func measure_remainder(measure_duration: float, time: float) -> float:
	return time - (int(time / measure_duration) * measure_duration)

func signature_to_beat(bpm: int, beat_length: int) -> float:
	return (60.0 / bpm) * (4.0 / beat_length)

## Tools

func split_tempo(dict: Dictionary) -> Dictionary:
	var a := dict.values()
	var d := {primary = [0,0,0,0], secondary = [0,0,0,0]}
# warning-ignore:integer_division
	for i in a.size() / 2:
		d.primary[i] = a[i * 2]
		d.secondary[i] = a[i * 2 + 1]
	return d

func get_time_duration(start) -> float:
	return get_time_now() - start

func get_time_now() -> float:
	return OS.get_system_time_msecs() / 1000.0
