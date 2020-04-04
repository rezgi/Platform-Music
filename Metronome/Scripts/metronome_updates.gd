extends Node

#var metronome := { enabled = true , bpm = 120, signature = {} }

func update(action: Dictionary, data: Dictionary) -> Dictionary:
	var m = data.metronome
	
	if action.type == "bpm_input": m.bpm = action.value
	if action.type == "enabled": m.enabled = action.value
	
	print("data : ", data)
	return data
