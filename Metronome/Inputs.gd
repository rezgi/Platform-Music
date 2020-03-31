extends Node

"""
Utility functions for checking and parsing UI inputs.
"""

func parse_input_bpm(text) -> int:
	return 0 if int(text) > 320 or int(text) < 0 else int(text)

func parse_input_signature(text) -> Dictionary:
	var splitted = text.split("/", false, 1)
	
	if splitted.size() != 2 or text.count("/") != 1: return {"check" : false}

	var bar := int(splitted[0])
	var beat := int(splitted[1])
	var check_bar := false
	var check_beat := false
	
	if bar > 1 and bar <= 64: check_bar = true
	
	var i := 2
	while i <= 64:
		if beat == i: check_beat = true
		i *= 2

	return { "check" : true if check_bar and check_beat else false, "bar" : bar, "beat" : beat }

func warning_message(check_status, text_input, icon_warning, hint) -> void:
	if !check_status:
		text_input.set("custom_colors/font_color", Color.firebrick)
		icon_warning.visible = true
		icon_warning.hint_tooltip = hint
	else: 
		text_input.set("custom_colors/font_color", Color(0.88, 0.88, 0.88))
		icon_warning.visible = false

func custom_controls(event, text_node) -> void:
	if event is InputEventMouseButton: text_node.select_all()
	if event is InputEventKey and (event.scancode == 16777218 or event.scancode == 16777221): text_node.text = ""

