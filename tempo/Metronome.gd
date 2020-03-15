extends Node
class_name Metronome, "res://tempo/tempo.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome tool
- Custom BPM & time signature
- Tempo subdivision up to 128 per measure
- Tempo format : [measure, quart, sixteenth, sixtyfourth] -> [1, 4, 4, 4]
- Input fields : BPM / time signature / metronome clicks on subdivisions / tempo display
- Methods : get & set tempo, tempo to time, time to tempo
"""

onready var bpm_text_input := $CenterContainer/VBoxContainer/BPMInput
onready var bar_signature := $CenterContainer/VBoxContainer/HBoxContainer/BarSignature
onready var beat_signature := $CenterContainer/VBoxContainer/HBoxContainer/BeatSignature
onready var btn := $CenterContainer/VBoxContainer/StartButton
onready var label := $CenterContainer/VBoxContainer/TempoDisplay
onready var clic := $AudioStreamPlayer

var Metronome := {
	tempo = {
		full = 1,
		half = 1,
		quart = 1,
		eight = 1,
		sixteenth = 1,
		thirtysecond = 1,
		sixtyfourth = 1,
		hundredtwentyeight = 1
	},
	time = {
		full = 0.0,
		half = 0.0,
		quart = 0.0,
		eight = 0.0,
		sixteenth = 0.0,
		thirtysecond = 0.0,
		sixtyfourth = 0.0,
		hundredtwentyeight = 0.0,
		beat_duration = 0.0,
		
		beats_per_measure = 0,
		bar_length = 0,
		bpm = 0,
		delay = 0.0
	}
}

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

## RUN

func _ready() -> void:
	set_physics_process(false)
	measure_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_measure.pressed
	quart_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_quart.pressed

func _physics_process(_delta: float) -> void:
	if metronome_is_on:
		count_tempo()
		label.text = "%s\n%s" % [str(tempo_to_array("primary")), str(tempo_to_array("secondary"))]

## INPUT

func check_inputs(time_input: Dictionary) -> bool:
	var beat_is_ok = false
	for i in possible_beats:
		if time_input.beat_input == i:
			beat_is_ok = true
	
	if time_input.bpm_input and time_input.bar_input and time_input.beat_input and beat_is_ok:
		return true
	else: return false

func getset_tempo_data(time_input) -> Dictionary:
	Metronome.tempo.beats_per_measure = time_input.bar_input
	Metronome.tempo.bar_length = time_input.beat_input
	Metronome.tempo.bpm = time_input.bpm_input
	Metronome.time = durations_to_tempo_subdivisions(bpm_and_time_signature_to_durations(time_input))
	return Metronome

## ALGORITHM

func bpm_and_time_signature_to_durations(time_input: Dictionary) -> float:
	return (60.0 / float(time_input.bpm_input)) * (4.0 / float(time_input.beat_input))

func durations_to_tempo_subdivisions(beat_duration: float) -> Dictionary:
	var d = {}
	d.full = beat_duration * Metronome.tempo.beats_per_measure
	d.half = beat_duration * 2
	d.quart = beat_duration
	d.eight = d.quart / 2.0
	d.sixteenth = d.eight / 2.0
	d.thirtysecond = d.sixteenth / 2.0
	d.sixtyfourth = d.thirtysecond / 2.0
	d.hundredtwentyeight = d.sixtyfourth / 2.0
	d.beat_duration = beat_duration
	return d

func count_tempo() -> void:
	# adapt to FPS & BPM : if 1/128 < delta, test 1/64, if still smaller, use 1/16 counting
	# get m.time smallest subdivision after checking FPS
	# get m.time.delay
	# then use only m.tempo in function
	# add for each subdivision its threshold and play arguments
	# add smallest name in m.tempo
	# how to do with thirty_two_counter ?
	
	delta_accumulator += get_physics_process_delta_time()
	var m = Metronome
	
	if delta_accumulator >= m.time.hundredtwentyeight:
		
		m.time.delay = delta_accumulator - m.time.hundredtwentyeight
		delta_accumulator = 0.0 + m.time.delay
		
		m.tempo.hundredtwentyeight += 1
		thirty_two_counter += 1
		
		# for i in subdivision:
			# count(subdivision):
			# if subdivision[i].counter > subdivision[i].threshold:
			#	subdivision[i + 2].counter += 1
			#	subdivision[i].counter = 1
			#	play_metronome(subdivision[i].play)
		
		# if delta < m.time.hundredtwentyeight:
		#	smallest = m.time.hundredtwentyeight
		# elif delta < m.time.sixtyfourth:
		#	smallest = m.time.sixtyfourth
		# else: smallest = m.time.sixteenth
		
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
		if m.tempo.quart > m.tempo.beats_per_measure:
			m.tempo.full += 1
			m.tempo.quart = 1
			m.tempo.half = 1
			play_metronome(measure_sound_on, 1, 0)

# TOOLS

func start_metronome() -> void:
	metronome_is_on = true
	set_physics_process(true)
	play_metronome(sixtyfourth_sound_on, 5, -10)
	play_metronome(measure_sound_on, 1, 0)

func stop_metronome() -> void:
	metronome_is_on = false
	set_physics_process(false)
	reset_metronome()

func reset_metronome() -> void:
	for key in Metronome.tempo:
		Metronome.tempo[key] = 1
	for key in Metronome.time:
		Metronome.time[key] = 0.0

func play_metronome(is_on: bool, pitch: float, volume: float) -> void:
	# take an named enum or dict for clearer arguments
	# move this function to the UI section and module
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

# UI

func _on_Button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		
		var time_input := {
			bpm_input = int(bpm_text_input.text),
			bar_input = int(bar_signature.text),
			beat_input = int(beat_signature.text)
		}
		
		if check_inputs(time_input):
# warning-ignore:return_value_discarded
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
