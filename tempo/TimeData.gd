extends Node

# measure.quart.sixteenth.sixtyfourth > 1.1.1.1 to 1.4.4.4
# binary has 4 quarts, ternay has 3 thirds > binary : 1.4.4.4 / ternary : 1.3.4.4

onready var line_edit := $CenterContainer/VBoxContainer/LineEdit
onready var btn := $CenterContainer/VBoxContainer/Button
onready var label := $CenterContainer/VBoxContainer/Label
onready var clic := $AudioStreamPlayer

var measure := {}
var delta_accumulator := 0.0

func _ready() -> void:
	set_physics_process(false)
	measure.time = reset_measure_time()
	measure.tempo = reset_measure_tempo()

func _physics_process(delta: float) -> void:
	if btn.pressed:
		count_tempo(delta)
		label.text = str("%s . %s . %s . %s \n delay : %s" % [
			measure.tempo.full,
			measure.tempo.quart,
			measure.tempo.sixteenth,
			measure.tempo.sixtyfourth,
			measure.time.delay
		])

func _on_Button_toggled(button_pressed)->void:
	if button_pressed:
		btn.text = "Stop"
		
		var bpm_input = int(line_edit.text)
		var measure_duration = bpm_to_measure_duration(bpm_input)
		measure.time = subdivide_tempo_to_time(measure_duration)
		
		set_physics_process(true)
	else: 
		set_physics_process(false)
		measure.time = reset_measure_time()
		measure.tempo = reset_measure_tempo()
		btn.text = "Start"

func count_tempo(delta)->void:
	delta_accumulator += delta
	
	if delta_accumulator >= measure.time.sixtyfourth:
		clic.play()
		measure.time.delay = delta_accumulator - measure.time.sixtyfourth
		delta_accumulator = 0.0
		measure.tempo.sixtyfourth += 1
		
		if measure.tempo.sixtyfourth > 4:
			measure.tempo.sixteenth += 1
			measure.tempo.sixtyfourth = 1
		if measure.tempo.sixteenth > 4:
			measure.tempo.quart += 1
			measure.tempo.sixteenth = 1
		if measure.tempo.quart > 4:
			measure.tempo.full += 1
			measure.tempo.quart = 1

func reset_measure_tempo()->Dictionary:
	var d = {}
	d.full = 1
	d.quart = 1
	d.sixteenth = 1
	d.sixtyfourth = 1
	return d

func reset_measure_time()->Dictionary:
	var d = {}
	d.full = 0
	d.half = 0
	d.quart = 0
	d.eight = 0
	d.sixteenth = 0
	d.thirtysecond = 0
	d.sixtyfourth = 0
	return d

func bpm_to_measure_duration(bpm)->float:
	return 60.0 / (bpm / 4.0)

func subdivide_tempo_to_time(measure_duration)->Dictionary:
	var d = {}
	d.full = measure_duration
	d.half = measure_duration / 2.0
	d.quart = measure_duration / 4.0
	d.eight = measure_duration / 8.0
	d.sixteenth = measure_duration / 16.0
	d.thirtysecond = measure_duration / 32.0
	d.sixtyfourth = measure_duration / 64.0
	d.delay = 0
	return d
