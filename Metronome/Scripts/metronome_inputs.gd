extends Node

"""
Utility functions for checking and parsing UI inputs.
"""

#onready var btn_play := get_node("../../Main/ContainerControls/ButtonPlay")
#
#func _init() -> void:
#	print(btn_play)
#
#func _ready() -> void:
#	print(btn_play)

func parse_input_bpm(text: String) -> int:
	return 0 if int(text) > 320 or int(text) < 0 else int(text)

func parse_input_signature(text: String) -> Dictionary:
	var splitted = text.split("/", false, 1)
	
	if splitted.size() != 2 or text.count("/") != 1: return {"check" : 0}

	var bar := int(splitted[0])
	var beat := int(splitted[1])
	var check_bar := 0
	var check_beat := 0
	
	if bar > 1 and bar <= 64: check_bar = 1
	
	var i := 2
	while i <= 64:
		if beat == i: check_beat = 1
		i *= 2

	return { "check" : 1 if check_bar and check_beat else 0, "bar" : bar, "beat" : beat }

func custom_controls(event: InputEvent, text_node: TextEdit) -> void:
	if event is InputEventMouseButton: text_node.select_all()
	if event is InputEventKey and (event.scancode == 16777218 or event.scancode == 16777221): text_node.text = ""

func warning_message(check_status: int, text_input: TextEdit, icon_warning: TextureRect, hint: String) -> void:
	if !check_status:
		text_input.set("custom_colors/font_color", Color(0.992, 0.839, 0.019))
		icon_warning.visible = true
		icon_warning.hint_tooltip = hint
	else: 
		text_input.set("custom_colors/font_color", Color(0.88, 0.88, 0.88))
		icon_warning.visible = false

func disable_play(btn_play: TextureButton, btn_stop: Button, warning_play: String) -> void:
	btn_play.modulate = Color("32ffffff")
	btn_play.hint_tooltip = warning_play
	btn_stop.hint_tooltip = warning_play
	btn_play.disabled = true
	btn_stop.disabled = true

func check_color(input_is_ok: bool, status: int) -> Color:
	match status:
		0: return Color.white
		1: return Color("32ffffff")
		2: return Color("#6a9dea") if input_is_ok else Color("32ffffff")
		3: return Color.white if input_is_ok else Color("32ffffff")
		_: return Color.red

