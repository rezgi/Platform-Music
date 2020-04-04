extends "res://Metronome/Scripts/metronome.gd"

var nodes := {}
var i: GDScript

func effect(action: Dictionary, _data: Dictionary) -> void:
	if action.type == "bpm_changed": input_bpm_check(i.parse_input_bpm(nodes.input_bpm.text))


# Logic dispatchers

func input_bpm_check(parse_result: int) -> void:
	send({type = "bpm_input", value = parse_result})
	if parse_result: send({type = "enabled", value = true})
	else: send({type = "enabled", value = false})
