extends Node

"""
Metronome Main Manager. Orchestrates dataflow between nodes & logic.
"""

# iterate through tree, if input, script and signal node store them

#var input_bpm
#var input_signature
#var btn_play
#var btn_stop
#var icon_warning

onready var e := $Scripts/Effects
onready var u := $Scripts/Updates
onready var input := $Scripts/Inputs

var data := flow.data
var metronome := { enabled = true , bpm = 120, signature = {} }

func _on_Metronome_ready() -> void:
	data.metronome = metronome
#	e = $Scripts/Effects
	e.i = input
#	u = $Scripts/Updates
	print(e,u, input, e.i)
	e.nodes = {
		input_bpm = $UI/Main/ContainerSignature/TextEditBPM,
		input_signature = $UI/Main/ContainerSignature/TextEditSignature,
		btn_play = $UI/Main/ContainerControls/ButtonPlay,
		btn_stop = $UI/Main/ContainerControls/ButtonStop,
		icon_warning = $UI/Main/ContainerSignature/IconWarning }

func send(action: Dictionary) -> void:
	data = u.update(action, data)
	e.effect(action, data)

# iterate through tree, if input, script and signal node store them

#onready var input_bpm := $UI/Main/ContainerSignature/TextEditBPM
#onready var input_signature := $UI/Main/ContainerSignature/TextEditSignature
#onready var btn_play := $UI/Main/ContainerControls/ButtonPlay
#onready var btn_stop := $UI/Main/ContainerControls/ButtonStop
#onready var icon_warning := $UI/Main/ContainerSignature/IconWarning

#onready var e := $Scripts/Effects
#onready var u := $Scripts/Updates
#onready var i := $Scripts/Inputs
#var e
#var u
#var i
#
#var data := flow.data
#var metronome := { enabled = true , bpm = 120, signature = {} }
#
#func _ready() -> void:
#	data.metronome = metronome
#	if $Scripts/Updates: print(u)
#	if e:
#		e.nodes = {
#			input_bpm = $UI/Main/ContainerSignature/TextEditBPM,
#			input_signature = $UI/Main/ContainerSignature/TextEditSignature,
#			btn_play = $UI/Main/ContainerControls/ButtonPlay,
#			btn_stop = $UI/Main/ContainerControls/ButtonStop,
#			icon_warning = $UI/Main/ContainerSignature/IconWarning }
#
#func send(action: Dictionary) -> void:
#	data = u.update(action, data)
#	e.effect(action, data)

