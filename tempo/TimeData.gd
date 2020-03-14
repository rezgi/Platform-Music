extends Node

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome tool
- Custom BPM & time signature
- Tempo subdivision up to 128 per measure
- Tempo format : [measure, quart, sixteenth, sixtyfourth] -> [1, 4, 4, 4]
- Input fields : BPM / time signature / metronome clicks on subdivisions / tempo display
- Methods : get & set tempo, tempo to time, time to tempo
"""

# Tempo algorithm
	# Make metronome adapt to FPS & BPM : if 1/128 < delta, test 1/64, if still smaller, use 1/16 counting
	# have 2 tempo displays : [1, 1/4, 1/16, 1/64] & [1/2, 1/8, 1/32, 1/128]
	# Make better counting code since lots of repetitions and conditions with regular parameters
	# how to implement dotted time ? can add secondary tempo to primary : prim[1] + sec[1] : 1/4 + 1/8
# Create a tempo <> time converter
	# tempo to time needs to take into account signature, works only for 4/4 now
# Cosmetic changes
	# one field for time signature ?
	# make field text all selected when click on it
	# rename scene to 'Metronome' and give class_name & icon
	# delete old tempo.tscn & its script
# Code design
	# Metronome dict is accessed globaly, pass it to funcs using it maybe
	# modulate script : signals / UI inputs / tempo. leave only main logic and exposed methods in here
	# gather all buttons & text input signals and combine them into one signal, procedural
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
var thirty_two_counter := 1
var possible_beats := [4, 2, 8, 16, 32, 64]
var metronome_is_on := false

var measure_sound_on := false
var half_sound_on := false
var quart_sound_on := false
var eight_sound_on := false
var sixteenth_sound_on := false
var thirtysecond_sound_on := false
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

func _physics_process(_delta: float) -> void:
	if metronome_is_on:
		count_tempo()
		label.text = "%s\n%s" % [str(tempo_to_array("primary")), str(tempo_to_array("secondary"))]

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
	# return Metronome dict
	Metronome.time = durations_to_tempo_subdivisions(bpm_and_time_signature_to_durations(time_input))

##
## METRONOME ALGORITHM
##

func bpm_and_time_signature_to_durations(time_input: Dictionary) -> Dictionary:
	var time_signature := {}
	time_signature.beat_duration = (60.0 / float(time_input.bpm_input)) * (4.0 / float(time_input.beat_input))
	time_signature.measure_duration = time_signature.beat_duration * time_input.bar_input
	time_signature.beats_per_measure = time_input.bar_input
	time_signature.bar_length = time_input.beat_input
	time_signature.bpm = time_input.bpm_input
	return time_signature

func durations_to_tempo_subdivisions(time_signature: Dictionary) -> Dictionary:
	# half needs more precise work (3/4 problem)
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
	d.bpm = time_signature.bpm
	d.delay = 0
	
	return d

func count_tempo() -> void:
	# make better code to avoid repeating conditions and better flexibility
	
	delta_accumulator += get_physics_process_delta_time()
	var m = Metronome
	
	if delta_accumulator >= m.time.hundredtwentyeight:
		
		m.time.delay = delta_accumulator - m.time.hundredtwentyeight
		delta_accumulator = 0.0 + m.time.delay
		
		m.tempo.hundredtwentyeight += 1
		thirty_two_counter += 1
		
		if m.tempo.hundredtwentyeight > 2:
			m.tempo.sixtyfourth += 1
			m.tempo.hundredtwentyeight = 1
			play_metronome(sixtyfourth_sound_on, 12, -12)
		if thirty_two_counter > 4:
			m.tempo.thirtysecond += 1
			thirty_two_counter = 1
			play_metronome(thirtysecond_sound_on, 10, -10)
		if m.tempo.sixtyfourth > 4:
			m.tempo.sixteenth += 1
			m.tempo.sixtyfourth = 1
			play_metronome(sixteenth_sound_on, 8, -8)
		if m.tempo.thirtysecond > 4:
			m.tempo.eight += 1
			m.tempo.thirtysecond = 1
			play_metronome(eight_sound_on, 6, -6)
		if m.tempo.sixteenth > 4:
			m.tempo.quart += 1
			m.tempo.sixteenth = 1
			play_metronome(quart_sound_on, 4, -4)
		if m.tempo.eight > 4:
			m.tempo.half += 1
			m.tempo.eight = 1
			play_metronome(half_sound_on, 2, -2)
		if m.tempo.quart > m.time.beats_per_measure:
			m.tempo.full += 1
			m.tempo.quart = 1
			m.tempo.half = 1
			play_metronome(measure_sound_on, 1, 0)

##
# METRONOME TOOLS
##

func start_metronome() -> void:
	metronome_is_on = true
	set_physics_process(true)
	play_metronome(sixtyfourth_sound_on, 5, -10)
	play_metronome(measure_sound_on, 1, 0)

func stop_metronome() -> void:
	metronome_is_on = false
	set_physics_process(false)
	Metronome.time = reset_measure_time()
	Metronome.tempo = reset_measure_tempo()

func reset_measure_tempo() -> Dictionary:
	# primary tempo, maybe add another secondary (1/2, 1/8, 1/32, 1/128) tempo with other func
	# base_4 : [1, 1/4, 1/16, 1/64]
	# base_2 : [1/2, 1/8, 1/32, 1/128]
	var d = {}
	d.full = 1
	d.half = 1
	d.quart = 1
	d.eight = 1
	d.sixteenth = 1
	d.thirtysecond = 1
	d.sixtyfourth = 1
	d.hundredtwentyeight = 1
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
	d.hundredtwentyeight = 0
	
	d.beat_signature = 0
	d.bar_signature = 0
	d.bpm = 0
	
	return d

func play_metronome(is_on: bool, pitch: float, volume: float) -> void:
	# take an named enum or dict for clearer arguments
	if is_on:
		clic.pitch_scale = pitch
		clic.volume_db = volume
		clic.play()

func tempo_to_array(type: String) -> Array:
	var array := []
	if type == "primary":
		array = [
			Metronome.tempo.values()[0],
			Metronome.tempo.values()[2],
			Metronome.tempo.values()[4],
			Metronome.tempo.values()[6]
		]
	elif type == "secondary":
		array = [
			Metronome.tempo.values()[1],
			Metronome.tempo.values()[3],
			Metronome.tempo.values()[5],
			Metronome.tempo.values()[7]
		]
	return array

func tempo_to_time(tempo_array: Array) -> float:
	# take signature into account
	# take either dict or array
	# consider primary & secondary tempo
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
			start_metronome()
			btn.text = "Stop"
		else:
			label.text = "Please enter a correct value"
			button_pressed = !button_pressed
			btn.pressed = false
			btn.text = "Start"
	else: 
		stop_metronome()
		btn.text = "Start"

func _on_check_measure_toggled(button_pressed: bool) -> void:
	measure_sound_on = button_pressed

func _on_check_half_toggled(button_pressed: bool) -> void:
	half_sound_on = button_pressed

func _on_check_quart_toggled(button_pressed: bool) -> void:
	quart_sound_on = button_pressed

func _on_check_eight_toggled(button_pressed: bool) -> void:
	eight_sound_on = button_pressed

func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
	sixteenth_sound_on = button_pressed

func _on_check_thirtytwo_toggled(button_pressed: bool) -> void:
	thirtysecond_sound_on = button_pressed

func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
	sixtyfourth_sound_on = button_pressed
