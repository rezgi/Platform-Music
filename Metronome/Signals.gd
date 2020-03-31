extends Node

"""
Manage Metronome UI signals.
"""

onready var i := preload("res://Metronome/Inputs.gd").new()
onready var icon_warning := get_node("../../Main/ContainerSignature/IconWarning")
onready var input_bpm := get_node("../../Main/ContainerSignature/TextEditBPM")
onready var input_signature := get_node("../../Main/ContainerSignature/TextEditSignature")

var warning_bpm := "BPM must be an integer between 1 and 320"
var warning_signature := "Bar (Bar/4) should be an integer between 1 and 64, and Beat (4/Beat) should be a power of 2"
var new_signature := {}

func _on_TextEditBPM_text_changed() -> void:
	var bpm := i.parse_input_bpm(input_bpm.text)
	i.warning_message(bpm, input_bpm, icon_warning, warning_bpm)
#	if bpm: new_signature.bpm = bpm

func _on_TextEditSignature_text_changed() -> void:
	var signature := i.parse_input_signature(input_signature.text)
	i.warning_message(signature.check, input_signature, icon_warning, warning_signature)
#	if signature.check: new_signature.bar = signature.bar, new_signature.beat = signature.beat

func _on_TextEditBPM_gui_input(event: InputEvent) -> void:
	i.custom_controls(event, input_bpm)

func _on_TextEditBeat_gui_input(event: InputEvent) -> void:
	i.custom_controls(event, input_signature)
