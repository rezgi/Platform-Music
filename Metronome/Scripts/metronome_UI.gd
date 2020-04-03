extends Control

"""
Metronome Main Manager. Orchestrates dataflow between nodes & logic.
"""

# iterate through tree, if input, script and signal node store them
# create update / effect scripts
# create send here ?
# how to send data down the tree ?

onready var input_bpm := $Main/ContainerSignature/TextEditBPM
onready var input_signature := $Main/ContainerSignature/TextEditSignature
onready var btn_play := $Main/ContainerControls/ButtonPlay
onready var btn_stop := $Main/ContainerControls/ButtonStop
onready var icon_warning := $Main/ContainerSignature/IconWarning

onready var input := $Scripts/Inputs
onready var signals := $Scripts/Signals
onready var control := $Scripts/Controls
onready var core := $Scripts/Core


func _ready() -> void:
	pass
