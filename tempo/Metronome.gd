extends Node
class_name Metronome, "res://tempo/metronome.png"

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

# Put Metronome dictionary in its own script module
var Metronome := {
	subdivisions = {
		full = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		half = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		quart = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		eight = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		sixteenth = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		thirtysecond = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		sixtyfourth = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
		hundredtwentyeight = {
			duration = 0.0,
			tempo_count = 1,
			threshold = 0
			},
	},
	info = {
		bpm = 0,
		beats_per_bar = 0,
		beat_length = "",
		delay = 0.0,
		delta = 0.0,
		delta_accumulator = 0.0,
		thirty_two_accumulator = 1,
		smallest_subdivision = ""
	}
}

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
	var check_status = false
	
	# array of possible beat signature types, power of 2's
	for i in [4, 2, 8, 16, 32, 64]:
		if time_input.beat_length == i: check_status = true
	
	if time_input.bpm and time_input.beats_per_bar and time_input.beat_length and check_status:
		return true
	else: return false

func set_tempo_data(time_input) -> void:
	Metronome.info.bpm = time_input.bpm
	Metronome.info.beats_per_bar = time_input.beats_per_bar
	Metronome.info.beat_length = str("1/", time_input.beat_length)
	beat_duration_to_subdivisions_duration(time_signature_to_beat_duration(time_input))
	Metronome.info.smallest_subdivision = find_smallest_subdivision(Metronome.subdivisions)
	Metronome.info.delta = get_physics_process_delta_time()

## ALGORITHM

func time_signature_to_beat_duration(tempo_data: Dictionary) -> float:
	return (60.0 / float(tempo_data.bpm)) * (4.0 / float(tempo_data.beat_length))

func beat_duration_to_subdivisions_duration(beat_duration: float) -> void:
	var d = Metronome.subdivisions
	
	d.full.duration = beat_duration * Metronome.info.beats_per_bar
	d.half.duration = beat_duration * 2
	
	d.quart.duration = beat_duration
	d.quart.threshold = Metronome.info.beats_per_bar
	
	d.eight.duration = d.quart.duration / 2.0
	d.eight.threshold = 4
	
	d.sixteenth.duration = d.eight.duration / 2.0
	d.sixteenth.threshold = 4
	
	d.thirtysecond.duration = d.sixteenth.duration / 2.0
	d.thirtysecond.threshold = 4
	
	d.sixtyfourth.duration = d.thirtysecond.duration / 2.0
	d.sixtyfourth.threshold = 4
	
	d.hundredtwentyeight.duration = d.sixtyfourth.duration / 2.0
	d.hundredtwentyeight.threshold = 2

func find_smallest_subdivision(metronome_subdivisions: Dictionary) -> String:
	var delta := get_physics_process_delta_time()
	var smallest_subdivision := ""
	
	if metronome_subdivisions.hundredtwentyeight.duration >= delta:
		smallest_subdivision = "hundredtwentyeight"
	elif metronome_subdivisions.sixtyfourth.duration >= delta:
		smallest_subdivision = "sixtyfourth"
	elif metronome_subdivisions.sixteenth.duration >= delta:
		smallest_subdivision = "sixteenth"

	return smallest_subdivision

#func tempo_iterator():
	# if subdivision[i].counter > subdivision[i].threshold:
	#	subdivision[i + 2].counter += 1
	#	subdivision[i].counter = 1
	#	play_metronome(subdivision[i].play_settings)

func count_tempo() -> void:
	# get smallest_subdivision index for array incrementations (i+2)
	# Metronome.subdivisions.values()[0].tempo_count, how to get index from name
	# or maybe don't get name but index in find_smallest_subdivision
	
	var m = Metronome.info
	var smallest_subdivision = Metronome.subdivisions[m.smallest_subdivision]
	m.delta_accumulator += m.delta
	
	if m.delta_accumulator >= smallest_subdivision.duration:
		
		m.delay = m.delta_accumulator - smallest_subdivision.duration
		m.delta_accumulator = 0.0 + m.delay
		
		smallest_subdivision.tempo_count += 1
		m.thirty_two_accumulator += 1

		if smallest_subdivision.tempo_count > smallest_subdivision.threshold:
			print('up')
		

# TOOLS

func start_metronome() -> void:
	metronome_is_on = true
	set_physics_process(true)
	play_metronome(sixtyfourth_sound_on, 5, -10)
	play_metronome(measure_sound_on, 1, 0)

func stop_metronome() -> void:
	metronome_is_on = false
	set_physics_process(false)
#	reset_metronome()

func reset_metronome() -> void:
	for key in Metronome.tempo:
		Metronome.tempo[key] = 1
	for key in Metronome.time:
		Metronome.time[key] = 0.0

func play_metronome(is_on: bool, pitch: float, volume: float) -> void:
	if is_on:
		clic.pitch_scale = pitch
		clic.volume_db = volume
		clic.play()

func tempo_to_array(type: String) -> Array:
	var array := []
	if type == "primary":
		array = [
			Metronome.subdivisions.values()[0].tempo_count,
			Metronome.subdivisions.values()[2].tempo_count,
			Metronome.subdivisions.values()[4].tempo_count,
			Metronome.subdivisions.values()[6].tempo_count
		]
	elif type == "secondary":
		array = [
			Metronome.subdivisions.values()[1].tempo_count,
			Metronome.subdivisions.values()[3].tempo_count,
			Metronome.subdivisions.values()[5].tempo_count,
			Metronome.subdivisions.values()[7].tempo_count
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
			bpm = int(bpm_text_input.text),
			beats_per_bar = int(bar_signature.text),
			beat_length = int(beat_signature.text)
		}
		
		if check_inputs(time_input):
			set_tempo_data(time_input)
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


#func count_tempo() -> void:
#	# adapt to FPS & BPM : if 1/128 < delta, test 1/64, if still smaller, use 1/16 counting
#	# get m.time smallest subdivision after checking FPS
#	# get m.time.delay
#	# then use only m.tempo in function
#	# add for each subdivision its threshold and play arguments
#	# add smallest name in m.tempo
#	# how to do with thirty_two_counter ?
#
#	delta_accumulator += get_physics_process_delta_time()
#	var m = Metronome
##	m.time[m.time.smallest_subdivision]
#
#	if delta_accumulator >= m.time.hundredtwentyeight:
#		# replace m.time.hundredtwentyeight by smallest_subdivision
#
#		m.time.delay = delta_accumulator - m.time.hundredtwentyeight
#		delta_accumulator = 0.0 + m.time.delay
#
#		m.tempo.hundredtwentyeight += 1
#		thirty_two_counter += 1
#
#		# for i in subdivision:
#			# count(subdivision):
#			# if subdivision[i].counter > subdivision[i].threshold:
#			#	subdivision[i + 2].counter += 1
#			#	subdivision[i].counter = 1
#			#	play_metronome(subdivision[i].play)
#
#		# if delta < m.time.hundredtwentyeight:
#		#	smallest = m.time.hundredtwentyeight
#		# elif delta < m.time.sixtyfourth:
#		#	smallest = m.time.sixtyfourth
#		# else: smallest = m.time.sixteenth
#
#		if m.tempo.hundredtwentyeight > 2:
#			m.tempo.sixtyfourth += 1
#			m.tempo.hundredtwentyeight = 1
#			play_metronome(sixtyfourth_sound_on, 12, -12)
#		if thirty_two_counter > 4:
#			m.tempo.thirtysecond += 1
#			thirty_two_counter = 1
#			play_metronome(thirtysecond_sound_on, 10, -10)
#		if m.tempo.sixtyfourth > 4:
#			m.tempo.sixteenth += 1
#			m.tempo.sixtyfourth = 1
#			play_metronome(sixteenth_sound_on, 8, -8)
#		if m.tempo.thirtysecond > 4:
#			m.tempo.eight += 1
#			m.tempo.thirtysecond = 1
#			play_metronome(eight_sound_on, 6, -6)
#		if m.tempo.sixteenth > 4:
#			m.tempo.quart += 1
#			m.tempo.sixteenth = 1
#			play_metronome(quart_sound_on, 4, -4)
#		if m.tempo.eight > 4:
#			m.tempo.half += 1
#			m.tempo.eight = 1
#			play_metronome(half_sound_on, 2, -2)
#		if m.tempo.quart > m.tempo.beats_per_measure:
#			m.tempo.full += 1
#			m.tempo.quart = 1
#			m.tempo.half = 1
#			play_metronome(measure_sound_on, 1, 0)
