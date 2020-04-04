extends Node

"""
Metronome Main Manager. Orchestrates dataflow between nodes & logic.
"""

var data := flow.data
var metronome := { enabled = true , bpm = 120, signature = {} }
var send_ref := funcref(self, "send")

func _ready() -> void:
	data.metronome = metronome
	$Scripts/Signals.send = send_ref
	$Scripts/Effects.input = $Scripts/Inputs
	$Scripts/Effects.nodes = {
		input_bpm = $UI/Main/ContainerSignature/TextEditBPM,
		input_signature = $UI/Main/ContainerSignature/TextEditSignature,
		btn_play = $UI/Main/ContainerControls/ButtonPlay,
		btn_stop = $UI/Main/ContainerControls/ButtonStop,
		icon_warning = $UI/Main/ContainerSignature/IconWarning 
		}

func send(action: Dictionary) -> void:
	data = $Scripts/Updates.update(action, data)
	$Scripts/Effects.effect(action, send_ref, data)
	print(data)
