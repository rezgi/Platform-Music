extends Node

# How to trigger warning message when "enabled" is false ? just action.type == "enabled" in effect ?

var input: Node
var nodes: Dictionary

func effect(action: Dictionary, _send: FuncRef, _data: Dictionary) -> void:
	if action.type == "bpm_changed": bpm_check(input.parse_bpm(nodes.input_bpm.text), _send)
	if action.type == "signature_changed": signature_check(input.parse_signature(nodes.input_signature.text), _send)

# Logic dispatchers

func bpm_check(res: int, send: FuncRef) -> void:
	send.call_func({type = "bpm_input", value = res})
	toggler(res, "enabled", send)

func signature_check(res: Dictionary, send: FuncRef) -> void:
	if res.check : send.call_func({type = "signature_input", value = {bar = res.bar, beat = res.beat}})
	toggler(res.check, "enabled", send)

func toggler(res: int, string: String, send) -> void:
	if res: send.call_func({type = string, value = true})
	else: send.call_func({type = string, value = false})
