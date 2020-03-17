extends Node
class_name Metronome, "res://metronome/metronome.png"

"""
Tempo and Time algorithm, root of the rythmic design.

- Metronome tool
- Custom BPM & time signature
- Tempo subdivision up to 128 per measure depending on delta
- 2 Tempo formats : [measure, quart, sixteenth, sixtyfourth] - [half, eight, thirtysecond, hundredtwentyeight]
- Metronome clic sounds from checked UI buttons
- Methods : get & set tempo, tempo to time, time to tempo
"""

onready var bpm_text_input := $CenterContainer/VBoxContainer/BPMInput
onready var bar_signature := $CenterContainer/VBoxContainer/HBoxContainer/BarSignature
onready var beat_signature := $CenterContainer/VBoxContainer/HBoxContainer/BeatSignature
onready var btn := $CenterContainer/VBoxContainer/StartButton
onready var label := $CenterContainer/VBoxContainer/TempoDisplay
onready var clic := $AudioStreamPlayer

var module = preload("res://metronome/metronome_default_dictionary.gd")
var Metronome = module.get_default_metronome_dictionary()

## RUN

func _ready() -> void:
	set_physics_process(false)
	Metronome.subdivisions.full.sound.on = $CenterContainer/VBoxContainer/VBoxContainer/check_measure.pressed
	Metronome.subdivisions.quart.sound.on = $CenterContainer/VBoxContainer/VBoxContainer/check_quart.pressed

func _physics_process(_delta: float) -> void:
	if Metronome.info.metronome_is_on:
		count_tempo()
		label.text = display_tempo()

## PARSER

func check_inputs(time_input: Dictionary) -> bool:
	var check_status = false
	
	# array of possible beat signature types, power of 2's
	for i in [4, 2, 8, 16, 32, 64]:
		if time_input.beat_length == i: check_status = true
	
	if time_input.bpm and time_input.beats_per_bar and time_input.beat_length and check_status:
		return true
	else: return false

func time_signature_to_beat_duration(time_input: Dictionary) -> float:
	return (60.0 / float(time_input.bpm)) * (4.0 / float(time_input.beat_length))

func beat_duration_to_subdivisions_duration(beat_duration: float) -> void:
	var d = Metronome.subdivisions
	d.full.duration = beat_duration * Metronome.info.beats_per_bar
	d.half.duration = beat_duration * 2
	d.quart.duration = beat_duration
	d.quart.threshold = Metronome.info.beats_per_bar
	d.eight.duration = d.quart.duration / 2.0
	d.sixteenth.duration = d.eight.duration / 2.0
	d.thirtysecond.duration = d.sixteenth.duration / 2.0
	d.sixtyfourth.duration = d.thirtysecond.duration / 2.0
	d.hundredtwentyeight.duration = d.sixtyfourth.duration / 2.0

func set_smallest_subdivision() -> void:
	if Metronome.subdivisions.hundredtwentyeight.duration >= Metronome.info.delta:
		Metronome.info.smallest_subdivision = 7
		Metronome.info.secondary_index = 5
		print("128")
	elif Metronome.subdivisions.sixtyfourth.duration >= Metronome.info.delta:
		Metronome.info.smallest_subdivision = 6
		Metronome.info.secondary_index = 5
		print("64")
	elif Metronome.subdivisions.sixteenth.duration >= Metronome.info.delta:
		Metronome.info.smallest_subdivision = 4
		Metronome.info.secondary_index = 3
		print("16")

func set_tempo_data(time_input) -> void:
	Metronome.info.bpm = time_input.bpm
	Metronome.info.beats_per_bar = time_input.beats_per_bar
	Metronome.info.beat_length = str("1/", time_input.beat_length)
	Metronome.info.delta = get_physics_process_delta_time()
	beat_duration_to_subdivisions_duration(time_signature_to_beat_duration(time_input))
	set_smallest_subdivision()

# COUNTER

func count_tempo() -> void:
	
	var m = Metronome.info
	var subdivisions = Metronome.subdivisions.values()
	var smallest_subdivision = subdivisions[m.smallest_subdivision]
	var i = m.smallest_subdivision
	m.delta_accumulator += m.delta
	
	if m.delta_accumulator >= smallest_subdivision.duration:
		
		m.delay = m.delta_accumulator - smallest_subdivision.duration
		m.delta_accumulator = 0.0 + m.delay
		smallest_subdivision.tempo_count += 1
		m.secondary_counter += 1

		while i >= 2:
			
			if subdivisions[i].tempo_count > subdivisions[i].threshold:
				var next_index := 0
				if i == 2:
					next_index = 0
					subdivisions[1].tempo_count = 1
				elif i == 7: next_index = 6
				else: next_index = i - 2
				
				subdivisions[next_index].tempo_count += 1
				subdivisions[i].tempo_count = 1
				
				if i != 7 and subdivisions[next_index].sound.on:
					play_metronome(subdivisions[next_index].sound)
			
			if m.smallest_subdivision > m.secondary_index and \
			m.secondary_counter > subdivisions[m.secondary_index].threshold:
				
				subdivisions[m.secondary_index].tempo_count += 1
				m.secondary_counter = 1
				
				if subdivisions[m.secondary_index].sound.on :
					play_metronome(subdivisions[m.secondary_index].sound)
			
			i -= 1

# METHODS

func start_metronome() -> void:
	Metronome.info.metronome_is_on = true
	set_physics_process(true)
	play_metronome(Metronome.subdivisions.sixtyfourth.sound)
	play_metronome(Metronome.subdivisions.full.sound)

func stop_metronome() -> void:
	Metronome.info.metronome_is_on = false
#	reset_metronome()
	set_physics_process(false)

func reset_metronome() -> void:
	pass

func play_metronome(sound: Dictionary) -> void:
	if sound.on:
		clic.pitch_scale = sound.pitch
		clic.volume_db = sound.volume
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

func display_tempo() -> String:
	return "%s\n%s" % [str(tempo_to_array("primary")), str(tempo_to_array("secondary"))]

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
	Metronome.subdivisions.full.sound.on = button_pressed

func _on_check_half_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.half.sound.on = button_pressed

func _on_check_quart_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.quart.sound.on = button_pressed

func _on_check_eight_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.eight.sound.on = button_pressed

func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.sixteenth.sound.on = button_pressed

func _on_check_thirtytwo_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.thirtysecond.sound.on = button_pressed

func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
	Metronome.subdivisions.sixtyfourth.sound.on = button_pressed
