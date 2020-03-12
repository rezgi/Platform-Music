extends Node

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome tool
- Custom BPM & time signature
- Tempo subdivision up to 64 per measure
- Tempo format : [measure, quart, sixteenth, sixtyfourth] -> [1, 4, 4, 4]
- Input fields : BPM / time signature / metronome clicks on subdivisions / tempo display
- Methods : get & set tempo, tempo to time, time to tempo
"""

# Tempo algorithm
	# maybe better to use OS.ticks than delta
	# count of signatures like 4/2 isn't working the right way, refactor tempo count
	# better use of Metronome.time elements to trigger beats increment
	# gone down to 128, test its use
	# how to use 1/2, 1/8, 1/32, maybe will work with new data structure
	# how to implement dotted time
# Create a tempo <> time converter
	# tempo to time needs to take into account signature, works only for 4/4 now
# Cosmetic changes
	# one field for time signature ?
	# rename scene to 'Metronome' and give class_name & icon
	# delete old tempo.tscn & its script
	# modulate script : signals / UI inputs / tempo. leave only main logic and exposed methods in here
	# is there a way to gather all buttons signals and combine them into one signal ? procedural too
	# a functional way to treat signals : central data that changes when a signal comes, loop to read from it
# Use outside the scene
	# make UI togglable for integration into other scenes, or integrate into Inspector ? Both ?
	# display running time sync with tempo updates (1/64)
	# signal on each tick, send measure dict
	# design the API to use its methods
	# check if functional paradigm applied


onready var bpm_text_input := $CenterContainer/VBoxContainer/BPMInput
onready var bar_signature := $CenterContainer/VBoxContainer/HBoxContainer/BarSignature
onready var beat_signature := $CenterContainer/VBoxContainer/HBoxContainer/BeatSignature
onready var btn := $CenterContainer/VBoxContainer/StartButton
onready var label := $CenterContainer/VBoxContainer/TempoDisplay
onready var clic := $AudioStreamPlayer

var Metronome := {}
var delta_accumulator := 0.0
var possible_beats := [4, 2, 8, 16, 32, 64]
var measure_sound_on := false
var quart_sound_on := false
var sixteenth_sound_on := false
var sixtyfourth_sound_on := false

##
## RUN
##

func _ready() -> void:
	set_physics_process(false)
	Metronome.time = reset_measure_time()
	Metronome.tempo = reset_measure_tempo()
	measure_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_measure.pressed
	quart_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_quart.pressed

func _physics_process(delta: float) -> void:
	if btn.pressed:
		count_tempo(delta)
		label.text = str(tempo_to_array())

##
## INPUT LOGIC
##

func check_inputs(time_input: Dictionary) -> bool:
	var beat_is_ok = false
	for i in possible_beats:
		if time_input.beat_input == i:
			beat_is_ok = true
	
	if time_input.bpm_input and time_input.bar_input and time_input.beat_input and beat_is_ok:
		return true
	else: return false

func getset_tempo_data(time_input) -> void:
	Metronome.time = durations_to_tempo_subdivisions(bpm_and_time_signature_to_durations(time_input))
	play_metronome(sixtyfourth_sound_on, 5, -10)
	play_metronome(measure_sound_on, 1, 0)

##
## METRONOME ALGORITHM
##

func bpm_and_time_signature_to_durations(time_input: Dictionary) -> Dictionary:
	var time_signature := {}
	time_signature.beat_duration = (60.0 / float(time_input.bpm_input)) * (4.0 / float(time_input.beat_input))
	time_signature.measure_duration = time_signature.beat_duration * time_input.bar_input
	time_signature.beats_per_measure = time_input.bar_input
	time_signature.bar_length = time_input.beat_input
	return time_signature

func durations_to_tempo_subdivisions(time_signature: Dictionary) -> Dictionary:
	# half seems to have exceptions  in DAW(in 3/4 for example), here it's simply 2 x quarts
	var d = {}
	d.full = time_signature.measure_duration
	d.half = time_signature.beat_duration * 2
	d.quart = time_signature.beat_duration
	d.eight = d.quart / 2.0
	d.sixteenth = d.eight / 2.0
	d.thirtysecond = d.sixteenth / 2.0
	d.sixtyfourth = d.thirtysecond / 2.0
	d.hundredtwentyeight = d.sixtyfourth / 2.0
	d.beat_duration = time_signature.beat_duration
	d.beats_per_measure = time_signature.beats_per_measure
	d.bar_length = time_signature.bar_length
	d.delay = 0
	return d

func count_tempo(delta: float) -> void:
	delta_accumulator += delta
	var m = Metronome
	
	if delta_accumulator >= m.time.sixtyfourth:
		m.time.delay = delta_accumulator - m.time.sixtyfourth
		delta_accumulator = 0.0
		m.tempo.sixtyfourth += 1
		play_metronome(sixtyfourth_sound_on, 5, -10)
		
		if m.tempo.sixtyfourth > m.time.bar_length:
			m.tempo.sixteenth += 1
			m.tempo.sixtyfourth = 1
			play_metronome(sixteenth_sound_on, 4, -10)
		if m.tempo.sixteenth > m.time.bar_length:
			m.tempo.quart += 1
			m.tempo.sixteenth = 1
			play_metronome(quart_sound_on, 2, -5)
		if m.tempo.quart > m.time.beats_per_measure:
			m.tempo.full += 1
			m.tempo.quart = 1
			play_metronome(measure_sound_on, 1, 0)

##
# METRONOME TOOLS
##

func reset_measure_tempo() -> Dictionary:
	var d = {}
	d.full = 1
	d.quart = 1
	d.sixteenth = 1
	d.sixtyfourth = 1
	return d

func reset_measure_time() -> Dictionary:
	var d = {}
	d.full = 0
	d.half = 0
	d.quart = 0
	d.eight = 0
	d.sixteenth = 0
	d.thirtysecond = 0
	d.sixtyfourth = 0
	d.beat_signature = 0
	d.bar_signature = 0
	return d

func play_metronome(is_on: bool, pitch: float, volume: float) -> void:
	if is_on:
		clic.pitch_scale = pitch
		clic.volume_db = volume
		clic.play()

func tempo_to_array() -> Array:
	return Metronome.tempo.values()

func tempo_to_time(tempo_array: Array) -> float:
	# take signature into account
	var bar = (tempo_array[0] - 1) * Metronome.time.full
	var quart = (tempo_array[1] - 1) * Metronome.time.quart
	var sixt = (tempo_array[2] - 1) * Metronome.time.sixteenth
	var thirt = (tempo_array[3] - 1) * Metronome.time.sixtyfourth
	return bar + quart + sixt + thirt

##
# UI LOGIC
##

func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var time_input := {
			bpm_input = int(bpm_text_input.text),
			bar_input = int(bar_signature.text),
			beat_input = int(beat_signature.text)
		}
		
		if check_inputs(time_input):
			getset_tempo_data(time_input)
			set_physics_process(true)
			btn.text = "Stop"
		else:
			label.text = "Please enter a correct value"
			button_pressed = !button_pressed
			btn.pressed = false
			btn.text = "Start"
	else: 
		set_physics_process(false)
		Metronome.time = reset_measure_time()
		Metronome.tempo = reset_measure_tempo()
		btn.text = "Start"

func _on_check_measure_toggled(button_pressed: bool) -> void:
	measure_sound_on = button_pressed

func _on_check_quart_toggled(button_pressed: bool) -> void:
	quart_sound_on = button_pressed

func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
	sixteenth_sound_on = button_pressed

func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
	sixtyfourth_sound_on = button_pressed
