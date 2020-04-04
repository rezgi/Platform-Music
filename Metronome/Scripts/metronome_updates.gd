extends Node

# see how to duplicate data without mutating it
# send signal on data state_changed ?

func update(action: Dictionary, data: Dictionary) -> Dictionary:
	var m = data.metronome
	
	if action.type == "bpm_input": m.bpm = action.value
	if action.type == "signature_input": m.signature = action.value
	if action.type == "enabled": m.enabled = action.value
	
#	print("data : ", data)
	return data
