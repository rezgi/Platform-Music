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
	# delta is too big, still figuring out
	# count of signatures like 4/2 isn't working the right way, refactor tempo count
	# better use of Metronome.time elements to trigger beats increment
	# gone down to 128, test its use
	# how to use 1/2, 1/8, 1/32, maybe will work with new data structure
	# have 2 tempo displays : [1, 1/4, 1/16, 1/64] & [1/2, 1/8, 1/32, 1/128]
	# how to implement dotted time ? can add secondary tempo to primary : prim[1] + sec[1] : 1/4 + 1/8
# Create a tempo <> time converter
	# tempo to time needs to take into account signature, works only for 4/4 now
# Cosmetic changes
	# one field for time signature ?
	# rename scene to 'Metronome' and give class_name & icon
	# delete old tempo.tscn & its script
# Code design
	# Metronome dict is accessed globaly, pass it to funcs using it
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
var possible_beats := [4, 2, 8, 16, 32, 64]
var metronome_is_on := false

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

func _physics_process(_delta: float) -> void:
	if metronome_is_on:
		count_tempo()
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
	print(d)
	
	return d

func count_tempo() -> void:
	
	# 128 is too small for _process which has a minimum of 0.016667 (delta) at 60 FPS
	# use 128 only for time computation : 64th dotted / grid subdivisions
	# delay problem : tempo isn't updated if < 110 && > 226 BPM because of delay size, delta is too big
	# don't go under 16th when some BPM is reached ?
	# Tried animationPlayer, buggy
	# setting the project FPS to 120 instead of 60 reduces delta, ask about it
	# FPS is currently set to 120, don't forget
	# maybe take only intervals, like between 128 and 64 for example : if < 128, 128 + 1, if > 128 && < 64, 64 + 1
	
	delta_accumulator += get_physics_process_delta_time()
	var m = Metronome
	
	print("delta : ", get_physics_process_delta_time())
	print("delta_acc : ", delta_accumulator)
	print("128th : ", m.time.hundredtwentyeight)
	print("64th : ", m.time.sixtyfourth)
	print("32nd : ", m.time.thirtysecond)
	print("16th : ", m.time.sixteenth)
	print("--")
	if delta_accumulator >= m.time.sixtyfourth:
		m.time.delay = delta_accumulator - m.time.sixtyfourth
#		print("delay : ", m.time.delay)
		delta_accumulator = 0.0
		m.tempo.sixtyfourth += 1
		play_metronome(sixtyfourth_sound_on, 5, -10)
		
		if m.tempo.sixtyfourth > 4.0:
			m.tempo.sixteenth += 1
			m.tempo.sixtyfourth = 1
			play_metronome(sixteenth_sound_on, 4, -10)
		if m.tempo.sixteenth > 4.0:
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
	# primary tempo, maybe add another secondary tempo with other func
	var d = {}
	d.full = 1
#	d.half = 1
	d.quart = 1
#	d.eight = 1
	d.sixteenth = 1
#	d.thirtysecond = 1
	d.sixtyfourth = 1
#	d.hundredtwentyeight = 1
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

func tempo_to_array() -> Array:
	# separate array types : primary & secondary
	return Metronome.tempo.values()

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

func _on_check_quart_toggled(button_pressed: bool) -> void:
	quart_sound_on = button_pressed

func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
	sixteenth_sound_on = button_pressed

func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
	sixtyfourth_sound_on = button_pressed
