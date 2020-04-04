extends Node

"""
Manage Metronome UI signals.
"""

# text inputs : would be better to have a signal on Enter / Tab / focus_exited
# select text on focus_entered / tab toggles between the two inputs
# button bug when input error and put back correct values
# Where do (Apostrophe) in play and () in stop hints come from ?
# keyboard shortcuts (Play / Stop) don't work correctly

#enum btn_status {ENABLED, DISABLED, ENTERED, EXITED}
#var warning_bpm := "BPM must be an integer between 1 and 320"
#var warning_signature := "Bar (Bar/4) should be an integer between 1 and 64, and Beat (4/Beat) should be a power of 2"
#var warning_play := "Can't play with wrong signature format. Enter correct values."

var send: FuncRef
var metronome_clics := {measure = true, beat = true, sixteen = false}

##	Signature Inputs

func _on_TextEditBPM_text_changed() -> void:
	send.call_func({type = "bpm_changed"})

func _on_TextEditSignature_text_changed() -> void:
	send.call_func({type = "signature_changed"})

func _on_TextEditBPM_gui_input(event: InputEvent) -> void:
	pass

func _on_TextEditBeat_gui_input(event: InputEvent) -> void:
	pass

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

func _on_ButtonStop_mouse_entered() -> void:
	pass

func _on_ButtonStop_mouse_exited() -> void:
	pass

func _on_ButtonPlay_toggled(button_pressed: bool) -> void:
	pass

func _on_ButtonPlay_mouse_entered() -> void:
	pass

func _on_ButtonPlay_mouse_exited() -> void:
	pass
