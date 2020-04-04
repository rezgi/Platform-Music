extends "res://Metronome/Scripts/metronome.gd"

"""
Manage Metronome UI signals.
"""

# iterate through input nodes and connect them, assign send() to each signal with procedural name and value
# use a dictionary for what input and signal to store

# button status logic still messy
# button bug when input error and put back correct values
# Where do (Apostrophe) in play and () in stop hints come from ?
# 'Enter' shortcut in inputs should confirm data and focus out, check shortcuts node option
# keyboard shortcuts (Play / Stop) don't work correctly



# put following vars in flow.data
enum btn_status {ENABLED, DISABLED, ENTERED, EXITED}

var warning_bpm := "BPM must be an integer between 1 and 320"
var warning_signature := "Bar (Bar/4) should be an integer between 1 and 64, and Beat (4/Beat) should be a power of 2"
var warning_play := "Can't play with wrong signature format. Enter correct values."

var input_is_ok := true
var new_signature := {bpm = 0, bar = 0, beat = 0}
var metronome_clics := {measure = true, beat = true, sixteen = false}
var metronome_status := {play = false, pause = false}


##	Signature Inputs

func _on_TextEditBPM_text_changed() -> void:
	send({type = "bpm_changed"})
#	var bpm := i.parse_input_bpm(input_bpm.text)
#	i.warning_message(bpm, input_bpm, icon_warning, warning_bpm)
#
#	if not bpm:
##		flow.send({type = "input_check", value = false})
##		print("print : ", flow.data)
#		input_is_ok = false
#		i.disable_play(btn_play, btn_stop, warning_play)
#	else:
#		input_is_ok = true
#		new_signature.bpm = bpm

func _on_TextEditSignature_text_changed() -> void:
	send({type = "signature_changed"})
#	var signature := i.parse_input_signature(input_signature.text)
#	i.warning_message(signature.check, input_signature, icon_warning, warning_signature)
#
#	if not signature.check:
#		input_is_ok = false
#		i.disable_play(btn_play, btn_stop, warning_play)
#	else:
#		input_is_ok = true
#		new_signature.bar = signature.bar
#		new_signature.beat = signature.beat

func _on_TextEditBPM_gui_input(event: InputEvent) -> void:
	pass
#	i.custom_controls(event, input_bpm)

func _on_TextEditBeat_gui_input(event: InputEvent) -> void:
	pass
#	i.custom_controls(event, input_signature)

##	Metronome Sound Activation

func _on_CheckBoxSoundMeasure_toggled(button_pressed: bool) -> void:
	metronome_clics.measure = button_pressed

func _on_CheckBoxSoundQuart_toggled(button_pressed: bool) -> void:
	metronome_clics.quart = button_pressed

func _on_CheckBoxSoundSixteen_toggled(button_pressed: bool) -> void:
	metronome_clics.sixteen = button_pressed

##	Metronome Start / Pause / Stop

func _on_ButtonStop_pressed() -> void:
	pass
#	if metronome_status.play: 
#		metronome_status.play = false
#		metronome_status.pause = false
#		btn_play.pressed = false
#	else: btn_stop.modulate = i.check_color(metronome_status.play, btn_status.DISABLED)

func _on_ButtonStop_mouse_entered() -> void:
	pass
#	btn_stop.modulate = i.check_color(metronome_status.play, btn_status.ENTERED)

func _on_ButtonStop_mouse_exited() -> void:
	pass
#	btn_stop.modulate = i.check_color(metronome_status.play, btn_status.EXITED)

func _on_ButtonPlay_toggled(button_pressed: bool) -> void:
	pass
#	print(btn_play.pressed)
#	if button_pressed and input_is_ok:
#		metronome_status.play = true
#		btn_stop.modulate = i.check_color(metronome_status.play, btn_status.ENABLED)
#	if not button_pressed:
#		metronome_status.pause = true
#		btn_stop.modulate = i.check_color(metronome_status.pause, btn_status.ENABLED)
#	if not input_is_ok:
#		btn_play.modulate = i.check_color(input_is_ok, btn_status.DISABLED)

func _on_ButtonPlay_mouse_entered() -> void:
	pass
#	btn_play.modulate = i.check_color(input_is_ok, btn_status.ENTERED)

func _on_ButtonPlay_mouse_exited() -> void:
	pass
#	btn_play.modulate = i.check_color(input_is_ok, btn_status.EXITED)
