extends Node

# not mutate data and keep old state with data stamps
# make a function that triggers on data change, makes a copy and saves the time of state change

# make data structure for Metronome
# modularize & scope
# how to keep send global and use local update & effect
# need funcref ? if send is global no need to pass funcref, but not pure
# signals & callbacks ?
# put data dict in main ? will be reinitialized if left here ?

signal state_changed

var data := {}

#func check_data_state():
#	var new_data := {}
#
#var ref_send := funcref(self, "send")
#
#func send(action: Dictionary) -> void:
#	data = update(data, action)
#	effect(data, ref_send, action)
#
#func update(data: Dictionary, action: Dictionary) -> Dictionary:
#	if action.type == "init": data.started = true
#	if action.type == "test func": data.effect = str("the effect is ", action.value)
#	if action.type == "input_check": data.metronome_status = action.value
#
#	return data
#
#func effect(data: Dictionary, send: FuncRef, action: Dictionary) -> void:
#	if action.type == "init": test_func(action.value, send)
#
#func test_func(value, send):
#	send.call_func({type = "test func", value = value})
#
