extends Node
class_name MetronomeGUI, "res://metronome/media/metronome.png"

"""
Metronome GUI

- Time signature input
- Metronome clic sounds from checked UI buttons
- Sends one signal with all input data

- Make inspector settings
- Make UI togglable + tool
"""
# on buttons pressed : send all check_buttons status and bool + signature input

onready var bpm_text_input := $CenterContainer/VBoxContainer/BPMInput
onready var bar_signature := $CenterContainer/VBoxContainer/HBoxContainer/BarSignature
onready var beat_signature := $CenterContainer/VBoxContainer/HBoxContainer/BeatSignature
onready var btn := $CenterContainer/VBoxContainer/StartButton
onready var label := $CenterContainer/VBoxContainer/TempoDisplay
onready var clic := $AudioStreamPlayer

#func _ready() -> void:
#	set_physics_process(false)
#	Metronome.subdivisions.full.sound.on = $CenterContainer/VBoxContainer/VBoxContainer/check_measure.pressed
#	Metronome.subdivisions.quart.sound.on = $CenterContainer/VBoxContainer/VBoxContainer/check_quart.pressed

#func _physics_process(_delta: float) -> void:
#	if Metronome.info.metronome_is_on:
#		count_tempo()
#		label.text = display_tempo()

#func start_metronome() -> void:
#	Metronome.info.metronome_is_on = true
#	set_physics_process(true)
#	play_metronome(Metronome.subdivisions.sixtyfourth.sound)
#	play_metronome(Metronome.subdivisions.full.sound)
#
#func stop_metronome() -> void:
#	Metronome.info.metronome_is_on = false
##	reset_metronome()
#	set_physics_process(false)
#
#func reset_metronome() -> void:
#	pass
#
#func play_metronome(sound: Dictionary) -> void:
#	if sound.on:
#		clic.pitch_scale = sound.pitch
#		clic.volume_db = sound.volume
#		clic.play()
#
#func tempo_to_array(type: String) -> Array:
#	var array := []
#	if type == "primary":
#		array = [
#			Metronome.subdivisions.values()[7].tempo_count,
#			Metronome.subdivisions.values()[5].tempo_count,
#			Metronome.subdivisions.values()[3].tempo_count,
#			Metronome.subdivisions.values()[1].tempo_count
#		]
#	elif type == "secondary":
#		array = [
#			Metronome.subdivisions.values()[6].tempo_count,
#			Metronome.subdivisions.values()[4].tempo_count,
#			Metronome.subdivisions.values()[2].tempo_count,
#			Metronome.subdivisions.values()[0].tempo_count
#		]
#	return array
#
#func display_tempo() -> String:
#	return "%s\n%s" % [str(tempo_to_array("primary")), str(tempo_to_array("secondary"))]

# UI

#func _on_Button_toggled(button_pressed: bool) -> void:
#	if button_pressed:
#
#		var time_input := {
#			bpm = int(bpm_text_input.text),
#			beats_per_bar = int(bar_signature.text),
#			beat_length = int(beat_signature.text)
#		}
#
#		if check_inputs(time_input):
#			set_tempo_data(time_input)
#			start_metronome()
#			btn.text = "Stop"
#		else:
#			label.text = "Please enter a correct value"
#			button_pressed = !button_pressed
#			btn.pressed = false
#			btn.text = "Start"
#	else: 
#		stop_metronome()
#		btn.text = "Start"
#
#func _on_check_measure_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.full.sound.on = button_pressed
#
#func _on_check_half_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.half.sound.on = button_pressed
#
#func _on_check_quart_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.quart.sound.on = button_pressed
#
#func _on_check_eight_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.eight.sound.on = button_pressed
#
#func _on_check_sixteenth_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.sixteenth.sound.on = button_pressed
#
#func _on_check_thirtytwo_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.thirtysecond.sound.on = button_pressed
#
#func _on_check_sixtyfourth_toggled(button_pressed: bool) -> void:
#	Metronome.subdivisions.sixtyfourth.sound.on = button_pressed
