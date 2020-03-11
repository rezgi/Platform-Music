extends Node

# measure.quart.sixteenth.sixtyfourth > 1.1.1.1 to 1.4.4.4
# binary has 4 quarts, ternay has 3 thirds > binary : 1.4.4.4 / ternary : 1.3.4.4
# create a tempo <> time converter
# how to use 1/2, 1/8, 1/32
# how to implement dotted time

onready var line_edit := $CenterContainer/VBoxContainer/LineEdit
onready var btn := $CenterContainer/VBoxContainer/Button
onready var label := $CenterContainer/VBoxContainer/Label
onready var beat_signature := $CenterContainer/VBoxContainer/HBoxContainer/QuartSignature
onready var bar_signature := $CenterContainer/VBoxContainer/HBoxContainer/BeatSignature
onready var clic := $AudioStreamPlayer

var measure := {}
var delta_accumulator := 0.0
var measure_sound_on := false
var quart_sound_on := false
var sixteenth_sound_on := false
var sixtyfourth_sound_on := false

func _ready() -> void:
	set_physics_process(false)
	measure.time = reset_measure_time()
	measure.tempo = reset_measure_tempo()
	measure_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_measure.pressed
	quart_sound_on = $CenterContainer/VBoxContainer/VBoxContainer/check_quart.pressed

func _physics_process(delta: float) -> void:
	if btn.pressed:
		count_tempo(delta)
		label.text = str(tempo_to_array())

func _on_check_measure_toggled(button_pressed: bool) -> void:
	measure_sound_on = button_pressed

func _on_check_quart_toggled(button_pressed: bool) -> void:
	quart_sound_on = button_pressed

func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
	sixteenth_sound_on = button_pressed

func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
	sixtyfourth_sound_on = button_pressed

func _on_Button_toggled(button_pressed) -> void:
	if button_pressed:
		if get_and_set_tempo_data():
			set_physics_process(true)
			btn.text = "Stop"
		else:
			label.text = "Please enter a correct value"
			button_pressed = !button_pressed
			btn.pressed = false
			btn.text = "Start"
	else: 
		set_physics_process(false)
		measure.time = reset_measure_time()
		measure.tempo = reset_measure_tempo()
		btn.text = "Start"

func get_and_set_tempo_data() -> bool:
	var bpm_input = int(line_edit.text)
	var quart_input = int(beat_signature.text)
	var beat_input = int(bar_signature.text)
	
	if bpm_input and quart_input and beat_input:
		measure.time = subdivide_tempo_to_time(
			bpm_to_measure_duration(bpm_input), 
			quart_input, 
			beat_input
			)
		
		play_metronome(sixtyfourth_sound_on, 5, -10)
		play_metronome(measure_sound_on, 1, 0)
		return true
	else: return false

func count_tempo(delta) -> void:
	delta_accumulator += delta
	
	if delta_accumulator >= measure.time.sixtyfourth:
		measure.time.delay = delta_accumulator - measure.time.sixtyfourth
		delta_accumulator = 0.0
		measure.tempo.sixtyfourth += 1
		play_metronome(sixtyfourth_sound_on, 5, -10)
		
		if measure.tempo.sixtyfourth > measure.time.bar_signature:
			measure.tempo.sixteenth += 1
			measure.tempo.sixtyfourth = 1
			play_metronome(sixteenth_sound_on, 4, -10)
		if measure.tempo.sixteenth > measure.time.bar_signature:
			measure.tempo.quart += 1
			measure.tempo.sixteenth = 1
			play_metronome(quart_sound_on, 2, -5)
		if measure.tempo.quart > measure.time.beat_signature:
			measure.tempo.full += 1
			measure.tempo.quart = 1
			play_metronome(measure_sound_on, 1, 0)

func bpm_to_measure_duration(bpm) -> float:
	return 60.0 / (bpm / 4.0)

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

func subdivide_tempo_to_time(measure_duration, quart_input, beat_input) -> Dictionary:
	var d = {}
	d.full = measure_duration
	d.half = measure_duration / 2.0
	d.quart = measure_duration / 4.0
	d.eight = measure_duration / 8.0
	d.sixteenth = measure_duration / 16.0
	d.thirtysecond = measure_duration / 32.0
	d.sixtyfourth = measure_duration / 64.0
	d.beat_signature = quart_input
	d.bar_signature = beat_input
	d.delay = 0
	return d

func play_metronome(is_on: bool, pitch: float, volume: float) -> void:
	if is_on:
		clic.pitch_scale = pitch
		clic.volume_db = volume
		clic.play()

func tempo_to_array() -> Array:
	return measure.tempo.values()

func tempo_to_time():
	pass

func time_to_tempo():
	pass

func dot_time():
	pass
